<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Khám phá món ăn - POB</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        * { font-family: 'Inter', sans-serif; }

        .navbar {
            background: #fff;
            border-bottom: 1px solid #e5e7eb;
            box-shadow: 0 1px 4px rgba(0,0,0,.06);
            position: sticky; top: 0; z-index: 50;
        }

        .hero {
            background: linear-gradient(135deg, #273155 0%, #3d4f7c 50%, #5b6fa8 100%);
            padding: 56px 24px 72px;
            text-align: center;
            position: relative;
            overflow: hidden;
        }

        .search-box {
            position: relative;
            max-width: 560px;
            margin: 0 auto;
        }
        .search-box input {
            width: 100%;
            padding: 14px 20px 14px 48px;
            border-radius: 14px;
            border: none;
            font-size: 15px;
            box-shadow: 0 4px 20px rgba(0,0,0,.15);
            outline: none;
        }
        .search-icon {
            position: absolute;
            left: 16px; top: 50%;
            transform: translateY(-50%);
            font-size: 18px;
            pointer-events: none;
        }

        .shop-card {
            background: #fff;
            border-radius: 18px;
            border: 1px solid #f0f0f0;
            box-shadow: 0 2px 8px rgba(0,0,0,.06);
            transition: transform .18s, box-shadow .18s;
            overflow: hidden;
            display: flex;
            flex-direction: column;
            cursor: pointer;
        }
        .shop-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 8px 28px rgba(39,49,85,.16);
        }

        .shop-logo-wrap {
            background: linear-gradient(135deg, #f8f9ff, #eef0fa);
            height: 140px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 52px;
            flex-shrink: 0;
            position: relative;
            overflow: hidden;
        }
        .shop-logo-wrap img {
            width: 100%; height: 100%;
            object-fit: cover;
        }

        .shop-badge {
            position: absolute; top: 10px; right: 10px;
            background: #dcfce7; color: #16a34a;
            font-size: 11px; font-weight: 700;
            padding: 2px 8px; border-radius: 99px;
        }

        .shop-body { padding: 16px; flex: 1; display: flex; flex-direction: column; gap: 6px; }
        .shop-name { font-size: 15px; font-weight: 700; color: #1e293b; line-height: 1.3; }
        .shop-desc { font-size: 13px; color: #64748b;
            display: -webkit-box; -webkit-line-clamp: 2;
            -webkit-box-orient: vertical; overflow: hidden; }
        .shop-meta { display: flex; align-items: flex-start; gap: 6px;
            font-size: 12px; color: #94a3b8; margin-top: 4px; }
        .shop-meta span { overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }

        .btn-order {
            margin: 0 16px 16px;
            padding: 10px;
            border-radius: 10px;
            background: linear-gradient(135deg, #273155, #3d4f7c);
            color: #fff;
            font-size: 13px;
            font-weight: 600;
            text-align: center;
            transition: opacity .15s;
        }
        .btn-order:hover { opacity: .85; }

        .avatar-btn {
            width: 36px; height: 36px;
            border-radius: 50%;
            background: linear-gradient(135deg, #273155, #5b6fa8);
            color: #fff;
            font-size: 14px;
            font-weight: 700;
            display: flex; align-items: center; justify-content: center;
            cursor: pointer;
            border: none;
            position: relative;
            overflow: hidden;
        }

        .dropdown {
            position: absolute; top: calc(100% + 10px); right: 0;
            background: #fff;
            border: 1px solid #e5e7eb;
            border-radius: 12px;
            box-shadow: 0 8px 24px rgba(0,0,0,.12);
            min-width: 190px;
            overflow: hidden;
            display: none;
            z-index: 100;
        }
        .dropdown.open { display: block; }
        .dropdown a, .dropdown button {
            display: flex; align-items: center; gap: 8px;
            width: 100%; padding: 11px 16px;
            font-size: 13px; font-weight: 500; color: #374151;
            text-align: left; background: none; border: none; cursor: pointer;
            text-decoration: none;
            transition: background .1s;
        }
        .dropdown a:hover, .dropdown button:hover { background: #f8fafc; }
        .dropdown .divider { height: 1px; background: #f0f0f0; margin: 4px 0; }

        .empty-state {
            text-align: center; padding: 64px 24px; color: #94a3b8;
        }
    </style>
</head>
<body>

<!-- NAVBAR -->
<nav class="navbar px-5 py-3 flex items-center gap-4">
    <div class="w-9 h-9 rounded-xl flex items-center justify-center text-white font-extrabold text-sm flex-shrink-0"
         style="background: linear-gradient(135deg,#273155,#3d4f7c);">POB</div>
    <span class="text-base font-extrabold text-gray-800 hidden sm:block">POB Food</span>

    <div class="flex-1 max-w-xs mx-4 hidden md:block relative">
        <span class="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400 text-sm">🔍</span>
        <input id="navSearch" type="text" placeholder="Tìm quán..."
               class="w-full pl-8 pr-3 py-2 rounded-lg border border-gray-200 text-sm focus:outline-none focus:border-indigo-400"
               oninput="filterShops(this.value)">
    </div>

    <div class="ml-auto flex items-center gap-5">
        <a href="${pageContext.request.contextPath}/user/donhang"
           class="text-sm font-medium text-gray-600 hover:text-indigo-700 flex items-center gap-1">
            📦 <span class="hidden sm:inline">Đơn hàng</span>
        </a>
        <a href="${pageContext.request.contextPath}/user/dia-chi"
           class="text-sm font-medium text-gray-600 hover:text-indigo-700 flex items-center gap-1">
            📍 <span class="hidden sm:inline">Địa chỉ</span>
        </a>

        <div class="relative" id="avatarWrap">
            <button class="avatar-btn" onclick="toggleDropdown()" title="${account.fullName}">
                <c:choose>
                    <c:when test="${not empty account.avatarUrl}">
                        <img src="${account.avatarUrl}" alt="avatar"
                             style="width:100%;height:100%;object-fit:cover;">
                    </c:when>
                    <c:otherwise>
                        <c:choose>
                            <c:when test="${not empty account.fullName}">${fn:substring(account.fullName, 0, 1)}</c:when>
                            <c:otherwise>${fn:substring(account.userName, 0, 1)}</c:otherwise>
                        </c:choose>
                    </c:otherwise>
                </c:choose>
            </button>
            <div class="dropdown" id="accountDropdown">
                <div class="px-4 py-3 border-b border-gray-100">
                    <div class="text-sm font-bold text-gray-800">
                        <c:choose>
                            <c:when test="${not empty account.fullName}">${account.fullName}</c:when>
                            <c:otherwise>${account.userName}</c:otherwise>
                        </c:choose>
                    </div>
                    <c:if test="${not empty account.email}">
                        <div class="text-xs text-gray-400 mt-0.5">${account.email}</div>
                    </c:if>
                </div>
                <a href="${pageContext.request.contextPath}/user/donhang">📦 Đơn hàng của tôi</a>
                <a href="${pageContext.request.contextPath}/user/dia-chi">📍 Địa chỉ giao hàng</a>
                <a href="${pageContext.request.contextPath}/user/doi-mat-khau">🔒 Đổi mật khẩu</a>
                <div class="divider"></div>
                <form action="${pageContext.request.contextPath}/logout" method="post">
                    <button type="submit">🚪 Đăng xuất</button>
                </form>
            </div>
        </div>
    </div>
</nav>

<!-- HERO -->
<div class="hero">
    <div class="relative z-10">
        <h1 class="text-3xl sm:text-4xl font-extrabold text-white mb-2">
            Hôm nay bạn muốn ăn gì? 🍜
        </h1>
        <p class="text-indigo-200 text-base mb-6">Khám phá các quán ăn ngon đang phục vụ</p>
        <div class="search-box">
            <span class="search-icon">🔍</span>
            <input id="heroSearch" type="text" placeholder="Tìm quán ăn, món ăn..."
                   oninput="filterShops(this.value)">
        </div>
    </div>
</div>

<!-- SHOP LIST -->
<div class="max-w-6xl mx-auto px-4 py-8">

    <div class="flex items-center justify-between mb-6">
        <div>
            <div class="text-xl font-extrabold text-gray-800">Cửa hàng đang hoạt động</div>
            <div class="text-sm text-gray-400 mt-1" id="shopCount">
                <c:choose>
                    <c:when test="${empty shops}">0</c:when>
                    <c:otherwise>${shops.size()}</c:otherwise>
                </c:choose>
            </span>
        </div>
        <span class="sec-link" onclick="filterShops('')">Xem tất cả</span>
    </div>

    <c:choose>
        <c:when test="${empty shops}">
            <div class="empty-state">
                <div class="text-6xl mb-4">🍽️</div>
                <p class="text-lg font-semibold text-gray-500">Chưa có cửa hàng nào mở cửa</p>
                <p class="text-sm mt-1">Vui lòng quay lại sau nhé!</p>
            </div>
        </c:when>
        <c:otherwise>
            <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-5" id="shopGrid">
                <c:forEach var="shop" items="${shops}">
                    <div class="shop-card"
                         data-name="${fn:escapeXml(fn:toLowerCase(shop.shopName))}"
                         data-desc="${fn:escapeXml(fn:toLowerCase(shop.shopDescription))}"
                         data-addr="${fn:escapeXml(fn:toLowerCase(shop.shopAddress))}"
                         onclick="goToShop(${shop.id})">

                        <div class="shop-logo-wrap">
                            <c:choose>
                                <c:when test="${not empty shop.shopLogo}">
                                    <img src="${shop.shopLogo}" alt="${shop.shopName}"
                                         onerror="this.parentNode.innerHTML='<span style=\'font-size:52px\'>🍽️</span><span class=\'shop-badge\'>● Đang mở</span>';">
                                </c:when>
                                <c:otherwise>
                                    <span>🍽️</span>
                                </c:otherwise>
                            </c:choose>
                            <span class="shop-badge">● Đang mở</span>
                        </div>

                        <div class="shop-body">
                            <div class="shop-name">${shop.shopName}</div>
                            <c:if test="${not empty shop.shopDescription}">
                                <div class="shop-desc">${shop.shopDescription}</div>
                            </c:if>
                            <c:if test="${not empty shop.shopAddress}">
                                <div class="shop-meta">
                                    <span>📍</span>
                                    <span title="${shop.shopAddress}">${shop.shopAddress}</span>
                                </div>
                            </c:if>
                            <c:if test="${not empty shop.shopPhone}">
                                <div class="shop-meta">
                                    <span>📞</span>
                                    <span>${shop.shopPhone}</span>
                                </div>
                            </c:if>
                        </div>

                        <div class="btn-order">Xem thực đơn →</div>
                    </div>
                </c:forEach>
            </div>

            <div id="noResults" class="empty-state" style="display:none;">
                <div class="text-5xl mb-3">🔍</div>
                <p class="text-base font-semibold text-gray-500">Không tìm thấy quán nào</p>
                <p class="text-sm mt-1">Thử từ khoá khác nhé</p>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<footer class="text-center text-xs text-gray-400 py-8 border-t border-gray-100 mt-4">
    © 2024 POB Food &nbsp;·&nbsp; Đặt đồ ăn dễ dàng
</footer>

<script>
    /* ── Navigate to shop ── */
    function goToShop(shopId) {
        window.location.href = '${pageContext.request.contextPath}/user/shop?id=' + shopId;
    }

    /* ── Search / filter shops ── */
    function filterShops(query) {
        // sync all search inputs
        ['navSearch','mobileSearch','heroSearch'].forEach(function(id) {
            var el = document.getElementById(id);
            if (el) el.value = query;
        });

        var q = query.toLowerCase().trim();
        var cards = document.querySelectorAll('#shopGrid .shop-card');
        if (!cards.length) return;

        var visible = 0;
        cards.forEach(function(card) {
            var name = card.dataset.name || '';
            var desc = card.dataset.desc || '';
            var addr = card.dataset.addr || '';
            var match = !q || name.includes(q) || desc.includes(q) || addr.includes(q);
            card.style.display = match ? '' : 'none';
            if (match) visible++;
        });

        var noResults = document.getElementById('noResults');
        var countEl   = document.getElementById('shopCount');
        if (noResults) noResults.style.display = (visible === 0) ? 'block' : 'none';
        if (countEl) {
            countEl.textContent = q
                ? visible + ' cửa hàng khớp với "' + query + '"'
                : visible + ' cửa hàng';
        }
    }

    function toggleDropdown() {
        document.getElementById('accountDropdown').classList.toggle('open');
    }
    document.addEventListener('click', function(e) {
        var wrap = document.getElementById('avatarWrap');
        if (wrap && !wrap.contains(e.target)) {
            document.getElementById('accountDropdown').classList.remove('open');
        }
    });
</script>
</body>
</html>
