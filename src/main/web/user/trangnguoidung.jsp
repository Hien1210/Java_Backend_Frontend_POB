<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Khám phá món ăn - POB</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Inter', -apple-system, sans-serif; background: #f0f4f8; min-height: 100vh; }

        /* ===== NAVBAR ===== */
        .navbar {
            background: #fff; border-bottom: 1px solid #e9edf2;
            box-shadow: 0 1px 6px rgba(26,32,53,0.06);
            position: sticky; top: 0; z-index: 50;
            padding: 0 24px; height: 60px;
            display: flex; align-items: center; gap: 16px;
        }
        .nav-logo { display: flex; align-items: center; gap: 10px; text-decoration: none; flex-shrink: 0; }
        .nav-logo-badge { width: 36px; height: 36px; border-radius: 10px; background: linear-gradient(135deg,#1a2035,#2d3a6e); display: flex; align-items: center; justify-content: center; color: #fff; font-weight: 800; font-size: 12px; }
        .nav-logo-name { font-size: 16px; font-weight: 800; color: #0f172a; }

        .nav-search { flex: 1; max-width: 320px; position: relative; margin: 0 8px; }
        .nav-search input { width: 100%; padding: 8px 12px 8px 36px; border: 1.5px solid #e2e8f0; border-radius: 10px; font-size: 13.5px; font-family: inherit; background: #f8fafc; color: #0f172a; outline: none; transition: border-color 0.2s; }
        .nav-search input:focus { border-color: #10b981; background: #fff; }
        .nav-search-icon { position: absolute; left: 10px; top: 50%; transform: translateY(-50%); font-size: 15px; color: #94a3b8; pointer-events: none; }

        .nav-links { margin-left: auto; display: flex; align-items: center; gap: 20px; }
        .nav-link { display: flex; align-items: center; gap: 5px; font-size: 13.5px; font-weight: 500; color: #64748b; text-decoration: none; transition: color 0.2s; }
        .nav-link:hover { color: #10b981; }

        .avatar-wrap { position: relative; }
        .avatar-btn {
            width: 36px; height: 36px; border-radius: 50%;
            background: linear-gradient(135deg, #1a2035, #10b981);
            color: #fff; font-size: 14px; font-weight: 700;
            display: flex; align-items: center; justify-content: center;
            cursor: pointer; border: none; overflow: hidden; flex-shrink: 0;
        }
        .avatar-btn img { width: 100%; height: 100%; object-fit: cover; }

        .dropdown {
            position: absolute; top: calc(100% + 10px); right: 0;
            background: #fff; border: 1px solid #e9edf2;
            border-radius: 14px; box-shadow: 0 10px 32px rgba(26,32,53,0.14);
            min-width: 200px; overflow: hidden; display: none; z-index: 100;
        }
        .dropdown.open { display: block; }
        .dropdown-header { padding: 14px 16px; border-bottom: 1px solid #f1f5f9; }
        .dropdown-header .name { font-size: 13.5px; font-weight: 700; color: #0f172a; }
        .dropdown-header .email { font-size: 11.5px; color: #94a3b8; margin-top: 2px; }
        .dropdown a, .dropdown button {
            display: flex; align-items: center; gap: 9px;
            width: 100%; padding: 11px 16px;
            font-size: 13px; font-weight: 500; color: #374151;
            text-decoration: none; background: none; border: none;
            cursor: pointer; font-family: inherit; transition: background 0.1s;
        }
        .dropdown a:hover, .dropdown button:hover { background: #f8fafc; color: #10b981; }
        .dropdown-divider { height: 1px; background: #f1f5f9; margin: 4px 0; }

        /* ===== HERO ===== */
        .hero {
            background: linear-gradient(140deg, #1a2035 0%, #0f1624 60%, #162035 100%);
            padding: 56px 24px 72px; text-align: center; position: relative; overflow: hidden;
        }
        .hero::before { content: ''; position: absolute; top: -100px; right: -100px; width: 400px; height: 400px; border-radius: 50%; background: radial-gradient(circle, rgba(16,185,129,0.12) 0%, transparent 70%); }
        .hero::after  { content: ''; position: absolute; bottom: -60px; left: -60px; width: 280px; height: 280px; border-radius: 50%; background: radial-gradient(circle, rgba(245,158,11,0.07) 0%, transparent 70%); }
        .hero-content { position: relative; z-index: 1; }
        .hero h1 { font-size: 36px; font-weight: 800; color: #fff; letter-spacing: -0.02em; margin-bottom: 8px; }
        .hero h1 span { color: #f59e0b; }
        .hero p { font-size: 14px; color: rgba(255,255,255,0.45); margin-bottom: 24px; }

        .search-hero { position: relative; max-width: 520px; margin: 0 auto; }
        .search-hero input {
            width: 100%; padding: 16px 20px 16px 50px;
            border-radius: 16px; border: none; font-size: 15px; font-family: inherit;
            box-shadow: 0 6px 24px rgba(0,0,0,0.18); outline: none; color: #0f172a;
            transition: box-shadow 0.2s;
        }
        .search-hero input:focus { box-shadow: 0 6px 28px rgba(16,185,129,0.2); }
        .search-hero-icon { position: absolute; left: 18px; top: 50%; transform: translateY(-50%); font-size: 18px; pointer-events: none; }

        /* ===== SHOP GRID ===== */
        .section { max-width: 1200px; margin: 0 auto; padding: 32px 20px; }
        .section-header { display: flex; align-items: flex-end; justify-content: space-between; margin-bottom: 20px; }
        .section-title { font-size: 20px; font-weight: 800; color: #0f172a; }
        .section-count { font-size: 13px; color: #94a3b8; margin-top: 3px; }

        .shop-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(240px, 1fr)); gap: 20px; }

        .shop-card {
            background: #fff; border-radius: 18px;
            border: 1px solid #eef0f4;
            box-shadow: 0 2px 10px rgba(26,32,53,0.06);
            overflow: hidden; display: flex; flex-direction: column;
            cursor: pointer; transition: transform 0.18s, box-shadow 0.18s;
        }
        .shop-card:hover { transform: translateY(-4px); box-shadow: 0 10px 30px rgba(26,32,53,0.13); }

        .shop-img {
            height: 150px; background: linear-gradient(135deg,#f0f4f8,#e8ecf2);
            display: flex; align-items: center; justify-content: center; font-size: 54px;
            overflow: hidden; position: relative; flex-shrink: 0;
        }
        .shop-img img { width: 100%; height: 100%; object-fit: cover; }
        .shop-open-badge {
            position: absolute; top: 10px; right: 10px;
            background: #dcfce7; color: #16a34a;
            font-size: 10.5px; font-weight: 700; padding: 3px 10px; border-radius: 99px;
        }

        .shop-body { padding: 16px; flex: 1; display: flex; flex-direction: column; gap: 5px; }
        .shop-name { font-size: 15px; font-weight: 700; color: #0f172a; line-height: 1.3; }
        .shop-desc { font-size: 12.5px; color: #64748b; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; }
        .shop-meta { display: flex; align-items: flex-start; gap: 5px; font-size: 12px; color: #94a3b8; }
        .shop-meta span:last-child { overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }

        .shop-cta {
            margin: 0 16px 16px;
            padding: 10px;
            border-radius: 12px;
            background: linear-gradient(135deg, #10b981, #059669);
            color: #fff; font-size: 13px; font-weight: 600;
            text-align: center; transition: opacity 0.15s;
        }
        .shop-cta:hover { opacity: 0.88; }

        .empty-state { text-align: center; padding: 72px 24px; color: #94a3b8; }
        .empty-state .empty-icon { font-size: 60px; margin-bottom: 14px; }
        .empty-state .empty-title { font-size: 17px; font-weight: 600; color: #64748b; margin-bottom: 6px; }
        .empty-state .empty-sub   { font-size: 13px; }

        footer { text-align: center; font-size: 12px; color: #b0bcc9; padding: 28px 24px; border-top: 1px solid #e9edf2; margin-top: 16px; }

        @media (max-width: 600px) {
            .nav-search, .nav-link span { display: none; }
            .hero h1 { font-size: 26px; }
            .shop-grid { grid-template-columns: 1fr 1fr; gap: 12px; }
        }
    </style>
</head>
<body>

<!-- NAVBAR -->
<nav class="navbar">
    <a href="${pageContext.request.contextPath}/user/home" class="nav-logo">
        <div class="nav-logo-badge">POB</div>
        <span class="nav-logo-name">POB Food</span>
    </a>

    <div class="nav-search">
        <span class="nav-search-icon">🔍</span>
        <input id="navSearch" type="text" placeholder="Tìm quán..." oninput="filterShops(this.value)">
    </div>

    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/user/donhang" class="nav-link">📦 <span>Đơn hàng</span></a>
        <a href="${pageContext.request.contextPath}/user/dia-chi" class="nav-link">📍 <span>Địa chỉ</span></a>

        <div class="avatar-wrap" id="avatarWrap">
            <button class="avatar-btn" onclick="toggleDropdown()" title="${account.fullName}">
                <c:choose>
                    <c:when test="${not empty account.avatarUrl}">
                        <img src="${account.avatarUrl}" alt="avatar">
                    </c:when>
                    <c:otherwise>
                        <c:choose>
                            <c:when test="${not empty account.fullName}">${fn:substring(account.fullName,0,1)}</c:when>
                            <c:otherwise>${fn:substring(account.userName,0,1)}</c:otherwise>
                        </c:choose>
                    </c:otherwise>
                </c:choose>
            </button>
            <div class="dropdown" id="accountDropdown">
                <div class="dropdown-header">
                    <div class="name"><c:choose><c:when test="${not empty account.fullName}">${account.fullName}</c:when><c:otherwise>${account.userName}</c:otherwise></c:choose></div>
                    <c:if test="${not empty account.email}"><div class="email">${account.email}</div></c:if>
                </div>
                <a href="${pageContext.request.contextPath}/user/donhang">📦 Đơn hàng của tôi</a>
                <a href="${pageContext.request.contextPath}/user/dia-chi">📍 Địa chỉ giao hàng</a>
                <a href="${pageContext.request.contextPath}/user/doi-mat-khau">🔒 Đổi mật khẩu</a>
                <div class="dropdown-divider"></div>
                <form action="${pageContext.request.contextPath}/logout" method="post">
                    <button type="submit">🚪 Đăng xuất</button>
                </form>
            </div>
        </div>
    </div>
</nav>

<!-- HERO -->
<div class="hero">
    <div class="hero-content">
        <h1>Hôm nay bạn muốn ăn gì? <span>🍜</span></h1>
        <p>Khám phá các quán ăn ngon đang phục vụ</p>
        <div class="search-hero">
            <span class="search-hero-icon">🔍</span>
            <input id="heroSearch" type="text" placeholder="Tìm quán ăn, món ăn..." oninput="filterShops(this.value)">
        </div>
    </div>
</div>

<!-- SHOP LIST -->
<div class="section">
    <div class="section-header">
        <div>
            <div class="section-title">Cửa hàng đang hoạt động</div>
            <div class="section-count" id="shopCount">
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
                <div class="empty-icon">🍽️</div>
                <div class="empty-title">Chưa có cửa hàng nào mở cửa</div>
                <div class="empty-sub">Vui lòng quay lại sau nhé!</div>
            </div>
        </c:when>
        <c:otherwise>
            <div class="shop-grid" id="shopGrid">
                <c:forEach var="shop" items="${shops}">
                    <div class="shop-card"
                         data-name="${fn:toLowerCase(shop.shopName)}"
                         data-desc="${fn:toLowerCase(shop.shopDescription)}"
                         data-addr="${fn:toLowerCase(shop.shopAddress)}"
                         onclick="goToShop(${shop.id})">

                        <div class="shop-img">
                            <c:choose>
                                <c:when test="${not empty shop.shopLogo}">
                                    <img src="${shop.shopLogo}" alt="${shop.shopName}"
                                         onerror="this.parentNode.innerHTML='<span style=\'font-size:52px\'>🍽️</span>';">
                                </c:when>
                                <c:otherwise><span>🍽️</span></c:otherwise>
                            </c:choose>
                            <span class="shop-open-badge">● Đang mở</span>
                        </div>

                        <div class="shop-body">
                            <div class="shop-name">${shop.shopName}</div>
                            <c:if test="${not empty shop.shopDescription}">
                                <div class="shop-desc">${shop.shopDescription}</div>
                            </c:if>
                            <c:if test="${not empty shop.shopAddress}">
                                <div class="shop-meta"><span>📍</span><span title="${shop.shopAddress}">${shop.shopAddress}</span></div>
                            </c:if>
                            <c:if test="${not empty shop.shopPhone}">
                                <div class="shop-meta"><span>📞</span><span>${shop.shopPhone}</span></div>
                            </c:if>
                        </div>

                        <div class="shop-cta">Xem thực đơn →</div>
                    </div>
                </c:forEach>
            </div>

            <div id="noResults" class="empty-state" style="display:none;">
                <div class="empty-icon">🔍</div>
                <div class="empty-title">Không tìm thấy quán nào</div>
                <div class="empty-sub">Thử từ khoá khác nhé</div>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<footer>© 2026 POB Food &nbsp;·&nbsp; Đặt đồ ăn dễ dàng</footer>

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
            var match = !q || (card.dataset.name || '').includes(q) || (card.dataset.desc || '').includes(q) || (card.dataset.addr || '').includes(q);
            card.style.display = match ? '' : 'none';
            if (match) visible++;
        });

        var noResults = document.getElementById('noResults');
        var countEl = document.getElementById('shopCount');
        if (noResults) noResults.style.display = (visible === 0) ? 'block' : 'none';
        if (countEl) countEl.textContent = q ? visible + ' cửa hàng khớp với "' + query + '"' : visible + ' cửa hàng';
    }

    function toggleDropdown() {
        document.getElementById('accountDropdown').classList.toggle('open');
    }
    document.addEventListener('click', function(e) {
        var wrap = document.getElementById('avatarWrap');
        if (wrap && !wrap.contains(e.target)) document.getElementById('accountDropdown').classList.remove('open');
    });
</script>
</body>
</html>
