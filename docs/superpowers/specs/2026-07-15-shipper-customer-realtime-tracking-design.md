# Theo dõi vị trí Shipper real-time (Shipper ↔ Khách hàng) — Design Spec

## Mục tiêu

Cho phép khách hàng xem vị trí shipper di chuyển real-time trên bản đồ ngay tại trang danh sách đơn hàng (`user/donhang.jsp`), khi đơn đang ở trạng thái `SHIPPING`. Shipper chia sẻ vị trí GPS tự động từ trang chi tiết đơn hàng (`shipper/chitietdonhang.jsp`).

Phạm vi lần này: **chỉ làm luồng Shipper ↔ Khách hàng**. Admin dashboard tổng hợp vị trí tất cả shipper sẽ làm ở giai đoạn sau, không nằm trong spec này.

## Kiến trúc tổng quan

Một WebSocket endpoint duy nhất phía server (`jakarta.websocket`), phân biệt vai trò qua query param khi kết nối:

```
wss://.../ws/tracking?role=shipper&orderId=123
wss://.../ws/tracking?role=customer&orderId=123
```

Server giữ 2 cấu trúc trong bộ nhớ (không cần bảng/cột DB mới):
- `Map<Long orderId, Set<Session>> customerWatchers` — các khách đang xem đơn đó.
- `Map<Long orderId, double[]> lastKnownLocation` — vị trí gần nhất của shipper cho đơn đó, để khách vào giữa chừng vẫn thấy vị trí ngay lập tức thay vì phải chờ lần gửi tiếp theo.

**Luồng dữ liệu:** Shipper gửi tọa độ qua WebSocket → server cập nhật `lastKnownLocation[orderId]` → server broadcast tọa độ đó cho toàn bộ `customerWatchers.get(orderId)` (không đụng tới các đơn khác — mỗi khách chỉ nhận đúng dữ liệu shipper đang giao đơn của mình, đảm bảo bảo mật/riêng tư).

## Bảo mật handshake

Trước khi chấp nhận kết nối WebSocket, server phải xác thực danh tính người kết nối:

- Dùng `ServerEndpointConfig.Configurator` (override `modifyHandshake(...)`) để copy thông tin đăng nhập hiện có trong `HttpSession` (cụ thể là `currentAccountId`, và role/roleId nếu cần) vào `EndpointConfig.getUserProperties()` — đây là cơ chế chuẩn để mang thông tin từ HTTP session sang WebSocket session vì `@ServerEndpoint` không tự nhiên truy cập được `HttpSession`.
- Trong `@OnOpen`, đọc `currentAccountId` từ `session.getUserProperties()` (đã được Configurator gắn vào), sau đó kiểm tra theo `role` truyền vào:
  - `role=shipper`: `order.getShipperId() == currentAccountId`, nếu không khớp → đóng session ngay (`session.close()` với close reason phù hợp).
  - `role=customer`: `order.getUserId() == currentAccountId`, nếu không khớp → đóng session ngay.
- Việc này ngăn người dùng đoán `orderId` để nghe lén vị trí của đơn hàng không phải của họ.

## Phía Shipper (`shipper/chitietdonhang.jsp`)

Khi trang mở và `order.staTus == 'SHIPPING'`:
- JS mở WebSocket tới `?role=shipper&orderId=...`.
- Gọi `navigator.geolocation.watchPosition(...)`; mỗi lần có tọa độ mới, gửi qua WebSocket, throttle tối thiểu ~3 giây/lần để tránh gửi quá dày.
- Dừng gửi khi: trang bị đóng/rời (`beforeunload`), hoặc đơn không còn ở trạng thái `SHIPPING` nữa.
- Nếu trình duyệt từ chối quyền định vị (`PERMISSION_DENIED`): hiển thị cảnh báo nhỏ, không chặn các chức năng khác của trang.

## Phía Khách hàng (`user/donhang.jsp`)

Với mỗi order card có `staTus == 'SHIPPING'`:
- Render `<div id="map-${order.id}"></div>` — gắn `orderId` vào id của div để JS luôn khởi tạo đúng map instance cho đúng đơn, tránh xung đột khi có nhiều đơn `SHIPPING` hiển thị cùng lúc trên danh sách.
- JS khởi tạo Leaflet map trong div đó với 3 marker:
  - 🏪 Cửa hàng — cố định, từ `order.shop.locationX/Y` (đã có sẵn từ tính năng shop-profile-location trước đó).
  - 🏠 Điểm giao — cố định, từ `order.locationX/Y` (đã có sẵn từ tính năng checkout-location trước đó).
  - 🛵 Shipper — marker động; khởi tạo ngay tại `lastKnownLocation` nếu server trả về khi mở kết nối, sau đó cập nhật vị trí mỗi lần nhận broadcast mới.
- Gọi `map.fitBounds(...)` chứa cả 3 điểm ngay khi khởi tạo, để khách thấy toàn cảnh hành trình mà không cần tự zoom/pan.
- Mở WebSocket tới `?role=customer&orderId=...` khi card hiện ra; đóng khi rời trang hoặc đơn chuyển sang `DONE`/`CANCELLED`.
- Nếu chưa có `lastKnownLocation` (shipper chưa gửi lần nào) → chỉ hiện 2 marker tĩnh; marker shipper xuất hiện khi có dữ liệu đầu tiên.

## Tránh lỗi bản đồ bị xám/vỡ hình (Leaflet trong container ẩn/động)

Vì map được khởi tạo trong 1 div nằm bên trong order card (có thể đang bị `display:none` hoặc mới render động), Leaflet sẽ tính sai kích thước container nếu gọi `L.map()` trước khi div có kích thước thật. Vì vậy trong `orderTrackingMap.js`, ngay sau khi khởi tạo map (hoặc mỗi khi card đơn hàng chứa map đó được mở/hiện ra), phải gọi `map.invalidateSize()` để Leaflet tính lại kích thước container và render đúng, tránh tình trạng bản đồ hiển thị xám/vỡ tile.

## Dọn dẹp tài nguyên phía server (tránh rò rỉ bộ nhớ)

Trong `@OnClose` của endpoint:
- Gỡ session khỏi `customerWatchers.get(orderId)`.
- Sau khi gỡ, nếu `Set<Session>` đó rỗng (`isEmpty()`), gọi `customerWatchers.remove(orderId)` để xóa hẳn key khỏi map — không để lại các Set rỗng tồn đọng vô thời hạn trong RAM.
- `lastKnownLocation[orderId]` có thể dọn khi đơn chuyển trạng thái khác `SHIPPING` (đơn giản nhất: xóa khi nhận sự kiện đóng kết nối từ phía shipper, hoặc theo TTL nếu cần chặt chẽ hơn — không bắt buộc trong phạm vi spec này).

## Thư viện JS dùng chung

Tạo file `orderTrackingMap.js` chứa hàm khởi tạo map 3-marker + fitBounds + invalidateSize, dùng riêng cho `donhang.jsp` (không sửa các trang Leaflet khác đang có, tránh phá vỡ tính năng đã hoàn thiện trước đó ở `diaChi.jsp`, `Shopprofile.jsp`, `Quanlybill.jsp`, `HoaDonShop.jsp`).

## Dependency mới

Thêm vào `pom.xml`: `jakarta.websocket-api` (nhóm `jakarta.websocket`, bản tương thích Jakarta EE 10, scope `provided` — runtime implementation do servlet container/Tomcat cung cấp).

## Ngoài phạm vi (Out of scope)

- Admin dashboard xem toàn bộ vị trí shipper (làm sau).
- Lưu lịch sử di chuyển của shipper vào DB (chỉ giữ vị trí gần nhất trong bộ nhớ).
- Route/đường đi thực tế (routing API) — chỉ vẽ marker, không vẽ polyline đường đi.
