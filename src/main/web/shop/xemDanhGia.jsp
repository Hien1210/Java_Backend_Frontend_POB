<%@ page pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đánh giá cửa hàng - POB</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        * { font-family: 'Inter', sans-serif; }
        .tab-btn.active { border-bottom: 2px solid #273155; color: #273155; font-weight: 700; }
        .tab-panel { display: none; }
        .tab-panel.active { display: block; }
        .star-filled { color: #f59e0b; }
        .star-empty  { color: #d1d5db; }
    </style>
</head>
<body class="bg-gray-50 min-h-screen">

<%-- Navbar shop (include nếu có) --%>
<div class="max-w-4xl mx-auto px-4 py-8">

    <!-- Header tổng quan -->
    <div class="bg-white rounded-2xl shadow p-6 mb-6 flex items-center gap-6">
        <div class="text-center">
            <div class="text-5xl font-extrabold text-amber-400">
                <fmt:formatNumber value="${avgRating}" maxFractionDigits="1"/>
            </div>
            <div class="flex justify-center gap-0.5 mt-1">
                <c:forEach begin="1" end="5" var="i">
                    <span class="${i <= avgRating ? 'star-filled' : 'star-empty'} text-xl">★</span>
                </c:forEach>
            </div>
            <p class="text-xs text-gray-400 mt-1">${totalFeedback} đánh giá</p>
        </div>
        <div class="flex-1">
            <h2 class="text-xl font-extrabold text-gray-800 mb-1">${shop.shopName}</h2>
            <p class="text-sm text-gray-500">Xem đánh giá từ khách hàng và shipper của bạn</p>
        </div>
        <a href="${pageContext.request.contextPath}/shop"
           class="text-xs text-gray-400 hover:text-gray-600 font-medium">← Về trang quản lý</a>
    </div>

    <!-- Tab -->
    <div class="bg-white rounded-2xl shadow overflow-hidden">
        <div class="flex border-b border-gray-100">
            <button onclick="switchTab('user')"
                    class="tab-btn active flex-1 py-4 text-sm text-gray-500 hover:text-gray-800 transition"
                    id="tab-user">
                👤 Từ Khách hàng
                <span class="ml-1 bg-blue-50 text-blue-600 text-xs font-bold px-2 py-0.5 rounded-full">
                    ${feedbackUser.size()}
                </span>
            </button>
            <button onclick="switchTab('shipper')"
                    class="tab-btn flex-1 py-4 text-sm text-gray-500 hover:text-gray-800 transition"
                    id="tab-shipper">
                🛵 Từ Shipper
                <span class="ml-1 bg-green-50 text-green-600 text-xs font-bold px-2 py-0.5 rounded-full">
                    ${feedbackShipper.size()}
                </span>
            </button>
        </div>

        <!-- Tab: User -->
        <div class="tab-panel active p-6" id="panel-user">
            <c:choose>
                <c:when test="${empty feedbackUser}">
                    <div class="text-center py-12 text-gray-400">
                        <div class="text-4xl mb-2">💬</div>
                        <p class="text-sm">Chưa có đánh giá từ khách hàng</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="flex flex-col gap-4">
                    <c:forEach var="fb" items="${feedbackUser}">
                        <div class="border border-gray-100 rounded-xl p-4 hover:bg-gray-50 transition">
                            <div class="flex items-start justify-between mb-2">
                                <div class="flex items-center gap-2">
                                    <div class="w-8 h-8 rounded-full bg-blue-100 flex items-center justify-center text-blue-600 font-bold text-sm">
                                        ${fb.anonymous ? '?' : fb.reviewerName.charAt(0)}
                                    </div>
                                    <div>
                                        <p class="text-sm font-semibold text-gray-800">
                                            ${fb.anonymous ? 'Ẩn danh' : fb.reviewerName}
                                        </p>
                                        <p class="text-xs text-gray-400">Đơn #${fb.orderId}</p>
                                    </div>
                                </div>
                                <div class="flex items-center gap-1">
                                    <c:forEach begin="1" end="5" var="i">
                                        <span class="${i <= fb.rating ? 'star-filled' : 'star-empty'} text-base">★</span>
                                    </c:forEach>
                                    <span class="text-xs text-gray-400 ml-1">
                                        <fmt:formatDate value="${fb.createdAt}" pattern="dd/MM/yyyy"/>
                                    </span>
                                </div>
                            </div>
                            <c:if test="${not empty fb.comment}">
                                <p class="text-sm text-gray-600 leading-relaxed">${fb.comment}</p>
                            </c:if>
                        </div>
                    </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Tab: Shipper -->
        <div class="tab-panel p-6" id="panel-shipper">
            <c:choose>
                <c:when test="${empty feedbackShipper}">
                    <div class="text-center py-12 text-gray-400">
                        <div class="text-4xl mb-2">🛵</div>
                        <p class="text-sm">Chưa có đánh giá từ shipper</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="flex flex-col gap-4">
                    <c:forEach var="fb" items="${feedbackShipper}">
                        <div class="border border-gray-100 rounded-xl p-4 hover:bg-gray-50 transition">
                            <div class="flex items-start justify-between mb-2">
                                <div class="flex items-center gap-2">
                                    <div class="w-8 h-8 rounded-full bg-green-100 flex items-center justify-center text-green-600 font-bold text-sm">
                                        ${fb.reviewerName.charAt(0)}
                                    </div>
                                    <div>
                                        <p class="text-sm font-semibold text-gray-800">${fb.reviewerName}</p>
                                        <p class="text-xs text-gray-400">Đơn #${fb.orderId}</p>
                                    </div>
                                </div>
                                <div class="flex items-center gap-1">
                                    <c:forEach begin="1" end="5" var="i">
                                        <span class="${i <= fb.rating ? 'star-filled' : 'star-empty'} text-base">★</span>
                                    </c:forEach>
                                    <span class="text-xs text-gray-400 ml-1">
                                        <fmt:formatDate value="${fb.createdAt}" pattern="dd/MM/yyyy"/>
                                    </span>
                                </div>
                            </div>
                            <c:if test="${not empty fb.comment}">
                                <p class="text-sm text-gray-600 leading-relaxed">${fb.comment}</p>
                            </c:if>
                        </div>
                    </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<script>
    function switchTab(tab) {
        document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
        document.querySelectorAll('.tab-panel').forEach(p => p.classList.remove('active'));
        document.getElementById('tab-' + tab).classList.add('active');
        document.getElementById('panel-' + tab).classList.add('active');
    }
</script>
</body>
</html>
