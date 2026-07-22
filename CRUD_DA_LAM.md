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

<<<<<<< HEAD
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

## 49. Fix bug modal + redesign light theme cho `menuShop.jsp`, `trangnguoidung.jsp` (User)

- **Bug da fix**: rule dung chung `body > *:not(.starfield) { position: relative; z-index: 1; }`
  o dau file co do dac hieu CSS cao hon `.modal-overlay`/`.cart-bar` (vi `:not(.starfield)` tinh
  la 1 class selector, ket hop voi type selector `body` -> tong dac hieu lon hon selector class
  don `.modal-overlay`), nen no ghi de `position: fixed` thanh `position: relative`. Hau qua:
  modal "Chon tuy chon" khi bam nut `+`/dat mon khong con la overlay phu toan man hinh nua ma bi
  day vao giua trang, nam duoi luoi san pham (dung nhu anh chup man hinh nguoi dung gui). Da sua
  bang cach thay rule dung chung chi con set `z-index` (bo `position: relative`), va them
  `position: fixed !important` truc tiep vao `.modal-overlay` va `.cart-bar` de dam bao khong bi
  ghi de nua du CSS phia tren co doi sau nay.
- **Redesign light theme**: doi toan bo 2 file tu theme toi "vu tru" (`theme-space.css` — tim
  `#8b5cf6`/cyan `#22d3ee` tren nen den `#05040f`) sang light theme trang sach theo bang mau
  moi: nen trang `#FAFAFA`, navbar/card `#FFFFFF`, mau cam thuong hieu `--primary: #FF6B35`
  (hover `#FF8C5A`), nen cam nhat cho tag/banner `--primary-light: #FFF0EB`, vien nhat
  `#EEEEEE`, text chinh `#1A1A1A`, text phu `#999999`. Bo lop `.starfield` (sao lap lanh, dat
  `display:none`), bo toan bo `linear-gradient` tim-cyan tren nut/badge/card, doi sang mau cam
  dac (hoac nen `--primary-light`) phang. Them Google Fonts "Be Vietnam Pro" (heading
  weight 500, body weight 400) qua `<link>` trong `<head>`.
- **Giu nguyen 100%**: cau truc HTML, toan bo `id`/`class` ma JS tham chieu (`openModal`,
  `closeModal`, `changeQty`, `updateTotal`, `filterCategory` cua `menuShop.jsp`; `goToShop`,
  `filterShops`, `filterCat`, `toggleDropdown`, banner slider `goSlide`/`nextSlide`/swipe touch
  cua `trangnguoidung.jsp`), toan bo EL/JSTL render du lieu tu DB, va cac form action
  (`/user/add-to-cart`, `/checkout`, `/logout`...). Khong dong vao Servlet/DAO/Model.

## 50. Quet toan bo giao dien tim bug + redesign lai `index.jsp` (trang chu khach — chua dang nhap)

- **Quet bug toan he thong** (khong sua gi them ngoai muc duoi day — cac cho khac da kiem tra
  sach): xac nhan pattern loi "selector generic dac hieu cao ghi de `position`/`z-index`" (xem
  muc 49) CHI xay ra o `menuShop.jsp` va `trangnguoidung.jsp`, da fix het o ca hai. Kiem tra rieng
  con lai: khong co `id` trung lap trong `src/main/web/user/*.jsp`; khong co ham JS nao duoc goi
  qua `onclick` ma thieu dinh nghia (cac trang shop/admin/shipper goi `pobToggleSidebar()` /
  `pobToggleTheme()` dinh nghia dung chung trong `assets/js/dashboard-theme.js`, khong phai bug);
  khong con text mau trang-tren-trang sau khi doi 2 trang tren sang light theme; `theme-space.css`
  dung selector `.space-scope > *` (khong phai `body > *`) nen an toan voi `.pob-modal-overlay`
  vi thu tu khai bao trong file dam bao modal thang. Bug nho khong anh huong chuc nang, khong sua:
  mang JS `['navSearch','mobileSearch','heroSearch']` trong `trangnguoidung.jsp` tham chieu id
  `heroSearch` khong ton tai trong HTML — vo hai vi code da co check `if (el)`.
- **Redesign `index.jsp`** (trang chu cong khai cho khach chua dang nhap, o `src/main/web/`,
  KHONG phai `user/trangnguoidung.jsp`): thay toan bo Tailwind CDN + Font Awesome CDN cu bang
  CSS thuan theo mau thiet ke dark/glassmorphism nguoi dung cung cap — nen `#0B0F19`, panel kinh
  mo `.glass-panel` (`backdrop-filter: blur`), mau cam thuong hieu `--primary-color: #FA4A0C`,
  font Google "Outfit". Cau truc moi: navbar kinh mo dinh trang (doi mau khi cuon qua class
  `.scrolled`), hero voi thanh tim kiem + so lieu thong ke, section "Dat do an de dang" 3 buoc,
  section "Mon ngon noi bat" 3 the mon an mau (chua noi voi DB — day la trang landing tinh cho
  khach vang lai, giu dung tinh chat cu cua `index.jsp` truoc do), section quang cao app voi
  mockup dien thoai bang CSS thuan, footer. Them JS thuan (khong con Tailwind/FontAwesome): scroll
  reveal animation (`IntersectionObserver`), doi mau navbar khi cuon, active-link theo section
  dang xem. Cac nut hanh dong tro dung route that cua he thong: "Dang nhap" -> `/dangnhap`,
  "Dang ky" -> `/dangky`, "Dang ky cua hang" -> `/dangky-shop`, "Tro thanh shipper" ->
  `/dangky-shipper`. Khong dong vao Servlet/DAO/Model.

## 51. Doi tone mau `index.jsp` sang sang de dong bo voi tone User, giu net sang trong

- Doi toan bo bien mau trong `:root` cua `index.jsp` tu dark mode (`--bg-color:#0B0F19`,
  `--primary-color:#FA4A0C`) sang light mode dong bo voi `menuShop.jsp`/`trangnguoidung.jsp`:
  `--bg-color:#FAFAFA`, `--bg-alt:#FFFFFF`, `--text-main:#1A1A1A`, `--text-muted:#666666`,
  `--primary-color:#FF6B35` (hover `#FF8C5A`), them `--primary-light:#FFF0EB` /
  `--primary-light-border:#FFD4C2` giong 2 trang User kia. `--glass-bg`/`--glass-border` doi sang
  kinh mo trang (`rgba(255,255,255,.65)` + vien den mo nhat) thay vi kinh mo toi, giu nguyen hieu
  ung `backdrop-filter: blur` — day la diem mau chot giu lai net "sang trong" (glassmorphism) cua
  thiet ke goc.
- Cac phan tu truoc do dung mau trang trong suot gia dinh nen toi (`rgba(255,255,255,.05/.1)` cho
  `.glass-panel`, `.store-btn`, `.rating`) da doi sang nen trang dac/xam nhat + border/shadow phu
  hop nen sang, nen khi hover van tao hieu ung noi/glow (dung mau cam `--primary-light*` thay vi
  trang mo) — giu cam giac "premium floating card".
- **Chu y giu 2 vung toi lam diem nhan sang trong** (chu dich, khong phai bug): khung mockup dien
  thoai `.phone-frame` (bezel + man hinh toi that nhu dien thoai that) va `.footer` (nen toi
  `#0B0F19` lam "bookend" khep trang). Ca 2 vung nay tu khai bao lai bien CSS `--text-main`/
  `--text-muted` cuc bo (VD: `.footer { --text-main:#FFFFFF; --text-muted:#94A3B8; }`) de chu ben
  trong van sang mau tren nen toi, khong bi ke thua nham mau toi tu bien global moi.
- Khong dong vao cau truc HTML, JS, hay bat ky route/form action nao (`/dangnhap`, `/dangky`,
  `/dangky-shop`, `/dangky-shipper`) — chi doi CSS mau sac. Khong dong vao Servlet/DAO/Model.

## 52. Them anh that vao `index.jsp` thay cho emoji placeholder

- User cung cap 2 anh mon an (burger va pizza chup theo phong cach "food photography" bay lo lung
  nen toi) qua chat; tim thay file goc trung ten tai `Downloads/landing page/assets/burger_hero.png`
  va `pizza_dish.png` (trung khop voi ten file duoc tham chieu trong HTML mau ban dau nguoi dung
  gui o muc 50) — da copy vao `src/main/web/assets/img/burger_hero.png` va
  `src/main/web/assets/img/pizza_dish.png`.
- Thay 4 cho dung emoji placeholder trong `index.jsp` bang `<img>` that:
  - Hero section: span `.hero-emoji` (🍔) -> `<img class="hero-food-img">` dung `burger_hero.png`,
    van giu animation `float` va `drop-shadow` cu.
  - The mon "Double Cheeseburger" trong Popular Menu: `.emoji-img` (🍔) -> `<img>` dung
    `burger_hero.png` (CSS `.card-img-wrapper img` co san da xu ly `object-fit: cover`).
  - The mon "Pizza Pepperoni (L)": `.emoji-img` (🍕) -> `<img>` dung `pizza_dish.png`.
  - Man hinh mockup dien thoai trong section App: `.phone-emoji-box` tu hien thi emoji font-size
    sang chua `<img>` dung `pizza_dish.png` (them CSS `.phone-emoji-box img { object-fit: cover }`
    va bo `font-size`, giu nguyen gradient nen lam khung anh).
  - The mon "Set Sushi Thuong Hang" van giu emoji 🍣 vi khong co anh that duoc cung cap.
- Khong dong vao CSS mau sac/bo cuc da lam o muc 50-51, khong dong vao Servlet/DAO/Model.

## 53. Fix loi khong chon duoc topping trong modal them vao gio hang (`menuShop.jsp`)

- **Nguyen nhan**: modal them mon truoc do chi render topping duoi dang `<div>` tinh (ten +
  gia), khong co input nao — kem dong chu "* Lien he shop de chon topping khi dat hang". Trong
  khi backend (`UserCartServlet.doPost` o `/user/add-to-cart`) **da san sang** nhan
  `toppingId[]`/`toppingQty[]` va luu qua `CartItemToppingDAO.create(...)`, cung nhu
  `UserCartViewServlet` da co san flow sua topping trong gio hang — chi thieu UI chon topping o
  buoc them vao gio.
- **Da sua**: doi moi topping thanh `<label class="topping-item">` bao mot
  `<input type="checkbox" name="toppingId" value="${t.id}" data-price="${t.price}">` + mot
  `<input type="hidden" name="toppingQty" disabled>` rieng (chi enable khi checkbox duoc check,
  de dam bao 2 mang `toppingId[]`/`toppingQty[]` submit dung thu tu khop nhau — checkbox khong
  check thi khong submit, hidden qty disabled cung khong submit). Moi topping co bo dem so luong
  rieng (nut `−`/`+`, ham `changeToppingQty(toppingId, delta)`, gioi han 1-99) chi hien khi da
  chon. Them JS `toggleTopping(checkbox, toppingId)` cap nhat object `selectedToppings` va
  `updateTotal()` de cong them `sum(gia topping * so luong topping)` vao "Tam tinh" — cong thuc
  nay khop chinh xac voi cach `UserCartViewServlet` tinh `lineTotal = size.price * qty +
  toppingTotal` (gia topping KHONG nhan voi so luong mon chinh, vi `CartItemTopping.quantity` la
  so luong doc lap theo dung schema DB).
- **Reset trang thai moi lan mo modal**: vi cac checkbox topping dung chung DOM cho moi san pham
  (khong render lai theo tung mon), `openModal()` duoc them doan reset: bo check toan bo
  checkbox, an bo dem so luong, disable lai hidden qty input — tranh tinh trang chon topping o
  mon A roi mo mon B van con giu trang thai da chon.
- **Gioi han da biet (khong thuoc pham vi fix nay)**: `UserCartServlet` chi luu topping khi TAO
  MOI cart item; neu nguoi dung them lai dung san pham+size da co trong gio (chi tang so luong
  qua `cartItemDAO.incrementQuantity`), topping moi chon o lan sau se bi bo qua — day la hanh vi
  co san cua backend tu truoc, khong lien quan bug UI vua sua, muon sua topping cua item da co
  trong gio phai vao trang gio hang (`/cart-items`, co flow sua topping rieng trong
  `UserCartViewServlet`).
- Khong dong vao Servlet/DAO/Model (backend da du field can thiet tu truoc).
=======
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

## 25c. Them tinh khoang cach va ETA vao ban do theo doi shipper realtime

Endpoint: khong co endpoint moi, chi sua file JS dung chung `assets/js/orderTrackingMap.js` (dung
o `user/donhang.jsp`, xem muc 25).

Phan con thieu so voi yeu cau ban dau (tinh khoang cach Shop/Shipper/Khach + ETA) — da bo sung
hoan toan o phia client (khong sua backend/DAO/WebSocket):

- `src/main/web/assets/js/orderTrackingMap.js`:
  - `trackingHaversineKm(lat1, lng1, lat2, lng2)` (moi) — cong thuc Haversine tinh khoang cach
    duong chim bay giua 2 toa do (km), tra `null` neu thieu toa do nao.
  - `trackingFormatDistance(km)` / `trackingFormatEta(km)` (moi) — format hien thi (m neu < 1km,
    km 1 chu so thap phan neu >= 1km; ETA = `khoang_cach / 30 km/h` lam tron phut, toi thieu 1 phut).
  - Trong `initOrderTrackingMap(...)`: them 1 `<div class="tracking-distance-info">` chen ngay
    duoi ban do, ham `updateInfoPanel(shipperLat, shipperLng)` hien:
    - `🏪→🏠` (Shop → diem giao): tinh 1 lan luc mo ban do, luon hien neu co du toa do shop+diem giao.
    - `🏪→🛵` (Shop → Shipper) va `🛵→🏠` (Shipper → diem giao) kem `(ETA ~x phut)`: chi hien sau
      khi nhan duoc it nhat 1 vi tri shipper qua WebSocket, cap nhat lai moi lan `message` (moi
      lan shipper gui GPS moi).

Ghi chu:

- Khoang cach la duong chim bay (Haversine), khong phai khoang cach thuc te theo duong di (khong
  dung routing API nao, dung dung tinh chat "mien phi, khong can Google Maps" cua yeu cau ban dau).
- Toc do trung binh gia dinh co dinh 30 km/h de tinh ETA (giong vi du trong yeu cau), khong doi
  theo dieu kien giao thong thuc te.
- Khong sua `TrackingEndpoint.java`/backend — toan bo tinh toan o client tu du lieu da co san
  (toa do shop/diem giao da truyen san, toa do shipper nhan qua WebSocket).

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

Da compile lai toan bo `src/main/java` bang `javac`, khong loi (chi sua JSP).

## 29. Fix marker shop khong hien trong modal ban do cua Quanlybill.jsp (shop)

**Trieu chung:** Bam nut 📍 tren 1 dong don hang o `shop/Quanlybill.jsp`, modal chi thay 1 marker
(diem giao), khong thay marker rieng cho vi tri shop.

**Nguyen nhan (2 phan):**
1. **Loi code that su:** marker shop dung sai icon — `L.divIcon({ html: '🏠', ... })` dung emoji
   🏠 (nha), trung voi y nghia "🏠 Diem giao" da dung o noi khac trong app (`orderTrackingMap.js`),
   gay nham lan/kho phan biet 2 marker. Ngoai ra khong co CSS rieng cho class `shop-marker-icon`,
   nen Leaflet ap dung CSS mac dinh cho `divIcon` (nen trang + vien), co the bi mo/khuat tren nen
   ban do sang mau.
2. **Dieu kien du lieu:** marker shop CHI hien khi `currentShop.locationX`/`locationY` (lay tu
   session, gan trong `ShopBillServlet`) khac null — neu shop chua bao gio bam "💾 Luu thay doi"
   tren `Shopprofile.jsp` sau khi chon vi tri tren ban do (chi keo/click pin ma khong submit form),
   toa do se khong duoc luu vao DB va marker se khong bao gio hien, du code khong loi.

**Da sua:**
- `src/main/web/shop/Quanlybill.jsp` (ham `openOrderMapModal`):
  - Doi icon shop tu `🏠` sang `🏪` (dung voi quy uoc `orderTrackingMap.js` da dung: 🏪 = cua
    hang, 🏠 = diem giao), them `iconAnchor:[12,12]` de can giua dung.
  - Them `bindPopup('🏠 Điểm giao')` cho marker diem giao va `bindPopup('🏪 Cửa hàng')` cho marker
    shop de nguoi dung phan biet ro khi bam vao tung marker.
  - Them CSS `.shop-marker-icon{background:none;border:none;font-size:22px;...}` de override CSS
    mac dinh cua Leaflet divIcon, dam bao icon 🏪 hien ro rang, khong bi nen/vien che.
  - Them `console.warn(...)` khi shop chua co toa do, giup debug nhanh neu marker khong hien.

**Luu y cho nguoi dung:** neu sau khi sua van khong thay marker shop, kiem tra lai
`shop/Shopprofile.jsp` — phai chon vi tri tren ban do VA bam nut "💾 Lưu thay đổi" thi toa do moi
duoc luu vao DB (chi mo ban do chon pin ma khong submit form se khong luu gi ca).

Da compile lai toan bo `src/main/java` bang `javac`, khong loi (chi sua JSP).

## 30. Thay popup xac nhan cua trinh duyet (window.confirm) bang modal tuy chinh khi shipper nhan don

**Trieu chung:** Tren `shipper/nhan-don`, khi bam nut "✅ Nhận đơn này", trinh duyet hien popup
native `window.confirm()` ("localhost:8080 says — Xác nhận nhận đơn #16?") — khong dong bo giao
dien voi phan con lai cua app va bi cam dung theo yeu cau cua nguoi dung.

**Nguyen nhan:** nut submit dung truc tiep `onclick="return confirm('Xác nhận nhận đơn #${order.id}?')"`
de chan submit form neu nguoi dung bam Cancel — day la popup mac dinh cua trinh duyet, khong the
tuy chinh style/theme.

**Da sua:**
- `src/main/web/shipper/nhanDon.jsp`:
  - Them CSS `.confirm-modal-backdrop` / `.confirm-modal` / `.confirm-icon` / `.confirm-title` /
    `.confirm-desc` / `.confirm-btns` / `.confirm-btn*` — tai su dung dung pattern da co san trong
    `shipper/trangchucuashipper.jsp` (dam bao dong bo giao dien, dung bien CSS theme
    `--bg-card`/`--border-color`/`--text-main`/`--text-muted`/`--primary`).
  - Them 1 modal dung chung `#confirmAcceptOrderModal` (icon ✅, tieu de "Xác nhận nhận đơn?",
    hien `#<orderId>` dong), 2 nut Huỷ/Nhận đơn.
  - Doi nut submit tren moi don thanh `type="button"`, form them `id="acceptOrderForm${order.id}"`,
    bo `onclick="return confirm(...)"`, thay bang `onclick="openAcceptOrderConfirm(formId, orderId)"`.
  - Them JS: `openAcceptOrderConfirm(formId, orderId)` luu form dang cho + hien orderId trong
    modal roi mo modal; `doAcceptOrderConfirm()` dong modal va submit form da luu; `openConfirm`/
    `closeConfirm` toggle class `.active` — giong het logic da dung trong `trangchucuashipper.jsp`.
  - Nut toggle Online/Offline (dong 164, dung `confirm()` rieng) KHONG bi dong den — nam ngoai
    pham vi yeu cau lan nay (chi "Nhận đơn này" duoc de cap trong screenshot/yeu cau cua nguoi dung).

Da compile lai toan bo `src/main/java` bang `javac -encoding UTF-8`, khong loi (chi sua JSP).

## 31. Fix marker shop va diem giao giong het nhau tren ban do theo doi realtime cua khach hang (donhang.jsp)

**Trieu chung:** Tren `user/donhang.jsp`, ban do theo doi don hang (WebSocket realtime) hien 2
marker (shop va diem giao) nhung ca 2 deu la pin xanh mac dinh cua Leaflet, giong het nhau, khong
phan biet duoc dau la shop dau la diem giao — trong khi `shop/Quanlybill.jsp` da duoc sua o
`## 29` de dung icon 🏪 rieng cho shop thi file JS dung chung `orderTrackingMap.js` van con dung
`L.marker` mac dinh cho ca 2.

**Nguyen nhan:** `assets/js/orderTrackingMap.js` (dung chung boi ca `donhang.jsp` va cac trang
khac dung tracking map) tao `shopMarker` bang `L.marker([shopLat, shopLng])` khong truyen icon
tuy chinh, nen Leaflet dung pin xanh mac dinh — giong het pin xanh mac dinh cua `destMarker`.

**Da sua:**
- `src/main/web/assets/js/orderTrackingMap.js`: doi `shopMarker` sang dung `L.divIcon({html:'🏪',
  iconSize:[24,24], iconAnchor:[12,12], className:'shop-marker-icon'})`, dong bo voi cach lam da
  dung trong `Quanlybill.jsp` (🏪 = shop, 🏠 = diem giao/destination pin mac dinh giu nguyen).
- `src/main/web/user/donhang.jsp`: them CSS `.shop-marker-icon{background:none;border:none;
  font-size:22px;...}` vao `<style>` cua trang de override CSS mac dinh cua Leaflet divIcon (neu
  khong co CSS nay, icon 🏪 se bi nen trang/vien cua Leaflet che mo).

Day la thay doi thuan JS/JSP (khong dung Java), khong can compile lai `javac`.

## 32. Ha trong nguy co icon shop/shipper bi ghim xanh mac dinh cua khach hang de len khi toa do o gan nhau

**Boi canh:** nguoi dung nghi ngo khi dua toa do Shop/Shipper ve gan Khach hang (vai km, thay vi
fake xa 1500km) thi icon 🏪/🛵 se "tu dong bien thanh ghim xanh mac dinh" va nghi do 2 nguyen nhan:
(1) luc cap nhat WebSocket tao lai marker moi quen truyen `icon`, (2) icon bi ghi de/nham lan giua
cac object khi toa do gan nhau.

**Kiem tra code (`assets/js/orderTrackingMap.js`):** ca 2 gia thuyet tren KHONG dung voi code hien
tai — `shipperMarker` chi duoc tao 1 lan duy nhat (co truyen `icon` ro rang), moi lan nhan message
WebSocket sau do chi goi `shipperMarker.setLatLng(latlng)` (khong tao lai marker), dung y nhu de
xuat cua nguoi dung. `shopMarker`/`destMarker` cung moi object mot icon rieng, khong bi ghi de.

**Nguy co thuc su tim thay:** Leaflet tu dong sap xep z-order marker theo vi do (marker o phia
nam hon se ve len tren). Ghim mac dinh cua `destMarker` (25x41px + shadow) lon hon nhieu so voi
divIcon 24x24 cua shop/shipper — neu shop/shipper nam phia bac diem giao (rat co the xay ra khi
toa do o gan nhau, tuy khu vuc), ghim mac dinh co the de len va che khuat icon nho hon, tao cam
giac "icon bien mat, chi con lai ghim xanh mac dinh".

**Da sua (phong ngua):** `src/main/web/assets/js/orderTrackingMap.js`:
- Them `zIndexOffset: 1000` cho `shopMarker` va `zIndexOffset: 2000` cho `shipperMarker`, dam bao
  2 icon nay LUON ve tren `destMarker` (offset mac dinh = 0) bat ke vi do tuong doi giua cac diem.
- Sua icon shipper dung them `className: 'shop-marker-icon'` (class CSS bare-emoji da dung chung
  toan bo project) + `iconAnchor: [12, 12]` de can giua chinh xac, thay vi de trong className/
  khong co iconAnchor nhu truoc.

**Luu y cho nguoi dung:** toa do Shop la du lieu luu trong DB qua `shop/Shopprofile.jsp` (chon
pin tren ban do + bam "💾 Lưu thay đổi"); toa do Shipper la GPS thuc te gui lien tuc qua
WebSocket tu trinh duyet cua shipper (`navigator.geolocation`), khong phai gia tri fake luu san
trong code — muon test toa do gan Long Bien can: (1) doi vi tri Shop qua UI Shopprofile, (2) gia
lap GPS trinh duyet shipper (vd Chrome DevTools > Sensors > Location) roi thu lai.

Day la thay doi thuan JS (khong dung Java), khong can compile lai `javac`.

## 33. Gom cac file JSP theo role (admin/shop/shipper/user) dang nam roi rac o web root

**Trieu chung:** `src/main/web/` co san 4 thu muc role (`admin/`, `shop/`, `shipper/`, `user/`)
nhung van con ~28 file JSP nam truc tiep o root, phan lon chi phuc vu dung 1 role (chi duoc
forward toi boi dung 1 servlet co check quyen role do). Nguoi dung phan anh de nam o ngoai thi
"roi", kho quan ly.

**Nguyen nhan:** cac file nay duoc them dan trong qua trinh phat trien nhung chua duoc don vao
dung thu muc role tu dau.

**Da sua:** di chuyen (git mv, giu lich su) 12 file JSP vao dung thu muc role, cap nhat hang so
forward path (VIEW/LIST_VIEW/FORM_VIEW/REVIEW_VIEW/FAILED_VIEW) trong tung servlet tuong ung —
chi doi string literal, KHONG doi bat ky `@WebServlet` urlPattern nao nen URL nguoi dung
go/bookmark khong doi:

- `admin/`: `quanlitaikhoan.jsp` (ghi de len file `admin/quanlitaikhoan.jsp` cu — file cu la dead
  code, khong servlet nao tham chieu) — sua `QuanLiTaiKhoanServlet.java` (`VIEW`).
- `shop/`: `quanLyCuaHang.jsp`, `registerShop.jsp`, `shopChoDuyet.jsp`, `shopDangKyThongTin.jsp`,
  `shopDanhSach.jsp`, `shopThemSua.jsp`, `shopTuChoi.jsp`, `taoCategory.jsp`, `taoProduct.jsp` —
  sua `DangKyShopServlet.java`, `ShopHomeServlet.java`, `ShopServlet.java`, `CategoryServlet.java`,
  `ProductServlet.java`.
- `shipper/`: `registerShipper.jsp` — sua `Dangkyshipperservlet.java` (`VIEW`).
- `user/`: `DanhSachGioHang.jsp`, `cartItemDanhSach.jsp`, `cartItemThemSua.jsp`,
  `checkoutThanhToan.jsp`, `hoaDon.jsp`, `orderDanhSach.jsp`, `orderDetailDanhSach.jsp`,
  `orderDetailThemSua.jsp`, `orderThemSua.jsp`, `thanhToanThatBai.jsp`, `themSuaGioHang.jsp` —
  sua `CartServlet.java`, `CartItemServlet.java`, `CheckoutServlet.java`, `BillServlet.java`,
  `OrderServlet.java`, `OrderDetailServlet.java`, `PayOSReturnServlet.java`.

Xoa han 2 file mo coi (khong servlet/JSP nao tham chieu, da bi thay the boi ban khac): `shopTrangChu.jsp`
(da bi thay boi `shop/trangcuahang.jsp`) va `quanLyGioHang.jsp`.

Cac file dung chung nhieu role / truoc dang nhap giu nguyen o root, khong di chuyen: `DangNhap.jsp`,
`index.jsp`, `nhapOTP.jsp`, `quenmatkhau.jsp`, `register.jsp` — dung dung boi `AppFilter.java`
whitelist va nhieu servlet dang nhap/dang ky/quen mat khau.

`<jsp:include page="quanLyCuaHang.jsp" />` trong `shopDanhSach.jsp`/`shopThemSua.jsp` la include
tuong doi (khong co `/` dau) nen khi ca 3 file di chuyen cung luc vao `shop/`, include nay khong
can sua gi. Cac `<a href>`/`<form action>` deu dung path tuong doi toi URL servlet hoac
`${pageContext.request.contextPath}`, duoc trinh duyet phan giai theo URL pattern (khong phai vi
tri file vat ly) nen khong bi anh huong. `AppFilter.java`/`AuthFilter.java` khong can sua vi chi
tham chieu cac file SHARED con lai o root.

Da bien dich sach: `javac -encoding UTF-8 -cp "$CP" -d out $(find src/main/java -name "*.java")`
khong loi. Da grep lai toan bo `src/main/java` va `src` xac nhan khong con path nao tro sai vao
12 file da move hoac 2 file da xoa.

## 34. ShipperFeedbackServlet forward toi file JSP khong ton tai + thong bao loi khong hien

**Trieu chung:** khi shipper bam danh gia mot don khong du dieu kien (khong co quyen danh gia,
hoac da danh gia roi), trang bao loi 500. Phat hien trong luc soat lai toan bo project truoc khi
nguoi dung commit (theo yeu cau "kiem lai project co bug hay loi logic gi khong").

**Nguyen nhan:** `ShipperFeedbackServlet.java` (doGet, 2 cho) forward toi
`/shipper/donhang.jsp` — file nay chua bao gio ton tai trong git history (bug co san, khong lien
quan den viec gom JSP o muc 33). Ngoai ra, ngay ca truoc khi forward loi, code dung
`req.setAttribute("loi", "...")` nhung `shipper/danhGia.jsp` khong he doc attribute `loi` o bat
ky dau nao — trang chi doc query-param `${param.error eq '...'}` (dung cho case offline) — nen
du co forward dung file, thong bao loi cu the van se khong hien thi cho shipper thay.

**Da sua:** `ShipperFeedbackServlet.java` (doGet) — doi ca 2 nhanh loi tu
`setAttribute("loi", ...) + getRequestDispatcher(...).forward(...)` sang
`sendRedirect(req.getContextPath() + "/shipper/danh-gia?error=<gia_tri>")`, dung dung pattern
`?error=offline` da co san trong chinh file nay:
- Khong co quyen danh gia don nay → `?error=noquyen`
- Da danh gia don nay roi → `?error=dadanhgia`

`shipper/danhGia.jsp` — them 2 khoi `<c:if test="${param.error eq 'noquyen'}">` va
`<c:if test="${param.error eq 'dadanhgia'}">`, style dong bo voi khoi `error eq 'offline'` co
san (cung mau canh bao do, cung border/padding), hien dung 2 thong bao truoc do bi mat:
"Bạn không có quyền đánh giá đơn hàng này!" va "Bạn đã đánh giá shop này cho đơn hàng này rồi!".

Da bien dich sach: `javac -encoding UTF-8 -cp "$CP" -d out $(find src/main/java -name "*.java")`
khong loi. Da ra soat lai toan bo `getRequestDispatcher(...)` trong project, xac nhan khong con
forward path nao tro toi file khong ton tai tren dia.

## 35. Bo sung try/catch cho cac tham so id/orderId/rating parse tu request (tranh 500 loi)

**Trieu chung:** phat hien trong luc soat lai toan bo project truoc khi commit (dispatch subagent
kiem tra compile, forward path, SQL injection, resource leak, unsafe parsing, null pointer).

**Nguyen nhan:**
- `ShipperFeedbackServlet.java` (`doPost`) parse `orderId`/`rating` bang `Long.parseLong`/
  `Integer.parseInt` truc tiep, khong co try/catch — form bi gui thieu/sai du lieu se nem
  `NumberFormatException` khong duoc bat, ra loi 500 thay vi redirect nhe nhang. File
  `FeedbackServlet.java` (tuong tu, ben user) da co san try/catch cho dung case nay, servlet ben
  shipper bi thieu.
- `ShopServlet.java` (`showEditForm`, `updateShop`, `deleteShop`) parse `Long.parseLong(request.
  getParameter("id"))` khong guard — loi van bi bat boi catch chung o `doGet` nhung van la loi
  500 trang container thay vi thong bao "khong tim thay" nhu quy uoc san co (`shops?error=
  notfound`) trong 2 ham dau.

**Da sua:**
- `ShipperFeedbackServlet.java` (`doPost`) — boc `orderId`/`rating` trong try/catch
  `NumberFormatException`, redirect ve `/shipper/danh-gia` khi loi, dung pattern giong
  `FeedbackServlet.java`.
- `ShopServlet.java` — ca 3 ham `showEditForm`, `updateShop`, `deleteShop` deu boc
  `Long.parseLong(request.getParameter("id"))` trong try/catch, redirect ve `shops?error=
  notfound` khi loi — dong bo voi quy uoc "not found" da dung san trong file.

Da bien dich sach: `javac -encoding UTF-8 -cp "$CP" -d out $(find src/main/java -name "*.java")`
khong loi.

## 35. Dong bo giao dien dang ky Shop/Shipper theo dang ky User

**Yeu cau:** "Trong dang ky Shop va Shipper nen dong bo lai voi dang ky User" — trang dang ky
Shop (`shop/registerShop.jsp`) va Shipper (`shipper/registerShipper.jsp`) truoc do dung layout
rieng (background gradient don, input khong style, font Arial), khong dong bo voi trang dang ky
User (`register.jsp`) da co san design system 2 cot (`.form-panel` + `.deco-panel`) voi Inter
font, input co icon SVG, nut show/hide password.

**Da sua:** viet lai hoan toan 2 file `shop/registerShop.jsp` va `shipper/registerShipper.jsp`
theo dung cau truc CSS/HTML cua `register.jsp` (giu nguyen convention scriptlet-based, KHONG
dung `<c:if>` vi 2 file nay khong khai bao taglib `c`):

- `shop/registerShop.jsp`: giu nguyen field (fullname, phone, username, email, password,
  confirm_password) va form action `/dangky-shop`; doi mau accent sang teal (`#0f766e`) dong bo
  voi thuong hieu Shop cu; nut `.role-btn-row` link sang `/dangky` va `/dangky-shipper`.
- `shipper/registerShipper.jsp`: giu nguyen hidden field `role_id=4`, select
  `shipper_region` (2 option `KV_TRUNG_TAM`/`KV_NGOAI_THANH`), pattern SDT
  `[0-9]{10,11}`, `minlength="6"` cho password, form action `/dangky-shipper`; doi mau accent
  sang xanh la dam (`#2d6a4f`/`#1b4332`) dong bo voi thuong hieu Shipper cu; nut `.role-btn-row`
  link sang `/dangky` va `/dangky-shop`.

Ca 2 file deu dung khoi hien thi loi scriptlet giong `register.jsp`:
`<% if (request.getAttribute("loi") != null && !((String)request.getAttribute("loi")).isEmpty()) { %>`
... `<%= request.getAttribute("loi") %>` ... `<% } %>` — khong dung JSTL vi khong co taglib.

Khong doi servlet nao (`DangKyShopServlet.java`, `Dangkyshipperservlet.java`), khong doi ten
field input nen logic xu ly form giu nguyen 100%.

## 36. Nang cap tham my giao dien dang ky Shop/Shipper (UI polish pass)

**Yeu cau:** "dua tren giao dien hien tai cua user hay thiet ke lai cho dep hon" — dung
skill `ui-ux-pro-max` de danh gia lai 2 trang `shop/registerShop.jsp` va
`shipper/registerShipper.jsp` (da co design system 2 cot tu muc 35) va nang cap them phan
tham my/UX ma khong dong den field/servlet.

**Da sua o ca 2 file** (giu nguyen mau accent rieng: teal `#0f766e` cho Shop, xanh la dam
`#2d6a4f`/`#1b4332` cho Shipper):

- Icon input doi mau theo accent khi focus: them `.field-wrap:focus-within .field-icon-left`
  (truoc do icon luon mau xam, khong phan hoi trang thai focus).
- Nut submit (`.btn-primary`) them icon mui ten SVG, truot sang phai 3px khi hover
  (`transform: translateX(3px)` tren `svg` con).
- Thay emoji `👤`/`🏪`/`🛵` trong `.role-btn-row` bang icon SVG stroke dong bo voi cac icon
  input khac (theo guideline `no-emoji-icons` cua ui-ux-pro-max) — `role-btn` doi tu
  `display:block` sang `display:flex` de can icon + text.
- `.deco-panel`: them lop `background-image` dang luoi cham (dot-grid, 20x20px, opacity thap)
  chong len gradient cu de tang chieu sau; tang nhe opacity 2 vong tron trang tri
  (`::before`/`::after`) cho ro net hon.
- Them `.stats-row` (3 stat: Tai xe/Don-ngay/Danh gia cho Shipper; Cua hang/Khach hang/Ho tro
  cho Shop) duoi `.deco-desc` de tang do tin cay (social proof), truoc khi vao `.step-list`.
- `.step-item`: them duong noi doc (`::after` pseudo-element) giua cac buoc lien tiep de tao
  cam giac "timeline" ro rang hon thay vi 3 the roi rac.

Khong doi bat ky attribute `name`, `id`, `value` nao cua input/select, khong doi form
`action`/`method`, khong doi servlet — chi la CSS/markup trang tri them, logic xu ly form giu
nguyen 100%. Khong co dev server preview san (project Java/Tomcat, khong co `.claude/launch.json`)
va Browser tool khong cho phep `file://`, nen doi chieu bang cach doc lai CSS/HTML sau khi sua
thay vi render truc tiep trong trinh duyet.

## 37. Redesign toan bo giao dien vai tro User theo Tier-A design system (skill ui-ux-pro-max)

**Yeu cau:** "dua tren giao dien hien tai cua user hay thiet ke lai cho dep hon" — dung skill
`ui-ux-pro-max`, chon ca 4 pham vi: Trang chu User, Trang shop/menu mon an, Gio hang & thanh
toan, Trang ca nhan/don hang. Ap dung dong bo "Tier-A" design system (Inter font, nen
`#f0f4f8`, navbar trang sticky, badge logo gradient dark-navy, nut CTA gradient xanh la
`#10b981→#059669`, header/hero gradient toi `#1a2035→#0f1624` co blob trang tri, card bo
tron 16-20px) cho toan bo trang thuoc vai tro User, va thay het icon emoji bang SVG icon
inline (theo guideline `no-emoji-icons` + `icon-style-consistent` cua ui-ux-pro-max, muc 4 —
uu tien HIGH).

**Cac file da sua** (tat ca deu trong `src/main/web/user/`):

- `gioHang.jsp`, `donhang.jsp`, `menuShop.jsp`, `trangnguoidung.jsp` — chuyen day du sang
  Tier-A + SVG icon.
- `diaChi.jsp` — thay toan bo emoji (navbar, 5 alert, empty-state, badge mac dinh, nhan dia
  chi Nha/Cong ty/Truong hoc, thong tin nguoi nhan, cac nut sua/xoa/mac dinh, tieu de modal,
  nut chon vi tri tren ban do, icon xac nhan xoa) bang SVG icon moi ve (home, office,
  graduation-cap, person, phone, trash, plus, pencil, star, map-pin...). Rieng emoji trong
  `<select><option>` (🏠/🏢/🎓/📍) duoc bo hoan toan (chi con text) vi the `<option>` native
  khong render duoc SVG ben trong — ngoai le hop ly cua rule `no-emoji-icons`. Nhan tien fix
  loi thieu 2 tham so `locationX`, `locationY` trong loi goi ham `openEdit(...)` (cac bien nay
  da duoc dung trong than ham nhung chua duoc truyen vao, khien hidden input toa do khi sua
  dia chi luon rong).
- `checkoutThanhToan.jsp` — nang cap CSS input/nut tu kieu flat cu (border xam, bo tron 5px)
  len chuan Tier-A (border 1.5px `#e2e8f0`, bo tron 10px, nut CTA gradient xanh la co
  box-shadow, hover nang len), dong thoi thay het emoji (navbar, alert loi, tieu de gio hang,
  ten shop, tieu de dia chi nhan, nut chon ban do, nut xac nhan thanh toan) bang SVG icon.
  Phan JS Leaflet/Nominatim (`initCheckoutLocationMap`, `toggleCheckoutLocationMap`) giu
  nguyen 100% khong dong den.
- `hoaDon.jsp` — file nay da co san CSS Tier-A (bill-card, header gradient toi...) tu truoc,
  chi can thay emoji: navbar (📦), alert thanh cong (🎉), tieu de hoa don (🧾), nut in (🖨️),
  nut ve don hang (📦), icon empty-state (🧾) — tat ca chuyen sang SVG (package, checkmark,
  receipt, printer). Bullet `●` trong status-badge khong phai emoji nen giu nguyen.
- `thanhToanThatBai.jsp` — viet lai toan bo tu giao dien Tier-C cu (Segoe UI, nen `#f0f2f5`,
  bo tron 5-10px, khong co gradient) sang Tier-A day du (card bo tron 20px, icon-wrap tron
  chua SVG X-circle mau do, nut CTA gradient xanh la). Giu nguyen 100% binding `${loi}`,
  `${order.id}` va link `/cart`.

**Kho khan da xu ly:** lan dau sua `diaChi.jsp` bi loi Edit "String to replace not found" vi
`old_string` thieu mot khoi `<label>`+`<textarea>` "Dia chi day du" nam xen giua `<select>` va
nut chon ban do trong file thuc te — sua bang cach `Grep -C 3` + `Read` doan chinh xac roi
Edit lai voi `old_string` day du, thanh cong ngay lan thu 2.

Khong co dev server preview cho project Java/Tomcat nay (khong co `.claude/launch.json`), nen
kiem tra bang cach doc lai HTML/CSS sau khi sua thay vi render truc tiep trong trinh duyet.
Chua chay build/compile de kiem tra cu phap JSP cho cac file da sua trong tac vu nay.

## Chuan hoa hien thi ngay gio (DateUtil + EL function)

Them 2 file moi:
- `src/main/java/org/example/utils/DateUtil.java` — 2 static method: `format(Object)` tra
  ve `dd/MM/yyyy HH:mm`, `formatDate(Object)` tra ve `dd/MM/yyyy`. Xu ly null, LocalDateTime,
  LocalDate, java.sql.Timestamp, java.util.Date, fallback toString() cho kieu khac.
- `src/main/web/WEB-INF/functions.tld` — EL function library uri `/app-functions`, khai bao
  2 ham: `app:formatDateTime(obj)` -> DateUtil.format, `app:formatDate(obj)` -> DateUtil.formatDate.

Da them taglib `<%@ taglib uri="/app-functions" prefix="app" %>` va thay bieu thuc ngay gio
tho (Timestamp/LocalDateTime in truc tiep, hoac ghep chuoi thu cong bang fn:substring /
cac field dayOfMonth-monthValue-year-hour-minute) bang `${app:formatDateTime(...)}` (hoac
`app:formatDate` khi chi can ngay) trong cac file JSP sau:

- `admin/chiTietYeuCauShipper.jsp`, `admin/chiTietYeuCauShop.jsp`
- `user/DanhSachGioHang.jsp`, `user/themSuaGioHang.jsp` (input datetime-local), `user/orderThemSua.jsp` (input datetime-local)
- `shipper/chitietdonhang.jsp`, `shipper/dashboard.jsp`, `shipper/nhanDon.jsp`,
  `shipper/trangchucuashipper.jsp`, `shipper/thongbao.jsp`
- `admin/hoSoAdmin.jsp`, `admin/TongQuanHeThong.jsp`, `admin/yeuCauShipper.jsp`,
  `admin/yeuCauShop.jsp`, `admin/appeals.jsp` (gop 2 dong ngay+gio rieng thanh 1 dong
  `app:formatDateTime`)
- `shop/HoaDonShop.jsp`, `shop/trangcuahang.jsp`, `shop/shopThemSua.jsp` (input datetime-local),
  `shop/Quanlybill.jsp`, `shop/xemDanhGia.jsp` (2 vi tri), `shop/_invoiceModal.jspf` (them
  taglib truc tiep vao file .jspf vi no da san co cac taglib khac; file nay duoc
  `<%@ include %>` — static include — boi `shop/Quanlybill.jsp` va `shop/Banhang.jsp` nen
  khong can them taglib rieng o 2 file cha)
- `user/hoaDon.jsp` (gop 2 dong "gio" + "ngay/thang/nam" ghep thu cong bang fn:substring
  thanh 1 dong `app:formatDateTime`)

Luu y: input `type="datetime-local"` (themSuaGioHang.jsp, orderThemSua.jsp, shopThemSua.jsp)
sau khi doi sang dinh dang `dd/MM/yyyy HH:mm` se khong con dung chuan ISO
(`yyyy-MM-ddTHH:mm`) ma trinh duyet yeu cau cho input datetime-local, nen truong nay co the
khong tu dien gia tri cu vao form nua khi vao trang sua — can luu y kiem tra lai UI truong
hop nay.

Khong chay duoc `mvn compile` de kiem tra DateUtil.java (khong co `mvn` trong PATH cua moi
truong thuc thi lenh); ban than DateUtil.java don gian, chi dung API chuan JDK nen it rui ro
loi cu phap.

## 21. Popup thong bao (Toast) dung chung, tu doc query string success/error

Them moi `src/main/web/assets/js/toast.js` — component popup thong bao goc tren-phai man
hinh, tu doc `success`/`error` tren query string URL hien tai bang `URLSearchParams` va tu
hien popup, khong can them HTML/JS goi thu cong nao khac ngoai 1 the `<script>` include.

Da include `<script src="${pageContext.request.contextPath}/assets/js/toast.js"></script>`
(dung EL, dung quy uoc include JS tinh da co trong du an, vd `orderTrackingMap.js` o
`user/donhang.jsp`) ngay truoc `</body>` cua 28 file JSP co dung `${param.success}` hoac
`${param.error}`:

- Admin (5 file): `admin/appeals.jsp`, `admin/doiMatKhauAdmin.jsp`, `admin/hoSoAdmin.jsp`,
  `admin/quanlitaikhoan.jsp`, `admin/yeuCauShipper.jsp`.
- Shipper (5 file): `shipper/danhGia.jsp`, `shipper/doiMatKhauShipper.jsp`,
  `shipper/hoSoShipper.jsp`, `shipper/hosotaixe.jsp`, `shipper/nhanDon.jsp`.
- Shop (12 file): `shop/doiMatKhauShop.jsp`, `shop/hoSoShop.jsp`, `shop/Quanlybill.jsp`,
  `shop/Quanlyloaisanpham.jsp`, `shop/Quanlyloaitopping.jsp`, `shop/Quanlysanpham.jsp`,
  `shop/Quanlytopping.jsp`, `shop/Shopprofile.jsp`, `shop/taoCategory.jsp`,
  `shop/taoProduct.jsp`, `shop/ThungRacLoaiSanPham.jsp`, `shop/ThungRacLoaiTopping.jsp`,
  `shop/ThungRacSanPham.jsp`, `shop/ThungRacTopping.jsp`.
- User (6 file): `user/cartItemDanhSach.jsp`, `user/DanhSachGioHang.jsp`, `user/diaChi.jsp`,
  `user/donhang.jsp`, `user/orderDanhSach.jsp`, `user/orderDetailDanhSach.jsp`.

Khong xoa/sua HTML/banner thong bao cu nao dang co san trong cac file tren, chi them 1 dong
script. Da grep lai `param\.(success|error)` tren toan bo `src/main/web` va xac nhan khong
con file nao thieu include `toast.js`.

## 22. Bat dang nhap lai sau khi doi mat khau

Endpoint: `/admin/change-password`, `/shop/doi-mat-khau`, `/shipper/doi-mat-khau`

Truoc do doi mat khau xong chi redirect ve lai chinh trang doi mat khau voi `?success=1`,
session cu van con hieu luc. Da sua ca 3 servlet (`AdminChangePasswordServlet`,
`ShopDoiMatKhauServlet`, `ShipperDoiMatKhauServlet`): sau khi luu mat khau moi thanh cong,
goi `session.invalidate()` roi redirect sang `/dangnhap?success=password_changed` (buoc
dang nhap lai bang mat khau moi). Them ma `password_changed` vao bang dich cua
`assets/js/toast.js` (hien popup "Doi mat khau thanh cong! Vui long dang nhap lai."), va
them include `toast.js` vao `DangNhap.jsp` de popup hien duoc ngay tren trang dang nhap.

Ghi chu: Nguoi dung thuong (role user) hien chi co luong "Quen mat khau" qua OTP
(`QuenMatKhauServlet`), khong co man hinh doi mat khau khi da dang nhap, nen khong can sua.

## 23. Khach tu huy don sau 5 phut + he thong tu dong huy don sau 10 phut

Endpoint: `/user/donhang` (POST action=cancel), nen: `OrderAutoCancelListener`

- `OrderDAO`/`OrderDAOImpl`: them `cancelStalePendingOrders(int minutesThreshold)` — 1 cau
  UPDATE hang loat `SET status='CANCELLED' WHERE status='PENDING' AND created_at < DATEADD(minute, -N, GETDATE())`.
- `org/example/listener/OrderAutoCancelListener.java` (moi, `@WebListener`, khong can khai
  bao trong `web.xml` vi du an da dung annotation cho servlet) — dung
  `ScheduledExecutorService` (daemon thread), quet moi 60 giay, tu dong huy don PENDING qua
  10 phut chua duoc shop xu ly.
- `UserOrderServlet`: them `doPost` xu ly `action=cancel&orderId=` — kiem tra don thuoc dung
  user, con o trang thai PENDING va da qua 5 phut ke tu `createdAt` (`isCancelableNow()`) moi
  cho huy; doGet tinh san map `cancelable` (orderId -> boolean) truyen sang JSP.
- `user/donhang.jsp`: voi don `PENDING`, hien nut "Huy don hang" (form POST, confirm truoc
  khi submit) neu da qua 5 phut, nguoc lai hien ghi chu "Co the huy don sau 5 phut...".
- `assets/js/toast.js`: them ma `order_cancelled`, `not_found`, `cannot_cancel` vao bang dich
  popup thong bao.

Ghi chu: Nguong 5 phut (khach tu huy) va 10 phut (he thong tu huy) la 2 hang so rieng
(`CANCELABLE_AFTER_MINUTES` trong `UserOrderServlet`, `AUTO_CANCEL_AFTER_MINUTES` trong
`OrderAutoCancelListener`) — sua truc tiep trong code neu can doi nguong sau nay.

## 24. Shipper chup va luu anh giay to tuy than (CCCD/CMND)

Endpoint: `/shipper/upload-id-card`, trang `/shipper/profile` (`hosotaixe.jsp`)

- DB: them cot `id_card_image_url NVARCHAR(500) NULL` vao `Shipper_Profiles` —
  `migration_shipper_profiles.sql` (them nhanh ALTER cho DB da co san) va cap nhat
  `Database.md` (schema tao moi).
- `models/ShipperProfile.java`: them field `idCardImageUrl`.
- `daos/ShipperProfileDAO.java`/`ShipperProfileDAOImpl.java`: them
  `updateIdCardImageUrl(accountId, url)` (MERGE upsert rieng, khong dung chung voi
  `save()` vi anh duoc luu ngay sau khi upload, khong doi cung luc voi form thong tin xe).
- `controllers/ShipperIdCardUploadServlet.java` (moi, `@WebServlet("/shipper/upload-id-card")`)
  — nhan `imageUrl` (URL Cloudinary da upload tu client, giong pattern
  `ShipperAvatarUploadServlet`), validate `roleId == 4` va domain
  `https://res.cloudinary.com/` truoc khi luu.
- `shipper/hosotaixe.jsp`: them khoi UI trong the "🪪 Giấy tờ nghề nghiệp" — nut
  "📸 Chụp / Chọn ảnh CCCD" (`input type="file" accept="image/*" capture="environment"` —
  tren mobile se mo thang camera sau), thanh progress bar, va script rieng upload truc tiep
  len Cloudinary (cung cloud `jcnsb47f` + preset `avatar_preset`, folder `id_cards`) roi
  goi `/shipper/upload-id-card` de luu URL, cap nhat lai anh preview ngay khong can reload trang.

Ghi chu: Chi luu URL anh (khong ma hoa/an anh), giong cach du an dang luu avatar — phu hop
pham vi do an. Neu can bao mat hon (an che URL cong khai) thi phai doi sang upload qua server
+ luu file rieng, ngoai pham vi lan sua nay.

## 25. Cho phep ton kho "khong xac dinh / khong gioi han"

Endpoint: `/shop/products` (`Quanlysanpham.jsp`), `/product` (CRUD chung `taoProduct.jsp`)

Truoc do `Product.stockQuantity` la kieu `int` (luon co gia tri, mac dinh 0), khong the bieu
dien "chua biet ton kho bao nhieu". Cot DB `Products.stock_quantity` thuc te da la
`INT NULL DEFAULT 0` voi CHECK `stock_quantity >= 0` (CHECK cho qua gia tri NULL trong SQL
Server) nen khong can migrate DB, chi can sua code cho phep luu/doc NULL:

- `models/Product.java`: doi `stockQuantity` tu `int` sang `Integer` (null = khong xac
  dinh/khong gioi han).
- `daos/ProductDAOImpl.java`: `bindInsert`/`bindUpdate`/`createAndReturnId` dung
  `ps.setNull(Types.INTEGER)` khi `stockQuantity == null` thay vi ep ve 0; `mapProduct` giu
  nguyen gia tri NULL doc tu DB thay vi ep ve 0.
- `controllers/ShopProductServlet.java`: them `parseStockQuantity(req)` — tra ve `null` neu
  checkbox `stockUnknown` duoc tick hoac o nhap de trong; validate `< 0` chi khi khac null.
- `controllers/ProductServlet.java` (CRUD chung `/product`): `stock_quantity` de trong -> luu
  NULL thay vi mac dinh 0; sua `validateProduct` tranh NullPointerException khi so sanh `< 0`.
- `shop/Quanlysanpham.jsp`: o nhap "Số lượng tồn kho" them checkbox "Không xác định / không
  giới hạn tồn kho" (tick thi disable + xoa o nhap so, submit se gui `stockUnknown=on`); bang
  danh sach hien chu "Không xác định" (mau nhat) thay vi so 0 khi `stockQuantity` la null.
- `shop/taoProduct.jsp`: bang danh sach CRUD chung cung hien "Không xác định" khi null.

Ghi chu: San pham co ton kho NULL van ban binh thuong tren POS (`/shop/pos`) vi POS chi loc
theo `staTus` (ACTIVE/HIDDEN/OUT_OF_STOCK), khong doc `stockQuantity` — xem muc 18.

## 20. Upload anh san pham qua Cloudinary (Quan ly san pham)

Endpoint: `/shop/products`

Truoc do form them/sua san pham trong `Quanlysanpham.jsp` chi co 1 o nhap text "URL anh san
pham" de dan link tay, va gia tri nay **khong bao gio duoc luu xuong DB**: bang `Products` thuc
te khong co cot `image_url` (da ghi chu san trong `ProductDAOImpl` tu truoc, cac cau SQL insert/
update/select deu chu dong bo qua field `imageUrl` cua model). Anh san pham dung ra phai luu o
bang rieng `Product_Images` (`product_id`, `image_url`, `is_primary`, `sort_order`, unique index
chi cho 1 anh `is_primary=1` moi san pham — xem `Database.md` muc 12) nhung chua co DAO/servlet
nao dong toi bang nay.

Da them moi:

- `src/main/java/org/example/daos/ProductImageDAO.java` + `ProductImageDAOImpl.java` (moi) —
  thao tac bang `Product_Images`: `findPrimaryUrlByProductId`, `findPrimaryUrlsByProductIds`
  (lay hang loat cho trang danh sach, tranh N+1 query), `upsertPrimary` (xoa anh `is_primary=1`
  cu roi insert anh moi trong 1 transaction — moi san pham hien chi luu 1 anh dai dien).

Da sua:

- `src/main/java/org/example/controllers/ShopProductServlet.java`:
  - `createProduct`/`updateProduct`: sau khi tao/cap nhat san pham va luu size, neu form co
    `imageUrl` (khong rong) thi goi `productImageDAO.upsertPrimary(productId, imageUrl)`.
  - `doGet` (action=edit): sau khi lay san pham + size, goi them
    `productImageDAO.findPrimaryUrlByProductId(id)` de gan vao `product.imageUrl` cho modal Sua
    hien dung anh hien tai.
  - `forwardProductPage`: lay anh dai dien hang loat qua `findPrimaryUrlsByProductIds` roi gan
    vao tung `Product` truoc khi forward sang JSP (bang danh sach hien dung anh that thay vi
    luon rong).
- `src/main/web/shop/Quanlysanpham.jsp`: thay o nhap text "URL anh san pham" bang nut chon file
  ảnh (`<input type="file">`) upload thang len Cloudinary qua JS (dung chung cloud `jcnsb47f` +
  unsigned preset `avatar_preset` da dung cho avatar/CCCD, doi sang folder `products` — theo dung
  pattern da co san o `hoSoShop.jsp`/`hoSoShipper.jsp`/`hoSoAdmin.jsp`), co thanh tien trinh +
  thong bao trang thai. Upload xong JS tu dien URL tra ve (`secure_url`) vao 1 input an
  `imageUrl` (gia tri nay moi la cai duoc submit cung form Them/Sua san pham) va cap nhat preview
  ngay, khong doi HTML cua form Them/Sua (van 1 request POST duy nhat, khong them request rieng
  luu anh nhu avatar).

Chuc nang da co:

- Bam "Thêm sản phẩm mới" hoac "Sửa" mot san pham -> trong modal, bam chon file anh -> anh duoc
  upload len Cloudinary, hien preview ngay, luu vao `Product_Images` khi bam "Lưu"/"Thêm sản
  phẩm" cung luc voi cac truong khac cua san pham.
- Bang danh sach san pham hien dung anh dai dien da luu (thay vi luon hien icon 🍽️ mac dinh).

Han che/gia dinh da biet:

- Moi san pham hien chi ho tro 1 anh dai dien (`is_primary=1`), chua lam UI quan ly nhieu anh/
  sap xep `sort_order` du bang `Product_Images` co ho tro (ngoai pham vi yeu cau lan nay, chi can
  "them anh moi lan them/sua san pham").
- Da compile lai toan bo `src/main/java` bang `javac` (qua Bash, classpath tu `.m2`), khong loi.

Loi phat sinh khi test thuc te (khong lien quan Cloudinary, lo ra khi bam "Luu thay doi" sua san
pham da co don hang): `updateProduct` truoc do xoa het size cu (`productSizeDAO.deleteByProductId`)
roi tao lai toan bo tu form. Neu 1 size da tung duoc dat hang (`Order_Details.product_size_id` FK
toi `Product_Sizes`), cau `DELETE ... WHERE product_id = ?` vi pham `FK_Detail_Size` va that bai
**cho ca cau lenh** (khong xoa duoc size nao ca, kha ca cac size khong lien quan), nhung code
khong kiem tra gia tri tra ve nen van chay tiep vong lap tao size moi -> size cu (chua bi xoa) +
size moi trung ten -> vi pham `UNIQUE KEY UQ_Product_Size (product_id, size_name)`. Da sua: them
`ShopProductServlet.syncSizes(productId, shopId, newSizes)` thay the hoan toan logic xoa-het-tao-
lai — so khop theo ten size (khong phan biet hoa/thuong): size trung ten thi `update()` gia giu
nguyen `id` (khong pha FK), size moi thi `create()`, size cu khong con trong form thi `delete()`
tung id rieng (neu 1 size dang bi FK rang buoc thi rieng no that bai va bi bo qua, khong lam hong
ca request nhu truoc).

Sau khi shop upload duoc anh, phat hien them: cac trang **hien anh cho phia khac** (khach hang xem
menu shop, nhan vien Bam Bill) van chi hien icon mac dinh du JSP da san sang `${p.imageUrl}` —
vi cac servlet tuong ung chua bao gio goi `ProductImageDAO` (moi tao o tren, truoc gio chi
`ShopProductServlet` dung). Da sua them:

- `src/main/java/org/example/controllers/UserShopMenuServlet.java` (`/user/shop`, JSP
  `user/menuShop.jsp` — khach hang xem menu 1 shop): nap anh dai dien hang loat qua
  `productImageDAO.findPrimaryUrlsByProductIds` roi gan vao tung `Product` truoc khi forward.
- `src/main/java/org/example/controllers/ShopPosServlet.java` (`/shop/pos`, JSP
  `shop/Banhang.jsp` — nhan vien Bam Bill): tuong tu, nap anh dai dien cho danh sach san pham
  hien trong luoi chon mon.

Da compile lai toan bo `src/main/java` bang `javac`, khong loi.

## 21. Upload anh Logo shop qua Cloudinary (Thong tin cua hang)

Endpoint: `/shop/profile`

Khac voi anh san pham (muc 20), `shopLogo` da la cot that trong bang `Shops` va da duoc
`ShopProfileServlet`/`ShopDAOImpl` doc/ghi day du tu truoc — chi thieu UI upload thuc su, form
truoc do chi co 1 o nhap text de dan URL anh tay.

Da sua giao dien (khong doi backend):

- `src/main/web/shop/Shopprofile.jsp`: doi o nhap text `shopLogo` thanh input an (`type="hidden"`)
  + them nut chon file anh (`<input type="file" id="shopLogoFile">`), upload thang len Cloudinary
  qua JS (dung chung cloud `jcnsb47f` + unsigned preset `avatar_preset`, folder `shops` — cung
  pattern voi anh san pham/avatar), co thanh tien trinh + thong bao trang thai. Upload xong JS
  dien URL tra ve vao input an `shopLogo` (gia tri nay moi la cai duoc submit cung form) va goi
  lai ham `previewLogo()` co san de cap nhat khung xem truoc ben canh ngay lap tuc.

Chuc nang da co:

- Trong `/shop/profile`, bam chon file anh logo -> anh duoc upload len Cloudinary, hien preview
  ngay trong khung "Tổng quan" -> bam "Lưu thay đổi" se luu URL logo cung luc voi cac truong ho so
  khac cua shop (khong them request rieng).

Da compile lai toan bo `src/main/java` bang `javac` (khong co thay doi Java trong muc nay), khong loi.

## 22. Het han don hang qua ngay (Shipper khong the nhan don cua ngay hom truoc)

Endpoint: `/shipper/nhan-don`

Van de thuc te: don hang da duoc Shop xac nhan (`status = READY_FOR_PICKUP`) nhung chua co
Shipper nao nhan, neu de qua ngay hom sau van con hien trong danh sach "Don cho nhan" va Shipper
van bam nhan duoc — sai logic vi do an khong the giao qua ngay. Bang `Orders` khong co cot rieng
"order_date", ngay tao don la cot `created_at` (xem `Database.md` muc 16); cot `status` co
CHECK constraint chi cho phep `PENDING/CONFIRMED/READY_FOR_PICKUP/SHIPPING/DONE/CANCELLED` (khong
co `EXPIRED`), nen dung `CANCELLED` cho don het han.

Da sua:

- `src/main/java/org/example/daos/OrderDAOImpl.java` (`findAvailableOrders`, ham lay danh sach
  don cho Shipper nhan): them dieu kien
  `CAST(created_at AS DATE) = CAST(GETDATE() AS DATE)` vao cau SQL — chi tra ve don duoc tao
  DUNG NGAY HOM NAY, don cua ngay truoc du con `READY_FOR_PICKUP` va chua co shipper cung khong
  con hien trong danh sach nua.
- `src/main/java/org/example/controllers/ShipperAcceptOrderServlet.java` (`doPost`, xu ly
  Shipper bam "Nhan don"): truoc khi goi `assignShipper`, lay lai `Order` qua `orderDAO.findById`
  va so sanh `order.getCreatedAt().toLocalDate()` voi `LocalDate.now()` (ngay he thong). Neu khac
  ngay (vd Shipper mo tab cu/cache con don cua hom truoc, hoac request thu cong toi endpoint) thi
  **tu choi nhan** + goi luon `orderDAO.updateStatus(orderId, "CANCELLED")` de huy don, redirect
  ve `/shipper/nhan-don?error=expired`.
- `src/main/web/shipper/nhanDon.jsp`: them thong bao loi `❌ Đơn hàng này đã hết hạn giao trong
  ngày.` khi `param.error eq 'expired'`.

Chuc nang da co:

- Danh sach don cho Shipper nhan (`/shipper/nhan-don`) chi hien don tao trong ngay hom nay.
- Neu vi ly do nao do Shipper van gui duoc request nhan 1 don cua ngay truoc (bypass giao dien),
  server van chan lai o tang servlet, huy don do va bao loi ro rang thay vi nhan nham.

Han che/gia dinh da biet:

- Kiem tra "cung ngay" dung `LocalDate.now()` cua may chu ung dung (JVM), khong phai cua SQL
  Server — phu hop vi ca 2 thuong cung timezone trong pham vi do an, nhung neu deploy da server
  o nhieu timezone khac nhau se can dong bo lai.
- Chua co job/scheduler tu dong quet va huy hang loat cac don `READY_FOR_PICKUP` qua ngay chua ai
  nhan — hien tai don do se tu bien mat khoi danh sach (nho dieu kien SQL o `findAvailableOrders`)
  nhung van giu nguyen `status = READY_FOR_PICKUP` trong DB cho toi khi co 1 Shipper thu nhan
  (luc do moi bi chuyen sang `CANCELLED`) hoac shop tu xu ly thu cong.
- Da compile lai toan bo `src/main/java` bang `javac`, khong loi.

## 23. Xoa muc "Danh muc mon an" / "San pham" khoi sidebar Super Admin

Sidebar cua tat ca trang Super Admin (`src/main/web/admin/*.jsp`) truoc do co 2 muc menu tro toi
`/Category` va `/product` — day la 2 endpoint CRUD chung (xem `CategoryServlet`/`ProductServlet`
trong `PROJECT_STRUCTURE.md`), thuc chat la du lieu san pham/loai san pham cua tung Shop, khong
phai chuc nang quan ly he thong cua Super Admin — dat trong sidebar nay gay nham lan. Da xoa 2
muc nay (chi sua JSP, khong doi backend) khoi sidebar cua 9 file:
`TongQuanHeThong.jsp`, `yeuCauShop.jsp`, `chiTietYeuCauShop.jsp`, `quanlitaikhoan.jsp`,
`hoSoAdmin.jsp`, `chiTietYeuCauShipper.jsp`, `doiMatKhauAdmin.jsp`, `appeals.jsp`,
`yeuCauShipper.jsp`.

Ghi chu: Khong dong servlet `CategoryServlet`/`ProductServlet` (endpoint `/Category`, `/product`)
vi day la CRUD chung, chi bo lien ket tren sidebar Super Admin.

## 24. To chuc lai sidebar Super Admin thanh 4 nhom (chuan bi cho cac tinh nang tiep theo)

Sidebar Super Admin truoc do chi co 2 nhom pha tron ("Quan ly he thong" / "Quan ly Du lieu"),
khong con cho hop ly de them cac tinh nang moi (tai chinh, kiem duyet noi dung, cau hinh he
thong...). Da to chuc lai thanh 4 nhom theo dung yeu cau, ap dung dong bo cho ca 9 file JSP admin
(2 kieu markup khac nhau dang ton tai song song trong repo — kieu `<ul><li>` va kieu
`<div class="menu-section"><a class="menu-item">`, giu nguyen kieu cua tung file, chi to chuc lai
noi dung):

1. **📊 TỔNG QUAN & PHÂN TÍCH**: Tổng quan hệ thống (`/tong-quan`), Báo cáo vận hành (`href="#"`,
   cho lam sau).
2. **⚖️ KIỂM DUYỆT & ĐIỀU PHỐI**: Duyệt Shop (`/super-admin/shop-requests`), Duyệt Shipper
   (`/super-admin/shipper-requests`), Kiểm duyệt nội dung (`href="#"`), Kháng nghị
   (`/admin/appeals`, giu nguyen link).
3. **💰 QUẢN LÝ TÀI CHÍNH** (nhom moi): Đối soát doanh thu Shop, Duyệt rút tiền Shipper (ca 2 deu
   `href="#"`, chua lam logic).
4. **⚙️ CẤU HÌNH & HỆ THỐNG**: Người dùng (`/quanlitaikhoan`, giu nguyen link), Tham số vận hành,
   Truyền thông & Banner (ca 2 deu `href="#"`).

Tien the sua them (ngoai viec to chuc lai nhom):

- Muc "Duyệt Shipper" truoc do o 5/9 file (`TongQuanHeThong.jsp`, `quanlitaikhoan.jsp`,
  `hoSoAdmin.jsp`, `doiMatKhauAdmin.jsp`, `appeals.jsp`) chi la `<li>` tinh, KHONG co the
  `<a href=...>` bao quanh — bam vao khong dieu huong duoc. Da bo sung link toi
  `/super-admin/shipper-requests` (dung endpoint that su cua `SuperAdminShipperRequestServlet`,
  xac nhan qua cac file con lai da dung dung link nay).
- File `yeuCauShipper.jsp` va `chiTietYeuCauShipper.jsp` truoc do KHONG co muc "Kháng nghị" trong
  sidebar (thieu so voi 7 file con lai) — da them vao nhom Kiem duyet & Dieu phoi cho dong bo.
- Badge so luong (Duyet Shop/Duyet Shipper/Khang nghi "mơi") dung chung dieu kien
  `${shopChoDuyet > 0}` / `${not empty pendingShippers}` / `${pendingCount > 0}` o tat ca file —
  JSTL EL tra ve rong/false 1 cach an toan neu servlet cua trang do khong set attribute tuong ung
  (vd trang Ho so/Doi mat khau khong set `pendingShippers`), khong gay loi, chi don gian la badge
  khong hien — nen co the dung chung 1 dieu kien o moi noi ma khong can sua servlet.

Cac muc `href="#"` (Bao cao van hanh, Kiem duyet noi dung, Doi soat doanh thu Shop, Duyet rut
tien Shipper, Tham so van hanh, Truyen thong & Banner) la placeholder — CHUA co servlet/JSP/logic
phia sau, se lam trong buoc tiep theo.

## 25. Dong bo theme cho 2 trang Duyet Shipper voi cac trang Admin con lai

Sau khi to chuc lai sidebar (muc 24), phat hien `yeuCauShipper.jsp` va `chiTietYeuCauShipper.jsp`
(2/9 file admin) dung 1 bang mau CSS khac han 7 file con lai: `--bg-base:#151521`,
`--primary:#20d489` (xanh la chuoi khac tong), thieu class `.badge-count` du sidebar dung toi, va
phan header dung avatar tinh "AD" + nut "Đăng xuất" do rieng le thay vi avatar-dropdown giong cac
trang khac — nhin lac tong so voi phan con lai cua he thong Super Admin.

Da sua (chi CSS/JS trong JSP, khong doi backend):

- `src/main/web/admin/yeuCauShipper.jsp`, `src/main/web/admin/chiTietYeuCauShipper.jsp`: thay
  toan bo bien `:root[data-theme]` bang dung bang mau cua `yeuCauShop.jsp`/`chiTietYeuCauShop.jsp`
  (`--bg-base:#0f172a`, `--primary:#10b981`, `--warning:#f59e0b`...), them class `.badge-count`/
  `.badge-count.green` con thieu, va doi phan avatar o top-header tu avatar tinh + nut "Đăng xuất"
  rieng sang avatar-btn (co the hien avatarUrl that) + avatar-dropdown (Ho so ca nhan/Doi mat
  khau/Dang xuat) giong het cac trang admin khac — dong bo cach nguoi dung dang xuat/xem ho so
  tren toan bo Super Admin.

Ghi chu: Khong sua noi dung nghiep vu (bang danh sach shipper cho duyet, form Duyet/Tu choi, chi
tiet ho so shipper) — chi thay CSS/markup phan khung (sidebar/topbar/avatar) de dong bo giao dien.

## 26. Bo goc khung highlight menu-item dang active tren sidebar

Nguoi dung phan anh khung mau xanh cua menu-item dang active (vd "Duyet Shipper") bi vuong canh,
khong bo goc nhu cac trang khac. Kiem tra lai ca 9 file JSP admin: co 4 file da dung style bo goc
(`border-radius:8px; margin-bottom:4px`, container `.menu`/`.menu-section` co padding ngang 12px
de tao khoang cach 2 ben) — `TongQuanHeThong.jsp`, `quanlitaikhoan.jsp`, `hoSoAdmin.jsp`,
`doiMatKhauAdmin.jsp`; con 5 file kia (`appeals.jsp`, `yeuCauShop.jsp`, `chiTietYeuCauShop.jsp`,
`yeuCauShipper.jsp`, `chiTietYeuCauShipper.jsp`) dung kieu cu: khong bo goc, dung vien trai
`border-left:3px solid transparent` lam dau hieu active, container khong co padding ngang nen
khung mau tran sat 2 canh sidebar — day chinh la kieu nguoi dung dang thay va muon sua.

Da dong bo ca 5 file con lai ve dung 1 kieu (bo goc) nhu 4 file kia:

- Container (`.menu` hoac `.menu-section`): them padding ngang tu `0` len `12px` de tao khoang
  cach 2 ben cho khung active "noi" thay vi tran vien.
- `.menu-item`: giam padding ngang tu `20px`/`25px` xuong `16px` (bu lai phan padding ngang moi
  cua container), them `border-radius: 8px; margin-bottom: 4px;`, bo `border-left: 3px solid
  transparent`.
- `.menu-item.active`: bo `border-left-color`, dung dung 1 kieu `background-color:
  var(--primary-light); color: var(--primary); font-weight: 600;` (truoc do 2 file
  `yeuCauShop.jsp`/`chiTietYeuCauShop.jsp` dung mau cung `rgba(32,212,137,0.1)` thay vi bien
  `--primary-light`, gio dung chung 1 bien).

Ghi chu: Chi doi CSS, khong doi HTML/logic. `.menu-item:hover` giu nguyen (da giong nhau tu truoc).

## 27. Them hieu ung con thieu tren trang Duyet Shop / Duyet Shipper

Nguoi dung phan anh vao trang Duyet Shop/Duyet Shipper "khong co hieu ung gi". Kiem tra lai: nut
bam (`.btn:hover` nhac len + `box-shadow`, `.btn:active` nhan xuong) da co san tu truoc giong cac
trang khac, nhung **khi danh sach dang rong** (0 shop/shipper cho duyet — dung tinh trang thuc te
luc kiem tra) thi trang chi hien 1 khung `.empty` tinh, khong hieu ung gi, khac han khung
`.table-card` (co san animation `fadeUp` khi co du lieu) — day la ly do trang trong "chet", khong
song dong nhu trang Tong quan (luon co the thong ke + hover). Ngoai ra dong bang cung chi doi mau
nen khi hover, chua co diem nhan ro rang nhu cac trang khac.

Da them (chi CSS, khong doi HTML/logic):

- `.empty` (khung "Hien khong co yeu cau nao dang cho duyet") them `animation: fadeUp 0.35s ease
  both;` — ap dung cho ca 4 file: `yeuCauShop.jsp`, `yeuCauShipper.jsp` (trang danh sach) va
  `chiTietYeuCauShop.jsp`, `chiTietYeuCauShipper.jsp` (khung "khong tim thay", it gap hon).
- `tr:hover td` (trang danh sach `yeuCauShop.jsp`, `yeuCauShipper.jsp`) them
  `box-shadow: inset 3px 0 0 var(--primary);` lam vach mau nhan o canh trai dong dang hover, kem
  `transition: background-color 0.2s ease, box-shadow 0.2s ease;` de doi mau/vach muot hon thay vi
  doi mau nen dot ngot.

Ghi chu: Nut Duyet/Tu choi/Chi tiet da co hieu ung hover tu truoc (kiem tra lai xac nhan dung), chi
khong hien ra duoc vi luc kiem tra danh sach dang trong (0 ban ghi) nen khong co nut nao de ren
chuot vao.

## 38. Redesign layout trang Tong quan he thong (them card Tong Doanh Thu San, khung bieu do, bang Top 5 shop)

Trieu chung: Nguoi dung phan anh trang `/tong-quan` (`admin/TongQuanHeThong.jsp`) phia nua duoi
con trong, chi co 1 bang "Yeu cau duyet Shop gan day", chua co bieu do xu huong hay bang xep hang
doanh thu shop.

Nguyen nhan: Trang moi dung 4 card thong ke + 1 bang, `ShopDAO`/`TongQuanServlet` chua co ham/
attribute nao tinh tong doanh thu toan san hoac xep hang shop theo doanh thu.

Da sua:

- Model moi `org.example.models.ShopRevenueStat` (shopName, tongDon, doanhThu) — POJO don gian
  giong style cac model khac trong project.
- `ShopDAO`/`ShopDAOImpl` them 2 method:
  - `getTotalRevenue()`: `SELECT ISNULL(SUM(total_price), 0) FROM Orders WHERE status = 'DONE'`
    — tong doanh thu toan san.
  - `findTop5ShopsByRevenue()`: JOIN `Shops`/`Orders`, group theo shop, `tongDon = COUNT(o.id)`,
    `doanhThu = SUM(CASE WHEN status='DONE' THEN total_price ELSE 0 END)`, `ORDER BY doanhThu
    DESC`, `TOP 5`, chi shop `is_deleted = 0`.
- `TongQuanServlet.java` goi 2 ham tren, set them attribute `tongDoanhThuSan` va
  `top5ShopDoanhThu`.
- `admin/TongQuanHeThong.jsp`:
  - Them taglib `fmt` de format tien te (`<fmt:formatNumber pattern="#,##0"/> đ`), dung dung
    convention da co trong `shop/trangcuahang.jsp`.
  - `.stats-grid` doi `grid-template-columns: repeat(4, 1fr)` sang `repeat(auto-fit,
    minmax(220px, 1fr))` de tu co gian dep khi co 5 card; them bien mau `--purple` va rule
    `.stat-card:nth-child(5)` cho card moi.
  - Them card thu 5 "Tong Doanh Thu San" (mau tim, du lieu tu `${tongDoanhThuSan}`).
  - Than duoi chia layout 2 cot moi `.dashboard-grid` (`2fr 1fr`, responsive ve 1 cot khi man
    hinh <= 1100px): cot trai la khung `.chart-panel`/`.chart-container` chua `<canvas
    id="revenueTrendChart">` (placeholder CSS, chua nhung script Chart.js — nguoi dung se tu ve
    sau); cot phai la bang "Yeu cau duyet Shop gan day" cu, chuyen nguyen khoi vao, khong doi
    logic/noi dung.
  - Them bang moi "Top 5 Cua Hang Doanh Thu Cao Nhat" (Hang, Ten Cua Hang, Tong Don, Doanh Thu)
    o duoi cung, full width, dung `${top5ShopDoanhThu}` voi `varStatus` de danh so hang #1-#5.

Ghi chu: Bien `${canhBaoViPham}` o card thu 4 van chua duoc servlet set (bug co san, khong thuoc
scope yeu cau nay, khong dong vao). Da `javac` bien dich sach sau khi them model + 2 method DAO +
2 attribute servlet + JSP moi.

## 39. Bo sung du lieu that cho card "Canh Bao Vi Pham" (Tong quan he thong)

Trieu chung: Card "Canh Bao Vi Pham" o trang `/tong-quan` dung `${canhBaoViPham}` nhung servlet
chua bao gio set attribute nay (bug ke thua tu muc 38) — card luon hien rong/0.

Nguyen nhan: Chua co logic tinh "vi pham" nao gop du lieu tu cac bang lien quan.

Da hoi lai nguoi dung va chot pham vi: "vi pham" = tong 3 nguon du lieu, tinh toan thoi gian (luy
ke), CHUA can dieu huong sang trang chi tiet:

1. Shop bi khoa: `Shops.status = 'BLOCKED'`.
2. Tai khoan bi dinh chi/khoa: `Accounts.is_deleted = 1 OR Accounts.status = 'BLOCKED'` — dung
   dung 2 dieu kien ma `DangNhapServlet.java` da dung de tu choi dang nhap (dong 37, 47).
3. Danh gia thap: `Feedbacks.rating <= 2` (gop chung ca danh gia nham vao SHOP lan SHIPPER).

Rieng tieu chi "don hang bi huy bat thuong" KHONG dua vao vi bang `Orders` chi luu chung 1
`status = 'CANCELLED'` cho moi nguyen nhan huy (khach tu huy, shop bao het hang, shipper bo don,
he thong tu huy do qua han/qua ngay) — khong co cot luu ai/ly do huy nen khong the tach rieng
"huy do loi shop/shipper" ra khoi huy hop le. Nguoi dung da dong y bo tieu chi nay thay vi doi
schema `Orders` (qua rong so voi scope card).

Da them:

- `AccountDAO`/`AccountDAOImpl.countSuspendedAccounts()`: `SELECT COUNT(*) FROM Accounts WHERE
  is_deleted = 1 OR status = 'BLOCKED'`.
- `ShopDAO`/`ShopDAOImpl.countBlockedShops()`: `SELECT COUNT(*) FROM Shops WHERE status =
  'BLOCKED'`.
- `FeedbackDAO`/`FeedbackDAOImpl.countLowRatingFeedback(int threshold)`: `SELECT COUNT(*) FROM
  Feedbacks WHERE rating <= ?`.
- `TongQuanServlet.java`: cong ca 3 ham tren (`countBlockedShops() + countSuspendedAccounts() +
  countLowRatingFeedback(2)`) thanh `canhBaoViPham`, set vao request attribute — JSP khong doi gi
  them vi card nay da co san tu muc 38, chi thieu du lieu.

Ghi chu: `ThongKeDAOImpl.getViolationWarnings()` (mot DAO khac, khong lien quan `TongQuanServlet`)
truoc do da co san logic dem shop BLOCKED nhung khong duoc dung o trang nay — khong sua/xoa vi
thuoc luong code khac, chi tham khao de xac nhan gia tri cot `status` dung dung. Da `javac` bien
dich sach sau khi them 3 method DAO + 1 bien servlet.

## 40. Ve bieu do "Xu huong Doanh thu / Don hang" bang Chart.js (Tong quan he thong)

Yeu cau: Trang `/tong-quan` co san khung CSS trong `.chart-container`/`<canvas
id="revenueTrendChart">` (tao tu muc 38, chua co du lieu). Nguoi dung yeu cau ve bieu do duong
(Line Chart) 7 ngay gan nhat, 3 duong: don thanh cong (xanh la neon), don huy (do neon), doanh
thu (cam neon), hop voi Dark Mode.

Da them:

- Model moi `org.example.models.DailyOrderStat`: POJO `ngay` (String, dinh dang `dd/MM`),
  `donThanhCong` (int), `donHuy` (int), `doanhThu` (double) — theo dung style cac model khac
  trong project (no-arg + full-arg constructor, getter/setter, khong Lombok).
- `ShopDAO`/`ShopDAOImpl.findDailyOrderStats(int days)`: query 1 lan gop nhom theo ngay
  (`CAST(created_at AS DATE)`) tren toan bang `Orders` (khong loc theo shop — thong ke toan
  san), dem `COUNT(CASE WHEN status='DONE' ...)` cho don thanh cong, `COUNT(CASE WHEN
  status='CANCELLED' ...)` cho don huy, `SUM(CASE WHEN status='DONE' THEN total_price ELSE 0
  END)` cho doanh thu, loc `created_at >= DATEADD(DAY, -(days-1), CAST(GETDATE() AS DATE))`. Sau
  do zero-fill trong Java (vong lap `LocalDate` tu `today.minusDays(days-1)` den `today`) de dam
  bao du 7 ngay lien tuc kem ngay khong co don van hien 0 — dung dung pattern
  `ShopDashboardDAOImpl.loadRevenueLast7Days()` da co san trong project, chi mo rong them 2 cot
  dem don thay vi chi doanh thu, va bo dieu kien loc `shop_id` vi day la thong ke toan he thong.
- `TongQuanServlet.java`: goi `shopDAO.findDailyOrderStats(7)`, set attribute
  `thongKeTheoNgay`.
- `admin/TongQuanHeThong.jsp`: nhung `<script src="https://cdn.jsdelivr.net/npm/chart.js">`
  (CDN, dung convention da co trong `shop/trangcuahang.jsp`), build 4 mang JS (`trendLabels`,
  `trendDonThanhCong`, `trendDonHuy`, `trendDoanhThu`) tu `${thongKeTheoNgay}` qua
  `<c:forEach>` (khong dung JSON, dung convention toan project), roi khoi tao `new Chart(...)`
  kieu `line` nham vao `<canvas id="revenueTrendChart">`:
  - 3 dataset: "Don thanh cong" (`borderColor: '#00ff9d'`), "Don huy" (`borderColor:
    '#ff3860'`), "Doanh thu (đ)" (`borderColor: '#ff9100'`) — deu co `backgroundColor` fill
    trong suot nhe cung mau, `tension: 0.35` cho duong cong muot.
  - 2 truc Y rieng (`yDon` ben trai cho so luong don, `yRevenue` ben phai cho doanh thu) vi 2
    thang do khac nhau qua lon (chuc/don vs trieu dong) — tranh duong doanh thu de bet cac
    duong con lai.
  - Plugin tuy chinh `neonGlowPlugin` (hook `beforeDatasetDraw`/`afterDatasetDraw`) set
    `ctx.shadowColor` = mau duong + `ctx.shadowBlur = 12` truoc khi Chart.js ve tung dataset —
    tao hieu ung "phat sang" that (Chart.js khong co option glow san, day la ky thuat canvas
    shadow chuan).
  - Mau chu/luoi truc (`ticks`, `grid`, `legend`) doc truc tiep tu bien CSS `--text-muted` va
    `--border-color` cua trang (qua `getComputedStyle`) de tu dong hop voi theme dang active
    luc trang load (dark/light).

Da `javac` bien dich sach sau khi them model + 1 method DAO + 1 attribute servlet + script
Chart.js trong JSP. Khong co test framework trong project — khuyen nghi nguoi dung chay server,
load `/tong-quan`, kiem tra bieu do hien du 7 ngay va 3 duong mau dung nhu yeu cau.

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

## 46. Trang "Doi soat doanh thu Shop" (phan he Quan ly tai chinh) — Khung giao dien, mock data

**File moi**:
- `src/main/web/admin/DoiSoatDoanhThuShop.jsp` — JSP giao dien, style Dark/Light Mode dong bo voi
  cac trang Super Admin khac (cung bo bien CSS `:root[data-theme]`, cung sidebar, cung
  theme-toggle/sidebar-collapse dung localStorage key `'theme'`/`'sidebarCollapsed'`).
- `src/main/java/org/example/controllers/DoiSoatDoanhThuShopServlet.java` — servlet
  `@WebServlet("/admin/doi-soat-doanh-thu-shop")`, hien tai chi `forward` sang JSP, CHUA query DB.

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

**Gan link sidebar**: da thay `href="#"` bang
`${pageContext.request.contextPath}/admin/doi-soat-doanh-thu-shop` cho muc menu "Doi soat doanh
thu Shop" tren TAT CA cac trang Super Admin dang co muc nay trong sidebar (BaoCaoVanHanh.jsp,
appeals.jsp, doiMatKhauAdmin.jsp, hoSoAdmin.jsp, KiemDuyetBinhLuan.jsp, KiemDuyetNoiDung.jsp,
quanlitaikhoan.jsp, TongQuanHeThong.jsp, chiTietYeuCauShipper.jsp, yeuCauShipper.jsp,
chiTietYeuCauShop.jsp, yeuCauShop.jsp), giu nguyen 2 kieu cau truc HTML khac nhau cua tung file.

**Chua lam (cho duyet layout xong moi lam tiep)**:
- Servlet chua query DB that (Orders/Order_Logs/Shops) de tinh doanh thu/phi san/trang thai
  thanh toan thuc te.
- Chua co bang luu trang thai "da thanh toan cho Shop" that trong DB — hien tai nut [Xac nhan
  thanh toan] chi doi giao dien, KHONG ghi log/khong co API POST that.
- Chua co logic phan quyen rieng cho action thanh toan (vi du: co can ghi log ai la nguoi
  bam xac nhan thanh toan, so tien, thoi diem — tuong tu Order_Logs) — se thiet ke sau khi
  chot layout va nguon du lieu that.

## 46.1. Trang "Doi soat doanh thu Shop" — Noi du lieu that + xac nhan thanh toan (POST/AJAX)

**File moi**:
- `migration_shop_settlements.sql` — tao bang `Shop_Settlements` (id, shop_id, period_start,
  period_end, gross_revenue, platform_fee, net_payout, status ['PENDING'/'PAID'], confirmed_by,
  confirmed_at, created_at, updated_at). Rang buoc UNIQUE (shop_id, period_start, period_end) —
  moi lan Admin xac nhan thanh toan cho 1 Shop trong 1 khoang ngay cu the se upsert 1 dong (dung
  lenh T-SQL `MERGE`). FK toi `Shops(id)` va `Accounts(id)` (confirmed_by).
- `src/main/java/org/example/models/ShopDoiSoat.java` — DTO ket qua doi soat 1 Shop (shopId,
  shopName, soDonThanhCong, tongDoanhThu, phiSan, soTienThucNhan, daThanhToan). `phiSan`/
  `soTienThucNhan` tu tinh trong constructor (10%/90% cua tongDoanhThu).
- `src/main/java/org/example/daos/DoiSoatDoanhThuShopDAO.java` + `DoiSoatDoanhThuShopDAOImpl.java`:
  - `getDoiSoatTheoShop(tuNgay, denNgay, shopId)`: SQL `LEFT JOIN Orders` (dieu kien
    `status = 'DONE'` va `created_at` trong khoang ngay) tren `Shops` (chi lay `is_deleted = 0`),
    kem `LEFT JOIN Shop_Settlements` (theo dung shop_id + period_start + period_end) de biet
    Shop da duoc xac nhan thanh toan cho DUNG ky nay hay chua. GROUP BY shop, tra ve so don +
    tong doanh thu (SUM total_price, KHONG gom delivery_fee vi phi ship thuoc ve shipper). Loc
    them theo shopId neu Admin chon 1 Shop cu the thay vi "Tat ca".
  - `xacNhanThanhToan(shopId, tuNgay, denNgay, tongDoanhThu, phiSan, soTienThucNhan, confirmedBy)`:
    dung `MERGE INTO Shop_Settlements` — neu da co dong cho dung (shop_id, period_start,
    period_end) thi UPDATE status='PAID', neu chua co thi INSERT moi.
- **Sua** `src/main/java/org/example/controllers/DoiSoatDoanhThuShopServlet.java`:
  - `doGet`: kiem tra quyen Super Admin (roleId == 1) truoc khi xu ly (redirect ve `/dangnhap`
    neu khong dat). Doc `tuNgay`/`denNgay` (mac dinh 30 ngay gan nhat, giong
    `BaoCaoVanHanhServlet`) va `shopId` (mac dinh "all"). Goi DAO lay danh sach doi soat that,
    tinh tong Gross Revenue / tong Phi san / tong Net Payout / so Shop cho thanh toan tu chinh
    danh sach nay (KHONG hardcode), roi forward sang JSP kem danh sach Shop that (tu `ShopDAO`)
    de render dropdown bo loc.
  - `doPost`: action "Xac nhan thanh toan" (goi tu AJAX). Kiem tra quyen Super Admin, **tinh lai
    doanh thu ngay tai server** (khong tin so lieu client gui len) qua
    `getDoiSoatTheoShop(shopId, tuNgay, denNgay)`, tu choi neu Shop khong co don thanh cong nao
    trong ky, roi goi `xacNhanThanhToan(...)` voi `confirmed_by = ID cua Super Admin dang dang
    nhap` (lay tu session). Tra ve JSON `{success, ...}` cho JS xu ly.

**Sua** `src/main/web/admin/DoiSoatDoanhThuShop.jsp`:
- Bo banner "DANG DUNG MOCK DATA".
- Bo loc Shop: dropdown render bang JSTL `<c:forEach>` tu danh sach Shop that (`danhSachShop`)
  thay vi hardcode 5 shop; 2 o ngay lay gia tri tu server (`tuNgay`/`denNgay` da parse) thay vi
  hardcode `2026-07-01`/`2026-07-22`.
- 3 card so lieu: dung `<fmt:formatNumber>` tren `tongDoanhThu`/`tongPhiSan`/`tongNetPayout` (that
  su tinh tu DB), khong con hardcode `82.450.000₫`...
- Bang doi soat: render bang JSTL `<c:forEach items="${danhSachDoiSoat}">` (khong con JS mang
  `mockShops`), moi dong `<tr>` co `data-shop-id` de JS biet xac nhan thanh toan cho Shop nao.
  Nut [Xac nhan thanh toan] tu dong `disabled` neu Shop da thanh toan HOAC khong co don thanh
  cong nao trong ky.
- JS: bo toan bo khoi mock-render; thay bang 1 handler AJAX that — bam nut se `confirm()` roi
  `fetch()` POST (`application/x-www-form-urlencoded`, gui `shopId`/`tuNgay`/`denNgay`) toi
  chinh URL servlet. Chi cap nhat UI (doi pill thanh "Da thanh toan", nut thanh "Da chi" +
  disabled) khi server tra ve `{success:true}`; neu loi thi bao `alert()` va cho phep bam lai.

**Luu y quan trong**: "Tong doanh thu" (Gross Revenue) hien dang tinh = `SUM(Orders.total_price)`
CHUA gom `delivery_fee` — vi phi giao hang thuoc ve Shipper, khong phai doanh thu cua Shop/san.
Neu sau nay nghiep vu thay doi (vd: san cung thu % tren phi ship) thi can sua lai cong thuc trong
`DoiSoatDoanhThuShopDAOImpl.getDoiSoatTheoShop()`.

**Van con thieu (chua lam trong luot nay)**:
- Chua co man hinh/lich su xem lai cac lan da xac nhan thanh toan truoc do (bang `Shop_Settlements`
  hien chi duoc dung ngam de biet Trang thai trong ky dang xem, chua co trang "Lich su doi soat").
- Chua chay migration `migration_shop_settlements.sql` tren DB that (can DBA/nguoi quan tri DB
  chay truoc khi tinh nang nay hoat dong, vi bang `Shop_Settlements` chua ton tai san server).
>>>>>>> ThanhHien_TY00243
