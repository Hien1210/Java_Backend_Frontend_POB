<%@ page pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
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

/* NAVBAR */
.navbar {
    background: rgba(255,251,248,.92); backdrop-filter: blur(14px);
    border-bottom: 1px solid var(--border);
    height: 74px; display: flex; align-items: center;
    padding: 0 30px; position: sticky; top: 0; z-index: 100;
    gap: 16px;
}
.nav-logo { font-family: var(--font-h); font-size: 1.55rem; font-weight: 800; letter-spacing: -.5px; }
.nav-logo span { color: var(--gold); }
.nav-title { font-size: .95rem; font-weight: 700; color: var(--text); }
.nav-sep { width: 1px; height: 20px; background: var(--border); }
.nav-right { margin-left: auto; display: flex; gap: 10px; }
.nav-link {
    display: inline-flex; align-items: center; gap: 7px;
    padding: 9px 18px; font-size: .85rem; font-weight: 700;
    color: var(--muted); border: 1.5px solid var(--border); border-radius: 50px; transition: var(--tr);
}
.nav-link:hover { color: var(--gold); border-color: var(--gold); background: var(--surface-lt); }

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

<nav class="navbar">
    <div class="nav-logo">POBFood<span>.</span></div>
    <div class="nav-sep"></div>
    <span class="nav-title">Đơn hàng của tôi</span>
    <div class="nav-right">
        <a href="${pageContext.request.contextPath}/user/dia-chi" class="nav-link">
            <i class="fa-solid fa-location-dot"></i> Địa chỉ
        </a>
        <a href="${pageContext.request.contextPath}/user/diem-thuong" class="nav-link">
            <i class="fa-solid fa-gift"></i> Điểm thưởng
        </a>
        <a href="${pageContext.request.contextPath}/user/home" class="nav-link">
            <i class="fa-solid fa-house"></i> Trang chủ
        </a>
    </div>
</nav>
    </div>
</nav>

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
                                ${order.staTus == 'PENDING' ? 'badge-warning' :
                                  order.staTus == 'CONFIRMED' ? 'badge-info' :
                                  order.staTus == 'READY_FOR_PICKUP' ? 'badge-primary' :
                                  order.staTus == 'SHIPPING' ? 'badge-warning' :
                                  order.staTus == 'DONE' ? 'badge-success' :
                                  order.staTus == 'CANCELLED' ? 'badge-danger' : 'badge-neutral'}">
                                <c:choose>
                                    <c:when test="${order.staTus eq 'PENDING'}">⏳ Chờ xác nhận</c:when>
                                    <c:when test="${order.staTus eq 'CONFIRMED'}">✅ Đã xác nhận</c:when>
                                    <c:when test="${order.staTus eq 'READY_FOR_PICKUP'}">📦 Chờ shipper</c:when>
                                    <c:when test="${order.staTus eq 'SHIPPING'}">🛵 Đang giao</c:when>
                                    <c:when test="${order.staTus eq 'DONE'}">🎉 Đã giao</c:when>
                                    <c:when test="${order.staTus eq 'CANCELLED'}">❌ Đã huỷ</c:when>
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

                        <div class="order-price">
                            Tổng: <span><fmt:formatNumber value="${order.totalPrice}" type="number" groupingUsed="true"/> đ</span>
                        </div>

                        <c:if test="${order.staTus eq 'SHIPPING'}">
                            <div id="map-${order.id}" class="tracking-map"></div>
                        </c:if>

                        <!-- Nút đánh giá chỉ khi DONE -->
                        <c:if test="${order.staTus eq 'DONE'}">
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

                        <!-- Khiếu nại: cho phép với mọi đơn không phải PENDING (đã có tiến triển thực tế để khiếu nại) -->
                        <c:if test="${order.staTus ne 'PENDING'}">
                            <div class="fb-row" style="margin-top:6px;">
                                <a href="${pageContext.request.contextPath}/khieu-nai?orderId=${order.id}" class="btn-fb" style="background:rgba(248,113,113,.12);color:var(--danger);border-color:rgba(248,113,113,.4);">📢 Khiếu nại đơn này</a>
                            </div>
                        </c:if>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>

</div>
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

<script>window.POB_CONTEXT_PATH = '${pageContext.request.contextPath}';</script>
<script src="${pageContext.request.contextPath}/assets/js/toast.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/notifications-ws.js"></script>
</body>
</html>
