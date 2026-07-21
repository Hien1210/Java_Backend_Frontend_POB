<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${shop.shopName} – POB Food</title>
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
            background: #05040f;
            color: #f3f1ff;
            min-height: 100vh;
            padding-bottom: 80px;
        }
        a { text-decoration: none; color: inherit; }

        :root {
            --primary: #8b5cf6;
            --primary-dark: #7c3aed;
            --primary-light: rgba(139,92,246,.16);
            --secondary: #22d3ee;
            --secondary-light: rgba(34,211,238,.16);
            --accent-pink: #f472b6;
            --white: #ffffff;
            --bg-deep: #05040f;
            --bg-base: #0b0a1f;
            --bg-panel: #14122c;
            --bg-panel-solid: #181633;
            --bg-input: #0f0e24;
            --border-color: rgba(139,92,246,.22);
            --text-main: #f3f1ff;
            --text-muted: #b3aed6;
            --text-dim: #746fa0;
            --success: #34d399;
            --radius-sm: 8px;
            --radius-md: 14px;
            --radius-lg: 20px;
            --shadow-sm: 0 2px 10px rgba(0,0,0,.35);
            --shadow-md: 0 8px 26px rgba(0,0,0,.45);
            --shadow-lg: 0 18px 50px rgba(0,0,0,.55);
            --glow-primary: 0 0 0 1px rgba(139,92,246,.4), 0 0 22px rgba(139,92,246,.32);
        }

        /* Nền vũ trụ tĩnh + sao lấp lánh */
        .starfield {
            position: fixed; inset: 0; pointer-events: none; z-index: 0;
            background-repeat: repeat;
            background-image:
                radial-gradient(1.6px 1.6px at 20px 30px, rgba(255,255,255,.9) 100%, transparent),
                radial-gradient(1.2px 1.2px at 90px 120px, rgba(255,255,255,.7) 100%, transparent),
                radial-gradient(1.8px 1.8px at 160px 60px, rgba(255,255,255,.85) 100%, transparent),
                radial-gradient(1.2px 1.2px at 230px 180px, rgba(255,255,255,.6) 100%, transparent),
                radial-gradient(1.5px 1.5px at 300px 40px, rgba(255,255,255,.8) 100%, transparent);
            background-size: 340px 260px;
            animation: pobTwinkle 5s ease-in-out infinite alternate;
        }
        @keyframes pobTwinkle { from { opacity: .5; } to { opacity: 1; } }
        body > *:not(.starfield) { position: relative; z-index: 1; }

        /* ══════════ NAVBAR ══════════ */
        .navbar {
            background: rgba(20, 18, 44, .85); backdrop-filter: blur(10px);
            border-bottom: 1px solid var(--border-color);
            position: sticky; top: 0; z-index: 100;
        }
        .navbar-inner {
            max-width: 1100px; margin: 0 auto;
            padding: 0 20px; height: 60px;
            display: flex; align-items: center; gap: 14px;
        }
        .btn-back {
            display: flex; align-items: center; gap: 6px;
            padding: 7px 14px; border-radius: 50px;
            font-size: 13.5px; font-weight: 600; color: var(--text-muted);
            border: 1.5px solid var(--border-color);
            background: var(--bg-panel);
            cursor: pointer; transition: border-color .15s, color .15s;
        }
        .btn-back:hover { border-color: var(--secondary); color: var(--secondary); }
        .navbar-title {
            font-size: 16px; font-weight: 800; color: var(--text-main);
            flex: 1; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;
        }
        .nav-order-link {
            display: flex; align-items: center; gap: 6px;
            padding: 7px 14px; border-radius: 50px;
            font-size: 13px; font-weight: 600; color: var(--text-muted);
            transition: background .15s, color .15s;
        }
        .nav-order-link:hover { background: var(--primary-light); color: var(--primary); }

        /* ══════════ SHOP HERO ══════════ */
        .shop-hero {
            background: linear-gradient(135deg, #1b1440 0%, #3b2a78 50%, #5b21b6 100%);
            position: relative; overflow: hidden;
        }
        .shop-hero::before {
            content: '';
            position: absolute; inset: 0;
            background: radial-gradient(circle at 80% 20%, rgba(34,211,238,.25) 0%, transparent 50%),
                        radial-gradient(circle at 10% 80%, rgba(244,114,182,.18) 0%, transparent 40%);
            pointer-events: none;
        }
        .shop-hero-inner {
            max-width: 1100px; margin: 0 auto;
            padding: 32px 20px 28px;
            display: flex; align-items: center; gap: 20px;
            position: relative; z-index: 1;
        }
        .shop-logo {
            width: 88px; height: 88px; border-radius: var(--radius-md);
            background: rgba(255,255,255,.95);
            display: flex; align-items: center; justify-content: center;
            font-size: 42px; flex-shrink: 0;
            overflow: hidden;
            box-shadow: var(--glow-primary);
            border: 3px solid rgba(255,255,255,.4);
        }
        .shop-logo img { width: 100%; height: 100%; object-fit: cover; }
        .shop-info { flex: 1; min-width: 0; }
        .shop-info h1 {
            font-size: clamp(1.4rem, 3vw, 1.9rem);
            font-weight: 900; color: #fff; line-height: 1.2;
        }
        .shop-info .desc {
            color: rgba(255,255,255,.8); font-size: 13.5px; margin-top: 5px;
            display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;
        }
        .shop-meta-row {
            display: flex; flex-wrap: wrap; gap: 14px; margin-top: 10px;
        }
        .shop-meta-item {
            display: flex; align-items: center; gap: 5px;
            font-size: 12.5px; color: rgba(255,255,255,.78);
        }
        .hero-stats {
            display: flex; gap: 12px; flex-shrink: 0;
        }
        .hero-stat-box {
            background: rgba(255,255,255,.1); backdrop-filter: blur(8px);
            border: 1px solid rgba(255,255,255,.2);
            border-radius: var(--radius-sm);
            padding: 10px 16px; text-align: center;
        }
        .hero-stat-box .val { font-size: 18px; font-weight: 900; color: #fff; }
        .hero-stat-box .lbl { font-size: 10px; color: rgba(255,255,255,.7); margin-top: 1px; }

        /* ══════════ NOTIFICATION ══════════ */
        .notif-wrap { max-width: 1100px; margin: 0 auto; padding: 0 20px; }
        .notif-success {
            display: flex; align-items: center; justify-content: space-between; gap: 10px;
            background: rgba(52,211,153,.1); border: 1.5px solid rgba(52,211,153,.35); border-radius: var(--radius-md);
            padding: 12px 16px; margin-top: 16px;
            font-size: 13.5px; font-weight: 600; color: var(--success);
        }
        .notif-success a {
            background: var(--success); color: #06281d;
            padding: 6px 14px; border-radius: var(--radius-sm);
            font-size: 12.5px; font-weight: 700;
            transition: opacity .15s;
        }
        .notif-success a:hover { opacity: .85; }

        /* ══════════ CATEGORY TABS ══════════ */
        .cat-section {
            background: var(--bg-panel-solid);
            border-bottom: 1px solid var(--border-color);
            position: sticky; top: 60px; z-index: 50;
        }
        .cat-inner {
            max-width: 1100px; margin: 0 auto; padding: 0 20px;
        }
        .cat-scroll {
            display: flex; gap: 8px;
            overflow-x: auto; padding: 14px 0;
            scrollbar-width: none;
        }
        .cat-scroll::-webkit-scrollbar { display: none; }
        .cat-pill {
            padding: 7px 18px; border-radius: 50px;
            font-size: 13px; font-weight: 600;
            border: 2px solid var(--border-color);
            background: var(--bg-panel); color: var(--text-muted);
            cursor: pointer; white-space: nowrap; flex-shrink: 0;
            transition: all .15s;
        }
        .cat-pill:hover { border-color: var(--secondary); color: var(--secondary); }
        .cat-pill.active {
            background: linear-gradient(135deg, var(--primary), var(--secondary)); color: var(--white);
            border-color: transparent;
            box-shadow: var(--glow-primary);
        }

        /* ══════════ PRODUCTS SECTION ══════════ */
        .products-section { max-width: 1100px; margin: 0 auto; padding: 24px 20px; }
        .sec-head {
            display: flex; align-items: center; gap: 10px; margin-bottom: 18px;
        }
        .sec-title { font-size: 18px; font-weight: 800; color: var(--text-main); }
        .sec-count {
            background: var(--primary-light); color: #c4b5fd;
            font-size: 12px; font-weight: 700;
            padding: 2px 10px; border-radius: 50px;
        }

        /* ══════════ PRODUCT CARD ══════════ */
        .product-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(210px, 1fr));
            gap: 16px;
        }
        .product-card {
            background: linear-gradient(180deg, rgba(255,255,255,.045), rgba(255,255,255,.015));
            border-radius: var(--radius-lg);
            border: 1px solid var(--border-color);
            box-shadow: var(--shadow-sm);
            overflow: hidden;
            display: flex; flex-direction: column;
            cursor: pointer;
            transition: transform .22s cubic-bezier(.34,1.56,.64,1), box-shadow .22s, border-color .22s;
        }
        .product-card:hover {
            transform: translateY(-5px);
            box-shadow: var(--glow-primary);
            border-color: var(--primary);
        }
        .product-card.hidden-card { display: none; }

        /* Thumb */
        .p-thumb {
            height: 155px; position: relative; overflow: hidden; flex-shrink: 0;
            background: var(--bg-input);
            display: flex; align-items: center; justify-content: center;
        }
        .p-thumb img {
            width: 100%; height: 100%; object-fit: cover;
            transition: transform .35s;
        }
        .product-card:hover .p-thumb img { transform: scale(1.08); }
        .p-thumb .fallback { font-size: 56px; opacity: .35; }
        .p-overlay {
            position: absolute; inset: 0;
            background: linear-gradient(to bottom, transparent 50%, rgba(0,0,0,.4) 100%);
        }

        /* Status badges */
        .badge-new {
            position: absolute; top: 10px; left: 10px;
            background: var(--secondary); color: #04262e;
            font-size: 10px; font-weight: 800;
            padding: 3px 9px; border-radius: 50px;
            letter-spacing: .3px;
        }
        .badge-hot {
            position: absolute; top: 10px; left: 10px;
            background: var(--accent-pink); color: #2e0a1f;
            font-size: 10px; font-weight: 800;
            padding: 3px 9px; border-radius: 50px;
        }
        .badge-oos {
            position: absolute; top: 10px; left: 10px;
            background: rgba(0,0,0,.6); color: #fff;
            font-size: 10px; font-weight: 700;
            padding: 3px 9px; border-radius: 50px;
        }

        /* Price on thumb */
        .p-price-thumb {
            position: absolute; bottom: 10px; left: 10px;
            background: rgba(11,10,31,.75); backdrop-filter: blur(4px);
            color: #fff; font-size: 12.5px; font-weight: 800;
            padding: 3px 10px; border-radius: 50px;
        }

        /* Body */
        .p-body {
            padding: 13px 14px 6px; flex: 1; display: flex; flex-direction: column; gap: 4px;
        }
        .p-name {
            font-size: 14.5px; font-weight: 800; color: var(--text-main);
            line-height: 1.3;
            display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;
        }
        .p-desc {
            font-size: 12px; color: var(--text-dim); line-height: 1.5;
            display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;
        }
        .p-rating {
            display: flex; align-items: center; gap: 4px;
            font-size: 12px; color: var(--text-dim); margin-top: 2px;
        }
        .p-stars { color: #fbbf24; letter-spacing: -1px; }

        /* Card footer */
        .p-footer {
            display: flex; align-items: center; justify-content: space-between;
            padding: 8px 14px 14px;
        }
        .p-price {
            font-size: 15px; font-weight: 900; color: var(--secondary);
        }
        .p-price small { font-size: 11px; font-weight: 400; color: var(--text-dim); display: block; line-height: 1.2; }
        .btn-add {
            display: flex; align-items: center; justify-content: center;
            width: 36px; height: 36px; border-radius: 50%;
            background: linear-gradient(135deg, var(--primary), var(--secondary)); color: var(--white);
            border: none; font-size: 22px; font-weight: 300;
            cursor: pointer; flex-shrink: 0;
            box-shadow: var(--glow-primary);
            transition: filter .15s, transform .1s;
            line-height: 1;
        }
        .btn-add:hover { filter: brightness(1.15); transform: scale(1.1); }
        .btn-add:disabled {
            background: rgba(255,255,255,.06); color: var(--text-dim);
            cursor: not-allowed; box-shadow: none; transform: none;
        }

        /* ══════════ EMPTY STATE ══════════ */
        .empty-state {
            text-align: center; padding: 80px 24px; color: var(--text-dim);
        }
        .empty-state .e-icon { font-size: 72px; margin-bottom: 16px; line-height: 1; filter: drop-shadow(0 0 14px rgba(139,92,246,.45)); }
        .empty-state .e-title { font-size: 17px; font-weight: 700; color: var(--text-muted); }
        .empty-state .e-sub { font-size: 13px; margin-top: 6px; }

        /* ══════════ MODAL ══════════ */
        .modal-overlay {
            position: fixed; inset: 0;
            background: rgba(3,2,12,.7); backdrop-filter: blur(4px);
            display: flex; align-items: flex-end; justify-content: center;
            z-index: 300; opacity: 0; pointer-events: none;
            transition: opacity .22s;
        }
        .modal-overlay.open { opacity: 1; pointer-events: all; }
        .modal-box {
            background: var(--bg-panel-solid);
            border: 1px solid var(--border-color); border-bottom: none;
            border-radius: 24px 24px 0 0;
            padding: 0;
            width: 100%; max-width: 520px;
            transform: translateY(50px);
            transition: transform .25s cubic-bezier(.4,0,.2,1);
            max-height: 92vh; overflow-y: auto;
        }
        .modal-overlay.open .modal-box { transform: translateY(0); }

        /* Modal header */
        .modal-header {
            position: sticky; top: 0; z-index: 10;
            background: var(--bg-panel-solid);
            padding: 20px 20px 16px;
            border-bottom: 1px solid var(--border-color);
            display: flex; align-items: flex-start; justify-content: space-between; gap: 12px;
        }
        .modal-title-wrap .m-name {
            font-size: 17px; font-weight: 800; color: var(--text-main); line-height: 1.3;
        }
        .modal-title-wrap .m-sub { font-size: 12.5px; color: var(--text-dim); margin-top: 2px; }
        .modal-close {
            width: 32px; height: 32px; border-radius: 50%;
            background: var(--bg-input); border: none;
            display: flex; align-items: center; justify-content: center;
            font-size: 18px; cursor: pointer; flex-shrink: 0;
            color: var(--text-muted); transition: background .15s;
        }
        .modal-close:hover { background: var(--primary-light); color: var(--primary); }

        .modal-body { padding: 20px; }

        /* Size selector */
        .m-section-title {
            font-size: 13px; font-weight: 700; color: var(--text-main);
            margin-bottom: 10px; display: flex; align-items: center; gap: 4px;
        }
        .m-required { color: var(--accent-pink); }
        .size-radio { display: none; }
        .size-label {
            display: inline-flex; flex-direction: column; align-items: center;
            padding: 9px 16px; border-radius: var(--radius-sm);
            border: 2px solid var(--border-color); font-size: 13px; font-weight: 600;
            cursor: pointer; transition: all .12s; text-align: center;
            background: var(--bg-input);
        }
        .size-label .s-name { color: var(--text-main); }
        .size-label .s-price { font-size: 11.5px; color: var(--text-dim); font-weight: 500; margin-top: 1px; }
        .size-radio:checked + .size-label {
            background: var(--primary-light);
            border-color: var(--primary);
        }
        .size-radio:checked + .size-label .s-name { color: #c4b5fd; }
        .size-radio:checked + .size-label .s-price { color: #c4b5fd; }

        /* Topping */
        .topping-item {
            display: flex; align-items: center; justify-content: space-between;
            padding: 10px 12px; border-radius: var(--radius-sm);
            border: 1.5px solid var(--border-color); margin-bottom: 6px;
            font-size: 13px; color: var(--text-muted);
            background: var(--bg-input);
        }
        .topping-item .t-price { font-weight: 700; color: var(--secondary); }

        /* Quantity */
        .qty-row {
            display: flex; align-items: center; gap: 14px;
        }
        .qty-btn {
            width: 36px; height: 36px; border-radius: 50%;
            border: 2px solid var(--border-color); background: var(--bg-input);
            font-size: 20px; font-weight: 300; cursor: pointer;
            display: flex; align-items: center; justify-content: center;
            color: var(--text-main); transition: border-color .15s, background .15s;
            line-height: 1;
        }
        .qty-btn:hover { border-color: var(--primary); background: var(--primary-light); }
        .qty-val { font-size: 18px; font-weight: 800; min-width: 28px; text-align: center; color: var(--text-main); }

        /* Summary */
        .m-summary {
            background: var(--primary-light); border: 1.5px solid rgba(139,92,246,.35);
            border-radius: var(--radius-md); padding: 14px 16px;
            display: flex; align-items: center; justify-content: space-between;
            margin-top: 18px;
        }
        .m-summary .s-label { font-size: 13px; color: var(--text-muted); font-weight: 600; }
        .m-summary .s-total { font-size: 18px; font-weight: 900; color: #c4b5fd; }

        .btn-submit {
            width: 100%; margin-top: 14px; padding: 14px;
            border-radius: var(--radius-md); border: none;
            background: linear-gradient(135deg, var(--primary), var(--secondary)); color: var(--white);
            font-size: 15px; font-weight: 800; cursor: pointer;
            box-shadow: var(--glow-primary);
            transition: filter .15s, transform .1s;
        }
        .btn-submit:hover { filter: brightness(1.1); transform: scale(.99); }

        /* ══════════ CART BAR ══════════ */
        .cart-bar {
            position: fixed; bottom: 0; left: 0; right: 0;
            background: linear-gradient(135deg, var(--primary-dark), var(--primary), var(--secondary));
            padding: 14px 24px;
            display: flex; align-items: center; justify-content: space-between; gap: 16px;
            z-index: 200; transform: translateY(100%);
            transition: transform .28s cubic-bezier(.4,0,.2,1);
            box-shadow: 0 -4px 24px rgba(139,92,246,.4);
        }
        .cart-bar.visible { transform: translateY(0); }
        .cart-bar-label { font-size: 14px; font-weight: 700; color: #fff; }
        .cart-bar-label small { display: block; font-size: 11px; font-weight: 400; opacity: .85; }
        .cart-bar-btn {
            background: #fff; color: var(--primary-dark);
            font-size: 13.5px; font-weight: 800;
            padding: 9px 20px; border-radius: 50px;
            white-space: nowrap;
            box-shadow: 0 2px 8px rgba(0,0,0,.25);
            transition: opacity .15s;
        }
        .cart-bar-btn:hover { opacity: .9; }

        /* ══════════ RESPONSIVE ══════════ */
        @media (max-width: 640px) {
            .hero-stats { display: none; }
            .shop-hero-inner { padding: 24px 16px; gap: 14px; }
            .shop-logo { width: 72px; height: 72px; font-size: 34px; }
            .product-grid { grid-template-columns: repeat(2, 1fr); gap: 12px; }
        }
        @media (max-width: 400px) {
            .product-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
<div class="starfield"></div>

<!-- ═══════════════════ NAVBAR ═══════════════════ -->
<nav class="navbar">
    <div class="navbar-inner">
        <a href="${pageContext.request.contextPath}/user/home" class="btn-back">
            ← Trang chủ
        </a>
        <div class="navbar-title">${shop.shopName}</div>
        <a href="${pageContext.request.contextPath}/user/donhang" class="nav-order-link">
            📦 Đơn hàng
        </a>
    </div>
</nav>

<!-- ═══════════════════ SHOP HERO ═══════════════════ -->
<div class="shop-hero">
    <div class="shop-hero-inner">
        <div class="shop-logo">
            <c:choose>
                <c:when test="${not empty shop.shopLogo}">
                    <img src="${shop.shopLogo}" alt="${shop.shopName}"
                         onerror="this.parentNode.innerHTML='🍽️'">
                </c:when>
                <c:otherwise>🍽️</c:otherwise>
            </c:choose>
        </div>

        <div class="shop-info">
            <h1>${shop.shopName}</h1>
            <c:if test="${not empty shop.shopDescription}">
                <div class="desc">${shop.shopDescription}</div>
            </c:if>
            <div class="shop-meta-row">
                <c:if test="${not empty shop.shopAddress}">
                    <span class="shop-meta-item">📍 ${shop.shopAddress}</span>
                </c:if>
                <c:if test="${not empty shop.shopPhone}">
                    <span class="shop-meta-item">📞 ${shop.shopPhone}</span>
                </c:if>
                <span class="shop-meta-item">
                    <span style="color:#34d399;font-size:8px;">●</span> &nbsp;Đang mở cửa
                </span>
            </div>
        </div>

        <div class="hero-stats">
            <div class="hero-stat-box">
                <div class="val">4.8 ⭐</div>
                <div class="lbl">Đánh giá</div>
            </div>
            <div class="hero-stat-box">
                <div class="val">30'</div>
                <div class="lbl">Giao hàng</div>
            </div>
            <div class="hero-stat-box">
                <div class="val">
                    <c:choose>
                        <c:when test="${not empty products}">${fn:length(products)}</c:when>
                        <c:otherwise>0</c:otherwise>
                    </c:choose>
                </div>
                <div class="lbl">Món ăn</div>
            </div>
        </div>
    </div>
</div>

<!-- Thông báo thành công -->
<div class="notif-wrap">
    <c:if test="${param.added eq '1'}">
        <div class="notif-success">
            <span>✅ Đã thêm vào giỏ hàng thành công!</span>
            <a href="${pageContext.request.contextPath}/checkout?cartId=${param.cartId}">
                Thanh toán ngay →
            </a>
        </div>
    </c:if>
</div>

<!-- ═══════════════════ CATEGORY TABS ═══════════════════ -->
<c:if test="${not empty categories}">
    <div class="cat-section">
        <div class="cat-inner">
            <div class="cat-scroll">
                <button class="cat-pill active" onclick="filterCategory('all', this)">🍽️ Tất cả</button>
                <c:forEach var="cat" items="${categories}">
                    <button class="cat-pill" onclick="filterCategory('${cat.id}', this)">
                        ${cat.categoryName}
                    </button>
                </c:forEach>
            </div>
        </div>
    </div>
</c:if>

<!-- ═══════════════════ PRODUCTS ═══════════════════ -->
<div class="products-section">
    <div class="sec-head">
        <h2 class="sec-title">🛒 Thực đơn</h2>
        <span class="sec-count" id="productCount">
            <c:choose>
                <c:when test="${not empty products}">${fn:length(products)}</c:when>
                <c:otherwise>0</c:otherwise>
            </c:choose> món
        </span>
    </div>

    <c:choose>
        <c:when test="${empty products}">
            <div class="empty-state">
                <div class="e-icon">🍽️</div>
                <div class="e-title">Quán chưa có món nào</div>
                <div class="e-sub">Vui lòng quay lại sau!</div>
            </div>
        </c:when>
        <c:otherwise>
            <div class="product-grid" id="productGrid">
                <c:forEach var="p" items="${products}" varStatus="vs">
                    <div class="product-card" data-cat="${p.categoryId}" id="pcard-${p.id}">

                        <!-- Ảnh -->
                        <div class="p-thumb">
                            <c:choose>
                                <c:when test="${not empty p.imageUrl}">
                                    <img src="${p.imageUrl}" alt="${p.productName}"
                                         onerror="this.style.display='none';this.nextSibling.style.display='flex'">
                                    <div class="fallback" style="display:none;width:100%;height:100%;align-items:center;justify-content:center;">🍜</div>
                                </c:when>
                                <c:otherwise>
                                    <div class="fallback">🍜</div>
                                </c:otherwise>
                            </c:choose>
                            <div class="p-overlay"></div>

                            <%-- Badge trạng thái --%>
                            <c:choose>
                                <c:when test="${p.staTus eq 'OUT_OF_STOCK'}">
                                    <div class="badge-oos">Hết hàng</div>
                                </c:when>
                                <c:when test="${vs.index < 3}">
                                    <div class="badge-hot">🔥 Hot</div>
                                </c:when>
                                <c:when test="${vs.index >= 3 and vs.index < 6}">
                                    <div class="badge-new">Mới</div>
                                </c:when>
                            </c:choose>

                            <%-- Giá trên ảnh --%>
                            <c:if test="${not empty p.sizes}">
                                <div class="p-price-thumb">
                                    từ <fmt:formatNumber value="${p.sizes[0].price}" type="number" groupingUsed="true"/>đ
                                </div>
                            </c:if>
                        </div>

                        <!-- Nội dung -->
                        <div class="p-body">
                            <div class="p-name">${p.productName}</div>
                            <c:if test="${not empty p.description}">
                                <div class="p-desc">${p.description}</div>
                            </c:if>
                            <div class="p-rating">
                                <span class="p-stars">★★★★</span>
                                <span>${4}.${5 - (vs.index mod 3)} (${12 + (vs.index mod 30)} đánh giá)</span>
                            </div>
                        </div>

                        <!-- Footer card -->
                        <div class="p-footer">
                            <div class="p-price">
                                <c:choose>
                                    <c:when test="${not empty p.sizes}">
                                        <fmt:formatNumber value="${p.sizes[0].price}" type="number" groupingUsed="true"/>đ
                                        <small>Từ size nhỏ nhất</small>
                                    </c:when>
                                    <c:otherwise>
                                        Liên hệ
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <button class="btn-add"
                                    <c:if test="${p.staTus eq 'OUT_OF_STOCK'}">disabled title="Hết hàng"</c:if>
                                    onclick="openModal(${p.id}, '${fn:escapeXml(p.productName)}', '${fn:escapeXml(p.description)}', ${shop.id},
                                        [<c:forEach var="s" items="${p.sizes}" varStatus="st">{id:${s.id},name:'${fn:escapeXml(s.sizeName)}',price:${s.price}}<c:if test="${!st.last}">,</c:if></c:forEach>])">
                                +
                            </button>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <div id="noResults" class="empty-state" style="display:none;">
                <div class="e-icon">🔍</div>
                <div class="e-title">Không có món nào trong danh mục này</div>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<!-- ═══════════════════ MODAL THÊM VÀO GIỎ ═══════════════════ -->
<div class="modal-overlay" id="modalOverlay" onclick="closeModalOnBg(event)">
    <div class="modal-box">
        <div class="modal-header">
            <div class="modal-title-wrap">
                <div class="m-name" id="modalTitle">Chọn tùy chọn</div>
                <div class="m-sub" id="modalDesc"></div>
            </div>
            <button class="modal-close" onclick="closeModal()">×</button>
        </div>

        <div class="modal-body">
            <form action="${pageContext.request.contextPath}/user/add-to-cart" method="post" id="addToCartForm">
                <input type="hidden" name="productId" id="modalProductId">
                <input type="hidden" name="shopId" value="${shop.id}">

                <!-- Size -->
                <div id="sizeSection">
                    <div class="m-section-title">
                        Chọn size <span class="m-required">*</span>
                    </div>
                    <div class="flex gap-2 flex-wrap" id="sizeOptions" style="display:flex;flex-wrap:wrap;gap:8px;"></div>
                </div>

                <!-- Topping tham khảo -->
                <c:if test="${not empty toppings}">
                    <div style="margin-top:18px;">
                        <div class="m-section-title">Topping (tham khảo)</div>
                        <c:forEach var="t" items="${toppings}">
                            <div class="topping-item">
                                <span>${t.toppingName}</span>
                                <span class="t-price">+<fmt:formatNumber value="${t.price}" type="number" groupingUsed="true"/>đ</span>
                            </div>
                        </c:forEach>
                        <p style="font-size:11.5px;color:var(--text-dim);margin-top:6px;">* Liên hệ shop để chọn topping khi đặt hàng</p>
                    </div>
                </c:if>

                <!-- Số lượng -->
                <div style="margin-top:18px;">
                    <div class="m-section-title">Số lượng</div>
                    <div class="qty-row">
                        <button type="button" class="qty-btn" onclick="changeQty(-1)">−</button>
                        <span class="qty-val" id="qtyDisplay">1</span>
                        <button type="button" class="qty-btn" onclick="changeQty(1)">+</button>
                        <input type="hidden" name="quantity" id="qtyInput" value="1">
                    </div>
                </div>

                <!-- Tổng tiền -->
                <div class="m-summary">
                    <span class="s-label">🧾 Tạm tính</span>
                    <span class="s-total" id="totalPrice">—</span>
                </div>

                <button type="submit" class="btn-submit" id="submitBtn">
                    🛒 Thêm vào giỏ hàng
                </button>
            </form>
        </div>
    </div>
</div>

<!-- ═══════════════════ CART BAR ═══════════════════ -->
<div class="cart-bar" id="cartBar">
    <div class="cart-bar-label">
        🛒 Đã thêm vào giỏ hàng!
        <small>Tiếp tục chọn thêm hoặc thanh toán</small>
    </div>
    <a href="${pageContext.request.contextPath}/checkout?cartId=${param.cartId}" class="cart-bar-btn">
        Thanh toán →
    </a>
</div>

<script>
    var currentSizes = [];
    var selectedSizePrice = 0;
    var qty = 1;

    /* ── Open modal ── */
    function openModal(productId, productName, productDesc, shopId, sizes) {
        document.getElementById('modalProductId').value = productId;
        document.getElementById('modalTitle').textContent = productName;
        document.getElementById('modalDesc').textContent = productDesc || '';

        currentSizes = sizes;
        qty = 1;
        document.getElementById('qtyDisplay').textContent = 1;
        document.getElementById('qtyInput').value = 1;

        var sizeSection = document.getElementById('sizeSection');
        var sizeOptions = document.getElementById('sizeOptions');
        sizeOptions.innerHTML = '';

        if (sizes && sizes.length > 0) {
            sizeSection.style.display = 'block';
            sizes.forEach(function(s, i) {
                var uid = 'sz_' + s.id;
                var inp = document.createElement('input');
                inp.type = 'radio'; inp.name = 'sizeId'; inp.value = s.id;
                inp.id = uid; inp.className = 'size-radio';
                if (i === 0) { inp.checked = true; selectedSizePrice = s.price; }
                inp.addEventListener('change', function() {
                    selectedSizePrice = s.price;
                    updateTotal();
                });

                var lbl = document.createElement('label');
                lbl.htmlFor = uid; lbl.className = 'size-label';
                lbl.innerHTML = '<span class="s-name">' + s.name + '</span>'
                              + '<span class="s-price">' + s.price.toLocaleString('vi-VN') + 'đ</span>';

                sizeOptions.appendChild(inp);
                sizeOptions.appendChild(lbl);
            });
        } else {
            sizeSection.style.display = 'none';
            selectedSizePrice = 0;
        }

        updateTotal();
        document.getElementById('modalOverlay').classList.add('open');
        document.body.style.overflow = 'hidden';
    }

    function closeModal() {
        document.getElementById('modalOverlay').classList.remove('open');
        document.body.style.overflow = '';
    }
    function closeModalOnBg(e) {
        if (e.target === document.getElementById('modalOverlay')) closeModal();
    }

    /* ── Quantity ── */
    function changeQty(delta) {
        qty = Math.max(1, Math.min(99, qty + delta));
        document.getElementById('qtyDisplay').textContent = qty;
        document.getElementById('qtyInput').value = qty;
        updateTotal();
    }

    function updateTotal() {
        var total = selectedSizePrice * qty;
        document.getElementById('totalPrice').textContent =
            total > 0 ? total.toLocaleString('vi-VN') + 'đ' : '—';
    }

    /* ── Category filter ── */
    function filterCategory(catId, btn) {
        document.querySelectorAll('.cat-pill').forEach(function(p) { p.classList.remove('active'); });
        btn.classList.add('active');

        var cards = document.querySelectorAll('#productGrid .product-card');
        var visible = 0;
        cards.forEach(function(card) {
            var show = catId === 'all' || card.dataset.cat == catId;
            card.style.display = show ? '' : 'none';
            if (show) visible++;
        });

        var noR = document.getElementById('noResults');
        if (noR) noR.style.display = (visible === 0) ? 'block' : 'none';
        var cnt = document.getElementById('productCount');
        if (cnt) cnt.textContent = visible + ' món';
    }

    /* ── Form validation ── */
    document.getElementById('addToCartForm').addEventListener('submit', function(e) {
        var ss = document.getElementById('sizeSection');
        if (ss && ss.style.display !== 'none') {
            if (!document.querySelector('input[name="sizeId"]:checked')) {
                e.preventDefault();
                alert('Vui lòng chọn size trước khi thêm vào giỏ!');
            }
        }
    });

    /* ── Cart bar ── */
    (function() {
        var bar = document.getElementById('cartBar');
        var added = '${param.added}';
        if (added === '1') {
            bar.classList.add('visible');
        }
    })();

    /* ── Keyboard: ESC to close ── */
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') closeModal();
    });
</script>
</body>
</html>
