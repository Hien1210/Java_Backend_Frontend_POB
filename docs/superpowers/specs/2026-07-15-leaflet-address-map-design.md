# Thiết kế: Tích hợp bản đồ Leaflet cho địa chỉ giao hàng

Ngày: 2026-07-15

## Bối cảnh

`User_Addresses` đã có sẵn 2 cột `locationX`/`locationY` (decimal) nhưng chưa được dùng ở đâu cả. `Orders` cũng đã có sẵn `locationX`/`locationY` (đã xác nhận qua `DatabaseMetaData.getColumns` trên DB thật) nhưng model `Order.java` và `OrderDAOImpl` chưa map tới 2 cột này.

Mục tiêu: cho phép người dùng chọn (pin) vị trí thật trên bản đồ khi thêm/sửa địa chỉ, dùng thư viện miễn phí Leaflet.js + OpenStreetMap (không dùng Google Maps vì tốn phí), và mang tọa độ đó theo cả vào đơn hàng để sau này phục vụ shipper (không thuộc phạm vi đợt này — đợt này chỉ lưu tọa độ, chưa hiển thị bản đồ ở phía shipper/admin).

## Phạm vi

1. Trang **"Địa chỉ của tôi"** (`diaChi.jsp` / `UserAddressServlet`): modal Thêm và Sửa địa chỉ có nút "Chọn trên bản đồ" mở Leaflet map, bắt buộc chọn tọa độ mới lưu được (áp dụng cho cả tạo mới lẫn sửa địa chỉ cũ chưa có tọa độ).
2. Trang **Checkout** (`checkoutThanhToan.jsp` / `CheckoutServlet`): hiển thị nút "Thêm địa chỉ" / "Sửa địa chỉ" tùy theo địa chỉ mặc định đã có tọa độ hay chưa; mở modal có Leaflet map ngay tại trang checkout (không rời trang); khi lưu, tọa độ được ghi vào cả `User_Addresses` (tái sử dụng `UserAddressServlet` sẵn có) và vào `Orders.locationX/Y` của đơn hàng đang tạo.

Không thuộc phạm vi: hiển thị bản đồ cho shipper/admin xem vị trí giao hàng; tính khoảng cách/phí ship theo tọa độ; theo dõi vị trí real-time.

## Kiến trúc & công nghệ

- **Leaflet.js + Leaflet CSS**: nhúng qua CDN (`unpkg.com/leaflet@1.9.4`) bằng thẻ `<script>`/`<link>` thẳng trong JSP — không có build step nên đây là cách phù hợp nhất.
- **Tile layer**: OpenStreetMap tile server mặc định (`https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png`), kèm attribution bắt buộc `© OpenStreetMap contributors`.
- **Geocode/reverse-geocode**: Nominatim (`nominatim.openstreetmap.org`), gọi trực tiếp bằng `fetch()` từ JS phía client — không qua backend Java, tránh phải thêm HTTP client.
- **Quy ước tọa độ**: `locationX` = **latitude**, `locationY` = **longitude** (khớp thứ tự `[lat, lng]` mà Leaflet dùng).

## Luồng UI (áp dụng chung cho cả 2 nơi dùng — modal địa chỉ & modal checkout)

1. Mặc định modal **không hiển thị map** — chỉ hiện khi bấm nút "📍 Chọn trên bản đồ".
2. Khi map hiện ra lần đầu (lazy init):
   - Nếu đang sửa địa chỉ đã có tọa độ → center + đặt marker tại tọa độ đó.
   - Nếu chưa có tọa độ (tạo mới, hoặc sửa địa chỉ cũ dữ liệu NULL) → dùng browser Geolocation API để center vào vị trí hiện tại; nếu user từ chối quyền hoặc lỗi → fallback về tọa độ cố định (trung tâm Hà Nội: `21.0285, 105.8542`). Chưa đặt marker cho tới khi user click.
   - Bắt buộc gọi `map.invalidateSize()` ngay sau khi container hiện ra (bug quen thuộc của Leaflet trong Bootstrap modal ẩn — tile bị xám nếu không gọi).
3. Có 1 ô search phía trên map. User gõ địa chỉ + bấm "Tìm" → gọi Nominatim forward-geocode → lấy kết quả đầu tiên → **di chuyển marker tới đó luôn** (không chỉ pan bản đồ) + `map.setView()` + tự động trigger reverse-geocode để auto-fill ô địa chỉ text.
4. User có thể click trực tiếp lên map hoặc kéo marker để tinh chỉnh vị trí chính xác hơn. Mỗi lần marker đổi vị trí (click/drag-end):
   - Cập nhật 2 hidden input tọa độ trong form.
   - Gọi Nominatim reverse-geocode → auto-fill textarea địa chỉ (user vẫn sửa tay được sau đó).
5. Submit form: nếu 2 hidden input tọa độ rỗng → JS chặn submit, hiện alert "Vui lòng chọn vị trí trên bản đồ". Server (`UserAddressServlet`) validate lại — không tin client — trả `?error=missing` nếu thiếu.

## Backend — Trang "Địa chỉ của tôi"

**`UserAddress.java`**: thêm field `Double locationX`, `Double locationY` + getter/setter.

**`UserAddressDAOImpl.java`**: thêm `location_x`/`location_y`... — thực ra tên cột thật trên DB là `locationX`/`locationY` (không có underscore, đã xác nhận qua introspection) — thêm 2 cột này vào SELECT/INSERT/UPDATE, dùng `ps.setObject(...)`/`rs.getObject(..., Double.class)` để chấp nhận NULL với dữ liệu cũ.

**`UserAddressServlet.java`**:
- `createAddress`/`updateAddress`: đọc thêm `req.getParameter("locationX")`/`"locationY")`, validate parse được số hợp lệ và không rỗng → nếu thiếu, redirect `?error=missing` (dùng lại mã lỗi hiện có).
- Thêm hỗ trợ tham số tùy chọn `returnTo` + `cartId` trên cả GET lẫn POST: nếu có `returnTo=checkout` và `cartId` hợp lệ, sau khi xử lý xong (create/update) thì redirect về `/checkout?cartId={cartId}` thay vì `/user/dia-chi`. Tham số này chỉ ảnh hưởng đường redirect, không đổi logic lưu.

## Backend — Trang Checkout

**`Order.java`**: thêm field `Double locationX`, `Double locationY` + getter/setter.

**`OrderDAOImpl.java`**: đây là DAO tự dò cột qua `DatabaseMetaData` (schema-introspecting), nên chỉ cần thêm vào theo đúng pattern có sẵn:
- Thêm `LOCATION_X_CANDIDATES = {"locationX", "location_x"}`, `LOCATION_Y_CANDIDATES = {"locationY", "location_y"}` vào danh sách candidates.
- Thêm `locationX`/`locationY` (kiểu `resolveOptional`, vì đơn hàng không có account đăng nhập vẫn phải tạo được — coi tọa độ là optional ở DAO, còn validate bắt buộc nằm ở tầng Servlet/JS như mô tả dưới) vào `OrderSchema`, `buildInsertSql`/`buildUpdateSql`/`buildSelectColumns`/`bindEditableFields`/`mapOrder`.

**`CheckoutServlet.java`**:
- `doGet`: sau khi lấy `defaultAddress`, set thêm `req.setAttribute("hasLocation", defaultAddress != null && defaultAddress.getLocationX() != null && defaultAddress.getLocationY() != null)` để JSP quyết định hiện nút "Thêm địa chỉ" hay "Sửa địa chỉ".
- `doPost`: đọc thêm `orderLocationX`/`orderLocationY` (hidden input, copy sẵn từ `defaultAddress` lúc render trang, hoặc được cập nhật lại sau khi quay về từ modal lưu địa chỉ) → set vào `Order.setLocationX/Y(...)` trước khi `orderDAO.createAndReturnId(order)`. Không validate bắt buộc ở bước này (nếu người dùng chưa từng có địa chỉ nào có tọa độ và bỏ qua nút "Thêm địa chỉ", đơn hàng vẫn tạo được với tọa độ NULL — giữ tương thích ngược, không chặn luồng thanh toán hiện tại).

## Frontend — `checkoutThanhToan.jsp`

- Thêm nút ngay dưới ô "Địa chỉ giao hàng": nếu `hasLocation == true` → nút "✏️ Sửa địa chỉ" (mở modal, pre-fill từ `defaultAddress`); nếu `false` → nút "➕ Thêm địa chỉ" (modal trống, bắt buộc pin map).
- Modal trong trang này POST tới `${pageContext.request.contextPath}/user/dia-chi` với `action=create` hoặc `update`, kèm 2 hidden input `returnTo=checkout` và `cartId=${cart.id}`.
- Sau khi `UserAddressServlet` redirect về `/checkout?cartId=...`, `CheckoutServlet.doGet` chạy lại, lấy `defaultAddress` mới nhất (đã có tọa độ) → 2 hidden input `orderLocationX`/`orderLocationY` trong form thanh toán chính được set lại từ `defaultAddress.locationX/Y`.
- Textarea/input "Địa chỉ giao hàng" hiện tại (`shippingAddress`) giữ nguyên hành vi auto-fill từ `defaultAddress.address` như đã sửa trước đó — không đổi.

## Frontend — `diaChi.jsp`

- Modal Thêm và modal Sửa đều thêm: nút "📍 Chọn trên bản đồ", container `<div id="mapCreate">`/`<div id="mapEdit">` (ẩn mặc định), 2 hidden input `locationX`/`locationY` mỗi modal.
- Dùng 2 Leaflet map instance độc lập (1 cho Create, 1 cho Edit) — khởi tạo lười lần đầu bấm nút, tránh phải di chuyển DOM map giữa 2 modal. Cả 2 dùng chung 1 hàm JS helper `initAddressMap(containerId, latInputId, lngInputId, addressTextareaId, presetLat, presetLng)` để không lặp code.
- Modal Sửa: khi mở qua `openEdit(...)` JS hiện có, nếu địa chỉ có `locationX`/`locationY` (không null) → truyền preset để map center + đặt marker sẵn tại đó; nếu null (địa chỉ cũ) → không preset, xử lý như tạo mới (geolocation/fallback).

## Error handling

- Nominatim lỗi mạng/không phản hồi (search hoặc reverse-geocode): JS bắt lỗi `fetch`, hiện thông báo nhỏ trong modal, không chặn form. Reverse-geocode lỗi → marker vẫn đặt được, chỉ là ô địa chỉ text không tự điền.
- User từ chối quyền Geolocation: fallback tọa độ cố định (trung tâm Hà Nội).
- Submit thiếu tọa độ: chặn phía client (JS) + validate lại phía server (`UserAddressServlet` trả `?error=missing`).
- Đơn hàng tạo khi user bỏ qua bước thêm địa chỉ có tọa độ ở Checkout: cho phép tạo bình thường với `Order.locationX/Y = null` — không chặn luồng thanh toán hiện tại (khác với ràng buộc "bắt buộc" ở trang Địa chỉ của tôi, vì đây là optional nếu user chỉ muốn nhập tay `shippingAddress` như trước).

## Testing

Verify thủ công qua trình duyệt (dev server), các kịch bản:
1. Trang "Địa chỉ của tôi": tạo địa chỉ mới có dùng map + search; cố tình bỏ qua map khi tạo mới (phải bị chặn); sửa địa chỉ cũ chưa có tọa độ (bắt buộc chọn map mới lưu được); sửa địa chỉ đã có tọa độ (marker hiện đúng vị trí cũ); từ chối quyền định vị trình duyệt (test fallback Hà Nội).
2. Trang Checkout: vào checkout khi chưa có địa chỉ nào (thấy nút "Thêm địa chỉ"); vào checkout khi đã có địa chỉ mặc định có tọa độ (thấy nút "Sửa địa chỉ", form tự điền); lưu địa chỉ mới từ modal Checkout xong quay lại đúng trang checkout (không mất giỏ hàng, `cartId` giữ nguyên); đặt hàng xong kiểm tra `Orders.locationX/Y` trong DB có giá trị đúng bằng tọa độ đã pin.
3. Compile toàn project bằng lệnh `javac` chuẩn đã dùng trước đó (classpath từ `.m2`, convert path Windows-style) để đảm bảo không lỗi biên dịch.

## Việc cần cập nhật `.md` sau khi implement (theo CLAUDE.md)

- `CRUD_DA_LAM.md`: thêm mục mới mô tả tính năng Leaflet map cho địa chỉ (cả 2 nơi dùng), cột `locationX`/`locationY` trên `User_Addresses` và `Orders` được đưa vào sử dụng, tham số `returnTo`/`cartId` mới trên `UserAddressServlet`.
- `PROJECT_STRUCTURE.md`: cập nhật mô tả `UserAddress.java`, `Order.java` (thêm field mới), và ghi chú `checkoutThanhToan.jsp` nay có modal Thêm/Sửa địa chỉ tích hợp map.
