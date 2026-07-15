# Theo dõi vị trí Shipper real-time (Shipper ↔ Khách hàng) Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Cho khách hàng xem vị trí shipper di chuyển real-time trên bản đồ tại `user/donhang.jsp` khi đơn ở trạng thái `SHIPPING`, với shipper tự động chia sẻ GPS từ `shipper/chitietdonhang.jsp`.

**Architecture:** Một WebSocket endpoint (`jakarta.websocket`) tại `/ws/tracking`, phân biệt vai trò qua query param `role=shipper|customer` và `orderId`. Server giữ 2 cấu trúc trong bộ nhớ (`Map<Long, Set<Session>> customerWatchers`, `Map<Long, double[]> lastKnownLocation`) — không cần bảng/cột DB mới. Xác thực qua `ServerEndpointConfig.Configurator` copy `currentAccountId` từ `HttpSession` vào `userProperties`.

**Tech Stack:** Jakarta EE 10 (`jakarta.websocket-api`), JSP/JSTL, vanilla JS, Leaflet 1.9.4 (đã dùng sẵn trong project), `org.json` (đã có trong `pom.xml`, dùng thay cho `jakarta.json` vì không cần thêm dependency mới).

## Global Constraints

- Chỉ làm luồng **Shipper ↔ Khách hàng**. Không làm Admin dashboard (out of scope, spec đã ghi rõ).
- Không tạo bảng/cột DB mới cho vị trí — chỉ giữ trong bộ nhớ server (`ConcurrentHashMap`), đúng theo phương án A đã chọn.
- Bảo mật handshake bắt buộc dùng `ServerEndpointConfig.Configurator` copy `currentAccountId` từ `HttpSession` vào `userProperties` — không dùng cách nào khác (ví dụ truyền accountId qua query param, vì có thể giả mạo).
- `@OnClose` bắt buộc phải `customerWatchers.remove(orderId)` khi `Set<Session>` rỗng sau khi gỡ — không được để lại Set rỗng tồn đọng trong RAM.
- `orderTrackingMap.js` bắt buộc gọi `map.invalidateSize()` sau khi khởi tạo/mở map để tránh bản đồ xám/vỡ hình do container ẩn/động.
- Mỗi map div trong `donhang.jsp` bắt buộc dùng `id="map-${order.id}"` (đã chốt với người dùng) để tránh trùng instance khi nhiều đơn `SHIPPING` cùng hiển thị.
- Map khách hàng phải hiển thị đủ 3 điểm (Shop, điểm giao, shipper) và gọi `map.fitBounds(...)` chứa cả 3 khi khởi tạo.
- **Không có framework test (JUnit) trong project này** (xác nhận: không có `src/test`, không có dependency JUnit trong `pom.xml`). Theo đúng quy ước đã dùng ở các tính năng trước trong project (location picker cho UserAddress/Order/Shop), bước "kiểm thử" trong plan này là: (1) biên dịch bằng `javac` với classpath từ `.m2`, (2) kiểm thử thủ công qua trình duyệt (mô tả chi tiết từng bước thao tác). Không viết JUnit test giả cho project này.
- Sau khi hoàn thành, **phải cập nhật `CRUD_DA_LAM.md` và `PROJECT_STRUCTURE.md`** theo yêu cầu trong `CLAUDE.md`.

---

### Task 1: Thêm dependency `jakarta.websocket-api` vào `pom.xml`

**Files:**
- Modify: `pom.xml`

**Interfaces:**
- Produces: `jakarta.websocket.*` API khả dụng cho compile ở các task sau (Task 2, Task 3).

- [ ] **Step 1: Thêm dependency**

Mở `pom.xml`, thêm dependency sau vào trong khối `<dependencies>` (ngay sau dependency `jakarta.servlet-api`):

```xml
        <dependency>
            <groupId>jakarta.websocket</groupId>
            <artifactId>jakarta.websocket-api</artifactId>
            <version>2.1.1</version>
            <scope>provided</scope>
        </dependency>
```

`scope=provided` vì runtime implementation (Tomcat's `tomcat-websocket.jar`) đã có sẵn trong servlet container lúc chạy — giống cách `jakarta.servlet-api` đang được khai báo.

- [ ] **Step 2: Xác nhận Maven resolve được dependency**

Run: `mvn -q dependency:resolve` (hoặc trong IntelliJ: reload Maven project).
Expected: không có lỗi "could not resolve dependency" cho `jakarta.websocket-api`.

- [ ] **Step 3: Commit**

```bash
git add pom.xml
git commit -m "build: add jakarta.websocket-api dependency for realtime tracking"
```

---

### Task 2: `HttpSessionConfigurator` — copy currentAccountId từ HttpSession vào WebSocket userProperties

**Files:**
- Create: `src/main/java/org/example/websocket/HttpSessionConfigurator.java`

**Interfaces:**
- Consumes: `HttpSession` attribute `"account"` (kiểu `org.example.models.Account`, đã xác nhận có `getId()` — dùng ở mọi servlet hiện có trong project, ví dụ `UserOrderServlet.java:30`, `ShipperOrderServlet.java:167`).
- Produces: key `"currentAccountId"` (kiểu `Long`) trong `ServerEndpointConfig.getUserProperties()`, được `TrackingEndpoint` (Task 3) đọc lại trong `@OnOpen`.

- [ ] **Step 1: Tạo file**

```java
package org.example.websocket;

import jakarta.servlet.http.HttpSession;
import jakarta.websocket.HandshakeResponse;
import jakarta.websocket.server.HandshakeRequest;
import jakarta.websocket.server.ServerEndpointConfig;
import org.example.models.Account;

public class HttpSessionConfigurator extends ServerEndpointConfig.Configurator {

    @Override
    public void modifyHandshake(ServerEndpointConfig sec, HandshakeRequest request, HandshakeResponse response) {
        Object httpSessionObj = request.getHttpSession();
        if (httpSessionObj instanceof HttpSession) {
            HttpSession httpSession = (HttpSession) httpSessionObj;
            Object accountObj = httpSession.getAttribute("account");
            if (accountObj instanceof Account) {
                sec.getUserProperties().put("currentAccountId", ((Account) accountObj).getId());
            }
        }
    }
}
```

`request.getHttpSession()` chỉ trả về session khi client đã có session HTTP hợp lệ trước lúc mở WebSocket (đúng với luồng thực tế: shipper/khách phải đăng nhập và đang xem trang JSP mới mở kết nối). Nếu không có session hoặc chưa đăng nhập, `currentAccountId` sẽ không được set, và `TrackingEndpoint` (Task 3) sẽ từ chối kết nối vì không xác thực được.

- [ ] **Step 2: Biên dịch để xác nhận không có lỗi cú pháp**

Run:
```bash
CP=$(find /c/Users/ADMIN/.m2 -iname "*.jar" ! -iname "*-sources.jar" | sed 's#^/c#C:#' | tr '\n' ';')
javac -encoding UTF-8 -cp "$CP" -d /tmp/dbcheck/out src/main/java/org/example/websocket/HttpSessionConfigurator.java src/main/java/org/example/models/Account.java
```
Expected: không có lỗi biên dịch.

- [ ] **Step 3: Commit**

```bash
git add src/main/java/org/example/websocket/HttpSessionConfigurator.java
git commit -m "feat: add HttpSessionConfigurator for WebSocket handshake auth"
```

---

### Task 3: `TrackingEndpoint` — WebSocket server endpoint (relay + xác thực + dọn dẹp)

**Files:**
- Create: `src/main/java/org/example/websocket/TrackingEndpoint.java`

**Interfaces:**
- Consumes:
  - `HttpSessionConfigurator` (Task 2) — cung cấp `currentAccountId` qua `EndpointConfig.getUserProperties()`.
  - `OrderDAO.findById(long id)` (đã có, trả về `org.example.models.Order` với `getUserId()`, `getShipperId()`).
  - `org.json.JSONObject` (dependency `org.json:json:20240303` đã có sẵn trong `pom.xml`).
- Produces: endpoint `ws(s)://<host>/<contextPath>/ws/tracking?role=shipper|customer&orderId=<id>`, dùng bởi Task 4 (shipper JS) và Task 5 (`orderTrackingMap.js`). Message gửi lên từ shipper là JSON `{"lat":<double>,"lng":<double>}`; message broadcast xuống khách hàng có cùng format.

- [ ] **Step 1: Tạo file**

```java
package org.example.websocket;

import jakarta.websocket.CloseReason;
import jakarta.websocket.EndpointConfig;
import jakarta.websocket.OnClose;
import jakarta.websocket.OnError;
import jakarta.websocket.OnMessage;
import jakarta.websocket.OnOpen;
import jakarta.websocket.Session;
import jakarta.websocket.server.ServerEndpoint;
import org.example.daos.OrderDAO;
import org.example.daos.OrderDAOImpl;
import org.example.models.Order;
import org.json.JSONObject;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.CopyOnWriteArraySet;

@ServerEndpoint(value = "/ws/tracking", configurator = HttpSessionConfigurator.class)
public class TrackingEndpoint {

    private static final OrderDAO orderDAO = new OrderDAOImpl();

    private static final Map<Long, Set<Session>> customerWatchers = new ConcurrentHashMap<>();
    private static final Map<Long, double[]> lastKnownLocation = new ConcurrentHashMap<>();

    @OnOpen
    public void onOpen(Session session, EndpointConfig config) {
        Map<String, List<String>> params = session.getRequestParameterMap();
        String role = firstParam(params, "role");
        long orderId = parseLong(firstParam(params, "orderId"));

        Object accountIdObj = config.getUserProperties().get("currentAccountId");
        long currentAccountId = (accountIdObj instanceof Long) ? (Long) accountIdObj : -1L;

        Order order = orderId > 0 ? orderDAO.findById(orderId) : null;
        boolean authorized = order != null && currentAccountId != -1L && (
                ("shipper".equals(role) && order.getShipperId() == currentAccountId) ||
                ("customer".equals(role) && order.getUserId() == currentAccountId)
        );

        if (!authorized) {
            closeQuietly(session, "unauthorized");
            return;
        }

        session.getUserProperties().put("orderId", orderId);
        session.getUserProperties().put("role", role);

        if ("customer".equals(role)) {
            customerWatchers.computeIfAbsent(orderId, k -> new CopyOnWriteArraySet<>()).add(session);
            double[] last = lastKnownLocation.get(orderId);
            if (last != null) {
                sendQuietly(session, locationJson(last[0], last[1]));
            }
        }
    }

    @OnMessage
    public void onMessage(String message, Session session) {
        if (!"shipper".equals(session.getUserProperties().get("role"))) {
            return;
        }
        Long orderId = (Long) session.getUserProperties().get("orderId");
        if (orderId == null) {
            return;
        }

        JSONObject json = new JSONObject(message);
        double lat = json.getDouble("lat");
        double lng = json.getDouble("lng");
        lastKnownLocation.put(orderId, new double[]{lat, lng});

        Set<Session> watchers = customerWatchers.get(orderId);
        if (watchers == null) {
            return;
        }
        String payload = locationJson(lat, lng);
        for (Session watcher : watchers) {
            sendQuietly(watcher, payload);
        }
    }

    @OnClose
    public void onClose(Session session) {
        Long orderId = (Long) session.getUserProperties().get("orderId");
        if (orderId == null) {
            return;
        }
        Set<Session> watchers = customerWatchers.get(orderId);
        if (watchers != null) {
            watchers.remove(session);
            if (watchers.isEmpty()) {
                customerWatchers.remove(orderId);
            }
        }
    }

    @OnError
    public void onError(Session session, Throwable throwable) {
        // Không cần xử lý gì thêm — container sẽ tự đóng session lỗi.
    }

    private static String locationJson(double lat, double lng) {
        return new JSONObject().put("lat", lat).put("lng", lng).toString();
    }

    private static String firstParam(Map<String, List<String>> params, String name) {
        List<String> values = params.get(name);
        return (values != null && !values.isEmpty()) ? values.get(0) : null;
    }

    private static long parseLong(String s) {
        try {
            return Long.parseLong(s);
        } catch (Exception e) {
            return -1L;
        }
    }

    private static void closeQuietly(Session session, String reason) {
        try {
            session.close(new CloseReason(CloseReason.CloseCodes.CANNOT_ACCEPT, reason));
        } catch (IOException ignored) {
        }
    }

    private static void sendQuietly(Session session, String payload) {
        try {
            session.getBasicRemote().sendText(payload);
        } catch (IOException ignored) {
        }
    }
}
```

Điểm quan trọng cần giữ đúng (khớp spec):
- `@OnClose` gỡ session khỏi `Set`, và nếu `Set` rỗng thì `customerWatchers.remove(orderId)` — đúng yêu cầu dọn RAM.
- `onOpen` từ chối kết nối (`closeQuietly`) nếu `order` không tồn tại, hoặc `currentAccountId` không khớp `order.getShipperId()`/`order.getUserId()` tùy `role` — đúng yêu cầu bảo mật.
- Khách hàng kết nối vào giữa chừng vẫn nhận được `lastKnownLocation` ngay lập tức (đúng phương án A đã chọn).

- [ ] **Step 2: Biên dịch để xác nhận không có lỗi**

Run:
```bash
CP=$(find /c/Users/ADMIN/.m2 -iname "*.jar" ! -iname "*-sources.jar" | sed 's#^/c#C:#' | tr '\n' ';')
javac -encoding UTF-8 -cp "$CP" -d /tmp/dbcheck/out $(find src/main/java -name "*.java")
```
Expected: biên dịch toàn bộ project thành công, không lỗi (bao gồm cả 2 file mới trong `org.example.websocket`).

- [ ] **Step 3: Commit**

```bash
git add src/main/java/org/example/websocket/TrackingEndpoint.java
git commit -m "feat: add TrackingEndpoint WebSocket for shipper-customer realtime location relay"
```

---

### Task 4: `chitietdonhang.jsp` — Shipper tự động gửi GPS khi đơn đang SHIPPING

**Files:**
- Modify: `src/main/web/shipper/chitietdonhang.jsp` (thêm script vào cuối, trước `</body>`, sau khối script hiện có ở dòng 373-440 và 455-471)

**Interfaces:**
- Consumes: endpoint `TrackingEndpoint` (Task 3) tại `/ws/tracking?role=shipper&orderId=...`.
- Produces: không có interface nào cho task khác dùng — đây là điểm cuối (leaf) của luồng gửi.

- [ ] **Step 1: Thêm script gửi vị trí, chèn ngay trước thẻ `</body>` cuối file (dòng 471-472 hiện tại)**

```html
<c:if test="${order.staTus == 'SHIPPING'}">
<script>
(function () {
    var orderId = ${order.id};
    var protocol = location.protocol === 'https:' ? 'wss://' : 'ws://';
    var wsUrl = protocol + location.host + '${pageContext.request.contextPath}/ws/tracking?role=shipper&orderId=' + orderId;
    var socket = new WebSocket(wsUrl);
    var watchId = null;
    var lastSentAt = 0;
    var MIN_INTERVAL_MS = 3000;

    function sendPosition(position) {
        var now = Date.now();
        if (now - lastSentAt < MIN_INTERVAL_MS) return;
        lastSentAt = now;
        if (socket.readyState === WebSocket.OPEN) {
            socket.send(JSON.stringify({
                lat: position.coords.latitude,
                lng: position.coords.longitude
            }));
        }
    }

    function handleGeoError(err) {
        console.warn('Không thể lấy vị trí GPS:', err.message);
    }

    socket.addEventListener('open', function () {
        if (navigator.geolocation) {
            watchId = navigator.geolocation.watchPosition(sendPosition, handleGeoError, {
                enableHighAccuracy: true,
                maximumAge: 5000
            });
        }
    });

    window.addEventListener('beforeunload', function () {
        if (watchId !== null && navigator.geolocation) {
            navigator.geolocation.clearWatch(watchId);
        }
        if (socket.readyState === WebSocket.OPEN) {
            socket.close();
        }
    });
})();
</script>
</c:if>
```

- [ ] **Step 2: Kiểm thử thủ công**

1. Build và deploy project, đăng nhập với tài khoản shipper đã có đơn ở trạng thái `SHIPPING` (dùng luồng có sẵn: nhận đơn ở `nhanDon.jsp` → "Xác nhận đã lấy hàng" để chuyển trạng thái sang `SHIPPING`).
2. Mở `shipper/chitietdonhang.jsp?...` (qua link "📋 Đơn hàng nhận" → chọn đơn `SHIPPING`).
3. Mở DevTools → tab Network → filter `WS`, xác nhận có kết nối WebSocket tới `/ws/tracking?role=shipper&orderId=...` với status `101 Switching Protocols`.
4. Trình duyệt hỏi quyền định vị — bấm "Allow". Xác nhận trong tab Network (frame) hoặc Console log không có lỗi.
5. Nếu từ chối quyền định vị: xác nhận trang không bị crash/lỗi JS khác (chỉ log `console.warn`).

Expected: kết nối WebSocket mở thành công, không có lỗi console (trừ warning geolocation nếu từ chối quyền).

- [ ] **Step 3: Commit**

```bash
git add src/main/web/shipper/chitietdonhang.jsp
git commit -m "feat: shipper auto-sends GPS location via WebSocket while SHIPPING"
```

---

### Task 5: `UserOrderServlet` + `orderTrackingMap.js` + `donhang.jsp` — Bản đồ 3-marker cho khách hàng

**Files:**
- Modify: `src/main/java/org/example/controllers/UserOrderServlet.java`
- Create: `src/main/web/assets/js/orderTrackingMap.js`
- Modify: `src/main/web/user/donhang.jsp`

**Interfaces:**
- Consumes:
  - `TrackingEndpoint` (Task 3) tại `/ws/tracking?role=customer&orderId=...`, nhận message JSON `{"lat":..,"lng":..}`.
  - `Order.getLocationX()/getLocationY()` (đã có sẵn — tọa độ điểm giao).
  - `Shop.getLocationX()/getLocationY()` (đã có sẵn — tọa độ cửa hàng).
- Produces: hàm JS toàn cục `initOrderTrackingMap(containerId, shopLat, shopLng, destLat, destLng, wsUrl)` trong `orderTrackingMap.js`, gọi từ `donhang.jsp`.

- [ ] **Step 1: Thêm `shopCoords` map vào `UserOrderServlet.java`**

Sửa `src/main/java/org/example/controllers/UserOrderServlet.java`, trong vòng lặp `for (Order o : orders)` (dòng 43-53 hiện tại), thêm việc thu thập tọa độ shop cùng lúc với `shopNames`:

```java
        List<Order> orders = orderDAO.findByUserId(account.getId());

        // Gắn tên shop và trạng thái đã feedback cho mỗi đơn
        java.util.Map<Long, String> shopNames = new java.util.HashMap<>();
        java.util.Map<Long, double[]> shopCoords = new java.util.HashMap<>();
        java.util.Map<Long, Boolean> feedbackShop = new java.util.HashMap<>();
        java.util.Map<Long, Boolean> feedbackShipper = new java.util.HashMap<>();

        for (Order o : orders) {
            long shopId = o.getShopId();
            if (!shopNames.containsKey(shopId)) {
                Shop shop = shopDAO.selectShopById(shopId);
                shopNames.put(shopId, shop != null ? shop.getShopName() : "Shop #" + shopId);
                if (shop != null && shop.getLocationX() != null && shop.getLocationY() != null) {
                    shopCoords.put(shopId, new double[]{shop.getLocationX(), shop.getLocationY()});
                }
            }
            feedbackShop.put(o.getId(),
                    feedbackDAO.existsByOrderAndType(o.getId(), "USER", "SHOP"));
            feedbackShipper.put(o.getId(),
                    feedbackDAO.existsByOrderAndType(o.getId(), "USER", "SHIPPER"));
        }

        req.setAttribute("orders", orders);
        req.setAttribute("shopNames", shopNames);
        req.setAttribute("shopCoords", shopCoords);
        req.setAttribute("feedbackShop", feedbackShop);
        req.setAttribute("feedbackShipper", feedbackShipper);
        req.getRequestDispatcher("/user/donhang.jsp").forward(req, resp);
```

(Chỉ thêm dòng khai báo `shopCoords`, dòng `if (shop != null ...)` bên trong vòng lặp, và dòng `req.setAttribute("shopCoords", shopCoords);` — phần còn lại giữ nguyên như hiện tại.)

- [ ] **Step 2: Biên dịch xác nhận `UserOrderServlet.java` không lỗi**

Run:
```bash
CP=$(find /c/Users/ADMIN/.m2 -iname "*.jar" ! -iname "*-sources.jar" | sed 's#^/c#C:#' | tr '\n' ';')
javac -encoding UTF-8 -cp "$CP" -d /tmp/dbcheck/out $(find src/main/java -name "*.java")
```
Expected: biên dịch thành công.

- [ ] **Step 3: Tạo `orderTrackingMap.js`**

```javascript
function initOrderTrackingMap(containerId, shopLat, shopLng, destLat, destLng, wsUrl) {
    var container = document.getElementById(containerId);
    if (!container || container._trackingMap) {
        return;
    }

    var map = L.map(containerId);
    container._trackingMap = map;

    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        maxZoom: 19,
        attribution: '&copy; OpenStreetMap'
    }).addTo(map);

    var bounds = [];
    var shopMarker = null;
    var destMarker = null;
    var shipperMarker = null;

    if (shopLat != null && shopLng != null) {
        shopMarker = L.marker([shopLat, shopLng]).addTo(map).bindPopup('🏪 Cửa hàng');
        bounds.push([shopLat, shopLng]);
    }
    if (destLat != null && destLng != null) {
        destMarker = L.marker([destLat, destLng]).addTo(map).bindPopup('🏠 Điểm giao');
        bounds.push([destLat, destLng]);
    }

    if (bounds.length > 0) {
        map.fitBounds(bounds, {padding: [30, 30]});
    } else {
        map.setView([21.0278, 105.8342], 13);
    }

    setTimeout(function () {
        map.invalidateSize();
    }, 0);

    var socket = new WebSocket(wsUrl);
    socket.addEventListener('message', function (event) {
        var data = JSON.parse(event.data);
        var latlng = [data.lat, data.lng];

        if (shipperMarker === null) {
            shipperMarker = L.marker(latlng, {
                icon: L.divIcon({className: '', html: '🛵', iconSize: [24, 24]})
            }).addTo(map).bindPopup('🛵 Shipper');
        } else {
            shipperMarker.setLatLng(latlng);
        }

        var allBounds = bounds.slice();
        allBounds.push(latlng);
        map.fitBounds(allBounds, {padding: [30, 30]});
    });

    window.addEventListener('beforeunload', function () {
        if (socket.readyState === WebSocket.OPEN || socket.readyState === WebSocket.CONNECTING) {
            socket.close();
        }
    });
}
```

- [ ] **Step 4: Sửa `donhang.jsp` — thêm Leaflet CDN, map div, và khởi tạo map cho đơn `SHIPPING`**

Thêm vào `<head>`, ngay sau dòng `<link href="https://fonts.googleapis.com...">` (dòng 11 hiện tại):

```html
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/orderTrackingMap.js"></script>
```

Trong `<c:forEach var="order" items="${orders}">` (dòng 113-167 hiện tại), thêm khối bản đồ ngay sau `</div>` đóng `.order-meta` (sau dòng 140, trước `<c:if test="${order.staTus eq 'DONE'}">` ở dòng 142):

```html
                        <c:if test="${order.staTus eq 'SHIPPING'}">
                            <div id="map-${order.id}" style="height:220px;border-radius:12px;margin-top:10px;overflow:hidden;"></div>
                        </c:if>
```

Thêm script khởi tạo map ngay trước `</body>` (dòng 173 hiện tại):

```html
<script>
    (function () {
        var protocol = location.protocol === 'https:' ? 'wss://' : 'ws://';
        var contextPath = '${pageContext.request.contextPath}';
        <c:forEach var="order" items="${orders}">
        <c:if test="${order.staTus eq 'SHIPPING'}">
        (function () {
            var shopCoord = ${not empty shopCoords[order.shopId] ? 'true' : 'false'};
            var shopLat = ${not empty shopCoords[order.shopId] ? shopCoords[order.shopId][0] : 'null'};
            var shopLng = ${not empty shopCoords[order.shopId] ? shopCoords[order.shopId][1] : 'null'};
            var destLat = ${not empty order.locationX ? order.locationX : 'null'};
            var destLng = ${not empty order.locationY ? order.locationY : 'null'};
            var wsUrl = protocol + location.host + contextPath + '/ws/tracking?role=customer&orderId=${order.id}';
            initOrderTrackingMap('map-${order.id}', shopLat, shopLng, destLat, destLng, wsUrl);
        })();
        </c:if>
        </c:forEach>
    })();
</script>
```

- [ ] **Step 5: Kiểm thử thủ công**

1. Build + deploy, đăng nhập tài khoản khách hàng có đơn ở trạng thái `SHIPPING` (dùng cùng đơn đã test ở Task 4).
2. Mở `user/donhang.jsp`. Xác nhận card đơn `SHIPPING` hiện bản đồ với 2 marker tĩnh (🏪 cửa hàng, 🏠 điểm giao) ngay cả khi shipper chưa gửi vị trí nào — và bản đồ hiển thị rõ ràng, không bị xám/vỡ (nhờ `invalidateSize()`).
3. Mở đồng thời trang shipper (`chitietdonhang.jsp` của Task 4) ở tab/trình duyệt khác cho cùng đơn, cho phép quyền định vị.
4. Quan sát tab khách hàng: marker 🛵 xuất hiện và cập nhật vị trí theo thời gian thực (có thể giả lập di chuyển bằng DevTools → Sensors → Location trên tab shipper).
5. Đóng tab shipper — xác nhận tab khách hàng không lỗi console, marker shipper đứng yên ở vị trí cuối cùng (đúng thiết kế, không cần xử lý "shipper mất kết nối" ngoài phạm vi spec).

Expected: đủ 3 marker hiển thị đúng vai trò, `fitBounds` bao trọn các điểm, không có lỗi console.

- [ ] **Step 6: Commit**

```bash
git add src/main/java/org/example/controllers/UserOrderServlet.java src/main/web/assets/js/orderTrackingMap.js src/main/web/user/donhang.jsp
git commit -m "feat: customer realtime shipper tracking map on donhang.jsp"
```

---

### Task 6: Cập nhật tài liệu + kiểm tra tổng thể

**Files:**
- Modify: `CRUD_DA_LAM.md`
- Modify: `PROJECT_STRUCTURE.md`

**Interfaces:**
- Consumes: toàn bộ thay đổi từ Task 1-5.
- Produces: không có (task cuối).

- [ ] **Step 1: Cập nhật `CRUD_DA_LAM.md`**

Thêm mục mới mô tả tính năng: WebSocket endpoint `/ws/tracking` (file `TrackingEndpoint.java`, `HttpSessionConfigurator.java`), luồng shipper gửi GPS (`chitietdonhang.jsp`), luồng khách hàng xem bản đồ 3-marker (`donhang.jsp`, `orderTrackingMap.js`, thay đổi `UserOrderServlet.java` thêm `shopCoords`). Ghi rõ: không có bảng/cột DB mới, dữ liệu vị trí chỉ giữ trong bộ nhớ server.

- [ ] **Step 2: Cập nhật `PROJECT_STRUCTURE.md`**

Thêm các file mới vào cây thư mục: `src/main/java/org/example/websocket/HttpSessionConfigurator.java`, `src/main/java/org/example/websocket/TrackingEndpoint.java`, `src/main/web/assets/js/orderTrackingMap.js`.

- [ ] **Step 3: Biên dịch toàn bộ project lần cuối**

Run:
```bash
CP=$(find /c/Users/ADMIN/.m2 -iname "*.jar" ! -iname "*-sources.jar" | sed 's#^/c#C:#' | tr '\n' ';')
javac -encoding UTF-8 -cp "$CP" -d /tmp/dbcheck/out $(find src/main/java -name "*.java")
```
Expected: 0 lỗi.

- [ ] **Step 4: Commit**

```bash
git add CRUD_DA_LAM.md PROJECT_STRUCTURE.md
git commit -m "docs: update CRUD_DA_LAM and PROJECT_STRUCTURE for realtime tracking feature"
```
