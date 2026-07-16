# Shop Profile Location Picker Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Let a shop set its own delivery-map location (`Shops.locationX`/`locationY`) via an editable Leaflet map picker on the "Thông tin cửa hàng" page (`/shop/profile`, `Shopprofile.jsp`), and actually wire those columns through the DAO/servlet layer that currently silently drops them.

**Architecture:** Three layers, bottom-up: (1) `ShopDAOImpl` gains read/write support for the `locationX`/`locationY` columns it currently ignores; (2) `ShopProfileServlet` parses the new optional form params and sets them on the `Shop` before persisting; (3) `Shopprofile.jsp` gets a new optional map-picker field inside its existing edit form, reusing the `diaChi.jsp` Leaflet interaction pattern (click/drag pin + Nominatim search), scoped to this page's own function names.

**Tech Stack:** Leaflet.js 1.9.4 via CDN (`unpkg.com/leaflet@1.9.4`), OpenStreetMap tiles + Nominatim, JSTL (`c`, `fn` taglibs — both already imported in `Shopprofile.jsp`), plain JDBC (`java.sql.*`, already imported in `ShopDAOImpl`).

## Global Constraints

- Leaflet version: `1.9.4`, loaded from `https://unpkg.com/leaflet@1.9.4/dist/leaflet.css` and `https://unpkg.com/leaflet@1.9.4/dist/leaflet.js` (exact URLs, matching every other Leaflet usage in this codebase).
- Tile layer: `https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png` with attribution `&copy; OpenStreetMap contributors`.
- Coordinate convention: `locationX` = latitude, `locationY` = longitude (i.e. `[lat, lng]` when constructing any Leaflet `L.latLng`/`L.marker`). Same convention as `Order`/`UserAddress`.
- Fallback map center when no coordinates exist yet: `21.0285, 105.8542` (Hà Nội) — same default used in `diaChi.jsp`.
- The `Shops` table's location columns are named `locationX`/`locationY` (camelCase — unlike every other column on that table, which is snake_case). Use those exact column names in SQL.
- **This field is optional.** Do not add `required` to the hidden lat/lng inputs, and do not block form submission if they're empty — unlike `diaChi.jsp`'s address creation, which requires coordinates.
- All coordinate values rendered into HTML must go through `data-*` attributes wrapped in `fn:escapeXml(...)`, never interpolated directly into inline `onclick` JS string literals (established convention from the prior Leaflet features in this codebase).
- Nullable `Double` → JDBC pattern already established in `UserAddressDAOImpl.java:57-66`: `if (x != null) { ps.setDouble(idx, x); } else { ps.setNull(idx, java.sql.Types.DECIMAL); }`.
- Reading a nullable numeric column back out: `rs.getObject("colName", Double.class)` (established in `UserAddressDAOImpl.java:152-153`).

---

### Task 1: `ShopDAOImpl` — read and persist `locationX`/`locationY`

**Files:**
- Modify: `src/main/java/org/example/daos/ShopDAOImpl.java`

**Interfaces:**
- Consumes: `Shop.getLocationX()/getLocationY()` (already exist on the model), `Shop.setLocationX(Double)/setLocationY(Double)` (already exist).
- Produces: `ShopDAOImpl.mapResultSetToShop()` now populates `locationX`/`locationY` on every `Shop` it returns (used by every DAO read method — `selectShopByOwnerId`, `selectShopById`, `selectAllShops`, `selectPendingShops`). `ShopDAOImpl.updateShop(Shop)` now persists `locationX`/`locationY` to the DB. Task 2 relies on `updateShop` actually saving these two fields.

- [ ] **Step 1: Read `locationX`/`locationY` in `mapResultSetToShop`**

In `src/main/java/org/example/daos/ShopDAOImpl.java`, find `mapResultSetToShop` (starts at line 235). Change:
```java
        shop.setClientKey(rs.getString("client_key"));
        shop.setApiKey(rs.getString("api_key"));
        shop.setCheckSumKey(rs.getString("check_sum_key"));

        // Xử lý các cột thời gian dạng DATETIME2
```
to:
```java
        shop.setClientKey(rs.getString("client_key"));
        shop.setApiKey(rs.getString("api_key"));
        shop.setCheckSumKey(rs.getString("check_sum_key"));
        shop.setLocationX(rs.getObject("locationX", Double.class));
        shop.setLocationY(rs.getObject("locationY", Double.class));

        // Xử lý các cột thời gian dạng DATETIME2
```

- [ ] **Step 2: Add `locationX`/`locationY` to the `UPDATE` statement**

In the same file, change the `UPDATE` constant (line 22) from:
```java
    private static final String UPDATE = "UPDATE Shops SET owner_id = ?, shop_name = ?, shop_description = ?, shop_address = ?, shop_phone = ?, shop_logo = ?, status = ?, rejection_reason = ?, approved_by = ?, approved_at = ?, client_key = ?, api_key = ?, check_sum_key = ?, updated_at = GETDATE() WHERE id = ?";
```
to:
```java
    private static final String UPDATE = "UPDATE Shops SET owner_id = ?, shop_name = ?, shop_description = ?, shop_address = ?, shop_phone = ?, shop_logo = ?, status = ?, rejection_reason = ?, approved_by = ?, approved_at = ?, client_key = ?, api_key = ?, check_sum_key = ?, locationX = ?, locationY = ?, updated_at = GETDATE() WHERE id = ?";
```

- [ ] **Step 3: Bind the two new parameters and shift the `WHERE id` index**

In `updateShop` (starts at line 125), change:
```java
            ps.setString(11, shop.getClientKey());
            ps.setString(12, shop.getApiKey());
            ps.setString(13, shop.getCheckSumKey());
            ps.setLong(14, shop.getId()); // ID de tim ban ghi can update

            ps.executeUpdate();
```
to:
```java
            ps.setString(11, shop.getClientKey());
            ps.setString(12, shop.getApiKey());
            ps.setString(13, shop.getCheckSumKey());
            if (shop.getLocationX() != null) {
                ps.setDouble(14, shop.getLocationX());
            } else {
                ps.setNull(14, Types.DECIMAL);
            }
            if (shop.getLocationY() != null) {
                ps.setDouble(15, shop.getLocationY());
            } else {
                ps.setNull(15, Types.DECIMAL);
            }
            ps.setLong(16, shop.getId()); // ID de tim ban ghi can update

            ps.executeUpdate();
```

(`Types` is already available via the existing `import java.sql.*;` at the top of the file — no import changes needed.)

- [ ] **Step 4: Compile-verify**

Run:
```bash
CP=$(find /c/Users/ADMIN/.m2 -iname "*.jar" ! -iname "*-sources.jar" | sed 's#^/c#C:#' | tr '\n' ';')
javac -encoding UTF-8 -cp "$CP" -d /tmp/dbcheck/out $(find src/main/java -name "*.java")
```
Expected: no errors.

- [ ] **Step 5: Commit**

```bash
git add src/main/java/org/example/daos/ShopDAOImpl.java
git commit -m "Wire Shops.locationX/locationY through ShopDAOImpl read/update"
```

---

### Task 2: `ShopProfileServlet` — accept optional `shopLocationX`/`shopLocationY`

**Files:**
- Modify: `src/main/java/org/example/controllers/ShopProfileServlet.java`

**Interfaces:**
- Consumes: `Shop.setLocationX(Double)/setLocationY(Double)` (existing model setters), `ShopDAOImpl.updateShop(Shop)` now persisting these fields (Task 1).
- Produces: request params `shopLocationX`/`shopLocationY` (optional, blank-tolerant `String`) consumed by Task 3's JSP form (hidden inputs of the same names). On the validation-failure re-render path, `formShop.getLocationX()/getLocationY()` are set so Task 3's map pre-fill (`formShop.locationX`/`formShop.locationY`) doesn't silently lose a picked location.

- [ ] **Step 1: Add a blank-tolerant Double parser**

In `src/main/java/org/example/controllers/ShopProfileServlet.java`, add this private method right after `normalize` (after line 127, before the closing `}` of the class at line 128):
```java
    private Double parseDoubleOrNull(String value) {
        try {
            String normalized = normalize(value);
            return normalized.isEmpty() ? null : Double.parseDouble(normalized);
        } catch (Exception e) {
            return null;
        }
    }
```

- [ ] **Step 2: Read the new params in `doPost` and set them on the validation-failure `formShop`**

Change:
```java
        String shopName = normalize(req.getParameter("shopName"));
        String shopDescription = normalize(req.getParameter("shopDescription"));
        String shopAddress = normalize(req.getParameter("shopAddress"));
        String shopPhone = normalize(req.getParameter("shopPhone"));
        String shopLogo = normalize(req.getParameter("shopLogo"));
        String clientKey = normalize(req.getParameter("clientKey"));
        String apiKey = normalize(req.getParameter("apiKey"));
        String checkSumKey = normalize(req.getParameter("checkSumKey"));

        if (shopName.isEmpty() || shopAddress.isEmpty() || shopPhone.isEmpty()) {
            req.setAttribute("loi", "Tên cửa hàng, địa chỉ và số điện thoại không được để trống!");
            Shop formShop = new Shop();
            formShop.setShopName(shopName);
            formShop.setShopDescription(shopDescription);
            formShop.setShopAddress(shopAddress);
            formShop.setShopPhone(shopPhone);
            formShop.setShopLogo(shopLogo);
            formShop.setClientKey(clientKey);
            formShop.setApiKey(apiKey);
            formShop.setCheckSumKey(checkSumKey);
            req.setAttribute("shopForm", formShop);
            req.getRequestDispatcher(VIEW).forward(req, resp);
            return;
        }
```
to:
```java
        String shopName = normalize(req.getParameter("shopName"));
        String shopDescription = normalize(req.getParameter("shopDescription"));
        String shopAddress = normalize(req.getParameter("shopAddress"));
        String shopPhone = normalize(req.getParameter("shopPhone"));
        String shopLogo = normalize(req.getParameter("shopLogo"));
        String clientKey = normalize(req.getParameter("clientKey"));
        String apiKey = normalize(req.getParameter("apiKey"));
        String checkSumKey = normalize(req.getParameter("checkSumKey"));
        Double shopLocationX = parseDoubleOrNull(req.getParameter("shopLocationX"));
        Double shopLocationY = parseDoubleOrNull(req.getParameter("shopLocationY"));

        if (shopName.isEmpty() || shopAddress.isEmpty() || shopPhone.isEmpty()) {
            req.setAttribute("loi", "Tên cửa hàng, địa chỉ và số điện thoại không được để trống!");
            Shop formShop = new Shop();
            formShop.setShopName(shopName);
            formShop.setShopDescription(shopDescription);
            formShop.setShopAddress(shopAddress);
            formShop.setShopPhone(shopPhone);
            formShop.setShopLogo(shopLogo);
            formShop.setClientKey(clientKey);
            formShop.setApiKey(apiKey);
            formShop.setCheckSumKey(checkSumKey);
            formShop.setLocationX(shopLocationX);
            formShop.setLocationY(shopLocationY);
            req.setAttribute("shopForm", formShop);
            req.getRequestDispatcher(VIEW).forward(req, resp);
            return;
        }
```

- [ ] **Step 3: Set the coordinates on `shop` before saving**

Change:
```java
        // Chỉ cập nhật các trường hồ sơ + thông tin thanh toán (Client ID/API Key/Checksum Key), giữ nguyên trạng thái duyệt / owner.
        shop.setShopName(shopName);
        shop.setShopDescription(shopDescription);
        shop.setShopAddress(shopAddress);
        shop.setShopPhone(shopPhone);
        shop.setShopLogo(shopLogo);
        shop.setClientKey(clientKey);
        shop.setApiKey(apiKey);
        shop.setCheckSumKey(checkSumKey);

        shopDAO.updateShop(shop);
```
to:
```java
        // Chỉ cập nhật các trường hồ sơ + thông tin thanh toán (Client ID/API Key/Checksum Key), giữ nguyên trạng thái duyệt / owner.
        shop.setShopName(shopName);
        shop.setShopDescription(shopDescription);
        shop.setShopAddress(shopAddress);
        shop.setShopPhone(shopPhone);
        shop.setShopLogo(shopLogo);
        shop.setClientKey(clientKey);
        shop.setApiKey(apiKey);
        shop.setCheckSumKey(checkSumKey);
        shop.setLocationX(shopLocationX);
        shop.setLocationY(shopLocationY);

        shopDAO.updateShop(shop);
```

- [ ] **Step 4: Compile-verify**

Run the standard command from Global Constraints (Task 1, Step 4). Expected: no errors.

- [ ] **Step 5: Commit**

```bash
git add src/main/java/org/example/controllers/ShopProfileServlet.java
git commit -m "Accept optional shopLocationX/shopLocationY on shop profile save"
```

---

### Task 3: `Shopprofile.jsp` — editable location-picker map in the edit form

**Files:**
- Modify: `src/main/web/shop/Shopprofile.jsp`

**Interfaces:**
- Consumes: `formShop.locationX`/`formShop.locationY` (Double, may be null — already exposed via `<c:set var="formShop" value="${not empty shopForm ? shopForm : currentShop}"/>` at line 231, and now genuinely populated thanks to Task 1 + Task 2). Submits hidden inputs `shopLocationX`/`shopLocationY` consumed by Task 2's servlet.
- Produces: nothing consumed by other tasks (last JSP-only task).

- [ ] **Step 1: Add Leaflet CDN tags to `<head>`**

Change:
```jsp
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thông tin cửa hàng - ${not empty currentShop.shopName ? currentShop.shopName : 'Cửa hàng'}</title>
```
to:
```jsp
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
    <title>Thông tin cửa hàng - ${not empty currentShop.shopName ? currentShop.shopName : 'Cửa hàng'}</title>
```

- [ ] **Step 2: Insert the map-picker form field between "Địa chỉ" and "Số điện thoại"**

Change:
```jsp
                            <div class="form-group form-full">
                                <label for="shopAddress">Địa chỉ <span class="req">*</span></label>
                                <input type="text" id="shopAddress" name="shopAddress" class="form-control"
                                       value="${fn:escapeXml(formShop.shopAddress)}"
                                       placeholder="Số nhà, đường, quận/huyện, tỉnh/thành..."
                                       required>
                            </div>

                            <div class="form-group">
                                <label for="shopPhone">Số điện thoại <span class="req">*</span></label>
```
to:
```jsp
                            <div class="form-group form-full">
                                <label for="shopAddress">Địa chỉ <span class="req">*</span></label>
                                <input type="text" id="shopAddress" name="shopAddress" class="form-control"
                                       value="${fn:escapeXml(formShop.shopAddress)}"
                                       placeholder="Số nhà, đường, quận/huyện, tỉnh/thành..."
                                       required>
                            </div>

                            <div class="form-group form-full">
                                <label>Vị trí trên bản đồ</label>
                                <button type="button" class="btn btn-secondary" id="shopLocationToggleBtn"
                                        data-preset-lat="${fn:escapeXml(formShop.locationX != null ? formShop.locationX : '')}"
                                        data-preset-lng="${fn:escapeXml(formShop.locationY != null ? formShop.locationY : '')}">📍 Chọn vị trí trên bản đồ</button>
                                <div id="shopLocationMapWrapper" style="display:none; margin-top:10px;">
                                    <div style="display:flex; gap:8px; margin-bottom:8px;">
                                        <input type="text" id="shopLocationMapSearchInput" class="form-control" placeholder="Tìm địa chỉ...">
                                        <button type="button" id="shopLocationMapSearchBtn" class="btn btn-secondary">Tìm</button>
                                    </div>
                                    <div id="shopLocationMap" style="height:280px; border-radius:12px; overflow:hidden;"></div>
                                </div>
                                <input type="hidden" name="shopLocationX" id="shopLocationXInput"
                                       value="${fn:escapeXml(formShop.locationX != null ? formShop.locationX : '')}">
                                <input type="hidden" name="shopLocationY" id="shopLocationYInput"
                                       value="${fn:escapeXml(formShop.locationY != null ? formShop.locationY : '')}">
                                <p class="hint">Không bắt buộc — chọn vị trí để khách hàng và shipper thấy đúng nơi lấy hàng trên bản đồ.</p>
                            </div>

                            <div class="form-group">
                                <label for="shopPhone">Số điện thoại <span class="req">*</span></label>
```

- [ ] **Step 3: Add the map-picker JS**

In the existing `<script>` block (starts at line 385), change:
```javascript
<script>
    function previewLogo(url) {
```
to:
```javascript
<script>
    function initShopLocationMap(presetLat, presetLng) {
        var mapContainer = document.getElementById('shopLocationMap');
        if (mapContainer.dataset.initialized === 'true') {
            var existingMap = mapContainer._leafletMap;
            setTimeout(function () { existingMap.invalidateSize(); }, 50);
            return;
        }
        mapContainer.dataset.initialized = 'true';

        var defaultLat = 21.0285, defaultLng = 105.8542;
        var startLat = presetLat ? parseFloat(presetLat) : defaultLat;
        var startLng = presetLng ? parseFloat(presetLng) : defaultLng;

        var map = L.map('shopLocationMap').setView([startLat, startLng], 15);
        mapContainer._leafletMap = map;

        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
            attribution: '&copy; OpenStreetMap contributors',
            maxZoom: 19
        }).addTo(map);

        var marker = null;

        function updateCoords(lat, lng) {
            document.getElementById('shopLocationXInput').value = lat;
            document.getElementById('shopLocationYInput').value = lng;
        }

        function placeMarker(lat, lng) {
            if (marker) {
                marker.setLatLng([lat, lng]);
            } else {
                marker = L.marker([lat, lng], { draggable: true }).addTo(map);
                marker.on('dragend', function () {
                    var pos = marker.getLatLng();
                    updateCoords(pos.lat, pos.lng);
                });
            }
            updateCoords(lat, lng);
        }

        map.on('click', function (e) {
            placeMarker(e.latlng.lat, e.latlng.lng);
        });

        if (presetLat && presetLng) {
            placeMarker(startLat, startLng);
        } else if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(
                function (pos) { map.setView([pos.coords.latitude, pos.coords.longitude], 15); },
                function () { /* denied - keep default center */ },
                { timeout: 5000 }
            );
        }

        document.getElementById('shopLocationMapSearchBtn').addEventListener('click', function () {
            var query = document.getElementById('shopLocationMapSearchInput').value.trim();
            if (!query) return;
            fetch('https://nominatim.openstreetmap.org/search?format=json&q=' + encodeURIComponent(query) + '&limit=1')
                .then(function (res) { return res.json(); })
                .then(function (results) {
                    if (results && results.length > 0) {
                        var lat = parseFloat(results[0].lat);
                        var lng = parseFloat(results[0].lon);
                        map.setView([lat, lng], 16);
                        placeMarker(lat, lng);
                    } else {
                        alert('Không tìm thấy địa chỉ, vui lòng thử tên khác');
                    }
                })
                .catch(function () {
                    alert('Không tìm được địa chỉ, vui lòng thử lại');
                });
        });
    }

    function toggleShopLocationMap() {
        var wrapper = document.getElementById('shopLocationMapWrapper');
        wrapper.style.display = 'block';
        var btn = document.getElementById('shopLocationToggleBtn');
        var presetLat = btn.dataset.presetLat || null;
        var presetLng = btn.dataset.presetLng || null;
        setTimeout(function () {
            initShopLocationMap(presetLat, presetLng);
        }, 50);
    }

    document.addEventListener('DOMContentLoaded', function () {
        var toggleBtn = document.getElementById('shopLocationToggleBtn');
        if (toggleBtn) {
            toggleBtn.addEventListener('click', toggleShopLocationMap);
        }
    });

    function previewLogo(url) {
```

(This adds a new `DOMContentLoaded` listener alongside the existing avatar-dropdown one near the bottom of the file — do not merge into or replace that listener.)

- [ ] **Step 4: Compile-verify**

Run the standard command from Global Constraints (Task 1, Step 4) — JSPs aren't compiled by `javac`, but this step re-confirms the Java layer (Tasks 1-2) still compiles clean after the JSP edit. Expected: no errors.

- [ ] **Step 5: Commit**

```bash
git add src/main/web/shop/Shopprofile.jsp
git commit -m "Add editable Leaflet location picker to shop profile page"
```

---

### Task 4: Update docs and final verification

**Files:**
- Modify: `CRUD_DA_LAM.md`
- Modify: `PROJECT_STRUCTURE.md`

**Interfaces:**
- Consumes: nothing (documentation only).
- Produces: nothing.

- [ ] **Step 1: Append a new section to `CRUD_DA_LAM.md`**

The file's last section is `## 23. Xem vi tri giao hang tren ban do (phia shop)` (line 814). Append this new section at the end of the file:
```markdown

## 24. Chon vi tri cua hang tren ban do (trang Thong tin cua hang, phia shop)

- **Van de:** Shop khong co cach nao dat toa do vi tri cua hang (`Shops.locationX`/`locationY`). Cot DB va field model da co san nhung `ShopDAOImpl` chua bao gio doc/ghi chung, nen marker cua hang tren ban do giao hang (tinh nang truoc do) luon rong.
- **Sua:**
  - `ShopDAOImpl.mapResultSetToShop()`: doc them `locationX`/`locationY` tu ResultSet.
  - `ShopDAOImpl.updateShop()`: ghi them `locationX`/`locationY` vao cau lenh UPDATE.
  - `ShopProfileServlet`: nhan them 2 tham so form `shopLocationX`/`shopLocationY` (khong bat buoc), set len `Shop` truoc khi luu.
  - `shop/Shopprofile.jsp`: them nut "Chon vi tri tren ban do" trong form chinh sua, mo ra ban do Leaflet (click/keo ghim + o tim kiem Nominatim) — cung mau giao dien voi `user/diaChi.jsp`, nhung khong bat buoc phai chon.
- **Tech:** Leaflet 1.9.4 CDN + OpenStreetMap + Nominatim, khong doi Model/DB schema (cot da co san).
```

- [ ] **Step 2: Update the `/shop/profile` row in `PROJECT_STRUCTURE.md`**

At line 60, change:
```markdown
| `/shop/profile` | [ShopProfileServlet.java](src/main/java/org/example/controllers/ShopProfileServlet.java) | ShopDAO/Impl | Shop | [shop/Shopprofile.jsp](src/main/web/shop/Shopprofile.jsp) |
```
to:
```markdown
| `/shop/profile` | [ShopProfileServlet.java](src/main/java/org/example/controllers/ShopProfileServlet.java) | ShopDAO/Impl | Shop | [shop/Shopprofile.jsp](src/main/web/shop/Shopprofile.jsp) — form chỉnh sửa có nút "📍 Chọn vị trí trên bản đồ" (Leaflet, không bắt buộc) để đặt `locationX`/`locationY` của cửa hàng |
```

- [ ] **Step 3: Full compile**

Run:
```bash
CP=$(find /c/Users/ADMIN/.m2 -iname "*.jar" ! -iname "*-sources.jar" | sed 's#^/c#C:#' | tr '\n' ';')
javac -encoding UTF-8 -cp "$CP" -d /tmp/dbcheck/out $(find src/main/java -name "*.java")
```
Expected: no errors.

- [ ] **Step 4: Manual regression checklist (on a local dev server)**

1. `/shop/profile`: open the page, click "📍 Chọn vị trí trên bản đồ" — map opens centered on Hà Nội (no prior coordinates). Click somewhere on the map — a pin drops there and the hidden inputs update. Save the form.
2. Reload `/shop/profile` — click the toggle button again: the map now opens pre-centered on the previously saved coordinates with the pin already placed there (confirms `formShop.locationX/locationY` round-trips through `ShopDAOImpl`).
3. Use the search box (e.g. type an address) — map recenters and drops a pin on the first result.
4. Save the form with the location fields untouched (never opened the map) — confirm the save still succeeds and doesn't clear a previously-set location (confirms the field is truly optional and doesn't get wiped by omission... note: if the map was never opened, the hidden inputs still carry the value rendered server-side from `formShop`, so this should hold).
5. Trigger the "required field empty" validation path (clear `shopName` and submit) after having picked a location — confirm the re-rendered form still shows the picked location in the map when re-opened (confirms Task 2 Step 2's `formShop.setLocationX/Y`).
6. Open `/shop/bills` (`Quanlybill.jsp`) or a bill detail (`HoaDonShop.jsp`) for an order that has coordinates — confirm the 🏠 shop marker now renders (previously always missing).

- [ ] **Step 5: Commit**

```bash
git add CRUD_DA_LAM.md PROJECT_STRUCTURE.md
git commit -m "Document shop-profile location picker feature"
```
