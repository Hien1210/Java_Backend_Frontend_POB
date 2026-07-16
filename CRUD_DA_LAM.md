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

## 20. Tu dong dien "Thong tin nhan hang" tu tai khoan khi Checkout

Endpoint: `/checkout`

Nguoi dung phan anh trang xac nhan hoa don (`checkoutThanhToan.jsp`) co 3 o "Ten nguoi nhan",
"So dien thoai", "Dia chi giao hang" nhung luon de trong, bat nguoi dung phai tu go lai du da co
san thong tin tai khoan/dia chi da luu. Kiem tra thi `CheckoutServlet.doGet()` (muc 7) **da san**
set attribute `account` va `defaultAddress` (dia chi mac dinh cua user, lay qua
`UserAddressDAO.findByAccountId`), nhung `checkoutThanhToan.jsp` chua bao gio doc 2 attribute nay
— ca 3 o chi bind `${param.*}` (rong o lan GET dau tien).

Da sua (chi JSP, khong doi backend):

- `src/main/web/checkoutThanhToan.jsp`: 3 o input doi `value` uu tien theo thu tu
  `param.* (gia tri vua submit khi loi validate) -> defaultAddress.* (dia chi mac dinh da luu) ->
  account.fullName/account.phone (rieng ten/sdt, dia chi khong co fallback tai khoan vi Account
  khong luu dia chi)`.

Chuc nang da co:

- Vao `/checkout` lan dau (chua nhap gi): neu user co dia chi mac dinh trong `UserAddresses` thi
  3 o tu dien san ten/sdt/dia chi cua dia chi do; neu chua co dia chi nao thi fallback dien
  ten/sdt theo ho so tai khoan (dia chi de trong). Nguoi dung van sua duoc binh thuong truoc khi
  xac nhan.
- Neu submit loi validate (vd bo trong 1 o), form re-render giu dung gia tri nguoi dung vua nhap
  (khong bi ghi de lai boi dia chi mac dinh).

Loi phat sinh sau khi chay thuc te tren Tomcat: `/checkout` (GET) nem
`SQLServerException: Invalid column name 'account_id'` tu `UserAddressDAOImpl.findByAccountId()`.
Da ket noi truc tiep DB that (14.225.217.109) qua `DatabaseMetaData.getColumns` de doi chieu, xac
nhan bang `User_Addresses` thuc te dung cot `user_id` (khong phai `account_id`) va `address`
(khong phai `full_address`), dung khop voi comment co san trong `models/UserAddress.java`
(`// maps to DB column: user_id`, `// maps to DB column: address`) — chi rieng
`UserAddressDAOImpl.java` la sai/chua bao gio khop schema that. Da sua toan bo SQL trong
`daos/UserAddressDAOImpl.java` (`findByAccountId`, `findById`, `create`, `update`, `setDefault`,
`map`) sang dung `user_id`/`address`; `delete()` doi tu DELETE cung thanh xoa mem
(`is_deleted = 1`, cot nay co san tren `User_Addresses` that nhung truoc do khong duoc dung) cho
dong bo pattern xoa mem cua cac module khac; `findByAccountId`/`findById` them dieu kien
`is_deleted = 0`. Da compile lai toan bo `src/main/java`, khong loi.

## 21. Thieu Servlet cho trang "Dia chi giao hang" cua user (404)

Endpoint: `/user/dia-chi`

Trang `src/main/web/user/diaChi.jsp` da co san day du giao dien (danh sach dia chi, modal
them/sua/xoa/dat mac dinh, form POST toi `/user/dia-chi` voi param `action=create|update|delete|setDefault`)
va cac trang khac (`trangnguoidung.jsp`, `donhang.jsp`) da co san link toi `/user/dia-chi`, nhung
**chua co Servlet nao map URL nay** -> bam vao luon ra loi 404.

Da them moi:

- `src/main/java/org/example/controllers/UserAddressServlet.java` (`@WebServlet("/user/dia-chi")`),
  theo dung pattern cac servlet `/user/*` khac (vd `UserOrderServlet`): kiem tra session
  `account` + `roleId == 3` (customer), neu chua dang nhap thi redirect `/dangnhap`.
  - GET: lay danh sach dia chi cua user (`userAddressDAO.findByAccountId`), forward
    `user/diaChi.jsp`.
  - POST `action=create`: validate `fullAddress`/`receiverName`/`receiverPhone` khong rong, tao
    dia chi moi; neu tick "Dat lam mac dinh" thi goi them `setDefault` sau khi tao (vi
    `UserAddressDAO.create()` khong tra ve id ban vua tao, phai doc lai danh sach de lay ban moi
    nhat).
  - POST `action=update`/`delete`/`setDefault`: kiem tra dia chi dung thuoc ve user dang dang
    nhap (`existing.getAccountId() == account.getId()`) truoc khi cho sua/xoa/dat mac dinh, tranh
    user A sua duoc dia chi cua user B qua sua `id` tren URL.
  - Redirect ve `/user/dia-chi?success=...`/`?error=missing` dung theo cac ma `param.success`/
    `param.error` ma `diaChi.jsp` da doc san (`created`/`updated`/`deleted`/`default`/`missing`).

Chuc nang da co:

- User bam "📍 Dia chi" tu trang chu hoac trang don hang -> xem danh sach dia chi da luu -> them
  moi, sua, xoa (dia chi khong phai mac dinh), dat 1 dia chi lam mac dinh.
- Dia chi mac dinh nay chinh la dia chi duoc `CheckoutServlet` (muc 20) doc de tu dien form khi
  thanh toan.

Da compile lai toan bo `src/main/java`, khong loi.

## 22. Chon vi tri tren ban do (Leaflet.js + OpenStreetMap) cho dia chi

Endpoint: `/user/dia-chi`, `/checkout`

Truoc day dia chi giao hang chi la text tu do (`fullAddress`), khong co toa do, nen shipper/App
khong the dinh vi chinh xac diem giao hang. Yeu cau: cho phep nguoi dung ghim vi tri tren ban do
khi tao/sua dia chi, luu lai toa do, va mang toa do do di theo tung don hang.

Da them moi / Da sua:

- `models/UserAddress.java` va `models/Order.java`: them 2 field moi `Double locationX` (=
  **vi do - latitude**) va `Double locationY` (= **kinh do - longitude**), co the null (dia chi/
  don hang tao truoc feature nay se khong co toa do).
- `daos/UserAddressDAOImpl.java`: doc/ghi 2 cot `locationX`/`locationY` co san tren bang
  `User_Addresses` (xac nhan qua `DatabaseMetaData.getColumns` khi ket noi DB that — cot da co
  san tu truoc, khong can migration).
- `daos/OrderDAOImpl.java`: DAO nay tu do ten cot qua mang candidate (schema-introspecting), da
  them `locationX`/`locationY` vao danh sach candidate de doc/ghi 2 cot cung ten tren bang
  `Orders` (cung da co san, khong migration).
- `controllers/UserAddressServlet.java` (`/user/dia-chi`):
  - `action=create`/`update` gio **bat buoc** phai co `locationX` va `locationY` (khong con la
    optional) — thieu 1 trong 2 thi redirect ve `?error=missing`, ap dung ca cho dia chi cu
    (legacy, tao truoc feature nay) khi sua: phai chon lai vi tri tren ban do moi luu duoc.
  - Them 2 param optional moi: `returnTo=checkout&cartId=<id>` — neu co, sau khi
    create/update/... xong se redirect ve `/checkout?cartId=<id>` thay vi `/user/dia-chi` (dung
    cho modal dia chi ngay trong trang checkout, xem muc duoi).
- `src/main/web/user/diaChi.jsp` (trang "Dia chi cua toi"): ca modal Them moi va modal Sua deu
  co them 1 ban do Leaflet nhung (OpenStreetMap tile layer, tim kiem dia chi qua Nominatim
  geocode/reverse-geocode) de bam chon toa do; 3 ham JS dung chung `initAddressMap`,
  `toggleMap`, `validateAddressForm` (validate phia client: bat buoc phai co toa do truoc khi
  submit form, khop voi validate phia server o servlet).
- `controllers/CheckoutServlet.java`:
  - `doGet`: them attribute `hasLocation` (boolean) — `true` khi dia chi mac dinh (`defaultAddress`,
    xem muc 20) cua user co ca `locationX` va `locationY`.
  - `doPost`: doc them 2 param `orderLocationX`/`orderLocationY` tu form checkout, luu vao
    moi `Order` duoc tao trong don hang.
- `src/main/web/checkoutThanhToan.jsp`: **(da bi mot merge sau nay ghi de mat, xem muc 26 de biet
  ban hien tai)**. Thiet ke ban dau la 1 modal "Them/Sua dia chi" POST thang toi
  `/user/dia-chi?returnTo=checkout&cartId=<id>`; ban hien tai (sau muc 26) la 1 ban do Leaflet
  chon vi tri ngay tren trang, khong redirect, va dung ten param `locationX`/`locationY` (khong
  con `orderLocationX`/`orderLocationY`).

Quy uoc toa do: **`locationX` = vi do (latitude)`, `locationY` = kinh do (longitude)`** — dung
chung cho ca `UserAddress` va `Order`.

Chuc nang da co:

- Tao/sua dia chi o trang "Dia chi cua toi" -> bam vao ban do (hoac tim kiem dia chi qua thanh
  tim kiem dung Nominatim) de ghim vi tri -> bat buoc phai chon vi tri moi luu duoc dia chi.
- O trang checkout, neu dia chi mac dinh chua co toa do (`hasLocation=false`), nguoi dung co the
  mo modal them/sua dia chi ngay tai checkout (khong can rời trang) de bo sung toa do, xong quay
  lai checkout tiep tuc thanh toan.
- Toa do dia chi mac dinh tai thoi diem dat hang duoc luu lai tren tung `Order` (qua
  `orderLocationX`/`orderLocationY`), doc lap voi dia chi (neu sau nay user sua/xoa dia chi thi
  don hang cu van giu nguyen toa do da chot luc dat).

Da compile lai toan bo `src/main/java`, khong loi.

## 23. Xem vi tri giao hang tren ban do (phia shop)

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
