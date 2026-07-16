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
            background: linear-gradient(140deg, #1a2035 0%, #0f1624 100%);
            padding: 56px 24px 72px;
            text-align: center;
            position: relative;
            overflow: hidden;
        }
        .hero::before { content: ''; position: absolute; top: -60px; right: -60px; width: 220px; height: 220px; border-radius: 50%; background: radial-gradient(circle, rgba(16,185,129,0.18) 0%, transparent 70%); }

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
            background: linear-gradient(135deg, #10b981, #059669);
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
            background: linear-gradient(135deg, #1a2035, #2d3a6e);
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
         style="background: linear-gradient(135deg,#1a2035,#2d3a6e);">POB</div>
    <span class="text-base font-extrabold text-gray-800 hidden sm:block">POB Food</span>

    <div class="flex-1 max-w-xs mx-4 hidden md:block relative">
        <svg class="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/></svg>
        <input id="navSearch" type="text" placeholder="Tìm quán..."
               class="w-full pl-8 pr-3 py-2 rounded-lg border border-gray-200 text-sm focus:outline-none focus:border-emerald-400"
               oninput="filterShops(this.value)">
    </div>

    <div class="ml-auto flex items-center gap-5">
        <a href="${pageContext.request.contextPath}/user/donhang"
           class="text-sm font-medium text-gray-600 hover:text-emerald-600 flex items-center gap-1.5">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="m7.5 4.27 9 5.15"/><path d="M21 8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16Z"/><path d="m3.3 7 8.7 5 8.7-5"/><path d="M12 22V12"/></svg>
            <span class="hidden sm:inline">Đơn hàng</span>
        </a>
        <a href="${pageContext.request.contextPath}/user/dia-chi"
           class="text-sm font-medium text-gray-600 hover:text-emerald-600 flex items-center gap-1.5">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20 10c0 6-8 12-8 12s-8-6-8-12a8 8 0 0 1 16 0Z"/><circle cx="12" cy="10" r="3"/></svg>
            <span class="hidden sm:inline">Địa chỉ</span>
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
                <a href="${pageContext.request.contextPath}/user/donhang">
                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="m7.5 4.27 9 5.15"/><path d="M21 8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16Z"/><path d="m3.3 7 8.7 5 8.7-5"/><path d="M12 22V12"/></svg>
                    Đơn hàng của tôi
                </a>
                <a href="${pageContext.request.contextPath}/user/dia-chi">
                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20 10c0 6-8 12-8 12s-8-6-8-12a8 8 0 0 1 16 0Z"/><circle cx="12" cy="10" r="3"/></svg>
                    Địa chỉ giao hàng
                </a>
                <a href="${pageContext.request.contextPath}/user/doi-mat-khau">
                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
                    Đổi mật khẩu
                </a>
                <div class="divider"></div>
                <form action="${pageContext.request.contextPath}/logout" method="post">
                    <button type="submit">
                        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg>
                        Đăng xuất
                    </button>
                </form>
            </div>
        </div>
    </div>
</nav>

<!-- HERO -->
<div class="hero">
    <div class="relative z-10">
        <h1 class="text-3xl sm:text-4xl font-extrabold text-white mb-2">
            Hôm nay bạn muốn ăn gì?
        </h1>
        <p class="text-slate-300 text-base mb-6">Khám phá các quán ăn ngon đang phục vụ</p>
        <div class="search-box">
            <span class="search-icon">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#94a3b8" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/></svg>
            </span>
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
                    <c:when test="${empty shops}">0 cửa hàng</c:when>
                    <c:otherwise>${shops.size()} cửa hàng</c:otherwise>
                </c:choose>
            </div>
        </div>
        <span class="text-sm font-semibold text-emerald-600 cursor-pointer hover:text-emerald-700" onclick="filterShops('')">Xem tất cả</span>
    </div>

    <c:choose>
        <c:when test="${empty shops}">
            <div class="empty-state">
                <svg width="56" height="56" viewBox="0 0 24 24" fill="none" stroke="#cbd5e1" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" class="mx-auto mb-4"><path d="M3 2v7c0 1.1.9 2 2 2h4a2 2 0 0 0 2-2V2"/><path d="M7 2v20"/><path d="M21 15V2a5 5 0 0 0-5 5v6c0 1.1.9 2 2 2h3Zm0 0v7"/></svg>
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
                                         onerror="this.parentNode.innerHTML='<svg width=\'44\' height=\'44\' viewBox=\'0 0 24 24\' fill=\'none\' stroke=\'#94a3b8\' stroke-width=\'1.5\'><path d=\'M3 2v7c0 1.1.9 2 2 2h4a2 2 0 0 0 2-2V2\'/><path d=\'M7 2v20\'/><path d=\'M21 15V2a5 5 0 0 0-5 5v6c0 1.1.9 2 2 2h3Zm0 0v7\'/></svg><span class=\'shop-badge\'>● Đang mở</span>';">
                                </c:when>
                                <c:otherwise>
                                    <svg width="44" height="44" viewBox="0 0 24 24" fill="none" stroke="#94a3b8" stroke-width="1.5"><path d="M3 2v7c0 1.1.9 2 2 2h4a2 2 0 0 0 2-2V2"/><path d="M7 2v20"/><path d="M21 15V2a5 5 0 0 0-5 5v6c0 1.1.9 2 2 2h3Zm0 0v7"/></svg>
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
                                    <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="flex-shrink:0;margin-top:1px;"><path d="M20 10c0 6-8 12-8 12s-8-6-8-12a8 8 0 0 1 16 0Z"/><circle cx="12" cy="10" r="3"/></svg>
                                    <span title="${shop.shopAddress}">${shop.shopAddress}</span>
                                </div>
                            </c:if>
                            <c:if test="${not empty shop.shopPhone}">
                                <div class="shop-meta">
                                    <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="flex-shrink:0;margin-top:1px;"><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72c.127.96.362 1.903.7 2.81a2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45c.907.338 1.85.573 2.81.7A2 2 0 0 1 22 16.92Z"/></svg>
                                    <span>${shop.shopPhone}</span>
                                </div>
                            </c:if>
                        </div>

                        <div class="btn-order">Xem thực đơn →</div>
                    </div>
                </c:forEach>
            </div>

            <div id="noResults" class="empty-state" style="display:none;">
                <svg width="44" height="44" viewBox="0 0 24 24" fill="none" stroke="#cbd5e1" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" class="mx-auto mb-3"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/></svg>
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
