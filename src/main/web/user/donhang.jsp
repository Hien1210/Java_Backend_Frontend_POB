<%@ page pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đơn hàng của tôi - POB</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        * { font-family: 'Inter', sans-serif; }
        .status-badge { display: inline-flex; align-items: center; gap: 4px; padding: 3px 10px; border-radius: 99px; font-size: 12px; font-weight: 600; }
        .status-PENDING      { background:#fef9c3; color:#92400e; }
        .status-CONFIRMED    { background:#dbeafe; color:#1d4ed8; }
        .status-READY_FOR_PICKUP { background:#e0e7ff; color:#4338ca; }
        .status-SHIPPING     { background:#fef3c7; color:#d97706; }
        .status-DELIVERED    { background:#dcfce7; color:#16a34a; }
        .status-CANCELLED    { background:#fee2e2; color:#dc2626; }
        .btn-fb { display:inline-flex; align-items:center; gap:4px; padding:5px 12px; border-radius:8px;
                  font-size:13px; font-weight:600; cursor:pointer; border:1px solid; transition:opacity .15s; }
        .btn-fb:hover { opacity:.8; }
    </style>
</head>
<body class="bg-gray-50 min-h-screen">

<!-- Navbar mini -->
<div class="bg-white border-b shadow-sm px-6 py-4 flex items-center gap-4">
    <div class="w-9 h-9 rounded-xl flex items-center justify-center text-white font-extrabold text-sm"
         style="background: linear-gradient(135deg,#273155,#3d4f7c);">POB</div>
    <span class="text-lg font-extrabold text-gray-800">Đơn hàng của tôi</span>
    <a href="${pageContext.request.contextPath}/" class="ml-auto text-sm text-gray-500 hover:text-gray-800">← Trang chủ</a>
</div>

<div class="max-w-3xl mx-auto px-4 py-8">

    <c:if test="${param.success eq '1'}">
        <div class="bg-green-50 border border-green-200 text-green-700 rounded-xl px-4 py-3 mb-6 text-sm font-medium">
            ✅ Đánh giá của bạn đã được gửi thành công!
        </div>
    </c:if>
    <c:if test="${param.error eq '1'}">
        <div class="bg-red-50 border border-red-200 text-red-700 rounded-xl px-4 py-3 mb-6 text-sm font-medium">
            ❌ Không thể gửi đánh giá. Vui lòng thử lại.
        </div>
    </c:if>

    <c:choose>
        <c:when test="${empty orders}">
            <div class="bg-white rounded-2xl shadow p-12 text-center text-gray-400">
                <div class="text-5xl mb-3">🛒</div>
                <p class="text-base font-medium">Bạn chưa có đơn hàng nào.</p>
                <a href="${pageContext.request.contextPath}/" class="mt-4 inline-block text-sm text-blue-600 hover:underline">Khám phá món ăn ngay →</a>
            </div>
        </c:when>
        <c:otherwise>
            <div class="space-y-4">
                <c:forEach var="order" items="${orders}">
                    <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-5">
                        <!-- Row 1: mã + trạng thái -->
                        <div class="flex items-center justify-between mb-3">
                            <div>
                                <span class="font-bold text-gray-800 text-base">#${order.id}</span>
                                <span class="ml-2 text-sm text-gray-500">${shopNames[order.shopId]}</span>
                            </div>
                            <span class="status-badge status-${order.staTus}">
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
                        <div class="text-sm text-gray-500 mb-1">📍 ${order.shippingAddress}</div>
                        <div class="text-sm font-semibold text-gray-700 mb-3">
                            <fmt:formatNumber value="${order.totalPrice}" type="number" groupingUsed="true"/> đ
                            &nbsp;·&nbsp; ${order.paymentMethod}
                        </div>

                        <!-- Nút đánh giá chỉ khi DELIVERED -->
                        <c:if test="${order.staTus eq 'DELIVERED'}">
                            <div class="flex gap-2 flex-wrap">
                                <c:choose>
                                    <c:when test="${feedbackShop[order.id]}">
                                        <span class="btn-fb" style="background:#f9fafb;color:#9ca3af;border-color:#e5e7eb;cursor:default;">✓ Đã đánh giá Shop</span>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="${pageContext.request.contextPath}/feedback?orderId=${order.id}&targetType=SHOP"
                                           class="btn-fb" style="background:#fffbeb;color:#d97706;border-color:#fcd34d;">⭐ Đánh giá Shop</a>
                                    </c:otherwise>
                                </c:choose>

                                <c:if test="${order.shipperId != 0}">
                                    <c:choose>
                                        <c:when test="${feedbackShipper[order.id]}">
                                            <span class="btn-fb" style="background:#f9fafb;color:#9ca3af;border-color:#e5e7eb;cursor:default;">✓ Đã đánh giá Shipper</span>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="${pageContext.request.contextPath}/feedback?orderId=${order.id}&targetType=SHIPPER"
                                               class="btn-fb" style="background:#eff6ff;color:#2563eb;border-color:#93c5fd;">🛵 Đánh giá Shipper</a>
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
