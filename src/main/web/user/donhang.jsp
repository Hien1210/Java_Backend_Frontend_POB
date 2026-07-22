<%@ page pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đơn hàng của tôi - POB</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/theme-space.css">
    <style>
        .mini-nav { background: var(--bg-panel-solid); border-bottom: 1px solid var(--border-color); padding: 16px 24px; display: flex; align-items: center; gap: 16px; }
        .mini-nav .logo { width: 36px; height: 36px; border-radius: var(--radius-sm); background: linear-gradient(135deg, var(--primary), var(--secondary)); color: #fff; display: flex; align-items: center; justify-content: center; font-weight: 800; font-size: 13px; box-shadow: var(--glow-primary); }
        .mini-nav .title { font-size: 17px; font-weight: 800; color: var(--text-main); }
        .mini-nav .nav-links { margin-left: auto; display: flex; align-items: center; gap: 18px; }
        .mini-nav .nav-links a { font-size: 13px; color: var(--text-muted); }
        .mini-nav .nav-links a:hover { color: var(--secondary); }

        .container { max-width: 760px; margin: 0 auto; padding: 32px 16px; }
        .order-list { display: flex; flex-direction: column; gap: 16px; }
        .order-card { padding: 20px; }
        .order-top { display: flex; align-items: center; justify-content: space-between; margin-bottom: 10px; flex-wrap: wrap; gap: 6px; }
        .order-id { font-weight: 800; font-size: 15px; color: var(--text-main); }
        .order-shop { margin-left: 8px; font-size: 13px; color: var(--text-dim); }
        .order-addr { font-size: 13px; color: var(--text-dim); margin-bottom: 4px; }
        .order-price { font-size: 13.5px; font-weight: 700; color: var(--text-main); margin-bottom: 12px; }

        .btn-fb { display: inline-flex; align-items: center; gap: 4px; padding: 6px 14px; border-radius: var(--radius-pill); font-size: 12.5px; font-weight: 700; cursor: pointer; border: 1.5px solid; }
        .btn-fb-shop { background: var(--warning-light); color: var(--warning); border-color: rgba(251,191,36,.4); }
        .btn-fb-shipper { background: var(--info-light); color: var(--info); border-color: rgba(96,165,250,.4); }
        .btn-fb-done { background: rgba(255,255,255,.04); color: var(--text-dim); border-color: var(--border-color); cursor: default; }
        .fb-row { display: flex; gap: 8px; flex-wrap: wrap; }
    </style>
</head>
<body class="space-scope">
<div class="starfield"></div>

<!-- Navbar mini -->
<div class="mini-nav">
    <div class="logo">POB</div>
    <span class="title">Đơn hàng của tôi</span>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/user/dia-chi">📍 Địa chỉ</a>
        <a href="${pageContext.request.contextPath}/user/home">← Trang chủ</a>
    </div>
</div>

<div class="container">

    <c:if test="${param.success eq '1'}">
        <div class="alert alert-success" style="margin-bottom:20px;">✅ Đánh giá của bạn đã được gửi thành công!</div>
    </c:if>
    <c:if test="${param.error eq '1'}">
        <div class="alert alert-danger" style="margin-bottom:20px;">❌ Không thể gửi đánh giá. Vui lòng thử lại.</div>
    </c:if>

    <c:choose>
        <c:when test="${empty orders}">
            <div class="card empty-state">
                <div class="e-icon">🛒</div>
                <div class="e-title">Bạn chưa có đơn hàng nào</div>
                <a href="${pageContext.request.contextPath}/" style="margin-top:14px;display:inline-block;" class="text-secondary">Khám phá món ăn ngay →</a>
            </div>
        </c:when>
        <c:otherwise>
            <div class="order-list">
                <c:forEach var="order" items="${orders}">
                    <div class="card order-card">
                        <!-- Row 1: mã + trạng thái -->
                        <div class="order-top">
                            <div>
                                <span class="order-id">#${order.id}</span>
                                <span class="order-shop">${shopNames[order.shopId]}</span>
                            </div>
                            <span class="badge
                                ${order.staTus == 'PENDING' ? 'badge-warning' :
                                  order.staTus == 'CONFIRMED' ? 'badge-info' :
                                  order.staTus == 'READY_FOR_PICKUP' ? 'badge-primary' :
                                  order.staTus == 'SHIPPING' ? 'badge-warning' :
                                  order.staTus == 'DELIVERED' ? 'badge-success' :
                                  order.staTus == 'CANCELLED' ? 'badge-danger' : 'badge-neutral'}">
                                <c:choose>
                                    <c:when test="${order.staTus eq 'PENDING'}">⏳ Chờ xác nhận</c:when>
                                    <c:when test="${order.staTus eq 'CONFIRMED'}">✅ Đã xác nhận</c:when>
                                    <c:when test="${order.staTus eq 'READY_FOR_PICKUP'}">📦 Chờ shipper</c:when>
                                    <c:when test="${order.staTus eq 'SHIPPING'}">🛵 Đang giao</c:when>
                                    <c:when test="${order.staTus eq 'DELIVERED'}">🎉 Đã giao</c:when>
                                    <c:when test="${order.staTus eq 'CANCELLED'}">❌ Đã huỷ</c:when>
                                    <c:otherwise>${order.staTus}</c:otherwise>
                                </c:choose>
                            </span>
                        </div>

                        <!-- Row 2: địa chỉ + tiền -->
                        <div class="order-addr">📍 ${order.shippingAddress}</div>
                        <div class="order-price">
                            <fmt:formatNumber value="${order.totalPrice}" type="number" groupingUsed="true"/> đ
                            &nbsp;·&nbsp; ${order.paymentMethod}
                        </div>

                        <!-- Nút đánh giá chỉ khi DELIVERED -->
                        <c:if test="${order.staTus eq 'DELIVERED'}">
                            <div class="fb-row">
                                <c:choose>
                                    <c:when test="${feedbackShop[order.id]}">
                                        <span class="btn-fb btn-fb-done">✓ Đã đánh giá Shop</span>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="${pageContext.request.contextPath}/feedback?orderId=${order.id}&targetType=SHOP" class="btn-fb btn-fb-shop">⭐ Đánh giá Shop</a>
                                    </c:otherwise>
                                </c:choose>

                                <c:if test="${order.shipperId != 0}">
                                    <c:choose>
                                        <c:when test="${feedbackShipper[order.id]}">
                                            <span class="btn-fb btn-fb-done">✓ Đã đánh giá Shipper</span>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="${pageContext.request.contextPath}/feedback?orderId=${order.id}&targetType=SHIPPER" class="btn-fb btn-fb-shipper">🛵 Đánh giá Shipper</a>
                                        </c:otherwise>
                                    </c:choose>
                                </c:if>
                            </div>
                        </c:if>

                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>

</div>
</body>
</html>
