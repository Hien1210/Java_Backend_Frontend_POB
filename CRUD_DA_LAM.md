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

Tiep noi muc 22 (Leaflet address-map): sau khi don hang da co toa do (`Order.locationX`/
`locationY`), phia shop chua co cho nao xem lai toa do do tren ban do. Yeu cau: cho chu shop xem
vi tri giao hang cua don hang (va vi tri shop, neu co) tren ban do, chi doc, khong cho sua.

Pham vi:

- `src/main/web/shop/HoaDonShop.jsp` (trang chi tiet hoa don): them 1 ban do Leaflet chi doc
  ngay ben duoi phan "Dia chi giao hang", hien thi marker vi tri giao hang cua don hang va (neu
  co toa do) marker 🏠 cua shop, tu dong `fitBounds` de ca 2 marker deu nam trong khung nhin. Neu
  don hang khong co toa do (`locationX`/`locationY` null — vi du don tao truoc muc 22, hoac dia
  chi khong ghim vi tri) thi an ban do, hien dong text fallback "Chua co vi tri tren ban do".
- `src/main/web/shop/Quanlybill.jsp` (trang danh sach don hang): moi dong don hang co toa do
  hop le duoc them 1 nut "📍" mo modal hien thi ban do cung dang (marker giao hang + marker shop,
  chi doc); don hang khong co toa do thi khong hien nut.

Nguon du lieu: tai su dung `Order.locationX`/`locationY` (da co san tu muc 22) va
`Shop.locationX`/`locationY` (field co san tu truoc, truoc gio chua tung hien thi o dau) — ca 2
trang deu doc qua `sessionScope.currentShop` (da duoc set san khi shop dang nhap) de lay toa do
shop, khong can them truy van DAO/DB moi.

Hanh vi: chi doc (read-only) — khong co thao tac keo/tha hay sua toa do tren 2 trang nay; an
ban do/nut bam neu thieu toa do don hang; an marker shop neu thieu toa do shop (van hien marker
giao hang binh thuong).

Tech: tai su dung Leaflet.js 1.9.4 CDN + OpenStreetMap tile giong muc 22, khong co thay doi nao
o tang Model/DAO/Servlet (thuan JSP + JS).

## 24. Chon vi tri cua hang tren ban do (trang Thong tin cua hang, phia shop)

- **Van de:** Shop khong co cach nao dat toa do vi tri cua hang (`Shops.locationX`/`locationY`). Cot DB va field model da co san nhung `ShopDAOImpl` chua bao gio doc/ghi chung, nen marker cua hang tren ban do giao hang (tinh nang truoc do) luon rong.
- **Sua:**
  - `ShopDAOImpl.mapResultSetToShop()`: doc them `locationX`/`locationY` tu ResultSet.
  - `ShopDAOImpl.updateShop()`: ghi them `locationX`/`locationY` vao cau lenh UPDATE.
  - `ShopProfileServlet`: nhan them 2 tham so form `shopLocationX`/`shopLocationY` (khong bat buoc), set len `Shop` truoc khi luu.
  - `shop/Shopprofile.jsp`: them nut "Chon vi tri tren ban do" trong form chinh sua, mo ra ban do Leaflet (click/keo ghim + o tim kiem Nominatim) — cung mau giao dien voi `user/diaChi.jsp`, nhung khong bat buoc phai chon.
  - `shop/Shopprofile.jsp`: khi chon vi tri tren ban do (click, keo ghim, hoac tim kiem ra ket qua), tu dong reverse-geocode toa do qua Nominatim `/reverse` va dien lai vao o "Dia chi" (`#shopAddress`) — keo ghim duoc debounce 500ms de tranh goi API lien tuc; vi tri dat san (preset) khi mo lai form thi khong reverse-geocode (giu nguyen dia chi da luu). Cung mau voi `initAddressMap` trong `user/diaChi.jsp`.
- **Tech:** Leaflet 1.9.4 CDN + OpenStreetMap + Nominatim, khong doi Model/DB schema (cot da co san).

## 25. Theo doi vi tri shipper realtime tren ban do (WebSocket)

Endpoint: `/ws/tracking` (WebSocket, khong phai HTTP servlet), lien quan `shipper/chitietdonhang.jsp`, `user/donhang.jsp`

Tiep noi muc 22-24 (toa do shop/dia chi/don hang da co san qua Leaflet): yeu cau moi la xem **vi
tri shipper di chuyen realtime** tren ban do trong luc don dang giao (`status = SHIPPING`), thay
vi chi xem toa do tinh (shop/diem giao) nhu truoc. Khong them bang/cot DB moi — vi tri shipper chi
la du lieu tam thoi, phat truc tiep qua WebSocket va cache trong bo nho server (khong luu DB).

Da them moi:

- `pom.xml`: them 2 dependency `jakarta.websocket-api` va `jakarta.websocket-client-api` (cung
  ban 2.1.1, `scope=provided`, Tomcat da co san runtime) — phai co ca 2 vi rieng
  `jakarta.websocket-api` (server-api) khong co san goi `jakarta.websocket` co ban
  (`Session`, `Endpoint`...), thieu se khong compile duoc `TrackingEndpoint`.
- `src/main/java/org/example/websocket/HttpSessionConfigurator.java` (moi) — 1
  `ServerEndpointConfig.Configurator` copy `accountId` cua tai khoan dang dang nhap tu
  `HttpSession` sang `userProperties` cua WebSocket handshake, de endpoint biet ai dang ket noi
  ma khong can dang nhap lai qua WebSocket.
- `src/main/java/org/example/websocket/TrackingEndpoint.java` (moi) — `@ServerEndpoint("/ws/tracking",
  configurator = HttpSessionConfigurator.class)`. Client ket noi voi query string
  `?role=shipper&orderId=<id>` (shipper dang giao don do) hoac `?role=customer&orderId=<id>`
  (khach hang xem don do). Xac thuc quyen ket noi bang cach doi chieu `accountId` trong session
  voi `order.shipperId` (role=shipper) hoac `order.userId` (role=customer) cua chinh `orderId` do
  — khong cho xem/gui vi tri don hang khong lien quan. Tin nhan shipper gui len (JSON dang
  `{"lat":..,"lng":..}`) duoc:
  - Cache lai vi tri moi nhat cua `orderId` do trong 1 registry trong bo nho (Map tinh, khong
    ghi DB).
  - Phat (broadcast) ngay lap tuc cho tat ca session `role=customer` dang xem cung `orderId`.
  - Khi 1 khach hang moi ket noi (`role=customer`), neu da co vi tri cache san cho `orderId` do
    thi gui lai ngay vi tri gan nhat (de khach khong phai cho lan cap nhat GPS tiep theo cua
    shipper moi thay marker).

Da sua:

- `src/main/web/shipper/chitietdonhang.jsp`: them 1 script chi kich hoat khi
  `order.staTus == 'SHIPPING'` — mo WebSocket toi `/ws/tracking?role=shipper&orderId=<id>`, dung
  `navigator.geolocation.watchPosition` de theo doi GPS thiet bi shipper, throttle gui toi da
  ~3 giay/lan (tranh spam server), tu dong dong ket noi khi rời trang (`beforeunload`).
- `src/main/java/org/example/controllers/UserOrderServlet.java`: ngoai `shopNames` (map co san),
  them attribute moi `shopCoords` (`Map<Long shopId, double[] {lat, lng}>`) de JSP co toa do shop
  ma khong phai truy van them.
- `src/main/web/assets/js/orderTrackingMap.js` (moi) — module Leaflet dung chung:
  `initOrderTrackingMap(containerId, shopLat, shopLng, destLat, destLng, wsUrl)` — ve marker shop
  + marker diem giao hang, `fitBounds` ca 2, roi mo WebSocket `role=customer` toi `wsUrl` de nhan
  vi tri shipper va dat/di chuyen 1 marker shipper rieng moi khi co cap nhat.
- `src/main/web/user/donhang.jsp`: them CDN Leaflet, moi don hang dang `SHIPPING` co 1
  `<div id="map-${order.id}">` va 1 script goi `initOrderTrackingMap(...)` voi toa do shop lay tu
  `shopCoords[order.shopId]` (muc tren) va toa do diem giao la `order.locationX`/`locationY` cua
  chinh don hang, ket noi WebSocket toi `/ws/tracking?role=customer&orderId=${order.id}`.

Chuc nang da co:

- Khi don hang chuyen sang trang thai "Đang giao" (`SHIPPING`): shipper mo trang chi tiet don
  hang se tu dong phat vi tri GPS thiet bi len server qua WebSocket.
- Khach hang mo trang "Đơn hàng của tôi" thay ban do 2 marker tinh (shop + diem giao) bang ban do
  co them marker thu 3 la vi tri shipper, tu cap nhat lien tuc (~3s/lan) trong khi don dang giao,
  khong can F5 lai trang.

Han che/gia dinh da biet:

- Vi tri shipper chi ton tai trong bo nho server (registry tinh trong `TrackingEndpoint`), khong
  luu DB — mat khi restart server, va chi co 1 instance server (khong scale ngang nhieu server
  duoc voi thiet ke nay).
- Khong co bang/cot DB moi cho tinh nang nay.

Da compile lai toan bo `src/main/java` bang `javac` (classpath gom toan bo jar tu `.m2`, bao gom
`jakarta.websocket-api`/`jakarta.websocket-client-api` moi them), khong loi.

## 25b. Fix 3 loi Important tu final code review cua tinh nang theo dõi shipper realtime (WebSocket)

Endpoint: `/ws/tracking` va cac file lien quan o muc 25.

Ba loi Important tim thay khi review lai toan bo tinh nang WebSocket theo doi shipper, da sua:

- **Thieu kiem tra Origin khi handshake WebSocket (lo hong CSWSH)**: `HttpSessionConfigurator`
  truoc do khong override `checkOrigin`, dung mac dinh cua Jakarta (`true` cho moi Origin). Vi
  handshake chi xac thuc qua session cookie (trinh duyet tu dong gui kem cookie khi upgrade
  WebSocket kê ca cross-origin), 1 trang web doc hai ben ngoai co the mo ket noi WebSocket toi
  `/ws/tracking?role=customer&orderId=N` (lap N) trong khi nan nhan dang dang nhap, de nhan duoc
  luong vi tri GPS shipper cua don hang do, hoac (`role=shipper`) gia mao toa do GPS vao 1 don
  dang giao. Da sua trong `src/main/java/org/example/websocket/HttpSessionConfigurator.java`:
  them method `modifyHandshake` kiem tra header `Origin` so voi header `Host` cua chinh request
  (lay tu `HandshakeRequest.getHeaders()`); neu ca 2 co mat va host khac nhau thi KHONG set
  `currentAccountId` vao `userProperties` — tai su dung co che unauthorized co san trong
  `TrackingEndpoint.onOpen` (coi -1L la khong duoc phep, tu dong dong ket noi), khong tao co che
  moi. Neu thieu header `Origin` (client khong phai trinh duyet, hoac mot so truong hop
  same-origin khong gui Origin) van cho qua nhu truoc de khong lam gay ket noi hop le.

- **Race condition khi don cleanup `customerWatchers`**: `TrackingEndpoint.onClose` truoc do
  `watchers.remove(session); if (watchers.isEmpty()) customerWatchers.remove(orderId);` khong
  atomic — 1 `onOpen` dong thoi cua watcher moi tren cung `orderId` co the insert vao dung set do
  ngay truoc khi entry bi xoa khoi map, lam watcher moi bi "mo coi" trong 1 set da tach khoi map
  (`onMessage` sau nay se khong bao gio tim thay de gui vi tri). Da sua: thay
  `customerWatchers.remove(orderId)` bang `customerWatchers.computeIfPresent(orderId, (k, v) ->
  v.isEmpty() ? null : v)` sau khi remove session khoi set — chi xoa entry neu set van con rong
  TAI THOI DIEM computeIfPresent chay (atomic), dong cua so race. Van giu nguyen
  `CopyOnWriteArraySet` cho set watcher moi don, khong doi cau truc du lieu.

- **Ca 2 phia (shipper gui, khach hang nhan) khong co reconnect NEN cung khong bao gio bao loi khi
  mat ket noi**: neu socket cua shipper bi rot (thuong gap tren mobile: chuyen app nen, chuyen
  tram song), shipper khong tu ket noi lai va khong bao ai biet — marker shipper tren ban do khach
  hang cu dung yen ma khong co dau hieu gi la da mat ket noi. Theo dung pham vi yeu cau (KHONG lam
  reconnect/retry, chi them canh bao hien thi):
  - `src/main/web/assets/js/orderTrackingMap.js`: them `socket.addEventListener('close', ...)`
    va `('error', ...)` goi chung 1 ham hien 1 `<div>` nho ("⚠️ Mất kết nối theo dõi trực tiếp...")
    chen ngay sau khung ban do (`container.parentNode.insertBefore(...)`), an mac dinh
    (`display:none`), chi hien khi socket dong/loi.
  - `src/main/web/shipper/chitietdonhang.jsp`: them `socket.addEventListener('close', ...)` va
    `('error', ...)` goi ham `showTrackingWarning()` hien 1 `<span id="trackingWsWarning"
    class="badge">` (tai su dung dung class `.badge` va bien mau `var(--danger)` da co san trong
    file, dat ngay canh badge trang thai "🛵 Đang giao" de dong bo phong cach voi cac badge trang
    thai khac trong trang, khong tao co che canh bao rieng thu 2).

Da compile lai toan bo `src/main/java` bang `javac` (classpath tu `.m2`), khong loi. Da doc lai
thu cong `orderTrackingMap.js` va `chitietdonhang.jsp` de xac nhan brace/tag can doi.

## 26. Fix regression: marker diem giao (dest) khong bao gio hien tren ban do theo doi realtime cua khach hang

**Trieu chung:** Khach hang mo `/user/donhang`, don dang `SHIPPING`, ban do chi hien 1 marker
(shop 🏪) thay vi 3 marker (shop, diem giao 🏠, shipper 🛵) nhu thiet ke.

**Nguyen nhan (xac dinh qua git forensics):** `Order.locationX`/`locationY` (nguon cua marker diem
giao trong `donhang.jsp`, xem muc 25) luon luon `null` cho MOI don hang, ke ca don moi tao — vi
`src/main/web/checkoutThanhToan.jsp` khong con field nao de nguoi dung chon toa do giao hang, du
`CheckoutServlet.java` (`doPost`) van doc `req.getParameter("locationX"/"locationY")` va goi
`order.setLocationX/Y(...)` binh thuong (backend van dung, chi thieu dau vao tu form).

Truy vet bang `git log --oneline -- src/main/web/checkoutThanhToan.jsp` va
`git diff <parent> <merge-commit> -- <file>` cho thay: commit `97fc1cf`
("Merge branch 'bao-ty00366' into ThanhHien_TY00243") da ghi de `checkoutThanhToan.jsp` bang 1
ban don gian hon tu nhanh `bao-ty00366`, xoa mat tinh nang chon vi tri Leaflet da lam truoc do
(them tu commit `e7e2908` "Add inline address-map modal to checkout page"). Day la 1 **merge
regression**, khong phai loi thiet ke moi.

**Da sua:**
- `src/main/web/checkoutThanhToan.jsp`: them lai (dua tren layout hien tai cua team, khong revert
  nguyen ban cu):
  - Include Leaflet CSS/JS (CDN `unpkg.com/leaflet@1.9.4`) trong `<head>`.
  - O khu "Thong tin nhan hang": field "Ten nguoi nhan"/"So dien thoai"/"Dia chi giao hang" tu dien
    tu `defaultAddress` (uu tien `param.*` khi validate-fail re-render, dung pattern EL
    `${not empty param.X ? param.X : defaultAddress.X}` da dung o nhieu JSP khac trong project).
  - Them 1 form-group moi "Vi tri tren ban do": nut bam "📍 Chon vi tri tren ban do" (chi hien ban
    do khi bam, tranh load Leaflet khong can thiet), o trong co o tim kiem dia chi (Nominatim
    search) + ban do click-to-place-marker + marker keo duoc (draggable) + reverse-geocode debounce
    500ms de tu dien lai vao o "Dia chi giao hang". 2 input an `locationX`/`locationY` duoc cap
    nhat moi khi doi vi tri, gui thang trong form checkout POST toi `/checkout` — khop dung ten
    param ma `CheckoutServlet.doPost` da doc san.
  - Logic JS (`initCheckoutLocationMap`/`toggleCheckoutLocationMap`) dua theo dung pattern da co san
    va da chay tot o `Shopprofile.jsp` (`initShopLocationMap`), doi ten namespace sang
    `checkoutLocation*` de khong dung ID/ham voi modal ben `diaChi.jsp`.
  - Neu `defaultAddress` da co san toa do, ban do tu dat marker ngay (khong can bam "Tim"); neu
    chua co va trinh duyet cho phep, dung `navigator.geolocation` de can giua ban do vao vi tri
    hien tai cua nguoi dung (khong tu dat marker, chi doi nguoi dung click/keo).
- Khong sua Java (`CheckoutServlet.java` da dung san tu truoc, chi la dead code vi thieu input tu
  JSP).

**Ket qua:** Don hang tao moi tu gio se co `Order.locationX/locationY` (neu nguoi dung chon vi tri
tren ban do khi checkout), nen marker diem giao (🏠) se hien dung tren ban do theo doi realtime cua
ca khach hang (`donhang.jsp`) va shipper. Don hang cu (tao truoc fix nay) van se khong co marker
diem giao — day la gioi han cua thiet ke "snapshot tai thoi diem tao don" (xem muc 25), khong the
retroactive.

Da compile lai toan bo `src/main/java` bang `javac` (classpath tu `.m2`), khong loi — chi sua JSP
nen khong co thay doi phia Java.

## 27. Fix loi 500 khi xac nhan thanh toan (hoaDon.jsp - fmt:parseDate khong parse duoc LocalDateTime)

**Trieu chung:** Vao `/bill?orderIds=<id>` bi loi 500,
`JspException: In <parseDate>, value attribute can not be parsed: "2026-07-16T02:46:58.370"`.

**Nguyen nhan:** `Order.createdAt` la `java.time.LocalDateTime`, EL goi `toString()` ra dang ISO
(`yyyy-MM-ddTHH:mm:ss.SSS`, co `T` va mili giay). The `<fmt:parseDate pattern="yyyy-MM-dd
HH:mm:ss">` (danh cho `java.util.Date` kieu cu, dau cach thay vi `T`, khong co mili giay) khong
bao gio parse dung duoc chuoi nay — loi co san tu truoc, khong lien quan toi phan sua vi tri ban
do o muc 26.

**Da sua:**
- `src/main/web/hoaDon.jsp` (dong 146-147): bo `fmt:parseDate`/`fmt:formatDate`, thay bang
  `fn:substring(bill.order.createdAt.toString(), ...)` de cat truc tiep gio/phut/ngay/thang/nam tu
  chuoi ISO — dung y het pattern da dung san o `shop/xemDanhGia.jsp` (dong 258, 302) cho cung kieu
  `LocalDateTime` trong project. Taglib `fn` da co san trong file, khong can them include.

Da compile lai toan bo `src/main/java` bang `javac`, khong loi (chi sua JSP).

## 28. Fix layout bang "Quan ly hoa don" (shop) bi bop hep do dia chi qua dai

**Trieu chung:** O `shop/Quanlybill.jsp`, sau khi checkout dung Nominatim reverse-geocode (muc 26),
dia chi giao hang tra ve rat dai (vi du "Hem 145/26/7 Duong Phuc Loi, Hoi Xa, Phuong Phuc Loi, Ha
Noi, 08443, Viet Nam"), lam cot "Dia chi" chiem qua nhieu cho, day cac cot con lai (Ma don, Trang
thai, Thao tac...) bi bop hep lai, giao dien bang mat can doi.

**Da sua:**
- `src/main/web/shop/Quanlybill.jsp`:
  - Them CSS `td.addr-col{max-width:220px;overflow-wrap:break-word;}` va gan class `addr-col` cho
    o `<td>` chua `o.shippingAddress` — dia chi dai se tu xuong dong trong 1 cot co gioi han chieu
    rong, khong con day cac cot khac.
  - Cot "Ngay tao" (dong hien `${o.createdAt}` truc tiep, ra chuoi ISO tho co `T` va mili giay) doi
    sang dung `fn:substring(o.createdAt.toString(), ...)` de hien dang `HH:mm dd/MM/yyyy` — dung
    pattern da dung o `hoaDon.jsp` (muc 27) va `shop/xemDanhGia.jsp`.

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

## 41. Sidebar Toggle - thu gon/mo rong Sidebar (Tong quan he thong)

Yeu cau: Them nut bam (icon 3 gach SVG) canh logo "SUPER ADMIN" de thu gon Sidebar (chi con
icon, an chu), phan noi dung chinh ben phai tu dong mo rong, co hieu ung chuyen dong muot.

Pham vi: Chi ap dung cho `admin/TongQuanHeThong.jsp` (theo xac nhan cua nguoi dung) — sidebar
hien dang lap lai (khong dung chung 1 file layout) o 37 trang JSP khac trong project, khong dong
vao cac trang do.

Da sua trong `admin/TongQuanHeThong.jsp`:

- CSS:
  - `.sidebar` them `transition: width 0.3s ease` + `overflow: hidden`; them class
    `.sidebar.collapsed { width: 84px; }` (tu 260px).
  - Them `.sidebar-toggle-btn` (nut hinh vuong bo icon SVG 3 gach, dong bo mau Dark Mode qua
    bien `--bg-input`/`--border-color`/`--text-main`).
  - Tach cau truc menu-item thanh `.menu-item-label-group` (bao icon + `.menu-label`) de co the
    an rieng phan chu ma khong mat icon.
  - Khi `.collapsed`: an `.brand-text`, `.sidebar-hi` (dong "Hi, ten"), `.menu-title` (tieu de
    nhom menu), `.menu-label` (chu cua tung muc menu), `.badge` (badge so luong) — chi con lai
    icon logo + icon tung muc menu, can giua (`justify-content: center`).
  - `.main` them `transition: all 0.3s ease` de phan noi dung chinh (chua bieu do + card) co
    hieu ung mo rong muot khi Sidebar thu gon (do `.main` la flex child voi `flex: 1`, tu dong
    lap day khoang trong con lai — transition ap dung cho cac thuoc tinh phu tro nhu
    padding/margin neu co sau nay).
- HTML: them `id="sidebarMain"` vao `<aside class="sidebar">`; them `<button
  id="sidebarToggleBtn">` chua SVG 3 gach ngang canh logo (trong khoi `.brand`, dung
  `justify-content: space-between` de logo ben trai - nut toggle ben phai); moi menu-item duoc
  tach lai thanh `<span class="menu-icon">` + `<span class="menu-label">` bo trong 1
  `.menu-item-label-group` (truoc do icon+chu gop chung 1 `<span>`, khong the an rieng chu).
- JS: them 1 IIFE moi (canh IIFE theme-toggle da co san, cung style code) doc trang thai da luu
  trong `localStorage.getItem('sidebarCollapsed')` de giu trang thai thu gon qua lan reload
  (dung dung pattern `localStorage` da dung cho theme dark/light); khi bam nut, toggle class
  `collapsed` tren `#sidebarMain` va luu lai vao `localStorage`.

Khong co thay doi Java/Servlet/DAO — thuan tuy CSS/HTML/JS trong JSP nen khong can `javac`.
Khuyen nghi nguoi dung chay server, load `/tong-quan`, bam nut 3 gach de kiem tra Sidebar thu
gon/mo rong dung nhu yeu cau va trang thai duoc giu lai sau khi reload trang.

## 42. Dong bo Sidebar Toggle + Custom Scrollbar cho toan bo admin/ (8 file con lai)

Yeu cau: Nguoi dung xac nhan muon dong bo tinh nang Sidebar Toggle (muc 41) va custom scrollbar
(dark theme, cho khu vuc `.menu` cuon) sang tat ca cac trang JSP con lai trong `admin/` — chon
lam truoc toan bo `admin/` (9 file, `TongQuanHeThong.jsp` da co san) truoc khi xet toi `shop/`,
`shipper/`, `user/`.

Pham vi: 8 file con lai trong `admin/` — `quanlitaikhoan.jsp`, `yeuCauShop.jsp`,
`yeuCauShipper.jsp`, `doiMatKhauAdmin.jsp`, `hoSoAdmin.jsp`, `chiTietYeuCauShop.jsp`,
`chiTietYeuCauShipper.jsp`, `appeals.jsp`.

Phat hien: cac file khong dung chung 1 layout sidebar — co 2 "family" class-naming khac nhau,
phai kiem tra tung file truoc khi sua:

- **Family `.brand`/`.brand-row`/`.logo`/`.menu`** (giong `TongQuanHeThong.jsp`):
  `quanlitaikhoan.jsp`, `doiMatKhauAdmin.jsp`, `hoSoAdmin.jsp`, `appeals.jsp`. Trong nhom nay,
  cach dat ten badge cung khac nhau tung file: `quanlitaikhoan.jsp` dung `.badge-count`/
  `.badge-count.green`; `appeals.jsp` dung `.badge`/`.badge.red`; `doiMatKhauAdmin.jsp` va
  `hoSoAdmin.jsp` khong co badge nao trong menu.
- **Family `.sidebar-brand`/`.logo-icon`/`.menu-section`/`.menu-item-left`/`.badge-system`**:
  `yeuCauShop.jsp`, `yeuCauShipper.jsp`, `chiTietYeuCauShop.jsp`, `chiTietYeuCauShipper.jsp` — co
  them badge "SYSTEM" rieng (`.badge-system`), cau truc menu-item bao boc trong div
  `.menu-item-left`, scrollbar target `.menu-section` thay vi `.menu`.

Da sua giong pattern muc 41 (CSS collapse + toggle button + custom scrollbar; HTML `id=
"sidebarMain"` + nut `#sidebarToggleBtn` (SVG 3 gach) + tach `.menu-label`; JS them IIFE
`sidebarCollapsed` doc localStorage) cho ca 8 file, dieu chinh theo dung family class-naming cua
tung file:

- `quanlitaikhoan.jsp`, `yeuCauShop.jsp`, `yeuCauShipper.jsp`: da dong bo tu truoc.
- `doiMatKhauAdmin.jsp`, `hoSoAdmin.jsp`: khong co badge, tach 11 menu-item thanh
  `.menu-item-label-group` (icon + `.menu-label`).
- `chiTietYeuCauShop.jsp`, `chiTietYeuCauShipper.jsp`: trang "chi tiet" nhung dung chung cau truc
  sidebar voi trang danh sach cha (`yeuCauShop.jsp`/`yeuCauShipper.jsp`) — giu nguyen icon span,
  chi boc phan chu con lai trong `<span class="menu-label">`.
- `appeals.jsp`: co 3 badge dieu kien (`shopChoDuyet`, `pendingShippers`, `pendingCount`) dung
  class `.badge.red` (khac ten voi `.badge-count.green` cua `quanlitaikhoan.jsp`) — CSS an badge
  luc collapsed phai nham dung `.badge` chu khong phai `.badge-count`; cac khoi `<c:if>` chua
  badge duoc giu nguyen la sibling ben ngoai `.menu-item-label-group`. File nay cung la file DUY
  NHAT co script theme-toggle KHONG boc trong IIFE (dung bien toan cuc + `localStorage.getItem
  ('adminTheme')` thay vi `'theme'`) — IIFE `sidebarCollapsed` duoc chen ngay sau khoi
  `addEventListener('click', ...)` cua theme-toggle, truoc khai bao `function switchTab(name)`,
  thay vi sau dong dong `})();` nhu cac file khac.

Khong co thay doi Java/Servlet/DAO — thuan tuy CSS/HTML/JS trong JSP nen khong can `javac`.
Khuyen nghi nguoi dung chay server, load lai tung trang trong `admin/` de kiem tra nut toggle
hoat dong dung va scrollbar hien thi dep o Dark Mode.

## 43. [MOCK-DATA] Trang Kiem duyet noi dung (`admin/KiemDuyetNoiDung.jsp`)

Yeu cau: Dung khung giao dien (layout only, mock-data) cho tinh nang "Kiem duyet noi dung" —
Admin duyet binh luan/mon an bi he thong giu lai truoc khi hien thi cong khai. Nguoi dung yeu
cau lam truoc phan giao dien de duyet truc quan, CHUA can noi Servlet/DAO/DB that.

**Trang thai: CHI LA MOCK-DATA, chua co backend.** File co comment `<!-- MOCK-DATA -->` o dau va
1 dong canh bao mau xanh info tren giao dien de khong bi nham la tinh nang da hoan thien.

Da tao moi `src/main/web/admin/KiemDuyetNoiDung.jsp` — dong bo dung khung sidebar/topbar/Dark
Mode/custom scrollbar/sidebar-toggle nhu cac trang admin khac (xem muc 41, 42), gom:

- **2 tab**: "💬 Bình luận chờ duyệt (4)" va "🍜 Món ăn chờ duyệt (3)" (dung lai pattern
  `.tab-bar`/`.tab-btn`/`switchTab()` co san tu `appeals.jsp`).
- **Card kiem duyet dung chung** (`.mod-card`) cho ca 2 loai noi dung:
  - Tab binh luan: avatar + nguoi dang (`.mod-name`) + ngu canh (don hang/mon an lien quan) +
    thoi gian tuong doi; noi dung binh luan trong `.message-box`.
  - Tab mon an: avatar Shop + `.food-row` (thumbnail icon 64x64 + ten mon + danh muc + gia).
  - Ca 2 loai deu co `.reason-tags` — cac the ly do bi giu lai, phan biet mau theo muc do:
    `.reason-tag.danger` (do, VD "Chua tu khoa nhay cam"), `.reason-tag.warn` (vang, VD "Bi bao
    cao Nx"), `.reason-tag.info` (xanh duong, VD "Hinh anh mo/nghi van spam").
  - 2 nut hanh dong nhanh: `.btn-approve` ("✅ Phê duyệt") va `.btn-reject` ("🚫 Từ chối
    (Ẩn/Xóa)") — hien tai chi xu ly client-side (JS `mockApprove()`/`mockReject()`: card fade-out
    + remove khoi DOM + goi `window.showToast()` co san trong `assets/js/toast.js` de bao mock
    thanh cong/that bai), CHUA submit form/goi servlet that.
- Menu Sidebar: muc "Kiểm duyệt nội dung" duoc danh dau `active` va tro ve chinh trang nay
  (`${pageContext.request.contextPath}/admin/kiem-duyet-noi-dung` — URL nay CHUA duoc map servlet
  nao, chi la placeholder cho buoc lam backend sau).

Cac buoc con thieu de hoan thien tinh nang that (chua lam trong muc nay):
- Model/DAO doc danh sach binh luan + mon an dang o trang thai cho duyet (can xac dinh bang du
  lieu: co the la cot `status`/`is_flagged` tren bang `Comments`/`Products`, hoac bang report
  rieng).
- Servlet xu ly GET (nap danh sach that thay mock) + POST xu ly action `approve`/`reject`.
- Noi `<form>` that (giong pattern `appeals.jsp`) thay cho cac nut `onclick` JS mock.
- Dang ky route servlet cho URL `/admin/kiem-duyet-noi-dung` va cap nhat lai link o TAT CA cac
  trang admin khac dang de `href="#"` cho muc menu "Kiểm duyệt nội dung" (hien dang la placeholder
  o moi file, xem muc 41/42) tro ve dung URL nay.

Khong co thay doi Java/Servlet/DAO trong buoc nay — thuan tuy JSP/CSS/JS mock nen khong can
`javac`. Nguoi dung can chay server va load `/admin/KiemDuyetNoiDung.jsp` de duyet giao dien
truc quan (Dark/Light mode, thu gon Sidebar, bam thu nut Phe duyet/Tu choi de xem hieu ung) truoc
khi xac nhan lam tiep phan backend that.

## 44. Noi backend that cho tab "Mon an cho duyet" (`admin/KiemDuyetNoiDung.jsp`)

Yeu cau: Tiep tuc muc 43 — noi Servlet/DAO/DB that cho trang Kiem duyet noi dung. Khao sat code
xac nhan he thong CHUA co bang/model/DAO/UI nao cho tinh nang binh luan (khong bang `Comments`,
khong noi nguoi dung viet binh luan o dau), va cung chua co bang `Reports` hay logic loc tu khoa
nhay cam. Da hoi nguoi dung 2 quyet dinh pham vi truoc khi lam:

- **Chi lam that tab "Mon an cho duyet"** — dung lai cot `Products.status` san co, them 1 gia tri
  moi `PENDING_REVIEW`. Tab "Binh luan cho duyet" GIU NGUYEN mock-data (khong bang Comments nen
  khong the lam that), chi doi label/ghi chu de ro rang la mock.
- **Don gian hoa reason-tag**: chi 1 trang thai `PENDING_REVIEW` duy nhat, KHONG phan loai ly do
  (khong dong "chua tu khoa nhay cam"/"bi bao cao", khong bang Reports moi, khong logic loc tu
  khoa). San pham moi tao mac dinh la `PENDING_REVIEW` thay vi `ACTIVE`, hien 1 the ly do tinh
  "🆕 San pham moi can Super Admin duyet".

**Model** (`org/example/models/Product.java`): them field `shopName` (transient, chi phuc vu
hien thi ten shop dang gui mon an cho duyet, khong luu DB) + getter/setter
`getShopName()`/`setShopName()`.

**DAO** (`org/example/daos/ProductDAO.java` + `ProductDAOImpl.java`): them 2 method:
- `findPendingReview()`: `SELECT p.*, s.shop_name ... FROM Products p JOIN Shops s ON s.id =
  p.shop_id WHERE p.status = 'PENDING_REVIEW' AND p.is_deleted = 0 ORDER BY p.created_at DESC`
  (SQL cung, khong dung `buildSelectColumns(schema)` dong nhu cac method khac vi co JOIN sang
  `Shops`).
- `updateStatus(long id, String status)`: UPDATE cot status (+ `updated_at` neu co) qua
  `ProductSchema` dong (giong pattern cac method update khac trong file).

**Servlet moi** (`org/example/controllers/ContentModerationServlet.java`, route
`/admin/kiem-duyet-noi-dung`): copy dung pattern `AppealReviewServlet.java` —
- `doGet`: `requireAdmin()` (chan neu khong phai `roleId == 1`) → `findPendingReview()` → forward
  ve `admin/KiemDuyetNoiDung.jsp`.
- `doPost`: doc `action` (`approve`/`reject`) + `productId` → `approve` set status `ACTIVE`,
  `reject` set status `HIDDEN` → redirect ve chinh trang voi `?success=approved`/`?success=
  rejected` (toast.js da co san 2 ma nay, khong can sua toast.js).

**`ProductServlet.createProduct()`**: them 1 dong ep `product.setStaTus("PENDING_REVIEW")` ngay
sau khi doc form, TRUOC khi goi `normalizeStatus()` — chi ap dung cho luong tao moi (`create`),
khong dung chung ham `normalizeStatus()` de tranh anh huong luong `update` (Shop tu sua san pham
cua minh van giu nguyen status hien tai).

**Bug phat hien khi test thuc te (da sua)**: sau khi lam xong muc tren, test tao san pham moi tu
trang Shop ("Quan ly san pham") van thay status = `ACTIVE` ngay, khong vao hang cho duyet. Nguyen
nhan: trang "Quan ly san pham" cua Shop dung route `/shop/products` → servlet
`ShopProductServlet.java` (KHONG PHAI `/product` → `ProductServlet.java` da sua o tren — 2 servlet
tao san pham khac nhau, `ProductServlet` la luong `taoProduct.jsp` cu, `ShopProductServlet` la
luong that dang dung o `shop/Quanlysanpham.jsp`). `ShopProductServlet.createProduct()` tu doc
tham so `status` tu form roi set truc tiep (mac dinh `"ACTIVE"` neu form rong), khong lien quan gi
den logic da sua o `ProductServlet`. Da sua: `ShopProductServlet.java` dong ~188, thay
`product.setStaTus(status.isEmpty() ? "ACTIVE" : status)` bang `product.setStaTus(
"PENDING_REVIEW")` (bo qua hoan toan tham so status tu form khi tao moi, giong huong xu ly cua
`ProductServlet`). Da grep toan bo `src/main/java` xac nhan chi co 2 cho goi
`productDAO.createAndReturnId(product)` (ProductServlet, ShopProductServlet) — ca 2 deu da ep
`PENDING_REVIEW`, khong con luong tao san pham nao khac bo sot.

**Bo sung: hien anh that thay emoji co dinh**: nguoi dung yeu cau them anh san pham vao the o
hang cho duyet (truoc do `.food-thumb` chi hien 🍽️ tinh cho moi san pham). Da sua:
- `ContentModerationServlet.doGet()`: them `ProductImageDAO productImageDAO = new
  ProductImageDAOImpl()`, sau khi `findPendingReview()` goi
  `findPrimaryUrlsByProductIds(...)` (method co san, cung pattern voi
  `ShopProductServlet.forwardProductPage()`) roi `p.setImageUrl(...)` cho tung san pham.
- `admin/KiemDuyetNoiDung.jsp`: CSS `.food-thumb` them `overflow:hidden` + rule `.food-thumb img
  { width:100%; height:100%; object-fit:cover; }`; noi dung doi thanh `<c:choose>` — neu
  `p.imageUrl` khong rong thi hien `<img src="${p.imageUrl}">`, nguoc lai fallback ve emoji 🍽️
  cu (truong hop san pham chua upload anh).

**`admin/KiemDuyetNoiDung.jsp`**: xoa 3 the mock hardcode o tab "Mon an cho duyet", thay bang
`<c:forEach var="p" items="${pendingProducts}">` doc du lieu that tu servlet — avatar chu cai dau
ten Shop (`fn:substring`/`fn:toUpperCase`), thoi gian dung EL function co san `${app:formatDateTime
(p.createdAt)}` (taglib `/app-functions`, KHONG dung `fmt:formatDate` vi `Product.createdAt` la
`LocalDateTime` chu khong phai `java.util.Date`), nut Phe duyet/Tu choi la `<form method="post"
action="${pageContext.request.contextPath}/admin/kiem-duyet-noi-dung">` that (submit `productId` +
`action`) thay cho `onclick="mockApprove/Reject"`. Badge sidebar + tab-label + panel-title doi
sang `${pendingProducts.size()}` (dong nhat pattern voi `pendingShippers.size()` da dung o
`yeuCauShipper.jsp`). Tab "Binh luan cho duyet" GIU NGUYEN cac the mock + nut `mockApprove()`/
`mockReject()` (khong dung nua cho tab mon an) — dong `.mock-note` doi lai chi con canh bao ve tab
binh luan.

**Sua link sidebar** o 8 file admin con lai (dang `href="#"` cho muc "Kiểm duyệt nội dung"):
`appeals.jsp`, `chiTietYeuCauShipper.jsp`, `chiTietYeuCauShop.jsp`, `doiMatKhauAdmin.jsp`,
`hoSoAdmin.jsp`, `quanlitaikhoan.jsp`, `TongQuanHeThong.jsp`, `yeuCauShop.jsp`,
`yeuCauShipper.jsp` — doi thanh `${pageContext.request.contextPath}/admin/kiem-duyet-noi-dung`,
giu nguyen 2 kieu wrapper HTML da co cua tung file (`.brand`-family boc `<a>` ngoai `<li>`, vs
`.sidebar-brand`-family gan `class="menu-item"` truc tiep vao `<a>`).

**Rui ro da xac minh xay ra that (da sua)**: test tao san pham moi bi loi
`SQLServerException: The INSERT statement conflicted with the CHECK constraint
"CK__Products__status__43A1090D"` — dung nhu du bao. Da tao migration
`migration_product_status_pending_review.sql` (theo dung pattern
`migration_payment_method_payos.sql` da co san trong project): DROP constraint cu
`CK__Products__status__43A1090D`, ADD constraint moi `CK_Products_Status` cho phep them
`'PENDING_REVIEW'` ben canh 3 gia tri cu (`ACTIVE`, `OUT_OF_STOCK`, `HIDDEN`). **Nguoi dung can tu
chay file SQL nay 1 lan tren database POB** (vi du bang SSMS hoac `sqlcmd`) truoc khi tinh nang
hoat dong duoc — Claude khong co quyen truy cap DB truc tiep de tu chay migration.

**Luu y rui ro cu (da het hieu luc sau khi chay migration tren)**: `Database.md` mo ta `Products.status` co CHECK constraint
`IN ('ACTIVE','OUT_OF_STOCK','HIDDEN')` — KHONG liet ke `'PENDING_REVIEW'`. Chua kiem tra duoc
constraint nay co thuc su duoc enforce tren DB that hay khong (co the DB that khong co constraint
nay, hoac can migration sua lai). Neu insert/update san pham voi status `PENDING_REVIEW` bi loi
o runtime, day la nguyen nhan — can chay 1 migration `ALTER TABLE Products DROP CONSTRAINT ...`
+ tao lai CHECK moi co them `'PENDING_REVIEW'`.

Da bien dich sach bang `javac` (146 file `.java`, classpath ghep tu cac dependency trong
`pom.xml`) — khong loi.

## 45. Trang "Bao cao van hanh" cho Super Admin — Phan 1: Thong ke hieu suat Don hang & Giao van

Yeu cau: tao trang moi `admin/BaoCaoVanHanh.jsp` + backend that (Servlet/DAO), dong bo Dark Mode
voi cac trang admin con lai, gom: bo loc theo khoang ngay (Tu ngay/Den ngay + nut "Xem bao cao"),
khoi thong ke nhanh (Tong don hang phat sinh, Ty le hoan thanh don %, Thoi gian giao hang trung
binh phut), va bieu do Doughnut (Chart.js) ty le trang thai don hang (Thanh cong/Da huy/Dang
giao) — tat ca lay du lieu that qua cau lenh SQL `GROUP BY`.

**DAO moi** (`org/example/daos/BaoCaoVanHanhDAO.java` + `BaoCaoVanHanhDAOImpl.java`), dung
`DBUtil.getConnection()` (khong pool), 3 method:
- `countTotalOrders(tuNgay, denNgay)`: `SELECT COUNT(*) FROM Orders WHERE created_at >= ? AND
  created_at < DATEADD(DAY, 1, ?)`.
- `countOrdersByStatus(tuNgay, denNgay)`: `SELECT status, COUNT(*) FROM Orders WHERE ... GROUP BY
  status` → tra `Map<String,Integer>` (trang thai → so luong).
- `getAvgThoiGianGiaoHangPhut(tuNgay, denNgay)`: thoi gian giao = tu luc Shop xac nhan don
  (`Order_Logs.new_status = 'CONFIRMED'`) den luc Shipper giao xong (`new_status = 'DONE'`). SQL
  join 2 subquery (moi don lay `MIN(created_at)` cho lan chuyen trang thai CONFIRMED va DONE dau
  tien) roi tinh `AVG(DATEDIFF(MINUTE, ...))`, loc theo `Orders.created_at` trong khoang ngay va
  dam bao thoi gian DONE > CONFIRMED (tranh du lieu log bat thuong). Tra `null` (qua
  `rs.wasNull()`) neu khong co cap CONFIRMED→DONE nao trong khoang — JSP hien "--" thay vi 0/NaN.
  Dung dung ten bang `Order_Logs` (co gach duoi) theo schema thuc te trong `Database.md` — luu y
  DAO cu `OrderLogDAOImpl.java` dang truy van sai ten bang `"OrderLogs"` (khong gach duoi, bug co
  san, khong sua trong pham vi task nay).

**Servlet moi** (`org/example/controllers/BaoCaoVanHanhServlet.java`, route
`/admin/bao-cao-van-hanh`, guard `roleId == 1`): `doGet` doc param `tuNgay`/`denNgay` (ISO
`yyyy-MM-dd`, mac dinh 30 ngay gan nhat neu thieu/sai, tu dong hoan doi neu `denNgay` truoc
`tuNgay`), goi DAO, gom nhom 6 trang thai enum (`PENDING/CONFIRMED/READY_FOR_PICKUP/SHIPPING/
DONE/CANCELLED`) thanh 3 nhom cho bieu do (`DONE`→Thanh cong, `CANCELLED`→Da huy, 4 trang thai
con lai→Dang giao), tinh ty le hoan thanh (co chan chia cho 0), set 8 request attribute
(`tuNgay`, `denNgay`, `tongDonHang`, `tyLeHoanThanh`, `thoiGianGiaoTrungBinh`, `donThanhCong`,
`donDaHuy`, `donDangGiao`) roi forward sang `admin/BaoCaoVanHanh.jsp`.

**JSP moi** (`admin/BaoCaoVanHanh.jsp`): copy nguyen bo CSS theme Dark/Light + sidebar + topbar +
script toggle theme/sidebar tu `TongQuanHeThong.jsp` de dam bao dong bo giao dien. Them: form GET
loc ngay (`<input type="date">` x2 + nut "Xem bao cao"), 3 `.stat-card` trong `.stats-grid`, khoi
`.dashboard-grid` 2 cot gom panel bieu do Doughnut (`<canvas>` + Chart.js CDN, `type: 'doughnut'`,
mau xanh la/do/cam cho 3 trang thai, mau chu/legend doc dong tu bien CSS `--text-muted` giong
bieu do line co san) va panel chi tiet so don theo tung trang thai (dang legend list).

**Sidebar**: sua link "Bao cao van hanh" tu `href="#"` sang
`${pageContext.request.contextPath}/admin/bao-cao-van-hanh` trong ca `TongQuanHeThong.jsp` va
`KiemDuyetNoiDung.jsp`; trong `BaoCaoVanHanh.jsp` menu-item nay duoc danh dau `active`.

### 45.1. Fix: "Thoi gian giao hang trung binh" luon hien "--" (thieu du lieu Order_Logs that)

**Nguyen nhan**: cot `Order_Logs` chua bao gio duoc ghi boi luong xu ly don hang thuc te — chi co
man hinh CRUD doc lap `OrderLogServlet.java` (`/order-logs`, quan ly thu cong, khong lien quan
luong nghiep vu that) goi `OrderLogDAO.create()`. Ngoai ra `OrderLogDAOImpl.java` con dang truy
van sai ten bang `"OrderLogs"` (thieu gach duoi) thay vi `Order_Logs` that trong schema, nen neu
co goi insert cung se that bai am tham. SQL trong `BaoCaoVanHanhDAOImpl` ban than khong sai — chi
la khong co du lieu (va du co du lieu cung khong bao gio khop `new_status = 'CONFIRMED'` vi trang
thai nay chua tung duoc code gan cho don hang nao — xem ben duoi).

**Da lam** (theo lua chon cua user — "Ghi log trang thai that", khong bia so lieu 0/25 phut vao
UI):
- Sua bug ten bang trong `OrderLogDAOImpl.java`: `"OrderLogs"` → `"Order_Logs"` (ca 5 cau SQL:
  create/getAll/findById/update/delete).
- `ShopBillServlet.java` (action `"confirm"`, dong chuyen trang thai that su `PENDING →
  READY_FOR_PICKUP` — day chinh la hanh dong "Shop xac nhan don" trong nghiep vu du Orders.status
  khong dung literal `CONFIRMED`): sau khi `orderDAO.updateStatus(orderId, "READY_FOR_PICKUP")`,
  them insert `Order_Logs` moi voi `old_status="PENDING"`, `new_status="CONFIRMED"` (dung nhan
  ngu nghia khop voi SQL bao cao co san, du Orders.status thuc te la READY_FOR_PICKUP),
  `changed_by=account.getId()`.
- `ShipperOrderServlet.java` (action `"updateStatusToDone"`, chuyen `SHIPPING → DONE`): sau khi
  `orderDAO.updateStatus(orderId, "DONE")`, them insert `Order_Logs` moi voi
  `old_status="SHIPPING"`, `new_status="DONE"`, `changed_by=account.getId()`.
- Ca hai servlet them field `OrderLogDAO orderLogDAO = new OrderLogDAOImpl()`.

**Luu y**: don hang cu (tao truoc khi vá) se van khong co du lieu Order_Logs vi khong the tai tao
lai thoi diem chuyen trang thai trong qua khu — chi so "Thoi gian giao hang trung binh" se van
hien "--" cho den khi co du don hang moi di qua ca 2 moc CONFIRMED va DONE sau ban vá nay. Khong
bia gia tri mac dinh (0 hay 25 phut) de tranh danh lua nguoi xem bao cao.

### 45.2. Gan link sidebar "Bao cao van hanh" cho toan bo trang Super Admin

Truoc do link `/admin/bao-cao-van-hanh` moi chi duoc gan trong `TongQuanHeThong.jsp` va
`KiemDuyetNoiDung.jsp` (dung `href="#"` o cac trang con lai). Da sua `href="#"` →
`${pageContext.request.contextPath}/admin/bao-cao-van-hanh` (giu nguyen cau truc HTML rieng cua
tung file — co file dung `<a><li>...</li></a>`, co file dung `<a class="menu-item"><div>...</div></a>`)
trong tat ca cac trang Super Admin con lai: `appeals.jsp`, `chiTietYeuCauShipper.jsp`,
`chiTietYeuCauShop.jsp`, `doiMatKhauAdmin.jsp`, `hoSoAdmin.jsp`, `quanlitaikhoan.jsp`,
`yeuCauShipper.jsp`, `yeuCauShop.jsp`.

### 45.3. Fix: chon theme sang o "Tong quan" nhung sang trang "Khang nghi" tu doi lai theme toi

**Nguyen nhan**: 9/11 trang Super Admin dung chung localStorage key `'theme'` de luu/doc theme da
chon, nhung rieng `appeals.jsp` ("Khang nghi") va `KiemDuyetNoiDung.jsp` lai dung key khac
`'adminTheme'` — nen khi chuyen sang 2 trang nay, script doc key `'adminTheme'` (chua tung duoc
ghi) tra ve rong → mac dinh fallback ve `'dark'`, lam theme bi doi nguoc du user da chon sang o
trang khac.

**Da lam**: doi ca 2 noi doc/ghi trong `appeals.jsp` va `KiemDuyetNoiDung.jsp` tu
`localStorage.getItem/setItem('adminTheme', ...)` sang `localStorage.getItem/setItem('theme',
...)` de dong bo voi toan bo cac trang Super Admin con lai.

## 46. Trang "Bao cao van hanh" — Phan 2: "Thong ke Bien dong Van hanh" (Khung gio cao diem + Ly do huy don)

Yeu cau: them 1 card so lieu "Khung gio dat hang cao diem" va 1 bieu do cot (Chart.js) "Thong ke
ly do huy don" vao `admin/BaoCaoVanHanh.jsp`, deu lay du lieu that qua SQL `GROUP BY`.

**Van de phat sinh**: `Orders` chua co cot nao luu ly do huy don — moi cho huy don (Shop, Shipper
bao khach bom hang, tu dong huy don qua han, khach tu huy) deu chi goi
`orderDAO.updateStatus(orderId, "CANCELLED")` ma khong ghi ly do, nen khong the `GROUP BY` ra
duoc so lieu co y nghia. Phai them cot moi + sua tan goc 5 diem huy don trong code thay vi chi
sua rieng file JSP.

**Migration moi** (`migration_order_cancel_reason.sql`, cung pattern voi cac file
`migration_*.sql` khac trong repo — `USE POB; GO` + `IF NOT EXISTS (SELECT 1 FROM sys.columns
...)` de chay lai nhieu lan khong loi): `ALTER TABLE Orders ADD cancel_reason NVARCHAR(255)
NULL;`. **Nguoi dung can tu chay file nay 1 lan tren database POB** — Claude khong co quyen truy
cap DB truc tiep.

**`OrderDAO`/`OrderDAOImpl`**: them method moi `cancelOrder(long orderId, String reason)` — dung
lai dung machinery `resolveSchema()`/`q()` san co (ten bang/cot dong resolve nhu `updateStatus()`)
nhung cot `cancel_reason` la literal cung (cot moi tu them, ten co dinh, khong can dua vao
`OrderSchema` dang co ~20 tham so dang deo). SQL: `UPDATE ... SET status = 'CANCELLED',
cancel_reason = ? WHERE id = ?`. Cung sua `cancelStalePendingOrders()` (job tu dong huy don PENDING
qua han) de ghi kem `cancel_reason = N'Het han tu dong (qua gio xac nhan)'` cho nhat quan.

**5 diem goi huy don doi sang `cancelOrder(orderId, reason)` voi ly do co dinh theo tung nghiep vu**:
- `ShopBillServlet.java` (action `"cancel"`, Shop tu huy don PENDING): `"Shop huy don"`.
- `BomHangServlet.java` (Shipper bao khach tu choi nhan hang): `"Khach bom hang (tu choi nhan)"`.
- `ShipperAcceptOrderServlet.java` (don tao khac ngay hom nay, khong the giao qua ngay): `"Don qua
  han giao trong ngay"`.
- `UserOrderServlet.java` (khach tu huy don cua chinh minh): `"Khach hang tu huy"`.
- `OrderDAOImpl.cancelStalePendingOrders()` (job tu dong huy don PENDING qua nguong thoi gian):
  `"Het han tu dong (qua gio xac nhan)"`.

**Noi dung khung giao dien** (theo yeu cau, dung MOCK DATA de duyet layout truoc):
- Banner canh bao mau vang: "DANG DUNG DU LIEU MAU (MOCK DATA)..." de nguoi dung biet day chua
  phai du lieu that.
- Bo loc: chon Cua hang (dropdown "Tat ca cua hang" + 5 shop mau) + khoang ngay (tu ngay/den ngay).
- 3 card so lieu dau trang: Tong doanh thu toan san (Gross Revenue), Chiet khau san thu ve (10%),
  Tong tien can thanh toan cho Shop (Net Payout) — so lieu mau, hardcode trong JSP.
- Bang doi soat theo tung Shop: cot Ten Shop, So don thanh cong, Tong doanh thu, Phi san (10%),
  So tien thuc nhan, Trang thai (Da thanh toan / Cho thanh toan - pill mau xanh/vang), nut
  [Xac nhan thanh toan]. Du lieu bang duoc render bang JS tu mang `mockShops` (5 shop mau), tu tinh
  `fee = revenue * 10%` va `netPayout = revenue - fee`. Bam nut "Xac nhan thanh toan" chi doi
  trang thai tren giao dien (client-side only, chua goi API/DB).

**Servlet moi `KiemDuyetBinhLuanServlet.java`** (`/admin/kiem-duyet-binh-luan`, cung pattern
`requireAdmin()` check `roleId == 1` nhu `ContentModerationServlet`/`BaoCaoVanHanhServlet`):
forward toi `admin/KiemDuyetBinhLuan.jsp`. **Chua goi `findPendingReview()`** — JSP van dung
mock-data theo dung yeu cau, nen servlet hien khong set request attribute nao.

**[MOCK-DATA] `admin/KiemDuyetBinhLuan.jsp`** (dong bo Dark Mode/sidebar/tab-bar/`.mod-card` y
het cac trang admin khac — xem muc 41-43):
- **Tab 1 "Bình luận chờ duyệt"**: 3 `.mod-card` mau — nguoi gui, ten Shop bi binh luan, noi
  dung binh luan voi tu nhay cam duoc `<mark class="bad-word">` highlight do, the
  `.reason-tag.danger` ghi ro tu cam bi dinh, 2 nut "✅ Phê duyệt (Hiển thị)" / "🚫 Xóa bỏ" (JS
  `mockApprove()`/`mockReject()` — chi fade-out + remove DOM + `showToast()`, chua submit form
  that).
- **Tab 2 "Lịch sử xử lý"**: bang liet ke binh luan da xu ly, cot Trang thai dung
  `.status-pill.visible` (da duyet, xanh) / `.status-pill.removed` (da xoa, do).
- 1 dong canh bao mau xanh info o dau trang ghi ro day van la mock-data (giong pattern
  `KiemDuyetNoiDung.jsp`).
- Menu Sidebar: them muc "💬 Kiểm duyệt bình luận" (danh dau `active` tren chinh trang nay) vao
  ca 11 file admin JSP con lai (`appeals.jsp`, `yeuCauShop.jsp`, `chiTietYeuCauShipper.jsp`,
  `chiTietYeuCauShop.jsp`, `yeuCauShipper.jsp`, `hoSoAdmin.jsp`, `BaoCaoVanHanh.jsp`,
  `KiemDuyetNoiDung.jsp`, `quanlitaikhoan.jsp`, `TongQuanHeThong.jsp`, `doiMatKhauAdmin.jsp`) —
  moi file giu dung style markup rieng cua no (co file dung `<li class="menu-item">`, co file
  dung `<a class="menu-item"><div class="menu-item-left">`), dat ngay sau muc "Kiểm duyệt nội
  dung" nhu quy uoc hien co.

Con thieu (chua lam trong muc nay): UI quan ly bang `BannedWords` (them/xoa tu cam qua giao dien
thay vi SQL truc tiep), va tab "Lịch sử xử lý" van con la mock-data (xem muc 48 de biet ranh gioi
that/mock cu the sau khi noi Tab 1 voi DB that).

Da bien dich `javac` toan bo `src/main/java` sach loi (chi them method/field moi, khong doi API
cu). Nguoi dung can tu chay `migration_feedback_moderation.sql` tren DB `POB` (cung voi 2 file
migration con lai tu cac muc truoc — `migration_product_status_pending_review.sql`,
`migration_order_cancel_reason.sql` — neu chua chay) roi load `/admin/kiem-duyet-binh-luan` de
duyet giao dien truc quan (Dark/Light mode, 2 tab, bam thu nut Phe duyet/Xoa bo).

## 48. Noi "Kiem duyet binh luan" voi du lieu that — Tab "Bình luận chờ duyệt" + Phê duyệt/Xóa bỏ

Tiep tuc muc 47: chuyen Tab 1 tu mock-data sang du lieu that tu DB, va lam that 2 nut Phe
duyet/Xoa bo (cung huong da lam o muc 57 cho `KiemDuyetNoiDung.jsp`). Tab 2 "Lịch sử xử lý" giu
nguyen mock-data (ngoai pham vi yeu cau lan nay).

**Van con thieu (chua lam trong luot nay)**:
- Chua co man hinh/lich su xem lai cac lan da xac nhan thanh toan truoc do (bang `Shop_Settlements`
  hien chi duoc dung ngam de biet Trang thai trong ky dang xem, chua co trang "Lich su doi soat").
- Chua chay migration `migration_shop_settlements.sql` tren DB that (can DBA/nguoi quan tri DB
  chay truoc khi tinh nang nay hoat dong, vi bang `Shop_Settlements` chua ton tai san server).

## 47. Trang "Duyet rut tien Shipper" (phan he Quan ly tai chinh) — Khung giao dien + noi du lieu that

**File moi (khung Servlet/DAO, tao o luot lam truoc)**:
- `migration_shipper_withdrawals.sql` — tao 2 bang moi:
  - `Shipper_Wallets` (id, shipper_account_id UNIQUE, balance, updated_at) — vi tien cua Shipper,
    FK toi `Accounts(id)`.
  - `Shipper_Withdrawals` (id, shipper_account_id, amount, bank_name, bank_account_number,
    bank_account_holder, status ['PENDING'/'APPROVED'/'REJECTED'], reject_reason, requested_at,
    processed_at, processed_by). Cot bank_* luu **snapshot** thong tin ngan hang tai thoi diem yeu
    cau (khong JOIN song vao `Shipper_Profiles`) de lich su rut tien khong bi thay doi neu sau nay
    Shipper doi thong tin ngan hang. Index tren `status` va `shipper_account_id`.
  - **CHUA chay migration nay tren DB that** — day la dieu kien tien quyet de tinh nang hoat dong
    that su, can DBA/nguoi quan tri DB chay truoc.
- `src/main/java/org/example/models/ShipperWithdrawal.java` — DTO (id, shipperAccountId,
  shipperName, shipperPhone, amount, bankName, bankAccountNumber, bankAccountHolder, status,
  rejectReason, requestedAt, processedAt).
- `src/main/java/org/example/daos/ShipperWithdrawalDAO.java` + `ShipperWithdrawalDAOImpl.java`:
  - `getAllWithdrawals(status)`: SQL `JOIN Accounts` de lay ten/SDT Shipper, loc theo `status`
    neu khac null, sap xep moi nhat truoc.
  - `approveWithdrawal(withdrawalId, processedBy)`: 1 UPDATE co dieu kien
    `WHERE id = ? AND status = 'PENDING'` de tranh xu ly trung (Admin bam Phe duyet 2 lan, hoac
    2 Admin cung xu ly 1 luc).
  - `rejectWithdrawal(withdrawalId, processedBy, reason)`: **transaction** (autoCommit=false) —
    SELECT guard (chi xu ly neu dang PENDING) → UPDATE trang thai REJECTED → UPDATE
    `Shipper_Wallets.balance += amount` de **hoan tien vao vi** → commit; rollback + tra ve false
    neu yeu cau khong ton tai/da duoc xu ly truoc do.
- `src/main/java/org/example/controllers/DuyetRutTienShipperServlet.java` (`@WebServlet
  "/admin/duyet-rut-tien-shipper"`):
  - `doGet`: kiem tra quyen Super Admin (roleId == 1), doc `danhSachRutTien` tu DAO theo
    `status` filter (query param `status`), tu tinh 3 so lieu tong hop
    (tongTienYeuCau/choXuLy/daThanhToan) tu chinh danh sach da loc, forward sang JSP.
  - `doPost`: action "approve"/"reject" (tham so `id`, `action`, `reason` khi tu choi). Kiem tra
    quyen Super Admin, tra ve JSON hand-write `{success:true}` / `{success:false,"message":...}`.

**Sua (luot nay)** `src/main/web/admin/DuyetRutTienShipper.jsp` — noi vao du lieu that tu Servlet
o tren (thay the toan bo mock-data hardcode cua luot truoc):
- Them taglib `fmt` de dinh dang so tien.
- Bo loc trang thai: doi tu `<select>` + JS loc client-side sang `<form method="get">` submit
  thang ve Servlet (`onchange="this.form.submit()"`), server tra ve dung danh sach da loc theo
  `status` (gia tri filter hien tai duoc giu lai qua `${statusFilter}` de `<option selected>`
  dung dong bo voi URL).
- 3 card thong ke: dung `<fmt:formatNumber>` tren `tongTienYeuCau`/`choXuLy`/`daThanhToan` (Servlet
  tinh that tu danh sach dang xem), khong con hardcode.
- Bang danh sach: render bang `<c:forEach items="${danhSachRutTien}">`, moi `<tr>` co
  `data-id="${w.id}"` de JS biet goi API cho dung yeu cau nao. Cot Trang thai va cot Thao tac dung
  `<c:choose>` theo `w.status`: PENDING moi hien nut [Phe duyet]/[Tu choi], APPROVED/REJECTED hien
  text "Da xu ly" / "Da hoan tien vao vi" (khong con nut).
- Bo banner "DANG DUNG MOCK DATA".
- JS: thay toan bo logic cap nhat DOM gia lap bang `fetch()` POST that toi
  `/admin/duyet-rut-tien-shipper`:
  - [Phe duyet]: `confirm()` → POST `id`+`action=approve` → neu `{success:true}` thi doi pill
    thanh "Da duyet" va an nut; neu loi thi `alert(message)` va cho bam lai (khong optimistic-update
    truoc khi server xac nhan).
  - [Tu choi]: `prompt()` nhap ly do → POST `id`+`action=reject`+`reason` → neu `{success:true}`
    thi doi pill thanh "Tu choi" + text "Da hoan tien vao vi"; server da tu hoan tien vao
    `Shipper_Wallets` trong transaction, JS chi phan anh lai UI.
  - Nut duoc `disabled` trong luc cho response de tranh bam trung (double submit).

**Sua (luot truoc)** `src/main/web/admin/DoiSoatDoanhThuShop.jsp`:
- Link sidebar "Duyet rut tien Shipper" tu `href="#"` doi thanh
  `href="${pageContext.request.contextPath}/admin/duyet-rut-tien-shipper"`.

**Van con thieu / can luu y**:
- **QUAN TRONG**: `migration_shipper_withdrawals.sql` van CHUA duoc chay tren DB that — trang se
  loi 500 (bang khong ton tai) cho toi khi migration nay duoc chay thu cong.
- Chua co man hinh/API de Shipper tao yeu cau rut tien (`INSERT INTO Shipper_Withdrawals`) hay xem
  so du vi (`Shipper_Wallets`) — luot nay chi lam phia Admin duyet/tu choi. Can lam rieng 1 tinh
  nang phia app Shipper de tao du lieu dau vao cho trang nay.
- Chua co co che tru tien vao vi khi Shipper GUI yeu cau rut tien (tru truoc, hoan lai neu tu choi)
  — hien tai DAO chi cong tien lai khi REJECTED, gia dinh so tien da bi tru/khoa san khi tao yeu
  cau (o tinh nang tao yeu cau se lam sau).

## 48. Dong bo link sidebar "Duyet rut tien Shipper" tren toan bo trang Admin

Phat hien: o muc 47, chi co `DoiSoatDoanhThuShop.jsp` duoc sua link sidebar tu `href="#"` sang
`/admin/duyet-rut-tien-shipper`. Cac trang Admin khac (dung chung markup sidebar copy-paste, khong
co JSP fragment/include dung chung) van con `href="#"` cho muc menu nay -> bam vao khong dieu huong
duoc tu cac trang do.

Da sua `href="#"` -> `${pageContext.request.contextPath}/admin/duyet-rut-tien-shipper"` tren 12 file
con lai (tong cong 14 file admin co muc menu nay deu da dung link, gom ca 2 file da dung tu truoc):

- `src/main/web/admin/TongQuanHeThong.jsp`
- `src/main/web/admin/quanlitaikhoan.jsp`
- `src/main/web/admin/KiemDuyetNoiDung.jsp`
- `src/main/web/admin/KiemDuyetBinhLuan.jsp`
- `src/main/web/admin/hoSoAdmin.jsp`
- `src/main/web/admin/doiMatKhauAdmin.jsp`
- `src/main/web/admin/appeals.jsp`
- `src/main/web/admin/BaoCaoVanHanh.jsp`
- `src/main/web/admin/yeuCauShop.jsp`
- `src/main/web/admin/chiTietYeuCauShop.jsp`
- `src/main/web/admin/yeuCauShipper.jsp`
- `src/main/web/admin/chiTietYeuCauShipper.jsp`

Ghi chu: 4 file cuoi (`yeuCauShop.jsp`, `chiTietYeuCauShop.jsp`, `yeuCauShipper.jsp`,
`chiTietYeuCauShipper.jsp`) dung markup sidebar hoi khac (class `menu-item` gan truc tiep vao the
`<a>` thay vi vao `<li>` ben trong) nen khong khop pattern Grep ban dau, phai kiem tra rieng tung
file truoc khi sua.

Van con thieu: sidebar dang duplicate 14 lan, khong co JSP fragment/include dung chung — lan sau
neu them/doi muc menu moi phai sua thu cong tren tung file, de sot nhu lan nay. Nen can nhac tach
`sidebarAdmin.jspf` dung chung trong tuong lai.

---

**`Feedback.java`**: them 2 field view-only (khong luu DB, theo dung pattern `Product.shopName`):
- `targetName` (String) — ten Shop/Shipper bi binh luan, do o DAO qua JOIN/CASE roi set thu cong
  sau vong lap query (khong phai cot that trong bang `Feedbacks`).
- `highlightedComment` (String) — noi dung comment da HTML-escape + boc san the
  `<mark class="bad-word">` quanh tu cam, tinh san o DAO de JSP chi viec `${fb.highlightedComment}`
  (khong dung the JSTL moi nao — `functions.tld` khong co ham highlight).

**`FeedbackDAOImpl.java`**:
- `findPendingReview()`: viet lai SQL, them `CASE WHEN f.target_type='SHOP' THEN s.shop_name ELSE
  ta.full_name END AS target_name` voi 2 `LEFT JOIN` dieu kien theo `target_type` (join `Shops`
  khi la SHOP, join `Accounts` khi la SHIPPER). Sau moi vong lap, goi `f.setTargetName(...)` va
  `f.setHighlightedComment(highlightBadWords(f.getComment(), bannedWords))`.
- Them 3 helper `private` moi (khong dua len interface `FeedbackDAO` — YAGNI, chi noi bo dung):
  - `fetchBannedWords()`: tach rieng tu `checkBadWords()` cu de dung chung (DRY) — query
    `SELECT word FROM BannedWords` 1 lan, tra `List<String>`.
  - `escapeHtml(String)`: escape `& < > " '` truoc khi xu ly, tranh XSS tu comment nguoi dung.
  - `highlightBadWords(String comment, List<String> bannedWords)`: escape HTML truoc, roi tim
    TOAN BO vi tri khop tren chuoi da escape (khong phan biet hoa/thuong), gop cac vung chong
    lan, cuoi cung moi boc `<mark>` 1 lan duy nhat trong 1 pass — tranh loi boc long the khi 1 tu
    cam vo tinh trung ky tu voi the `<mark>` vua chen boi 1 tu cam khac duoc xu ly truoc do (rui
    ro co that neu thay the tuan tu tung tu mot).
- `checkBadWords()`: refactor de goi `fetchBannedWords()` thay vi tu query rieng — hanh vi khong
  doi.

**`KiemDuyetBinhLuanServlet.java`**:
- `doGet()`: them field `FeedbackDAO feedbackDAO = new FeedbackDAOImpl()`, goi
  `feedbackDAO.findPendingReview()`, set request attribute `pendingComments` truoc khi forward.
- Them moi `doPost()` (theo dung pattern PRG cua `ContentModerationServlet.doPost()`): doc param
  `action` (`approve`/`reject`) + `feedbackId`, goi `feedbackDAO.updateStatus(feedbackId,
  "VISIBLE")` hoac `updateStatus(feedbackId, "REMOVED")`, roi `resp.sendRedirect(...?success=...)`
  ve lai chinh GET route (khong dung forward) de tranh submit lai form khi F5.

**`admin/KiemDuyetBinhLuan.jsp`** — Tab 1 chuyen tu 3 the `.mod-card` viet cung sang du lieu that:
- Them taglib `<%@ taglib uri="/app-functions" prefix="app" %>` de dung `app:formatDateTime`.
- Xoa dong canh bao xanh "mock-data" va chu "(mock)" tren nut tab 1 (chi con o tab 2, danh dau
  rieng phan van con la mock).
- Badge dem so binh luan cho duyet doi tu so cung `3 bình luận chờ duyệt` sang
  `${pendingComments.size()} bình luận chờ duyệt` (chi hien khi `not empty pendingComments`).
- Vong lap `<c:forEach var="fb" items="${pendingComments}">` dung cho tung `.mod-card`: ten
  nguoi gui/avatar chu cai dau tu `fb.reviewerName` (`fn:substring`/`fn:toUpperCase`), dong
  "Bình luận về Shop/Shipper `${fb.targetName}`" (toan tu 3 ngoi `${fb.targetType eq 'SHOP' ? ...
  : ...}`), thoi gian tao qua `app:formatDateTime(fb.createdAt)`, noi dung hien thi truc tiep
  `${fb.highlightedComment}` (da highlight san tu DAO, khong can JS xu ly).
- 2 nut Phe duyet/Xoa bo doi tu `onclick="mockApprove/mockReject"` sang 2 the `<form method="post"
  action="${pageContext.request.contextPath}/admin/kiem-duyet-binh-luan">` rieng, moi form co
  hidden input `feedbackId` + `action` (`approve`/`reject`) — submit that, khong con AJAX/JS.
- `.empty-state` doi tu `style="display:none"` co dinh sang dieu kien
  `${empty pendingComments ? 'display:block;' : 'display:none;'}` de tu dong hien khi het hang
  doi.
- Xoa het JS `mockApprove()`/`mockReject()`/`mockRemoveCard()` (khong con dung); thay bang 1 doan
  script nho doc query param `?success=approved|rejected` sau redirect PRG de goi
  `window.showToast(...)` — dung lai ham `showToast()` co san tu `assets/js/toast.js`, khong tao
  co che toast moi.

Con lai chua lam (ngoai pham vi yeu cau lan nay, ghi lai de lam sau neu can): UI quan ly bang
`BannedWords` qua giao dien, va noi that Tab 2 "Lịch sử xử lý" voi query loc
`status IN ('VISIBLE','REMOVED')`.

## 49. Don gian hoa "Kiem duyet noi dung" con 2 tab + Tab moi "Quan ly Tu khoa cam" (Banned Words)

Trang `admin/KiemDuyetNoiDung.jsp` truoc do co 2 tab: "Bình luận chờ duyệt (mock)" + "Món ăn chờ
duyet" (that). Vi da co trang rieng `/admin/kiem-duyet-binh-luan` (muc 47-48) xu ly binh luan
that, tab binh luan mock o day bi trung lap va gay nham lan cho Super Admin. Yeu cau: xoa tab
binh luan mock, dua tab "Món ăn chờ duyệt" thanh Tab 1 mac dinh, va them Tab 2 moi de Super Admin
tu quan ly bang `BannedWords` (xem/them/xoa tu cam) truc tiep tren giao dien thay vi phai sua DB
tay.

**`BannedWord.java`** (model moi, `org.example.models`): POJO don gian `id` (long), `word`
(String), `createdAt` (LocalDateTime) — anh xa dung 3 cot cua bang `BannedWords` da tao tu
migration `migration_feedback_moderation.sql` (muc 47).

**`FeedbackDAO.java` / `FeedbackDAOImpl.java`** — them 3 method CONG KHAI moi (dat trong
`FeedbackDAO` vi day la noi duy nhat dang thao tac bang `BannedWords`, tranh tao them 1
DAO/model rieng khong can thiet cho 1 bang cau hinh nho):
- `findAllBannedWords()`: `SELECT id, word, created_at FROM BannedWords ORDER BY created_at DESC`,
  tra `List<BannedWord>` day du id (khac voi `fetchBannedWords()` private cu chi tra
  `List<String>` de phuc vu highlight, khong doi/xoa method cu).
- `addBannedWord(String word)`: `INSERT INTO BannedWords (word) VALUES (?)`.
- `deleteBannedWord(long id)`: `DELETE FROM BannedWords WHERE id = ?`.

**`ContentModerationServlet.java`**:
- Them field `FeedbackDAO feedbackDAO = new FeedbackDAOImpl()`.
- `doGet()`: goi them `feedbackDAO.findAllBannedWords()`, set request attribute `bannedWords`
  truoc khi forward (giu nguyen logic `pendingProducts` cu).
- `doPost()`: mo rong nhanh re theo `action` — giu nguyen 2 nhanh cu `approve`/`reject` (doc
  `productId`), them 2 nhanh moi khong dung chung param voi mon an de tranh xung dot:
  - `addWord`: doc param `word`, neu khong rong thi `feedbackDAO.addBannedWord(word.trim())` roi
    redirect `?success=wordAdded`.
  - `deleteWord`: doc param `wordId`, goi `feedbackDAO.deleteBannedWord(...)` roi redirect
    `?success=wordDeleted`. Van theo dung pattern PRG (Post-Redirect-Get) nhu 2 nhanh mon an.

**`admin/KiemDuyetNoiDung.jsp`**:
- Xoa het khoi Tab "Bình luận chờ duyệt (mock)" (4 the `.mod-card` viet cung du lieu gia + nut
  `onclick="mockApprove/mockReject"`), xoa luon banner CSS `.mock-note` va noi dung dung no (da
  het can thiet vi khong con du lieu mock nao tren trang nay).
- Tab bar chi con 2 nut: "🍜 Món ăn chờ duyệt (N)" (gio la `tab-btn active` mac dinh, panel
  `tab-food` cung doi thanh `tab-panel active`) va "🔞 Quản lý Từ khóa cấm (N)" (`tab-bannedwords`,
  khong active mac dinh). Logic/du lieu cua tab mon an giu nguyen 100% (khong doi form/servlet
  call), chi doi vi tri + trang thai active.
- Tab moi `tab-bannedwords`: 1 form nho tren cung (`action=addWord` + input text `name="word"`
  bat buoc + nut "➕ Thêm từ cấm"), duoi la `<c:forEach var="bw" items="${bannedWords}">` render
  moi tu cam thanh 1 "pill" (`.word-pill`) gom text + nut tron "✕" xoa — moi pill la 1
  `<form method="post">` rieng voi hidden `action=deleteWord` + `wordId=${bw.id}`, submit that
  (khong AJAX), dung dung pattern PRG nhu cac form khac trong file. Co `.empty-state` rieng khi
  `bannedWords` rong.
- CSS moi: `.word-input-row`, `.btn-add-word`, `.word-list`, `.word-pill` (theo dung he bien
  CSS dark/light `--bg-input`/`--border-color`/`--primary`/`--danger` da dung xuyen suot file,
  khong tao he mau moi).
- JS: xoa het `mockRemoveCard()`/`mockApprove()`/`mockReject()` (chet code sau khi xoa tab mock —
  tab mon an da dung `<form>` submit that tu truoc, khong phu thuoc JS nay). Thay bang 1 doan
  script doc query param `?success=...` sau PRG redirect de goi `window.showToast(...)` cho ca 4
  truong hop (`approved`/`rejected`/`wordAdded`/`wordDeleted`) — dung lai `showToast()` co san,
  khong tao co che moi.

Da bien dich `javac` toan bo `src/main/java` sach loi. Khong can migration moi — bang
`BannedWords` da duoc tao san tu `migration_feedback_moderation.sql` (muc 47), nguoi dung chi can
dam bao da chay migration nay truoc khi test. Kiem tra thu cong sau khi chay server: load
`/admin/kiem-duyet-noi-dung`, xac nhan Tab 1 (mon an) hien mac dinh va hoat dong nhu cu, chuyen
sang Tab 2 thay danh sach tu cam that (5 tu seed tu migration), thu them 1 tu moi va xoa 1 tu —
ca 2 thao tac phai cap nhat DB va load lai danh sach dung (PRG redirect + toast).

<<<<<<<<< Temporary merge branch 1
## 50. Sua loi avatar tu-dong-luu bo qua nut "Lưu thay đổi" (admin/shop/shipper profile)

**Trieu chung:** Tren 3 trang ho so ca nhan (`admin/hoSoAdmin.jsp`, `shop/hoSoShop.jsp`,
`shipper/hoSoShipper.jsp`), khi upload anh avatar moi, ngay sau khi Cloudinary tra ve URL, JS
POST luon URL do toi servlet rieng (`/admin/update-avatar`, `/shop/update-avatar`,
`/shipper/update-avatar`) va luu thang vao DB — trong khi cac truong con lai (ho ten, email, sdt)
chi luu khi bam nut "💾 Lưu thay đổi". Nguoi dung phan anh: upload avatar xong la avatar da doi
that tren toan he thong du chua bam Luu thay doi cho phan con lai cua form — hanh vi khong nhat
quan, gay hieu lam la "lam" (avatar luu ngay lap tuc, cac truong khac thi khong).

**Nguyen nhan:** Avatar dung 1 luong luu rieng, tach biet hoan toan khoi form chinh
(`<form action=".../profile" method="post">` hoac `.../ho-so`) — form chinh chi gui
`fullName`/`email`/`phone`, khong biet gi ve avatar.

**Da sua** (ap dung dong nhat ca 3 trang, cung 1 pattern):
- Them `<input type="hidden" name="avatarUrl" id="avatarUrlInput" value="${profile.avatarUrl}"/>`
  vao dau form chinh cua ca 3 trang, de avatarUrl di theo cung request voi cac truong khac khi
  bam "Lưu thay đổi".
- JS xu ly `change` cua file input: van upload len Cloudinary va preview ngay (avatar-card + nut
  avatar tren topbar) nhu cu, nhung **bo hoan toan** doan `fetch`/`XMLHttpRequest` POST toi
  `/admin|shop|shipper/update-avatar`. Thay vao do chi gan
  `document.getElementById('avatarUrlInput').value = url` va doi thong bao thanh
  `📌 Ảnh đã sẵn sàng, bấm "Lưu thay đổi" để áp dụng.` — avatar chi la preview cho toi khi submit
  form.
- `AdminProfileServlet.doPost()`, `ShopHoSoServlet.doPost()`, `ShipperHoSoServlet.doPost()`: doc
  them param `avatarUrl`; neu khac null va bat dau bang `https://res.cloudinary.com/` (giu nguyen
  whitelist domain nhu servlet update-avatar cu) thi `account.setAvatarUrl(avatarUrl.trim())`
  truoc khi `accountDAO.update(account)` — avatar gio duoc luu chung 1 transaction voi ho
  ten/email/sdt, dung 1 lan bam "Lưu thay đổi".
- Cac servlet cu `AvatarUploadServlet`/`ShopAvatarUploadServlet`/`ShipperAvatarUploadServlet`
  (`/admin|shop|shipper/update-avatar`) giu nguyen trong code (khong con noi nao goi toi nhung
  khong gay hai gi, xoa la viec don dep rieng ngoai pham vi loi nay).

Da bien dich `javac` toan bo `src/main/java` sach loi (chi doi doPost 3 servlet them 3 dong doc
param, khong doi API/signature nao). Nguoi dung can tu load lai 1 trong 3 trang ho so, doi anh
avatar, xac nhan: (1) avatar CHI doi preview, chua luu DB (F5 lai thi ve anh cu neu chua bam Luu),
(2) bam "💾 Lưu thay đổi" thi avatar + ho ten/email/sdt cung duoc luu 1 luc va hien
`✅ Cập nhật hồ sơ thành công!`.

## 51. Dong bo giao dien/JS upload avatar cua shop va shipper y chang SuperAdmin

Theo yeu cau nguoi dung: lam avatar-upload UI/JS cua `shop/hoSoShop.jsp` va `shipper/hoSoShipper.jsp`
**y chang** `admin/hoSoAdmin.jsp` (chi khac mau theme rieng cua tung trang), thay vi 2 pattern khac
nhau nhu truoc (admin dung `fetch` + label; shop/shipper dung `XMLHttpRequest` + thanh progress bar).

**Da sua** (ap dung dong nhat cho ca `shop/hoSoShop.jsp` va `shipper/hoSoShipper.jsp`):
- CSS: bo `.btn-change-avatar` / `#uploadProgressBar` / `.bar`, thay bang `.avatar-upload-btn`
  (nut dashed-border kieu admin) + `#avatarFileInput { display:none; }` + `.upload-status` — dung
  bien mau CSS rieng cua tung trang (`--bg-input`, `--border`/`--border-color`, `--text-muted`,
  `--primary`).
- HTML avatar-card: doi thu tu + cau truc giong admin —
  `<div class="profile-avatar" id="profileAvatarCircle">` boc `<img id="avatarPreviewImg">` hoac
  `<span id="avatarInitials">`, tiep theo `<input type="file" id="avatarFileInput"
  accept="image/jpeg,image/png,image/webp"/>`, `<label for="avatarFileInput"
  class="avatar-upload-btn">📷 Đổi ảnh đại diện</label>`, `<div class="upload-status"
  id="uploadStatus"></div>`, roi moi den ten/badge (bo nut `<button onclick=...>` va progress bar cu).
- JS: thay toan bo khoi `XMLHttpRequest` (upload progress %, uploadMsg/uploadProgressBar) bang dung
  `fetch()` y het admin: kiem tra file <= 2MB (them rang buoc nay, admin da co san nhung shop/shipper
  truoc do chua co), upload Cloudinary, tao/append `#avatarPreviewImg` vao `#profileAvatarCircle`
  (an `#avatarInitials` neu co), cap nhat avatar tren topbar (`#avatarBtn`), ghim URL vao
  `#avatarUrlInput`, hien `📌 Ảnh đã sẵn sàng, bấm "Lưu thay đổi" để áp dụng.` trong `#uploadStatus`.
- Khong doi servlet (`ShopHoSoServlet`, `ShipperHoSoServlet`) — logic luu avatarUrl khi bam
  "Lưu thay đổi" da dung tu muc 50, khong can sua them.

Da grep xac nhan khong con file nao tham chieu `uploadMsg`/`uploadProgressBar`/`btn-change-avatar`/
`uploadBar` trong `src/main/web`. Nguoi dung nen tu load lai `/shop/ho-so` va `/shipper/ho-so`, thu
doi avatar de xac nhan giao dien/hanh vi khop voi `/admin/profile`.
## 52. Phi giao hang tinh theo khoang cach (6.000d/km) va gioi han 20km khi checkout

Endpoint: `/checkout` (POST)

Truoc do phi giao hang la 1 hang so co dinh `FIXED_DELIVERY_FEE = 15000` ap dung cho moi don bat
ke khoang cach, khong co gioi han khoang cach shop-diem giao. Theo yeu cau moi: phi giao hang tinh
theo khoang cach thuc te (6.000d/km), va tu choi tao don neu shop cach diem giao qua 20km.

Da sua `src/main/java/org/example/controllers/CheckoutServlet.java`:

- Them hang so `FEE_PER_KM = 6000` va `MAX_DELIVERY_DISTANCE_KM = 20`.
- Them method tinh `haversineKm(lat1, lng1, lat2, lng2)` (cong thuc Haversine, giong ban client
  o `orderTrackingMap.js` muc 25c, nhung tinh o phia server vi day la buoc validate/tinh tien bat
  buoc, khong the tin client).
- Trong `doPost`, truoc khi tao don: voi moi shop trong gio hang (gio hang co the co nhieu shop,
  moi shop tao 1 `Order` rieng — xem muc 8), lay toa do shop (`Shop.locationX/locationY`, nhap tu
  `/shop/profile`) va toa do diem giao nguoi dung chon tren Leaflet luc checkout
  (`locationX`/`locationY` cua form, xem muc 26):
  - Neu ca 2 toa do deu co: tinh khoang cach Haversine. Neu > 20km thi **KHONG tao bat ky don nao**
    (kiem tra het tat ca shop truoc khi tao, tranh tao don cho shop hop le roi moi phat hien shop
    khac qua xa giua chung), hien loi tren trang xac nhan hoa don (dung lai co che
    `showReview(..., error)` da co san, hien qua `<div class="alert-error">` co san trong
    `checkoutThanhToan.jsp`) voi noi dung neu ro ten shop va khoang cach hien tai.
    Phi giao hang = `khoang_cach_km * 6000`.
  - Neu thieu toa do (shop chua chon vi tri, hoac khach khong chon diem giao tren ban do — muc nay
    khong bat buoc): giu nguyen `FIXED_DELIVERY_FEE = 15000` nhu truoc, khong chan don.

Da sua `src/main/web/user/checkoutThanhToan.jsp`: them 1 dong ghi chu duoi o "Phi giao hang" giai
thich day la phi tam tinh (chua chon vi tri), phi thuc te se tinh theo khoang cach sau khi chon
vi tri tren ban do, va don se bi tu choi neu shop cach diem giao qua 20km.

Han che/gia dinh da biet:

- Khoang cach la duong chim bay (Haversine), khong phai khoang cach thuc te theo duong di (dung
  cach tinh giong `orderTrackingMap.js`, khong dung routing API tra phi).
- Trang review (GET `/checkout`) van hien `FIXED_DELIVERY_FEE` lam gia tri tam tinh vi luc do
  nguoi dung chua chon vi tri tren ban do — chi tinh dung khi POST voi toa do da chon.
- Neu gio hang co nhieu shop va 1 trong so do qua 20km, TOAN BO checkout bi tu choi (khong tao
  rieng cho cac shop con lai) — nguoi dung phai bo san pham cua shop qua xa hoac doi diem giao
  truoc khi thanh toan lai.

Da compile lai toan bo `src/main/java` bang `javac -encoding UTF-8` (classpath tu `.m2`), khong loi.

## 53. Shipper huy don (bat buoc nhap ly do)

Endpoint: `/shipper/donhang` (POST, `action=cancelOrder`)

Truoc do shipper chi co 2 luong lam don bien mat khoi hang doi giao: "Bao bom hang" (`/shipper/bom-hang`,
chi danh cho truong hop **khach** tu choi nhan hang, tu dong tang `bom_count` cua khach) va hoan
thanh giao (`updateStatusToDone`). Chua co luong cho shipper **tu huy don** vi ly do cua rieng minh
(vd xe hong, khong tim duoc dia chi, ...).

Da sua `src/main/java/org/example/controllers/ShipperOrderServlet.java`:

- Them nhanh xu ly moi trong `doPost` cho `action=cancelOrder`, chi cho phep khi don dang
  `READY_FOR_PICKUP` hoac `SHIPPING` va thuoc dung shipper dang dang nhap (dung lai dieu kien
  `order.getShipperId() == account.getId()` da co san).
- Bat buoc co `reason` (param form) khong rong (server-side validate, ngoai validate JS o client) —
  neu rong thi khong lam gi ca (khong huy don), y het pattern cac nhanh action khac trong servlet
  nay (khong co error/toast rieng cho trang nay tu truoc).
- Khi hop le: `orderDAO.updateStatus(orderId, "CANCELLED")`, ghi 1 dong `Order_Logs` moi voi
  `old_status` = trang thai truoc do, `new_status = "CANCELLED"`, `note = "Shipper huy don. Ly do: " + reason`
  (dung cot `note NVARCHAR(MAX)` co san cua `Order_Logs`, khong them cot moi nao), va tao 1
  `Notification` cho chinh shipper (dung pattern cac nhanh action khac trong file nay, vd
  `updateStatusToDone`, deu chi notify shipper tu ve hanh dong cua minh, khong notify khach hang).

Da sua `src/main/web/shipper/chitietdonhang.jsp`:

- Them nut "❌ Huỷ đơn" trong khu vuc `action-bar`, hien khi don dang `READY_FOR_PICKUP` hoac
  `SHIPPING`.
- Nut goi `submitCancelOrder()` (script moi): dung `prompt()` de bat buoc shipper nhap ly do (rong
  thi bao loi va khong submit, huy prompt thi khong lam gi), roi `confirm()` xac nhan lan cuoi
  truoc khi submit form an (`reason` gan vao input hidden `cancelReasonInput`).

Ghi chu:

- Khac voi "Báo bom hàng" (loi cua khach hang, anh huong `bom_count`/khoa tai khoan khach), "Huỷ
  đơn" la loi/quyet dinh cua shipper, khong dung chung logic voi `BomHangServlet`, khong anh huong
  tai khoan khach hang.
- Khong them cot DB moi — ly do huy luu trong `Order_Logs.note` (cot san co, dung dung muc dich
  ghi log lich su chuyen trang thai don, xem cach dung tuong tu o cac nhanh `updateStatusToDone`
  trong cung file).
- Chua co man hinh nao (Admin/Shop/User) hien thi lai `note` cua `Order_Logs` cho don bi huy boi
  shipper — hien tai chi luu lai de tra cuu qua DB/bao cao van hanh sau nay, khong hien UI moi
  cho pham vi yeu cau nay.

Da compile lai toan bo `src/main/java` bang `javac -encoding UTF-8` (classpath tu `.m2`), khong loi.

## 54. Hoan thien quy trinh giao hang (CONFIRMED/READY_FOR_PICKUP/gan shipper), tru ton kho tu dong, khieu nai don hang, Notification realtime

File nay bi dinh conflict marker (`<<<<<<<`/`=======`/`>>>>>>>`) do merge tu 1 branch khac de len
tren cac muc da ghi cua phan viec nay — da don dep marker va danh so lai (xem muc 46/52/53 o
tren). Code that cua 4 tinh nang duoi day van con nguyen tren dia, chi bi mat noi dung ghi chep
chi tiet trong file .md nay; tom tat lai ngan gon o day de khong mat dau vet:

- **Quy trinh giao hang day du** (`ShopBillServlet`, `ShipperOrderServlet`,
  `ShipperAcceptOrderServlet`, `AccountDAO.findOnlineShippers()`): tach rieng buoc `CONFIRMED`
  (shop xac nhan) khoi `READY_FOR_PICKUP` (shop da chuan bi xong mon), them gan shipper thu cong
  tu dropdown shipper dang online (validate shipperId that su la shipper online, tranh IDOR), ben
  canh co che shipper tu nhan don co san. Endpoint: `/shop/bills`.
- **Tru ton kho tu dong** (`ProductDAO.decreaseStock()`, `utils/InventoryUtil.java`): khi 1 don
  chuyen sang `DONE` (qua `ShipperOrderServlet`, `ShopPosServlet`, hoac `PayOSReturnServlet` nhanh
  POS), tru `Products.stock_quantity` theo tung dong `OrderDetail`, tu chuyen `OUT_OF_STOCK` khi ve
  0; bo qua neu `stock_quantity` dang NULL (khong gioi han).
- **Khieu nai don hang** (bang moi `Complaints`, xem `migration_complaints.sql` — **can tu chay 1
  lan tren DB**): `ComplaintDAO`/`Impl`, `ComplaintServlet` (`/khieu-nai`, khach gui + xem trang
  thai), `AdminComplaintServlet` (`/admin/khieu-nai`, Super Admin loc/phan hoi/xu ly), JSP
  `user/khieuNai.jsp` + `admin/QuanLyKhieuNai.jsp`. Khong trung voi `AppealServlet` (`/appeal` chi
  danh cho khang nghi tai khoan bi khoa).
- **Notification cho khach hang + Realtime qua WebSocket** (bang co san `Notifications`, truoc chi
  dung cho shipper): `UserNotificationServlet` (`/user/thong-bao`) + `user/thongBao.jsp`; tao
  thong bao cho khach (`order.getUserId()`) tai moi buoc doi trang thai don co y nghia
  (`ShopBillServlet`, `ShipperOrderServlet`, `ShipperAcceptOrderServlet`). Nang cap realtime qua
  `websocket/NotificationEndpoint.java` (`/ws/notifications`, dung chung `HttpSessionConfigurator`
  voi `TrackingEndpoint`) — `NotificationDAOImpl.create()` la diem duy nhat tao Notification, tu
  dong `push()` qua WebSocket sau khi INSERT thanh cong nen khong can sua tung noi goi. Frontend
  dung chung `assets/js/notifications-ws.js` (toast + cap nhat badge `[data-notif-badge]` +
  ban su kien DOM `pob-notification`), gan vao `trangnguoidung.jsp`, `donhang.jsp`, `khieuNai.jsp`,
  `diaChi.jsp`, `thongBao.jsp`, `shipper/thongbao.jsp`.

Da bien dich `javac` toan bo `src/main/java` sach loi (xac nhan lai o thoi diem viet muc nay).

## 55. Fix loi giao dien sidebar Admin bi bop hep (menu chu xuong dong)

Nguoi dung bao loi kem screenshot: sidebar cua trang `/tong-quan` (Tổng quan hệ thống) bi bop rat
hep, chu trong menu xuong dong lien tuc thanh cot doc kho doc.

Nguyen nhan: thieu the dong `</div>` cho `.sidebar-brand` truoc `<ul class="menu">` —
`<ul class="menu">` bi long ben trong `.sidebar-brand` (von la 1 flex box hep chi danh cho
logo + ten) thay vi la anh em (sibling) cua no trong `<aside class="sidebar">`. Toan bo cac muc
menu vi the bi ep vao chung khong gian hep do, khien text buoc phai xuong dong.

Da sua:

- `src/main/web/admin/TongQuanHeThong.jsp` — them `</div>` dong `.sidebar-brand` truoc
  `<ul class="menu">`.
- `src/main/web/admin/quanlitaikhoan.jsp` — cung bi loi y het (copy-paste tu cung 1 mau sidebar),
  da sua tuong tu.

Da ra soat toan bo cac trang admin con lai dung chung mau sidebar (`yeuCauShop.jsp`,
`chiTietYeuCauShipper.jsp`, `chiTietYeuCauShop.jsp`, `doiMatKhauAdmin.jsp`, `hoSoAdmin.jsp`,
`yeuCauShipper.jsp`) — deu dong dung `</div>`, khong bi loi nay.

Ghi chu: day la loi thuan HTML/JSP (markup tinh), khong lien quan Java/DAO nen khong can bien
dich lai `javac`. Neu sau nay tao them trang admin moi bang cach copy-paste sidebar tu 1 trong
cac file nay, luon doi chieu dung cau truc: `.sidebar-brand` (logo + brand-text) phai duoc dong
`</div>` HOAN CHINH truoc khi mo `<ul class="menu">` hoac `.menu-section` moi.

## 56. Ra soat bao mat toan he thong — sua 3 bug tim duoc (IDOR nghiem trong, dropdown sai enum, badge sai trang thai)

Nguoi dung yeu cau "doc lai toan he thong tim bug". Dung 1 subagent doc toan bo code doi chieu
`Database.md` (CHECK constraint that) de tim bug thuc su (khong phai code smell). Tim duoc 3 bug,
da xac minh lai thu cong va sua ca 3:

**1. [NGHIEM TRONG] IDOR — `/orders`, `/order-details`, `/cart`, `/cart-items` khong he kiem tra
dang nhap/quyen so huu:**

- `OrderServlet.java`, `OrderDetailServlet.java`: 2 file nay la CRUD noi bo kieu "admin tool" (list
  TOAN BO ban ghi qua `getAll()`, sua/xoa bat ky ban ghi nao theo id, form nhap tay ca `userId`) —
  hoan toan khong co dong nao kiem tra `HttpSession`. `AuthFilter` (`filter/AuthFilter.java`) chi
  chan URL bat dau bang `/admin/*`, khong bao phu 2 endpoint nay. Da sua: them
  `requireAdmin(req, resp)` (kiem tra `account.getRoleId() == 1`) o dau ca `doGet`/`doPost`, giong
  het pattern `requireAdmin()` cua `KiemDuyetBinhLuanServlet` — vi day dung la cong cu quan tri noi
  bo, khong phai man hinh khach hang dung truc tiep (khach dung `/user/donhang`, `CheckoutServlet`).

- `CartServlet.java`, `CartItemServlet.java`: **KHONG the khoa admin-only** nhu 2 file tren vi
  `DanhSachGioHang.jsp` (view cua `/cart`) la trang khach hang dang dung THAT de vao "💳 Thanh
  toan" (gan tu muc 7), va `thanhToanThatBai.jsp` cung link ve `/cart`. Truoc do `listCarts()` goi
  `cartDAO.getAll()` (liet ke TOAN BO gio hang cua MOI nguoi dung), form them/sua co o nhap tay
  "User ID" — bat ky khach dang nhap nao cung xem/sua/xoa duoc gio hang cua nguoi khac. Da sua theo
  huong khac: **giu quyen truy cap cho khach hang (`roleId == 3`)** thay vi khoa admin-only, nhung
  ep/kiem tra chi duoc thao tac gio hang/CHI TIET gio hang cua CHINH minh:
  - `CartServlet`: `listCarts()` doi tu `getAll()` sang `cartDAO.findByUserId(account.getId())`
    (chi 1 gio hang cua chinh minh); `showEditForm`/`updateCart`/`deleteCart` kiem tra
    `cart.getUserId() == account.getId()` truoc khi cho phep; `readCart()` khong con doc `userId`
    tu form nua ma LUON gan `account.getId()` (bo hoan toan kha nang gia mao gio hang nguoi khac).
  - `CartItemServlet`: them field `CartDAO cartDAO` de doi chieu — `listItems()` chi lay item cua
    gio hang chinh minh (qua `cartDAO.findByUserId` roi `dao.findByCartId`); moi thao tac
    sua/xoa/xem chi tiet deu qua helper moi `ownsCartItem(item, account)` (tra ve `cart.getUserId()
    == account.getId()`); `createItem()` kiem tra `cartId` gui len tu form thuoc dung gio hang cua
    minh truoc khi tao; `updateItem()` khong cho doi `cartId` sang gio hang khac qua form (giu
    nguyen `cartId` that cua ban ghi cu).

**2. [TRUNG BINH] `user/orderThemSua.jsp` dropdown dua ra gia tri KHONG hop le, se vi pham CHECK
constraint khi luu:**

- Dropdown trang thai co option `COMPLETED` (khong ton tai trong CHECK cua `Orders.status`,
  `Database.md` dong 368 chi cho `PENDING/CONFIRMED/READY_FOR_PICKUP/SHIPPING/DONE/CANCELLED`),
  thieu han 2 gia tri that la `READY_FOR_PICKUP` va `DONE`. Dropdown phuong thuc thanh toan dua ra
  `BANKING`/`MOMO` (CHECK cua `Orders.payment_method`, dong 366, chi cho `COD/BANK/PAYOS`). Chon
  cac gia tri sai nay se bi SQL Server tu choi luc INSERT/UPDATE. Da sua lai dung 2 dropdown khop
  voi CHECK constraint that.

**3. [NHE] `shop/Quanlybill.jsp` dong 222 — badge so sanh voi `'DELIVERED'` khong ton tai, don da
giao xong hien badge xam sai thay vi badge xanh "Đã giao":**

- Cung dang bug `DELIVERED` vs `DONE` da tung sua o `user/donhang.jsp` (xem muc 52-54) nhung bi bo
  sot o file nay. Da sua `${ds == 'DELIVERED'}` thanh `${ds == 'DONE'}`.

Da bien dich `javac` toan bo `src/main/java` sach loi sau khi sua ca 3 bug.

Han che/ghi chu:

- Khong sua `OrderLogServlet.java` va cac CRUD noi bo khac (ngoai pham vi 3 bug tim duoc, subagent
  khong bao cao bug o file nay) — neu nghi ngo tuong tu thi kiem tra lai rieng.
- Sau khi khoa `/orders`, `/order-details` chi con Super Admin dung duoc — neu co man hinh nao
  khac (vd JSP nao) dang lien ket toi 2 URL nay voi ky vong nguoi dung thuong truy cap duoc thi se
  bi redirect ve `/dangnhap`; chua ra soat het moi lien ket toi 2 URL nay trong toan bo `src/main/web`
  (subagent xac nhan day la CRUD tool doc lap, khong thay lien ket tu luong khach hang that).

## 57. Ra soat bug lan 2 (Shop/Shipper/thanh toan/JS) — sua 3 bug them

Tiep tuc muc 56, dung subagent doc sau hon cac khu vuc chua kiem: race condition thanh toan,
quyen so huu o cac servlet Shop/Shipper con lai, JS client-side, SQL injection, NPE. Tim va sua
3 bug:

**1. [IDOR] Chuc nang "Khoi phuc" (restore) trong Thung Rac cua Topping/Loai Topping/Loai San
Pham khong kiem tra `shop_id` — 1 shop co the khoi phuc lai ban ghi da xoa mem cua shop khac:**

- `ToppingDAO.restore(id)`, `ToppingCategoryDAO.restore(id)`, `CategoryDAO.restore(id)` chi nhan
  `id`, SQL chi co `WHERE id = ?` — khac voi `ProductDAO.restore(id, shopId)` da co san va dung
  dung tu truoc (xem muc 19). 3 servlet goi thang `restore(id)` khong doi chieu chu so huu:
  `ShopToppingServlet.restoreTopping()`, `QuanLyLoaiToppingServlet.restoreToppingCategory()`,
  `ShopProductTypeServlet.restoreCategory()`.
- Da sua: doi ca 3 interface + Impl thanh `restore(long id, long shopId)`, them
  `AND shop_id = ?` (hoac `AND ${schema.shopId} = ?` cho `CategoryDAOImpl` vi dung dynamic
  schema resolution nhu `ProductDAOImpl`) vao cau SQL UPDATE. Sua ca 3 servlet truyen them
  `shop.getId()` khi goi.

**2. [Du lieu that/ton kho] `/payos/return` khong idempotent — F5/Back-Forward lai trang return
sau khi da thanh toan xong se tru ton kho THEM 1 LAN NUA cho cung 1 don (nhanh POS):**

- `PayOSReturnServlet.java`: PayOS tra ve trang thai that qua `PayOSUtil.getPaymentStatus()` (dung,
  khong tin query string) nhung sau khi xac nhan `PAID` thi luon chay `order.setStaTus("DONE")` +
  `orderDAO.update(order)` + `InventoryUtil.decreaseStockForOrder(...)` KHONG kiem tra xem don da
  o trang thai `DONE` tu truoc do chua. Nguoi dung reload/back-forward trang return (van con hop
  le vi PayOS van tra "PAID") se lam ham nay chay lai, tru them 1 lan ton kho cho cung 1 don —
  sai lech du lieu ton kho that. Da sua: kiem tra `"DONE".equalsIgnoreCase(order.getStaTus())`
  truoc, chi cap nhat status/tru kho khi don CHUA o trang thai `DONE` (idempotent).

**3. [Rui ro tao don trung] Khong co co che chong double-submit o 2 form thanh toan chinh:**

- `user/checkoutThanhToan.jsp` (checkout khach hang) va `shop/Banhang.jsp` (POS shop,
  `submitOrder()`): nut submit khong bi disable trong luc dang xu ly, bam 2 lan nhanh/double-click
  co the gui 2 request tao 2 Order trung nhau (server khong co transaction/idempotency check).
  Da them JS: disable nut + doi text "Đang xử lý..." ngay khi submit, dung `dataset.submitting`
  de chan goi lai neu ham bi trigger nhieu lan. Day la giam thieu o UI (khong sua duoc goc re la
  thieu transaction/idempotency o server — ngoai pham vi 1 lan sua nay, ghi lai de biet neu can
  lam ky hon sau).

Da bien dich `javac` toan bo `src/main/java` sach loi sau khi sua ca 3 bug.

Han che/ghi chu:

- Van con 1 nguyen nhan goc chua sua: server (`CheckoutServlet`, `ShopPosServlet`) khong dung
  transaction va khong co idempotency key that su — JS chong double-submit o muc 3 chi giam thieu
  o UI binh thuong, khong chan duoc truong hop hiem hon (2 tab cung luc, replay request bang tool
  ngoai trinh duyet). Neu can chan tuyet doi thi phai them co che khoa/transaction o server.

## 58. Xuat PDF & Excel (Shop: hoa don PDF + doanh thu Excel; Admin: thong ke Excel)

Yeu cau: Shop xuat duoc hoa don (PDF) va doanh thu (Excel); Admin xuat duoc thong ke (Excel).
Dung Apache POI (Excel) va iText (PDF) nhu de xuat.

**Dependency moi trong `pom.xml`** (chua co truoc do, du an chi co jakarta/mssql/jstl/jbcrypt/
javamail/json): `org.apache.poi:poi:5.2.5`, `org.apache.poi:poi-ooxml:5.2.5` (xuat `.xlsx`),
`com.itextpdf:itextpdf:5.5.13.3` (xuat PDF, ban iText 5, API don gian hon iText 7, du dung cho
hoa don/bao cao 1 trang). Ca 3 deu scope mac dinh (compile) nen `maven-war-plugin` se tu dong
dong goi vao `WEB-INF/lib` khi build, khong can cau hinh gi them.

**Luu y quan trong ve moi truong build**: may chay Claude khong co lenh `mvn` trong PATH (ghi
chu tu truoc, xem muc 11) nen KHONG the chay `mvn compile` that de kiem tra day du dependency
tree. Da tu tai thu cong cac jar can thiet (`poi`, `poi-ooxml`, `poi-ooxml-lite`, `xmlbeans`,
`commons-compress`, `commons-collections4`, `commons-io`, `commons-math3`, `SparseBitSet`,
`log4j-api`, `itextpdf`, `commons-codec`) vao `~/.m2/repository` roi dung `javac` truc tiep de
xac nhan code MOI viet bien dich sach (thanh cong). Rieng viec CHAY thu (`java -cp ...`) bi loi
`NoSuchMethodError` giua cac ban commons-compress/commons-io do may local co nhieu ban cu cua 2
thu vien nay tu cac du an khac lam sai lech classpath thu cong (khong dung Maven de dieu giai
phien ban dung nhu thuc te se xay ra khi nguoi dung build bang IntelliJ/Maven that). Day KHONG
phai loi trong code — chi la gioi han cua moi truong test thu cong, khong anh huong ket qua khi
nguoi dung tu build bang Maven that (Maven se tu dong tai dung version tuong thich cua toan bo
dependency tree). **Nguoi dung nen tu build lai 1 lan bang Maven/IntelliJ va thu xuat PDF/Excel
that de xac nhan chay dung**, thay vi chi tin ket qua bien dich `javac`.

**File tien ich moi:**

- `src/main/java/org/example/utils/ExcelExportUtil.java` (moi) — ham `export(sheetName, title,
  headers, rows)` dung chung, nhan `List<Object[]>` (moi dong 1 mang gia tri, ho tro
  String/Number/null), tu dong bold dong tieu de + dong header, auto-size cot. Dung
  `XSSFWorkbook` (`.xlsx`), khong dung `HSSFWorkbook` (`.xls` cu).
- `src/main/java/org/example/utils/PdfExportUtil.java` (moi) — ham `buildInvoicePdf(BillView)`
  tai su dung `BillView`/`BillLine` co san tu `BillUtil` (dung chung voi `/bill`, `/shop/bills`
  xem hoa don HTML). Dung font `Helvetica` voi bang ma `Cp1258` (`BaseFont.createFont(...,
  "Cp1258", NOT_EMBEDDED)`) de hien dung tieng Viet co dau **ma KHONG can nhung file `.ttf` ngoai**
  (khac voi cach thong thuong phai embed font Unicode) — day la 1 chieu meo pho bien voi iText 5
  cho tieng Viet, gon hon nhieu so voi nhung `arial.ttf`/`times.ttf` tu he thong (phu thuoc OS,
  khong portable khi deploy len server Linux).

**Shop — `ShopBillServlet.java` (`/shop/bills`), them 2 action GET moi:**

- `action=exportPdf&id=` — xuat hoa don 1 don hang ra PDF (`Content-Disposition: attachment`),
  kiem tra `order.getShopId() == shop.getId()` truoc khi cho xuat (khong lo hoa don shop khac).
  Nut "📄 PDF" moi canh nut "🧾 Xem" tren moi dong trong `shop/Quanlybill.jsp`.
- `action=exportExcel` — xuat TOAN BO danh sach don hang dang loc hien tai (dung lai
  `filterOrders()` co san, giu nguyen bo loc `q`/`date`/`status`/`method` tu URL) ra `.xlsx`, kem
  1 dong "TONG DOANH THU (khong tinh don huy)" o cuoi bang. Nut "📊 Xuất Excel (doanh thu)" moi o
  filter-bar cua `shop/Quanlybill.jsp`, truyen kem cac tham so loc hien tai de file xuat ra khop
  dung voi danh sach dang xem tren man hinh.

**Admin — `BaoCaoVanHanhServlet.java` (`/admin/bao-cao-van-hanh`), them action GET moi:**

- `action=exportExcel` — xuat toan bo so lieu dang hien thi tren trang (tong don, ty le hoan
  thanh, thoi gian giao trung binh, dem theo trang thai, khung gio cao diem, thong ke ly do huy
  don) ra `.xlsx`, giu nguyen khoang ngay `tuNgay`/`denNgay` dang loc. Nut "📊 Xuất thống kê
  (Excel)" moi canh nut "🔍 Xem báo cáo" trong `admin/BaoCaoVanHanh.jsp`.
- **Phat hien va sua them 1 bug an toan trong luc lam muc nay**: `BaoCaoVanHanhServlet.doGet()`
  truoc do **hoan toan khong kiem tra dang nhap/quyen** (khac voi cac servlet admin khac deu co
  `requireAdmin()`/kiem tra `roleId == 1`) — bat ky ai biet URL `/admin/bao-cao-van-hanh` deu xem
  duoc so lieu van hanh toan he thong du khong dang nhap. Da them kiem tra `account.getRoleId() ==
  1` dau `doGet()` truoc khi lam bat cu viec gi, giong pattern cac servlet admin khac.

Da bien dich `javac` toan bo `src/main/java` sach loi sau khi them 2 file tien ich + sua 2
servlet + them dependency moi vao `pom.xml`.

Han che/ghi chu:

- Chua lam xuat Excel/PDF cho `/bill` (khach hang tu xem hoa don) — chi lam theo dung yeu cau
  (Shop + Admin), khach hang van dung nut in trinh duyet (`window.print()`) nhu cu.
- File Excel dung style toi gian (bold + mau nen xam nhat cho header), khong co bieu do/format so
  phuc tap — du dung de doi soat/luu tru, khong thay the duoc bao cao truc quan Chart.js co san
  tren giao dien.
- `PdfExportUtil` chi xuat duoc 1 hoa don/lan goi (khop voi nut PDF tren tung dong don hang) —
  chua co xuat PDF hang loat (nhieu don 1 file) vi khong nam trong yeu cau.

## 59. Fix loi 500 khi vao `/shop/pos` (Bam Bill) va `/shop/bills` (Quan ly hoa don)

Nguoi dung bao loi kem screenshot: HTTP 500 `JasperException: Attempt to redefine the prefix [c]
to [http://java.sun.com/jsp/jstl/core], when it was already defined as [jakarta.tags.core]`.

Nguyen nhan: `shop/_invoiceModal.jspf` (fragment dung chung, duoc `<%@ include %>` boi ca
`Banhang.jsp` va `Quanlybill.jsp`) tu khai bao lai prefix `c`/`fmt` bang URI CU
(`http://java.sun.com/jsp/jstl/core`, `http://java.sun.com/jsp/jstl/fmt`), trong khi ca 2 trang
cha deu da khai bao cung prefix bang URI MOI (`jakarta.tags.core`, `jakarta.tags.fmt`, chuan
Jakarta EE 10 ma toan bo du an dang dung). Vi `<%@ include %>` la include tinh (gop noi dung vao
CUNG 1 file .java luc bien dich), JSP compiler thay 2 khai bao khac URI cho cung 1 prefix trong
cung 1 scope → loi bien dich, khong lien quan gi den cac thay doi backend gan day (loi co san tu
truoc, chi lo ra khi nguoi dung thuc su bam vao 2 trang nay).

Da sua `src/main/web/shop/_invoiceModal.jspf` (dong 4-5): doi
`http://java.sun.com/jsp/jstl/core` → `jakarta.tags.core`, `http://java.sun.com/jsp/jstl/fmt` →
`jakarta.tags.fmt`, khop dung voi ca `Banhang.jsp` lan `Quanlybill.jsp`.

Ghi chu: day la loi thuan JSP taglib (khong phai Java), khong can bien dich `javac`, chi can
Tomcat bien dich lai JSP (thuong tu dong khi reload/redeploy). Neu sau nay tao them JSP fragment
(.jspf) dung chung, luon kiem tra prefix taglib khop CHINH XAC (cung URI) voi tat ca trang se
include no, khong duoc tron URI cu/moi cho cung 1 prefix.

## 60. Loai Topping gan voi 1 Loai San Pham (tranh lan topping khong lien quan, vd nuoc mam cho tra sua)

Nguoi dung phan anh: hien tai 1 "Loai Topping" (vd "Topping tra sua") khong gan voi loai san
pham nao ca — nen khi ban hang (POS), 1 mon "Tra sua" van co the bi gan topping hoan toan khong
lien quan nhu "Nuoc mam". Xac nhan lai voi nguoi dung: cho phep gan tuy chon (nullable, khong bat
buoc) de tuong thich nguoc voi du lieu cu — de trong = ap dung cho MOI loai san pham.

**Migration moi** (`migration_topping_category_product_category.sql`, **nguoi dung can tu chay 1
lan tren DB**): them cot `ToppingCategories.category_id BIGINT NULL` (FK toi `Categories(id)`).

Da sua backend:

- `src/main/java/org/example/models/ToppingCategory.java`: them field `categoryId` (`Long`,
  nullable) va `categoryName` (view-only, do o DAO qua JOIN, khong co cot tuong ung).
- `src/main/java/org/example/daos/ToppingCategoryDAOImpl.java`: viet lai toan bo cac cau SELECT
  dung `LEFT JOIN Categories c ON tc.category_id = c.id` de lay kem `category_name`; `create()`/
  `update()` bind `category_id` (dung `Types.BIGINT` qua `setNull` neu la `null`).
- `src/main/java/org/example/controllers/QuanLyLoaiToppingServlet.java`: doc them param
  `productCategoryId` tu form (`readForm()`); **validate chong IDOR** — neu co chon, phai la 1
  loai san pham THUOC DUNG SHOP dang dang nhap (doi chieu qua `productCategoryDAO.findByShopId()`),
  khong cho gan vao loai san pham cua shop khac; `forwardPage()` truyen them
  `danhSachLoaiSanPham` (danh sach loai san pham cua shop) cho dropdown.

Da sua giao dien:

- `src/main/web/shop/Quanlyloaitopping.jsp`: them cot "Áp dụng cho loại sản phẩm" trong bang danh
  sach (badge ten loai san pham hoac "Tất cả loại sản phẩm" neu de trong); them dropdown chon
  loai san pham trong modal them/sua (option rong = ap dung cho tat ca).
- `src/main/web/shop/Banhang.jsp` (POS — noi topping THUC SU duoc chon luc ban hang, khac voi
  `menuShop.jsp` phia khach hang hien chi la danh sach "tham khao" tinh, chua wiring vao gio
  hang): day la noi quan trong nhat can loc dung.
  - Nut chon size san pham them `data-category-id="${p.categoryId}"`; `addToCart()` luu
    `categoryId` vao tung dong gio hang tam (cart line).
  - Moi nhom topping trong topping-picker boc trong `<div data-topping-group
    data-category-id="...">` (rong neu loai topping khong gan loai san pham nao).
  - `openToppingPicker(idx)`: khi mo panel chon topping cho 1 dong gio hang, an di cac nhom
    topping co `data-category-id` khac voi `categoryId` cua mon dang chon (chi hien nhom "ap
    dung cho tat ca" — `data-category-id` rong — hoac nhom dung loai voi mon do).

Han che/ghi chu:

- Chi loc o **client-side (JS)** trong `Banhang.jsp`, khong validate lai o server
  (`ShopPosServlet.createOrder()`) rang topping gui len co thuc su hop le voi loai san pham
  khong — chap nhan duoc vi day la POS do CHINH shop tu thao tac tren du lieu cua ho (khong phai
  ranh gioi bao mat giua nhieu ben, chi la data quality/UX), khong phai loi bao mat.
- `menuShop.jsp` (khach hang xem menu) hien chi hien topping nhu danh sach tham khao tinh, CHUA
  wiring vao luong dat hang thuc su cua khach (ghi chu "Liên hệ shop để chọn topping khi đặt
  hàng") — nen KHONG loc theo loai san pham trong lan sua nay, vi khong co "dong gio hang" nao de
  biet dang chon mon loai gi. Neu sau nay lam topping-picker that cho khach hang thi ap dung lai
  dung logic filter nay.
- Da bien dich `javac` toan bo `src/main/java` sach loi.

## 61. Nang cap "Loai Topping - Loai San Pham" tu 1-1 sang NHIEU-NHIEU

Tiep tuc muc 60. Nguoi dung yeu cau: 1 Loai Topping phai chon duoc **NHIEU HON 1** Loai San Pham
(vd "Topping tra sua" ap dung ca cho "Tra sua" lan "Cafe"), khong chi 1 loai duy nhat nhu thiet
ke ban dau o muc 60.

**Migration moi** (`migration_topping_category_multi_product_category.sql`, **nguoi dung can tu
chay 1 lan tren DB** — chay SAU migration o muc 60, vi no doc lai du lieu tu cot `category_id`
cu roi moi xoa cot do): tao bang trung gian `ToppingCategory_ProductCategories`
(`topping_category_id`, `category_id`, PK ghep 2 cot), chuyen du lieu cu tu cot
`ToppingCategories.category_id` (neu co) sang bang moi, roi **xoa han cot `category_id` cu**
(khong con dung 1-1 nua).

Da sua backend:

- `src/main/java/org/example/models/ToppingCategory.java`: doi `Long categoryId`/`String
  categoryName` (1-1) thanh `List<Long> categoryIds`/`List<String> categoryNames` (nhieu-nhieu),
  danh sach rong = ap dung cho MOI loai san pham.
- `src/main/java/org/example/daos/ToppingCategoryDAOImpl.java`: viet lai hoan toan — bo LEFT JOIN
  1 cot, thay bang helper `loadCategoryLinks()` (JOIN qua bang trung gian, tra ve ca
  `categoryIds` + `categoryNames`) goi sau moi lan map 1 dong; `saveCategoryLinks()` (xoa het lien
  ket cu roi ghi lai dung danh sach hien tai, dung `PreparedStatement.addBatch()`) goi sau
  `create()`/`update()` thanh cong. `create()` doi sang dung `Statement.RETURN_GENERATED_KEYS` de
  lay lai id vua tao (truoc do chi tra `Boolean`, khong co id de ghi lien ket).
- `src/main/java/org/example/controllers/QuanLyLoaiToppingServlet.java`: `readForm()` doi tu doc
  1 param `productCategoryId` sang doc **mang** qua
  `req.getParameterValues("productCategoryId")` (checkbox nhieu lua chon); `validate()` doi tu
  kiem tra 1 gia tri sang duyet qua tung phan tu trong `categoryIds`, dam bao TAT CA deu thuoc
  dung shop dang dang nhap (van giu nguyen muc dich chong IDOR nhu muc 60).

Da sua giao dien:

- `src/main/web/shop/Quanlyloaitopping.jsp`: bang danh sach doi tu 1 badge sang lap qua
  `cat.categoryNames` hien nhieu badge; modal them/sua doi dropdown `<select>` (chon 1) sang 1
  khung checkbox nhieu lua chon (`<input type="checkbox" name="productCategoryId"
  value="${pc.id}">`, dung `formCat.categoryIds.contains(pc.id)` de danh dau da chon khi sua).
- `src/main/web/shop/Banhang.jsp` (POS): nhom topping doi tu `data-category-id="1"` (1 gia tri)
  sang `data-category-ids="1,2,3"` (danh sach cach nhau dau phay, render qua `<c:forEach>` JSTL);
  JS `openToppingPicker()` doi logic so sanh 1-1 sang `ids.indexOf(...) !== -1` (kiem tra loai san
  pham cua mon dang chon co NAM TRONG danh sach cua nhom topping hay khong).

Ghi chu:

- Y het muc 60: chi loc client-side trong `Banhang.jsp`, khong validate lai o server luc tao don
  (van la POS noi bo cua shop, khong phai ranh gioi bao mat).
- Da bien dich `javac` toan bo `src/main/java` sach loi.
=========
## 50. Fix IDOR o `BillServlet.java` (`/bill`) — phat hien khi audit project sau khi merge nhanh `bao-ty00366`

Sau khi merge nhanh `bao-ty00366` vao `ThanhHien_TY00243` (commit `0363552`), kiem tra lai toan bo
project (compile `javac` + doc lai cac servlet lien quan don hang/gio hang) thi thay merge nay da tu
vang 2 lo hong IDOR/thieu auth da phat hien truoc do:

- `OrderServlet.java` (`/orders`): da them `requireAdmin()` (chi roleId=1 duoc dung).
- `CartServlet.java` / `CartItemServlet.java`: da them `requireLogin()` (roleId=3) + kiem tra
  `cart.userId == account.id` / `ownsCartItem()` truoc moi thao tac xem/sua/xoa.

Nhung rieng `BillServlet.java` (`/bill` — trang xem/in hoa don sau checkout) van con sot, hoan toan
khong co buoc kiem tra dang nhap lan kiem tra chu so huu don hang. Chi can doi `orderId` tren URL
`/bill?orderId=...` (ke ca chua dang nhap) la xem duoc hoa don cua nguoi khac (ten nguoi nhan, dia
chi, mon hang, so tien).

Da sua theo dung pattern cua `ComplaintServlet`/`CartServlet`:
- Them `requireLogin()`: bat buoc co session + `account.roleId == 3`, khong thi redirect ve
  `/dangnhap`.
- Trong vong lap build `bills` tu `orderIds`, chi giu lai don hang co `order.getUserId() ==
  account.getId()` — don cua nguoi khac bi bo qua am tham (khong loi rieng, giong cach xu ly
  `order == null` cu, tranh lo thong tin qua thong bao loi khac nhau).

Da bien dich lai `javac` toan bo `src/main/java` (classpath tu `.m2`, loai bo `*-sources.jar`/
`*-javadoc.jar` vi javac tu dong dung classpath lam sourcepath va co gang bien dich luon file
`.java` ben trong cac jar do gay loi gia), khong loi.

## 51. Dong bo lai toan bo giao dien Super Admin ve mot kien truc duy nhat (Nhom A)

Nguoi dung bao loi khi vao cac trang Super Admin: vi tri sidebar sai, mau UI khac nhau giua cac
trang, va nhieu loi giao dien khac. Audit toan bo 15 file JSP trong `src/main/web/admin/` +
`src/main/web/super-admin/` phat hien co **3 kien truc UI khong tuong thich** cung ton tai:

- **Nhom A** (chuan, dung chung `theme.css`/`dashboard.css`): `<body class="dash-body">`,
  `<aside id="sidebar">`, `<div class="menu">` + `<a class="menu-item">` voi
  `<span class="mi-left"><span class="mi-icon">...</span> Label</span>`, badge dang
  `<span class="menu-badge yellow">`, theme luu trong `localStorage['pob-dashboard-theme']`,
  toggle qua ham dung chung `pobToggleSidebar()`/`pobToggleTheme()` trong
  `assets/js/dashboard-theme.js`.
- **Nhom B** (legacy, moi file tu code rieng): `<html data-theme="dark">` hard-code, khong co
  `<link>` toi `theme.css`/`dashboard.css`, tu dinh nghia `:root[data-theme]` trung lap trong
  `<style>` rieng, `<aside id="sidebarMain">` co nut thu gon `.sidebar-toggle-btn`, menu dang
  `<ul><li>`, badge `<span class="badge red">`, theme luu key rieng tung file (`'theme'` hoac
  `'adminTheme'`).
- **Kien truc lai (hybrid)**: head/topbar/footer da giong Nhom A nhung phan `<aside>` van con
  sot markup Nhom B (`id="sidebarMain"`, `.logo-icon`/`.badge-system`/`.sidebar-toggle-btn`,
  `<div class="menu-section">`, `<div class="menu-item-left">`, badge
  `<span class="badge-count green">`).

Nguoi dung chon phuong an: **dua toan bo ve Nhom A**. Da sua 9 file sau ve dung Nhom A (giu
nguyen toan bo phan noi dung/logic nghiep vu rieng cua tung trang, chi thay doi phan
head/style/sidebar/topbar/footer-script cho dong bo):

- `src/main/web/admin/BaoCaoVanHanh.jsp`
- `src/main/web/admin/DoiSoatDoanhThuShop.jsp`
- `src/main/web/admin/DuyetRutTienShipper.jsp`
- `src/main/web/admin/KiemDuyetNoiDung.jsp`
- `src/main/web/admin/KiemDuyetBinhLuan.jsp`
- `src/main/web/admin/QuanLyKhieuNai.jsp`
- `src/main/web/admin/appeals.jsp`
- `src/main/web/admin/yeuCauShop.jsp`
- `src/main/web/admin/chiTietYeuCauShop.jsp`

Cac thay doi chinh ap dung cho tung file:

- Doi head sang dung `theme.css`/`dashboard.css` + script doc theme dong tu
  `localStorage['pob-dashboard-theme']` (bo het `data-theme="dark"` hard-code va CSS bien theme
  trung lap).
- Doi `<body>` sang `<body class="dash-body">`, them `<div class="sidebar-backdrop">`.
- Doi `<aside id="sidebarMain">` (hoac tuong duong) sang `<aside class="sidebar" id="sidebar">`,
  bo nut thu gon sidebar (`.sidebar-toggle-btn`/`#sidebarToggleBtn` — Nhom A khong co co che nay),
  bo badge "SYSTEM" thua.
- Doi menu tu `<ul><li>` hoac `<div class="menu-section">`/`.menu-item-left` sang
  `<div class="menu">` + `<a class="menu-item">` voi `<span class="mi-left"><span
  class="mi-icon">EMOJI</span> Label</span>`, badge doi thanh `<span class="menu-badge
  yellow">`.
- Doi topbar sang dung `pobToggleSidebar()`/`pobToggleTheme()` dung chung, dua avatar-dropdown
  xuong cuoi `<main>`, nhung script rieng cua tung trang (vd `switchTab`, toast PRG,
  `askRejectReason`) duoc giu nguyen.
- Xoa script theme-toggle/sidebar-collapse rieng cua tung file (dung key `'theme'`/
  `'adminTheme'`/`localStorage['sidebarCollapsed']`), thay bang 1 script
  `assets/js/dashboard-theme.js` dung chung.
- Sua vai link menu chet (`href="#"`) sang dung route co san: "Doi soat doanh thu Shop" ->
  `/admin/doi-soat-doanh-thu-shop`, "Duyet Shipper" -> `/super-admin/shipper-requests`. Bo 2 muc
  menu chi la placeholder khong co dich den ("Tham so van hanh", "Truyen thong & Banner") de dong
  bo voi bo menu chuan dung chung cho tat ca cac trang.

Cac file da la Nhom A tu truoc, khong can sua: `yeuCauShipper.jsp`, `chiTietYeuCauShipper.jsp` —
dung lam mau tham chieu cho cac file khac.

Ket qua: toan bo trang Super Admin gio dung chung 1 sidebar dat dung vi tri, dung chung 1 bang
mau/theme (sang/toi dong bo qua nut theme-toggle), dung chung 1 bo ham JS
(`pobToggleSidebar`/`pobToggleTheme`).

### 51.1. Bo sung: van con sot loi sidebar/font o nhieu trang khac (phat hien sau khi bao cao "da xong")

Bao cao ban dau o muc 51 la **chua day du** — danh sach 9 file goc bo sot nhieu file khac cung
bi loi. Nguoi dung gui screenshot bao lai loi sidebar/font, yeu cau kiem tra toan bo cac trang
con lai. Grep lai toan bo `src/main/web` voi pattern rong hon
(`menu-item-label-group|menu-item-left|badge-count|sidebarMain|sidebar-toggle-btn|class="badge
(yellow|green)"`) phat hien them nhieu file `<ul><li>`/`menu-item-label-group` cu hoac markup lai
(hybrid) chua duoc sua. Da sua them cac file sau ve dung Nhom A:

- `src/main/web/admin/TongQuanHeThong.jsp` — trang mac dinh `/tong-quan`, dung trang bi loi trong
  screenshot dau tien. Thay toan bo `<ul class="menu">` cu (badge `yellow`/`N moi`, 2 muc chet
  placeholder, href chet "Doi soat doanh thu Shop") bang menu chuan Nhom A.
- `src/main/web/admin/quanlitaikhoan.jsp` — cung loi `<ul><li>` (badge `badge-count green`), da
  thay bang menu chuan, giu "Nguoi dung" active.
- `src/main/web/admin/yeuCauShipper.jsp` — sidebar dung tieu de khong chuan ("Quan ly he
  thong"/"Quan ly du lieu"), thieu han cac muc "Bao cao van hanh"/"Kiem duyet noi dung"/"Kiem
  duyet binh luan", "Khang nghi" va 2 muc tai chinh con markup cu, bi trung lap muc "Nguoi dung".
  Da thay toan bo bang menu chuan day du, gop lai con 1 muc "Nguoi dung".
- `src/main/web/admin/chiTietYeuCauShipper.jsp` — file it duoc migrate nhat: khong co `<style>`
  cho avatar-dropdown, khong import taglib `fn`, topbar dung avatar cung "AD" + link logout truc
  tiep thay vi avatar-dropdown chuan. Da them taglib `fn`, CSS avatar-dropdown, thay topbar bang
  avatar-wrapper/avatar-circle chuan, them block `<div class="avatar-dropdown">` + script toggle
  con thieu hoan toan.
- `src/main/web/admin/hoSoAdmin.jsp` — cung loi tieu de khong chuan + markup `<a><li
  class="menu-item">` cu cho "Khang nghi" va 2 muc tai chinh, thieu 3 muc menu, va co 1 muc thua
  "San pham" (`/product`) khong thuoc bo menu Super Admin chuan (co le sot lai tu template ben
  Shop). Da thay bang menu chuan day du, xoa muc "San pham" thua.
- `src/main/web/admin/doiMatKhauAdmin.jsp` — cung loi tieu de khong chuan, "Khang nghi"/"Doi soat
  doanh thu Shop"/"Duyet rut tien Shipper" con markup `<a><li class="menu-item">` cu (khong dong
  badge dung cach, href chet cho "Doi soat doanh thu Shop"), thieu 3 muc menu, co 1 muc thua "San
  pham" (`/product`). Da thay bang menu chuan day du, xoa muc "San pham" thua.
- `src/main/web/admin/KiemDuyetBinhLuan.jsp`, `KiemDuyetNoiDung.jsp`, `DuyetRutTienShipper.jsp`,
  `DoiSoatDoanhThuShop.jsp`, `BaoCaoVanHanh.jsp` — da dung Nhom A tu truoc nhung con sot 2 muc
  menu chet placeholder ("Tham so van hanh", "Truyen thong & Banner"). Da xoa.

Sau khi sua xong, grep lai toan bo `src/main/web` voi cung pattern tren: chi con 1 file
`src/main/web/shop/Banhang.jsp` con markup cu — day la trang thuoc Shop portal, **khong thuoc
pham vi** yeu cau dong bo Super Admin nen khong sua.

Ket qua (cap nhat): toan bo 15+ file JSP Super Admin (ca trong `admin/` va `super-admin/`) hien
da dung chung 1 kien truc sidebar/menu/avatar-dropdown Nhom A, khong con file nao sot markup cu.


## 52. Dong bo sidebar admin: them "Quan ly khieu nai" va sua sidebar sai cua appeals.jsp/QuanLyKhieuNai.jsp

**Trieu chung**: Menu "Quản lý khiếu nại" chỉ hiện trên 1-2 trang admin (KiemDuyetBinhLuan.jsp,
QuanLyKhieuNai.jsp), biến mất khi chuyển sang các trang admin khác. Ngoài ra trang "Kháng nghị"
(appeals.jsp) có sidebar khác hẳn các trang admin còn lại (thiếu nhiều mục, tiêu đề section khác,
có link "Sản phẩm" thừa không thuộc về đâu).

**Nguyen nhan**: Tính năng "Quản lý khiếu nại" (`AdminComplaintServlet` @ `/admin/khieu-nai`) được
merge từ nhánh của thành viên khác (`bao-ty00366`). Do project không có sidebar dùng chung (mỗi
file JSP admin tự hardcode menu riêng), link sidebar của tính năng mới chỉ được thêm vào đúng 2
file mà người đó sửa, không lan ra 13 file admin còn lại. Rieng `appeals.jsp` dùng hẳn 1 bộ sidebar
khác (tiêu đề "Quản lý hệ thống"/"Quản lý Dữ liệu" thay vì chuẩn 4 section, thiếu "Báo cáo vận hành",
"Kiểm duyệt nội dung", "Kiểm duyệt bình luận", và có link `/product` "Sản phẩm" lạc chỗ trong mục
Tài chính - có vẻ là artifact còn sót từ merge). `QuanLyKhieuNai.jsp` cũng thiếu hẳn section
"💰 QUẢN LÝ TÀI CHÍNH".

**Da sua**:
- Thêm link "📢 Quản lý khiếu nại" (`/admin/khieu-nai`, đặt ngay trước "Kháng nghị") vào 12 file
  admin còn thiếu: `BaoCaoVanHanh.jsp`, `DoiSoatDoanhThuShop.jsp`, `DuyetRutTienShipper.jsp`,
  `KiemDuyetNoiDung.jsp`, `TongQuanHeThong.jsp`, `chiTietYeuCauShipper.jsp`, `chiTietYeuCauShop.jsp`,
  `doiMatKhauAdmin.jsp`, `hoSoAdmin.jsp`, `quanlitaikhoan.jsp`, `yeuCauShipper.jsp`, `yeuCauShop.jsp`.
  Không gắn badge `pendingCount` cho link này ở các file trên vì biến `pendingCount` ở các trang đó
  đang dùng cho số lượng "Kháng nghị" đang chờ, không phải số khiếu nại — tránh hiện nhầm số.
- `QuanLyKhieuNai.jsp`: bổ sung section "💰 QUẢN LÝ TÀI CHÍNH" (Đối soát doanh thu Shop, Duyệt rút
  tiền Shipper) đang bị thiếu, đặt giữa "Kháng nghị" và "⚙️ CẤU HÌNH & HỆ THỐNG".
- `appeals.jsp`: dựng lại toàn bộ sidebar theo đúng template chuẩn 4 section (📊 TỔNG QUAN & PHÂN
  TÍCH / ⚖️ KIỂM DUYỆT & ĐIỀU PHỐI / 💰 QUẢN LÝ TÀI CHÍNH / ⚙️ CẤU HÌNH & HỆ THỐNG) giống các trang
  admin khác, xoá link "Sản phẩm" lạc chỗ.
- Xác nhận: `grep -L "Quản lý khiếu nại" *.jsp` trong `src/main/web/admin` trả về rỗng (cả 15 file
  đều có link), và số lượng thẻ `<a>`/`</a>` cân bằng ở tất cả file đã sửa.

**Kiem tra thu cong**: Đăng nhập SuperAdmin, mở lần lượt từng trang trong sidebar (Tổng quan, Báo
cáo vận hành, Duyệt Shop/Shipper, Kiểm duyệt nội dung/bình luận, Quản lý khiếu nại, Kháng nghị, Đối
soát doanh thu, Duyệt rút tiền, Người dùng, Hồ sơ, Đổi mật khẩu) — xác nhận sidebar của mỗi trang
giống hệt nhau về thứ tự và đầy đủ mục, "Quản lý khiếu nại" luôn hiện trước "Kháng nghị".

## 53. Sua loi form "Chinh sua thong tin" trong admin/hoSoAdmin.jsp khong co CSS

**Trieu chung**: Ở trang Hồ sơ cá nhân (SuperAdmin), cột trái (avatar + info-card) hiển thị đẹp
nhưng cột phải (form "Chỉnh sửa thông tin") hiện các input/button theo style mặc định của trình
duyệt, không có border bo góc, màu nền, khoảng cách... như thiết kế.

**Nguyen nhan**: JSP dùng các class `.form-card`, `.form-card-title`, `.form-group`, `.form-hint`,
`.form-actions`, `.btn-save`, `.btn-cancel` nhưng các class này **không được định nghĩa ở bất kỳ
đâu** — không có trong `theme.css`, không có trong `dashboard.css`, và `<style>` riêng của
`hoSoAdmin.jsp` chỉ có CSS cho avatar/sidebar chứ không có CSS cho form. (File `shop/hoSoShop.jsp`
và `shipper/hoSoShipper.jsp` may mắn có sẵn các class này trong `<style>` riêng của chúng nên không
bị lỗi.)

**Da sua**: Thêm CSS cho `.form-card`, `.form-card-title`, `.form-group` (+ `label`, `input`,
`input:focus`, `input:disabled`), `.form-hint`, `.form-actions`, `.btn-save` (+ `:hover`),
`.btn-cancel` (+ `:hover`) vào `<style>` của `admin/hoSoAdmin.jsp`, dùng đúng biến CSS đã có sẵn
của trang (`--bg-panel`, `--border-color`, `--text-main`, `--text-muted`, `--text-dim`, `--primary`,
`--primary-dark`, `--bg-input`, `--radius-md`) để đồng bộ theme sáng/tối có sẵn.

**Kiem tra thu cong**: Mở `/admin/profile`, xác nhận form bên phải có card nền, border bo góc,
input có nền `--bg-input` + viền, focus đổi màu viền cam, nút "Lưu thay đổi" màu cam và "Huỷ" màu
xám giống cột trái; kiểm tra cả 2 theme sáng/tối qua nút toggle theme trên topbar.

## 54. Sua avatar tren topbar khong co con tro chuot (cursor: pointer)

**Trieu chung**: Đưa chuột qua vòng tròn avatar trên topbar (admin/shop/shipper) không hiện con
trỏ tay dù click vào đó sẽ mở dropdown thông tin tài khoản.

**Nguyen nhan**: Class `.avatar-circle` dùng chung trong `assets/css/dashboard.css` (áp dụng cho
cả 3 dashboard admin/shop/shipper vì cùng link file này) thiếu khai báo `cursor: pointer`.

**Da sua**: Thêm `cursor: pointer;` vào rule `.avatar-circle` trong `assets/css/dashboard.css`.

**Kiem tra thu cong**: Mở bất kỳ trang admin/shop/shipper nào, rê chuột qua avatar ở topbar — phải
thấy con trỏ tay (pointer) và dropdown vẫn mở/đóng bình thường khi click.

## 62. Ra soat bao mat lan 3 (audit chuan bi bao ve do an) — vá 4 lo hong auth/IDOR + 1 loi chuc nang webhook

Phat hien khi lam mot audit tong the theo checklist cham diem do an tot nghiep (dashboard, UI,
quy trinh, DB, hieu nang, bao mat, tai lieu). Tim duoc **4 lo hong auth/IDOR that su** con sot lai
sau 2 dot ra soat bao mat truoc do (muc 56, 57) va **1 loi chuc nang** lien quan `AppFilter`:

- **`TongQuanServlet.java` (`/tong-quan`, dashboard tong quan Super Admin)**: hoan toan khong co
  session/roleId check, va URL `/tong-quan` khong nam trong bat ky nhanh nao cua `AppFilter`
  (chi co `/super-admin/`, `/admin/`, `/shop`, `/shipper/`, `/user/`) nen ai cung xem duoc thong
  ke toan he thong (tong tai khoan, shop cho duyet, canh bao vi pham...) ma khong can dang nhap.
  Da sua: them check `session.getAttribute("account")` null -> redirect `/dangnhap`, va
  `roleId != 1` -> tra 403, giong dung pattern da dung o `BaoCaoVanHanhServlet`.

- **`ProductServlet.java` (`/product`)** va **`CategoryServlet.java` (`/Category`)**: day la 2
  servlet CRUD noi bo (forward toi `shop/taoProduct.jsp`/`shop/taoCategory.jsp`) nhung URL khong
  co tien to `/admin`, `/shop`, `/shipper`, `/user` nen `AppFilter` chi bat buoc "da dang nhap",
  khong gioi han role -> bat ky khach hang (role 3) nao dang nhap deu tao/sua/xoa duoc san
  pham/loai san pham cua **bat ky shop nao** (truyen `shopid`/`id` tuy y qua form). Da sua: them
  method `requireAdmin()` (giong het pattern da co san trong `OrderServlet.java`, chi cho phep
  `roleId == 1`) va goi o dau `doGet`/`doPost`.

- **`OrderLogServlet.java` (`/order-logs`)**: cung loi nhu tren — khong co role check, bat ky user
  dang nhap nao doc/sua/xoa duoc lich su thay doi trang thai cua **moi** don hang trong he thong.
  Da sua: them `requireAdmin()` giong 2 servlet tren.

- **`CheckoutServlet.java` (`/checkout`)**: IDOR — `doGet`/`doPost` lay `Cart` theo `cartId` tu
  form/query string ma khong kiem tra `cart.getUserId()` co khop voi tai khoan dang dang nhap
  khong; ke ca khi `AppFilter` da bat dang nhap, 1 user van co the truyen `cartId` cua nguoi khac
  de tao don hang (va xoa gio hang) tren tai khoan nan nhan. Da sua: lay `account` tu session
  ngay dau `doGet`/`doPost` (redirect `/dangnhap` neu chua dang nhap), va kiem tra
  `cart.getUserId() == account.getId()` truoc khi dung `cart` (khac `not_found` neu khong khop).

- **`AppFilter.java`**: `PayOSWebhookServlet` (`/payos/webhook`) la endpoint server-to-server ma
  PayOS goi thang (khong co session cookie/dang nhap), nhung URL nay khong nam trong danh sach
  whitelist cua `AppFilter` -> moi request webhook thuc te se bi filter redirect ve `/dangnhap`
  truoc khi toi duoc servlet, tuc la webhook **khong bao gio chay duoc** khi deploy that. Da sua:
  them `url.contains("/payos/webhook")` vao dieu kien whitelist.

Ngoai ra, phat hien them 1 loi trong chinh migration script:

- **`migration_payment_method_payos.sql`**: ban goc DROP constraint CHECK cu tren
  `Orders.payment_method` bang ten cung `CK__Orders__payment___690797E6` (ten SQL Server tu sinh
  cho CHECK khong dat ten, hau to hash khac nhau giua cac instance DB) -> tren DB that ten khong
  khop, khoi DROP khong chay (khong bao loi vi bi boc trong IF EXISTS) nen constraint cu **van con
  song song** voi `CK_Orders_PaymentMethod` moi = 2 CHECK constraint chong nhau tren cung 1 cot
  (dung 1 trong nhung phat hien khi audit `Database.md`). Da sua: doi sang dò ten constraint cu
  **dong** qua `sys.check_constraints` (loc theo `parent_column_id`, khong theo ten), roi drop
  bang dynamic SQL — chay dung tren moi DB. Da cap nhat ghi chu tuong ung trong `Database.md`
  (dong ~644).
- Them file moi `migration_verify_all.sql` (chi SELECT, khong sua gi) — chay 1 lan tren DB that se
  liet ke chinh xac bang/cot nao trong 19 file `migration_*.sql` **chua duoc apply** (cot
  `trang_thai` = THIEU), va rieng kiem tra con dung 1 CHECK constraint tren
  `Orders.payment_method` hay dang bi trung — dung de doi chieu truoc khi bao ve do an, tranh demo
  bi loi vi migration chua chay (vd `Shipper_Wallets`/`Shipper_Withdrawals` da ghi nhan la co the
  chua chay o muc 47).

## 63. Them bieu do Chart.js vao Dashboard tong quan Super Admin (`/tong-quan`)

`TongQuanServlet` tu truoc da tinh san `tongDoanhThuSan`, `top5ShopDoanhThu`,
`thongKeTheoNgay` (7 ngay gan day) nhung `admin/TongQuanHeThong.jsp` khong he render — chi co 4
stat card + 1 bang, khong co chart nao (phat hien khi audit chuan bi bao ve do an). Da sua
(chi sua JSP, khong dong toi servlet/DAO vi du lieu da co san dung):

## 62. Tab "Lịch sử xử lý" o trang Kiem duyet binh luan (Super Admin) - bo mock, dung du lieu that

Trang `/admin/kiem-duyet-binh-luan` truoc day chi co tab "Binh luan cho duyet" dung du lieu that;
tab "Lich su xu ly" van con la bang HTML hard-code 3 dong mock. Da thay bang du lieu that:

- Them cot `Feedbacks.reviewed_at` (`DATETIME2 NULL`) qua `migration_feedback_reviewed_at.sql`
  (chay 1 lan tren DB thuc te) — ghi nhan thoi diem Super Admin bam Phe duyet/Xoa bo. Feedback
  duoc dang truc tiep (khong qua kiem duyet) se co `reviewed_at = NULL` nen khong lot vao lich
  su, chi nhung binh luan da tung o `PENDING_REVIEW` va duoc Super Admin xu ly moi hien o day.
- `FeedbackDAOImpl.updateStatus()` cap nhat them `reviewed_at = GETDATE()` moi khi doi trang thai.
- Them `FeedbackDAO.findHistory()` / `FeedbackDAOImpl.findHistory()`: lay danh sach feedback co
  `reviewed_at IS NOT NULL`, join ten Shop/Shipper bi binh luan, highlight tu cam, sap xep theo
  `reviewed_at DESC`.
- `KiemDuyetBinhLuanServlet.doGet()` set them attribute `historyComments`.
- `KiemDuyetBinhLuan.jsp`: bo nhan "(mock)" tren ten tab, doi cot tieu de "Shop" -> "Doi tuong"
  (vi target co the la Shop hoac Shipper), thay bang `<tr>` hard-code bang `<c:forEach
  var="fb" items="${historyComments}">`, dung `app:formatDateTime(fb.reviewedAt)` cho cot thoi
  gian xu ly, hien trang thai qua `status-pill visible/removed` theo `fb.status`, them empty-state
  khi chua co lich su.

File lien quan: `migration_feedback_reviewed_at.sql`, `Database.md` (cot moi trong bang
Feedbacks), `src/main/java/org/example/models/Feedback.java`,
`src/main/java/org/example/daos/FeedbackDAO.java` + `FeedbackDAOImpl.java`,
`src/main/java/org/example/controllers/KiemDuyetBinhLuanServlet.java`,
`src/main/web/admin/KiemDuyetBinhLuan.jsp`.

Luu y: `migration_feedback_reviewed_at.sql` phai duoc chay tren DB thuc te truoc khi tab nay co
du lieu (giong nhu `migration_complaints.sql` cho trang Quan ly khieu nai, van dang cho chay).

## 63. Trang moi "Tham so van hanh" (Super Admin) - cau hinh tai chinh/giao hang/thoi gian

Trang moi `/admin/tham-so-van-hanh` (nhom sidebar "⚙️ Cau hinh & He thong") cho Super Admin
xem/sua cac tham so van hanh toan he thong, luu vao 1 dong duy nhat trong bang `System_Configs`.

- Bang moi `System_Configs` (id = 1 co dinh, CHECK id = 1) qua `migration_system_configs.sql`
  (chay 1 lan tren DB thuc te, tu insert san dong mac dinh khi tao bang). Cac cot:
  `commission_percent` (10%), `fixed_fee_per_order` (0d), `shipping_fee_first_2km` (15000d),
  `shipping_fee_per_km` (5000d), `max_delivery_radius_km` (10km), `shop_accept_order_minutes`
  (15 phut), `auto_complete_order_hours` (48 gio), `updated_at`.
- Model `SystemConfig.java`, DAO `SystemConfigDAO` / `SystemConfigDAOImpl`: `get()` doc dong
  id = 1 (fallback ve gia tri mac dinh code-hardcode neu DB chua co du lieu/loi ket noi),
  `save(config)` UPDATE toan bo cot + `updated_at = GETDATE()`.
- Servlet moi `ThamSoVanHanhServlet` (`/admin/tham-so-van-hanh`): GET load config hien tai va
  forward sang JSP; POST doc 7 tham so tu form, goi `save()`, redirect PRG kem `?success=saved|failed`.
- JSP moi `src/main/web/admin/ThamSoVanHanh.jsp`: form don gian dang 3 Card ("Cau hinh Tai chinh",
  "Cau hinh Giao hang", "Cau hinh Thoi gian") theo dung cau truc panel/sidebar/topbar/avatar-dropdown
  chuan (Nhom A) da dung o cac trang Super Admin khac, nut "💾 Luu thay doi" o cuoi form, toast
  thong bao qua PRG (`?success=saved` / `?success=failed`).
- Them lai muc menu "🛠️ Tham so van hanh" (tro toi `/admin/tham-so-van-hanh` that, thay cho
  `href="#"` da bi go bo truoc do) vao muc "⚙️ Cau hinh & He thong" tren TOAN BO 15 file JSP
  Super Admin con lai (BaoCaoVanHanh, DoiSoatDoanhThuShop, DuyetRutTienShipper, KiemDuyetBinhLuan,
  KiemDuyetNoiDung, QuanLyKhieuNai, TongQuanHeThong, appeals, chiTietYeuCauShipper,
  chiTietYeuCauShop, doiMatKhauAdmin, hoSoAdmin, quanlitaikhoan, yeuCauShipper, yeuCauShop) de giu
  dong bo kien truc sidebar Nhom A.

Luu y: `CheckoutServlet.java` hien van dung hang so code-hardcode rieng cho phi ship
(`FIXED_DELIVERY_FEE = 15000`, `FEE_PER_KM = 6000`, `MAX_DELIVERY_DISTANCE_KM = 20`) — CHUA duoc
noi voi bang `System_Configs` moi nay. Nghia la sua tham so tren trang "Tham so van hanh" hien
**chua** anh huong toi phi ship thuc te luc checkout; day chi la buoc luu tru cau hinh, viec ket
noi de checkout doc dong tham so nay se can lam o mot task rieng neu duoc yeu cau.

File lien quan: `migration_system_configs.sql`, `Database.md` (bang `System_Configs` moi),
`src/main/java/org/example/models/SystemConfig.java`,
`src/main/java/org/example/daos/SystemConfigDAO.java` + `SystemConfigDAOImpl.java`,
`src/main/java/org/example/controllers/ThamSoVanHanhServlet.java`,
`src/main/web/admin/ThamSoVanHanh.jsp`, va 15 file sidebar Super Admin da liet ke o tren.

Luu y: `migration_system_configs.sql` phai duoc chay tren DB thuc te truoc khi trang nay co du
lieu that (giong `migration_complaints.sql` va `migration_feedback_reviewed_at.sql`, ca 3 migration
deu dang cho user xac nhan de chay).

- Them taglib `fmt` + 1 stat card moi "Tong doanh thu toan san" (`tongDoanhThuSan`).
- Them 2 `<canvas>` + Chart.js (CDN, cung pattern da dung o `shop/trangcuahang.jsp`):
  - "Don hang & doanh thu toan san (7 ngay gan day)": bar+line ket hop (2 truc Y — so don ben
    trai, doanh thu ben phai), du lieu tu `thongKeTheoNgay` (`ngay`/`donThanhCong`/`donHuy`/`doanhThu`).
  - "Top 5 shop doanh thu cao nhat": horizontal bar, du lieu tu `top5ShopDoanhThu`
    (`shopName`/`doanhThu`).
- `shopName` dua vao chuoi JS qua `fn:escapeXml(...)` (giong pattern da dung o
  `admin/quanlitaikhoan.jsp`, `user/menuShop.jsp`) — HTML-entity hoa truoc khi chen vao script,
  khong the pha vo chuoi JS (an toan, khong phai XSS/JS-injection moi).

## 64. Them bo tai lieu thiet ke hoc thuat (ERD/Use Case/Sequence/Class/Deployment Diagram)

Chuan bi bao ve do an tot nghiep: du an truoc do chi co tai lieu ky thuat noi bo
(`PROJECT_STRUCTURE.md`, `CRUD_DA_LAM.md`, `Database.md` dang script SQL tho) ma khong co bo tai
lieu phan tich thiet ke chuan hoc thuat (ERD/UC/Sequence/Class/Deployment diagram) — day la thieu
sot lon nhat khi audit theo tieu chi cham do an.

Da them file moi **`TAI_LIEU_THIET_KE.md`** (dung cu phap Mermaid, render truc tiep tren
GitHub/nhieu trinh xem Markdown, co the mo bang mermaid.live de export PNG/SVG dan vao bao cao
Word):

- **ERD**: dung tu DDL that trong `Database.md` + `migration_shipper_withdrawals.sql` (2 bang
  `Shipper_Wallets`/`Shipper_Withdrawals` chua duoc gop vao `Database.md`), kem ghi chu cac quyet
  dinh thiet ke dang chu y (Products khong co cot gia, ToppingCategory-Category la N-N, is_deleted
  khong co o Orders...).
- **Use Case Diagram**: theo 4 role (User/Shop/Shipper/Super Admin), lay tu danh sach chuc nang
  thuc te trong `PROJECT_STRUCTURE.md` va `tongquanhethong.md`.
- **Sequence Diagram** (3 luong phuc tap nhat, the hien dung chieu sau ky thuat da lam):
  Checkout->PayOS->Webhook (bao gom nhanh song song return-URL vs webhook, chu ky HMAC-SHA256),
  Shop xac nhan don->gan shipper->giao hang (CONFIRMED->READY_FOR_PICKUP->SHIPPING->DONE, kem
  Order_Logs + Notification realtime), va WebSocket tracking (kem buoc xac thuc CSWSH cua
  `HttpSessionConfigurator`).
- **Class Diagram**: rut gon, cac model + DAO + servlet cot loi, dung dung kien truc 3 lop that
  cua du an (khong co Service layer).
- **Deployment Diagram**: Tomcat + SQL Server + cac dich vu ngoai that dang dung (PayOS API,
  Cloudinary, SMTP Gmail, Nominatim), kem ghi chu gioi han that (WebSocket in-memory khong scale
  ngang duoc).

Da them lien ket toi file nay tu `PROJECT_STRUCTURE.md` va `tongquanhethong.md` (dong dau file,
theo dung quy uoc dieu huong tai lieu hien co cua du an).

## 65. Da chay migration tren DB that (14.225.217.109/POB) — phat hien them 2 loi chi lo ra khi chay thuc te

Tiep theo muc 62 (audit bao mat) va 64 (tai lieu thiet ke), da ket noi va chay
`migration_verify_all.sql` tren DB that qua `sqlcmd`. Ket qua ban dau: 22/24 muc `OK`, 2 muc
`THIEU` (`Shipper_Profiles.id_card_image_url`, `ToppingCategories.category_id`), va
`Orders.payment_method` chi co **1** CHECK constraint cu (khong phai 2 constraint trung nhau nhu
suy doan tu audit tinh — DB nay duoc tao tu ban DDL da co san `PAYOS` trong CREATE TABLE goc, nen
khong bi trung, nhung van thieu `MOMO`).

Phat hien 2 loi moi **chi lo ra khi chay that**, audit code tinh khong bat duoc:

- **`migration_shipper_profiles.sql`**: gop `CREATE TABLE` + `CREATE TRIGGER` chung 1 batch (cung
  1 khoi truoc `GO`) — SQL Server bat buoc `CREATE TRIGGER` phai la cau lenh DUY NHAT trong batch
  cua no, nen ca file loi cu phap ngay luc PARSE (`Msg 156 Incorrect syntax near TRIGGER`), chan
  luon nhanh `ELSE` (them cot con thieu) khong chay duoc du bang da ton tai. Da sua: tach
  `CREATE TRIGGER` ra 1 batch rieng bang `GO`, boc trong `EXEC(...)` + kiem tra
  `sys.triggers` de idempotent.
- **14/19 file `migration_*.sql`** (bao gom file tren) **thieu dong `USE POB;`** o dau file — neu
  chay bang `sqlcmd -i file.sql` ma khong truyen co `-d POB`, script se chay nham vao database
  mac dinh cua login (`master`), khien `IF NOT EXISTS` danh gia sai ngu canh va co the bao loi FK
  kho hieu (`references invalid table 'Accounts'` — vi `Accounts` khong ton tai trong `master`).
  Da sua: them `USE POB;\nGO\n` vao dau ca 14 file de tu chay dung DB bat ke co truyen `-d` hay
  khong, dong bo voi 5 file da co san dong nay (`migration_payment_method_payos.sql`,
  `migration_order_cancel_reason.sql`, `migration_payment_status.sql`,
  `migration_payos_order_code.sql`, `migration_product_status_pending_review.sql`).

Da chay thanh cong tren DB that (qua `sqlcmd -S 14.225.217.109,1433 -d POB -U sa -P ... -C -i
<file>`):

- `migration_shipper_profiles.sql` (ban da sua) -> `Shipper_Profiles.id_card_image_url` da co.
- `migration_payment_method_payos.sql` (ban da sua o muc 62) -> `Orders.payment_method` gio chi
  con dung 1 CHECK constraint `CK_Orders_PaymentMethod` (COD/BANK/PAYOS/MOMO).

`migration_verify_all.sql` cung duoc sua: bo `ToppingCategories.category_id` khoi danh sach kiem
tra (day la thiet ke 1-1 CU da bi thay the boi bang trung gian N-N
`ToppingCategory_ProductCategories` — khong phai loi thieu migration, ghi chu ro trong file de
tranh bao nham lan sau).

Xac nhan cuoi cung: chay lai `migration_verify_all.sql` -> **23/23 muc OK**, dung 1 CHECK
constraint tren `payment_method`.

Da bo sung `Shipper_Wallets`/`Shipper_Withdrawals` vao `Database.md` (truoc do 2 bang nay da ton
tai that tren DB nhung chua duoc gop vao script tong hop), kem ghi chu luong nghiep vu chua khep
kin (Shipper chua co man hinh tao yeu cau rut tien/xem so du vi).

**Fix them (nguoi dung phat hien khi hoi "xoa file migration co sao khong")**: nhan ra
`Database.md` neu chay lai TU DAU tren 1 DB hoan toan trong (vd may khac) se **tu tai tao dung
loi 2 CHECK constraint chong nhau** vua don tren DB that, vi doan `CREATE TABLE Orders`/`CREATE
TABLE Products` goc van con CHECK inline khong dat ten (thieu `MOMO`/`PENDING_REVIEW`), roi doan
`ALTER TABLE ADD CONSTRAINT` phia sau **luon luon them** them 1 constraint co ten khac ma khong
kiem tra da co chua -- 2 constraint se ton tai song song ngay tu luc tao moi. Da sua:

- Gop CHECK vao thang trong `CREATE TABLE Orders` (`CONSTRAINT CK_Orders_PaymentMethod CHECK
  (payment_method IN ('COD','BANK','PAYOS','MOMO'))`) va `CREATE TABLE Products`
  (`CONSTRAINT CK_Products_Status CHECK (status IN ('ACTIVE','OUT_OF_STOCK','HIDDEN',
  'PENDING_REVIEW'))`) -- du gia tri tu dau, khong can vas sau.
- 2 khoi `ALTER TABLE ADD CONSTRAINT` phia duoi (danh cho DB CU da ton tai bang Orders/Products
  tu truoc khi gop) duoc boc trong `IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE
  name = ...)` de idempotent -- chay tren DB moi (da co constraint tu CREATE TABLE) se tu bo qua,
  khong tao trung.
- Khong can chay lai gi tren DB that (14.225.217.109) vi DB that da dung 1 constraint moi tu
  truoc (xac nhan o phan tren cua muc nay) -- day chi la sua tai lieu/script cho truong hop setup
  DB moi tu dau.

## 66. Gom 18 file migration thanh 1 file `migration_all.sql` (nguoi dung hoi "sao khong gop lai cho de")

Theo yeu cau nguoi dung: gom 18/19 file `migration_*.sql` (tru
`migration_topping_category_product_category.sql` -- thiet ke 1-1 CU da bi thay the) thanh 1 file
duy nhat **`migration_all.sql`**, dung theo dung thu tu phu thuoc (vd `migration_feedbacks.sql`
truoc `migration_feedback_moderation.sql` vi file sau sua bang do file truoc tao). Cac file goc
van giu nguyen, khong xoa (van la tai lieu lich su tung thay doi rieng le).

Chay thu `migration_all.sql` tren DB that phat hien them **2 loi that su co san trong file goc**
(khong lien quan gi den viec gop file, chi lo ra vi day la lan dau tien file duoc chay LAN 2 tren
1 DB da co du lieu):

- **`migration_shop_settlements.sql`**: khong co `IF NOT EXISTS` bao quanh `CREATE TABLE` -> chay
  lan 2 loi "already an object named 'Shop_Settlements'". Da sua: boc trong
  `IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Shop_Settlements')`.
- **`migration_topping_category_multi_product_category.sql`**: doan `INSERT ... SELECT ...
  category_id FROM ToppingCategories` tham chieu THANG (khong qua `EXEC` dong) toi cot
  `category_id` -- SQL Server bind ten cot LUC BIEN DICH ca batch (chi "deferred name resolution"
  cho BANG chua ton tai, khong deferred cho COT cua bang da ton tai), nen du nam trong
  `IF EXISTS (...)` bao ngoai van bi loi "Invalid column name 'category_id'" ngay luc parse --
  vi cot nay da bi chinh migration nay XOA tu lan chay dau tien (`ALTER TABLE ... DROP COLUMN
  category_id` o cuoi file), nen lan chay thu 2 khong con cot do nua. Da sua: boc doan
  `INSERT`/`ALTER TABLE DROP COLUMN` trong `EXEC(N'...')` de chi bind ten cot luc CHAY (runtime),
  giong pattern da dung o muc 62 cho `CREATE TRIGGER`.

Da chay lai `migration_all.sql` 2 lan lien tiep tren DB that (14.225.217.109) sau khi sua -- ca 2
lan deu sach, khong loi (xac nhan tinh idempotent that su). Chay lai `migration_verify_all.sql`
sa u do van ra dung 23/23 muc OK -- DB khong bi anh huong gi them (dung nhu ky vong, vi moi thu da
duoc ap dung tu truoc, `migration_all.sql` chi la ban gop tien loi, khong phai thay doi moi).

**Cap nhat theo yeu cau nguoi dung**: sau khi xac nhan `migration_all.sql` chay dung, da **xoa**
toan bo 20 file `migration_*.sql` rieng le (bao gom ca `migration_topping_category_product_category.sql`
da loi thoi) bang `git rm -f` (co sua chua commit nhung noi dung da nam trong `migration_all.sql`
truoc khi xoa nen khong mat gi). Tu gio thu muc goc repo chi con dung **2 file SQL**:
`migration_all.sql` (chay 1 lan de ap dung tat ca thay doi con thieu tren 1 DB moi/DB cu) va
`migration_verify_all.sql` (kiem tra, khong sua gi). Cac tham chieu ten file migration rieng le cu
trong lich su cac muc phia tren cua file nay (vd "xem migration_complaints.sql") van giu nguyen vi
la ghi chep lich su dung tai thoi diem do, khong sua lai — noi dung thuc te da nam het trong
`migration_all.sql`.

Ghi chu:

- Con 1 diem yeu da biet nhung **chua sua** trong lan nay (uu tien thap hon, ghi lai de lam sau):
  `AppealServlet.java` (`/appeal`, whitelist san vi dung cho tai khoan bi khoa) tin thang
  `accountId` tu request parameter ma khong xac minh nguoi goi thuc su so huu account do — co the
  bi loi dung de spam/dom don khang nghi cho tai khoan nguoi khac. Can giai phap khac (vd rang
  buoc qua email + OTP) thay vi chi ownership check thong thuong.
- Da compile lai toan bo `src/main/java` bang `javac -encoding UTF-8` (qua classpath `.m2`,
  duong dan Windows qua `cygpath -w`), khong loi.
