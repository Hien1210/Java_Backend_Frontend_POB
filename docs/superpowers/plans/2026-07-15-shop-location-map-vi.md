# Kế hoạch triển khai: Bản đồ vị trí giao hàng phía shop

> **Bản dịch tiếng Việt** của [2026-07-15-shop-location-map.md](2026-07-15-shop-location-map.md) — bản tiếng Anh là bản gốc dùng để thực thi (skill `subagent-driven-development`/`executing-plans`), file này chỉ để tham khảo/đọc hiểu. Các đoạn code/lệnh giữ nguyên không dịch.

**Mục tiêu:** Hiển thị bản đồ Leaflet chỉ-đọc (read-only) gồm vị trí của shop và vị trí giao hàng của đơn hàng, ở cả trang chi tiết hóa đơn (`HoaDonShop.jsp`) lẫn trang danh sách đơn hàng (`Quanlybill.jsp`) của shop.

**Kiến trúc:** Chỉ thay đổi JSP/JS thuần, không đổi Java/DAO — `Order.locationX/locationY` và `Shop.locationX/locationY` đã có sẵn và đã được nạp dữ liệu (`sessionScope.currentShop` đã được set thành `currentShop` ở cả 2 trang). Mỗi JSP tự nhúng Leaflet CDN riêng và 1 khối `<script>` tự chứa, namespace hàm riêng biệt — đúng theo convention hiện có của codebase (không dùng file JS tĩnh dùng chung). Bản đồ chỉ đọc: không có listener click/kéo, không gọi Nominatim.

**Công nghệ:** Leaflet.js 1.9.4 qua CDN (`unpkg.com/leaflet@1.9.4`), tile OpenStreetMap, JSTL (taglib `c`, `fn` — cả 2 file đích đều đã import sẵn).

## Ràng buộc chung (Global Constraints)

- Phiên bản Leaflet: `1.9.4`, nạp từ `https://unpkg.com/leaflet@1.9.4/dist/leaflet.css` và `https://unpkg.com/leaflet@1.9.4/dist/leaflet.js` (đúng URL — khớp phiên bản đã dùng ở `diaChi.jsp`/`checkoutThanhToan.jsp`).
- Tile layer: `https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png` kèm attribution `© OpenStreetMap contributors`.
- Quy ước tọa độ: `locationX` = latitude, `locationY` = longitude (tức `[lat, lng]` khi tạo bất kỳ `L.latLng`/`L.marker` nào của Leaflet).
- Bản đồ trong tính năng này **chỉ đọc**: không gắn listener `click` hay `dragend` lên marker, không có ô tìm kiếm, không gọi `fetch()` tới Nominatim.
- Mọi giá trị tọa độ render ra HTML phải đi qua thuộc tính `data-*` được bọc trong `fn:escapeXml(...)`, đọc lại trong JS qua `element.dataset.x` — tuyệt đối không nhúng EL trực tiếp vào chuỗi JS trong `onclick` (pattern đã chốt từ tính năng Leaflet address-map trước đó, và đã được củng cố qua 1 lần sửa lỗi ở review cuối của tính năng đó).
- Icon marker shop: `L.divIcon({ html: '🏠', className: 'shop-marker-icon', iconSize: [24, 24] })` — dùng giống hệt ở cả 2 file để marker shop trông nhất quán ở mọi nơi.
- Tên hàm JS trong mỗi file không được trùng với hàm đã có sẵn trên cùng trang đó (logic `avatarBtn`/`avatarDropdown` đã có sẵn ở cả 2 file — không đổi tên hay đụng vào).

---

### Task 1: `HoaDonShop.jsp` — nhúng bản đồ chỉ-đọc với marker shop + marker giao hàng

**Files:**
- Sửa: `src/main/web/shop/HoaDonShop.jsp`

**Interfaces:**
- Tiêu thụ (Consumes): `bill.order.locationX`/`bill.order.locationY` (kiểu `Double`, có thể null — `Order.java` đã có sẵn field này), `currentShop.locationX`/`currentShop.locationY` (kiểu `Double`, có thể null — `Shop.java` đã có sẵn field này, `currentShop` đã được set ở dòng 5 của file này qua `<c:set var="currentShop" value="${sessionScope.currentShop}" scope="request"/>`).
- Tạo ra (Produces): không có gì được task khác tiêu thụ (Task 1 và Task 2 độc lập — khác file).

- [ ] **Bước 1: Thêm thẻ CDN Leaflet vào `<head>`**

Trong `src/main/web/shop/HoaDonShop.jsp`, ngay sau dòng 4 (`<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>`) và trước dòng 5 (`<c:set var="currentShop" ...`) — không cần sửa ở đó; thay vào đó thêm thẻ CDN vào trong `<head>`, ngay sau dòng `<meta name="viewport" ...>` (hiện đang là dòng 16):

Đổi:
```jsp
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hóa đơn #${bill.order.id} - ${not empty currentShop.shopName ? currentShop.shopName : 'Cửa hàng'}</title>
```
thành:
```jsp
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
    <title>Hóa đơn #${bill.order.id} - ${not empty currentShop.shopName ? currentShop.shopName : 'Cửa hàng'}</title>
```

- [ ] **Bước 2: Thêm khung bản đồ / dòng dự phòng ngay sau dòng "Địa chỉ giao hàng"**

Tìm (hiện đang là dòng 204):
```jsp
                <div class="info-row"><span>Địa chỉ giao hàng</span><span><c:out value="${bill.order.shippingAddress}"/></span></div>
```

Đổi thành:
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

Lưu ý: `data-shop-lat`/`data-shop-lng` sẽ render ra chuỗi rỗng `""` khi `currentShop.locationX`/`locationY` là null — `fn:escapeXml("")` trên giá trị EL null cho ra chuỗi rỗng, được xử lý bằng `parseFloat` + kiểm tra `isNaN` trong đoạn JS ở Bước 3.

- [ ] **Bước 3: Thêm JS khởi tạo bản đồ trước `</body>`**

Tìm khối `<script>` đã có ở cuối file (hiện bắt đầu từ dòng 314, ngay sau `<div>` avatar-dropdown đóng lại):
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

Đổi thành (thêm 1 khối `document.addEventListener('DOMContentLoaded', ...)` thứ hai và hàm `initShopOrderMap`, giữ nguyên listener avatar-dropdown hiện có):
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

- [ ] **Bước 4: Xác minh biên dịch** (JSP không được `javac` biên dịch, nhưng vẫn xác nhận toàn project vẫn compile sạch vì không có file `.java` nào thay đổi)

Chạy:
```bash
CP=$(find /c/Users/ADMIN/.m2 -iname "*.jar" ! -iname "*-sources.jar" | sed 's#^/c#C:#' | tr '\n' ';')
javac -encoding UTF-8 -cp "$CP" -d /tmp/dbcheck/out $(find src/main/java -name "*.java")
```
Kỳ vọng: không lỗi (task này không đụng file `.java` nào, nên bước này chỉ xác nhận baseline không bị ảnh hưởng).

- [ ] **Bước 5: Kiểm thử thủ công trên trình duyệt**

Trên dev server local, đăng nhập bằng tài khoản shop (`roleId = 2`):
1. Mở chi tiết 1 hóa đơn (đường vào `HoaDonShop.jsp` có thể qua link "🧾 Xem" ở `Quanlybill.jsp` hoặc điều hướng trực tiếp — xác nhận theo routing hiện có) cho đơn có `locationX`/`locationY` khác null và `currentShop.locationX`/`locationY` cũng khác null → xác nhận bản đồ hiện ra dưới dòng "Địa chỉ giao hàng" với 2 marker (marker mặc định cho điểm giao hàng, 🏠 cho shop), tự động zoom để thấy cả 2, kéo/zoom được nhưng marker không di chuyển.
2. Mở chi tiết đơn có tọa độ khác null nhưng shop chưa có tọa độ (`locationX`/`locationY` của shop là null) → xác nhận chỉ marker giao hàng hiện ra, không lỗi JS console.
3. Mở chi tiết đơn có `locationX`/`locationY` null → xác nhận dòng "Chưa có vị trí trên bản đồ" hiện ra thay vì bản đồ, không lỗi JS console.

- [ ] **Bước 6: Commit**

```bash
git add src/main/web/shop/HoaDonShop.jsp
git commit -m "Add read-only shop+delivery location map to HoaDonShop.jsp"
```

---

### Task 2: `Quanlybill.jsp` — modal bản đồ theo từng dòng, có marker shop + marker giao hàng

**Files:**
- Sửa: `src/main/web/shop/Quanlybill.jsp`

**Interfaces:**
- Tiêu thụ: `o.locationX`/`o.locationY` (kiểu `Double`, có thể null, `o` là biến vòng lặp `Order` tại `<c:forEach var="o" items="${orderList}">` dòng 263), `currentShop.locationX`/`currentShop.locationY` (cùng biến `currentShop` đã set ở dòng 5 file này).
- Tạo ra: không có gì được task khác tiêu thụ (Task 1 và Task 2 độc lập).
- Lưu ý: file này đã có sẵn `<%@ include file="_invoiceModal.jspf" %>` (dòng 329), file này đã định nghĩa sẵn class CSS `.modal-overlay` và `.modal-box` dùng bên dưới (`_invoiceModal.jspf` dòng 8-9) — không định nghĩa lại các class này, chỉ tái sử dụng theo tên. File include đó cũng dùng `id="invoiceModalOverlay"` — modal mới của task này phải dùng id khác, không trùng (`orderMapModal`, như quy định bên dưới).

- [ ] **Bước 1: Thêm thẻ CDN Leaflet vào `<head>`**

Trong `src/main/web/shop/Quanlybill.jsp`, tìm (hiện đang là dòng 16-17):
```jsp
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hóa đơn - ${not empty currentShop.shopName ? currentShop.shopName : 'Cửa hàng'}</title>
```
Đổi thành:
```jsp
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
    <title>Hóa đơn - ${not empty currentShop.shopName ? currentShop.shopName : 'Cửa hàng'}</title>
```

- [ ] **Bước 2: Thêm nút "📍" vào các dòng có tọa độ giao hàng**

Tìm ô "Thao tác" (hiện đang là dòng 302-317):
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
Đổi thành:
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

- [ ] **Bước 3: Thêm modal bản đồ dùng chung sau đoạn include `_invoiceModal.jspf`**

Tìm (hiện đang là dòng 329):
```jsp
<%@ include file="_invoiceModal.jspf" %>
```
Đổi thành:
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

- [ ] **Bước 4: Thêm JS điều khiển modal trước `</body>`**

Tìm khối `<script>` đã có ở cuối file (hiện bắt đầu từ dòng 346):
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
Đổi thành (thêm các hàm điều khiển modal bản đồ, giữ nguyên listener avatar-dropdown hiện có):
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

- [ ] **Bước 5: Xác minh biên dịch**

Chạy:
```bash
CP=$(find /c/Users/ADMIN/.m2 -iname "*.jar" ! -iname "*-sources.jar" | sed 's#^/c#C:#' | tr '\n' ';')
javac -encoding UTF-8 -cp "$CP" -d /tmp/dbcheck/out $(find src/main/java -name "*.java")
```
Kỳ vọng: không lỗi (task này không đụng file `.java` nào).

- [ ] **Bước 6: Kiểm thử thủ công trên trình duyệt**

Trên dev server local, đăng nhập bằng tài khoản shop (`roleId = 2`), tại `/shop/bills`:
1. Xác nhận các dòng có `locationX`/`locationY` khác null hiện nút "📍", dòng không có thì không hiện.
2. Bấm "📍" trên 1 đơn → modal mở, bản đồ hiện cả marker giao hàng lẫn marker 🏠 shop (nếu shop có tọa độ), tự động fit để thấy cả 2, không bị xám/vỡ tile.
3. Đóng modal (nút ✕ và bấm vào nền tối bên ngoài khung) → cả 2 cách đều đóng được.
4. Bấm "📍" trên 1 đơn khác ngay sau khi vừa đóng → bản đồ render lại đúng tại tọa độ đơn mới (không lỗi "Map container is already initialized" trong console).
5. Nếu shop chưa có tọa độ riêng (`locationX`/`locationY` null), xác nhận chỉ marker giao hàng hiện ra, không lỗi JS.

- [ ] **Bước 7: Commit**

```bash
git add src/main/web/shop/Quanlybill.jsp
git commit -m "Add read-only shop+delivery location map modal to Quanlybill.jsp"
```

---

### Task 3: Cập nhật `CRUD_DA_LAM.md` và `PROJECT_STRUCTURE.md`

**Files:**
- Sửa: `CRUD_DA_LAM.md`
- Sửa: `PROJECT_STRUCTURE.md`

**Interfaces:**
- Tiêu thụ: không có (chỉ là tài liệu, mô tả tính năng đã hoàn thành ở Task 1-2).
- Tạo ra: không có.

- [ ] **Bước 1: Thêm mục mới vào `CRUD_DA_LAM.md`**

Đọc file trước để tìm số mục tiếp theo còn trống (tính năng Leaflet address-map trước đó đã thêm "mục 22" theo ledger của tính năng đó — đọc số mục cuối cùng hiện tại của file và dùng số kế tiếp). Thêm 1 mục mới mô tả:
- Tên tính năng: "Xem vị trí giao hàng trên bản đồ (phía shop)".
- Phạm vi: `HoaDonShop.jsp` (trang chi tiết hóa đơn) và `Quanlybill.jsp` (trang danh sách đơn hàng, qua modal).
- Nguồn dữ liệu: `Orders.locationX`/`locationY` (đã lưu từ tính năng Leaflet address map trước đó) và `Shop.locationX`/`locationY` (đã có sẵn từ trước, chưa từng hiển thị ở đâu) — cả 2 trang đọc `sessionScope.currentShop` đã có sẵn để lấy tọa độ shop, không cần truy vấn thêm.
- Hành vi: chỉ đọc (read-only), không cho sửa vị trí; ẩn bản đồ/nút nếu thiếu tọa độ đơn hàng; ẩn marker shop nếu thiếu tọa độ shop.
- Công nghệ: tái sử dụng Leaflet.js 1.9.4 CDN + OpenStreetMap tile, không có thay đổi Model/DAO nào.

- [ ] **Bước 2: Cập nhật `PROJECT_STRUCTURE.md`**

Đọc file trước để tìm dòng/mô tả hiện có của `HoaDonShop.jsp` và `Quanlybill.jsp` (hoặc mục liệt kê thư mục `shop/`). Cập nhật mô tả để ghi rõ 2 file này nay đã nhúng bản đồ vị trí Leaflet chỉ-đọc (marker shop + marker giao hàng) — cùng mức chi tiết như mục `checkoutThanhToan.jsp` đã được thêm ở Task 10 của tính năng trước.

- [ ] **Bước 3: Commit**

```bash
git add CRUD_DA_LAM.md PROJECT_STRUCTURE.md
git commit -m "Document shop-side delivery location map feature in CRUD_DA_LAM.md and PROJECT_STRUCTURE.md"
```
