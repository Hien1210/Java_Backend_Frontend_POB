<%@ page pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đơn hàng của tôi - POB</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/orderTrackingMap.js"></script>
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Inter', -apple-system, sans-serif; background: #f0f4f8; min-height: 100vh; }

        /* NAVBAR */
        .navbar { background: #fff; border-bottom: 1px solid #e9edf2; box-shadow: 0 1px 6px rgba(26,32,53,0.06); padding: 0 24px; height: 60px; display: flex; align-items: center; gap: 14px; }
        .nav-logo { display: flex; align-items: center; gap: 10px; text-decoration: none; }
        .nav-logo-badge { width: 36px; height: 36px; border-radius: 10px; background: linear-gradient(135deg,#1a2035,#2d3a6e); display: flex; align-items: center; justify-content: center; color: #fff; font-weight: 800; font-size: 12px; }
        .nav-title { font-size: 16px; font-weight: 800; color: #0f172a; }
        .nav-right { margin-left: auto; display: flex; align-items: center; gap: 16px; }
        .nav-link { font-size: 13px; font-weight: 500; color: #64748b; text-decoration: none; transition: color 0.2s; }
        .nav-link:hover { color: #10b981; }

        /* PAGE */
        .page-wrap { max-width: 760px; margin: 0 auto; padding: 32px 20px; }

        /* TRACKING MAP MARKERS */
        .shop-marker-icon { background: none; border: none; font-size: 22px; line-height: 24px; text-align: center; }

        /* ALERTS */
        .alert { display: flex; align-items: center; gap: 10px; border-radius: 12px; padding: 13px 16px; font-size: 13px; font-weight: 500; margin-bottom: 20px; }
        .alert-success { background: #f0fdf4; border: 1px solid #bbf7d0; color: #16a34a; }
        .alert-error   { background: #fef2f2; border: 1px solid #fecaca; color: #dc2626; }

        /* STATUS BADGES */
        .status-badge { display: inline-flex; align-items: center; gap: 5px; padding: 4px 12px; border-radius: 99px; font-size: 12px; font-weight: 700; white-space: nowrap; }
        .s-PENDING          { background: #fef9c3; color: #92400e; }
        .s-CONFIRMED        { background: #dbeafe; color: #1d4ed8; }
        .s-READY_FOR_PICKUP { background: #e0e7ff; color: #4338ca; }
        .s-SHIPPING         { background: #fef3c7; color: #d97706; }
        .s-DONE             { background: #dcfce7; color: #16a34a; }
        .s-CANCELLED        { background: #fee2e2; color: #dc2626; }

        /* ORDER CARDS */
        .order-list { display: flex; flex-direction: column; gap: 14px; }

        .order-card {
            background: #fff; border-radius: 18px;
            border: 1px solid #eef0f4;
            box-shadow: 0 2px 10px rgba(26,32,53,0.06);
            padding: 20px 22px;
            transition: box-shadow 0.18s;
        }
        .order-card:hover { box-shadow: 0 6px 22px rgba(26,32,53,0.1); }

        .order-top { display: flex; align-items: center; justify-content: space-between; margin-bottom: 12px; flex-wrap: wrap; gap: 8px; }
        .order-id-wrap { display: flex; align-items: center; gap: 10px; }
        .order-id   { font-size: 15px; font-weight: 800; color: #0f172a; }
        .order-shop { font-size: 13px; color: #64748b; }

        .order-meta { margin-bottom: 14px; display: flex; flex-direction: column; gap: 5px; }
        .order-addr { font-size: 13px; color: #64748b; display: flex; align-items: flex-start; gap: 5px; }
        .order-price { font-size: 14px; font-weight: 700; color: #0f172a; display: flex; align-items: center; gap: 8px; }
        .order-pay-method { font-size: 12px; font-weight: 500; color: #94a3b8; background: #f1f5f9; padding: 2px 8px; border-radius: 6px; }

        .order-actions { display: flex; gap: 8px; flex-wrap: wrap; padding-top: 14px; border-top: 1px solid #f1f5f9; }

        .btn-fb-done { display: inline-flex; align-items: center; gap: 5px; padding: 7px 14px; border-radius: 10px; font-size: 12.5px; font-weight: 600; cursor: pointer; border: 1.5px solid; text-decoration: none; transition: opacity 0.15s; }
        .btn-fb-done:hover { opacity: 0.8; }
        .btn-fb-shop    { background: #fffbeb; color: #d97706; border-color: #fcd34d; }
        .btn-fb-shipper { background: #eff6ff; color: #2563eb; border-color: #93c5fd; }
        .btn-fb-done-chip { display: inline-flex; align-items: center; gap: 5px; padding: 7px 14px; border-radius: 10px; font-size: 12.5px; font-weight: 600; background: #f8fafc; color: #9ca3af; border: 1.5px solid #e5e7eb; }

        /* EMPTY */
        .empty-state { background: #fff; border-radius: 20px; border: 1px solid #eef0f4; padding: 64px 24px; text-align: center; }
        .empty-icon  { font-size: 56px; margin-bottom: 14px; }
        .empty-title { font-size: 16px; font-weight: 600; color: #64748b; margin-bottom: 8px; }
        .empty-link  { display: inline-block; margin-top: 8px; font-size: 13.5px; font-weight: 700; color: #10b981; text-decoration: none; }
        .empty-link:hover { color: #059669; }
    </style>
</head>
<body>

<!-- NAVBAR -->
<nav class="navbar">
    <a href="${pageContext.request.contextPath}/user/home" class="nav-logo">
        <div class="nav-logo-badge">POB</div>
    </a>
    <span class="nav-title">Đơn hàng của tôi</span>
    <div class="nav-right">
        <a href="${pageContext.request.contextPath}/user/dia-chi" class="nav-link" style="display:inline-flex;align-items:center;gap:5px;">
            <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/></svg>
            Địa chỉ
        </a>
        <a href="${pageContext.request.contextPath}/user/home" class="nav-link">← Trang chủ</a>
    </div>
</nav>

<div class="page-wrap">

    <c:if test="${param.success eq '1'}">
        <div class="alert alert-success">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
            Đánh giá của bạn đã được gửi thành công!
        </div>
    </c:if>
    <c:if test="${param.error eq '1'}">
        <div class="alert alert-error">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><line x1="15" y1="9" x2="9" y2="15"/><line x1="9" y1="9" x2="15" y2="15"/></svg>
            Không thể gửi đánh giá. Vui lòng thử lại.
        </div>
    </c:if>

    <c:choose>
        <c:when test="${empty orders}">
            <div class="empty-state">
                <div class="empty-icon"><svg width="56" height="56" viewBox="0 0 24 24" fill="none" stroke="#cbd5e1" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" style="margin:0 auto;"><circle cx="9" cy="21" r="1"/><circle cx="20" cy="21" r="1"/><path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"/></svg></div>
                <div class="empty-title">Bạn chưa có đơn hàng nào.</div>
                <a href="${pageContext.request.contextPath}/" class="empty-link">Khám phá món ăn ngay →</a>
            </div>
        </c:when>
        <c:otherwise>
            <div class="order-list">
                <c:forEach var="order" items="${orders}">
                    <div class="order-card">

                        <div class="order-top">
                            <div class="order-id-wrap">
                                <span class="order-id">#${order.id}</span>
                                <span class="order-shop"><c:out value="${shopNames[order.shopId]}"/></span>
                            </div>
                            <span class="status-badge s-${order.staTus}">
                                <c:choose>
                                    <c:when test="${order.staTus eq 'PENDING'}">Chờ xác nhận</c:when>
                                    <c:when test="${order.staTus eq 'CONFIRMED'}">Đã xác nhận</c:when>
                                    <c:when test="${order.staTus eq 'READY_FOR_PICKUP'}">Chờ shipper</c:when>
                                    <c:when test="${order.staTus eq 'SHIPPING'}">Đang giao</c:when>
                                    <c:when test="${order.staTus eq 'DONE'}">Đã giao</c:when>
                                    <c:when test="${order.staTus eq 'CANCELLED'}">Đã huỷ</c:when>
                                    <c:otherwise>${order.staTus}</c:otherwise>
                                </c:choose>
                            </span>
                        </div>

                        <div class="order-meta">
                            <div class="order-addr"><span style="display:inline-flex;flex-shrink:0;"><svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/></svg></span><span><c:out value="${order.shippingAddress}"/></span></div>
                            <div class="order-price">
                                <fmt:formatNumber value="${order.totalPrice}" type="number" groupingUsed="true"/> đ
                                <span class="order-pay-method">${order.paymentMethod}</span>
                            </div>
                        </div>

                        <c:if test="${order.staTus eq 'SHIPPING'}">
                            <div id="map-${order.id}" style="height:220px;border-radius:12px;margin-top:10px;overflow:hidden;"></div>
                        </c:if>

                        <c:if test="${order.staTus eq 'DONE'}">
                            <div class="order-actions">
                                <c:choose>
                                    <c:when test="${feedbackShop[order.id]}">
                                        <span class="btn-fb-done-chip">
                                            <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
                                            Đã đánh giá Shop</span>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="${pageContext.request.contextPath}/feedback?orderId=${order.id}&targetType=SHOP" class="btn-fb-done btn-fb-shop">
                                            <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
                                            Đánh giá Shop</a>
                                    </c:otherwise>
                                </c:choose>

                                <c:if test="${order.shipperId != 0}">
                                    <c:choose>
                                        <c:when test="${feedbackShipper[order.id]}">
                                            <span class="btn-fb-done-chip">
                                                <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
                                                Đã đánh giá Shipper</span>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="${pageContext.request.contextPath}/feedback?orderId=${order.id}&targetType=SHIPPER" class="btn-fb-done btn-fb-shipper">
                                                <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="5.5" cy="17.5" r="3.5"/><circle cx="18.5" cy="17.5" r="3.5"/><path d="M15 6a1 1 0 0 0-1-1h-1a1 1 0 0 0-1 1v11h6M5 17.5V6h5"/><path d="M12 6h4l3 5"/></svg>
                                                Đánh giá Shipper</a>
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

<script>
    (function () {
        var protocol = location.protocol === 'https:' ? 'wss://' : 'ws://';
        var contextPath = '${pageContext.request.contextPath}';
        <c:forEach var="order" items="${orders}">
        <c:if test="${order.staTus eq 'SHIPPING'}">
        (function () {
            var shopCoord = ${not empty shopCoords[order.shopId] ? 'true' : 'false'};
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
</body>
</html>
