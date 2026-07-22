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

**`BaoCaoVanHanhDAO`/`BaoCaoVanHanhDAOImpl`**: them 2 method moi (van theo pattern SQL literal
truc tiep, khong dung schema resolution dong nhu `OrderDAOImpl`):
- `getKhungGioDatHangCaoDiem(tuNgay, denNgay)`: `SELECT TOP 1 DATEPART(HOUR, created_at) AS gio,
  COUNT(*) FROM Orders WHERE ... GROUP BY DATEPART(HOUR, created_at) ORDER BY so_luong DESC` — dung
  `DATEPART(HOUR, ...)` cua MSSQL (khong phai `HOUR()` kieu MySQL, DB thuc te cua project la SQL
  Server). Format ket qua thanh chuoi `"HH:00 - HH+1:00"` (vd `11:00 - 12:00`), tra `null` neu
  khong co don nao trong khoang ngay.
- `countCancelReasons(tuNgay, denNgay)`: `SELECT ISNULL(cancel_reason, N'Khong ro ly do') AS ly_do,
  COUNT(*) FROM Orders WHERE status = 'CANCELLED' AND ... GROUP BY ISNULL(cancel_reason, N'Khong
  ro ly do') ORDER BY so_luong DESC` — tra `LinkedHashMap<String,Integer>` de giu thu tu giam dan
  (khop thu tu cot trong bieu do).

**`BaoCaoVanHanhServlet.java`**: goi 2 method moi, them 2 request attribute `khungGioCaoDiem`
(String) va `lyDoHuyDon` (`Map<String,Integer>`) truoc khi forward.

**`admin/BaoCaoVanHanh.jsp`**:
- Them `.stat-card` thu 4 "Khung Gio Dat Hang Cao Diem" vao `.stats-grid` (accent mau tim
  `var(--purple)`, hien `--` neu `khungGioCaoDiem` rong).
- Them 1 `.panel` moi (duoi `.dashboard-grid` hien co, full width) "THONG KE LY DO HUY DON" chua
  `<canvas>` bieu do cot Chart.js — dung lai CDN `chart.js` da nhung san trong trang, doc mau truc
  qua CSS variable `--text-muted`/`--border-color` (dong bo Dark/Light theme) giong pattern
  `TongQuanHeThong.jsp`. Du lieu bieu do build tu `lyDoHuyDon` qua `<c:forEach>` JSTL sinh mang JS
  (dung `fn:escapeXml` cho label de tranh loi cu phap JS/XSS neu ly do co ky tu dac biet). Neu
  `lyDoHuyDon` rong thi hien thong bao "Khong co don hang nao bi huy..." thay vi ve bieu do rong.

**Luu y**: don da huy TRUOC khi chay migration + deploy ban vá nay se khong co `cancel_reason` (cot
moi thi NULL) — bieu do se gom tat ca vao nhom "Khong ro ly do" cho toi khi co du don huy moi di
qua code da sua.

## 47. Tinh nang "Kiem duyet binh luan" (Super Admin) — quet tu cam tu dong + trang duyet mock-data

Yeu cau: Super Admin tu them danh sach tu ngu nhay cam vao DB de he thong tu dong quet binh luan
moi, gan co "cho duyet" neu dinh tu cam; kem 1 trang `KiemDuyetBinhLuan.jsp` (Dark Mode, 2 tab)
de duyet/xoa. Phan logic quet tu cam (`checkBadWords`) la ham that, chay khi luu Feedback that;
con giao dien JSP van la khung mock-data (theo dung yeu cau + dung pattern mock-truoc-noi-sau da
dung o muc 43/44 cho `KiemDuyetNoiDung.jsp`).

**Migration moi** (`migration_feedback_moderation.sql`, cung pattern `USE POB; GO` +
`IF NOT EXISTS (...)` de chay lai nhieu lan khong loi): **nguoi dung can tu chay file nay 1 lan
tren database POB** — Claude khong co quyen truy cap DB truc tiep.
- Them cot `Feedbacks.status NVARCHAR(20) DEFAULT 'VISIBLE'` (gia tri: `VISIBLE` / `PENDING_REVIEW`
  / `REMOVED`).
- Tao bang moi `BannedWords (id, word, created_at)` — seed san 5 tu mau (`lừa đảo`, `ngu`, `chửi`,
  `địt`, `đéo`) de test ngay, Super Admin tu them/xoa tu qua SQL truc tiep (chua co UI quan ly
  bang nay trong buoc nay).

**`Feedback.java`**: them field `status` (String) + getter/setter chuan (khong dinh typo
`staTus` nhu `Product.java`/`Order.java`).

**`FeedbackDAO`/`FeedbackDAOImpl`** — 3 method moi (logic that, khong phai mock):
- `checkBadWords(String comment)`: query toan bo `SELECT word FROM BannedWords`, so sanh
  khong phan biet hoa/thuong (`toLowerCase().contains(...)`) voi tung tu, tra `true` ngay khi
  dinh 1 tu.
- `findPendingReview()`: `SELECT ... FROM Feedbacks WHERE status = 'PENDING_REVIEW' ORDER BY
  created_at DESC` (join `Accounts` lay ten nguoi gui, xu ly rieng an danh).
- `updateStatus(long feedbackId, String status)`: `UPDATE Feedbacks SET status = ? WHERE id = ?`
  — Super Admin duyet (`VISIBLE`) hoac xoa bo (`REMOVED`) 1 binh luan dang cho duyet.
- Sua `save()`: goi `checkBadWords(f.getComment())` truoc khi insert — dinh tu cam thi gan
  `status = "PENDING_REVIEW"` ngay tu luc luu, khong hien cong khai; khong dinh thi `VISIBLE`
  nhu binh thuong.
- Sua helper `map(ResultSet rs)`: doc them cot `status`, boc `try/catch(SQLException)` vi mot
  so query cu (`findByTarget()`) chua SELECT cot nay.

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

Da bien dich `javac` toan bo `src/main/java` sach loi (chi sua logic DAO/servlet + JSP, khong doi
API cong khai nao khac). Nguoi dung can tu chay `migration_feedback_moderation.sql` (neu chua
chay tu muc 47) roi load `/admin/kiem-duyet-binh-luan` — tao thu 1 binh luan chua tu cam de kiem
tra: binh luan phai hien PENDING_REVIEW trong hang doi that, bam Phe duyet/Xoa bo phai cap nhat
DB va load lai danh sach dung.

## 50. Hoan thien quy trinh giao hang: tach buoc CONFIRMED + gan shipper thu cong

Endpoint: `/shop/bills`

Truoc do quy trinh don hang trong `ShopBillServlet` bi rut gon sai: nut "Xac nhan" cua shop
nhay thang `PENDING -> READY_FOR_PICKUP` (bo qua trang thai `CONFIRMED` du DB (`Database.md`
dong 368) da khai bao du enum `PENDING, CONFIRMED, READY_FOR_PICKUP, SHIPPING, DONE, CANCELLED`),
dong thoi co bug: `OrderLog` ghi `newStatus = "CONFIRMED"` trong khi status thuc luu xuong DB lai
la `READY_FOR_PICKUP` (log va du lieu that lech nhau). Ngoai ra chi co 1 co che gan shipper duy
nhat la shipper tu nhan don qua `/shipper/nhan-don` (`OrderDAO.findAvailableOrders()` +
`assignShipper`), khong co cach nao de Shop chu dong chon shipper cu the.

Da sua/them:

- `src/main/java/org/example/daos/AccountDAO.java` + `AccountDAOImpl.java`: them
  `findOnlineShippers()` — lay danh sach shipper `role_id = 4 AND status = 'ACTIVE' AND
  is_online = 1 AND is_deleted = 0` de shop chon khi gan don.
- `src/main/java/org/example/controllers/ShopBillServlet.java`:
  - Action `confirm` (PENDING) gio chuyen dung sang `CONFIRMED` (truoc la nhay thang
    `READY_FOR_PICKUP`), OrderLog ghi dung `newStatus = CONFIRMED`.
  - Them action moi `prepared` (CONFIRMED -> READY_FOR_PICKUP, "Shop da chuan bi xong mon").
  - Them action moi `assignShipper` (chi khi don dang `READY_FOR_PICKUP` va chua co shipper) —
    goi lai `orderDAO.assignShipper(orderId, shipperId)` co san (WHERE shipper_id IS NULL/0 de
    tranh race voi shipper tu nhan don cung luc), ghi OrderLog neu thanh cong.
  - Action `cancel` (huy/tu choi don) gio cho phep ca khi dang `PENDING` lan `CONFIRMED`, khong
    chi rieng `PENDING` nhu truoc.
  - `doGet` truyen them attribute `onlineShippers` cho JSP hien dropdown chon shipper.
- `src/main/web/shop/Quanlybill.jsp`:
  - Them badge trang thai `CONFIRMED` ("Dang chuan bi mon"), badge `READY_FOR_PICKUP` phan biet
    da co shipper hay chua (`o.shipperId > 0`).
  - Them nut "Da chuan bi" (CONFIRMED) va form chon shipper + nut "Gan" (READY_FOR_PICKUP,
    chi hien khi `shipperId <= 0`).
  - Doi nhan nut huy o buoc PENDING tu "Huy" thanh "Tu choi" cho dung ngu nghia so do quy trinh.
  - Them thong bao PRG cho cac ket qua moi: `success=prepared`, `success=assigned`,
    `error=already_assigned`, `error=invalid_shipper`.

Quy trinh sau khi sua (khop dung so do yeu cau):

```
Khach dat -> PENDING
  -> Shop xac nhan (button "Xac nhan") -> CONFIRMED
  -> Shop chuan bi xong mon (button "Da chuan bi") -> READY_FOR_PICKUP
  -> Shop gan shipper thu cong (chon tu dropdown online) HOAC shipper tu nhan don qua
     /shipper/nhan-don (2 co che cung dung 1 ham OrderDAO.assignShipper, khong xung dot nhau
     nho dieu kien WHERE shipper_id IS NULL/0)
  -> Shipper bam "Bat dau giao" (/shipper/donhang, code cu, khong doi) -> SHIPPING
  -> Shipper bam "Hoan thanh" -> DONE
```

Da phat hien va sua 1 lo hong qua review (subagent doc lai code): action `assignShipper` luc
dau chi doc `shipperId` tu form roi goi thang `orderDAO.assignShipper(orderId, shipperId)`,
khong validate id do co thuc su la 1 shipper (role=4, active, online) hay khong — ke tan cong co
the sua value trong `<select>`/POST truc tiep de gan **bat ky account id nao** (ke ca admin, shop
khac, id khong ton tai) lam shipper cua don hang (IDOR/du lieu rac). Da sua: them
`ShopBillServlet.isValidOnlineShipper(shipperId)` doi chieu voi danh sach
`accountDAO.findOnlineShippers()` truoc khi cho gan, tu choi voi `error=invalid_shipper` neu
khong hop le.

Han che/ghi chu:

- Khong them bang/cot DB moi — chi dung lai `Orders.status`, `Orders.shipper_id` da co san
  dung nhu yeu cau (Database khong doi).
- `findOnlineShippers()` chi liet ke shipper dang bat "online" (cot `is_online`, xem
  `migration_shipper_is_online.sql`) — neu khong shipper nao dang online, dropdown gan se trong,
  shop van co the doi shipper tu bat online hoac dung co che tu nhan don nhu cu.
- Da bien dich `javac` toan bo `src/main/java` sach loi (khong doi API cong khai nao khac ngoai
  them method moi `AccountDAO.findOnlineShippers()`).
- Chua sua rieng phan admin (khong co yeu cau man hinh admin gan shipper trong lan nay, chi
  shop) — neu can them cho phia admin thi lam tuong tu, dung lai `OrderDAO.assignShipper` va
  `AccountDAO.findOnlineShippers`.

## 51. Tru ton kho tu dong khi don hoan thanh (DONE)

Endpoint: khong co endpoint moi, hook vao 3 noi don chuyen sang `DONE`.

Truoc do `Products.stock_quantity` co the nhap/sua qua `/shop/products` nhung khong bao gio bi
tru di khi ban duoc hang — kiem tra toan bo `stock_quantity`/`stockQuantity` trong code truoc khi
sua thi khong co cho nao thuc hien phep tru.

Da them:

- `src/main/java/org/example/daos/ProductDAO.java` + `ProductDAOImpl.java`: them
  `decreaseStock(productId, quantity)` — UPDATE nguyen tu 1 cau SQL
  `stock_quantity = stock_quantity - ?` co dieu kien `WHERE stock_quantity IS NOT NULL AND
  stock_quantity >= ?` (bo qua neu dang NULL = khong gioi han ton kho, khong tru am), dong thoi
  tu dong chuyen `status = 'OUT_OF_STOCK'` trong cung 1 cau SQL (CASE WHEN) neu ton kho ve 0.
- `src/main/java/org/example/utils/InventoryUtil.java` (moi) — ham tinh
  `decreaseStockForOrder(orderId)`, doc `OrderDetail` cua don roi goi `decreaseStock` cho tung
  san pham/so luong.

Da goi `InventoryUtil.decreaseStockForOrder(...)` ngay sau khi 1 don thuc su chuyen sang `DONE`
o ca 3 noi phat sinh trang thai nay:

- `ShipperOrderServlet.doPost` (action `updateStatusToDone`, luong giao hang qua shipper).
- `ShopPosServlet.createOrder()` — don CASH/QR tai quay tao ra da la `DONE` ngay lap tuc.
- `PayOSReturnServlet` — nhanh `source=pos` khi PayOS xac nhan `PAID` (POS goi PayOS).

Han che/ghi chu:

- Ton kho tinh theo **san pham** (`Products.stock_quantity`), khong theo tung size rieng (DB
  khong co cot ton kho o `Product_Sizes`) — dung lua chon da thong nhat voi nguoi dung, khong doi
  schema. Neu can chinh xac theo size thi phai them cot moi sau nay.
- Khong tru ton kho cho luong checkout online qua gio hang (`/checkout`) vi don o luong nay
  khong bao gio tu dong nhay thang len `DONE` — no phai qua CONFIRMED -> READY_FOR_PICKUP ->
  SHIPPING -> DONE (xem muc 50), va buoc DONE cuoi cung do shipper bam nen da duoc bao phu boi
  hook trong `ShipperOrderServlet`.
- Da bien dich `javac` toan bo `src/main/java` sach loi.

## 52. Module Khieu nai don hang (khach hang gui, Admin xu ly)

Endpoint: `/khieu-nai` (khach hang), `/admin/khieu-nai` (Super Admin)

Module hoan toan moi theo yeu cau roadmap — kiem tra truoc khi lam thi xac nhan **khong trung**
voi `AppealServlet` (`/appeal`) da co san, vi Appeal chi danh cho khang nghi **tai khoan bi
khoa/tu choi**, khong lien quan don hang.

Database moi (`migration_complaints.sql`, nguoi dung can tu chay 1 lan tren DB that):

- Bang `Complaints`: `id, order_id (FK Orders), account_id (FK Accounts), subject, content,
  status (PENDING/PROCESSING/RESOLVED/REJECTED, default PENDING), admin_reply, resolved_by,
  created_at, updated_at`.

Da them backend:

- `src/main/java/org/example/models/Complaint.java` (moi).
- `src/main/java/org/example/daos/ComplaintDAO.java` + `ComplaintDAOImpl.java` (moi) —
  `create`, `findByAccountId`, `findAll`, `findByStatus`, `findById`, `existsByOrderId`,
  `resolve(id, status, adminReply, resolvedBy)`.
- `src/main/java/org/example/controllers/ComplaintServlet.java` (moi, `/khieu-nai`, roleId=3
  nguoi dung thuong) — GET hien form (neu co `orderId`, co kiem tra don thuoc dung khach) + danh
  sach khieu nai da gui cua chinh khach; POST tao khieu nai moi (validate subject/content khong
  rong, don phai thuoc ve khach dang dang nhap).
- `src/main/java/org/example/controllers/AdminComplaintServlet.java` (moi, `/admin/khieu-nai`,
  roleId=1 Super Admin) — GET danh sach + loc theo `status`; POST `action=resolve|reject|processing`
  kem `reply` bat buoc, goi `ComplaintDAO.resolve(...)`.

Da them giao dien:

- `src/main/web/user/khieuNai.jsp` (moi) — form gui khieu nai cho 1 don (khi vao qua link co
  `orderId`) + danh sach khieu nai cua khach kem trang thai va phan hoi Admin (neu co).
- `src/main/web/admin/QuanLyKhieuNai.jsp` (moi) — sidebar/theme dong bo voi cac trang Super Admin
  khac (copy tu `KiemDuyetBinhLuan.jsp`), bo loc theo trang thai, moi khieu nai PENDING/PROCESSING
  co form nhap phan hoi + 2 nut "Giai quyet"/"Tu choi".
- `src/main/web/user/donhang.jsp`: them nut "📢 Khieu nai don nay" cho moi don khac `PENDING`
  (da co tien trien thuc te de khieu nai).
- `src/main/web/admin/KiemDuyetBinhLuan.jsp`: them muc menu "Quan ly khieu nai" vao sidebar de
  dieu huong cheo giua 2 trang kiem duyet/xu ly cua Super Admin.

Phat hien them 1 bug co san khong lien quan truc tiep nhung nam dung vi tri dang sua: JSP
`donhang.jsp` so sanh `order.staTus eq 'DELIVERED'` (ca badge trang thai lan dieu kien hien nut
danh gia Shop/Shipper) trong khi cot `Orders.status` thuc te dung gia tri `DONE` (xem
`Database.md` dong 368) — nghia la nut "Danh gia Shop/Shipper" **chua bao gio hien duoc** tu
truoc den nay. Da sua ca 2 cho tu `'DELIVERED'` thanh `'DONE'`.

Han che/ghi chu:

- Khach co the gui nhieu khieu nai cho cung 1 don (khong gioi han 1 khieu nai/don) — chap nhan
  duoc vi thuc te 1 don co the phat sinh nhieu van de khac nhau; neu muon gioi han thi da co san
  ham `ComplaintDAO.existsByOrderId` de kiem tra truoc khi tao.
- Khong upload anh kem khieu nai (ngoai pham vi lan nay, DB khong co cot luu anh) — chi co
  tieu de + noi dung van ban.
- Da bien dich `javac` toan bo `src/main/java` sach loi.

## 53. Thong bao (Notification) cho khach hang

Endpoint: `/user/thong-bao`

Truoc do bang `Notifications` + `NotificationDAO` da co san nhung **chi dung cho shipper**:
`ShipperOrderServlet`/`ShipperAcceptOrderServlet` tao thong bao voi `accountId = account.getId()`
la chinh tai khoan shipper dang thao tac (nhu 1 nhat ky hoat dong ca nhan qua `/shipper/thongbao`),
khong he gui thong bao cho khach hang dat don. Khach hang chua co man hinh thong bao nao va cung
khong nhan duoc bat ky notification nao khi don hang doi trang thai.

Da them backend:

- `src/main/java/org/example/controllers/UserNotificationServlet.java` (moi, `/user/thong-bao`,
  roleId=3) — GET danh sach + so chua doc (dung lai `NotificationDAO` co san, khong doi schema);
  POST danh dau da doc (1 hoac tat ca), giong het pattern `ShipperNotificationServlet`
  (`/shipper/thongbao`) da co truoc do.
- Them tao thong bao cho **khach hang** (`accountId = order.getUserId()`) tai moi diem don hang
  thuc su doi trang thai co y nghia voi khach:
  - `ShopBillServlet`: xac nhan (`PENDING->CONFIRMED`), chuan bi xong (`CONFIRMED->READY_FOR_PICKUP`),
    huy don (shop huy) — them helper `notifyCustomer(order, title, message)`.
  - `ShipperOrderServlet`: bat dau giao (`READY_FOR_PICKUP->SHIPPING`), giao thanh cong (`->DONE`),
    shipper huy don — them helper `notifyCustomer(...)` tuong tu.
  - `ShipperAcceptOrderServlet`: khi shipper tu nhan don (`/shipper/nhan-don`), gui them 1
    thong bao cho khach "Shipper da nhan don #...".
  - Khong dong cham thong bao shipper-tu-gui-cho-chinh-minh da co san (van giu nguyen, dong vai
    tro nhat ky hoat dong rieng cua shipper).

Da them giao dien:

- `src/main/web/user/thongBao.jsp` (moi) — theme dong bo voi `donhang.jsp`/`khieuNai.jsp`
  (`theme-space.css`, mini-nav), danh sach thong bao co danh dau chua doc/da doc, nut "Danh dau
  tat ca da doc".
- Them link 🔔 "Thong bao" vao mini-nav cua `donhang.jsp`, `khieuNai.jsp`, `diaChi.jsp`, va vao
  navbar chinh + dropdown tai khoan cua `trangnguoidung.jsp` (trang chu) kem **badge so luong
  chua doc** (`UserHomeServlet` set attribute `unreadNotifCount` qua `NotificationDAO.countUnread`).
  Cac trang con lai chi hien link, khong hien badge so (de gioi han pham vi, khong phai goi
  `countUnread` o moi servlet).

Han che/ghi chu:

- Ban dau (khi moi lam mục 53) chi la polling — khach phai vao `/user/thong-bao` hoac reload
  trang moi thay thong bao moi. Da nang cap len realtime qua WebSocket ngay sau do, xem **mục 54**.
- Da bien dich `javac` toan bo `src/main/java` sach loi.

## 54. Nang cap Notification len Realtime qua WebSocket

Endpoint WebSocket: `/ws/notifications`

Tiep tuc mục 53 (luc do chi la polling) — nguoi dung yeu cau lam realtime that su theo dung
pattern da co san cua `TrackingEndpoint` (theo doi vi tri shipper). Thiet ke:

- **Database khong doi** — van dung nguyen bang `Notifications` nhu mục 53, chi bo sung co che
  gui du lieu qua WebSocket, khong them cot/bang nao.
- **Backend:**
  - `src/main/java/org/example/websocket/NotificationEndpoint.java` (moi,
    `@ServerEndpoint("/ws/notifications", configurator = HttpSessionConfigurator.class)`) — tai
    su dung `HttpSessionConfigurator` co san (xac thuc qua `HttpSession` + chan CSWSH bang kiem
    tra Origin, giong het `TrackingEndpoint`). Quan ly `Map<Long accountId, Set<Session>>` bang
    `ConcurrentHashMap`/`CopyOnWriteArraySet` (thread-safe, nhieu tab/thiet bi cung 1 tai khoan
    van nhan duoc). Method static `push(Notification, unreadCount)` gui JSON
    `{id, title, message, unreadCount}` toi moi session dang mo cua dung tai khoan do; bo qua neu
    khong co session nao dang ket noi (khong loi).
  - `NotificationDAOImpl.create(...)`: sau khi INSERT thanh cong (dung `RETURN_GENERATED_KEYS` de
    lay lai id vua tao, truoc do method nay khong lay id), goi luon
    `NotificationEndpoint.push(notification, countUnread(accountId))`. Day la **diem duy nhat**
    tao Notification trong toan bo code (`ShopBillServlet`, `ShipperOrderServlet`,
    `ShipperAcceptOrderServlet` deu goi qua day) nen moi noi tao thong bao tu dong duoc day
    realtime ma khong can sua tung servlet.
- **Frontend:**
  - `src/main/web/assets/js/notifications-ws.js` (moi) — script dung chung: mo `WebSocket` toi
    `/ws/notifications` (tu suy ra `ws://`/`wss://` theo `location.protocol`), tu ket noi lai sau
    5s neu mat ket noi. Khi nhan duoc message: goi `window.showToast('info', ...)` (dung lai
    `toast.js` co san) + cap nhat moi phan tu `[data-notif-badge]` bang so `unreadCount` moi nhat
    + ban su kien DOM tuy chinh `pob-notification` de trang hien tai tu xu ly them.
  - Yeu cau 1 bien toan cuc `window.POB_CONTEXT_PATH` duoc set truoc khi include script (vi JS
    tinh khong doc duoc EL `${pageContext.request.contextPath}`).
  - Da gan vao: `user/trangnguoidung.jsp` (bell 🔔 co `[data-notif-badge]` cap nhat realtime,
    khong can reload trang chu nua), `user/donhang.jsp`, `user/khieuNai.jsp`, `user/diaChi.jsp`
    (toast + badge, chua co UI danh sach nen khong can lam gi them), `user/thongBao.jsp` va
    `shipper/thongbao.jsp` (nghe them su kien `pob-notification`, tu `reload()` sau 1.2s de danh
    sach hien dung thong bao moi nhat vi 2 trang nay dang hien thi truc tiep danh sach).

Han che/ghi chu:

- Khong dung message ACK/queue — neu client dang offline (dong tab/mat mang) luc Notification duoc
  tao, `push()` don gian bo qua; nguoi dung van thay duoc thong bao do khi mo lai `/user/thong-bao`
  vi da luu trong DB tu truoc (chi mat phan "realtime", khong mat du lieu).
  - `notifications-ws.js` tu ket noi lai sau 5s neu WebSocket bi dong bat ngo, nhung khong co gioi
  han so lan thu — chap nhan duoc voi quy mo do an, can luu y neu mo rong production that.
- Da bien dich `javac` toan bo `src/main/java` sach loi.
