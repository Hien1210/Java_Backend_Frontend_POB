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
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
    <style>
        * { font-family: 'Inter', sans-serif; }

        .navbar {
            background: rgba(255,255,255,.92);
            backdrop-filter: blur(10px);
            border-bottom: 1px solid #ffe4cc;
            position: sticky; top: 0; z-index: 50;
        }

        .logo-mark {
            background: linear-gradient(135deg, #FF6B00, #FF9142);
            box-shadow: 0 4px 14px rgba(255,107,0,.35);
        }

        .nav-search {
            background: #FFF4EA;
            border: 1.5px solid transparent;
            transition: border-color .15s, background .15s;
        }
        .nav-search:focus-within {
            border-color: #FF6B00;
            background: #fff;
        }

        .hero {
            background: linear-gradient(135deg, #FF7A18 0%, #FF6B00 45%, #FFA53E 100%);
            padding: 60px 24px 88px;
            text-align: center;
            position: relative;
            overflow: hidden;
        }
        .hero::before {
            content: "";
            position: absolute; inset: 0;
            background-image: radial-gradient(circle at 15% 25%, rgba(255,255,255,.14) 0, transparent 40%),
                               radial-gradient(circle at 85% 75%, rgba(255,255,255,.12) 0, transparent 45%);
            pointer-events: none;
        }
        .hero-emoji-float {
            position: absolute;
            font-size: 44px;
            opacity: .5;
            filter: drop-shadow(0 6px 10px rgba(0,0,0,.15));
        }

        .search-box {
            position: relative;
            max-width: 580px;
            margin: 0 auto;
        }
        .search-box input {
            width: 100%;
            padding: 16px 22px 16px 52px;
            border-radius: 18px;
            border: none;
            font-size: 15px;
            box-shadow: 0 10px 30px rgba(120,40,0,.25);
            outline: none;
        }
        .search-box input:focus {
            box-shadow: 0 10px 30px rgba(120,40,0,.25), 0 0 0 3px rgba(255,255,255,.5);
        }
        .search-icon {
            position: absolute;
            left: 18px; top: 50%;
            transform: translateY(-50%);
            font-size: 19px;
            pointer-events: none;
        }

        .shop-card {
            background: #fff;
            border-radius: 24px;
            border: 1px solid #fef0e2;
            box-shadow: 0 3px 14px rgba(255,107,0,.08);
            transition: transform .2s cubic-bezier(.2,.8,.2,1), box-shadow .2s;
            overflow: hidden;
            display: flex;
            flex-direction: column;
            cursor: pointer;
        }
        .shop-card:hover {
            transform: translateY(-6px);
            box-shadow: 0 16px 36px rgba(255,107,0,.22);
        }

        .shop-logo-wrap {
            background: linear-gradient(135deg, #FFE8D1, #FFF3E6);
            aspect-ratio: 3 / 2;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 56px;
            flex-shrink: 0;
            position: relative;
            overflow: hidden;
        }
        .shop-logo-wrap img {
            width: 100%; height: 100%;
            object-fit: cover;
            transition: transform .3s;
        }
        .shop-card:hover .shop-logo-wrap img {
            transform: scale(1.06);
        }

        .shop-badge {
            position: absolute; top: 12px; right: 12px;
            background: rgba(255,255,255,.95); color: #16a34a;
            font-size: 11px; font-weight: 700;
            padding: 4px 10px; border-radius: 99px;
            box-shadow: 0 2px 6px rgba(0,0,0,.1);
            display: flex; align-items: center; gap: 4px;
        }
        .shop-badge::before {
            content: "";
            width: 6px; height: 6px; border-radius: 50%;
            background: #16a34a;
            display: inline-block;
        }

        .shop-body { padding: 18px 18px 8px; flex: 1; display: flex; flex-direction: column; gap: 7px; }
        .shop-name {
            font-size: 16px; font-weight: 800; color: #241203; line-height: 1.3;
            display: -webkit-box; -webkit-line-clamp: 1; -webkit-box-orient: vertical; overflow: hidden;
        }
        .shop-desc { font-size: 13px; color: #94816f; line-height: 1.5;
            display: -webkit-box; -webkit-line-clamp: 2;
            -webkit-box-orient: vertical; overflow: hidden; }
        .shop-meta { display: flex; align-items: flex-start; gap: 6px;
            font-size: 12.5px; color: #a8967f; }
        .shop-meta span:last-child { overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
        .shop-meta .icon { flex-shrink: 0; opacity: .75; }

        .btn-order {
            margin: 14px 16px 16px;
            padding: 12px;
            border-radius: 14px;
            background: linear-gradient(135deg, #FF6B00, #FF8A2E);
            color: #fff;
            font-size: 13.5px;
            font-weight: 700;
            text-align: center;
            box-shadow: 0 6px 16px rgba(255,107,0,.3);
            transition: all .18s;
        }
        .shop-card:hover .btn-order {
            box-shadow: 0 10px 22px rgba(255,107,0,.42);
            transform: translateY(-1px);
            background: linear-gradient(135deg, #FF7A0F, #FF9A45);
        }

        .avatar-btn {
            width: 38px; height: 38px;
            border-radius: 50%;
            background: linear-gradient(135deg, #FF6B00, #FFA53E);
            color: #fff;
            font-size: 14px;
            font-weight: 700;
            display: flex; align-items: center; justify-content: center;
            cursor: pointer;
            border: none;
            position: relative;
            overflow: hidden;
            box-shadow: 0 3px 10px rgba(255,107,0,.3);
        }

        .dropdown {
            position: absolute; top: calc(100% + 12px); right: 0;
            background: #fff;
            border: 1px solid #ffe9d4;
            border-radius: 16px;
            box-shadow: 0 12px 32px rgba(120,40,0,.16);
            min-width: 200px;
            overflow: hidden;
            display: none;
            z-index: 100;
        }
        .dropdown.open { display: block; }
        .dropdown a, .dropdown button {
            display: flex; align-items: center; gap: 9px;
            width: 100%; padding: 12px 16px;
            font-size: 13px; font-weight: 500; color: #4b3a2c;
            text-align: left; background: none; border: none; cursor: pointer;
            text-decoration: none;
            transition: background .12s;
        }
        .dropdown a:hover, .dropdown button:hover { background: #FFF4EA; color: #FF6B00; }
        .dropdown .divider { height: 1px; background: #fbe8d6; margin: 4px 0; }

        .empty-state {
            text-align: center; padding: 70px 24px; color: #b8a591;
        }

        .section-badge {
            display: inline-flex; align-items: center; gap: 6px;
            background: #FFF0E0; color: #FF6B00;
            font-size: 12px; font-weight: 700;
            padding: 5px 12px; border-radius: 99px;
            margin-bottom: 6px;
        }
    </style>
</head>
<body class="bg-[#FFFBF7] min-h-screen">

<!-- NAVBAR -->
<nav class="navbar px-5 py-3 flex items-center gap-4">
    <div class="logo-mark w-9 h-9 rounded-2xl flex items-center justify-center text-white font-extrabold text-sm flex-shrink-0">POB</div>
    <span class="text-base font-extrabold text-[#241203] hidden sm:block">POB <span class="text-[#FF6B00]">Food</span></span>

    <div class="flex-1 max-w-xs mx-4 hidden md:block relative">
        <div class="nav-search rounded-xl flex items-center px-3 py-2 gap-2">
            <span class="text-gray-400 text-sm">🔍</span>
            <input id="navSearch" type="text" placeholder="Tìm quán..."
                   class="w-full bg-transparent text-sm outline-none"
                   oninput="filterShops(this.value)">
        </div>
    </div>

    <div class="ml-auto flex items-center gap-5">
        <a href="${pageContext.request.contextPath}/user/donhang"
           class="text-sm font-medium text-gray-500 hover:text-[#FF6B00] flex items-center gap-1 transition-colors">
            📦 <span class="hidden sm:inline">Đơn hàng</span>
        </a>
        <a href="${pageContext.request.contextPath}/user/dia-chi"
           class="text-sm font-medium text-gray-500 hover:text-[#FF6B00] flex items-center gap-1 transition-colors">
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
                <div class="px-4 py-3 border-b border-orange-50">
                    <div class="text-sm font-bold text-[#241203]">
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
    <span class="hero-emoji-float" style="top:18%; left:8%;">🍕</span>
    <span class="hero-emoji-float" style="top:60%; left:15%; font-size:34px;">🥤</span>
    <span class="hero-emoji-float" style="top:22%; right:10%;">🍔</span>
    <span class="hero-emoji-float" style="top:62%; right:6%; font-size:36px;">🍣</span>

    <div class="relative z-10">
        <div class="section-badge" style="background:rgba(255,255,255,.2); color:#fff;">🔥 Giao hàng nhanh trong 30 phút</div>
        <h1 class="text-3xl sm:text-4xl font-extrabold text-white mb-2 mt-2">
            Hôm nay bạn muốn ăn gì? 🍜
        </h1>
        <p class="text-orange-50 text-base mb-7 opacity-90">Khám phá hàng ngàn quán ăn ngon đang phục vụ gần bạn</p>
        <div class="search-box">
            <span class="search-icon">🔍</span>
            <input id="heroSearch" type="text" placeholder="Tìm quán ăn, món ăn..."
                   oninput="filterShops(this.value)">
        </div>
    </div>
</div>

<!-- SHOP LIST -->
<div class="max-w-6xl mx-auto px-4 py-10 -mt-8 relative z-10">

    <div class="flex items-center justify-between mb-6">
        <div>
            <div class="text-xl font-extrabold text-[#241203]">Cửa hàng đang hoạt động</div>
            <div class="text-sm text-gray-400 mt-1" id="shopCount">
                <c:choose>
                    <c:when test="${empty shops}">Không có cửa hàng nào</c:when>
                    <c:otherwise>${shops.size()} cửa hàng</c:otherwise>
                </c:choose>
            </div>
        </div>
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
            <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6" id="shopGrid">
                <c:forEach var="shop" items="${shops}">
                    <div class="shop-card"
                         data-name="${fn:toLowerCase(shop.shopName)}"
                         data-desc="${fn:toLowerCase(shop.shopDescription)}"
                         data-addr="${fn:toLowerCase(shop.shopAddress)}"
                         onclick="goToShop(${shop.id})">

                        <div class="shop-logo-wrap">
                            <c:choose>
                                <c:when test="${not empty shop.shopLogo}">
                                    <img src="${shop.shopLogo}" alt="${shop.shopName}"
                                         onerror="this.parentNode.innerHTML='<span style=\'font-size:56px\'>🍽️</span><span class=\'shop-badge\'>Đang mở</span>';">
                                </c:when>
                                <c:otherwise>
                                    <span>🍽️</span>
                                </c:otherwise>
                            </c:choose>
                            <span class="shop-badge">Đang mở</span>
                        </div>

                        <div class="shop-body">
                            <div class="shop-name">${shop.shopName}</div>
                            <c:if test="${not empty shop.shopDescription}">
                                <div class="shop-desc">${shop.shopDescription}</div>
                            </c:if>
                            <c:if test="${not empty shop.shopAddress}">
                                <div class="shop-meta">
                                    <span class="icon">📍</span>
                                    <span title="${shop.shopAddress}">${shop.shopAddress}</span>
                                </div>
                            </c:if>
                            <c:if test="${not empty shop.shopPhone}">
                                <div class="shop-meta">
                                    <span class="icon">📞</span>
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

<footer class="text-center text-xs text-gray-400 py-8 border-t border-orange-50 mt-4">
    © 2024 POB Food &nbsp;·&nbsp; Đặt đồ ăn dễ dàng
</footer>

<script>
    function goToShop(shopId) {
        window.location.href = '${pageContext.request.contextPath}/user/shop?id=' + shopId;
    }

    function filterShops(query) {
        document.getElementById('heroSearch').value = query;
        var navInput = document.getElementById('navSearch');
        if (navInput) navInput.value = query;

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
        var countEl = document.getElementById('shopCount');
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
