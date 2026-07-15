# Thiết kế: Hiển thị vị trí giao hàng (bản đồ) cho phía shop

Ngày: 2026-07-15

## Bối cảnh

`Orders.locationX`/`locationY` đã được lưu sẵn từ tính năng Leaflet address map (xem [2026-07-15-leaflet-address-map-design.md](2026-07-15-leaflet-address-map-design.md)) — mỗi đơn hàng tạo qua Checkout mang theo tọa độ giao hàng (có thể NULL với đơn cũ hoặc đơn không pin map). Hiện phía shop (`HoaDonShop.jsp`, `Quanlybill.jsp`) chỉ hiển thị `shippingAddress` dạng chữ, chưa có cách xem vị trí trên bản đồ.

Mục tiêu: cho phép shop xem vị trí giao hàng trên bản đồ ngay trong giao diện quản lý đơn, tái sử dụng toàn bộ dữ liệu và hạ tầng (Leaflet CDN, OpenStreetMap tile) đã có từ tính năng trước — **chỉ đọc**, không chỉnh sửa tọa độ.

`Shop.java` cũng đã có sẵn `locationX`/`locationY` (đã lưu sẵn qua form đăng ký/duyệt shop), và cả `HoaDonShop.jsp` lẫn `Quanlybill.jsp` đều đã có sẵn `sessionScope.currentShop` (đặt vào `currentShop` scope request ở đầu mỗi trang, dòng 5). Vì vậy bản đồ sẽ hiển thị **2 marker** — vị trí shop và vị trí giao hàng — trên cùng 1 khung nhìn, giúp shop hình dung khoảng cách/hướng giao hàng mà không cần thêm truy vấn DB nào.

## Phạm vi

1. **`HoaDonShop.jsp`** (trang chi tiết 1 hóa đơn): nhúng bản đồ Leaflet chỉ-đọc ngay dưới dòng "Địa chỉ giao hàng", hiển thị marker giao hàng tại `bill.order.locationX/locationY` (nếu có) và marker shop tại `currentShop.locationX/locationY` (nếu có), tự động `fitBounds` để thấy cả 2 điểm khi cả 2 đều tồn tại.
2. **`Quanlybill.jsp`** (trang danh sách đơn hàng): mỗi dòng có tọa độ giao hàng hiển thị nút "📍", bấm vào mở modal chứa bản đồ Leaflet chỉ-đọc cho đơn đó, cũng hiển thị cả marker shop (dùng chung `currentShop.locationX/locationY` cho mọi dòng, không đổi theo từng đơn).

Không thuộc phạm vi: chỉnh sửa/thay đổi tọa độ (đơn hàng hay shop) từ giao diện này; tính khoảng cách/chỉ đường thực tế (routing); hiển thị nhiều đơn cùng lúc trên 1 bản đồ; thay đổi Model/DAO (`Shop`, `Order` đều đã có field cần thiết).

## Kiến trúc & công nghệ

- Tái sử dụng nguyên trạng Leaflet.js 1.9.4 CDN (`unpkg.com/leaflet@1.9.4`) + OpenStreetMap tile layer + attribution `© OpenStreetMap contributors`, đúng pattern đã dùng ở `diaChi.jsp`/`checkoutThanhToan.jsp`.
- Không có build step → tiếp tục nhúng `<script>`/`<link>` thẳng trong từng JSP, theo đúng convention hiện tại của codebase (mỗi JSP tự chứa CSS/JS riêng, namespace hàm JS riêng để tránh đụng độ).
- Bản đồ ở cả 2 nơi đều **chỉ đọc**: không gắn listener `click`/`dragend` lên marker, không có ô search, không gọi Nominatim — khác với map ở tính năng trước (vốn dùng để pin/chỉnh vị trí).
- Quy ước tọa độ giữ nguyên: `locationX` = latitude, `locationY` = longitude (`[lat, lng]` khi gọi Leaflet).
- Marker shop dùng icon/màu khác marker giao hàng để phân biệt (Leaflet mặc định chỉ có 1 kiểu icon xanh dương — dùng CSS `filter: hue-rotate(...)` trên `L.icon` hoặc đơn giản hơn: `L.divIcon` với emoji `🏠` cho shop và giữ marker mặc định cho điểm giao hàng). Chọn `L.divIcon` với emoji vì không cần thêm asset ảnh, nhất quán với style icon `📍`/`✏️`/`➕` đã dùng trong toàn bộ tính năng trước.

## `HoaDonShop.jsp` — bản đồ nhúng trực tiếp

- Thêm Leaflet CDN tags (`<link>`/`<script>`) vào `<head>` của trang.
- Ngay sau dòng hiện có:
  ```jsp
  <div class="info-row"><span>Địa chỉ giao hàng</span><span><c:out value="${bill.order.shippingAddress}"/></span></div>
  ```
  thêm:
  - Nếu `bill.order.locationX != null && bill.order.locationY != null` (dùng `<c:if test="${bill.order.locationX != null && bill.order.locationY != null}">`): render
    ```jsp
    <div id="shopOrderMap"
         data-order-lat="${fn:escapeXml(bill.order.locationX)}"
         data-order-lng="${fn:escapeXml(bill.order.locationY)}"
         data-shop-lat="${fn:escapeXml(currentShop.locationX)}"
         data-shop-lng="${fn:escapeXml(currentShop.locationY)}"
         style="height:250px;border-radius:8px;margin-top:8px;"></div>
    ```
    (`data-shop-lat`/`data-shop-lng` để trống nếu `currentShop.locationX/Y` null — JS kiểm tra rỗng trước khi thêm marker shop.)
  - Nếu tọa độ đơn hàng null: render `<div class="info-row"><span>Vị trí bản đồ</span><span>Chưa có vị trí trên bản đồ</span></div>` — không tạo `L.map(...)` khi không có điểm giao hàng để hiển thị, kể cả khi shop có tọa độ (map chỉ có ý nghĩa khi biết điểm đến).
- JS thêm cuối trang, namespace riêng `initShopOrderMap()`:
  ```js
  function initShopOrderMap(containerId) {
    var el = document.getElementById(containerId);
    if (!el) return;
    var orderLat = parseFloat(el.dataset.orderLat);
    var orderLng = parseFloat(el.dataset.orderLng);
    var map = L.map(containerId, { zoomControl: true, dragging: true, scrollWheelZoom: false });
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
      attribution: '© OpenStreetMap contributors'
    }).addTo(map);
    var orderMarker = L.marker([orderLat, orderLng]).addTo(map);
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
  ```
  - Đọc tọa độ qua `data-*` + `dataset`, giữ đúng pattern escaping đã chốt ở tính năng trước (không nhúng EL trực tiếp vào literal JS).
  - `scrollWheelZoom: false` để tránh trang bị cuộn theo khi user lỡ scroll qua bản đồ.
  - `bounds.getNorthEast().distanceTo(bounds.getSouthWest()) > 0` kiểm tra 2 điểm không trùng nhau trước khi gọi `fitBounds` (nếu chỉ có 1 điểm hoặc 2 điểm trùng, `fitBounds` sẽ zoom cực sâu vô nghĩa) — fallback về `setView` tại điểm giao hàng.

## `Quanlybill.jsp` — modal bản đồ dùng chung

- Thêm Leaflet CDN tags vào `<head>`.
- Thêm 1 modal dùng chung cho toàn trang, đặt cuối `<body>` (ẩn mặc định qua CSS, cùng pattern `.modal-overlay`/`.modal-box` đã dùng ở `checkoutThanhToan.jsp`):
  ```jsp
  <div id="orderMapModal" class="modal-overlay" style="display:none;" onclick="closeOrderMapOnBg(event)">
    <div class="modal-box" style="max-width:500px;">
      <button type="button" onclick="closeOrderMapModal()">✕</button>
      <div id="orderMapContainer" style="height:350px;border-radius:8px;"></div>
    </div>
  </div>
  ```
- Trong bảng, cột "Thao tác" của mỗi dòng `<c:forEach var="o" items="${orderList}">`: nếu `o.locationX != null && o.locationY != null` → thêm nút:
  ```jsp
  <c:if test="${o.locationX != null && o.locationY != null}">
    <button type="button" class="btn-map" data-lat="${fn:escapeXml(o.locationX)}" data-lng="${fn:escapeXml(o.locationY)}" onclick="openOrderMapModal(this)">📍</button>
  </c:if>
  ```
  Đơn không có tọa độ: không render nút gì (ẩn hẳn, không disabled-icon, giữ bảng gọn).
- Modal cũng cần biết tọa độ shop — không đổi theo từng dòng nên đặt 1 lần trên chính `#orderMapModal`, ví dụ:
  ```jsp
  <div id="orderMapModal" class="modal-overlay" style="display:none;"
       data-shop-lat="${fn:escapeXml(currentShop.locationX)}"
       data-shop-lng="${fn:escapeXml(currentShop.locationY)}"
       onclick="closeOrderMapOnBg(event)">
  ```
- JS namespace riêng (không trùng với `openAddrModal`/`closeAddrModal` của `checkoutThanhToan.jsp`):
  ```js
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
  ```
  - `orderMap.remove()` khi đóng modal là bắt buộc: tránh giữ nhiều instance Leaflet trong bộ nhớ / lỗi "Map container is already initialized" khi mở lại modal cho đơn khác.
  - `invalidateSize()` + `fitBounds`/`setView` đều thực hiện trong cùng `setTimeout` sau khi modal đã `display:flex`: bù cho việc Leaflet tính sai kích thước container khi khởi tạo map lúc container còn ẩn (bug quen thuộc, đã gặp ở tính năng trước).

## Error handling

- Không có input người dùng nào ở tính năng này (chỉ đọc) → không cần validate phía server.
- Nếu Nominatim/OSM tile server không phản hồi: Leaflet tự hiển thị ô xám, không có JS error chặn trang — chấp nhận được vì đây là tính năng phụ trợ, không nằm trên luồng nghiệp vụ chính (tạo đơn/thanh toán).
- `orderMap.remove()` được gọi trong try-ít-rủi-ro (Leaflet's `remove()` tự no-op an toàn nếu map đã bị remove) — không cần bọc `try/catch`.

## Testing

Verify thủ công qua trình duyệt (dev server):
1. `HoaDonShop.jsp`: mở chi tiết 1 đơn có tọa độ, shop cũng có tọa độ → thấy bản đồ với 2 marker (🏠 shop + marker mặc định điểm giao hàng), tự động zoom để thấy cả 2. Mở đơn có tọa độ nhưng shop chưa có tọa độ (`currentShop.locationX/Y` null) → chỉ thấy 1 marker giao hàng, không lỗi JS. Mở đơn NULL tọa độ → thấy dòng "Chưa có vị trí trên bản đồ", không có lỗi JS console.
2. `Quanlybill.jsp`: danh sách có cả đơn có/không có tọa độ → chỉ đơn có tọa độ hiện nút 📍. Bấm nút → modal mở, bản đồ hiện cả marker shop + marker đơn, tự fitBounds đúng (không bị xám do lỗi kích thước). Đóng modal, mở lại cho đơn khác → bản đồ hiện đúng vị trí mới (không lỗi "already initialized"). Đóng bằng nút ✕ và bằng click nền ngoài modal đều hoạt động.
3. Compile toàn project bằng lệnh `javac` chuẩn đã dùng trước đó — không có thay đổi Java nào trong tính năng này nên chỉ cần xác nhận vẫn compile sạch (không có JSP nào phá vỡ build).

## Việc cần cập nhật `.md` sau khi implement (theo CLAUDE.md)

- `CRUD_DA_LAM.md`: thêm mục mô tả tính năng xem bản đồ vị trí giao hàng phía shop trên `HoaDonShop.jsp` và `Quanlybill.jsp`, ghi rõ đây là chế độ chỉ-đọc, hiển thị cả marker vị trí shop (`Shop.locationX/Y`) lẫn marker vị trí giao hàng (`Orders.locationX/locationY`) — cả 2 field đều đã có sẵn từ trước, tính năng này chỉ thêm phần hiển thị.
- `PROJECT_STRUCTURE.md`: cập nhật ghi chú cho `HoaDonShop.jsp` và `Quanlybill.jsp` (nay có nhúng bản đồ Leaflet/modal bản đồ).
