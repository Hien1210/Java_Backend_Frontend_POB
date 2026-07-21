# Leaflet Address Map Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Let users pick a real map location (Leaflet + OpenStreetMap) when adding/editing an address, both on the "Địa chỉ của tôi" page and inline on the Checkout page, and carry the picked coordinates onto the created `Order`.

**Architecture:** Servlet (Controller) → DAO (JDBC) → Model (POJO) → JSP (View), matching the rest of this codebase. Leaflet.js is loaded from a CDN directly in each JSP `<head>` (no frontend build step exists in this project). Two pages get their own self-contained `<script>` blocks with a small Leaflet init routine each — this project has no shared static JS directory (every JSP is self-contained with inline `<style>`/`<script>`), so the existing pattern is followed rather than introducing a new `/js` convention.

**Tech Stack:** Java Servlet/JSP (Jakarta EE), Maven, Tomcat 10.1, SQL Server (`mssql-jdbc`), Leaflet.js 1.9.4 (CDN), OpenStreetMap tiles, Nominatim geocoding API (called client-side via `fetch`).

## Global Constraints

- This project has **no automated test framework** (no JUnit/pytest). Verification for every `.java`-touching task is a full-project `javac` compile using the command below. Verification for every `.jsp`-touching task is a manual browser checklist (the engineer runs the project's own local Tomcat/Maven dev server, which is outside this plan's scope to start).
- Standard compile-verification command (run from the repo root):
  ```bash
  CP=$(find /c/Users/ADMIN/.m2 -iname "*.jar" ! -iname "*-sources.jar" | sed 's#^/c#C:#' | tr '\n' ';')
  javac -encoding UTF-8 -cp "$CP" -d /tmp/dbcheck/out $(find src/main/java -name "*.java")
  ```
  Expected: no output, exit code 0.
- DB column names are confirmed via live introspection (`DatabaseMetaData.getColumns`): `User_Addresses` has `locationX`, `locationY` (decimal, nullable); `Orders` has `locationX`, `locationY` (decimal, nullable). No schema migration needed.
- Coordinate convention: `locationX` = **latitude**, `locationY` = **longitude** (matches Leaflet's `[lat, lng]` order).
- Per `CLAUDE.md`: after all implementation tasks are done, `CRUD_DA_LAM.md` and `PROJECT_STRUCTURE.md` must be updated (Task 11).

---

### Task 1: `UserAddress` model — add locationX/locationY

**Files:**
- Modify: `src/main/java/org/example/models/UserAddress.java`

**Interfaces:**
- Produces: `UserAddress.getLocationX()` / `setLocationX(Double)`, `getLocationY()` / `setLocationY(Double)` — used by Task 2 (DAO), Task 3 (Servlet), Task 4/5 (JSP via EL `addr.locationX`/`addr.locationY`).

- [ ] **Step 1: Add the two fields and their accessors**

Add right after the existing `createdAt` field (line 14) and its accessors (after line 52), so the file becomes:

```java
package org.example.models;

import java.time.LocalDateTime;

public class UserAddress {
    private long id;
    private long userId;           // maps to DB column: user_id
    private String label;
    private String address;        // maps to DB column: address
    private String receiverName;
    private String receiverPhone;
    private boolean isDefault;
    private boolean isDeleted;
    private LocalDateTime createdAt;
    private Double locationX;      // maps to DB column: locationX (latitude)
    private Double locationY;      // maps to DB column: locationY (longitude)

    public UserAddress() {}

    public long getId() { return id; }
    public void setId(long id) { this.id = id; }

    public long getUserId() { return userId; }
    public void setUserId(long userId) { this.userId = userId; }

    // alias để không phải sửa Servlet cũ
    public long getAccountId() { return userId; }
    public void setAccountId(long accountId) { this.userId = accountId; }

    public String getLabel() { return label; }
    public void setLabel(String label) { this.label = label; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    // alias cho code cũ dùng fullAddress
    public String getFullAddress() { return address; }
    public void setFullAddress(String fullAddress) { this.address = fullAddress; }

    public String getReceiverName() { return receiverName; }
    public void setReceiverName(String receiverName) { this.receiverName = receiverName; }

    public String getReceiverPhone() { return receiverPhone; }
    public void setReceiverPhone(String receiverPhone) { this.receiverPhone = receiverPhone; }

    public boolean isDefault() { return isDefault; }
    public void setDefault(boolean aDefault) { isDefault = aDefault; }
    public boolean getIsDefault() { return isDefault; }

    public boolean isDeleted() { return isDeleted; }
    public void setDeleted(boolean deleted) { isDeleted = deleted; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public Double getLocationX() { return locationX; }
    public void setLocationX(Double locationX) { this.locationX = locationX; }

    public Double getLocationY() { return locationY; }
    public void setLocationY(Double locationY) { this.locationY = locationY; }
}
```

- [ ] **Step 2: Compile-verify**

Run:
```bash
CP=$(find /c/Users/ADMIN/.m2 -iname "*.jar" ! -iname "*-sources.jar" | sed 's#^/c#C:#' | tr '\n' ';')
javac -encoding UTF-8 -cp "$CP" -d /tmp/dbcheck/out $(find src/main/java -name "*.java")
```
Expected: no errors.

- [ ] **Step 3: Commit**

```bash
git add src/main/java/org/example/models/UserAddress.java
git commit -m "Add locationX/locationY fields to UserAddress model"
```

---

### Task 2: `UserAddressDAOImpl` — read/write locationX/locationY

**Files:**
- Modify: `src/main/java/org/example/daos/UserAddressDAOImpl.java`

**Interfaces:**
- Consumes: `UserAddress.getLocationX()/getLocationY()/setLocationX()/setLocationY()` (Task 1).
- Produces: `findByAccountId`/`findById` now populate `locationX`/`locationY`; `create`/`update` now persist them.

- [ ] **Step 1: Add columns to the two SELECT queries**

In `findByAccountId` (around line 15), change:
```java
String sql = "SELECT id, user_id, label, address, receiver_name, receiver_phone, is_default, created_at " +
             "FROM User_Addresses WHERE user_id = ? AND is_deleted = 0 ORDER BY is_default DESC, id ASC";
```
to:
```java
String sql = "SELECT id, user_id, label, address, receiver_name, receiver_phone, is_default, created_at, locationX, locationY " +
             "FROM User_Addresses WHERE user_id = ? AND is_deleted = 0 ORDER BY is_default DESC, id ASC";
```

In `findById` (around line 31), change:
```java
String sql = "SELECT id, user_id, label, address, receiver_name, receiver_phone, is_default, created_at " +
             "FROM User_Addresses WHERE id = ? AND is_deleted = 0";
```
to:
```java
String sql = "SELECT id, user_id, label, address, receiver_name, receiver_phone, is_default, created_at, locationX, locationY " +
             "FROM User_Addresses WHERE id = ? AND is_deleted = 0";
```

- [ ] **Step 2: Persist coordinates in `create`**

Replace the whole `create` method (lines 45-62):
```java
@Override
public boolean create(UserAddress a) {
    String sql = "INSERT INTO User_Addresses (user_id, label, address, receiver_name, receiver_phone, is_default, locationX, locationY) " +
                 "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
    try (Connection conn = DBUtil.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setLong(1, a.getAccountId());
        ps.setNString(2, a.getLabel());
        ps.setNString(3, a.getFullAddress());
        ps.setNString(4, a.getReceiverName());
        ps.setString(5, a.getReceiverPhone());
        ps.setBoolean(6, a.isDefault());
        if (a.getLocationX() != null) {
            ps.setDouble(7, a.getLocationX());
        } else {
            ps.setNull(7, Types.DECIMAL);
        }
        if (a.getLocationY() != null) {
            ps.setDouble(8, a.getLocationY());
        } else {
            ps.setNull(8, Types.DECIMAL);
        }
        return ps.executeUpdate() == 1;
    } catch (Exception e) {
        e.printStackTrace();
        return false;
    }
}
```

- [ ] **Step 3: Persist coordinates in `update`**

Replace the whole `update` method (lines 64-81):
```java
@Override
public boolean update(UserAddress a) {
    String sql = "UPDATE User_Addresses SET label = ?, address = ?, receiver_name = ?, receiver_phone = ?, locationX = ?, locationY = ? " +
                 "WHERE id = ? AND user_id = ?";
    try (Connection conn = DBUtil.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setNString(1, a.getLabel());
        ps.setNString(2, a.getFullAddress());
        ps.setNString(3, a.getReceiverName());
        ps.setString(4, a.getReceiverPhone());
        if (a.getLocationX() != null) {
            ps.setDouble(5, a.getLocationX());
        } else {
            ps.setNull(5, Types.DECIMAL);
        }
        if (a.getLocationY() != null) {
            ps.setDouble(6, a.getLocationY());
        } else {
            ps.setNull(6, Types.DECIMAL);
        }
        ps.setLong(7, a.getId());
        ps.setLong(8, a.getAccountId());
        return ps.executeUpdate() == 1;
    } catch (Exception e) {
        e.printStackTrace();
        return false;
    }
}
```

- [ ] **Step 4: Map coordinates back in `map()`**

In the private `map(ResultSet rs)` method (lines 121-133), add before `return a;`:
```java
a.setLocationX(rs.getObject("locationX", Double.class));
a.setLocationY(rs.getObject("locationY", Double.class));
```
So the full method becomes:
```java
private UserAddress map(ResultSet rs) throws SQLException {
    UserAddress a = new UserAddress();
    a.setId(rs.getLong("id"));
    a.setAccountId(rs.getLong("user_id"));
    a.setLabel(rs.getString("label"));
    a.setFullAddress(rs.getString("address"));
    a.setReceiverName(rs.getString("receiver_name"));
    a.setReceiverPhone(rs.getString("receiver_phone"));
    a.setDefault(rs.getBoolean("is_default"));
    Timestamp ca = rs.getTimestamp("created_at");
    if (ca != null) a.setCreatedAt(ca.toLocalDateTime());
    a.setLocationX(rs.getObject("locationX", Double.class));
    a.setLocationY(rs.getObject("locationY", Double.class));
    return a;
}
```

- [ ] **Step 5: Compile-verify**

Run the standard command from Global Constraints. Expected: no errors.

- [ ] **Step 6: Commit**

```bash
git add src/main/java/org/example/daos/UserAddressDAOImpl.java
git commit -m "Persist and read locationX/locationY in UserAddressDAOImpl"
```

---

### Task 3: `UserAddressServlet` — mandatory coordinates + returnTo/cartId

**Files:**
- Modify: `src/main/java/org/example/controllers/UserAddressServlet.java`

**Interfaces:**
- Consumes: `UserAddress.setLocationX(Double)/setLocationY(Double)` (Task 1), `UserAddressDAO.create/update` (Task 2).
- Produces: `POST /user/dia-chi` now requires `locationX`/`locationY` params on `action=create`/`action=update`; accepts optional `returnTo=checkout&cartId=<id>` params that redirect back to `/checkout?cartId=<id>` instead of `/user/dia-chi` after create/update (success or validation error). Consumed by Task 9 (checkout modal).

- [ ] **Step 1: Add a shared redirect helper and a Double parser**

Add these two private methods, right after `normalize` (end of file, before the final closing brace):
```java
private void redirectTo(HttpServletRequest req, HttpServletResponse resp, String queryString) throws IOException {
    String returnTo = normalize(req.getParameter("returnTo"));
    String cartId = normalize(req.getParameter("cartId"));
    if ("checkout".equals(returnTo) && !cartId.isEmpty()) {
        resp.sendRedirect(req.getContextPath() + "/checkout?cartId=" + cartId);
    } else {
        resp.sendRedirect(req.getContextPath() + "/user/dia-chi?" + queryString);
    }
}

private Double parseDoubleOrNull(String value) {
    try {
        String normalized = normalize(value);
        return normalized.isEmpty() ? null : Double.parseDouble(normalized);
    } catch (Exception e) {
        return null;
    }
}
```

- [ ] **Step 2: Require and set coordinates in `createAddress`, use `redirectTo`**

Replace the whole `createAddress` method:
```java
private void createAddress(HttpServletRequest req, HttpServletResponse resp, Account account) throws IOException {
    String label = normalize(req.getParameter("label"));
    String fullAddress = normalize(req.getParameter("fullAddress"));
    String receiverName = normalize(req.getParameter("receiverName"));
    String receiverPhone = normalize(req.getParameter("receiverPhone"));
    boolean isDefault = "true".equals(req.getParameter("isDefault"));
    Double locationX = parseDoubleOrNull(req.getParameter("locationX"));
    Double locationY = parseDoubleOrNull(req.getParameter("locationY"));

    if (fullAddress.isEmpty() || receiverName.isEmpty() || receiverPhone.isEmpty() || locationX == null || locationY == null) {
        redirectTo(req, resp, "error=missing");
        return;
    }

    UserAddress a = new UserAddress();
    a.setAccountId(account.getId());
    a.setLabel(label.isEmpty() ? "Khác" : label);
    a.setFullAddress(fullAddress);
    a.setReceiverName(receiverName);
    a.setReceiverPhone(receiverPhone);
    a.setDefault(isDefault);
    a.setLocationX(locationX);
    a.setLocationY(locationY);

    boolean ok = userAddressDAO.create(a);
    if (ok && isDefault) {
        List<UserAddress> addresses = userAddressDAO.findByAccountId(account.getId());
        UserAddress created = addresses.isEmpty() ? null : addresses.get(addresses.size() - 1);
        if (created != null) {
            userAddressDAO.setDefault(created.getId(), account.getId());
        }
    }

    redirectTo(req, resp, "success=created");
}
```

- [ ] **Step 3: Require and set coordinates in `updateAddress`, use `redirectTo`**

Replace the whole `updateAddress` method:
```java
private void updateAddress(HttpServletRequest req, HttpServletResponse resp, Account account) throws IOException {
    Long id = parseId(req.getParameter("id"));
    String label = normalize(req.getParameter("label"));
    String fullAddress = normalize(req.getParameter("fullAddress"));
    String receiverName = normalize(req.getParameter("receiverName"));
    String receiverPhone = normalize(req.getParameter("receiverPhone"));
    Double locationX = parseDoubleOrNull(req.getParameter("locationX"));
    Double locationY = parseDoubleOrNull(req.getParameter("locationY"));

    if (id == null || fullAddress.isEmpty() || receiverName.isEmpty() || receiverPhone.isEmpty() || locationX == null || locationY == null) {
        redirectTo(req, resp, "error=missing");
        return;
    }

    UserAddress existing = userAddressDAO.findById(id);
    if (existing == null || existing.getAccountId() != account.getId()) {
        redirectTo(req, resp, "error=missing");
        return;
    }

    existing.setLabel(label.isEmpty() ? "Khác" : label);
    existing.setFullAddress(fullAddress);
    existing.setReceiverName(receiverName);
    existing.setReceiverPhone(receiverPhone);
    existing.setLocationX(locationX);
    existing.setLocationY(locationY);

    userAddressDAO.update(existing);
    redirectTo(req, resp, "success=updated");
}
```

- [ ] **Step 4: Compile-verify**

Run the standard command from Global Constraints. Expected: no errors.

- [ ] **Step 5: Commit**

```bash
git add src/main/java/org/example/controllers/UserAddressServlet.java
git commit -m "Require map coordinates on address create/update; support returnTo=checkout redirect"
```

---

### Task 4: `diaChi.jsp` — Leaflet map in the "Thêm địa chỉ mới" modal

**Files:**
- Modify: `src/main/web/user/diaChi.jsp`

**Interfaces:**
- Produces: JS functions `initAddressMap(containerId, latInputId, lngInputId, addressFieldId, presetLat, presetLng)`, `toggleMap(wrapperId, containerId, latInputId, lngInputId, addressFieldId, presetLat, presetLng)`, `validateAddressForm(latInputId, lngInputId)` — reused by Task 5 for the Edit modal.

- [ ] **Step 1: Add the Leaflet CDN tags**

In `<head>`, right after the Google Fonts `<link>` (line 9), add:
```html
<link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
```

- [ ] **Step 2: Give the Create modal's address textarea an id**

Change (line 250):
```html
<textarea name="fullAddress" rows="2" required placeholder="Số nhà, tên đường, phường/xã, quận/huyện, tỉnh/thành phố" class="textarea-field"></textarea>
```
to:
```html
<textarea name="fullAddress" id="createFullAddress" rows="2" required placeholder="Số nhà, tên đường, phường/xã, quận/huyện, tỉnh/thành phố" class="textarea-field"></textarea>
```

- [ ] **Step 3: Add the map picker block to the Create modal**

Right after the "Địa chỉ đầy đủ" `form-group` (after line 251, before the `form-row` with Tên người nhận/SĐT), insert:
```html
<div class="form-group">
    <button type="button" class="addr-btn addr-btn-edit" onclick="toggleMap('createMapWrapper','createMap','createLat','createLng','createFullAddress', null, null)">📍 Chọn trên bản đồ</button>
    <div id="createMapWrapper" style="display:none; margin-top:10px;">
        <div style="display:flex; gap:8px; margin-bottom:8px;">
            <input type="text" id="createMapSearchInput" class="input-field" placeholder="Tìm địa chỉ...">
            <button type="button" id="createMapSearchBtn" class="btn-cancel">Tìm</button>
        </div>
        <div id="createMap" style="height:280px; border-radius:12px; overflow:hidden;"></div>
    </div>
    <input type="hidden" name="locationX" id="createLat">
    <input type="hidden" name="locationY" id="createLng">
</div>
```

- [ ] **Step 4: Require coordinates before submitting the Create form**

Change the Create modal's `<form>` opening tag (line 235):
```html
<form action="${pageContext.request.contextPath}/user/dia-chi" method="post">
```
to:
```html
<form action="${pageContext.request.contextPath}/user/dia-chi" method="post" onsubmit="return validateAddressForm('createLat','createLng')">
```

- [ ] **Step 5: Add the shared Leaflet JS helpers**

In the `<script>` block at the bottom of the file, right before the closing `</script>` (before line 366's `</script>`, i.e. after the `openDeleteConfirm` function), add:
```javascript
    function initAddressMap(containerId, latInputId, lngInputId, addressFieldId, presetLat, presetLng) {
        var mapContainer = document.getElementById(containerId);
        if (mapContainer.dataset.initialized === 'true') {
            var existingMap = mapContainer._leafletMap;
            setTimeout(function () { existingMap.invalidateSize(); }, 50);
            return;
        }
        mapContainer.dataset.initialized = 'true';

        var defaultLat = 21.0285, defaultLng = 105.8542;
        var startLat = presetLat ? parseFloat(presetLat) : defaultLat;
        var startLng = presetLng ? parseFloat(presetLng) : defaultLng;

        var map = L.map(containerId).setView([startLat, startLng], 15);
        mapContainer._leafletMap = map;

        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
            attribution: '&copy; OpenStreetMap contributors',
            maxZoom: 19
        }).addTo(map);

        var marker = null;

        function updateCoords(lat, lng) {
            document.getElementById(latInputId).value = lat;
            document.getElementById(lngInputId).value = lng;
        }

        function reverseGeocode(lat, lng) {
            fetch('https://nominatim.openstreetmap.org/reverse?format=json&lat=' + lat + '&lon=' + lng)
                .then(function (res) { return res.json(); })
                .then(function (data) {
                    if (data && data.display_name) {
                        document.getElementById(addressFieldId).value = data.display_name;
                    }
                })
                .catch(function () {
                    console.warn('Khong the lay dia chi tu toa do');
                });
        }

        function placeMarker(lat, lng, doReverseGeocode) {
            if (marker) {
                marker.setLatLng([lat, lng]);
            } else {
                marker = L.marker([lat, lng], { draggable: true }).addTo(map);
                marker.on('dragend', function () {
                    var pos = marker.getLatLng();
                    updateCoords(pos.lat, pos.lng);
                    reverseGeocode(pos.lat, pos.lng);
                });
            }
            updateCoords(lat, lng);
            if (doReverseGeocode) reverseGeocode(lat, lng);
        }

        map.on('click', function (e) {
            placeMarker(e.latlng.lat, e.latlng.lng, true);
        });

        if (presetLat && presetLng) {
            placeMarker(startLat, startLng, false);
        } else if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(
                function (pos) { map.setView([pos.coords.latitude, pos.coords.longitude], 15); },
                function () { /* denied - keep default center */ },
                { timeout: 5000 }
            );
        }

        document.getElementById(containerId + 'SearchBtn').addEventListener('click', function () {
            var query = document.getElementById(containerId + 'SearchInput').value.trim();
            if (!query) return;
            fetch('https://nominatim.openstreetmap.org/search?format=json&q=' + encodeURIComponent(query) + '&limit=1')
                .then(function (res) { return res.json(); })
                .then(function (results) {
                    if (results && results.length > 0) {
                        var lat = parseFloat(results[0].lat);
                        var lng = parseFloat(results[0].lon);
                        map.setView([lat, lng], 16);
                        placeMarker(lat, lng, true);
                    } else {
                        alert('Không tìm thấy địa chỉ, vui lòng thử tên khác');
                    }
                })
                .catch(function () {
                    alert('Không tìm được địa chỉ, vui lòng thử lại');
                });
        });
    }

    function toggleMap(wrapperId, containerId, latInputId, lngInputId, addressFieldId, presetLat, presetLng) {
        document.getElementById(wrapperId).style.display = 'block';
        setTimeout(function () {
            initAddressMap(containerId, latInputId, lngInputId, addressFieldId, presetLat, presetLng);
        }, 50);
    }

    function validateAddressForm(latInputId, lngInputId) {
        var lat = document.getElementById(latInputId).value;
        var lng = document.getElementById(lngInputId).value;
        if (!lat || !lng) {
            alert('Vui lòng chọn vị trí trên bản đồ trước khi lưu.');
            return false;
        }
        return true;
    }
```

- [ ] **Step 6: Manual browser check (Create modal)**

Start the local dev server (Tomcat/Maven, per the project's normal run configuration), log in as a `roleId=3` user, go to `/user/dia-chi`, click "+ Thêm địa chỉ mới":
1. Click "Lưu địa chỉ" without touching the map → expect the alert "Vui lòng chọn vị trí trên bản đồ trước khi lưu." and the form does NOT submit.
2. Click "📍 Chọn trên bản đồ" → map appears, centered on your browser's geolocation (or Hà Nội if location is denied).
3. Click anywhere on the map → a marker appears there, and the "Địa chỉ đầy đủ" textarea auto-fills with a reverse-geocoded address.
4. Type an address into the search box and click "Tìm" → map recenters and the marker jumps to the found location.
5. Fill in the rest of the form and click "Lưu địa chỉ" → address is created successfully (redirects to `/user/dia-chi?success=created`).

- [ ] **Step 7: Commit**

```bash
git add src/main/web/user/diaChi.jsp
git commit -m "Add Leaflet map picker to the address Create modal"
```

---

### Task 5: `diaChi.jsp` — Leaflet map in the "Sửa địa chỉ" modal

**Files:**
- Modify: `src/main/web/user/diaChi.jsp`

**Interfaces:**
- Consumes: `initAddressMap`, `toggleMap`, `validateAddressForm` (Task 4). `UserAddress.getLocationX()/getLocationY()` (Task 1).

- [ ] **Step 1: Add the map picker block to the Edit modal**

Right after the Edit modal's "Địa chỉ đầy đủ" `form-group` (after line 301, before the `form-row` with Tên người nhận/SĐT), insert:
```html
<div class="form-group">
    <button type="button" class="addr-btn addr-btn-edit" onclick="toggleMap('editMapWrapper','editMap','editLat','editLng','editFullAddress', window.editPresetLat, window.editPresetLng)">📍 Chọn trên bản đồ</button>
    <div id="editMapWrapper" style="display:none; margin-top:10px;">
        <div style="display:flex; gap:8px; margin-bottom:8px;">
            <input type="text" id="editMapSearchInput" class="input-field" placeholder="Tìm địa chỉ...">
            <button type="button" id="editMapSearchBtn" class="btn-cancel">Tìm</button>
        </div>
        <div id="editMap" style="height:280px; border-radius:12px; overflow:hidden;"></div>
    </div>
    <input type="hidden" name="locationX" id="editLat">
    <input type="hidden" name="locationY" id="editLng">
</div>
```

- [ ] **Step 2: Require coordinates before submitting the Edit form**

Change the Edit modal's `<form>` opening tag (line 284):
```html
<form action="${pageContext.request.contextPath}/user/dia-chi" method="post">
```
to:
```html
<form action="${pageContext.request.contextPath}/user/dia-chi" method="post" onsubmit="return validateAddressForm('editLat','editLng')">
```

- [ ] **Step 3: Pass locationX/locationY into `openEdit()` and pre-fill them**

Change the "Sửa" button's `onclick` in the address card loop (lines 209-212) from:
```html
<button class="addr-btn addr-btn-edit"
        onclick="openEdit(${addr.id}, '${addr.label}', '${addr.fullAddress}', '${addr.receiverName}', '${addr.receiverPhone}')">
    ✏️ Sửa
</button>
```
to:
```html
<button class="addr-btn addr-btn-edit"
        onclick="openEdit(${addr.id}, '${addr.label}', '${addr.fullAddress}', '${addr.receiverName}', '${addr.receiverPhone}', ${addr.locationX != null ? addr.locationX : 'null'}, ${addr.locationY != null ? addr.locationY : 'null'})">
    ✏️ Sửa
</button>
```

- [ ] **Step 4: Update `openEdit()` to accept and pre-fill coordinates**

Change the `openEdit` function (lines 352-360) from:
```javascript
    function openEdit(id, label, fullAddress, receiverName, receiverPhone) {
        document.getElementById('editId').value           = id;
        document.getElementById('editFullAddress').value  = fullAddress;
        document.getElementById('editReceiverName').value = receiverName;
        document.getElementById('editReceiverPhone').value= receiverPhone;
        var sel = document.getElementById('editLabel');
        for (var i = 0; i < sel.options.length; i++) sel.options[i].selected = sel.options[i].value === label;
        openModal('modalEdit');
    }
```
to:
```javascript
    function openEdit(id, label, fullAddress, receiverName, receiverPhone, locationX, locationY) {
        document.getElementById('editId').value           = id;
        document.getElementById('editFullAddress').value  = fullAddress;
        document.getElementById('editReceiverName').value = receiverName;
        document.getElementById('editReceiverPhone').value= receiverPhone;
        document.getElementById('editLat').value = (locationX === null || locationX === undefined) ? '' : locationX;
        document.getElementById('editLng').value = (locationY === null || locationY === undefined) ? '' : locationY;
        window.editPresetLat = locationX;
        window.editPresetLng = locationY;
        var sel = document.getElementById('editLabel');
        for (var i = 0; i < sel.options.length; i++) sel.options[i].selected = sel.options[i].value === label;
        openModal('modalEdit');
    }
```

- [ ] **Step 5: Manual browser check (Edit modal)**

On `/user/dia-chi`:
1. Edit an address that was created via Task 4 (already has coordinates) → click "✏️ Sửa" → click "Lưu địa chỉ" without opening the map → expect the update to succeed immediately (coordinates were pre-filled from the existing address, so `validateAddressForm` passes).
2. Click "📍 Chọn trên bản đồ" on that same edit → marker appears already placed at the address's saved location.
3. If any legacy address exists with `locationX`/`locationY` still NULL in the DB (e.g. one created before this feature), click "✏️ Sửa" → click "Lưu địa chỉ" without touching the map → expect the alert blocking submission, forcing the user to pick a location first.

- [ ] **Step 6: Commit**

```bash
git add src/main/web/user/diaChi.jsp
git commit -m "Add Leaflet map picker to the address Edit modal"
```

---

### Task 6: `Order` model — add locationX/locationY

**Files:**
- Modify: `src/main/java/org/example/models/Order.java`

**Interfaces:**
- Produces: `Order.getLocationX()/setLocationX(Double)`, `getLocationY()/setLocationY(Double)` — used by Task 7 (DAO) and Task 8 (CheckoutServlet).

- [ ] **Step 1: Add the two fields and accessors**

Add the field declarations right after `private LocalDateTime updatedAt;` (line 21):
```java
    private Double locationX;
    private Double locationY;
```

Add the getters/setters right after `getUpdatedAt()`/`setUpdatedAt()` (after line 169, before the `toString()` method):
```java
    public Double getLocationX() {
        return locationX;
    }

    public void setLocationX(Double locationX) {
        this.locationX = locationX;
    }

    public Double getLocationY() {
        return locationY;
    }

    public void setLocationY(Double locationY) {
        this.locationY = locationY;
    }
```

- [ ] **Step 2: Compile-verify**

Run the standard command from Global Constraints. Expected: no errors.

- [ ] **Step 3: Commit**

```bash
git add src/main/java/org/example/models/Order.java
git commit -m "Add locationX/locationY fields to Order model"
```

---

### Task 7: `OrderDAOImpl` — read/write locationX/locationY

**Files:**
- Modify: `src/main/java/org/example/daos/OrderDAOImpl.java`

**Interfaces:**
- Consumes: `Order.getLocationX()/getLocationY()/setLocationX()/setLocationY()` (Task 6).
- Produces: `createAndReturnId`/`create`/`update` now persist `locationX`/`locationY` when present; all `find*`/`getAll` methods now populate them on returned `Order` objects.

This DAO auto-detects real column names via `DatabaseMetaData`, so the change follows the same "candidates" pattern already used for every other field.

- [ ] **Step 1: Add candidate arrays**

Add two new candidate arrays next to the existing ones (after line 41, `UPDATED_AT_CANDIDATES`):
```java
    private static final String[] LOCATION_X_CANDIDATES = {"locationX", "location_x"};
    private static final String[] LOCATION_Y_CANDIDATES = {"locationY", "location_y"};
```

- [ ] **Step 2: Add fields to `OrderSchema` and its constructor**

In the `OrderSchema` inner class (lines 780-823), add two fields after `private final String updatedAt;` (line 798):
```java
        private final String locationX;
        private final String locationY;
```

Update the constructor signature (lines 800-803) from:
```java
        private OrderSchema(String tableName, String id, String userId, String shopId, String shipperId,
                            String receiverName, String receiverPhone, String shippingAddress,
                            String totalPrice, String deliveryFee, String paymentMethod, String paymentStatus, String payosOrderCode, String status,
                            String estimatedDeliveryTime, String isDeleted, String createdAt, String updatedAt) {
```
to:
```java
        private OrderSchema(String tableName, String id, String userId, String shopId, String shipperId,
                            String receiverName, String receiverPhone, String shippingAddress,
                            String totalPrice, String deliveryFee, String paymentMethod, String paymentStatus, String payosOrderCode, String status,
                            String estimatedDeliveryTime, String isDeleted, String createdAt, String updatedAt,
                            String locationX, String locationY) {
```

And add these two lines at the end of the constructor body (after `this.updatedAt = updatedAt;`, line 821):
```java
            this.locationX = locationX;
            this.locationY = locationY;
```

- [ ] **Step 3: Resolve the new columns when building the schema**

In `resolveSchema` (lines 314-347), change the `new OrderSchema(...)` call (lines 324-343) from:
```java
                CACHED_SCHEMA = new OrderSchema(
                        tableName,
                        resolveRequired(columns, ID_CANDIDATES),
                        resolveRequired(columns, USER_ID_CANDIDATES),
                        resolveRequired(columns, SHOP_ID_CANDIDATES),
                        resolveOptional(columns, SHIPPER_ID_CANDIDATES),
                        resolveRequired(columns, RECEIVER_NAME_CANDIDATES),
                        resolveRequired(columns, RECEIVER_PHONE_CANDIDATES),
                        resolveRequired(columns, SHIPPING_ADDRESS_CANDIDATES),
                        resolveRequired(columns, TOTAL_PRICE_CANDIDATES),
                        resolveOptional(columns, DELIVERY_FEE_CANDIDATES),
                        resolveOptional(columns, PAYMENT_METHOD_CANDIDATES),
                        resolveOptional(columns, PAYMENT_STATUS_CANDIDATES),
                        resolveOptional(columns, PAYOS_ORDER_CODE_CANDIDATES),
                        resolveOptional(columns, STATUS_CANDIDATES),
                        resolveOptional(columns, ESTIMATED_DELIVERY_TIME_CANDIDATES),
                        resolveOptional(columns, IS_DELETED_CANDIDATES),
                        resolveOptional(columns, CREATED_AT_CANDIDATES),
                        resolveOptional(columns, UPDATED_AT_CANDIDATES)
                );
```
to:
```java
                CACHED_SCHEMA = new OrderSchema(
                        tableName,
                        resolveRequired(columns, ID_CANDIDATES),
                        resolveRequired(columns, USER_ID_CANDIDATES),
                        resolveRequired(columns, SHOP_ID_CANDIDATES),
                        resolveOptional(columns, SHIPPER_ID_CANDIDATES),
                        resolveRequired(columns, RECEIVER_NAME_CANDIDATES),
                        resolveRequired(columns, RECEIVER_PHONE_CANDIDATES),
                        resolveRequired(columns, SHIPPING_ADDRESS_CANDIDATES),
                        resolveRequired(columns, TOTAL_PRICE_CANDIDATES),
                        resolveOptional(columns, DELIVERY_FEE_CANDIDATES),
                        resolveOptional(columns, PAYMENT_METHOD_CANDIDATES),
                        resolveOptional(columns, PAYMENT_STATUS_CANDIDATES),
                        resolveOptional(columns, PAYOS_ORDER_CODE_CANDIDATES),
                        resolveOptional(columns, STATUS_CANDIDATES),
                        resolveOptional(columns, ESTIMATED_DELIVERY_TIME_CANDIDATES),
                        resolveOptional(columns, IS_DELETED_CANDIDATES),
                        resolveOptional(columns, CREATED_AT_CANDIDATES),
                        resolveOptional(columns, UPDATED_AT_CANDIDATES),
                        resolveOptional(columns, LOCATION_X_CANDIDATES),
                        resolveOptional(columns, LOCATION_Y_CANDIDATES)
                );
```

- [ ] **Step 4: Include the columns in INSERT/UPDATE/SELECT column builders**

In `buildInsertSql` (lines 407-430), add before the closing `return`:
```java
        addOptionalValue(columns, values, schema.locationX, "?");
        addOptionalValue(columns, values, schema.locationY, "?");
```
(insert these two lines right after `addOptionalValue(columns, values, schema.updatedAt, "GETDATE()");`, i.e. after line 426, before line 428's `return`).

In `buildUpdateSql` (lines 432-459), add right after `addOptionalSet(sets, schema.estimatedDeliveryTime);` (line 447), before the `updatedAt` block:
```java
        addOptionalSet(sets, schema.locationX);
        addOptionalSet(sets, schema.locationY);
```

In `buildSelectColumns` (lines 514-533), add right after `addOptionalColumn(columns, schema.updatedAt);` (line 531), before `return columns;`:
```java
        addOptionalColumn(columns, schema.locationX);
        addOptionalColumn(columns, schema.locationY);
```

- [ ] **Step 5: Bind the new columns when inserting/updating**

In `bindEditableFields` (lines 470-512), add right after the `estimatedDeliveryTime` block (after line 510, before `return index;`):
```java
        if (schema.locationX != null) {
            if (order.getLocationX() != null) {
                ps.setDouble(index++, order.getLocationX());
            } else {
                ps.setNull(index++, Types.DECIMAL);
            }
        }
        if (schema.locationY != null) {
            if (order.getLocationY() != null) {
                ps.setDouble(index++, order.getLocationY());
            } else {
                ps.setNull(index++, Types.DECIMAL);
            }
        }
```

- [ ] **Step 6: Add a nullable-Double read helper and map the columns**

Add a new private helper right after `readDouble` (after line 655):
```java
    private Double readDoubleObj(ResultSet rs, String column) throws SQLException {
        if (column == null) {
            return null;
        }
        double value = rs.getDouble(column);
        return rs.wasNull() ? null : value;
    }
```

In `mapOrder` (lines 535-554), add right after `order.setUpdatedAt(readTimestamp(rs, schema.updatedAt));` (line 552), before `return order;`:
```java
        order.setLocationX(readDoubleObj(rs, schema.locationX));
        order.setLocationY(readDoubleObj(rs, schema.locationY));
```

- [ ] **Step 7: Compile-verify**

Run the standard command from Global Constraints. Expected: no errors.

- [ ] **Step 8: Commit**

```bash
git add src/main/java/org/example/daos/OrderDAOImpl.java
git commit -m "Persist and read locationX/locationY in OrderDAOImpl"
```

---

### Task 8: `CheckoutServlet` — hasLocation flag + read order coordinates on submit

**Files:**
- Modify: `src/main/java/org/example/controllers/CheckoutServlet.java`

**Interfaces:**
- Consumes: `UserAddress.getLocationX()/getLocationY()` (Task 1), `Order.setLocationX(Double)/setLocationY(Double)` (Task 6).
- Produces: request attribute `hasLocation` (Boolean) — consumed by Task 9's JSP to decide "Thêm địa chỉ" vs "Sửa địa chỉ" button text. `Order.locationX/locationY` are now set from the `orderLocationX`/`orderLocationY` POST params before the order is created.

- [ ] **Step 1: Set `hasLocation` in `doGet`**

Inside the `if (account != null) { ... }` block (lines 48-56), change:
```java
		if (account != null) {
			req.setAttribute("account", account);
			List<UserAddress> addresses = userAddressDAO.findByAccountId(account.getId());
			UserAddress defaultAddr = findDefault(addresses);
			if (defaultAddr == null && !addresses.isEmpty()) {
				defaultAddr = addresses.get(0);
			}
			req.setAttribute("defaultAddress", defaultAddr);
		}
```
to:
```java
		if (account != null) {
			req.setAttribute("account", account);
			List<UserAddress> addresses = userAddressDAO.findByAccountId(account.getId());
			UserAddress defaultAddr = findDefault(addresses);
			if (defaultAddr == null && !addresses.isEmpty()) {
				defaultAddr = addresses.get(0);
			}
			req.setAttribute("defaultAddress", defaultAddr);
			boolean hasLocation = defaultAddr != null && defaultAddr.getLocationX() != null && defaultAddr.getLocationY() != null;
			req.setAttribute("hasLocation", hasLocation);
		}
```

- [ ] **Step 2: Read `orderLocationX`/`orderLocationY` in `doPost` and set them on each created `Order`**

Add a parse helper right after `parseDouble` (after line 259):
```java
	private Double parseDoubleOrNull(String value) {
		try {
			String normalized = normalize(value);
			return normalized.isEmpty() ? null : Double.parseDouble(normalized);
		} catch (Exception e) { return null; }
	}
```

In `doPost`, right after the existing parameter reads (after line 76, `double deliveryFee = parseDouble(req.getParameter("deliveryFee"));`), add:
```java
		Double orderLocationX = parseDoubleOrNull(req.getParameter("orderLocationX"));
		Double orderLocationY = parseDoubleOrNull(req.getParameter("orderLocationY"));
```

In the per-shop order-creation loop (lines 111-121), add the two setter calls right after `order.setTotalPrice(subtotal + deliveryFee);` (line 120), before `long orderId = orderDAO.createAndReturnId(order);`:
```java
			order.setLocationX(orderLocationX);
			order.setLocationY(orderLocationY);
```

- [ ] **Step 3: Compile-verify**

Run the standard command from Global Constraints. Expected: no errors.

- [ ] **Step 4: Commit**

```bash
git add src/main/java/org/example/controllers/CheckoutServlet.java
git commit -m "Carry map coordinates from checkout form onto created Orders"
```

---

### Task 9: `checkoutThanhToan.jsp` — inline Thêm/Sửa địa chỉ modal with Leaflet map

**Files:**
- Modify: `src/main/web/checkoutThanhToan.jsp`

**Interfaces:**
- Consumes: request attributes `hasLocation` (Task 8), `defaultAddress` (existing, now also exposes `.locationX`/`.locationY` via Task 1), `cart` (existing). Posts to `POST /user/dia-chi` with `action`, `returnTo=checkout`, `cartId` (Task 3).
- Produces: hidden inputs `orderLocationX`/`orderLocationY` on the main checkout `<form>`, read by Task 8's `doPost`.

- [ ] **Step 1: Add the Leaflet CDN tags**

In `<head>`, right after the `<title>Thanh toán</title>` line (line 9), add:
```html
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
```

- [ ] **Step 2: Add modal CSS**

At the end of the existing `<style>` block, right before the closing `</style>` tag (before line 89), add:
```css
        .modal-overlay {
            position: fixed; inset: 0; background: rgba(15,22,36,0.55);
            display: flex; align-items: center; justify-content: center;
            z-index: 300; opacity: 0; pointer-events: none; transition: opacity 0.2s;
            padding: 20px;
        }
        .modal-overlay.open { opacity: 1; pointer-events: all; }
        .modal-box {
            background: #fff; border-radius: 12px;
            width: 100%; max-width: 480px; max-height: 90vh; overflow-y: auto;
            padding: 24px; box-shadow: 0 24px 70px rgba(15,22,36,0.22);
        }
        .modal-header-row { display: flex; align-items: center; justify-content: space-between; margin-bottom: 16px; }
        .modal-title-text { font-size: 16px; font-weight: 700; color: #2c3e50; }
        .modal-close-btn { background: none; border: none; cursor: pointer; font-size: 18px; color: #94a3b8; }
        .btn-secondary { background: #eef2f7; color: #2c3e50; }
```

- [ ] **Step 3: Add hidden coordinate inputs to the main checkout form**

Right after the "Địa chỉ giao hàng" `form-group` (after line 162, before the "Phương thức thanh toán" `form-group`), insert the button + hidden inputs:
```html
            <input type="hidden" name="orderLocationX" id="mainOrderLat" value="${defaultAddress.locationX}">
            <input type="hidden" name="orderLocationY" id="mainOrderLng" value="${defaultAddress.locationY}">

            <div class="form-group">
                <c:choose>
                    <c:when test="${hasLocation}">
                        <button type="button" class="btn btn-secondary" onclick="openAddrModal()">✏️ Sửa địa chỉ (đã có vị trí trên bản đồ)</button>
                    </c:when>
                    <c:otherwise>
                        <button type="button" class="btn btn-secondary" onclick="openAddrModal()">➕ Thêm địa chỉ (chọn vị trí trên bản đồ)</button>
                    </c:otherwise>
                </c:choose>
            </div>
```

- [ ] **Step 4: Add the address modal markup**

Right before the closing `</div>` of `.container` and after the main checkout `</form>` (after line 177, before line 178's `</div>`), insert:
```html
    <div class="modal-overlay" id="addrModal" onclick="closeAddrOnBg(event)">
        <div class="modal-box">
            <div class="modal-header-row">
                <span class="modal-title-text">📍 Địa chỉ nhận hàng</span>
                <button type="button" class="modal-close-btn" onclick="closeAddrModal()">✕</button>
            </div>
            <form action="${pageContext.request.contextPath}/user/dia-chi" method="post" onsubmit="return validateAddrModalForm()">
                <input type="hidden" name="action" value="${hasLocation ? 'update' : 'create'}">
                <c:if test="${hasLocation}">
                    <input type="hidden" name="id" value="${defaultAddress.id}">
                </c:if>
                <input type="hidden" name="returnTo" value="checkout">
                <input type="hidden" name="cartId" value="${cart.id}">

                <div class="form-group">
                    <label>Nhãn địa chỉ</label>
                    <select name="label">
                        <option value="Nhà">🏠 Nhà</option>
                        <option value="Công ty">🏢 Công ty</option>
                        <option value="Trường học">🎓 Trường học</option>
                        <option value="Khác">📍 Khác</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>Địa chỉ đầy đủ</label>
                    <textarea name="fullAddress" id="addrFullAddress" rows="2" required>${defaultAddress.fullAddress}</textarea>
                </div>
                <div class="form-group">
                    <label>Tên người nhận</label>
                    <input type="text" name="receiverName" value="${defaultAddress.receiverName}" required>
                </div>
                <div class="form-group">
                    <label>Số điện thoại</label>
                    <input type="text" name="receiverPhone" value="${defaultAddress.receiverPhone}" required>
                </div>
                <div class="form-group">
                    <button type="button" class="btn btn-secondary" onclick="toggleAddrMap()">📍 Chọn trên bản đồ</button>
                    <div id="addrMapWrapper" style="display:none; margin-top:10px;">
                        <div style="display:flex; gap:8px; margin-bottom:8px;">
                            <input type="text" id="addrMapSearchInput" placeholder="Tìm địa chỉ..." style="flex:1;padding:9px 12px;border:1px solid #ddd;border-radius:5px;">
                            <button type="button" id="addrMapSearchBtn" class="btn btn-secondary">Tìm</button>
                        </div>
                        <div id="addrMap" style="height:280px;border-radius:8px;overflow:hidden;"></div>
                    </div>
                    <input type="hidden" name="locationX" id="addrLat" value="${defaultAddress.locationX}">
                    <input type="hidden" name="locationY" id="addrLng" value="${defaultAddress.locationY}">
                </div>
                <c:if test="${!hasLocation}">
                    <label style="display:flex;align-items:center;gap:8px;font-size:13px;margin-bottom:14px;">
                        <input type="checkbox" name="isDefault" value="true" checked> Đặt làm địa chỉ mặc định
                    </label>
                </c:if>
                <button type="submit" class="btn btn-primary">Lưu địa chỉ</button>
            </form>
        </div>
    </div>
```

- [ ] **Step 5: Add the modal + map JS**

Right before the closing `</body>` (before line 180), add:
```html
    <script>
        function openAddrModal() {
            document.getElementById('addrModal').classList.add('open');
            document.body.style.overflow = 'hidden';
        }
        function closeAddrModal() {
            document.getElementById('addrModal').classList.remove('open');
            document.body.style.overflow = '';
        }
        function closeAddrOnBg(e) {
            if (e.target === document.getElementById('addrModal')) closeAddrModal();
        }

        function validateAddrModalForm() {
            var lat = document.getElementById('addrLat').value;
            var lng = document.getElementById('addrLng').value;
            if (!lat || !lng) {
                alert('Vui lòng chọn vị trí trên bản đồ trước khi lưu.');
                return false;
            }
            return true;
        }

        var addrMapInstance = null;
        var addrMapMarker = null;

        function toggleAddrMap() {
            document.getElementById('addrMapWrapper').style.display = 'block';
            var presetLat = document.getElementById('addrLat').value || null;
            var presetLng = document.getElementById('addrLng').value || null;
            setTimeout(function () { initAddrMap(presetLat, presetLng); }, 50);
        }

        function initAddrMap(presetLat, presetLng) {
            if (addrMapInstance) {
                addrMapInstance.invalidateSize();
                return;
            }

            var defaultLat = 21.0285, defaultLng = 105.8542;
            var startLat = presetLat ? parseFloat(presetLat) : defaultLat;
            var startLng = presetLng ? parseFloat(presetLng) : defaultLng;

            addrMapInstance = L.map('addrMap').setView([startLat, startLng], 15);

            L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                attribution: '&copy; OpenStreetMap contributors',
                maxZoom: 19
            }).addTo(addrMapInstance);

            function updateCoords(lat, lng) {
                document.getElementById('addrLat').value = lat;
                document.getElementById('addrLng').value = lng;
                document.getElementById('mainOrderLat').value = lat;
                document.getElementById('mainOrderLng').value = lng;
            }

            function reverseGeocode(lat, lng) {
                fetch('https://nominatim.openstreetmap.org/reverse?format=json&lat=' + lat + '&lon=' + lng)
                    .then(function (res) { return res.json(); })
                    .then(function (data) {
                        if (data && data.display_name) {
                            document.getElementById('addrFullAddress').value = data.display_name;
                        }
                    })
                    .catch(function () { console.warn('Khong the lay dia chi tu toa do'); });
            }

            function placeMarker(lat, lng, doReverseGeocode) {
                if (addrMapMarker) {
                    addrMapMarker.setLatLng([lat, lng]);
                } else {
                    addrMapMarker = L.marker([lat, lng], { draggable: true }).addTo(addrMapInstance);
                    addrMapMarker.on('dragend', function () {
                        var pos = addrMapMarker.getLatLng();
                        updateCoords(pos.lat, pos.lng);
                        reverseGeocode(pos.lat, pos.lng);
                    });
                }
                updateCoords(lat, lng);
                if (doReverseGeocode) reverseGeocode(lat, lng);
            }

            addrMapInstance.on('click', function (e) {
                placeMarker(e.latlng.lat, e.latlng.lng, true);
            });

            if (presetLat && presetLng) {
                placeMarker(startLat, startLng, false);
            } else if (navigator.geolocation) {
                navigator.geolocation.getCurrentPosition(
                    function (pos) { addrMapInstance.setView([pos.coords.latitude, pos.coords.longitude], 15); },
                    function () { /* denied - keep default center */ },
                    { timeout: 5000 }
                );
            }

            document.getElementById('addrMapSearchBtn').addEventListener('click', function () {
                var query = document.getElementById('addrMapSearchInput').value.trim();
                if (!query) return;
                fetch('https://nominatim.openstreetmap.org/search?format=json&q=' + encodeURIComponent(query) + '&limit=1')
                    .then(function (res) { return res.json(); })
                    .then(function (results) {
                        if (results && results.length > 0) {
                            var lat = parseFloat(results[0].lat);
                            var lng = parseFloat(results[0].lon);
                            addrMapInstance.setView([lat, lng], 16);
                            placeMarker(lat, lng, true);
                        } else {
                            alert('Không tìm thấy địa chỉ, vui lòng thử tên khác');
                        }
                    })
                    .catch(function () { alert('Không tìm được địa chỉ, vui lòng thử lại'); });
            });
        }
    </script>
```

- [ ] **Step 6: Manual browser check**

Add items to cart, go to `/checkout?cartId=<id>`:
1. If you have no saved address yet → button reads "➕ Thêm địa chỉ (chọn vị trí trên bản đồ)". Click it, fill the modal, pick a map location, save → redirected back to `/checkout?cartId=<id>` (same cart, not lost), button now reads "✏️ Sửa địa chỉ...".
2. Submit the main checkout form (COD) → order is created; query the DB (`SELECT locationX, locationY FROM Orders WHERE id = <new id>`) and confirm the coordinates match what was picked on the map.
3. Click "✏️ Sửa địa chỉ..." again, change nothing, save → still works without being forced to re-pick the map (coordinates were pre-filled).
4. In the modal, click "📍 Chọn trên bản đồ" and try the search box → same behavior as Task 4 (marker jumps to search result, reverse-geocode fills the address field).

- [ ] **Step 7: Commit**

```bash
git add src/main/web/checkoutThanhToan.jsp
git commit -m "Add inline address map picker modal to Checkout page"
```

---

### Task 10: Update project docs (mandatory per CLAUDE.md)

**Files:**
- Modify: `CRUD_DA_LAM.md`
- Modify: `PROJECT_STRUCTURE.md`

- [ ] **Step 1: Read both files to find the right insertion point**

Run:
```bash
tail -n 40 CRUD_DA_LAM.md
```
and open `PROJECT_STRUCTURE.md` to find the endpoint table used for `/user/dia-chi` (added in the prior session).

- [ ] **Step 2: Append a new section to `CRUD_DA_LAM.md`**

Add a new numbered section (using the next available number after the last one in the file) describing:
- Leaflet.js + OpenStreetMap + Nominatim integration for picking map coordinates on both the "Địa chỉ của tôi" page (`diaChi.jsp`) and the Checkout page (`checkoutThanhToan.jsp`).
- `User_Addresses.locationX/locationY` and `Orders.locationX/locationY` (both pre-existing decimal columns, confirmed via live `DatabaseMetaData` introspection, no migration needed) are now read/written by `UserAddress`/`Order` models and their DAOs.
- Coordinate picking is mandatory when creating or editing an address (client + server validation) — this also applies to editing legacy addresses that predate this feature (they must get a location picked before they can be saved).
- New optional `returnTo=checkout&cartId=<id>` params on `POST /user/dia-chi` redirect back to `/checkout?cartId=<id>` instead of `/user/dia-chi`, used by the Checkout page's inline address modal.
- Coordinate convention: `locationX` = latitude, `locationY` = longitude.

- [ ] **Step 3: Update `PROJECT_STRUCTURE.md`**

Update the description of `UserAddress.java` and `Order.java` models to mention the new `locationX`/`locationY` fields, and note that `checkoutThanhToan.jsp` now includes an inline "Thêm/Sửa địa chỉ" modal with a Leaflet map, reusing the `/user/dia-chi` endpoint via a `returnTo=checkout` redirect param.

- [ ] **Step 4: Commit**

```bash
git add CRUD_DA_LAM.md PROJECT_STRUCTURE.md
git commit -m "Document Leaflet address map feature in project docs"
```

---

### Task 11: Final full-project verification

**Files:** none (verification only)

- [ ] **Step 1: Full compile**

Run:
```bash
CP=$(find /c/Users/ADMIN/.m2 -iname "*.jar" ! -iname "*-sources.jar" | sed 's#^/c#C:#' | tr '\n' ';')
javac -encoding UTF-8 -cp "$CP" -d /tmp/dbcheck/out $(find src/main/java -name "*.java")
```
Expected: no errors.

- [ ] **Step 2: Full manual regression checklist**

On the local dev server:
1. `/user/dia-chi`: create a new address (map mandatory), edit it (coordinates pre-filled), edit a legacy NULL-coordinate address (map mandatory), set default, delete a non-default address — all still work.
2. `/checkout?cartId=<id>`: with no saved address → "Thêm địa chỉ" flow works end-to-end and the resulting order has non-null `Orders.locationX/locationY`. With a saved address that already has coordinates → "Sửa địa chỉ" flow works, checkout form's receiver name/phone/address auto-fill (pre-existing behavior, unaffected).
3. Deny browser geolocation once and confirm the map falls back to centering on Hà Nội instead of erroring out.

- [ ] **Step 3: Commit (if anything was fixed during verification)**

```bash
git add -A
git commit -m "Fix issues found during final verification of Leaflet address map feature"
```
(Skip this step if no fixes were needed.)
