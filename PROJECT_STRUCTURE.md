# PROJECT_STRUCTURE.md

> Đọc file này trước khi sửa code. Mục tiêu: biết nhanh dự án làm gì, cấu trúc ra sao, và khi user yêu cầu một chức năng thì cần mở file nào.

## 1. Tổng quan

- Đồ án tốt nghiệp: ứng dụng web đặt đồ ăn (food ordering) — quản lý shop, sản phẩm, giỏ hàng, đơn hàng, shipper, tài khoản, super admin duyệt shop.
- Stack: **Java Servlet/JSP** thuần (không dùng Spring), build bằng **Maven**, chạy trên **Apache Tomcat**.
- Kiến trúc: Servlet (Controller) → DAO (truy cập DB qua JDBC) → Model (POJO) → JSP (View).
- DB: SQL Server (`mssql-jdbc`), kết nối qua [DBUtil.java](src/main/java/org/example/utils/DBUtil.java).
- Mật khẩu hash bằng `jbcrypt`. Gửi email OTP bằng `javax.mail` qua [EmailUtil.java](src/main/java/org/example/utils/EmailUtil.java).

## 2. Cấu trúc thư mục chính

```
src/main/java/org/example/
  controllers/   -> Servlet, mỗi servlet = 1 endpoint (@WebServlet)
  daos/          -> Data Access Object, có interface (XxxDAO) + impl (XxxDAOImpl)
  models/        -> POJO (entity), tên trùng bảng DB (số ít)
  filter/        -> Servlet Filter (auth, chặn truy cập)
  utils/         -> DBUtil (kết nối DB), EmailUtil (gửi mail OTP)
  websocket/     -> WebSocket endpoint theo dõi vị trí shipper realtime (không qua DAO/Servlet HTTP)
    - [HttpSessionConfigurator.java](src/main/java/org/example/websocket/HttpSessionConfigurator.java): copy `accountId` từ HttpSession vào WebSocket handshake để xác thực.
    - [TrackingEndpoint.java](src/main/java/org/example/websocket/TrackingEndpoint.java): `@ServerEndpoint("/ws/tracking")`, relay vị trí GPS shipper tới các khách hàng đang xem cùng đơn hàng (cache trong bộ nhớ, không có bảng DB mới) — xem [CRUD_DA_LAM.md](CRUD_DA_LAM.md) mục 25.

src/main/web/    -> JSP views (KHÔNG nằm trong WEB-INF nên có thể truy cập trực tiếp)
  shop/          -> trang quản lý cho shop owner (sản phẩm, topping, loại sản phẩm, hồ sơ shop...)
  admin/         -> trang cho super admin (duyệt shop, tổng quan hệ thống, quản lý tài khoản)
  user/          -> trang cho người dùng thường
  shipper/       -> trang cho shipper
  assets/js/     -> JS dùng chung nhiều trang, vd [orderTrackingMap.js](src/main/web/assets/js/orderTrackingMap.js) (bản đồ Leaflet 3-marker: shop, điểm giao, shipper realtime qua WebSocket; kèm tính khoảng cách Haversine + ETA hiển thị dưới bản đồ — xem mục 25c trong CRUD_DA_LAM.md)
  WEB-INF/       -> web.xml, config

pom.xml          -> Maven dependencies (jakarta servlet, mssql-jdbc, jstl, jbcrypt, javax.mail, jakarta.websocket-api + jakarta.websocket-client-api cho tính năng theo dõi shipper realtime)
CRUD_DA_LAM.md   -> log các CRUD đã hoàn thành (cart, order, cart-items, order-details)
```

## 3. Bảng tra cứu nhanh: Endpoint → Servlet → DAO → JSP

| Endpoint (URL) | Servlet | DAO | Model | JSP liên quan |
|---|---|---|---|---|
| `/dangnhap` | [DangNhapServlet.java](src/main/java/org/example/controllers/DangNhapServlet.java) | AccountDAO | Account | [DangNhap.jsp](src/main/web/DangNhap.jsp) |
| `/dangky` | [DangKyServlet.java](src/main/java/org/example/controllers/DangKyServlet.java) | AccountDAO | Account | [register.jsp](src/main/web/register.jsp) |
| `/dangky-shipper` | [Dangkyshipperservlet.java](src/main/java/org/example/controllers/Dangkyshipperservlet.java) | AccountDAO | Account | [shipper/registerShipper.jsp](src/main/web/shipper/registerShipper.jsp) |
| `/dangky-shop` | [DangKyShopServlet.java](src/main/java/org/example/controllers/DangKyShopServlet.java) | ShopDAO | Shop | [shop/registerShop.jsp](src/main/web/shop/registerShop.jsp), [shop/shopDangKyThongTin.jsp](src/main/web/shop/shopDangKyThongTin.jsp) |
| `/logout` | [DangXuatServlet.java](src/main/java/org/example/controllers/DangXuatServlet.java) | - | - | - |
| `/quenmatkhau` | [QuenMatKhauServlet.java](src/main/java/org/example/controllers/QuenMatKhauServlet.java) | AccountDAO | Account | [quenmatkhau.jsp](src/main/web/quenmatkhau.jsp) |
| `/xacnhanotp` | [XacNhanOTPServlet.java](src/main/java/org/example/controllers/XacNhanOTPServlet.java) | AccountDAO | Account | [nhapOTP.jsp](src/main/web/nhapOTP.jsp) |
| `/quanlitaikhoan` | [QuanLiTaiKhoanServlet.java](src/main/java/org/example/controllers/QuanLiTaiKhoanServlet.java) | AccountDAO | Account | [admin/quanlitaikhoan.jsp](src/main/web/admin/quanlitaikhoan.jsp) (trang super admin) |
| `/cart` | [CartServlet.java](src/main/java/org/example/controllers/CartServlet.java) | [CartDAO.java](src/main/java/org/example/daos/CartDAO.java)/[CartDAOImpl.java](src/main/java/org/example/daos/CartDAOImpl.java) | [Cart.java](src/main/java/org/example/models/Cart.java) | [user/themSuaGioHang.jsp](src/main/web/user/themSuaGioHang.jsp), [user/DanhSachGioHang.jsp](src/main/web/user/DanhSachGioHang.jsp) |
| `/cart-items` | [CartItemServlet.java](src/main/java/org/example/controllers/CartItemServlet.java) | CartItemDAO/Impl | [CartItem.java](src/main/java/org/example/models/CartItem.java) | [user/cartItemDanhSach.jsp](src/main/web/user/cartItemDanhSach.jsp), [user/cartItemThemSua.jsp](src/main/web/user/cartItemThemSua.jsp) |
| `/orders` | [OrderServlet.java](src/main/java/org/example/controllers/OrderServlet.java) | OrderDAO/Impl | [Order.java](src/main/java/org/example/models/Order.java) | [user/orderDanhSach.jsp](src/main/web/user/orderDanhSach.jsp), [user/orderThemSua.jsp](src/main/web/user/orderThemSua.jsp) |
| `/order-details` | [OrderDetailServlet.java](src/main/java/org/example/controllers/OrderDetailServlet.java) | OrderDetailDAO/Impl | [OrderDetail.java](src/main/java/org/example/models/OrderDetail.java) | [user/orderDetailDanhSach.jsp](src/main/web/user/orderDetailDanhSach.jsp), [user/orderDetailThemSua.jsp](src/main/web/user/orderDetailThemSua.jsp) |
| `/order-logs` | [OrderLogServlet.java](src/main/java/org/example/controllers/OrderLogServlet.java) | OrderLogDAO/Impl | [OrderLog.java](src/main/java/org/example/models/OrderLog.java) | - |
| `/checkout` | [CheckoutServlet.java](src/main/java/org/example/controllers/CheckoutServlet.java) | CartDAO, CartItemDAO, ProductDAO, ProductSizeDAO, ShopDAO, OrderDAO, OrderDetailDAO | Cart, CartItem, Order, OrderDetail | [user/checkoutThanhToan.jsp](src/main/web/user/checkoutThanhToan.jsp) — tu dien Ten/SDT/Dia chi tu dia chi mac dinh cua user, co ban do Leaflet chon vi tri (nut "📍 Chon vi tri tren ban do", khong bat buoc) voi tim kiem Nominatim + reverse-geocode, luu vao 2 input an `locationX`/`locationY` gui thang trong form checkout (xem muc 26 trong CRUD_DA_LAM.md ve fix regression) |
| `/payos/return` | [PayOSReturnServlet.java](src/main/java/org/example/controllers/PayOSReturnServlet.java) | OrderDAO, ShopDAO + [PayOSUtil.java](src/main/java/org/example/utils/PayOSUtil.java) | Order, Shop | [user/thanhToanThatBai.jsp](src/main/web/user/thanhToanThatBai.jsp) (thất bại) hoặc redirect `/bill` (thành công) |
| `/payos/webhook` | [PayOSWebhookServlet.java](src/main/java/org/example/controllers/PayOSWebhookServlet.java) | OrderDAO, ShopDAO + PayOSUtil | Order, Shop | - (server-to-server, không có UI) |
| `/bill` | [BillServlet.java](src/main/java/org/example/controllers/BillServlet.java) | OrderDAO + [BillUtil.java](src/main/java/org/example/utils/BillUtil.java) | Order, [BillView](src/main/java/org/example/models/BillView.java) | [user/hoaDon.jsp](src/main/web/user/hoaDon.jsp) |
| `/shop/bills` | [ShopBillServlet.java](src/main/java/org/example/controllers/ShopBillServlet.java) | OrderDAO (findByShopId, assignShipper), AccountDAO (findOnlineShippers), ShopDAO + BillUtil | Order, Shop, BillView, Account | [shop/Quanlybill.jsp](src/main/web/shop/Quanlybill.jsp) — mỗi dòng đơn hàng có tọa độ hiển thị nút "📍" mở modal bản đồ Leaflet chỉ đọc (marker giao hàng + marker shop); quy trình đơn hàng đầy đủ `PENDING -> CONFIRMED -> READY_FOR_PICKUP -> (gán shipper thủ công hoặc shipper tự nhận) -> SHIPPING -> DONE` (xem mục 50 trong CRUD_DA_LAM.md), [shop/HoaDonShop.jsp](src/main/web/shop/HoaDonShop.jsp) — có sẵn bản đồ Leaflet chỉ đọc dưới phần "Địa chỉ giao hàng" (marker giao hàng + marker shop, tự `fitBounds`), ẩn nếu đơn hàng chưa có tọa độ |
| `/Category` | [CategoryServlet.java](src/main/java/org/example/controllers/CategoryServlet.java) | CategoryDAO/Impl | [Category.java](src/main/java/org/example/models/Category.java) | [shop/taoCategory.jsp](src/main/web/shop/taoCategory.jsp) |
| `/product` | [ProductServlet.java](src/main/java/org/example/controllers/ProductServlet.java) | ProductDAO/Impl, ProductSizeDAO/Impl | [Product.java](src/main/java/org/example/models/Product.java), [ProductSize.java](src/main/java/org/example/models/ProductSize.java), [ProductImage.java](src/main/java/org/example/models/ProductImage.java) | [shop/taoProduct.jsp](src/main/web/shop/taoProduct.jsp) |
| `/shops` | [ShopServlet.java](src/main/java/org/example/controllers/ShopServlet.java) | ShopDAO/Impl | [Shop.java](src/main/java/org/example/models/Shop.java) | [shop/shopDanhSach.jsp](src/main/web/shop/shopDanhSach.jsp), [shop/shopThemSua.jsp](src/main/web/shop/shopThemSua.jsp) |
| `/shop` (trang chủ shop) | [ShopHomeServlet.java](src/main/java/org/example/controllers/ShopHomeServlet.java) | ShopDAO | Shop | [shop/shopDangKyThongTin.jsp](src/main/web/shop/shopDangKyThongTin.jsp), [shop/shopChoDuyet.jsp](src/main/web/shop/shopChoDuyet.jsp), [shop/shopTuChoi.jsp](src/main/web/shop/shopTuChoi.jsp), [shop/trangcuahang.jsp](src/main/web/shop/trangcuahang.jsp) |
| `/shop/profile` | [ShopProfileServlet.java](src/main/java/org/example/controllers/ShopProfileServlet.java) | ShopDAO/Impl | Shop | [shop/Shopprofile.jsp](src/main/web/shop/Shopprofile.jsp) — form chỉnh sửa có nút "📍 Chọn vị trí trên bản đồ" (Leaflet, không bắt buộc) để đặt `locationX`/`locationY` của cửa hàng |
| `/shop/products` | [ShopProductServlet.java](src/main/java/org/example/controllers/ShopProductServlet.java) | ProductDAO/Impl, ProductSizeDAO/Impl | Product, ProductSize | [shop/Quanlysanpham.jsp](src/main/web/shop/Quanlysanpham.jsp) (giá theo size, không có giá ở cấp sản phẩm) |
| `/shop/product-types` | [ShopProductTypeServlet.java](src/main/java/org/example/controllers/ShopProductTypeServlet.java) | CategoryDAO/Impl | Category (cột DB: `name`, `description`, `is_deleted` — field `status` của model không có cột tương ứng, DAO tự bỏ qua) | [shop/Quanlyloaisanpham.jsp](src/main/web/shop/Quanlyloaisanpham.jsp) |
| `/shop/toppings` | [ShopToppingServlet.java](src/main/java/org/example/controllers/ShopToppingServlet.java) | [ToppingDAO.java](src/main/java/org/example/daos/ToppingDAO.java)/[ToppingDAOImpl.java](src/main/java/org/example/daos/ToppingDAOImpl.java) | [Topping.java](src/main/java/org/example/models/Topping.java) | [shop/Quanlytopping.jsp](src/main/web/shop/Quanlytopping.jsp) |
| `/shop/topping-categories` | [QuanLyLoaiToppingServlet.java](src/main/java/org/example/controllers/QuanLyLoaiToppingServlet.java) | [ToppingCategoryDAO.java](src/main/java/org/example/daos/ToppingCategoryDAO.java)/[ToppingCategoryDAOImpl.java](src/main/java/org/example/daos/ToppingCategoryDAOImpl.java) | [ToppingCategory.java](src/main/java/org/example/models/ToppingCategory.java) (cột DB: `name`, `description`, `is_deleted` — không có `status`) | [shop/Quanlyloaitopping.jsp](src/main/web/shop/Quanlyloaitopping.jsp) |
| `/super-admin/shop-requests` | [SuperAdminShopRequestServlet.java](src/main/java/org/example/controllers/SuperAdminShopRequestServlet.java) | ShopDAO/Impl | Shop | [admin/yeuCauShop.jsp](src/main/web/admin/yeuCauShop.jsp), [admin/chiTietYeuCauShop.jsp](src/main/web/admin/chiTietYeuCauShop.jsp) |
| `/tong-quan` | [TongQuanServlet.java](src/main/java/org/example/controllers/TongQuanServlet.java) | [ThongKeDAO.java](src/main/java/org/example/daos/ThongKeDAO.java)/[ThongKeDAOImpl.java](src/main/java/org/example/daos/ThongKeDAOImpl.java) | - | [admin/TongQuanHeThong.jsp](src/main/web/admin/TongQuanHeThong.jsp) |
| `/user/dia-chi` | [UserAddressServlet.java](src/main/java/org/example/controllers/UserAddressServlet.java) | [UserAddressDAO.java](src/main/java/org/example/daos/UserAddressDAO.java)/[UserAddressDAOImpl.java](src/main/java/org/example/daos/UserAddressDAOImpl.java) | [UserAddress.java](src/main/java/org/example/models/UserAddress.java) (co `locationX`/`locationY` = vi do/kinh do, bat buoc khi tao/sua) | [user/diaChi.jsp](src/main/web/user/diaChi.jsp) — modal Them/Sua co ban do Leaflet (OpenStreetMap + Nominatim) de chon toa do |
| `/ws/tracking` (WebSocket) | [TrackingEndpoint.java](src/main/java/org/example/websocket/TrackingEndpoint.java) (khong phai Servlet HTTP) | - (khong co DAO/DB, cache vi tri trong bo nho) | - | [shipper/chitietdonhang.jsp](src/main/web/shipper/chitietdonhang.jsp) (shipper gui GPS khi don `SHIPPING`), [user/donhang.jsp](src/main/web/user/donhang.jsp) + [orderTrackingMap.js](src/main/web/assets/js/orderTrackingMap.js) (khach hang xem ban do 3-marker realtime) |
| `/admin/kiem-duyet-noi-dung` | [ContentModerationServlet.java](src/main/java/org/example/controllers/ContentModerationServlet.java) — `doGet` load `pendingProducts` + `bannedWords`; `doPost` re nhanh theo `action` (`approve`/`reject` doc `productId`, `addWord`/`deleteWord` doc `word`/`wordId`) roi PRG redirect | ProductDAO/Impl (`findPendingReview()`, `updateStatus()`); FeedbackDAO/Impl (`findAllBannedWords()`, `addBannedWord()`, `deleteBannedWord()`) | Product (`status = PENDING_REVIEW`, field moi `shopName`); BannedWord (`id`, `word`, `createdAt`) | [admin/KiemDuyetNoiDung.jsp](src/main/web/admin/KiemDuyetNoiDung.jsp) — 2 tab deu du lieu that: Tab 1 "Món ăn chờ duyệt" (mac dinh active), Tab 2 "Quản lý Từ khóa cấm" (xem/them/xoa bang `BannedWords` qua form PRG) — xem muc 49 trong CRUD_DA_LAM.md |
| `/admin/bao-cao-van-hanh` | [BaoCaoVanHanhServlet.java](src/main/java/org/example/controllers/BaoCaoVanHanhServlet.java) | [BaoCaoVanHanhDAO.java](src/main/java/org/example/daos/BaoCaoVanHanhDAO.java)/[BaoCaoVanHanhDAOImpl.java](src/main/java/org/example/daos/BaoCaoVanHanhDAOImpl.java) | - (query truc tiep `Orders`, `Order_Logs` qua SQL `GROUP BY`) | [admin/BaoCaoVanHanh.jsp](src/main/web/admin/BaoCaoVanHanh.jsp) — bo loc theo ngay, 3 the thong ke (tong don, ty le hoan thanh, thoi gian giao TB), Doughnut Chart.js trang thai don hang (xem muc 45 trong CRUD_DA_LAM.md) |
| `/admin/kiem-duyet-binh-luan` | [KiemDuyetBinhLuanServlet.java](src/main/java/org/example/controllers/KiemDuyetBinhLuanServlet.java) (`doGet` goi `findPendingReview()`, `doPost` goi `updateStatus()` theo action approve/reject roi PRG redirect) | [FeedbackDAO.java](src/main/java/org/example/daos/FeedbackDAO.java)/[FeedbackDAOImpl.java](src/main/java/org/example/daos/FeedbackDAOImpl.java) — `checkBadWords()`, `findPendingReview()`, `updateStatus()` deu la logic that | [Feedback.java](src/main/java/org/example/models/Feedback.java) (`status = VISIBLE/PENDING_REVIEW/REMOVED`, field view-only `targetName`/`highlightedComment`), bang moi `BannedWords` | [admin/KiemDuyetBinhLuan.jsp](src/main/web/admin/KiemDuyetBinhLuan.jsp) — Tab "Bình luận chờ duyệt" dung du lieu that + form POST that, Tab "Lịch sử xử lý" van la mock (xem muc 48 trong CRUD_DA_LAM.md) |
| `/khieu-nai` | [ComplaintServlet.java](src/main/java/org/example/controllers/ComplaintServlet.java) (roleId=3) | [ComplaintDAO.java](src/main/java/org/example/daos/ComplaintDAO.java)/[ComplaintDAOImpl.java](src/main/java/org/example/daos/ComplaintDAOImpl.java), OrderDAO (kiem tra quyen so huu don) | [Complaint.java](src/main/java/org/example/models/Complaint.java) (bang moi `Complaints`, xem `migration_complaints.sql`) | [user/khieuNai.jsp](src/main/web/user/khieuNai.jsp) — form gui + danh sach khieu nai cua khach, lien ket tu nut "📢 Khieu nai" tren [user/donhang.jsp](src/main/web/user/donhang.jsp) (xem muc 52 trong CRUD_DA_LAM.md) |
| `/admin/khieu-nai` | [AdminComplaintServlet.java](src/main/java/org/example/controllers/AdminComplaintServlet.java) (roleId=1, Super Admin) | ComplaintDAO/Impl | Complaint | [admin/QuanLyKhieuNai.jsp](src/main/web/admin/QuanLyKhieuNai.jsp) — loc theo trang thai, form phan hoi + Giai quyet/Tu choi (xem muc 52 trong CRUD_DA_LAM.md) |
| `/user/thong-bao` | [UserNotificationServlet.java](src/main/java/org/example/controllers/UserNotificationServlet.java) (roleId=3) | [NotificationDAO.java](src/main/java/org/example/daos/NotificationDAO.java)/[NotificationDAOImpl.java](src/main/java/org/example/daos/NotificationDAOImpl.java) (bang co san `Notifications`, truoc chi dung cho shipper) | [Notification.java](src/main/java/org/example/models/Notification.java) | [user/thongBao.jsp](src/main/web/user/thongBao.jsp) — danh sach + danh dau da doc; link 🔔 kem badge so chua doc tren `trangnguoidung.jsp`, link don gian tren `donhang.jsp`/`khieuNai.jsp`/`diaChi.jsp` (xem muc 53 trong CRUD_DA_LAM.md) |
| `/shipper/thongbao` | [ShipperNotificationServlet.java](src/main/java/org/example/controllers/ShipperNotificationServlet.java) (roleId=4) | NotificationDAO/Impl | Notification | [shipper/thongbao.jsp](src/main/web/shipper/thongbao.jsp) — hop thu hoat dong rieng cua shipper (da co truoc, khong doi) |
| `/ws/notifications` (WebSocket) | [NotificationEndpoint.java](src/main/java/org/example/websocket/NotificationEndpoint.java) (khong phai Servlet HTTP, dung chung `HttpSessionConfigurator` voi `TrackingEndpoint`) | - (khong co DAO rieng — `NotificationDAOImpl.create()` goi `NotificationEndpoint.push()` sau khi INSERT thanh cong) | Notification | [assets/js/notifications-ws.js](src/main/web/assets/js/notifications-ws.js) — script dung chung: mo WebSocket, hien toast + cap nhat badge `[data-notif-badge]` realtime; dung tren `user/trangnguoidung.jsp`, `user/donhang.jsp`, `user/khieuNai.jsp`, `user/diaChi.jsp`, `user/thongBao.jsp`, `shipper/thongbao.jsp` (xem muc 54 trong CRUD_DA_LAM.md) |

## 4. Các trang JSP khác chưa gắn servlet rõ ràng (theo role)

- `user/trangnguoidung.jsp` — trang chủ người dùng.
- `shipper/trangchucuashipper.jsp` — trang chủ shipper.
- `quanLyCuaHang.jsp`, `shopThemSua.jsp` — quản lý cửa hàng.
- `index.jsp` — trang chủ chung.

## 5. Filter (chặn truy cập / phân quyền)

- [AuthFilter.java](src/main/java/org/example/filter/AuthFilter.java) — kiểm tra đăng nhập/phân quyền theo role.
- [AppFilter.java](src/main/java/org/example/filter/AppFilter.java) — filter chung của app (vd: set encoding).

## 6. Models (entity, tên bảng DB tương ứng)

`Account, Cart, CartItem, CartItemTopping, Category, Order, OrderDetail, OrderDetailTopping, OrderLog, Product, ProductImage, ProductSize, Role, Shop, Topping, ToppingCategory` — đều ở [src/main/java/org/example/models/](src/main/java/org/example/models). (Ngoài ra còn `UserAddress.java` cho `/user/dia-chi`.)

`Order` và `UserAddress` có thêm 2 field `Double locationX` (vĩ độ) / `Double locationY` (kinh độ) để lưu tọa độ chọn trên bản đồ Leaflet — xem [CRUD_DA_LAM.md](CRUD_DA_LAM.md) mục 22.

`Complaint.java` (bảng mới `Complaints`, khách hàng khiếu nại đơn hàng, Admin xử lý) — xem [CRUD_DA_LAM.md](CRUD_DA_LAM.md) mục 52.

## 7. Quy ước khi thêm chức năng mới (theo pattern đã có, xem [CRUD_DA_LAM.md](CRUD_DA_LAM.md))

1. Tạo `XxxDAO` (interface) + `XxxDAOImpl` trong `daos/`.
2. Tạo Servlet trong `controllers/` với `@WebServlet("/duong-dan")`, gọi DAO.
3. Tạo JSP danh sách (`xxxDanhSach.jsp`) + JSP thêm/sửa (`xxxThemSua.jsp`) trong `src/main/web/` (hoặc thư mục role tương ứng: `shop/` cho shop owner, `admin/` cho super admin, `user/`, `shipper/`).
4. Validate input ở servlet, redirect kèm `success`/`error` qua query string.
5. DAO nên tự dò tên bảng số ít/số nhiều và cột `is_deleted` (xoá mềm) nếu có, theo pattern đã dùng ở Cart/Order.

## 8. Khi user yêu cầu sửa/thêm tính năng — tra nhanh

- "Sửa giỏ hàng" → mục `/cart`, `/cart-items` ở bảng trên.
- "Sửa bấm bill/thanh toán/checkout/hóa đơn" → `/checkout` (giỏ hàng → tạo Order/OrderDetail), `/bill` (khách hàng xem/in hóa đơn), `/shop/bills` (shop owner xem/in hóa đơn các đơn thuộc shop mình, dùng chung [BillUtil.java](src/main/java/org/example/utils/BillUtil.java) với `/bill`).
- "Sửa đơn hàng" → mục `/orders`, `/order-details`.
- "Sửa trang quản lý sản phẩm/loại sản phẩm/topping của shop" → mục `/shop/products`, `/shop/product-types`, `/shop/toppings`, `/shop/topping-categories`, JSP trong `shop/`.
- "Sửa đăng nhập/đăng ký/quên mật khẩu/OTP" → các servlet `DangNhapServlet, DangKyServlet, QuenMatKhauServlet, XacNhanOTPServlet`.
- "Sửa duyệt shop / super admin" → `SuperAdminShopRequestServlet`, `TongQuanServlet`, JSP trong `admin/`.
- "Sửa kết nối DB" → [DBUtil.java](src/main/java/org/example/utils/DBUtil.java).
- "Sửa gửi mail" → [EmailUtil.java](src/main/java/org/example/utils/EmailUtil.java).
- "Sửa theo dõi vị trí shipper realtime / bản đồ đang giao hàng" → [TrackingEndpoint.java](src/main/java/org/example/websocket/TrackingEndpoint.java), [HttpSessionConfigurator.java](src/main/java/org/example/websocket/HttpSessionConfigurator.java), [orderTrackingMap.js](src/main/web/assets/js/orderTrackingMap.js), `shipper/chitietdonhang.jsp`, `user/donhang.jsp` — xem [CRUD_DA_LAM.md](CRUD_DA_LAM.md) mục 25.
- "Sửa thông báo (Notification) / bell 🔔 / realtime khi đơn đổi trạng thái" → [UserNotificationServlet.java](src/main/java/org/example/controllers/UserNotificationServlet.java) (`/user/thong-bao`), [ShipperNotificationServlet.java](src/main/java/org/example/controllers/ShipperNotificationServlet.java) (`/shipper/thongbao`), [NotificationEndpoint.java](src/main/java/org/example/websocket/NotificationEndpoint.java) (`/ws/notifications`), [notifications-ws.js](src/main/web/assets/js/notifications-ws.js) — điểm tạo Notification duy nhất là `NotificationDAOImpl.create()`, tự động push realtime, không cần sửa từng servlet gọi nó — xem [CRUD_DA_LAM.md](CRUD_DA_LAM.md) mục 53, 54.
