# Shop-Side Delivery Location Map Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Show a read-only Leaflet map with the shop's own location and the order's delivery location on both the shop bill-detail page (`HoaDonShop.jsp`) and the shop order-list page (`Quanlybill.jsp`).

**Architecture:** Pure JSP/JS changes, no Java/DAO changes — `Order.locationX/locationY` and `Shop.locationX/locationY` already exist and are already populated (`sessionScope.currentShop` is already set as `currentShop` on both pages). Each JSP embeds its own Leaflet CDN tags and a self-contained, uniquely-namespaced `<script>` block, following the existing codebase convention (no shared static JS file). Maps are read-only: no click/drag listeners, no Nominatim calls.

**Tech Stack:** Leaflet.js 1.9.4 via CDN (`unpkg.com/leaflet@1.9.4`), OpenStreetMap tiles, JSTL (`c`, `fn` taglibs — both already imported in both target files).

## Global Constraints

- Leaflet version: `1.9.4`, loaded from `https://unpkg.com/leaflet@1.9.4/dist/leaflet.css` and `https://unpkg.com/leaflet@1.9.4/dist/leaflet.js` (exact URLs — match the version already used in `diaChi.jsp`/`checkoutThanhToan.jsp`).
- Tile layer: `https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png` with attribution `© OpenStreetMap contributors`.
- Coordinate convention: `locationX` = latitude, `locationY` = longitude (i.e. `[lat, lng]` when constructing any Leaflet `L.latLng`/`L.marker`).
- Maps in this feature are **read-only**: no `click` or `dragend` listeners on markers, no search box, no Nominatim `fetch()` calls.
- All coordinate values rendered into HTML must go through `data-*` attributes wrapped in `fn:escapeXml(...)`, read in JS via `element.dataset.x` — never interpolate EL directly into inline `onclick` JS string literals (established pattern from the prior Leaflet address-map feature, reinforced by a review fix in that feature).
- Shop marker icon: `L.divIcon({ html: '🏠', className: 'shop-marker-icon', iconSize: [24, 24] })` — used identically in both files so shop markers look the same everywhere.
- JS function names per file must not collide with existing functions on that same page (`avatarBtn`/`avatarDropdown` logic already present in both files — do not rename or touch it).

---

### Task 1: `HoaDonShop.jsp` — embedded read-only map with shop + delivery markers

**Files:**
- Modify: `src/main/web/shop/HoaDonShop.jsp`

**Interfaces:**
- Consumes: `bill.order.locationX`/`bill.order.locationY` (`Double`, may be null — `Order.java` already has these), `currentShop.locationX`/`currentShop.locationY` (`Double`, may be null — `Shop.java` already has these, `currentShop` is already set at line 5 of this file via `<c:set var="currentShop" value="${sessionScope.currentShop}" scope="request"/>`).
- Produces: nothing consumed by other tasks (Task 1 and Task 2 are independent — different files).

- [ ] **Step 1: Add Leaflet CDN tags to `<head>`**

In `src/main/web/shop/HoaDonShop.jsp`, immediately after line 4 (`<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>`) and before line 5 (`<c:set var="currentShop" ...`), no change needed there — instead add the CDN tags inside `<head>`, right after the `<meta name="viewport" ...>` line (currently line 16):

Change:
```jsp
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hóa đơn #${bill.order.id} - ${not empty currentShop.shopName ? currentShop.shopName : 'Cửa hàng'}</title>
```
to:
```jsp
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
    <title>Hóa đơn #${bill.order.id} - ${not empty currentShop.shopName ? currentShop.shopName : 'Cửa hàng'}</title>
```

- [ ] **Step 2: Add the map container / fallback row after the "Địa chỉ giao hàng" row**

Find (currently line 204):
```jsp
                <div class="info-row"><span>Địa chỉ giao hàng</span><span><c:out value="${bill.order.shippingAddress}"/></span></div>
```

Change it to:
```jsp
                <div class="info-row"><span>Địa chỉ giao hàng</span><span><c:out value="${bill.order.shippingAddress}"/></span></div>
                <c:choose>
                    <c:when test="${bill.order.locationX != null && bill.order.locationY != null}">
                        <div id="shopOrderMap"
                             data-order-lat="${fn:escapeXml(bill.order.locationX)}"
                             data-order-lng="${fn:escapeXml(bill.order.locationY)}"
                             data-shop-lat="${fn:escapeXml(currentShop.locationX)}"
                             data-shop-lng="${fn:escapeXml(currentShop.locationY)}"
                             style="height:250px;border-radius:8px;margin:10px 0;"></div>
                    </c:when>
                    <c:otherwise>
                        <div class="info-row"><span>Vị trí bản đồ</span><span>Chưa có vị trí trên bản đồ</span></div>
                    </c:otherwise>
                </c:choose>
```

Note: `data-shop-lat`/`data-shop-lng` will render as the literal string `""` (empty) when `currentShop.locationX`/`locationY` are null — `fn:escapeXml("")` on a null EL value produces an empty string, which is handled by `parseFloat` + `isNaN` check in Step 3's JS.

- [ ] **Step 3: Add the map-init JS before `</body>`**

Find the existing `<script>` block near the end of the file (currently starts at line 314, right after the avatar-dropdown `<div>` closes):
```jsp
<script>
document.addEventListener('DOMContentLoaded', function() {
    var avatarBtn = document.getElementById('avatarBtn');
    var avatarDropdown = document.getElementById('avatarDropdown');
    if (avatarBtn && avatarDropdown) {
        avatarBtn.addEventListener('click', function(e) {
            e.stopPropagation();
            var rect = avatarBtn.getBoundingClientRect();
            avatarDropdown.style.top = (rect.bottom + 10) + 'px';
            avatarDropdown.style.right = (window.innerWidth - rect.right) + 'px';
            avatarDropdown.classList.toggle('open');
        });
        avatarDropdown.addEventListener('click', function(e) { e.stopPropagation(); });
        document.addEventListener('click', function() { avatarDropdown.classList.remove('open'); });
    }
});
</script></body>
```

Change it to (adding a second `document.addEventListener('DOMContentLoaded', ...)` block and the `initShopOrderMap` function, keeping the existing avatar-dropdown listener untouched):
```jsp
<script>
document.addEventListener('DOMContentLoaded', function() {
    var avatarBtn = document.getElementById('avatarBtn');
    var avatarDropdown = document.getElementById('avatarDropdown');
    if (avatarBtn && avatarDropdown) {
        avatarBtn.addEventListener('click', function(e) {
            e.stopPropagation();
            var rect = avatarBtn.getBoundingClientRect();
            avatarDropdown.style.top = (rect.bottom + 10) + 'px';
            avatarDropdown.style.right = (window.innerWidth - rect.right) + 'px';
            avatarDropdown.classList.toggle('open');
        });
        avatarDropdown.addEventListener('click', function(e) { e.stopPropagation(); });
        document.addEventListener('click', function() { avatarDropdown.classList.remove('open'); });
    }
});

function initShopOrderMap(containerId) {
    var el = document.getElementById(containerId);
    if (!el) return;
    var orderLat = parseFloat(el.dataset.orderLat);
    var orderLng = parseFloat(el.dataset.orderLng);
    if (isNaN(orderLat) || isNaN(orderLng)) return;

    var map = L.map(containerId, { zoomControl: true, dragging: true, scrollWheelZoom: false });
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: '© OpenStreetMap contributors'
    }).addTo(map);
    L.marker([orderLat, orderLng]).addTo(map);
    var bounds = L.latLngBounds([[orderLat, orderLng]]);

    var shopLat = parseFloat(el.dataset.shopLat);
    var shopLng = parseFloat(el.dataset.shopLng);
    if (!isNaN(shopLat) && !isNaN(shopLng)) {
        var shopIcon = L.divIcon({ html: '🏠', className: 'shop-marker-icon', iconSize: [24, 24] });
        L.marker([shopLat, shopLng], { icon: shopIcon }).addTo(map);
        bounds.extend([shopLat, shopLng]);
    }

    if (bounds.isValid() && bounds.getNorthEast().distanceTo(bounds.getSouthWest()) > 0) {
        map.fitBounds(bounds, { padding: [30, 30], maxZoom: 16 });
    } else {
        map.setView([orderLat, orderLng], 16);
    }
}

document.addEventListener('DOMContentLoaded', function () { initShopOrderMap('shopOrderMap'); });
</script></body>
```

- [ ] **Step 4: Compile-verify (JSP is not compiled by `javac`, but verify the whole project still compiles cleanly since no `.java` files changed)**

Run:
```bash
CP=$(find /c/Users/ADMIN/.m2 -iname "*.jar" ! -iname "*-sources.jar" | sed 's#^/c#C:#' | tr '\n' ';')
javac -encoding UTF-8 -cp "$CP" -d /tmp/dbcheck/out $(find src/main/java -name "*.java")
```
Expected: no errors (this task touches no `.java` files, so this just confirms the baseline is unaffected).

- [ ] **Step 5: Manual browser verification**

On the local dev server, as a shop account (`roleId = 2`):
1. Open a bill detail (`/shop/bills?action=view&as=modal&id=<id>` is the in-list modal — but `HoaDonShop.jsp` itself is reached via the "🧾 In hóa đơn"/print or a direct bill-detail link depending on routing; confirm via `Quanlybill.jsp`'s "🧾 Xem" link or existing navigation) for an order that has non-null `locationX`/`locationY` and where `currentShop.locationX`/`locationY` are also non-null → confirm a map renders below "Địa chỉ giao hàng" with two markers (default pin for delivery, 🏠 for shop), auto-zoomed to show both, draggable/zoomable but markers do not move.
2. Open a bill detail for an order with non-null coordinates but where the shop's own `locationX`/`locationY` are null → confirm only the delivery marker shows, no JS console errors.
3. Open a bill detail for an order with null `locationX`/`locationY` → confirm the "Chưa có vị trí trên bản đồ" row shows instead of a map, no JS console errors.

- [ ] **Step 6: Commit**

```bash
git add src/main/web/shop/HoaDonShop.jsp
git commit -m "Add read-only shop+delivery location map to HoaDonShop.jsp"
```

---

### Task 2: `Quanlybill.jsp` — per-row map modal with shop + delivery markers

**Files:**
- Modify: `src/main/web/shop/Quanlybill.jsp`

**Interfaces:**
- Consumes: `o.locationX`/`o.locationY` (`Double`, may be null, `o` is the `Order` loop variable at line 263's `<c:forEach var="o" items="${orderList}">`), `currentShop.locationX`/`currentShop.locationY` (same `currentShop` already set at line 5 of this file).
- Produces: nothing consumed by other tasks (Task 1 and Task 2 are independent).
- Note: this file already includes `<%@ include file="_invoiceModal.jspf" %>` (line 329), which already defines the CSS classes `.modal-overlay` and `.modal-box` used below (`_invoiceModal.jspf` lines 8-9) — do not redefine these classes, only reuse them by name. That included file also uses `id="invoiceModalOverlay"` — this task's new modal must use a different, non-colliding id (`orderMapModal`, as specified below).

- [ ] **Step 1: Add Leaflet CDN tags to `<head>`**

In `src/main/web/shop/Quanlybill.jsp`, find (currently line 16-17):
```jsp
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hóa đơn - ${not empty currentShop.shopName ? currentShop.shopName : 'Cửa hàng'}</title>
```
Change to:
```jsp
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
    <title>Hóa đơn - ${not empty currentShop.shopName ? currentShop.shopName : 'Cửa hàng'}</title>
```

- [ ] **Step 2: Add the "📍" button to rows that have delivery coordinates**

Find the "Thao tác" cell (currently lines 302-317):
```jsp
                                    <td style="white-space:nowrap;">
                                        <a href="${pageContext.request.contextPath}/shop/bills?action=view&as=modal&id=${o.id}" class="btn btn-primary">🧾 Xem</a>
                                        <c:if test="${fn:toUpperCase(o.staTus) == 'PENDING'}">
                                            <form method="post" action="${pageContext.request.contextPath}/shop/bills" style="display:inline;">
                                                <input type="hidden" name="action" value="confirm"/>
                                                <input type="hidden" name="orderId" value="${o.id}"/>
                                                <button type="submit" class="btn" style="background:#2ECC71;color:#fff;border:none;cursor:pointer;">✅ Xác nhận</button>
                                            </form>
                                            <form method="post" action="${pageContext.request.contextPath}/shop/bills" style="display:inline;"
                                                  onsubmit="return confirm('Hủy đơn #${o.id}?')">
                                                <input type="hidden" name="action" value="cancel"/>
                                                <input type="hidden" name="orderId" value="${o.id}"/>
                                                <button type="submit" class="btn" style="background:#E63946;color:#fff;border:none;cursor:pointer;">❌ Hủy</button>
                                            </form>
                                        </c:if>
                                    </td>
```
Change to:
```jsp
                                    <td style="white-space:nowrap;">
                                        <a href="${pageContext.request.contextPath}/shop/bills?action=view&as=modal&id=${o.id}" class="btn btn-primary">🧾 Xem</a>
                                        <c:if test="${o.locationX != null && o.locationY != null}">
                                            <button type="button" class="btn" style="background:var(--bg-input);border:1px solid var(--border);color:var(--text-muted);"
                                                    data-lat="${fn:escapeXml(o.locationX)}" data-lng="${fn:escapeXml(o.locationY)}"
                                                    onclick="openOrderMapModal(this)">📍</button>
                                        </c:if>
                                        <c:if test="${fn:toUpperCase(o.staTus) == 'PENDING'}">
                                            <form method="post" action="${pageContext.request.contextPath}/shop/bills" style="display:inline;">
                                                <input type="hidden" name="action" value="confirm"/>
                                                <input type="hidden" name="orderId" value="${o.id}"/>
                                                <button type="submit" class="btn" style="background:#2ECC71;color:#fff;border:none;cursor:pointer;">✅ Xác nhận</button>
                                            </form>
                                            <form method="post" action="${pageContext.request.contextPath}/shop/bills" style="display:inline;"
                                                  onsubmit="return confirm('Hủy đơn #${o.id}?')">
                                                <input type="hidden" name="action" value="cancel"/>
                                                <input type="hidden" name="orderId" value="${o.id}"/>
                                                <button type="submit" class="btn" style="background:#E63946;color:#fff;border:none;cursor:pointer;">❌ Hủy</button>
                                            </form>
                                        </c:if>
                                    </td>
```

- [ ] **Step 3: Add the shared map modal after the `_invoiceModal.jspf` include**

Find (currently line 329):
```jsp
<%@ include file="_invoiceModal.jspf" %>
```
Change to:
```jsp
<%@ include file="_invoiceModal.jspf" %>

<div id="orderMapModal" class="modal-overlay" style="display:none;"
     data-shop-lat="${fn:escapeXml(currentShop.locationX)}"
     data-shop-lng="${fn:escapeXml(currentShop.locationY)}"
     onclick="closeOrderMapOnBg(event)">
    <div class="modal-box" style="max-width:500px;padding:16px;" onclick="event.stopPropagation()">
        <div style="display:flex;justify-content:flex-end;margin-bottom:8px;">
            <button type="button" onclick="closeOrderMapModal()" style="border:none;background:none;font-size:18px;cursor:pointer;color:var(--text-muted);">✕</button>
        </div>
        <div id="orderMapContainer" style="height:350px;border-radius:8px;"></div>
    </div>
</div>
```

- [ ] **Step 4: Add the modal-control JS before `</body>`**

Find the existing `<script>` block near the end of the file (currently starts at line 346):
```jsp
<script>
document.addEventListener('DOMContentLoaded', function() {
    var avatarBtn = document.getElementById('avatarBtn');
    var avatarDropdown = document.getElementById('avatarDropdown');
    if (avatarBtn && avatarDropdown) {
        avatarBtn.addEventListener('click', function(e) {
            e.stopPropagation();
            var rect = avatarBtn.getBoundingClientRect();
            avatarDropdown.style.top = (rect.bottom + 10) + 'px';
            avatarDropdown.style.right = (window.innerWidth - rect.right) + 'px';
            avatarDropdown.classList.toggle('open');
        });
        avatarDropdown.addEventListener('click', function(e) { e.stopPropagation(); });
        document.addEventListener('click', function() { avatarDropdown.classList.remove('open'); });
    }
});
</script></body>
```
Change to (adding the map-modal functions, keeping the existing avatar-dropdown listener untouched):
```jsp
<script>
document.addEventListener('DOMContentLoaded', function() {
    var avatarBtn = document.getElementById('avatarBtn');
    var avatarDropdown = document.getElementById('avatarDropdown');
    if (avatarBtn && avatarDropdown) {
        avatarBtn.addEventListener('click', function(e) {
            e.stopPropagation();
            var rect = avatarBtn.getBoundingClientRect();
            avatarDropdown.style.top = (rect.bottom + 10) + 'px';
            avatarDropdown.style.right = (window.innerWidth - rect.right) + 'px';
            avatarDropdown.classList.toggle('open');
        });
        avatarDropdown.addEventListener('click', function(e) { e.stopPropagation(); });
        document.addEventListener('click', function() { avatarDropdown.classList.remove('open'); });
    }
});

var orderMap = null;
function openOrderMapModal(btn) {
    var lat = parseFloat(btn.dataset.lat);
    var lng = parseFloat(btn.dataset.lng);
    var modalEl = document.getElementById('orderMapModal');
    modalEl.style.display = 'flex';
    if (orderMap) { orderMap.remove(); orderMap = null; }
    orderMap = L.map('orderMapContainer', { scrollWheelZoom: false });
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: '© OpenStreetMap contributors'
    }).addTo(orderMap);
    L.marker([lat, lng]).addTo(orderMap);
    var bounds = L.latLngBounds([[lat, lng]]);

    var shopLat = parseFloat(modalEl.dataset.shopLat);
    var shopLng = parseFloat(modalEl.dataset.shopLng);
    if (!isNaN(shopLat) && !isNaN(shopLng)) {
        var shopIcon = L.divIcon({ html: '🏠', className: 'shop-marker-icon', iconSize: [24, 24] });
        L.marker([shopLat, shopLng], { icon: shopIcon }).addTo(orderMap);
        bounds.extend([shopLat, shopLng]);
    }

    setTimeout(function () {
        orderMap.invalidateSize();
        if (bounds.isValid() && bounds.getNorthEast().distanceTo(bounds.getSouthWest()) > 0) {
            orderMap.fitBounds(bounds, { padding: [30, 30], maxZoom: 16 });
        } else {
            orderMap.setView([lat, lng], 16);
        }
    }, 50);
}
function closeOrderMapModal() {
    document.getElementById('orderMapModal').style.display = 'none';
    if (orderMap) { orderMap.remove(); orderMap = null; }
}
function closeOrderMapOnBg(e) {
    if (e.target.id === 'orderMapModal') closeOrderMapModal();
}
</script></body>
```

- [ ] **Step 5: Compile-verify**

Run:
```bash
CP=$(find /c/Users/ADMIN/.m2 -iname "*.jar" ! -iname "*-sources.jar" | sed 's#^/c#C:#' | tr '\n' ';')
javac -encoding UTF-8 -cp "$CP" -d /tmp/dbcheck/out $(find src/main/java -name "*.java")
```
Expected: no errors (this task touches no `.java` files).

- [ ] **Step 6: Manual browser verification**

On the local dev server, as a shop account (`roleId = 2`), on `/shop/bills`:
1. Confirm rows for orders with non-null `locationX`/`locationY` show the "📍" button, and rows without it do not.
2. Click "📍" on an order → modal opens, map shows both delivery marker and 🏠 shop marker (assuming shop has coordinates), auto-fit to show both, no gray/broken tiles.
3. Close the modal (✕ button and by clicking the dark background outside the box) → both close it.
4. Click "📍" on a different order right after closing → map re-renders correctly at the new order's coordinates (no "Map container is already initialized" error in console).
5. If the shop's own `locationX`/`locationY` are null, confirm only the delivery marker shows, no JS errors.

- [ ] **Step 7: Commit**

```bash
git add src/main/web/shop/Quanlybill.jsp
git commit -m "Add read-only shop+delivery location map modal to Quanlybill.jsp"
```

---

### Task 3: Update `CRUD_DA_LAM.md` and `PROJECT_STRUCTURE.md`

**Files:**
- Modify: `CRUD_DA_LAM.md`
- Modify: `PROJECT_STRUCTURE.md`

**Interfaces:**
- Consumes: nothing (documentation only, describes the finished feature from Tasks 1-2).
- Produces: nothing.

- [ ] **Step 1: Add a new section to `CRUD_DA_LAM.md`**

Read the file first to find its next available section number (the prior Leaflet address-map feature added "section 22" per the ledger from that feature — read the file's current last section number and use the next one). Append a new section describing:
- Feature name: "Xem vị trí giao hàng trên bản đồ (phía shop)".
- Scope: `HoaDonShop.jsp` (trang chi tiết hóa đơn) và `Quanlybill.jsp` (trang danh sách đơn hàng, qua modal).
- Data source: `Orders.locationX`/`locationY` (đã lưu từ tính năng Leaflet address map trước đó) và `Shop.locationX`/`locationY` (đã có sẵn từ trước, chưa từng hiển thị ở đâu) — cả 2 trang đọc `sessionScope.currentShop` đã có sẵn để lấy tọa độ shop, không cần truy vấn thêm.
- Behavior: chỉ đọc (read-only), không cho sửa vị trí; ẩn bản đồ/nút nếu thiếu tọa độ đơn hàng; ẩn marker shop nếu thiếu tọa độ shop.
- Tech: tái sử dụng Leaflet.js 1.9.4 CDN + OpenStreetMap tile, không có thay đổi Model/DAO nào.

- [ ] **Step 2: Update `PROJECT_STRUCTURE.md`**

Read the file first to find the existing rows/descriptions for `HoaDonShop.jsp` and `Quanlybill.jsp` (or the `shop/` directory listing). Update their descriptions to mention they now embed a read-only Leaflet location map (shop + delivery marker) — matching the level of detail already used for the `checkoutThanhToan.jsp` entry added by the prior feature's Task 10.

- [ ] **Step 3: Commit**

```bash
git add CRUD_DA_LAM.md PROJECT_STRUCTURE.md
git commit -m "Document shop-side delivery location map feature in CRUD_DA_LAM.md and PROJECT_STRUCTURE.md"
```
