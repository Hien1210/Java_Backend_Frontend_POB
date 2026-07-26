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
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;700&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            font-family: 'Be Vietnam Pro', 'Inter', system-ui, -apple-system, sans-serif;
            background: #FAFAFA;
            color: #1A1A1A;
            min-height: 100vh;
            padding-bottom: 80px;
        }
        a { text-decoration: none; color: inherit; }

        :root {
            --primary: #FF6B35;
            --primary-hover: #FF8C5A;
            --primary-light: #FFF0EB;
            --primary-light-border: #FFD4C2;
            --primary-dark-text: #CC4A1A;
            --secondary: #FF8C5A;
            --accent-pink: #FF6B35;
            --white: #ffffff;
            --bg-page: #FAFAFA;
            --bg-panel: #FFFFFF;
            --bg-panel-solid: #FFFFFF;
            --bg-input: #F5F5F5;
            --border-color: #EEEEEE;
            --text-main: #1A1A1A;
            --text-muted: #666666;
            --text-dim: #999999;
            --success: #2E9E5B;
            --radius-sm: 8px;
            --radius-md: 14px;
            --radius-lg: 12px;
            --shadow-sm: 0 2px 10px rgba(0,0,0,.05);
            --shadow-md: 0 8px 26px rgba(0,0,0,.08);
            --shadow-lg: 0 18px 50px rgba(0,0,0,.12);
            --glow-primary: 0 4px 14px rgba(255,107,53,.28);
        }

        .starfield { display: none; }
        .shop-hero, .products-section, .notif-wrap { position: relative; }

        /* ══════════ NAVBAR ══════════ */
        .navbar {
            background: #FFFFFF;
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
            font-size: 13.5px; font-weight: 500; color: #444;
            border: 1px solid var(--border-color);
            background: #FFFFFF;
            cursor: pointer; transition: border-color .15s, color .15s;
        }
        .btn-back:hover { border-color: var(--primary); color: var(--primary); }
        .navbar-title {
            font-size: 16px; font-weight: 500; color: var(--text-main);
            flex: 1; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;
        }
        .nav-order-link {
            display: flex; align-items: center; gap: 6px;
            padding: 7px 14px; border-radius: 50px;
            font-size: 13px; font-weight: 500; color: #444;
            transition: background .15s, color .15s;
        }
        .nav-order-link:hover { background: var(--primary-light); color: var(--primary); }

        /* ══════════ SHOP HERO ══════════ */
        .shop-hero {
            background: linear-gradient(135deg, #FFF0EB 0%, #FFE4D6 100%);
            overflow: hidden;
            border-bottom: 1px solid var(--border-color);
        }
        .shop-hero::before {
            content: '';
            position: absolute; inset: 0;
            background: radial-gradient(circle at 80% 20%, rgba(255,140,90,.15) 0%, transparent 50%);
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
            background: #FFFFFF;
            display: flex; align-items: center; justify-content: center;
            font-size: 42px; flex-shrink: 0;
            overflow: hidden;
            box-shadow: var(--shadow-md);
            border: 3px solid #FFFFFF;
        }
        .shop-logo img { width: 100%; height: 100%; object-fit: cover; }
        .shop-info { flex: 1; min-width: 0; }
        .shop-info h1 {
            font-size: clamp(1.4rem, 3vw, 1.9rem);
            font-weight: 500; color: #1A1A1A; line-height: 1.2;
        }
        .shop-info .desc {
            color: #7A5548; font-size: 13.5px; margin-top: 5px;
            display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;
        }
        .shop-meta-row {
            display: flex; flex-wrap: wrap; gap: 14px; margin-top: 10px;
        }
        .shop-meta-item {
            display: flex; align-items: center; gap: 5px;
            font-size: 12.5px; color: #8A6A5D;
        }
        .hero-stats {
            display: flex; gap: 12px; flex-shrink: 0;
        }
        .hero-stat-box {
            background: #FFFFFF;
            border: 1px solid var(--primary-light-border);
            border-radius: var(--radius-sm);
            padding: 10px 16px; text-align: center;
        }
        .hero-stat-box .val { font-size: 18px; font-weight: 700; color: var(--primary); }
        .hero-stat-box .lbl { font-size: 10px; color: var(--text-dim); margin-top: 1px; }

        /* ══════════ NOTIFICATION ══════════ */
        .notif-wrap { max-width: 1100px; margin: 0 auto; padding: 0 20px; }
        .notif-success {
            display: flex; align-items: center; justify-content: space-between; gap: 10px;
            background: #EAF8EF; border: 1px solid #BCE8CB; border-radius: var(--radius-md);
            padding: 12px 16px; margin-top: 16px;
            font-size: 13.5px; font-weight: 500; color: var(--success);
        }
        .notif-success a {
            background: var(--success); color: #ffffff;
            padding: 6px 14px; border-radius: var(--radius-sm);
            font-size: 12.5px; font-weight: 600;
            transition: opacity .15s;
        }
        .notif-success a:hover { opacity: .85; }

        /* ══════════ CATEGORY TABS ══════════ */
        .cat-section {
            background: #FFFFFF;
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
            padding: 7px 18px; border-radius: 20px;
            font-size: 13px; font-weight: 500;
            border: 1px solid var(--border-color);
            background: #FFFFFF; color: #444;
            cursor: pointer; white-space: nowrap; flex-shrink: 0;
            transition: all .15s;
        }
        .cat-pill:hover { border-color: var(--primary); color: var(--primary); }
        .cat-pill.active {
            background: var(--primary); color: var(--white);
            border-color: var(--primary);
        }

        /* ══════════ PRODUCTS SECTION ══════════ */
        .products-section { max-width: 1100px; margin: 0 auto; padding: 24px 20px; }
        .sec-head {
            display: flex; align-items: center; gap: 10px; margin-bottom: 18px;
        }
        .sec-title { font-size: 18px; font-weight: 500; color: var(--text-main); }
        .sec-count {
            background: var(--primary-light); color: var(--primary);
            font-size: 12px; font-weight: 600;
            padding: 2px 10px; border-radius: 50px;
        }

        /* ══════════ PRODUCT CARD ══════════ */
        .product-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(210px, 1fr));
            gap: 16px;
        }
        .product-card {
            background: #FFFFFF;
            border-radius: var(--radius-lg);
            border: 1px solid var(--border-color);
            box-shadow: var(--shadow-sm);
            overflow: hidden;
            display: flex; flex-direction: column;
            cursor: pointer;
            transition: transform .22s cubic-bezier(.34,1.56,.64,1), box-shadow .22s, border-color .22s;
        }
        .product-card:hover {
            transform: translateY(-4px);
            box-shadow: var(--shadow-md);
            border-color: var(--primary-light-border);
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
            background: linear-gradient(to bottom, transparent 60%, rgba(0,0,0,.25) 100%);
        }

        /* Status badges */
        .badge-new {
            position: absolute; top: 10px; left: 10px;
            background: #2E9E5B; color: #fff;
            font-size: 10px; font-weight: 600;
            padding: 3px 9px; border-radius: 50px;
            letter-spacing: .3px;
        }
        .badge-hot {
            position: absolute; top: 10px; left: 10px;
            background: var(--primary); color: #fff;
            font-size: 10px; font-weight: 600;
            padding: 3px 9px; border-radius: 50px;
        }
        .badge-oos {
            position: absolute; top: 10px; left: 10px;
            background: rgba(0,0,0,.55); color: #fff;
            font-size: 10px; font-weight: 600;
            padding: 3px 9px; border-radius: 50px;
        }

        /* Price on thumb */
        .p-price-thumb {
            position: absolute; bottom: 10px; left: 10px;
            background: rgba(255,255,255,.92);
            color: var(--primary); font-size: 12.5px; font-weight: 700;
            padding: 3px 10px; border-radius: 50px;
            box-shadow: 0 2px 6px rgba(0,0,0,.12);
        }

        /* Body */
        .p-body {
            padding: 13px 14px 6px; flex: 1; display: flex; flex-direction: column; gap: 4px;
        }
        .p-name {
            font-size: 14.5px; font-weight: 500; color: var(--text-main);
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
        .p-stars { color: #FFB100; letter-spacing: -1px; }

        /* Card footer */
        .p-footer {
            display: flex; align-items: center; justify-content: space-between;
            padding: 8px 14px 14px;
        }
        .p-price {
            font-size: 15px; font-weight: 500; color: var(--primary);
        }
        .p-price small { font-size: 11px; font-weight: 400; color: var(--text-dim); display: block; line-height: 1.2; }
        .btn-add {
            display: flex; align-items: center; justify-content: center;
            width: 36px; height: 36px; border-radius: 50%;
            background: var(--primary); color: var(--white);
            border: none; font-size: 22px; font-weight: 300;
            cursor: pointer; flex-shrink: 0;
            box-shadow: var(--glow-primary);
            transition: background .15s, transform .1s;
            line-height: 1;
        }
        .btn-add:hover { background: var(--primary-hover); transform: scale(1.1); }
        .btn-add:disabled {
            background: #EEEEEE; color: var(--text-dim);
            cursor: not-allowed; box-shadow: none; transform: none;
        }

        /* ══════════ EMPTY STATE ══════════ */
        .empty-state {
            text-align: center; padding: 80px 24px; color: var(--text-dim);
        }
        .empty-state .e-icon { font-size: 72px; margin-bottom: 16px; line-height: 1; opacity: .5; }
        .empty-state .e-title { font-size: 17px; font-weight: 500; color: var(--text-muted); }
        .empty-state .e-sub { font-size: 13px; margin-top: 6px; }

        /* ══════════ MODAL ══════════ */
        /* position: fixed !important vì rule "body > *:not(.starfield)" ở trên có độ đặc hiệu
           cao hơn .modal-overlay và từng ghi đè thành position:relative, khiến modal bị đẩy
           vào giữa trang thay vì phủ toàn màn hình. */
        .modal-overlay {
            position: fixed !important; inset: 0;
            background: rgba(26,26,26,.45);
            display: flex; align-items: flex-end; justify-content: center;
            z-index: 300; opacity: 0; pointer-events: none;
            transition: opacity .22s;
        }
        .modal-overlay.open { opacity: 1; pointer-events: all; }
        .modal-box {
            background: #FFFFFF;
            border: 1px solid var(--border-color); border-bottom: none;
            border-radius: 20px 20px 0 0;
            padding: 0;
            width: 100%; max-width: 520px;
            transform: translateY(50px);
            transition: transform .25s cubic-bezier(.4,0,.2,1);
            max-height: 92vh; overflow-y: auto;
            box-shadow: var(--shadow-lg);
        }
        .modal-overlay.open .modal-box { transform: translateY(0); }

        /* Modal header */
        .modal-header {
            position: sticky; top: 0; z-index: 10;
            background: #FFFFFF;
            padding: 20px 20px 16px;
            border-bottom: 1px solid var(--border-color);
            display: flex; align-items: flex-start; justify-content: space-between; gap: 12px;
        }
        .modal-title-wrap .m-name {
            font-size: 17px; font-weight: 500; color: var(--text-main); line-height: 1.3;
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
            font-size: 13px; font-weight: 600; color: var(--text-main);
            margin-bottom: 10px; display: flex; align-items: center; gap: 4px;
        }
        .m-required { color: var(--primary); }
        .size-radio { display: none; }
        .size-label {
            display: inline-flex; flex-direction: column; align-items: center;
            padding: 9px 16px; border-radius: var(--radius-sm);
            border: 2px solid var(--border-color); font-size: 13px; font-weight: 600;
            cursor: pointer; transition: all .12s; text-align: center;
            background: #FFFFFF;
        }
        .size-label .s-name { color: var(--text-main); }
        .size-label .s-price { font-size: 11.5px; color: var(--text-dim); font-weight: 500; margin-top: 1px; }
        .size-radio:checked + .size-label {
            background: var(--primary-light);
            border-color: var(--primary);
        }
        .size-radio:checked + .size-label .s-name { color: var(--primary); }
        .size-radio:checked + .size-label .s-price { color: var(--primary); }

        /* Topping */
        .topping-item {
            display: flex; align-items: center; gap: 10px;
            padding: 10px 12px; border-radius: var(--radius-sm);
            border: 1.5px solid var(--border-color); margin-bottom: 6px;
            font-size: 13px; color: var(--text-muted);
            background: #FAFAFA; cursor: pointer; transition: border-color .15s, background .15s;
        }
        .topping-item:has(.topping-check:checked),
        .topping-item.checked {
            border-color: var(--primary); background: var(--primary-light);
        }
        .topping-item .topping-check {
            width: 18px; height: 18px; flex-shrink: 0; accent-color: var(--primary); cursor: pointer;
        }
        .topping-item .t-name { flex: 1; color: var(--text-main); }
        .topping-item .t-price { font-weight: 600; color: var(--primary); flex-shrink: 0; }
        .t-qty-row { display: inline-flex; align-items: center; gap: 6px; margin-left: 4px; flex-shrink: 0; }
        .t-qty-btn {
            width: 22px; height: 22px; border-radius: 50%; border: 1.5px solid var(--border-color);
            background: #FFFFFF; font-size: 13px; font-weight: 600; cursor: pointer; line-height: 1;
            display: flex; align-items: center; justify-content: center; color: var(--text-main);
            transition: border-color .15s, background .15s;
        }
        .t-qty-btn:hover { border-color: var(--primary); background: var(--primary-light); }
        .t-qty-val { font-size: 12.5px; font-weight: 700; min-width: 14px; text-align: center; color: var(--text-main); }

        /* Quantity */
        .qty-row {
            display: flex; align-items: center; gap: 14px;
        }
        .qty-btn {
            width: 36px; height: 36px; border-radius: 50%;
            border: 2px solid var(--border-color); background: #FFFFFF;
            font-size: 20px; font-weight: 300; cursor: pointer;
            display: flex; align-items: center; justify-content: center;
            color: var(--text-main); transition: border-color .15s, background .15s;
            line-height: 1;
        }
        .qty-btn:hover { border-color: var(--primary); background: var(--primary-light); }
        .qty-val { font-size: 18px; font-weight: 700; min-width: 28px; text-align: center; color: var(--text-main); }

        /* Summary */
        .m-summary {
            background: var(--primary-light); border: 1px solid var(--primary-light-border);
            border-radius: var(--radius-md); padding: 14px 16px;
            display: flex; align-items: center; justify-content: space-between;
            margin-top: 18px;
        }
        .m-summary .s-label { font-size: 13px; color: var(--text-muted); font-weight: 600; }
        .m-summary .s-total { font-size: 18px; font-weight: 700; color: var(--primary); }

        .btn-submit {
            width: 100%; margin-top: 14px; padding: 14px;
            border-radius: var(--radius-md); border: none;
            background: var(--primary); color: var(--white);
            font-size: 15px; font-weight: 600; cursor: pointer;
            box-shadow: var(--glow-primary);
            transition: background .15s, transform .1s;
        }
        .btn-submit:hover { background: var(--primary-hover); transform: scale(.99); }

        /* ══════════ CART BAR ══════════ */
        .cart-bar {
            position: fixed !important; bottom: 0; left: 0; right: 0;
            background: var(--primary);
            padding: 14px 24px;
            display: flex; align-items: center; justify-content: space-between; gap: 16px;
            z-index: 200; transform: translateY(100%);
            transition: transform .28s cubic-bezier(.4,0,.2,1);
            box-shadow: 0 -4px 24px rgba(255,107,53,.3);
        }
        .cart-bar.visible { transform: translateY(0); }
        .cart-bar-label { font-size: 14px; font-weight: 600; color: #fff; }
        .cart-bar-label small { display: block; font-size: 11px; font-weight: 400; opacity: .9; }
        .cart-bar-btn {
            background: #fff; color: var(--primary);
            font-size: 13.5px; font-weight: 600;
            padding: 9px 20px; border-radius: 50px;
            white-space: nowrap;
            box-shadow: 0 2px 8px rgba(0,0,0,.15);
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

                <!-- Topping -->
                <c:if test="${not empty toppings}">
                    <div style="margin-top:18px;">
                        <div class="m-section-title">Topping (tuỳ chọn)</div>
                        <c:forEach var="t" items="${toppings}">
                            <label class="topping-item" for="topping_${t.id}">
                                <input type="checkbox" class="topping-check" id="topping_${t.id}"
                                       name="toppingId" value="${t.id}" data-price="${t.price}"
                                       onchange="toggleTopping(this, ${t.id})">
                                <span class="t-name">${t.toppingName}</span>
                                <span class="t-price">+<fmt:formatNumber value="${t.price}" type="number" groupingUsed="true"/>đ</span>
                                <span class="t-qty-row" id="toppingQtyRow_${t.id}" style="display:none;">
                                    <button type="button" class="t-qty-btn" onclick="event.preventDefault();event.stopPropagation();changeToppingQty(${t.id},-1)">−</button>
                                    <span class="t-qty-val" id="toppingQtyVal_${t.id}">1</span>
                                    <button type="button" class="t-qty-btn" onclick="event.preventDefault();event.stopPropagation();changeToppingQty(${t.id},1)">+</button>
                                </span>
                                <input type="hidden" name="toppingQty" id="toppingQtyInput_${t.id}" value="1" disabled>
                            </label>
                        </c:forEach>
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
    var selectedToppings = {}; // { toppingId: { price, qty } }

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

        /* Reset topping (checkbox dung chung giua cac san pham, phai reset moi lan mo modal) */
        selectedToppings = {};
        document.querySelectorAll('.topping-check').forEach(function(cb) {
            cb.checked = false;
            var tId = cb.value;
            var qtyRow = document.getElementById('toppingQtyRow_' + tId);
            var qtyVal = document.getElementById('toppingQtyVal_' + tId);
            var qtyInput = document.getElementById('toppingQtyInput_' + tId);
            var row = cb.closest('.topping-item');
            if (qtyRow) qtyRow.style.display = 'none';
            if (qtyVal) qtyVal.textContent = 1;
            if (qtyInput) { qtyInput.value = 1; qtyInput.disabled = true; }
            if (row) row.classList.remove('checked');
        });

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
        for (var tId in selectedToppings) {
            total += selectedToppings[tId].price * selectedToppings[tId].qty;
        }
        document.getElementById('totalPrice').textContent =
            total > 0 ? total.toLocaleString('vi-VN') + 'đ' : '—';
    }

    /* ── Topping ── */
    function toggleTopping(checkbox, toppingId) {
        var qtyRow = document.getElementById('toppingQtyRow_' + toppingId);
        var qtyInput = document.getElementById('toppingQtyInput_' + toppingId);
        var row = checkbox.closest('.topping-item');
        if (checkbox.checked) {
            var price = parseFloat(checkbox.dataset.price) || 0;
            selectedToppings[toppingId] = { price: price, qty: 1 };
            document.getElementById('toppingQtyVal_' + toppingId).textContent = 1;
            qtyInput.value = 1;
            qtyInput.disabled = false;
            qtyRow.style.display = 'inline-flex';
            if (row) row.classList.add('checked');
        } else {
            delete selectedToppings[toppingId];
            qtyInput.disabled = true;
            qtyRow.style.display = 'none';
            if (row) row.classList.remove('checked');
        }
        updateTotal();
    }

    function changeToppingQty(toppingId, delta) {
        var t = selectedToppings[toppingId];
        if (!t) return;
        t.qty = Math.max(1, Math.min(99, t.qty + delta));
        document.getElementById('toppingQtyVal_' + toppingId).textContent = t.qty;
        document.getElementById('toppingQtyInput_' + toppingId).value = t.qty;
        updateTotal();
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
