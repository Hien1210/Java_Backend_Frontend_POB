# CRUD da lam

## 1. CRUD gio hang

Endpoint: `/cart`

Da them backend:

- `src/main/java/org/example/daos/CartDAO.java`
- `src/main/java/org/example/daos/CartDAOImpl.java`
- `src/main/java/org/example/controllers/CartServlet.java`

Da sua giao dien:

- `src/main/web/themSuaGioHang.jsp`

Chuc nang da co:

- Xem danh sach gio hang.
- Them gio hang moi.
- Sua gio hang.
- Xoa gio hang.
- Validate `userId`.
- Redirect thong bao ket qua bang query string `success`/`error`.
- DAO tu nhan dien bang `Carts` hoac `Cart`.
- DAO ho tro cot `is_deleted` neu database co cot xoa mem.

Ghi chu:

- Neu tao moi bi loi validate, form van giu dung che do them moi thay vi bi nham sang sua.
- Khi cap nhat gio hang ma bo trong ngay tao, he thong giu lai ngay tao cu.

## 2. CRUD don hang

Endpoint: `/orders`

Da them backend:

- `src/main/java/org/example/daos/OrderDAO.java`
- `src/main/java/org/example/daos/OrderDAOImpl.java`
- `src/main/java/org/example/controllers/OrderServlet.java`

Da them giao dien:

- `src/main/web/orderDanhSach.jsp`
- `src/main/web/orderThemSua.jsp`

Chuc nang da co:

- Xem danh sach don hang.
- Them don hang moi.
- Sua don hang.
- Xoa don hang.
- Validate cac field chinh:
  - `userId`
  - ten nguoi nhan
  - so dien thoai nguoi nhan
  - dia chi giao hang
  - tong tien
  - phi giao hang
- DAO tu nhan dien bang `Orders` hoac `Order`.
- DAO ho tro cot `is_deleted` neu database co cot xoa mem.
- Ho tro cac cot tuy chon neu database co:
  - `shipper_id`
  - `delivery_fee`
  - `payment_method`
  - `status`
  - `estimated_delivery_time`
  - `created_at`
  - `updated_at`

## 3. CRUD chi tiet gio hang

Endpoint: `/cart-items`

Da them backend:

- `src/main/java/org/example/daos/CartItemDAO.java`
- `src/main/java/org/example/daos/CartItemDAOImpl.java`
- `src/main/java/org/example/controllers/CartItemServlet.java`

Da them giao dien:

- `src/main/web/cartItemDanhSach.jsp`
- `src/main/web/cartItemThemSua.jsp`

Chuc nang da co:

- Xem danh sach chi tiet gio hang.
- Them chi tiet gio hang.
- Sua chi tiet gio hang.
- Xoa chi tiet gio hang.
- Validate `cartId`, `productId`, `quantity`.

## 4. CRUD chi tiet don hang

Endpoint: `/order-details`

Da them backend:

- `src/main/java/org/example/daos/OrderDetailDAO.java`
- `src/main/java/org/example/daos/OrderDetailDAOImpl.java`
- `src/main/java/org/example/controllers/OrderDetailServlet.java`

Da them giao dien:

- `src/main/web/orderDetailDanhSach.jsp`
- `src/main/web/orderDetailThemSua.jsp`

Chuc nang da co:

- Xem danh sach chi tiet don hang.
- Them chi tiet don hang.
- Sua chi tiet don hang.
- Xoa chi tiet don hang.
- Validate `orderId`, `productId`, `quantity`, `price`.

## 5. CRUD Topping va Loai Topping (shop owner)

Endpoint: `/shop/toppings`, `/shop/topping-categories`

Truoc khi sua: `ToppingDAO`/`ToppingDAOImpl` chua ton tai du da duoc `ShopToppingServlet` goi toi
(project khong compile duoc). Ngoai ra `ToppingCategory` va `ToppingCategoryDAOImpl` dung cot
`category_name`/`status` khong co trong bang `ToppingCategories` thuc te (DB chi co `name`,
`description`, `is_deleted`). Topping JSP cho chon status `HIDDEN`/`INACTIVE` trong khi cot
`status` cua bang `Toppings` co CHECK chi cho `ACTIVE`/`OUT_OF_STOCK`.

Da sua/them backend:

- `src/main/java/org/example/daos/ToppingDAO.java` (moi)
- `src/main/java/org/example/daos/ToppingDAOImpl.java` (moi, join sang `ToppingCategories` de lay ten loai)
- `src/main/java/org/example/daos/ToppingCategoryDAO.java` (doi ten tu `ToppingcategoryDAO.java` cho dung quy uoc Java)
- `src/main/java/org/example/daos/ToppingCategoryDAOImpl.java` (sua lai dung cot `name`/`description`)
- `src/main/java/org/example/models/ToppingCategory.java` (doi `categoryName`->`name`, bo `status` gia, them `description`)
- `src/main/java/org/example/controllers/ShopToppingServlet.java` (chuan hoa status chi ACTIVE/OUT_OF_STOCK)
- `src/main/java/org/example/controllers/Quanlyloaitoppingservlet.java` (doc form theo `name`/`description`, bo thong ke theo status)

Da sua giao dien:

- `src/main/web/admin/Quanlytopping.jsp` (dropdown status chi con ACTIVE/OUT_OF_STOCK, sua tham chieu `cat.name`)
- `src/main/web/admin/Quanlyloaitopping.jsp` (form/doi bang dung `name`+`description`, bo cot trang thai)

Chuc nang da co:

- Xem danh sach topping / loai topping theo shop.
- Them, sua, xoa (mem) topping va loai topping.
- Validate ten, loai topping phai thuoc dung shop, gia >= 0.

Ghi chu:

- Project gio compile sach (`javac` toan bo `src/main/java`, khong loi).
- Day la vi du ve viec model/DAO bi lech voi schema thuc te trong `Database.txt` — luon doi chieu ten cot
  voi `Database.txt` truoc khi them DAO moi.

## 6. CRUD San Pham, Loai San Pham va Thong Tin Cua Hang (shop owner)

Endpoint: `/shop/products`, `/shop/product-types`, `/shop/profile`

Cac loi thuc te tim thay va da sua:

- Hai servlet `ShopProductTypeServlet` va `QuanLyLoaiSanPhamServlet` cung map `@WebServlet("/shop/product-types")`
  (trung URL, container se loi khi deploy). Da xoa file `QuanLyLoaiSanPhamServlet.java` (khong noi nao goi toi),
  giu lai `ShopProductTypeServlet.java`.
- `ProductSizeDAOImpl.update()` build SQL voi cot `stock_quantity` khong ton tai trong bang `Product_Sizes`,
  va bind thieu 1 tham so (3 gia tri cho 4 dau `?`) -> sua size luon loi. Da sua lai SQL chi con
  `size_name`, `price`.
- JSP `Quanlysanpham.jsp` gui size voi ten field `sizePrice[]` nhung `ShopProductServlet` lai doc
  `priceAdjust[]` -> gia cua size khong bao gio duoc luu (luon mac dinh 0, vi pham CHECK price > 0 cua
  `Product_Sizes`). Da sua servlet doc dung `sizePrice[]`.
- JSP co o nhap "Gia ban" rieng o cap san pham va nhap "Ton kho" rieng cho tung size, nhung ca hai deu
  khong duoc servlet doc/luu (Products khong co cot gia, Product_Sizes khong co cot ton kho theo size).
  Da bo 2 o nay khoi form de tranh nham lan; gia ban hien thi/luu hoan toan qua size.
- EL `${productSua.status}` trong modal sua san pham bi loi vi model `Product` chi co getter `getStaTus()`
  (chu T hoa, khong phai chuan `status`) -> sua thanh `productSua.staTus`.
- Thieu validate "phai co it nhat 1 size voi gia > 0" truoc khi tao/sua san pham — da them, neu khong co
  size hop le se bao loi va khong tao san pham mo coi (khong gia).
- `ShopProductServlet.forwardProductPage()` chua gan cac bien thong ke `soDangBan`, `soHetHang`,
  `tongDaBan` ma JSP can hien thi — da tinh va set trong servlet.
- Form sua thong tin cua hang trong `Shopprofile.jsp` submit toi `/shop/profile` nhung khong co servlet
  nao map URL nay (404 khi bam Luu). Da tao moi `ShopProfileServlet.java` (GET hien thi, POST update),
  chi cap nhat 5 truong ho so (`shopName`, `shopDescription`, `shopAddress`, `shopPhone`, `shopLogo`),
  giu nguyen status/owner/API keys cua shop.

Ghi chu:

- `Category`/`CategoryDAOImpl` (loai san pham) van con field `status` nhung bang `Categories` thuc te
  khong co cot nay — DAO tu do schema bang `DatabaseMetaData` nen khong bi loi SQL (chi bo qua cot status
  khi khong tim thay), nhung tinh nang "trang thai loai san pham" tren JSP se khong bao gio luu duoc.
  Khong sua vi khong gay loi runtime, chi ghi chu lai cho lan sau.
- Project van compile sach sau khi sua (`javac` toan bo `src/main/java`).

## 7. Bam bill thanh toan (checkout + hoa don)

Endpoint: `/checkout`, `/bill`

Da them backend:

- `src/main/java/org/example/controllers/CheckoutServlet.java` (moi) — GET hien hoa don tam tu
  gio hang de xac nhan, POST tao `Order` + `OrderDetail` tu `CartItem` roi xoa cac `CartItem` da
  thanh toan.
- `src/main/java/org/example/controllers/BillServlet.java` (moi) — hien hoa don chi tiet (san
  pham, size, so luong, gia, tong tien) cho 1 hoac nhieu don hang, co nut in (`window.print()`).
- `CartItemDAO`/`CartItemDAOImpl`: them `findByCartId(cartId)`.
- `OrderDetailDAO`/`OrderDetailDAOImpl`: them `findByOrderId(orderId)`.
- `OrderDAO`/`OrderDAOImpl`: them `createAndReturnId(order)` (dung `RETURN_GENERATED_KEYS`) vi
  `create()` cu chi tra `Boolean`, khong co cach lay lai id don vua tao de gan vao `OrderDetail`.

Da them giao dien:

- `src/main/web/checkoutThanhToan.jsp` — bang chi tiet hoa don tam + form nhap nguoi nhan,
  dia chi, phuong thuc thanh toan, phi giao hang.
- `src/main/web/hoaDon.jsp` — hoa don sau khi thanh toan thanh cong, co the in.
- `src/main/web/DanhSachGioHang.jsp` — them nut "💳 Thanh toan" o moi gio hang, them thong bao
  loi `empty_cart`.

Chuc nang da co:

- Bam "Thanh toan" tu mot gio hang -> xem lai hoa don tam (san pham, size, don gia, thanh tien
  theo tung shop) -> nhap thong tin nguoi nhan + phuong thuc thanh toan -> xac nhan se tao 1
  `Order` rieng cho moi shop co trong gio hang (vi 1 don hang chi gan voi 1 `shop_id`), kem
  `OrderDetail` tuong ung, roi xoa cac `CartItem` da thanh toan khoi gio hang.
- Xem/in lai hoa don chi tiet cho cac don hang vua tao qua `/bill?orderIds=1,2,3`.

Han che/gia dinh da biet (ghi lai de lan sau xem):

- `CartItem` hien khong luu `product_size_id` (chi co `cart_id`, `product_id`, `quantity`), nen
  khi checkout, gia duoc lay theo **size re nhat** cua san pham (`ProductSizeDAO.findByProductId`
  roi chon `price` nho nhat). Neu can chon dung size luc them vao gio hang thi phai sua schema +
  DAO cua `CartItem` de luu them `product_size_id`.
- Phi giao hang (`deliveryFee`) nguoi dung nhap 1 lan duoc ap dung cho **moi** don hang tach theo
  shop (gia dinh moi shop la 1 lan giao hang rieng), khong chia deu.
- Neu tao `Order` cho shop dau tien thanh cong nhung loi o shop tiep theo (vd mat ket noi DB
  giua chung), cac don da tao truoc do se khong bi rollback (khong dung transaction) — chap nhan
  duoc voi pham vi do an, can luu y neu mo rong sau.

## 8. Dong bo giao dien bam bill cho Shop (xem/in hoa don theo shop)

Endpoint: `/shop/bills`

Phat hien loi quan trong khi lam phan nay: `OrderDAOImpl` **khong he doc/ghi cot `shop_id`**
(schema dynamic chi co `id, user_id, shipper_id, ...`, thieu han `shop_id`). Nghia la
`CheckoutServlet` o muc 7 da goi `order.setShopId(...)` nhung gia tri nay bi am tham bo qua khi
luu xuong DB — moi `Order` tao ra deu co `shop_id = 0` (sai). Da sua:

- `OrderDAO`/`OrderDAOImpl`: them `shop_id` vao schema dong (bat buoc, giong `user_id`), doc/ghi
  day du trong `create`, `createAndReturnId`, `update`, `getAll`, `findById`; them method moi
  `findByShopId(shopId)` de loc don hang theo shop.
- `OrderServlet` (CRUD admin chung `/orders`) + `orderThemSua.jsp`, `orderDanhSach.jsp`: them
  truong/cot **Shop ID** (bat buoc) vi form nay truoc gio khong nhap shop_id, se loi sau khi
  sua DAO o tren.

Tach logic dung hoa don ra dung chung (tranh lap code giua khach hang va shop):

- `org/example/models/BillView.java`, `BillLine.java` (model, chuyen ra tu `BillServlet` cu).
- `org/example/utils/BillUtil.java` (moi) — `BillUtil.build(order)` dung 1 `BillView` day du
  (san pham, size, gia, tong) tu 1 `Order`. Dung chung boi `BillServlet` (`/bill`, khach hang xem
  sau checkout) va `ShopBillServlet` (`/shop/bills`, shop owner xem/in lai).

Da them backend cho Shop:

- `src/main/java/org/example/controllers/ShopBillServlet.java` (moi) — `@WebServlet("/shop/bills")`,
  kiem tra `account.roleId == 2` + chu shop dung loai (`shopDAO.selectShopByOwnerId`), danh sach
  don hang cua shop (`orderDAO.findByShopId`), xem hoa don 1 don (`action=view&id=`) co kiem tra
  don do co thuoc dung shop khong truoc khi cho xem.

Da them/dong bo giao dien:

- `src/main/web/shop/Quanlybill.jsp` (moi) — danh sach don hang cua shop, dung dung theme/sidebar
  F&B (CSS variables, sidebar cam) nhu cac trang Shop khac, co nut "🧾 Xem hoa don" tren tung dong.
- `src/main/web/shop/HoaDonShop.jsp` (moi) — hoa don chi tiet trong layout Shop (sidebar + theme),
  nut in (`window.print()`), nut quay lai danh sach.
- Them muc menu **"🧾 Hoa don / Don hang"** (section "Don hang") vao sidebar cua TAT CA trang
  Shop hien co de dong bo navigation: `Shopprofile.jsp`, `trangcuahang.jsp`, `Quanlysanpham.jsp`,
  `Quanlyloaisanpham.jsp`, `Quanlytopping.jsp`, `Quanlyloaitopping.jsp` (truoc do moi trang tu
  copy-paste sidebar rieng, khong co lien ket toi `/shop/bills`).

Chuc nang da co:

- Shop owner vao sidebar bam "Hoa don / Don hang" -> xem danh sach don hang cua shop minh (nguoi
  nhan, dia chi, tong tien, trang thai) -> bam "Xem hoa don" tren 1 don -> xem chi tiet (san pham,
  size, so luong, don gia, tong tien, phi giao hang) va in duoc.

Ghi chu:

- Trang `/shop` (`trangcuahang.jsp`) co san mot bang "Don hang gan day" nhung dung sai ten field
  (`order.customerName`, `order.totalAmount`, `order.status` — khong khop voi model `Order` thuc
  te co `receiverName`, `totalPrice`, `staTus`) va `ShopHomeServlet` khong he set attribute
  `donHangGanDay`/`tongSanPham`/... nen bang nay luon rong. Day la van de co san tu truoc, khong
  sua trong lan nay vi ngoai pham vi "dong bo giao dien bam bill".

## 9. Thanh toan online qua PayOS (QR Code)

Endpoint: `/checkout` (chon paymentMethod=PAYOS), `/payos/return`, `/payos/webhook`

Bo sung:

- DB: them cot `payos_order_code` (BIGINT NULL) vao bang `Orders` —
  `migration_payos_order_code.sql`. Dung de noi 1 Order voi 1 link thanh toan PayOS
  (PayOS yeu cau 1 `orderCode` so nguyen duy nhat, dung lai `id` cua Order cho gon).
- `Shop` da co san field `clientKey`/`apiKey`/`checkSumKey` (cot DB thuc te: `client_key`,
  `api_key`, `check_sum_key`) nhung truoc gio khong duoc DAO doc/ghi — da sua trong
  `ShopDAOImpl` (xem muc 6 cap nhat) de man hinh `/shop/profile` nhap duoc 3 gia tri nay.
- `org/example/utils/PayOSUtil.java` (moi) — goi REST API PayOS thuan (khong dung SDK,
  vi chua co trong repo Maven noi bo):
  - `createPaymentLink(...)`: tao link thanh toan QR, tu ky HMAC-SHA256 bang `checkSumKey`
    cua shop theo dung thu tu field PayOS yeu cau (amount/cancelUrl/description/orderCode/returnUrl).
  - `getPaymentStatus(...)`: goi lai API PayOS lay trang thai thuc cua 1 `orderCode`
    (KHONG tin truc tiep query string tren returnUrl vi nguoi dung co the tu sua URL).
  - `verifyWebhookSignature(...)`: verify chu ky webhook PayOS gui len bang `checkSumKey`.
- `OrderDAO`/`OrderDAOImpl`: them cot dong `payos_order_code` vao schema (giong pattern
  cac cot tuy chon khac), them `setPayosOrderCode`, `findByPayosOrderCode`,
  `updatePaymentStatusByPayosOrderCode`.
- `CheckoutServlet`: them nhanh xu ly khi `paymentMethod = PAYOS`:
  - Chi cho phep khi gio hang chi co 1 shop (PayOS gan voi 3-key cua 1 shop, khong the
    gop nhieu shop vao 1 link thanh toan) — bao loi yeu cau thanh toan rieng tung shop neu
    gio hang co nhieu shop.
  - Kiem tra shop da nhap du 3 key chua, neu thieu thi bao loi.
  - Tao Order (status PENDING, payment_status UNPAID mac dinh) nhu binh thuong, roi goi
    `PayOSUtil.createPaymentLink` voi `orderCode = order.id`, `amount = round(totalPrice)`.
  - Thanh cong: luu `payos_order_code`, xoa cac CartItem da thanh toan, redirect sang
    `checkoutUrl` cua PayOS (trang QR ben ngoai).
  - Thanh toan that bai khi tao link (vd loi ket noi/sai key): KHONG xoa gio hang, hien lai
    trang xac nhan hoa don voi thong bao loi de nguoi dung sua/thu lai.
- `PayOSReturnServlet` (moi, `/payos/return`) — PayOS redirect nguoi dung ve day sau khi
  thanh toan xong/huy. Doc `orderCode` tu query string, tim lai Order, **goi lai API PayOS
  de lay trang thai thuc** (khong doc thang `status` tren query string), neu `PAID` thi cap
  nhat `payment_status = PAID` va redirect sang `/bill?orderIds=`, nguoc lai forward sang
  `thanhToanThatBai.jsp`.
- `PayOSWebhookServlet` (moi, `/payos/webhook`) — endpoint server-to-server PayOS goi khi
  link thanh toan doi trang thai; verify chu ky bang `checkSumKey` cua dung shop truoc khi
  cap nhat `payment_status = PAID`. Can cau hinh URL nay tren PayOS Dashboard cua shop voi
  domain public (khong hoat dong duoc tren localhost) — voi do an chay local, nguon xac nhan
  chinh van la `/payos/return`.
- `thanhToanThatBai.jsp` (moi) — trang hien khi thanh toan PayOS khong thanh cong/bi huy.
- `checkoutThanhToan.jsp` — doi option "Thanh toan online" (`ONLINE`, chua gan voi cong nao)
  thanh "Thanh toan online qua PayOS" (`PAYOS`).

Han che/gia dinh da biet:

- Moi link PayOS gan voi dung 1 shop (dung 3 key cua shop do) nen gio hang nhieu shop khong
  the thanh toan PayOS gop 1 lan — phai tach checkout theo tung shop (gio han co san trong
  thiet ke checkout hien tai, theo `byShop`).
- Khong dung transaction: neu tao Order xong nhung goi PayOS loi, Order van ton tai trong DB
  o trang thai PENDING/UNPAID (khong rollback) — nguoi dung co the tao checkout moi nhung
  Order cu se "treo", co the don dep thu cong sau. Phu hop pham vi do an.
- Webhook can domain public moi nhan duoc (PayOS khong goi toi localhost) — chi xac nhan
  duoc that su khi deploy len server co domain/IP cong khai.

## 10. Tich hop PayOS thuc su cho POS ("Bam Bill")

Endpoint: `/shop/pos` (chon phuong thuc PAYOS), `/payos/return?source=pos`

Truoc do `/shop/pos` (`ShopPosServlet`, `Banhang.jsp`) co nut chon "🏦 PayOS" nhung chi luu
`paymentMethod='MOMO'` (ten gia, khong goi API nao) — hoa don tao xong ngay va hien placeholder
"Đang chờ tích hợp PayOS". Da sua de goi PayOS thuc su, dung lai `PayOSUtil` da lam o muc 9:

- `mapPaymentMethod`: bo map gia "PAYOS"->"MOMO", luu dung `paymentMethod='PAYOS'`.
- `createOrder()`: neu `paymentMethod=PAYOS`:
  - Kiem tra shop co du 3 key chua, thieu thi bao loi truoc khi tao don.
  - Tao Order/OrderDetail/OrderDetailTopping nhu thuong (paymentStatus=PENDING,
    staTus=PENDING — khac voi CASH/QR la staTus=DONE ngay vi PayOS chua xac nhan thanh toan),
    roi goi `PayOSUtil.createPaymentLink(...)` voi `returnUrl=/payos/return?source=pos`.
  - Thanh cong: luu `payos_order_code`, redirect sang `checkoutUrl` cua PayOS.
  - That bai luc tao link (sai key/mat ket noi): xoa luon OrderDetail + Order vua tao (khong
    de don "treo"), bao loi tren `Banhang.jsp`.
  - Them action moi `discardOrder` (POST `/shop/pos`, param `id`): xoa (mem) 1 Order +
    OrderDetail cua dung shop, dieu kien `paymentStatus != PAID` — dung cho nut "Xac nhan"
    tren trang thanh toan that bai de dam bao "khong luu bill".
- `PayOSReturnServlet`: them tham so `source` tren returnUrl de phan nhanh UI sau khi PayOS
  xac nhan trang thai thuc (van goi lai API PayOS, khong tin query string):
  - `source=pos` + PAID: cap nhat `payment_status=PAID`, `staTus=DONE`, redirect
    `/shop/pos?invoiceId=<id>` (trang in hoa don co san, dung lai `_invoiceModal.jspf`).
  - `source=pos` + khong PAID: forward `shop/ThanhToanThatBaiPos.jsp` (moi) — trang thong bao
    co nut "✅ Xac nhan" submit POST `/shop/pos?action=discardOrder&id=...` -> huy don, ve
    `/shop/pos`.
  - `source=cart` (hoac khong co `source`, mac dinh): giu nguyen hanh vi cu — PAID thi sang
    `/bill?orderIds=`, khong PAID thi forward `thanhToanThatBai.jsp` (khong xoa don, cho phep
    "treo" de xem lai, theo ghi chu han che da co tu muc 9).
- `CheckoutServlet`: returnUrl doi thanh `/payos/return?source=cart` cho ro nghia (hanh vi
  khong doi, source=cart la nhanh mac dinh).
- `_invoiceModal.jspf`: sua dieu kien hien nhan "🏦 PayOS" tu `paymentMethod == 'MOMO'` (cu)
  thanh `paymentMethod == 'PAYOS'`; bo placeholder QR "Đang chờ tích hợp PayOS", thay bang
  "✅ Đã thanh toán qua PayOS" (vi luc xem hoa don nay thi PayOS da xac nhan PAID roi).

## 19. Xoa mem (Soft Delete) va Thung Rac cho CRUD Shop

Cac CRUD quan ly shop (san pham, topping, loai san pham, loai topping) da co cot `is_deleted` trong
DB nen viec xoa mem da ton tai tu truoc (DAO ghi `is_deleted = 1` thay vi DELETE). Lan nay bo sung
tinh nang **Thung Rac + Khoi Phuc** cho 4 module:

Da sua backend (DAO interface + impl):

- `src/main/java/org/example/daos/ProductDAO.java`: them `findDeletedByShopId(shopId)`,
  `restore(id, shopId)`
- `src/main/java/org/example/daos/ProductDAOImpl.java`: them 2 method tuong ung, dung SQL
  `WHERE is_deleted = 1` de lay danh sach tron thung rac, va `SET is_deleted = 0` de khoi phuc.
- `src/main/java/org/example/daos/ToppingDAO.java`: them `findDeletedByShopId(shopId)`,
  `restore(id)`
- `src/main/java/org/example/daos/ToppingDAOImpl.java`: them 2 method, join sang ToppingCategories
  de lay ten loai.
- `src/main/java/org/example/daos/ToppingCategoryDAO.java`: them `findDeletedByShopId(shopId)`,
  `restore(id)`
- `src/main/java/org/example/daos/ToppingCategoryDAOImpl.java`: them 2 method tuong ung.
- `src/main/java/org/example/daos/CategoryDAO.java`: them `findDeletedByShopId(shopId)`,
  `restore(id)`
- `src/main/java/org/example/daos/CategoryDAOImpl.java`: them 2 method tuong ung dung schema dong.

Da sua backend (Servlet):

- `src/main/java/org/example/controllers/ShopProductServlet.java`:
  - GET `action=trash` -> tai danh sach san pham bi xoa, forward `/shop/ThungRacSanPham.jsp`.
  - POST `action=restore` -> goi `productDAO.restore(id, shopId)`, redirect ve trang trash.
- `src/main/java/org/example/controllers/ShopToppingServlet.java`: tuong tu cho topping.
- `src/main/java/org/example/controllers/ShopProductTypeServlet.java`: tuong tu cho loai san pham.
- `src/main/java/org/example/controllers/QuanLyLoaiToppingServlet.java`: tuong tu cho loai topping.

Da them giao dien:

- `src/main/web/shop/ThungRacSanPham.jsp` (moi) - danh sach san pham trong thung rac.
- `src/main/web/shop/ThungRacTopping.jsp` (moi) - danh sach topping trong thung rac.
- `src/main/web/shop/ThungRacLoaiSanPham.jsp` (moi) - danh sach loai san pham trong thung rac.
- `src/main/web/shop/ThungRacLoaiTopping.jsp` (moi) - danh sach loai topping trong thung rac.
- Them nut "Thung rac" vao header cua 4 trang quan ly hien co:
  `Quanlysanpham.jsp`, `Quanlytopping.jsp`, `Quanlyloaisanpham.jsp`, `Quanlyloaitopping.jsp`.

Chuc nang da co:

- Xoa san pham/topping/loai san pham/loai topping -> vao thung rac (is_deleted = 1), khong mat data.
- Bam nut "Thung rac" trong trang quan ly -> xem danh sach cac muc da xoa cua shop minh.
- Bam "Khoi phuc" tren tung muc -> dat is_deleted = 0, hien thi lai trong danh sach chinh.
- Bao mat: chung tra shopId truoc khi khoi phuc san pham / topping, khong the khoi phuc muc cua shop khac.

Luu y: Cac trang JSP thung rac co cung theme F&B cam nhu cac trang shop hien co, nut khoi phuc mau xanh la (var(--success)).

## 11. Kiem tra da chay

Da compile toan bo `src/main/java` bang `javac` (qua PowerShell, classpath gom servlet-api,
mssql-jdbc, jstl, jbcrypt, javax.mail, org.json tu `.m2`) va khong co loi bien dich, bao gom
`CheckoutServlet`, `BillServlet`, `ShopBillServlet`, `BillUtil`, `PayOSUtil`,
`PayOSReturnServlet`, `PayOSWebhookServlet` va cac DAO moi sua.

Lenh Maven chua chay duoc vi moi truong hien tai khong co `mvn` trong PATH.

## 12. Cach test nhanh

Chay project tren Tomcat roi truy cap:

- `/cart` de quan ly gio hang.
- `/cart-items` de quan ly chi tiet gio hang.
- `/orders` de quan ly don hang.
- `/order-details` de quan ly chi tiet don hang.
- `/shop/toppings` de quan ly topping (can dang nhap tai khoan shop, shop da duoc duyet).
- `/shop/topping-categories` de quan ly loai topping.
- `/shop/products` de quan ly san pham (yeu cau nhap it nhat 1 size + gia khi tao/sua).
- `/shop/product-types` de quan ly loai san pham.
- `/shop/profile` de sua thong tin cua hang (ten, mo ta, dia chi, SDT, logo).
- `/cart` -> bam "💳 Thanh toan" tren mot gio hang co san pham -> xem hoa don tam -> dien thong
  tin nguoi nhan -> xac nhan se tao don hang va chuyen sang `/bill?orderIds=...` de xem/in hoa don.
- `/shop/bills` (dang nhap tai khoan shop, shop da duoc duyet) de xem danh sach don hang cua shop
  va bam "🧾 Xem hoa don" tren 1 don de xem/in chi tiet hoa don ngay trong giao dien Shop.
- `/shop/profile` -> nhap Client ID/API Key/Checksum Key cua shop (lay tu PayOS Dashboard) ->
  Luu. `/cart` -> Thanh toan -> chon "Thanh toan online qua PayOS" -> Xac nhan -> he thong tao
  don hang + goi PayOS tao link QR -> chuyen sang trang thanh toan PayOS. Quet QR/thanh toan
  xong, PayOS redirect ve `/payos/return`: thanh cong -> `/bill?orderIds=...`, that bai/huy ->
  `thanhToanThatBai.jsp`.
- `/shop/pos` -> chon mon -> chon phuong thuc "🏦 PayOS" -> Xac nhan -> chuyen sang trang
  thanh toan PayOS. Thanh cong -> ve `/shop/pos?invoiceId=...` (modal hoa don, da PAID). That
  bai/huy -> trang "Thanh toán PayOS thất bại" -> bam "✅ Xac nhan" -> don vua tao bi huy
  (khong luu bill) va quay ve `/shop/pos` de bam bill lai.

## 13. Hien thi "Hinh thuc" (phuong thuc thanh toan) trong Quan ly hoa don cua Shop

Endpoint: `/shop/bills`

Nguoi dung phan anh trang `Quanlybill.jsp` chi co cot "Thanh toan" (PAID/UNPAID/PENDING) nhung
khong cho biet khach thanh toan bang gi (Tien mat / QR chuyen khoan / PayOS). Logic "Da thanh
toan" theo `payment_status` thi da co san tu truoc (set PAID ngay khi CASH o `/shop/pos`, cap
nhat PAID qua webhook/return cho PayOS, xac nhan tay qua pill PENDING/PAID cho QR chuyen khoan
vi khong co cong thanh toan nao xac thuc duoc giao dich chuyen khoan tay) — khong sua lai phan
nay, chi bo sung hien thi:

- `src/main/web/shop/Quanlybill.jsp`: them cot "Hinh thuc" vao bang danh sach, doc
  `o.paymentMethod` (BANK -> 📱 QR chuyen khoan, PAYOS -> 🏦 PayOS, con lai -> 💵 Tien mat),
  dung chung logic hien thi voi `_invoiceModal.jspf`.
- `src/main/web/shop/HoaDonShop.jsp`: them dong "Phuong thuc thanh toan" (icon + ten) va dong
  "Thanh toan" (badge PAID/PENDING/UNPAID) vao trang chi tiet hoa don (truoc do chi in tho
  `bill.order.paymentMethod`, khong co dong trang thai thanh toan).

Ghi chu: Khong co thay doi backend/DAO, chi sua JSP hien thi du lieu da co san tren `Order`.

## 14. Bo loc theo hinh thuc thanh toan trong Quan ly hoa don cua Shop

Endpoint: `/shop/bills?method=COD|BANK|PAYOS`

Bo sung bo loc moi ben canh bo loc "Thanh toan" (UNPAID/PAID/CANCELLED) da co tu truoc:

- `src/main/java/org/example/controllers/ShopBillServlet.java`: doc them param `method`, them
  vao `filterOrders(...)` (sua signature them tham so `methodFilter`), so khop bang
  `normalizePaymentMethod(o.getPaymentMethod())` — coi `COD`/null/bat ky gia tri khac BANK,
  PAYOS la "Tien mat" (dong bo voi logic hien thi o `Quanlybill.jsp`/`_invoiceModal.jspf`).
- `src/main/web/shop/Quanlybill.jsp`: them dropdown "method" vao filter-bar (Tat ca hinh thuc /
  💵 Tien mat / 📱 QR chuyen khoan / 🏦 PayOS), giu lai lua chon da chon qua `${methodFilter}`.

Da compile lai toan bo `src/main/java` bang `javac`, khong loi.

## 15. Sua loi trang chu Shipper va thieu `product_size_id` trong gio hang

Cac loi thuc te tim thay va da sua:

- `shipper/trangchucuashipper.jsp` truoc do duoc truy cap truc tiep nhu file JSP tinh (qua
  `sendRedirect` thang toi `/shipper/trangchucuashipper.jsp` tu `DangNhapServlet`/`XacNhanOTPServlet`),
  khong co servlet nao set attribute `danhSachDonHang` -> trang luon trong. JSP con dung
  `${order.status}` (model `Order` chi co `getStaTus()`) va `${order.shopName}/${order.shopAddress}/${order.shopPhone}`
  (Order khong co cac field nay, chi co `shopId`) -> hien thi rong/sai. Form cap nhat trang thai
  submit toi `/quanlydonhang_shipper`, khong co servlet nao map URL do -> 404.
  Da sua:
  - Them `OrderDAO.findByShipperId(shipperId)` + impl trong `OrderDAOImpl`.
  - Tao moi `models/ShipperOrderView.java` (view rieng cho trang shipper, co san `status`,
    `shopName`, `shopAddress`, `shopPhone` khop dung JSP dang dung, khong sua JSP).
  - Tao moi `controllers/ShipperOrderServlet.java` (`@WebServlet("/shipper/donhang")`):
    GET lay don theo `findByShipperId`, join sang Shop de lay ten/dia chi/SDT, forward JSP;
    POST xu ly `updateStatusToShipping`/`updateStatusToDone` (kiem tra don dung thuoc shipper
    va dung trang thai truoc khi cap nhat).
  - `DangNhapServlet`, `XacNhanOTPServlet`: redirect shipper sang `/shipper/donhang` thay vi
    file JSP tinh.
  - `trangchucuashipper.jsp`: sua form action tu `/quanlydonhang_shipper` sang `/shipper/donhang`.
- `Cart_Items` (theo `Database.md`) co cot `product_size_id BIGINT NOT NULL` (FK sang
  `Product_Sizes`), nhung `CartItem` model va `CartItemDAOImpl` truoc do hoan toan khong biet
  cot nay, dong thoi `CartItemDAOImpl` dung sai ten bang `CartItems` (thuc te la `Cart_Items`,
  giong loi da gap voi `Order_Details` o cac muc truoc) -> moi cau lenh INSERT/SELECT/UPDATE/DELETE
  cua CartItem deu se loi "Invalid object name" khi chay thuc te tren DB. Da sua:
  - `models/CartItem.java`: them field `productSizeId` + getter/setter.
  - `daos/CartItemDAOImpl.java`: doi tat ca SQL tu bang `CartItems` sang `Cart_Items`, them
    cot `product_size_id` vao INSERT/SELECT/UPDATE.
  - `controllers/CartItemServlet.java`: doc/validate them `productSizeId` tu form.
  - `cartItemThemSua.jsp`, `cartItemDanhSach.jsp`: them o nhap/hien thi `Product Size ID`.
  - `CheckoutServlet.buildLines()`: truoc do luon lay size re nhat cua san pham (han che da
    ghi nhan o muc 7) vi `CartItem` khong luu size khach chon. Gio `CartItem` da co
    `productSizeId` nen sua lai dung `productSizeDAO.findById(item.getProductSizeId())` de lay
    dung size khach da chon khi them vao gio hang, khong con chon size re nhat nua.

Ghi chu:

- Chua co man hinh khach hang "them vao gio hang" tu trang san pham (chi co CRUD admin chung
  qua `/cart-items`), nen sau khi sua, nguoi goi `CartItemDAO.create()`/`update()` (vd. trang
  san pham sau nay) phai truyen dung `productSizeId` cua size khach chon, khong duoc bo trong.
- Da compile lai toan bo `src/main/java` bang `javac` (qua PowerShell/Bash voi classpath tu
  `.m2` + `jakarta.servlet-api`), khong loi.

## 16. Dashboard doanh thu cho Shop

Endpoint: `/shop` (trang chu shop, `trangcuahang.jsp`)

Truoc do `ShopHomeServlet` forward sang `trangcuahang.jsp` nhung khong he set bat ky attribute
thong ke nao (`tongSanPham`, `donChoXuLy`, `doanhThuHomNay`, `tongTopping`, `donHangGanDay`) ->
trang chu shop luon hien so 0/rong. Bang "Don hang gan day" co san cung dung sai ten field
(`order.customerName`, `order.totalAmount`, `order.status` thay vi `receiverName`, `totalPrice`,
`staTus` cua model `Order` thuc te) nen luon rong du co du lieu.

Da them moi:

- `src/main/java/org/example/models/ShopDashboardStats.java` (moi) — model gom doanh thu hom
  nay/tuan nay/thang nay, tong don/don hoan thanh/don huy/don cho xu ly, tong san pham, tong
  topping, danh sach top san pham ban chay, danh sach doanh thu 7 ngay gan day (cho bieu do).
- `src/main/java/org/example/daos/ShopDashboardDAO.java` + `ShopDashboardDAOImpl.java` (moi) —
  dung SQL truc tiep tren ten cot thuc te cua `Database.md` (giong pattern `ThongKeDAOImpl` cua
  admin, khong dung schema dong nhu `OrderDAOImpl` vi can SUM/GROUP BY):
  - Doanh thu = `SUM(total_price)` cua `Orders` co `status = 'DONE'`, loc theo `created_at` (hom
    nay / 7 ngay gan day / dau thang).
  - Dem don theo `status` (PENDING/DONE/CANCELLED) bang 1 query `GROUP BY status`.
  - Top san pham ban chay: join `Order_Details` + `Orders` (status DONE) + `Products`, `GROUP BY`
    san pham, sap xep theo so luong ban giam dan, lay TOP 5.
  - Doanh thu 7 ngay gan day: query gom nhom theo ngay roi map vao du 7 ngay lien tiep (ngay
    khong co don van tra ve 0, khong bi thieu diem tren bieu do).

Da sua:

- `src/main/java/org/example/controllers/ShopHomeServlet.java`: them `loadDashboard(req, shopId)`
  goi `ShopDashboardDAO` va set day du attribute cho JSP, dong thoi lay 5 don hang gan nhat cua
  shop qua `OrderDAO.findByShopId` (sap xep theo id giam dan) de sua loi "Don hang gan day" luon
  rong.
- `src/main/web/shop/trangcuahang.jsp`: them taglib `fmt` de format tien te; sua bang "Don hang
  gan day" dung dung field cua model `Order` (`receiverName`, `totalPrice`, `staTus`); them stat
  card doanh thu tuan/thang, tong don/don hoan thanh/don huy; them bang "Top mon ban chay"; them
  bieu do cot doanh thu 7 ngay (Chart.js qua CDN, du lieu nhung tu `doanhThu7NgayQua`).

Chuc nang da co:

- Trang chu shop (`/shop`) hien thi doanh thu hom nay/tuan/thang, tong don, don hoan thanh, don
  huy, don cho xu ly, tong san pham, tong topping, bieu do cot doanh thu 7 ngay gan day, top 5
  mon ban chay (theo so luong, chi tinh tu don da `DONE`), va danh sach 5 don hang gan day nhat
  (hien dung ten nguoi nhan/tong tien/trang thai).

Ghi chu:

- "Doanh thu" chi tinh tren don co `status = 'DONE'` (da giao thanh cong), khong tinh don dang
  PENDING/CANCELLED — phu hop voi y nghia doanh thu thuc te.
- Da compile lai toan bo `src/main/java` bang `javac` (qua Bash, classpath tu `.m2`, doi duong
  dan sang dang Windows `C:\...` truoc khi truyen vao `javac.exe`), khong loi.

## 17. Sua loi dashboard shop khong lay duoc du lieu DB, lo ID tren giao dien, ton kho khong luu

Phat hien bang cach ket noi truc tiep vao DB that (14.225.217.109) qua 1 chuong trinh Java
JDBC test (khong sua schema), doi chieu voi `Database.md` va code thuc te:

- **Dashboard shop (`/shop`) van hien so 0** du DB co san 44 don `status = 'DONE'` cho shop_id=1:
  `ShopDashboardDAOImpl` (muc 16) loc moi query tren bang `Orders` bang `AND is_deleted = 0`,
  nhung bang `Orders` thuc te (kiem tra qua `DatabaseMetaData.getColumns`) **khong co cot
  `is_deleted`** (chi co tren `Products`/`Toppings`). Moi query nem `SQLException "Invalid
  column name 'is_deleted'"`, bi `catch (Exception e) { e.printStackTrace(); }` nuot mat, dashboard
  tra ve toan so 0. Da sua: bo dieu kien `is_deleted = 0` khoi 4 cau SQL tren `Orders` trong
  `ShopDashboardDAOImpl.java` (`getRevenueSince`, `loadOrderCounts`, `loadTopProducts`,
  `loadRevenueLast7Days`), giu nguyen `is_deleted = 0` cho `Products`/`Toppings` (`countRows`)
  vi 2 bang nay co cot do that. Da test lai truc tiep tren DB that: doanh thu hom nay shop_id=1
  ra `2,008,000 đ`, dem don theo status ra dung 44 DONE, top san pham ban chay ra dung du lieu.

- **Quan ly Topping**: dropdown "Loc loai" trong `Quanlytopping.jsp` dung sai field
  `${cat.categoryName}` trong khi model `ToppingCategory` (da doi ten o muc 5) chi co `name` ->
  dropdown loc luon rong/trong khong hien ten loai. Da sua thanh `${cat.name}`. Phan bang danh
  sach topping chinh van lay dung du lieu (`ToppingDAOImpl.findByShopId` da loc dung `shop_id`),
  khong loi.

- **Moi shop chi thay san pham/topping cua minh**: kiem tra lai `ShopProductServlet`/
  `ShopToppingServlet` deu da goi `findByShopId(shop.getId())` voi `shop` lay tu
  `shopDAO.selectShopByOwnerId(account.getId())` cua tai khoan dang dang nhap — co loc dung,
  khong bi lo san pham/topping cua shop khac.

- **Khong de lo ID database tren giao dien**: cac trang `Quanlytopping.jsp`, `Quanlyloaitopping.jsp`,
  `Quanlyloaisanpham.jsp` truoc do hien cot dau tien la `#${id}` (ID that trong DB). Da doi
  cot nay thanh so thu tu hien thi (`${vs.index + 1}` qua `c:forEach varStatus="vs"`), khong con
  lo ID DB; cac lien ket sua/xoa van dung id that o tham so URL/form (binh thuong, can thiet de
  CRUD hoat dong, khong hien thi truc tiep cho nguoi dung doc thay). Cung sua fallback hien thi
  loai topping khi thieu join tu `'Loại #' + id` thanh `'Chưa phân loại'` (muc nay cung thuoc
  Quanlytopping.jsp).

- **Ton kho (`stock_quantity`) khong duoc luu**: o nhap "So luong ton kho" da co san trong
  `Quanlysanpham.jsp` (`name="stockQuantity"`) va `ProductDAOImpl`/`Product.java` da ho tro day
  du cot `stock_quantity`, nhung `ShopProductServlet.createProduct()`/`updateProduct()` **chua
  bao gio doc `req.getParameter("stockQuantity")`** nen gia tri luon mac dinh 0 khi tao moi va
  khong doi khi sua (kiem chung tren DB that: san pham tao gan nhat co `stock_quantity = 0` du
  da nhap so khac tren form). Da sua: doc + validate (`>= 0`) + `product.setStockQuantity(...)`
  o ca 2 luong create/update trong `ShopProductServlet.java`.

Da compile lai toan bo `src/main/java` bang `javac`, khong loi. Da test truc tiep cac cau SQL
sua doi tren DB that (khong qua Tomcat) de xac nhan ket qua dung truoc khi ket luan.

## 18. Trang thai san pham (Dang ban/Het hang/Tam an) khong duoc ap dung khi Bam Bill

Endpoint: `/shop/pos` (`Banhang.jsp`)

Sua trang thai san pham trong `Quanlysanpham.jsp` (ACTIVE/HIDDEN/OUT_OF_STOCK) va bam Luu thi
DB cap nhat dung (`ShopProductServlet`/`ProductDAOImpl` da luu dung tu truoc), nhung trang
"Bam Bill" (`ShopPosServlet` -> `Banhang.jsp`) khong he doc/loc theo `staTus` khi lay danh sach
san pham:

- `ShopPosServlet.forwardPage()` goi `productDAO.findByShopId(shop.getId())` lay **tat ca** san
  pham (khong loai is_deleted theo status), roi `Banhang.jsp` lap qua tat ca va render nut bam
  thanh size binh thuong cho moi san pham, bat ke `staTus` la gi -> san pham da danh dau "Tam an"
  hay "Het hang" tren `Quanlysanpham.jsp` van hien ra va bam ban binh thuong tren POS.

Da sua:

- `src/main/java/org/example/controllers/ShopPosServlet.java` (`forwardPage`): them
  `products.removeIf(p -> "HIDDEN".equalsIgnoreCase(p.getStaTus()));` ngay sau khi lay danh sach
  -> san pham `HIDDEN` (tam an) khong con xuat hien tren POS nua (giong nhu da an voi khach).
- `src/main/web/shop/Banhang.jsp`: voi san pham `OUT_OF_STOCK` (het hang), van hien the san pham
  de nhan vien biet ton tai nhung khong cho bam ban — them class `out-of-stock` + badge "Hết hàng"
  tren anh, cac nut size doi thanh `size-pill-disabled` (`disabled`, khong gan `onclick`, hien
  chu "Hết hàng" thay vi gia).

Ghi chu:

- `ACTIVE` (dang ban): hien thi va ban binh thuong, khong doi gi.
- `HIDDEN` (tam an): an hoan toan khoi POS (nhan vien cung khong thay), giong y nghia "an khoi
  ban hang" cua trang thai nay.
- `OUT_OF_STOCK` (het hang): van hien de nhan vien biet san pham ton tai nhung khoa nut bam,
  khong cho them vao gio hang tam.
- Da compile lai toan bo `src/main/java` bang `javac`, khong loi.

## 20. Dong bo design system moi (theme.css + dashboard.css) cho 4 trang Super Admin

Endpoint: `/super-admin/shipper-requests`, `/super-admin/shop-requests`, `/Category`, `/product`

Truoc do 4 trang nay moi trang tu nhung nguyen 1 khoi `<style>` rieng (bien theme, sidebar,
topbar, table, badge... trung lap toan bo) thay vi dung chung `assets/css/theme.css` +
`assets/css/dashboard.css` da co san (dung cho `admin/TongQuanHeThong.jsp`, `admin/appeals.jsp`,
`admin/chiTietYeuCauShop.jsp`, `admin/chiTietYeuCauShipper.jsp`). Da dong bo lai giao dien (chi
sua JSP, khong dong den servlet/DAO):

- `src/main/web/admin/yeuCauShipper.jsp`: xoa toan bo CSS rieng (~90 dong), doi sang sidebar/topbar
  chuan 7 muc (active "Duyet Shipper"), bang danh sach chuyen sang `.dash-table`, nut hanh dong
  sang `.btn.btn-sm` (`btn-outline`/`btn-success`/`btn-danger-outline`), giu nguyen link
  `?action=detail&id=`, 2 form accept/reject va ham JS `confirmReject(id, name)`.
- `src/main/web/admin/yeuCauShop.jsp`: tuong tu, active "Duyet Shop", giu nguyen ham JS
  `confirmReject(shopId, shopName)` (prompt nhap ly do, ghi vao input hidden `reason_<id>`), bo
  o tim kiem trang tri khong co `name`/khong lam gi (khong anh huong logic).
- `src/main/web/taoCategory.jsp` (goc `src/main/web/`, KHONG phai `admin/`): truoc do da co
  sidebar/topbar kieu Super Admin (khong phai truong hop "chua co khung" — chi la CSS rieng cu),
  da doi sang khung chuan + giu nguyen toan bo field form (`shopId`, `categoryName`, `status`)
  va bang danh sach + `c:set formCategory`, action edit/delete qua query string `?action=edit&id=`.
- `src/main/web/taoProduct.jsp` (goc, KHONG phai `admin/`): tuong tu, giu nguyen toan bo field
  form (`productname`, `shopid`, `categoryid`, `price`, `stock_quantity` — id/name giu y nguyen
  ke ca cho lech `label for="soldQuantity"` voi input id thuc `stock_quantity` da co tu truoc,
  khong sua vi ngoai pham vi doi giao dien, `soldCount`, `status` theo `staTus`, `description`),
  bang danh sach + panel "Huong dan"/thong ke mini o canh form. Bo phan phan trang gia (nut
  `‹ 1 ›` khong co onclick, khong co logic that, thuan tuy trang tri).

CSS rieng con giu lai (khong co san trong `theme.css`/`dashboard.css`): layout 2 cot cua form
(`.cat-grid`, `.prod-grid`), khoi "Huong dan" (`.info-item`, `.info-icon`, `.mini-stat-grid`) o
`taoProduct.jsp`, va khoi avatar-dropdown (giong het cach lam o `TongQuanHeThong.jsp`/`appeals.jsp`,
chua duoc gom vao `dashboard.css` nen van phai copy per-page).

Da kiem tra lai: so luong the `c:if/c:choose/c:when/c:otherwise/c:forEach/form` mo-dong khop nhau
o ca 4 file, khong mat `name=`/`id=` nao cua form/input (trung voi ban goc qua `git diff`, chi mat
duy nhat `id="themeToggleBtn"` — khong can nua vi doi sang dung chung `pobToggleTheme()` cua
`dashboard-theme.js`, ham nay khong dua vao id nut ma dung `document.documentElement`).

## 21. Dong bo design system moi (theme.css + dashboard.css) cho 2 trang Quan ly tai khoan

Endpoint: `/quanlitaikhoan`

Day la 2 file JSP **khac noi dung nhau** (khong phai ban sao): `admin/quanlitaikhoan.jsp` la ban
cu/du phong (khong co servlet nao forward toi — theo `PROJECT_STRUCTURE.md`), con
`src/main/web/quanlitaikhoan.jsp` (goc, ngoai `admin/`) moi la trang that duoc
`QuanLiTaiKhoanServlet` forward toi. Ca 2 deu quan ly CRUD tai khoan nhung khac nhau ro ret:

- `admin/quanlitaikhoan.jsp`: chi co bang danh sach + tim kiem + 2 modal xoa (tam thoi/vinh vien)
  qua dropdown "⋮" per dong; sua tai khoan chuyen huong sang trang khac qua link
  `?action=edit&id=`, KHONG co modal them/sua tai chinh trang nay.
- `src/main/web/quanlitaikhoan.jsp` (goc): day du hon — co `c:set var="formAccount"`, modal
  them/sua tai khoan ngay tren trang (`accountModal`, dung chung 1 form cho ca create/update),
  co sap xep cot (`sortField`/`sortOrder` qua query string), co avatar rieng tung dong, modal xoa
  tam thoi co them textarea nhap `suspendReason`.

Da sua (chi JSP, khong dong servlet/DAO):

- Xoa toan bo khoi `<style>` cu (bien theme sang/toi, sidebar, topbar, table, modal... trung lap
  voi `theme.css`/`dashboard.css`) o ca 2 file; bo `data-theme="dark"` hard-code tren `<html>`,
  them script chong nhay mau + link `theme.css`/`dashboard.css` giong `TongQuanHeThong.jsp`.
- Sidebar doi sang chuan 7 muc dong bo toan Super Admin (copy tu `TongQuanHeThong.jsp`), active
  "Nguoi dung" o ca 2 file; badge "Duyet Shop" doi sang dung `${shopChoDuyet}` (truoc do
  `admin/quanlitaikhoan.jsp` dung sai bien `${pendingShopsCount}` — khong ai set nen badge khong
  bao gio hien; file goc con te hon la hard-code text "2 moi" khong qua EL nao ca).
- Topbar/avatar dropdown + nut chuyen theme doi sang dung chung `pobToggleTheme()`/
  `pobToggleSidebar()` cua `dashboard-theme.js` (bo doan JS tu viet rieng doc/ghi
  `localStorage` theo key `adminTheme`/`theme` cua tung file).
- Badge vai tro (SUPER ADMIN/SHOP/KHACH HANG/SHIPPER hoac 👑 Admin/🏪 Shop/👤 User/🛵 Shipper —
  giu nguyen text/emoji rieng cua tung file) doi sang `.badge.badge-info` (vai tro co quyen quan
  tri) / `.badge.badge-neutral` (Khach hang/User), dung nhu quy uoc "info/neutral = vai tro" đa
  thong nhat cho toan bo Super Admin.
- Nut hanh dong: nut "⋮" mo dropdown moi dong doi sang `.btn.btn-sm.btn-ghost`; nut trong modal xac
  nhan doi sang `.btn.btn-ghost` (Huy) / `.btn.btn-warning` (xoa tam thoi) / `.btn.btn-danger`
  (xoa vinh vien) / `.btn.btn-primary` (tim kiem, luu, tao moi). Modal doi khung sang
  `.pob-modal-overlay`/`.pob-modal-box` (JS mo/dong van dung `classList.add/remove('open')` nhu
  cu — rieng modal them/sua o file goc truoc do dung class `active`, da doi 2 dong JS
  `classList.add('active')`/`remove('active')` thanh `'open'` cho khop voi component modal chung,
  khong doi ten ham/bien nao khac).
- Form them/sua tai khoan (file goc) doi input/select sang `.form-group`/`.form-label`/
  `.form-control`/`.form-select`/`.form-hint`, giu nguyen 100% `name`/`id`/`value`/`required`/
  `placeholder` cua tung field (`username`, `password`, `fullname`, `email`, `phone`, `roleid`,
  `avatarurl`) va textarea `suspendReason` trong modal xoa tam thoi.
- O tim kiem doi input sang `.dash-input`, nut sang `.btn`, giu nguyen toan bo tham so query
  string (`action=search`, `searchKeyword`, `sortField`, `sortOrder`) va logic servlet phia sau.
- Sua 1 loi co san trong `quanlitaikhoan.jsp` (goc): dong dong `</tr>` bi go nham thanh
  `end pt-tr>` (khong phai the HTML hop le, trinh duyet se render chu "end pt-tr>" ra man hinh
  thay vi dong dung hang bang) — sua lai thanh `</tr>`, khong dong gi khac toi logic
  `c:if test="${not empty searchKeyword and empty danhsach}"` bao quanh.

Da kiem tra lai o ca 2 file: so luong the `c:if/c:choose/c:when/c:otherwise/c:forEach/c:set`
mo-dong khop nhau, toan bo `name=`/`id=` cua form/input/textarea giu nguyen (doi chieu qua
`grep`), khong con CSS trung lap voi `theme.css`/`dashboard.css`.

## 22. Dong bo design system moi (theme.css + dashboard.css) cho 3 trang Shop (doi mat khau, ho so, xem danh gia)

Endpoint: `/shop/doi-mat-khau`, `/shop/ho-so`, `/shop/danh-gia`

Tiep tuc dong bo giao dien Shop (sau `trangcuahang.jsp`/`Shopprofile.jsp` da lam mau truoc do),
chi sua 3 file JSP, khong dong servlet/DAO:

- `src/main/web/shop/doiMatKhauShop.jsp`: xoa toan bo khoi `<style>` rieng (bien theme F&B cam,
  sidebar/topbar/table tu ve), doi `<html lang="vi" data-theme="light">`, nap
  `theme.css`+`dashboard.css`, `<body class="dash-body">`, sidebar 9 muc chuan (khong active muc
  nao vi trang chi mo qua dropdown avatar), topbar chi con `menu-toggle-btn` + avatar (bo
  theme-toggle vi Shop dung theme sang co dinh). Giu nguyen 100% form doi mat khau
  (`currentPassword`/`newPassword`/`confirmPassword`, cac `id` do JS dung) + toan bo ham JS
  `togglePw`/`checkStrength`/`checkMatch` (thanh do do manh mat khau) — chi doi CSS bao quanh
  sang `.form-group/.form-label/.form-control/.btn.btn-primary/.btn.btn-ghost/.alert`. Link
  "🔒 Đổi mật khẩu" trong dropdown avatar them `style="color:var(--primary);font-weight:700;"`
  de lam noi bat vi dang o dung trang do.
- `src/main/web/shop/hoSoShop.jsp`: tuong tu, sidebar khong active muc nao. Giu nguyen 100%
  doan JS upload avatar qua Cloudinary (unsigned upload preset `avatar_preset`, cloud
  `jcnsb47f`, XHR co progress bar, sau do POST `avatarUrl` ve `/shop/update-avatar`) — cac
  `id` JS dung (`avatarFileInput`, `uploadProgressBar`, `uploadBar`, `uploadMsg`) va selector
  `.profile-avatar`/`#avatarBtn` deu giu nguyen, chi doi bien mau `var(--accent)` (da xoa khoi
  `:root`) thanh `var(--danger)` trong 3 cho gan `msg.style.color` de khop voi `theme.css`. Panel
  thong tin (email/SDT/ho ten) chuyen sang dung `.info-card`+`.info-row/.info-label/.info-value`
  co san trong `dashboard.css`. Link "👤 Hồ sơ cá nhân" trong dropdown avatar duoc lam noi bat
  tuong tu.
- `src/main/web/shop/xemDanhGia.jsp`: sidebar active "⭐ Xem đánh giá" (dung nhu ban goc). Giu
  nguyen toan bo logic tab Khach hang/Shipper (`switchTab()`, `${feedbackUser.size()}`/
  `${feedbackShipper.size()}`), vong lap sao (`c:forEach begin="1" end="5"`), field
  `fb.anonymous`/`fb.reviewerName`/`fb.orderId`/`fb.rating`/`fb.comment`/`fb.createdAt`. Banner
  tong quan (`.overview-card`), tabs (`.tab-bar`/`.tab-btn`/`.tab-badge`) va card danh gia
  (`.review-card`/`.reviewer-avatar`/`.stars`) la CSS dac thu rieng (khong co san trong
  `theme.css`/`dashboard.css`) nen giu lai, chi doi ten bien: `var(--border)`->`var(--border-color)`,
  `var(--accent)`->`var(--danger)`, mau sao tu hex cung `#FFB703` sang `var(--warning)`. Trang
  thai rong (`Chua co danh gia...`) doi tu class `.empty-icon`+`<p>` tu che sang dung component
  `.empty-state`+`.e-icon`+`.e-title` co san trong `theme.css`.

Da kiem tra lai o ca 3 file: khong con bien CSS cu (`var(--border)`, `var(--primary-dk)`,
`var(--accent)`, `var(--accent-lt)`, `var(--success-lt)`, `var(--warning-lt)`, `var(--info-lt)`,
`var(--sh-sm)`, `var(--sh-md)`), so luong the `c:if/c:choose/c:when/c:otherwise/c:forEach` mo-dong
khop nhau, toan bo `name=`/`id=`/`onclick=`/`oninput=` cua form/input/JS giu nguyen (doi chieu qua
`git diff` + `grep`), doan JS upload Cloudinary trong `hoSoShop.jsp` giu nguyen logic 100%.

## 26. Dong bo design system moi (theme.css + dashboard.css) cho 3 trang Loai San Pham/Topping/Loai Topping cua Shop

Endpoint: `/shop/product-types`, `/shop/topping-categories`, `/shop/toppings`

3 file nay truoc do van dung khoi `<style>` rieng (bien mau F&B cam `--border`, `--primary-dk`,
`--accent`, `--sh-sm`...) va layout "page-grid" 2 cot (form them/sua nam co dinh ben trai, danh
sach ben phai) thay vi modal nhu `Quanlysanpham.jsp` da lam mau. Da dong bo lai (chi sua JSP,
khong dong servlet/DAO):

- `src/main/web/shop/Quanlyloaisanpham.jsp`: xoa khoi `<style>` cu (~150 dong bien theme/sidebar/
  topbar/table/badge trung `dashboard.css`), doi `<html lang="vi">` thanh
  `<html lang="vi" data-theme="light">`, them link `theme.css`/`dashboard.css`. Sidebar/topbar doi
  sang khung chuan 9 muc + avatar dropdown (copy tu `trangcuahang.jsp`), active "Quan ly loai san
  pham". Chuyen form them/sua (truoc la panel co dinh ben trai, field `typeName`/`status`) vao
  `.pob-modal-overlay#typeModal`/`.pob-modal-box`, mo bang nut "+ Them loai san pham moi"
  (`openTypeModal()`), tu mo khi dang sua/co loi (`isEditMode`/`hasError`, giong het pattern
  `Quanlysanpham.jsp`). Bang danh sach chuyen sang `.dash-table-wrap`+`table.dash-table`, badge
  trang thai (ACTIVE/HIDDEN/khac) sang `.badge-success/.badge-danger/.badge-neutral`. Giu nguyen
  100% `name=`/`id=` cua form (`typeName`, `status`, `action`, `id`), query string
  (`?action=edit&id=`, `?action=trash`), ham `filterTable()`/`updateCharCount()`.
- `src/main/web/shop/Quanlyloaitopping.jsp`: tuong tu, active "Quan ly loai Topping". Form them/sua
  (field `categoryName`, `description`, khong co `status` — dung voi ghi chu la
  `ToppingCategories` khong co cot nay) chuyen vao `.pob-modal-overlay#categoryModal`. File goc
  khong co o tim kiem/loc client-side nen KHONG them moi (giu nguyen hanh vi, chi doi giao dien).
- `src/main/web/shop/Quanlytopping.jsp`: tuong tu, active "Quan ly Topping". Form them/sua (field
  `toppingName`, `toppingCategoryId`, `price`, `status` ACTIVE/OUT_OF_STOCK) chuyen vao
  `.pob-modal-overlay#toppingModal`. Giu nguyen o tim kiem theo ten (topbar) + dropdown loc theo
  loai topping (table-toolbar) voi 2 ham rieng `filterTable()`/`filterByCategory()` y nguyen logic
  cu (khong gop thanh 1 ham `applyFilters()` de tranh doi hanh vi).

Ca 3 file: nut "Thung rac" tren topbar giu nguyen link `?action=trash`, doi sang
`.btn.btn-danger-outline.btn-sm`; JS mo/dong modal dung `classList.add/remove('open')` (dung voi
component `.pob-modal-overlay.open` cua `theme.css`, KHONG phai `.active`). Da kiem tra lai: khong
con bien CSS cu (`--border`, `--primary-dk`, `--accent`, `--accent-lt`, `--success-lt`,
`--warning-lt`, `--sh-sm`, `--sh-md`), so luong the `c:if/c:choose/c:when/c:otherwise/c:forEach/form`
mo-dong khop nhau, toan bo `name=` cua form/input giu nguyen (doi chieu qua `grep`).

## 22. Dong bo design system moi (theme.css + dashboard.css) cho 2 trang Hoa don cua Shop

Endpoint: `/shop/bills`

Tiep tuc dong bo giao dien Shop (sau 3 trang mau `trangcuahang.jsp`, `Quanlysanpham.jsp`,
`Shopprofile.jsp`) cho 2 file con lai thuoc nhom "Quan ly hoa don" (chi sua JSP, khong dong
servlet/DAO/`_invoiceModal.jspf`):

- `src/main/web/shop/Quanlybill.jsp`: xoa toan bo khoi `<style> :root{...}` rieng (mau F&B cam,
  sidebar, topbar, table, status-badge, btn, alert...) trung voi `theme.css`/`dashboard.css`;
  doi `<html lang="vi">` thanh `<html lang="vi" data-theme="light">`, them link
  `theme.css`/`dashboard.css`; `<body>` doi sang `class="dash-body"`, sidebar/topbar/avatar-dropdown
  copy dung cau truc 9 muc tu `trangcuahang.jsp` (active "📋 Quan ly hoa don"); bang danh sach
  doi sang `.dash-table-wrap`+`table.dash-table`; cot "Hinh thuc"/"Thanh toan"/"Trang thai don"
  doi tu `.status-badge` (CSS rieng) sang `.badge`+bien the (PAID=`badge-success`,
  UNPAID=`badge-danger`, PENDING=`badge-warning`; COD=`badge-neutral`, BANK/PAYOS=`badge-info`);
  nut Xac nhan/Huy doi tu inline-style `background:#2ECC71/#E63946` sang `.btn.btn-sm.btn-success`/
  `.btn.btn-sm.btn-danger`; filter-bar giu CSS rieng (khong co san trong dashboard.css) nhung
  input/select doi sang dung chung `.dash-input`; dong include `<%@ include file="_invoiceModal.jspf" %>`
  giu nguyen 100% (khong sua file jspf).
- `src/main/web/shop/HoaDonShop.jsp`: tuong tu — xoa CSS rieng trung lap, giu lai CSS dac thu cho
  layout hoa don in an (`.bill-center/.bill-wrap/.bill/.bill-header/.bill-totals/.bill-actions`,
  scope `.bill .info-row`/`.bill table` de tranh dung ten `.info-row`/`table` da co nghia khac
  trong `dashboard.css`); 3 dong trang thai (Phuong thuc/Thanh toan/Trang thai) doi sang `.badge`;
  nut "🖨️ In hoa don" (`window.print()`) va "← Quay lai danh sach" doi sang `.btn.btn-primary`/
  `.btn.btn-ghost`, giu nguyen ham `window.print()`.

Da kiem tra lai o ca 2 file: khong con bien CSS cu (`var(--border)`, `var(--primary-dk)`,
`var(--accent)`, `var(--accent-lt)`, `var(--success-lt)`, `var(--warning-lt)`, `var(--info-lt)`,
`var(--sh-sm)`, `var(--sh-md)`), so luong the JSTL mo-dong khop nhau (kiem qua `grep`), toan bo
`name=`/`id=`/`action=` cua form/input va tham so query string (`?action=view&as=modal&id=`,
`?method=`, `?status=`, `?action=confirm`, `?action=cancel`...) giu nguyen (doi chieu qua
`comm` voi ban goc tren git), dong include `_invoiceModal.jspf` khong doi.

## 23. Dong bo design system moi (theme.css + dashboard.css) cho 4 trang Thung rac cua Shop

Endpoint: `/shop/products?action=trash`, `/shop/product-types?action=trash`,
`/shop/toppings?action=trash`, `/shop/topping-categories?action=trash`

Tiep tuc dong bo giao dien Shop (sau `trangcuahang.jsp`, `Quanlysanpham.jsp`, `Shopprofile.jsp`,
`Quanlybill.jsp`, `HoaDonShop.jsp`) cho 4 file "Thung rac" con lai — chi sua JSP (khong dong
servlet/DAO), 4 file gan nhu giong het nhau nen sua theo cung 1 pattern:

- `src/main/web/shop/ThungRacSanPham.jsp`, `ThungRacLoaiSanPham.jsp`, `ThungRacTopping.jsp`,
  `ThungRacLoaiTopping.jsp`: xoa toan bo khoi `<style> :root{...}` rieng (mau F&B cam, sidebar,
  topbar, table, `.status-badge`, `.btn`, `.alert`, avatar-dropdown... trung voi
  `theme.css`/`dashboard.css`); doi `<html lang="vi">` thanh `<html lang="vi" data-theme="light">`
  (theo dung quy uoc Shop chi dung theme sang, khong co nut chuyen dark/light), them link
  `theme.css`/`dashboard.css`; `<body>` doi sang `class="dash-body"`; sidebar 9 muc + `.sidebar-backdrop`
  copy dung cau truc tu `trangcuahang.jsp`, active dung muc theo tung trang (Quan ly san pham /
  Quan ly loai san pham / Quan ly Topping / Quan ly loai Topping); topbar giu `.menu-toggle-btn`
  (`onclick="pobToggleSidebar()"`) + avatar/dropdown, khong co nut theme-toggle (dung 1 theme sang
  co dinh); nut "← Quay lai danh sach" doi tu `.btn-back` (CSS rieng) sang `.btn.btn-ghost`, dat
  trong `.content` phia tren panel; bang danh sach cac muc da xoa boc trong `.panel`
  (`.panel-header`/`.panel-title` + badge dem so luong `.badge.badge-neutral`, `.panel-body`),
  dung `.dash-table-wrap`+`table.dash-table` thay cho `<table>` CSS rieng; cot "Trang thai"
  (`Da xoa`) doi tu `.status-badge.status-deleted` sang `.badge.badge-danger`; nut "♻️ Khoi phuc"
  moi dong doi tu `.btn.btn-restore` sang `.btn.btn-sm.btn-success`; alert loi doi class
  `alert-error` (khong co trong theme.css) sang `alert-danger` cho dung voi `.alert`+`.alert-danger`
  cua `theme.css`; danh sach rong doi tu `.empty-state` CSS rieng sang `.empty-state`+`.e-icon`/`.e-title`
  chuan cua `theme.css`.
- Giu nguyen 100%: khoi kiem tra quyen `roleId != 2` dau file, taglib/`<%@ page %>`, toan bo EL
  (`${deletedProducts}`, `${deletedCategories}`, `${deletedToppings}`, `${p.productName}`,
  `${cat.categoryName}`, `${cat.name}`/`${cat.description}`, `${t.toppingName}`/
  `${t.toppingCategoryName}`/`${t.price}`...), form khoi phuc (`method="post"`,
  `action="${pageContext.request.contextPath}/shop/products|product-types|toppings|topping-categories"`,
  `name="action" value="restore"`, `name="id"`), khong co `onsubmit`/`confirm(...)` nao trong 4
  file goc nen khong can giu them.

Da kiem tra lai ca 4 file: khong con `:root{...}` hay CSS trung lap voi `theme.css`/`dashboard.css`,
so luong the `c:if/c:choose/c:when/c:otherwise/c:forEach/form` mo-dong khop nhau (kiem qua `grep`),
toan bo `name=`/`action=`/`method=` cua form/input giu nguyen 100% so voi ban goc (doi chieu qua
`git diff` chi con `name=`/`action=`/`method=`, khong lech dong nao), ca 4 file dung thong nhat
1 pattern giong het nhau (chi khac tieu de, muc active sidebar, link "Quay lai danh sach", ten
bien EL va cac cot rieng cua tung loai du lieu — vi du `ThungRacTopping.jsp` co them cot "Loai
topping"/"Gia", `ThungRacLoaiTopping.jsp` co them cot "Mo ta").

## 30. Dong bo design system moi (theme.css + dashboard.css) cho trang "Bam Bill" cua Shop

Endpoint: `/shop/pos`

`src/main/web/shop/Banhang.jsp` (trang POS phuc tap nhat cua Shop: chon mon, gio hang tam,
size/topping picker, thanh toan) truoc do van dung 1 khoi `<style>` rieng voi bien theme F&B
cam cu (`--bg-base`, `--border`, `--primary-dk`, `--accent`, `--sh-sm`...) giong cac trang Shop
khac truoc khi dong bo. Da sua (chi JSP, khong dong servlet/DAO `ShopPosServlet`):

- Xoa toan bo bien `:root{...}`, reset, CSS sidebar/topbar/table cu; doi `<html>` sang
  `data-theme="light"` co dinh (Shop khong co dark mode); them link `theme.css`/`dashboard.css`;
  `<body class="dash-body">`.
- Sidebar doi sang dung 9 muc chuan (copy tu `trangcuahang.jsp`), active "🧾 Bam Bill"; them
  `.sidebar-backdrop` + nut `.menu-toggle-btn` (goi `pobToggleSidebar()`) cho mobile — truoc do
  trang nay khong co nut thu gon sidebar tren mobile.
- Topbar: giu nguyen o tim mon (`id="searchBox"`, `oninput="filterProducts(this.value)"`) nhung
  doi sang `.dash-input`; avatar doi sang cau truc chuan `.avatar-wrapper`/`.avatar-circle` (JS
  dropdown giu nguyen logic, chi doi class).
- Nut "Xac nhan" (`#btnConfirm`) doi tu CSS `.btn-confirm` rieng sang `.btn.btn-primary.btn-block`
  dung chung; o nhap ten khach (`#customerName`) doi sang `.dash-input`; xoa het khoi `.btn`/
  `.btn-primary`/`.btn-secondary` cu tu dinh nghia rieng (khong noi nao dung toi, bi trung ten
  voi `.btn` chung cua `theme.css` gay xung dot neu giu lai).
- Panel chon topping khi them mon vao gio (`#toppingOverlay`) — modal rieng ngoai
  `_invoiceModal.jspf` — doi tu class rieng `.topping-picker-overlay`/`.show` sang dung khung
  modal chung `.pob-modal-overlay`/`.pob-modal-box` (them class phu `.topping-picker-box` de giu
  kich thuoc rieng 340px), sua 2 dong JS `classList.add('show')`/`classList.remove('show')` trong
  `openToppingPicker()`/`closeToppingPicker()` thanh `.add('open')`/`.remove('open')` cho dung quy
  uoc modal chung — khong doi ten ham/logic gio hang tam nao khac.
- CSS rieng con giu lai (dac thu POS, chua co san trong `theme.css`/`dashboard.css`): layout 2
  cot `.pos-layout` (luoi chon mon ben trai cuon rieng + `.cart-panel` gio hang tam co dinh ben
  phai), `.product-grid`/`.product-card`/`.size-pills`, cac dong `.cart-line`/`.qty-stepper`,
  `.pay-methods`, va CSS panel `.topping-picker-box`/`.topping-row`.
- Include `<%@ include file="_invoiceModal.jspf" %>` giu nguyen dong, khong dong vao file
  `_invoiceModal.jspf` (file nay da dung san token/class moi tu truoc).

Da kiem tra lai: toan bo `name=`/`id=` cua form/input/button giu nguyen 100% (doi chieu qua
`grep` giua ban cu va ban moi), toan bo ham JS (`addToCart`, `renderCart`, `changeQty`,
`removeLine`, `openToppingPicker`, `closeToppingPicker`, `onToppingCheck`, `onToppingQty`,
`selectPayMethod`, `filterProducts`, `filterByCategory`, `submitOrder`) va toan bo `onclick`/
`onchange`/`oninput` giu nguyen (chi them 1 `onclick="pobToggleSidebar()"` moi cho nut mobile),
logic gio hang tam JS-side (`var cart = []`) va toan bo tham so form POST
(`action`, `paymentMethod`, `customerName`, `lineProductId[]`, `lineSizeId[]`, `lineQty[]`,
`lineToppings[]`) khong doi. So luong the `c:if/c:choose/c:when/c:otherwise/c:forEach/c:set`
mo-dong khop nhau, khong con bien CSS cu (`--border)`, `--primary-dk`, `--accent`, `--sh-sm`...).

## 31. Dong bo tone mau cho Shipper (dashboard shell dung chung) + Theme "Vu tru/Khong gian" rieng cho User

Yeu cau: lam lai frontend cua 3 role Shipper/Super Admin/Admin(Shop) cho dong bo mot tong mau,
va lam lai frontend role User theo phong cach "vu tru/khong gian" (khac han tone F&B cam cua cac
role kia). Khong sua backend, giu nguyen 100% chuc nang/servlet/endpoint/EL/JS hien co.

Ra soat truoc khi lam: Super Admin (`admin/*.jsp` + `quanlitaikhoan.jsp` root) va Admin/Shop
(`shop/*.jsp`, `taoCategory.jsp`, `taoProduct.jsp`) da duoc dong bo theme cam (`theme.css` +
`dashboard.css`) tu truoc trong nhanh nay — chi con thieu rieng role **Shipper**.

Da sua (Shipper — 10 file trong `src/main/web/shipper/`, tat ca truoc do moi file tu code rieng
mot bo `:root` mau xanh la `#4CAF50`/cam `#FF9800` + sidebar/topbar/avatar-dropdown copy-paste
rieng, key luu theme la `shipper-theme`):

- `dashboard.jsp`, `trangchucuashipper.jsp`, `chitietdonhang.jsp`, `nhanDon.jsp`,
  `doiMatKhauShipper.jsp`, `thongbao.jsp`, `danhGia.jsp`, `hoSoShipper.jsp`, `hosotaixe.jsp`,
  `guiFeedback.jsp` — doi toan bo sang dung chung `assets/css/theme.css` +
  `assets/css/dashboard.css` + `assets/js/dashboard-theme.js` (key luu theme doi thanh
  `pob-dashboard-theme`, dung chung voi Super Admin), sidebar/topbar/avatar-dropdown dung dung
  cau truc `.sidebar`/`.sidebar-brand`/`.menu-item`/`.topbar`/`.avatar-circle` nhu
  `admin/hoSoAdmin.jsp`, them `sidebar-backdrop` + `menu-toggle-btn` (`pobToggleSidebar()`) cho
  mobile (truoc do khong co, sidebar shipper tren mobile chi doi thanh thanh ngang cuon).
- Giu nguyen nut bat/tat Online/Offline o cuoi sidebar (form POST `/shipper/status`), chuyen
  vao `.sidebar-foot` dung khung chung; giu nguyen toan bo endpoint form
  (`/shipper/donhang`, `/shipper/nhan-don`, `/shipper/dashboard`, `/shipper/thongbao`,
  `/shipper/danh-gia`, `/shipper/profile`, `/shipper/ho-so`, `/shipper/doi-mat-khau`,
  `/shipper/bom-hang`, `/shipper/feedback`, `/shipper/update-avatar`) va toan bo ham JS
  (`filterOrders`, `applyFilters`, `openDetailModal`/`closeDetailModal`, checklist
  `toggleCheck`/`resetChecklist`/`updateUI` cua `chitietdonhang.jsp`, upload avatar Cloudinary
  cua `hoSoShipper.jsp`, chart thu nhap Chart.js cua `dashboard.jsp`).
- Mau sac quy uoc lai theo token chung: trang thai "cho lay hang" -> `--warning`, "dang giao"
  -> `--primary` (cam thuong hieu, nhan manh viec dang lam), "hoan thanh" -> `--success`, "huy/bom
  hang" -> `--danger`; modal chi tiet don hang (`trangchucuashipper.jsp`) doi tu class rieng
  `.modal-backdrop`/`.modal-content`/`active` sang dung khung modal chung
  `.pob-modal-overlay`/`.pob-modal-box`/`open`.
- `guiFeedback.jsp` (form danh gia shop sau khi giao xong) truoc do dung rieng Tailwind CDN +
  tong mau navy — bo Tailwind, doi sang `theme.css` thuan, giu nguyen form POST
  `/shipper/feedback` (`orderId`, `rating`, `comment`) va JS chon sao.

Da tao moi CSS rieng cho role User (`src/main/web/assets/css/theme-space.css`) — theme "vu
tru/khong gian": nen toi (`--bg-deep #05040f` -> `--bg-base #0b0a1f`), gradient tinh van tim-cyan
(`--primary #8b5cf6`, `--secondary #22d3ee`, `--accent-pink #f472b6`), lop `.starfield` (sao lam
lanh bang nhieu `radial-gradient` + `@keyframes pobTwinkle`), card kinh mo (`backdrop-filter:
blur`), glow neon cho nut/card khi hover (`--glow-primary`). File nay doc lap, khong phu thuoc
`theme.css` cam cua cac role kia (co chu y khac biet tong mau theo yeu cau).

Da sua (User — 5 file trong `src/main/web/user/`):

- `guiFeedback.jsp`, `donhang.jsp`, `diaChi.jsp`: bo Tailwind CDN + tong mau navy cu, doi sang
  `assets/css/theme-space.css`, giu nguyen toan bo form action (`/feedback`, `/user/dia-chi`),
  tham so (`orderId`, `targetType`, `rating`, `comment`, `is_anonymous`, `action=create|update|
  delete|setDefault`, cac field dia chi) va JS (`setRating`, `openModal`/`closeModal`/`openEdit`
  cua modal dia chi).
- `menuShop.jsp`, `trangnguoidung.jsp` (2 trang lon nhat, dung CSS rieng inline nhu ban goc thay
  vi `theme-space.css` de tranh dung ten class voi phan CSS dac thu rieng trang): giu nguyen
  toan bo `:root` bien nhung doi gia tri mau tu cam F&B sang tim-cyan vu tru, them
  `.starfield` + tinh van nen; giu nguyen 100% cau truc HTML/id/class ma JS dang tham chieu
  (`openModal`, `closeModal`, `changeQty`, `updateTotal`, `filterCategory` cua `menuShop.jsp`;
  `goToShop`, `filterShops`, `filterCat`, `toggleDropdown`, banner slider `goSlide`/`nextSlide`/
  swipe touch cua `trangnguoidung.jsp`) va toan bo EL/JSTL render san pham/shop tu DB
  (khong dung du lieu gia dinh nao khac ngoai nhung gia tri demo co san tu truoc nhu rating
  "4.x" gia lap theo `vs.index`).

Kiem tra: dem the `<c:if>/<c:choose>/<c:when>/<c:otherwise>/<c:forEach>` mo-dong khop nhau tren
tung file da sua (Shipper + User). Khong dong vao Servlet/DAO/Model nao — chi doi CSS/markup/JS
thuan giao dien.
