# Thiết kế: Hiển thị vị trí giao hàng (bản đồ) cho phía shop

Ngày: 2026-07-15

## Bối cảnh

`Orders.locationX`/`locationY` đã được lưu sẵn từ tính năng Leaflet address map (xem [2026-07-15-leaflet-address-map-design.md](2026-07-15-leaflet-address-map-design.md)) — mỗi đơn hàng tạo qua Checkout mang theo tọa độ giao hàng (có thể NULL với đơn cũ hoặc đơn không pin map). Hiện phía shop (`HoaDonShop.jsp`, `Quanlybill.jsp`) chỉ hiển thị `shippingAddress` dạng chữ, chưa có cách xem vị trí trên bản đồ.

Mục tiêu: cho phép shop xem vị trí giao hàng trên bản đồ ngay trong giao diện quản lý đơn, tái sử dụng toàn bộ dữ liệu và hạ tầng (Leaflet CDN, OpenStreetMap tile) đã có từ tính năng trước — **chỉ đọc**, không chỉnh sửa tọa độ.

## Phạm vi

1. **`HoaDonShop.jsp`** (trang chi tiết 1 hóa đơn): nhúng bản đồ Leaflet chỉ-đọc ngay dưới dòng "Địa chỉ giao hàng", hiển thị marker cố định tại `bill.order.locationX/locationY` nếu có.
2. **`Quanlybill.jsp`** (trang danh sách đơn hàng): mỗi dòng có tọa độ hiển thị nút "📍", bấm vào mở modal chứa bản đồ Leaflet chỉ-đọc cho đơn đó.

Không thuộc phạm vi: chỉnh sửa/thay đổi tọa độ từ phía shop; tính khoảng cách/chỉ đường; hiển thị nhiều đơn cùng lúc trên 1 bản đồ; thay đổi Model/DAO (đã đủ từ tính năng trước).

## Kiến trúc & công nghệ

- Tái sử dụng nguyên trạng Leaflet.js 1.9.4 CDN (`unpkg.com/leaflet@1.9.4`) + OpenStreetMap tile layer + attribution `© OpenStreetMap contributors`, đúng pattern đã dùng ở `diaChi.jsp`/`checkoutThanhToan.jsp`.
- Không có build step → tiếp tục nhúng `<script>`/`<link>` thẳng trong từng JSP, theo đúng convention hiện tại của codebase (mỗi JSP tự chứa CSS/JS riêng, namespace hàm JS riêng để tránh đụng độ).
- Bản đồ ở cả 2 nơi đều **chỉ đọc**: không gắn listener `click`/`dragend` lên marker, không có ô search, không gọi Nominatim — khác với map ở tính năng trước (vốn dùng để pin/chỉnh vị trí).
- Quy ước tọa độ giữ nguyên: `locationX` = latitude, `locationY` = longitude (`[lat, lng]` khi gọi Leaflet).

## `HoaDonShop.jsp` — bản đồ nhúng trực tiếp

- Thêm Leaflet CDN tags (`<link>`/`<script>`) vào `<head>` của trang.
- Ngay sau dòng hiện có:
  ```jsp
  <div class="info-row"><span>Địa chỉ giao hàng</span><span><c:out value="${bill.order.shippingAddress}"/></span></div>
  ```
  thêm:
  - Nếu `bill.order.locationX != null && bill.order.locationY != null` (dùng `<c:if test="${bill.order.locationX != null && bill.order.locationY != null}">`): render `<div id="shopOrderMap" style="height:250px;border-radius:8px;margin-top:8px;"></div>` kèm 2 input ẩn (hoặc data-attribute trên chính div) mang tọa độ, escaped qua `fn:escapeXml`.
  - Nếu null: render `<div class="info-row"><span>Vị trí bản đồ</span><span>Chưa có vị trí trên bản đồ</span></div>` — không nhúng Leaflet CDN thừa khi không có tọa độ để hiển thị (nhưng vì trang chỉ có 1 order, CDN tag vẫn có thể nhúng tĩnh trong `<head>`; việc `<c:if>` chỉ quyết định có gọi `initShopOrderMap()` và tạo `L.map(...)` hay không).
- JS thêm cuối trang, namespace riêng `initShopOrderMap()`:
  ```js
  function initShopOrderMap(containerId, lat, lng) {
    var map = L.map(containerId, { zoomControl: true, dragging: true, scrollWheelZoom: false }).setView([lat, lng], 16);
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
      attribution: '© OpenStreetMap contributors'
    }).addTo(map);
    L.marker([lat, lng]).addTo(map);
  }
  ```
  Gọi `initShopOrderMap('shopOrderMap', <lat>, <lng>)` trong `<script>` inline, đọc tọa độ từ `data-lat`/`data-lng` trên div (không nhúng EL trực tiếp vào literal JS số — dù đây là số thuần từ DB nên rủi ro XSS thấp, vẫn giữ nhất quán với pattern `data-*` đã chốt ở tính năng trước).
  - `scrollWheelZoom: false` để tránh trang bị cuộn theo khi user lỡ scroll qua bản đồ.

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
- JS namespace riêng (không trùng với `openAddrModal`/`closeAddrModal` của `checkoutThanhToan.jsp`):
  ```js
  var orderMap = null;
  function openOrderMapModal(btn) {
    var lat = parseFloat(btn.dataset.lat);
    var lng = parseFloat(btn.dataset.lng);
    document.getElementById('orderMapModal').style.display = 'flex';
    if (orderMap) { orderMap.remove(); orderMap = null; }
    orderMap = L.map('orderMapContainer', { scrollWheelZoom: false }).setView([lat, lng], 16);
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
      attribution: '© OpenStreetMap contributors'
    }).addTo(orderMap);
    L.marker([lat, lng]).addTo(orderMap);
    setTimeout(function () { orderMap.invalidateSize(); }, 50);
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
  - `invalidateSize()` sau `setTimeout` ngắn: bù cho việc Leaflet tính sai kích thước container khi khởi tạo map trong lúc modal vừa được `display:flex` (bug quen thuộc, đã gặp ở tính năng trước).

## Error handling

- Không có input người dùng nào ở tính năng này (chỉ đọc) → không cần validate phía server.
- Nếu Nominatim/OSM tile server không phản hồi: Leaflet tự hiển thị ô xám, không có JS error chặn trang — chấp nhận được vì đây là tính năng phụ trợ, không nằm trên luồng nghiệp vụ chính (tạo đơn/thanh toán).
- `orderMap.remove()` được gọi trong try-ít-rủi-ro (Leaflet's `remove()` tự no-op an toàn nếu map đã bị remove) — không cần bọc `try/catch`.

## Testing

Verify thủ công qua trình duyệt (dev server):
1. `HoaDonShop.jsp`: mở chi tiết 1 đơn có tọa độ → thấy bản đồ với marker đúng vị trí, kéo/zoom bản đồ được nhưng marker không di chuyển được. Mở chi tiết 1 đơn NULL tọa độ (đơn cũ hoặc tạo không qua map) → thấy dòng "Chưa có vị trí trên bản đồ", không có lỗi JS console.
2. `Quanlybill.jsp`: danh sách có cả đơn có/không có tọa độ → chỉ đơn có tọa độ hiện nút 📍. Bấm nút → modal mở, bản đồ hiện đúng vị trí (không bị xám do lỗi kích thước). Đóng modal, mở lại cho đơn khác → bản đồ hiện đúng vị trí mới (không lỗi "already initialized"). Đóng bằng nút ✕ và bằng click nền ngoài modal đều hoạt động.
3. Compile toàn project bằng lệnh `javac` chuẩn đã dùng trước đó — không có thay đổi Java nào trong tính năng này nên chỉ cần xác nhận vẫn compile sạch (không có JSP nào phá vỡ build).

## Việc cần cập nhật `.md` sau khi implement (theo CLAUDE.md)

- `CRUD_DA_LAM.md`: thêm mục mô tả tính năng xem bản đồ vị trí giao hàng phía shop trên `HoaDonShop.jsp` và `Quanlybill.jsp`, ghi rõ đây là chế độ chỉ-đọc và tái sử dụng dữ liệu `Orders.locationX/locationY` đã có.
- `PROJECT_STRUCTURE.md`: cập nhật ghi chú cho `HoaDonShop.jsp` và `Quanlybill.jsp` (nay có nhúng bản đồ Leaflet/modal bản đồ).
