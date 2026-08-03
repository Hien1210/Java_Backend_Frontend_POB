<%@ page pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Đơn hàng của tôi - POBFood</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/user-theme.css">
<link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/orderTrackingMap.js"></script>
<style>
:root {
    --bg:         #FFFBF8;
    --surface:    #FFFFFF;
    --surface-lt: #FFF4EC;
    --gold:       #FF5A1F;
    --gold-hover: #E14A0F;
    --text:       #241C15;
    --muted:      #8A7B6C;
    --border:     #F1E4D6;
    --font-h: 'Plus Jakarta Sans', sans-serif;
    --font-b: 'Plus Jakarta Sans', sans-serif;
    --tr: all 0.3s ease;
    --shadow: 0 14px 34px rgba(60,30,10,.14);
    --success: #15803D; --warning: #C2660A; --info: #1D4ED8; --danger: #E11D48;
}
*, *::before, *::after { margin: 0; padding: 0; box-sizing: border-box; }
body { font-family: var(--font-b); background: var(--bg); color: var(--text); min-height: 100vh; }
a { text-decoration: none; color: inherit; transition: var(--tr); }

/* NAVBAR (đồng bộ với trang chủ user/trangnguoidung.jsp) */
.navbar {
    position: sticky; top: 0; left: 0; width: 100%;
    background: rgba(255,251,248,.92);
    backdrop-filter: blur(14px);
    z-index: 1000;
    border-bottom: 1px solid var(--border);
}
.nav-content {
    max-width: 1180px; margin: 0 auto; padding: 0 20px;
    display: flex; justify-content: space-between; align-items: center; height: 76px; gap: 16px;
}
.logo { display: flex; align-items: center; gap: 8px; flex-shrink: 0; }
.logo h1 { font-family: var(--font-h); font-size: 1.55rem; letter-spacing: -.5px; }
.logo span { color: var(--gold); }
.logo-emoji { width: 30px; height: 30px; filter: drop-shadow(0 4px 8px rgba(255,90,31,.4)); }
.nav-links { display: flex; gap: 20px; align-items: center; }
.nav-links a { font-size: .86rem; font-weight: 600; color: var(--muted); white-space: nowrap; }
.nav-links a:hover, .nav-links a.active { color: var(--gold); }
.nav-actions { display: flex; align-items: center; gap: 14px; }
.nav-search { position: relative; }
.nav-search input {
    background: var(--surface-lt); border: 1.5px solid var(--border); border-radius: 50px;
    color: var(--text); font-family: var(--font-b); font-size: .85rem;
    padding: 9px 16px 9px 38px; width: 200px; transition: var(--tr);
}
.nav-search input:focus { outline: none; border-color: var(--gold); width: 240px; background: var(--surface); }
.nav-search input::placeholder { color: var(--muted); }
.nav-search i { position: absolute; left: 14px; top: 50%; transform: translateY(-50%); color: var(--muted); font-size: .85rem; pointer-events: none; }
.avatar-wrap { position: relative; }
.avatar-btn {
    width: 38px; height: 38px; border-radius: 50%;
    background: linear-gradient(135deg, var(--gold), var(--gold-hover));
    color: #FFF; font-size: 14px; font-weight: 800;
    border: none; cursor: pointer; font-family: var(--font-b);
    display: flex; align-items: center; justify-content: center;
    box-shadow: 0 8px 22px rgba(255,90,31,.3);
}
.avatar-dropdown {
    position: absolute; top: calc(100% + 12px); right: 0;
    background: var(--surface); border: 1px solid var(--border); border-radius: 16px;
    min-width: 220px; z-index: 200;
    display: none; box-shadow: var(--shadow);
    overflow: hidden;
}
.avatar-dropdown.open { display: block; }
.dd-head { padding: 16px 18px; border-bottom: 1px solid var(--border); background: var(--surface-lt); }
.dd-name { font-size: 14px; font-weight: 700; color: var(--text); }
.dd-email { font-size: 11.5px; color: var(--muted); margin-top: 3px; }
.dd-link, .dd-btn {
    display: flex; align-items: center; gap: 10px;
    width: 100%; padding: 12px 18px;
    font-size: 13px; font-weight: 600; color: var(--muted);
    background: none; border: none; cursor: pointer;
    font-family: var(--font-b); transition: var(--tr); text-align: left;
}
.dd-link i, .dd-btn i { color: var(--gold); width: 14px; }
.dd-link:hover, .dd-btn:hover { background: var(--surface-lt); color: var(--text); }
.dd-divider { height: 1px; background: var(--border); margin: 4px 0; }
.cart-btn {
    width: 38px; height: 38px; border-radius: 50%;
    display: flex; align-items: center; justify-content: center;
    background: var(--surface-lt); border: 1.5px solid var(--border); color: var(--text);
    font-size: 15px; transition: var(--tr); flex-shrink: 0; text-decoration: none;
}
.cart-btn:hover { border-color: var(--gold); color: var(--gold); }
@media (max-width: 860px) { .nav-links, .nav-search { display: none; } }

/* CONTAINER */
.container { max-width: 780px; margin: 0 auto; padding: 44px 20px 80px; }

/* ALERTS */
.alert {
    display: flex; align-items: center; gap: 10px;
    padding: 14px 18px; margin-bottom: 20px; border-radius: 14px;
    border: 1px solid; font-size: .9rem; font-weight: 600;
}
.alert-success { background: #EAFBF1; border-color: #BBF0CF; color: #15803D; }
.alert-danger  { background: #FEECEF; border-color: #FBD0D8; color: #E11D48; }

/* SECTION HEADER */
.section-header { margin-bottom: 28px; }
.section-header h2 { font-family: var(--font-h); font-size: 1.9rem; color: var(--text); letter-spacing: -.5px; }
.section-header .sub { font-size: .88rem; color: var(--muted); margin-top: 4px; font-weight: 500; }

/* EMPTY */
.empty-state {
    text-align: center; padding: 70px 24px; border-radius: 22px;
    background: var(--surface); border: 1px dashed var(--border);
}
.empty-state img { width: 90px; height: 90px; margin-bottom: 18px; filter: drop-shadow(0 12px 18px rgba(60,30,10,.2)); animation: donhang-float 4s ease-in-out infinite; }
@keyframes donhang-float { 0%,100% { transform: translateY(0); } 50% { transform: translateY(-10px); } }
.empty-state h3 { font-family: var(--font-h); font-size: 1.3rem; color: var(--text); margin-bottom: 8px; }
.empty-state p { font-size: .9rem; color: var(--muted); }
.link-gold { color: var(--gold); font-weight: 700; }
.link-gold:hover { color: var(--gold-hover); text-decoration: underline; }

/* ORDER LIST */
.order-list { display: flex; flex-direction: column; gap: 18px; }
.order-card {
    background: var(--surface); border: 1.5px solid var(--border); border-radius: 20px;
    transition: var(--tr); padding: 24px;
    box-shadow: 0 2px 12px rgba(60,30,10,.05);
}
.order-card:hover { border-color: var(--gold); box-shadow: var(--shadow); transform: translateY(-2px); }

.order-top { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 14px; flex-wrap: wrap; gap: 10px; }
.order-id { font-family: var(--font-h); font-size: 1.15rem; color: var(--text); font-weight: 800; }
.order-shop { font-size: .85rem; color: var(--gold); margin-top: 3px; font-weight: 700; }

/* BADGE */
.badge {
    display: inline-flex; align-items: center; gap: 5px;
    padding: 6px 14px; font-size: .75rem; font-weight: 700; border-radius: 50px;
    letter-spacing: .2px; border: 1px solid;
    font-family: var(--font-b);
}
.badge-pending  { border-color: #FFDCB0; color: #C2660A; background: #FFF3E0; }
.badge-info     { border-color: #C4D7FC; color: #1D4ED8; background: #EAF1FE; }
.badge-primary  { border-color: #FFD3B8; color: var(--gold); background: #FFF1E8; }
.badge-success  { border-color: #BBF0CF; color: #15803D; background: #EAFBF1; }
.badge-danger   { border-color: #FBD0D8; color: #E11D48; background: #FEECEF; }
.badge-neutral  { border-color: var(--border);  color: var(--muted);   background: var(--surface-lt); }

.order-meta { display: flex; flex-direction: column; gap: 6px; margin-bottom: 16px; }
.order-meta-row { display: flex; align-items: center; gap: 8px; font-size: .85rem; color: var(--muted); font-weight: 500; }
.order-meta-row i { color: var(--gold); width: 14px; font-size: .8rem; }
.order-price { font-size: 1rem; font-weight: 700; color: var(--text); margin-bottom: 18px; }
.order-price span { color: var(--gold); font-family: var(--font-h); font-size: 1.15rem; font-weight: 800; }

.divider { height: 1px; background: var(--border); margin-bottom: 18px; }

/* TRACKING MAP */
.shop-marker-icon { background: none; border: none; font-size: 22px; line-height: 24px; text-align: center; }
.tracking-map { height: 220px; border-radius: 14px; margin-bottom: 18px; overflow: hidden; }

/* FEEDBACK BUTTONS */
.fb-row { display: flex; gap: 10px; flex-wrap: wrap; }
.btn-fb {
    display: inline-flex; align-items: center; gap: 6px;
    padding: 9px 18px; font-size: .8rem; font-weight: 700; border-radius: 50px;
    cursor: pointer; border: 1.5px solid; transition: var(--tr);
    font-family: var(--font-b);
    background: transparent; text-decoration: none;
}
.btn-fb-shop    { border-color: #FFDCB0; color: #C2660A; }
.btn-fb-shop:hover    { background: #FFF3E0; }
.btn-fb-shipper { border-color: #C4D7FC; color: #1D4ED8; }
.btn-fb-shipper:hover { background: #EAF1FE; }
.btn-fb-done    { border-color: var(--border); color: var(--muted); cursor: default; background: var(--surface-lt); }
</style>
</head>
<body>

<<<<<<< HEAD
<<<<<<< HEAD
<!-- Navbar mini -->
<div class="mini-nav">
    <div class="logo">POB</div>
    <span class="title">Đơn hàng của tôi</span>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/user/dia-chi">📍 Địa chỉ</a>
        <a href="${pageContext.request.contextPath}/user/thong-bao">🔔 Thông báo</a>
        <a href="${pageContext.request.contextPath}/user/home">← Trang chủ</a>
=======
<nav class="navbar">
    <div class="nav-logo">POBFood<span>.</span></div>
    <div class="nav-sep"></div>
    <span class="nav-title">Đơn hàng của tôi</span>
    <div class="nav-right">
        <a href="${pageContext.request.contextPath}/user/dia-chi" class="nav-link">
            <i class="fa-solid fa-location-dot"></i> Địa chỉ
        </a>
        <a href="${pageContext.request.contextPath}/user/home" class="nav-link">
            <i class="fa-solid fa-house"></i> Trang chủ
        </a>
>>>>>>> origin/DUNGLAILAPTRINH_00306
=======
<header class="navbar">
    <div class="nav-content">
        <div class="logo">
            <img class="logo-emoji" src="https://cdn.jsdelivr.net/gh/microsoft/fluentui-emoji@main/assets/Steaming%20bowl/3D/steaming_bowl_3d.png" alt="">
            <h1>POBFood<span>.</span></h1>
        </div>

        <nav class="nav-links">
            <a href="${pageContext.request.contextPath}/user/home">Trang chủ</a>
            <a href="${pageContext.request.contextPath}/user/home#restaurants">Nhà hàng</a>
            <a href="${pageContext.request.contextPath}/user/donhang" class="active">Đơn hàng</a>
            <a href="${pageContext.request.contextPath}/user/dia-chi">Địa chỉ</a>
            <a href="${pageContext.request.contextPath}/user/diem-thuong">Điểm thưởng</a>
        </nav>

        <div class="nav-actions">
            <div class="nav-search">
                <i class="fa-solid fa-magnifying-glass"></i>
                <input id="navSearch" type="text" placeholder="Tìm quán, món ăn..."
                       onkeydown="if(event.key==='Enter'){event.preventDefault();window.location.href='${pageContext.request.contextPath}/user/home#restaurants';}">
            </div>

            <div class="avatar-wrap" id="avatarWrap">
                <button class="avatar-btn" onclick="toggleDropdown()" aria-label="Tài khoản">
                    ${fn:substring(not empty account.fullName ? account.fullName : account.userName, 0, 1)}
                </button>
                <div class="avatar-dropdown" id="accountDropdown">
                    <div class="dd-head">
                        <div class="dd-name">${not empty account.fullName ? account.fullName : account.userName}</div>
                        <c:if test="${not empty account.email}"><div class="dd-email">${account.email}</div></c:if>
                    </div>
                    <a href="${pageContext.request.contextPath}/user/donhang" class="dd-link">
                        <i class="fa-solid fa-box"></i> Đơn hàng của tôi
                    </a>
                    <a href="${pageContext.request.contextPath}/user/dia-chi" class="dd-link">
                        <i class="fa-solid fa-location-dot"></i> Địa chỉ giao hàng
                    </a>
                    <a href="${pageContext.request.contextPath}/user/diem-thuong" class="dd-link">
                        <i class="fa-solid fa-star"></i> Điểm thưởng & Voucher
                    </a>
                    <a href="${pageContext.request.contextPath}/user/thong-bao" class="dd-link">
                        <i class="fa-solid fa-bell"></i> Thông báo
                    </a>
                    <a href="${pageContext.request.contextPath}/user/cart" class="dd-link">
                        <i class="fa-solid fa-cart-shopping"></i> Giỏ hàng
                    </a>
                    <a href="${pageContext.request.contextPath}/user/doi-mat-khau" class="dd-link">
                        <i class="fa-solid fa-lock"></i> Đổi mật khẩu
                    </a>
                    <div class="dd-divider"></div>
                    <form action="${pageContext.request.contextPath}/logout" method="post">
                        <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                        <button type="submit" class="dd-btn">
                            <i class="fa-solid fa-right-from-bracket"></i> Đăng xuất
                        </button>
                    </form>
                </div>
            </div>

            <a href="${pageContext.request.contextPath}/user/thong-bao" class="cart-btn" aria-label="Thông báo" style="position:relative;">
                <i class="fa-solid fa-bell"></i>
                <span data-notif-badge style="display:${unreadNotifCount > 0 ? 'inline-block' : 'none'};position:absolute;top:2px;right:2px;background:#ef4444;color:#fff;border-radius:999px;font-size:10px;min-width:16px;height:16px;line-height:16px;text-align:center;padding:0 3px;font-weight:700;">${unreadNotifCount}</span>
            </a>

            <a href="${pageContext.request.contextPath}/user/cart" class="cart-btn" aria-label="Giỏ hàng">
                <i class="fa-solid fa-bag-shopping"></i>
            </a>
        </div>
>>>>>>> GiaHung_TY00316
    </div>
</header>

<div class="container">

    <c:if test="${param.success eq '1'}">
        <div class="alert alert-success"><i class="fa-solid fa-circle-check"></i> Đánh giá của bạn đã được gửi thành công!</div>
    </c:if>
    <c:if test="${param.error eq '1'}">
        <div class="alert alert-danger"><i class="fa-solid fa-circle-exclamation"></i> Không thể gửi đánh giá. Vui lòng thử lại.</div>
    </c:if>

    <div class="section-header">
        <h2>Lịch Sử Đơn Hàng</h2>
        <p class="sub">Theo dõi và đánh giá các đơn hàng đã đặt</p>
    </div>

    <c:choose>
        <c:when test="${empty orders}">
            <div class="empty-state">
                <img src="https://cdn.jsdelivr.net/gh/microsoft/fluentui-emoji@main/assets/Package/3D/package_3d.png" alt="">
                <h3>Chưa có đơn hàng nào</h3>
                <p>Hãy khám phá các nhà hàng và đặt món ngay!</p>
                <a href="${pageContext.request.contextPath}/user/home" class="link-gold" style="display:inline-block;margin-top:16px;">
                    Khám phá ngay <i class="fa-solid fa-arrow-right"></i>
                </a>
            </div>
        </c:when>
        <c:otherwise>
            <div class="order-list">
                <c:forEach var="order" items="${orders}">
                    <div class="order-card">
                        <div class="order-top">
                            <div>
                                <div class="order-id">Đơn #${order.id}</div>
                                <div class="order-shop"><i class="fa-solid fa-store"></i> ${shopNames[order.shopId]}</div>
                            </div>
                            <span class="badge
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> GiaHung_TY00316
                                ${order.staTus == 'PENDING' ? 'badge-warning' :
                                  order.staTus == 'WAITING_FOR_SHIPPER' ? 'badge-info' :
                                  order.staTus == 'ACCEPTED' ? 'badge-info' :
                                  order.staTus == 'READY_FOR_PICKUP' ? 'badge-primary' :
                                  order.staTus == 'SHIPPING' ? 'badge-warning' :
                                  order.staTus == 'DONE' ? 'badge-success' :
                                  order.staTus == 'CANCELLED' ? 'badge-danger' : 'badge-neutral'}">
                                <c:choose>
                                    <c:when test="${order.staTus eq 'PENDING'}">⏳ Chờ xác nhận</c:when>
                                    <c:when test="${order.staTus eq 'WAITING_FOR_SHIPPER'}">👨‍🍳 Đang chuẩn bị & Tìm tài xế</c:when>
                                    <c:when test="${order.staTus eq 'ACCEPTED'}">🛵 Tài xế đã nhận (Đang chuẩn bị)</c:when>
                                    <c:when test="${order.staTus eq 'READY_FOR_PICKUP'}">📦 Chờ shipper lấy hàng</c:when>
                                    <c:when test="${order.staTus eq 'SHIPPING'}">🛵 Đang giao</c:when>
                                    <c:when test="${order.staTus eq 'DONE'}">🎉 Đã giao</c:when>
                                    <c:when test="${order.staTus eq 'CANCELLED'}">❌ Đã huỷ</c:when>
<<<<<<< HEAD
=======
                                ${order.staTus == 'PENDING'          ? 'badge-pending'  :
                                  order.staTus == 'CONFIRMED'        ? 'badge-info'     :
                                  order.staTus == 'READY_FOR_PICKUP' ? 'badge-primary'  :
                                  order.staTus == 'SHIPPING'         ? 'badge-pending'  :
                                  order.staTus == 'DELIVERED'        ? 'badge-success'  :
                                  order.staTus == 'CANCELLED'        ? 'badge-danger'   : 'badge-neutral'}">
                                <c:choose>
                                    <c:when test="${order.staTus eq 'PENDING'}"><i class="fa-solid fa-clock"></i> Chờ xác nhận</c:when>
                                    <c:when test="${order.staTus eq 'CONFIRMED'}"><i class="fa-solid fa-circle-check"></i> Đã xác nhận</c:when>
                                    <c:when test="${order.staTus eq 'READY_FOR_PICKUP'}"><i class="fa-solid fa-box"></i> Chờ shipper</c:when>
                                    <c:when test="${order.staTus eq 'SHIPPING'}"><i class="fa-solid fa-motorcycle"></i> Đang giao</c:when>
                                    <c:when test="${order.staTus eq 'DELIVERED'}"><i class="fa-solid fa-check-double"></i> Đã giao</c:when>
                                    <c:when test="${order.staTus eq 'CANCELLED'}"><i class="fa-solid fa-xmark"></i> Đã huỷ</c:when>
>>>>>>> origin/DUNGLAILAPTRINH_00306
=======
>>>>>>> GiaHung_TY00316
                                    <c:otherwise>${order.staTus}</c:otherwise>
                                </c:choose>
                            </span>
                        </div>

                        <div class="order-meta">
                            <div class="order-meta-row">
                                <i class="fa-solid fa-location-dot"></i>
                                <span>${order.shippingAddress}</span>
                            </div>
                            <div class="order-meta-row">
                                <i class="fa-solid fa-credit-card"></i>
                                <span>${order.paymentMethod}</span>
                            </div>
                        </div>

<<<<<<< HEAD
<<<<<<< HEAD
                        <!-- Nút đánh giá chỉ khi DONE -->
                        <c:if test="${order.staTus eq 'DONE'}">
=======
=======
>>>>>>> GiaHung_TY00316
                        <div class="order-price">
                            Tổng: <span><fmt:formatNumber value="${order.totalPrice}" type="number" groupingUsed="true"/> đ</span>
                        </div>

                        <c:if test="${order.staTus eq 'SHIPPING'}">
                            <div id="map-${order.id}" class="tracking-map"></div>
                        </c:if>

<<<<<<< HEAD
                        <c:if test="${order.staTus eq 'DELIVERED'}">
                            <div class="divider"></div>
>>>>>>> origin/DUNGLAILAPTRINH_00306
=======
                        <!-- Nút đánh giá chỉ khi DONE -->
                        <c:if test="${order.staTus eq 'DONE'}">
>>>>>>> GiaHung_TY00316
                            <div class="fb-row">
                                <c:choose>
                                    <c:when test="${feedbackShop[order.id]}">
                                        <span class="btn-fb btn-fb-done"><i class="fa-solid fa-check"></i> Đã đánh giá Shop</span>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="${pageContext.request.contextPath}/feedback?orderId=${order.id}&targetType=SHOP" class="btn-fb btn-fb-shop">
                                            <i class="fa-solid fa-star"></i> Đánh giá Shop
                                        </a>
                                    </c:otherwise>
                                </c:choose>
                                <c:if test="${order.shipperId != 0}">
                                    <c:choose>
                                        <c:when test="${feedbackShipper[order.id]}">
                                            <span class="btn-fb btn-fb-done"><i class="fa-solid fa-check"></i> Đã đánh giá Shipper</span>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="${pageContext.request.contextPath}/feedback?orderId=${order.id}&targetType=SHIPPER" class="btn-fb btn-fb-shipper">
                                                <i class="fa-solid fa-motorcycle"></i> Đánh giá Shipper
                                            </a>
                                        </c:otherwise>
                                    </c:choose>
                                </c:if>
                            </div>
                        </c:if>
<<<<<<< HEAD
<<<<<<< HEAD
=======

                        <!-- Hoàn tiền: chỉ khi đã CANCELLED và đã PAID (payment_status = REFUNDED) -->
                        <c:if test="${order.staTus eq 'CANCELLED' and order.paymentStatus eq 'REFUNDED'}">
                            <div class="fb-row" style="margin-top:6px;">
                                <a href="${pageContext.request.contextPath}/user/yeu-cau-hoan-tien?orderId=${order.id}"
                                   class="btn-fb" style="background:rgba(220,38,38,.1);color:#dc2626;border-color:rgba(220,38,38,.3);font-weight:700;">
                                    ↩️ Yêu cầu hoàn tiền
                                </a>
                            </div>
                        </c:if>
>>>>>>> GiaHung_TY00316

                        <!-- Khiếu nại: cho phép với mọi đơn không phải PENDING (đã có tiến triển thực tế để khiếu nại) -->
                        <c:if test="${order.staTus ne 'PENDING'}">
                            <div class="fb-row" style="margin-top:6px;">
                                <a href="${pageContext.request.contextPath}/khieu-nai?orderId=${order.id}" class="btn-fb" style="background:rgba(248,113,113,.12);color:var(--danger);border-color:rgba(248,113,113,.4);">📢 Khiếu nại đơn này</a>
                            </div>
                        </c:if>
<<<<<<< HEAD

=======
>>>>>>> origin/DUNGLAILAPTRINH_00306
=======
>>>>>>> GiaHung_TY00316
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>

</div>
<<<<<<< HEAD
<<<<<<< HEAD
<script>window.POB_CONTEXT_PATH = '${pageContext.request.contextPath}';</script>
<script src="${pageContext.request.contextPath}/assets/js/toast.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/notifications-ws.js"></script>
=======

=======
>>>>>>> GiaHung_TY00316
<script>
    (function () {
        var protocol = location.protocol === 'https:' ? 'wss://' : 'ws://';
        var contextPath = '${pageContext.request.contextPath}';
        <c:forEach var="order" items="${orders}">
        <c:if test="${order.staTus eq 'SHIPPING'}">
        (function () {
            var shopLat = ${not empty shopCoords[order.shopId] ? shopCoords[order.shopId][0] : 'null'};
            var shopLng = ${not empty shopCoords[order.shopId] ? shopCoords[order.shopId][1] : 'null'};
            var destLat = ${not empty order.locationX ? order.locationX : 'null'};
            var destLng = ${not empty order.locationY ? order.locationY : 'null'};
            var wsUrl = protocol + location.host + contextPath + '/ws/tracking?role=customer&orderId=${order.id}';
            initOrderTrackingMap('map-${order.id}', shopLat, shopLng, destLat, destLng, wsUrl);
        })();
        </c:if>
        </c:forEach>
    })();
</script>
<<<<<<< HEAD
>>>>>>> origin/DUNGLAILAPTRINH_00306
=======

<script>
function toggleDropdown() {
    document.getElementById('accountDropdown').classList.toggle('open');
}
document.addEventListener('click', function(e) {
    var w = document.getElementById('avatarWrap');
    if (w && !w.contains(e.target)) document.getElementById('accountDropdown').classList.remove('open');
});
</script>
<script>window.POB_CONTEXT_PATH = '${pageContext.request.contextPath}';</script>
<script src="${pageContext.request.contextPath}/assets/js/toast.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/pob-dialog.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/notifications-ws.js"></script>
>>>>>>> GiaHung_TY00316
</body>
</html>
