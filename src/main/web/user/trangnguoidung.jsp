<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>POBFood - Đói bụng? Có ngay!</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/user-theme.css">
<style>
:root {
    --bg:         #FFFBF8;
    --surface:    #FFFFFF;
    --surface-lt: #FFF4EC;
    --gold:       #FF5A1F;
    --gold-hover: #E14A0F;
    --text:       #241C15;
    --muted:      #8A7B6C;
    --border:     #F1E4D6;
    --font-h: 'Plus Jakarta Sans', sans-serif;
    --font-b: 'Plus Jakarta Sans', sans-serif;
    --tr: all 0.3s ease;
    --shadow: 0 14px 36px rgba(60,30,10,.14);
    --glow:   0 8px 22px rgba(255,90,31,.3);
}
*, *::before, *::after { margin: 0; padding: 0; box-sizing: border-box; }
html { scroll-behavior: smooth; }
body { font-family: var(--font-b); background: var(--bg); color: var(--text); line-height: 1.6; }
h1,h2,h3,h4,h5,h6 { font-family: var(--font-h); font-weight: 800; }
a { text-decoration: none; color: inherit; transition: var(--tr); }
ul { list-style: none; }
.container { max-width: 1180px; margin: 0 auto; padding: 0 20px; }
.section-padding { padding: 90px 0; }

/* ── SECTION HEADER ── */
.section-header { text-align: center; margin-bottom: 50px; }
.section-header .subtitle {
    font-size: .85rem; text-transform: uppercase; letter-spacing: 2px; font-weight: 700;
    color: var(--gold); display: block; margin-bottom: 10px;
}
.section-header .title { font-size: 2.4rem; color: var(--text); letter-spacing: -.5px; }

/* ── BUTTONS ── */
.btn-primary {
    display: inline-flex; align-items: center; gap: 8px;
    background: linear-gradient(135deg, var(--gold), var(--gold-hover)); color: #fff;
    border: none; border-radius: 50px;
    padding: 14px 32px; font-size: 1rem; font-weight: 700;
    cursor: pointer; transition: var(--tr); text-align: center;
    font-family: var(--font-b); box-shadow: var(--glow);
}
.btn-primary:hover { transform: translateY(-2px); box-shadow: 0 14px 30px rgba(255,90,31,.4); }
.btn-full { width: 100%; justify-content: center; }

/* ── NAVBAR ── */
.navbar {
    position: fixed; top: 0; left: 0; width: 100%;
    background: rgba(255,251,248,.92);
    backdrop-filter: blur(14px);
    z-index: 1000;
    border-bottom: 1px solid var(--border);
}
.nav-content {
    display: flex; justify-content: space-between; align-items: center; height: 76px;
}
.logo { display: flex; align-items: center; gap: 8px; }
.logo h1 { font-size: 1.7rem; letter-spacing: -.5px; }
.logo span { color: var(--gold); }
.logo-emoji { width: 32px; height: 32px; filter: drop-shadow(0 4px 8px rgba(255,90,31,.4)); }
.nav-links { display: flex; gap: 30px; }
.nav-links a { font-size: .92rem; font-weight: 600; color: var(--muted); }
.nav-links a:hover, .nav-links a.active { color: var(--gold); }

.nav-actions { display: flex; align-items: center; gap: 16px; }

/* Search in nav */
.nav-search { position: relative; }
.nav-search input {
    background: var(--surface-lt); border: 1.5px solid var(--border); border-radius: 50px;
    color: var(--text); font-family: var(--font-b); font-size: .85rem;
    padding: 9px 16px 9px 38px; width: 220px; transition: var(--tr);
}
.nav-search input:focus { outline: none; border-color: var(--gold); width: 280px; background: var(--surface); }
.nav-search input::placeholder { color: var(--muted); }
.nav-search i { position: absolute; left: 14px; top: 50%; transform: translateY(-50%); color: var(--muted); font-size: .85rem; pointer-events: none; }

/* Avatar dropdown */
.avatar-wrap { position: relative; }
.avatar-btn {
    width: 40px; height: 40px; border-radius: 50%;
    background: linear-gradient(135deg, var(--gold), var(--gold-hover));
    color: #FFF; font-size: 15px; font-weight: 800;
    border: none; cursor: pointer; font-family: var(--font-b);
    display: flex; align-items: center; justify-content: center;
    box-shadow: var(--glow);
}
.avatar-dropdown {
    position: absolute; top: calc(100% + 12px); right: 0;
    background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius-md, 16px);
    min-width: 220px; z-index: 200;
    display: none; box-shadow: var(--shadow);
    overflow: hidden;
}
.avatar-dropdown.open { display: block; }
.dd-head { padding: 16px 18px; border-bottom: 1px solid var(--border); background: var(--surface-lt); }
.dd-name { font-size: 14px; font-weight: 700; color: var(--text); }
.dd-email { font-size: 11.5px; color: var(--muted); margin-top: 3px; }
.dd-link, .dd-btn {
    display: flex; align-items: center; gap: 10px;
    width: 100%; padding: 12px 18px;
    font-size: 13px; font-weight: 600; color: var(--muted);
    background: none; border: none; cursor: pointer;
    font-family: var(--font-b); transition: var(--tr); text-align: left;
}
.dd-link i, .dd-btn i { color: var(--gold); width: 14px; }
.dd-link:hover, .dd-btn:hover { color: var(--gold); background: var(--primary-light, #FFF1E8); }
.dd-divider { height: 1px; background: var(--border); margin: 4px 0; }

.cart-btn {
    background: var(--surface-lt); border: 1.5px solid var(--border); border-radius: 50%;
    width: 42px; height: 42px; color: var(--text);
    font-size: 1.05rem; cursor: pointer; position: relative; transition: var(--tr);
    display: flex; align-items: center; justify-content: center;
}
.cart-btn:hover { color: var(--gold); border-color: var(--gold); }
.cart-count {
    position: absolute; top: -6px; right: -6px;
    background: var(--gold); color: #fff;
    font-size: .68rem; font-weight: 800;
    width: 19px; height: 19px; border-radius: 50%;
    display: flex; align-items: center; justify-content: center;
    border: 2px solid var(--bg);
}

/* ── HERO ── */
.hero {
    position: relative; min-height: 92vh; padding-top: 76px;
    background: radial-gradient(circle at 85% 15%, #FFE3D1 0%, transparent 45%),
                radial-gradient(circle at 10% 85%, #FFF3C4 0%, transparent 40%),
                var(--bg);
    display: flex; align-items: center; overflow: hidden;
}
.hero-grid { display: grid; grid-template-columns: 1.05fr .95fr; gap: 40px; align-items: center; }
.hero-content { max-width: 600px; position: relative; z-index: 2; }
.hero-badge {
    display: inline-flex; align-items: center; gap: 8px;
    padding: 8px 18px; background: var(--surface); border: 1px solid var(--primary-border, #FFD3B8);
    border-radius: 50px; font-weight: 700; font-size: .85rem; color: var(--gold);
    margin-bottom: 22px; box-shadow: var(--shadow-sm, 0 2px 10px rgba(0,0,0,.05));
}
.hero-title { font-size: 3.6rem; line-height: 1.08; margin-bottom: 20px; letter-spacing: -1.5px; color: var(--text); }
.hero-title .accent { color: var(--gold); }
.hero-subtitle { font-size: 1.1rem; color: var(--muted); margin-bottom: 32px; font-weight: 500; max-width: 480px; }

.hero-search-wrap { margin-bottom: 32px; }
.hero-search {
    display: flex; align-items: center; gap: 0;
    background: var(--surface); border: 1.5px solid var(--border); border-radius: 60px;
    max-width: 520px; width: 100%; padding: 6px; box-shadow: var(--shadow);
}
.hero-search i { padding: 0 16px; color: var(--muted); }
.hero-search input {
    flex: 1; background: transparent; border: none;
    padding: 12px 0; color: var(--text); font-family: var(--font-b); font-size: .95rem;
    outline: none;
}
.hero-search input::placeholder { color: var(--muted); }
.hero-search .btn-search {
    background: linear-gradient(135deg, var(--gold), var(--gold-hover)); color: #fff;
    border: none; padding: 13px 26px; border-radius: 50px;
    font-family: var(--font-b); font-size: .88rem;
    font-weight: 700; cursor: pointer; transition: var(--tr);
}
.hero-search .btn-search:hover { transform: translateY(-1px); }

.hero-stats { display: flex; gap: 30px; margin-bottom: 8px; }
.hero-stat h4 { font-size: 1.7rem; font-weight: 800; color: var(--text); }
.hero-stat p { font-size: .82rem; color: var(--muted); font-weight: 600; }

/* ── HERO 3D FOOD VISUAL ── */
.hero-visual { position: relative; height: 480px; z-index: 1; }
.hero-orb {
    position: absolute; border-radius: 50%;
    background: radial-gradient(circle, #FFDAB9 0%, transparent 70%);
    filter: blur(10px);
}
.hero-3d-item {
    position: absolute; filter: drop-shadow(0 20px 30px rgba(60,30,10,.28));
    animation: floaty 6s ease-in-out infinite;
}
.hero-3d-item img { width: 100%; height: 100%; display: block; }
.hero-3d-main { width: 260px; height: 260px; top: 42%; left: 50%; transform: translate(-50%,-50%); animation-delay: 0s; z-index: 3; }
.hero-3d-a { width: 120px; height: 120px; top: 6%; left: 8%; animation-delay: .6s; z-index: 2; }
.hero-3d-b { width: 110px; height: 110px; bottom: 10%; left: 4%; animation-delay: 1.2s; z-index: 2; }
.hero-3d-c { width: 130px; height: 130px; top: 4%; right: 4%; animation-delay: .3s; z-index: 2; }
.hero-3d-d { width: 105px; height: 105px; bottom: 6%; right: 6%; animation-delay: .9s; z-index: 2; }

@keyframes floaty {
    0%, 100% { transform: translateY(0) rotate(0deg); }
    50%      { transform: translateY(-18px) rotate(4deg); }
}
.hero-3d-main.floaty-center { animation-name: floaty-center; }
@keyframes floaty-center {
    0%, 100% { transform: translate(-50%,-50%) translateY(0) rotate(0deg); }
    50%      { transform: translate(-50%,-50%) translateY(-16px) rotate(-3deg); }
}

/* ── CATEGORIES ── */
.categories { background: var(--surface-lt); }
.category-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
    gap: 22px;
}
.category-card {
    background: var(--surface); border: 1.5px solid var(--border); border-radius: var(--radius-lg, 22px);
    padding: 30px 16px; text-align: center; cursor: pointer; transition: var(--tr);
    box-shadow: var(--shadow-sm, 0 2px 10px rgba(0,0,0,.05));
}
.category-card .cat-icon { width: 58px; height: 58px; margin: 0 auto 14px; filter: drop-shadow(0 8px 14px rgba(60,30,10,.22)); transition: var(--tr); }
.category-card:hover .cat-icon { transform: scale(1.12) rotate(-6deg); }
.category-card h3 { font-size: .98rem; font-family: var(--font-b); font-weight: 700; }
.category-card:hover { transform: translateY(-8px); border-color: var(--gold); box-shadow: var(--shadow); }
.category-card.active { border-color: var(--gold); background: var(--primary-light, #FFF1E8); }

/* ── RESTAURANTS ── */
.restaurant-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
    gap: 32px;
}
.shop-card {
    background: var(--surface); border: 1.5px solid var(--border); border-radius: var(--radius-lg, 22px);
    overflow: hidden; transition: var(--tr); cursor: pointer;
    box-shadow: var(--shadow-sm, 0 2px 10px rgba(0,0,0,.05));
}
.shop-card:hover { transform: translateY(-6px); box-shadow: var(--shadow); border-color: var(--primary-border, #FFD3B8); }
.shop-img {
    width: 100%; height: 210px; object-fit: cover;
    background: var(--surface-lt); display: flex; align-items: center; justify-content: center;
    position: relative;
}
.shop-img img { width: 100%; height: 100%; object-fit: cover; }
.shop-img .fallback-icon { width: 70px; height: 70px; filter: drop-shadow(0 10px 16px rgba(60,30,10,.2)); }
.shop-info { padding: 22px; }
.shop-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px; gap: 10px; }
.shop-title { font-size: 1.25rem; color: var(--text); }
.shop-badge-open {
    font-size: .72rem; font-weight: 700; letter-spacing: .3px; flex-shrink: 0;
    color: #15803D; text-transform: uppercase; background: var(--accent-green-lt, #EAFBF1);
    border: 1px solid #BBF0CF; border-radius: 50px;
    padding: 4px 12px; display: inline-flex; align-items: center; gap: 5px;
}
.shop-badge-open i { font-size: 6px; }
.shop-desc { color: var(--muted); font-size: .88rem; margin-bottom: 14px; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; }
.shop-meta { display: flex; flex-direction: column; gap: 6px; margin-bottom: 18px; }
.shop-meta-row { display: flex; align-items: center; gap: 8px; font-size: .83rem; color: var(--muted); }
.shop-meta-row i { color: var(--gold); width: 14px; }
.btn-menu {
    width: 100%; background: var(--primary-light, #FFF1E8); color: var(--gold);
    border: 1.5px solid var(--primary-border, #FFD3B8); padding: 12px; border-radius: 50px;
    font-family: var(--font-b); font-size: .85rem; font-weight: 700;
    cursor: pointer; transition: var(--tr);
}
.btn-menu:hover { background: var(--gold); color: #fff; box-shadow: var(--glow); border-color: var(--gold); }

/* EMPTY */
.empty-state {
    text-align: center; padding: 70px 24px; color: var(--muted);
    grid-column: 1 / -1;
}
.empty-state img { width: 84px; height: 84px; margin: 0 auto 16px; filter: drop-shadow(0 10px 16px rgba(60,30,10,.2)); }
.empty-state h3 { font-family: var(--font-h); font-size: 1.3rem; margin-bottom: 8px; color: var(--text); }
.empty-state p { font-size: .9rem; }

/* ── CART MODAL ── */
.cart-modal {
    position: fixed; inset: 0; z-index: 2000;
    display: flex; justify-content: flex-end;
    visibility: hidden; opacity: 0; transition: var(--tr);
}
.cart-modal.active { visibility: visible; opacity: 1; }
.cart-overlay {
    position: absolute; inset: 0;
    background: rgba(36,20,10,.55); backdrop-filter: blur(5px);
}
.cart-content {
    position: relative; width: 100%; max-width: 400px; height: 100%;
    background: var(--surface); display: flex; flex-direction: column;
    transform: translateX(100%); transition: transform .4s ease;
    box-shadow: -12px 0 40px rgba(60,30,10,.18);
}
.cart-modal.active .cart-content { transform: translateX(0); }
.cart-header {
    padding: 28px 26px; border-bottom: 1px solid var(--border);
    display: flex; justify-content: space-between; align-items: center;
}
.cart-header h2 { font-size: 1.4rem; }
.close-btn { background: var(--surface-lt); border: none; width: 34px; height: 34px; border-radius: 50%; color: var(--muted); font-size: 1.1rem; cursor: pointer; transition: var(--tr); }
.close-btn:hover { color: var(--gold); background: var(--primary-light, #FFF1E8); }
.cart-body { flex: 1; overflow-y: auto; padding: 26px; }
.cart-items { display: flex; flex-direction: column; gap: 18px; }
.empty-cart { text-align: center; color: var(--muted); padding: 50px 0; }
.empty-cart img { width: 78px; height: 78px; margin-bottom: 14px; }
.cart-item {
    display: flex; justify-content: space-between; align-items: center;
    padding-bottom: 18px; border-bottom: 1px solid var(--border);
}
.cart-item-info h4 { font-family: var(--font-b); font-weight: 700; margin-bottom: 5px; font-size: .95rem; }
.cart-item-info p { color: var(--gold); font-size: .9rem; font-weight: 700; }
.cart-item-actions { display: flex; align-items: center; gap: 10px; }
.qty-btn {
    background: var(--surface-lt); border: 1.5px solid var(--border); color: var(--text);
    width: 28px; height: 28px; border-radius: 50%; cursor: pointer; transition: var(--tr);
    display: flex; align-items: center; justify-content: center; font-size: .85rem;
}
.qty-btn:hover { border-color: var(--gold); color: var(--gold); }
.cart-footer {
    padding: 26px; border-top: 1px solid var(--border);
    background: var(--surface-lt);
}
.cart-total {
    display: flex; justify-content: space-between; align-items: center;
    margin-bottom: 18px; font-size: 1.05rem; font-weight: 700;
}
.total-price { color: var(--gold); font-size: 1.35rem; font-family: var(--font-h); }

/* ── FOOTER ── */
.footer { border-top: 1px solid var(--border); padding: 70px 0 20px; background: var(--surface-lt); }
.footer-content {
    display: flex; justify-content: space-between; align-items: center;
    margin-bottom: 50px; flex-wrap: wrap; gap: 40px;
}
.footer-brand h2 { font-size: 1.8rem; margin-bottom: 10px; display: flex; align-items: center; gap: 8px; }
.footer-brand span { color: var(--gold); }
.footer-brand p { color: var(--muted); max-width: 320px; }
.footer-links { display: flex; gap: 28px; flex-wrap: wrap; }
.footer-links a { color: var(--muted); font-size: .9rem; font-weight: 600; }
.footer-links a:hover { color: var(--gold); }
.footer-bottom {
    text-align: center; color: var(--muted); font-size: .85rem;
    padding-top: 20px; border-top: 1px solid var(--border);
}

/* ── RESPONSIVE ── */
@media (max-width: 992px) {
    .hero-grid { grid-template-columns: 1fr; text-align: center; }
    .hero-content { margin: 0 auto; }
    .hero-search { margin: 0 auto; }
    .hero-stats { justify-content: center; }
    .hero-visual { height: 340px; margin-top: 20px; }
    .hero-3d-main { width: 190px; height: 190px; }
}
@media (max-width: 768px) {
    .hero-title { font-size: 2.6rem; }
    .nav-links, .nav-search { display: none; }
    .footer-content { flex-direction: column; text-align: center; }
    .footer-links { justify-content: center; }
    .restaurant-grid { grid-template-columns: 1fr; }
}
</style>
</head>
<body>

<!-- ── NAVBAR ── -->
<header class="navbar">
    <div class="container nav-content">
        <div class="logo">
            <img class="logo-emoji" src="https://cdn.jsdelivr.net/gh/microsoft/fluentui-emoji@main/assets/Steaming%20bowl/3D/steaming_bowl_3d.png" alt="">
            <h1>POBFood<span>.</span></h1>
        </div>

        <nav class="nav-links">
            <a href="#home" class="active">Trang chủ</a>
            <a href="#categories">Danh mục</a>
            <a href="#restaurants">Nhà hàng</a>
        </nav>

        <div class="nav-actions">
            <div class="nav-search">
                <i class="fa-solid fa-magnifying-glass"></i>
                <input id="navSearch" type="text" placeholder="Tìm quán, món ăn..." oninput="filterShops(this.value)">
            </div>

            <div class="avatar-wrap" id="avatarWrap">
                <button class="avatar-btn" onclick="toggleDropdown()" aria-label="Tài khoản">
                    ${fn:substring(not empty account.fullName ? account.fullName : account.userName, 0, 1)}
                </button>
                <div class="avatar-dropdown" id="accountDropdown">
                    <div class="dd-head">
                        <div class="dd-name">${not empty account.fullName ? account.fullName : account.userName}</div>
                        <c:if test="${not empty account.email}"><div class="dd-email">${account.email}</div></c:if>
                    </div>
                    <a href="${pageContext.request.contextPath}/user/donhang" class="dd-link">
                        <i class="fa-solid fa-box"></i> Đơn hàng của tôi
                    </a>
                    <a href="${pageContext.request.contextPath}/user/dia-chi" class="dd-link">
                        <i class="fa-solid fa-location-dot"></i> Địa chỉ giao hàng
                    </a>
                    <a href="${pageContext.request.contextPath}/user/doi-mat-khau" class="dd-link">
                        <i class="fa-solid fa-lock"></i> Đổi mật khẩu
                    </a>
                    <div class="dd-divider"></div>
                    <form action="${pageContext.request.contextPath}/logout" method="post">
                        <button type="submit" class="dd-btn">
                            <i class="fa-solid fa-right-from-bracket"></i> Đăng xuất
                        </button>
                    </form>
                </div>
            </div>

            <a href="${pageContext.request.contextPath}/user/cart" class="cart-btn" aria-label="Giỏ hàng">
                <i class="fa-solid fa-bag-shopping"></i>
            </a>
        </div>
    </div>
</header>

<!-- ── HERO ── -->
<section id="home" class="hero">
    <div class="container hero-grid">
        <div class="hero-content">
            <div class="hero-badge"><i class="fa-solid fa-bolt"></i> Giao hàng hỏa tốc trong 20 phút</div>
            <h2 class="hero-title">Đói bụng?<br>Đã có <span class="accent">POBFood!</span></h2>
            <p class="hero-subtitle">Khám phá hàng ngàn món ăn ngon từ các nhà hàng hàng đầu, giao tận nơi nóng hổi chỉ trong vài bước.</p>
            <div class="hero-search-wrap">
                <div class="hero-search">
                    <i class="fa-solid fa-magnifying-glass"></i>
                    <input id="heroSearch" type="text" placeholder="Bạn muốn ăn gì hôm nay?" oninput="filterShops(this.value)">
                    <button class="btn-search" onclick="filterShops(document.getElementById('heroSearch').value)">Tìm kiếm</button>
                </div>
            </div>
            <div class="hero-stats">
                <div class="hero-stat"><h4>10k+</h4><p>Nhà hàng</p></div>
                <div class="hero-stat"><h4>30k+</h4><p>Món ăn</p></div>
                <div class="hero-stat"><h4>4.9 ★</h4><p>Đánh giá</p></div>
            </div>
        </div>

        <div class="hero-visual">
            <div class="hero-3d-item hero-3d-main floaty-center">
                <img src="https://cdn.jsdelivr.net/gh/microsoft/fluentui-emoji@main/assets/Hamburger/3D/hamburger_3d.png" alt="Burger">
            </div>
            <div class="hero-3d-item hero-3d-a">
                <img src="https://cdn.jsdelivr.net/gh/microsoft/fluentui-emoji@main/assets/Pizza/3D/pizza_3d.png" alt="Pizza">
            </div>
            <div class="hero-3d-item hero-3d-b">
                <img src="https://cdn.jsdelivr.net/gh/microsoft/fluentui-emoji@main/assets/Bubble%20tea/3D/bubble_tea_3d.png" alt="Trà sữa">
            </div>
            <div class="hero-3d-item hero-3d-c">
                <img src="https://cdn.jsdelivr.net/gh/microsoft/fluentui-emoji@main/assets/Sushi/3D/sushi_3d.png" alt="Sushi">
            </div>
            <div class="hero-3d-item hero-3d-d">
                <img src="https://cdn.jsdelivr.net/gh/microsoft/fluentui-emoji@main/assets/French%20fries/3D/french_fries_3d.png" alt="Khoai tây chiên">
            </div>
        </div>
    </div>
</section>

<!-- ── CATEGORIES ── -->
<section id="categories" class="categories section-padding">
    <div class="container">
        <div class="section-header">
            <span class="subtitle">Lựa chọn của bạn</span>
            <h2 class="title">Danh Mục Ẩm Thực</h2>
        </div>
        <div class="category-grid">
            <c:choose>
                <c:when test="${not empty categories}">
                    <div class="category-card active" onclick="filterCategory('all', this)">
                        <img class="cat-icon" src="https://cdn.jsdelivr.net/gh/microsoft/fluentui-emoji@main/assets/Fork%20and%20knife%20with%20plate/3D/fork_and_knife_with_plate_3d.png" alt="">
                        <h3>Tất Cả</h3>
                    </div>
                    <c:set var="catIconsArr" value="${fn:split('Pizza|Sushi|Green salad|Cupcake|Taco|Spaghetti|Bento box|Hot beverage', '|')}" />
                    <c:set var="catIconFilesArr" value="${fn:split('pizza_3d.png|sushi_3d.png|green_salad_3d.png|cupcake_3d.png|taco_3d.png|spaghetti_3d.png|bento_box_3d.png|hot_beverage_3d.png', '|')}" />
                    <c:forEach var="cat" items="${categories}" varStatus="cs">
                        <c:set var="idx" value="${cs.index mod 8}" />
                        <div class="category-card"
                             data-cat="${fn:escapeXml(cat.categoryName)}"
                             onclick="filterCategory('${fn:escapeXml(cat.categoryName)}', this)">
                            <img class="cat-icon" src="https://cdn.jsdelivr.net/gh/microsoft/fluentui-emoji@main/assets/${catIconsArr[idx]}/3D/${catIconFilesArr[idx]}" alt="">
                            <h3>${fn:escapeXml(cat.categoryName)}</h3>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="category-card active" onclick="filterCategory('all', this)">
                        <img class="cat-icon" src="https://cdn.jsdelivr.net/gh/microsoft/fluentui-emoji@main/assets/Fork%20and%20knife%20with%20plate/3D/fork_and_knife_with_plate_3d.png" alt="">
                        <h3>Tất Cả</h3>
                    </div>
                    <div class="category-card" onclick="filterCategory('all', this)">
                        <img class="cat-icon" src="https://cdn.jsdelivr.net/gh/microsoft/fluentui-emoji@main/assets/Sushi/3D/sushi_3d.png" alt="">
                        <h3>Hải Sản &amp; Sushi</h3>
                    </div>
                    <div class="category-card" onclick="filterCategory('all', this)">
                        <img class="cat-icon" src="https://cdn.jsdelivr.net/gh/microsoft/fluentui-emoji@main/assets/Green%20salad/3D/green_salad_3d.png" alt="">
                        <h3>Healthy &amp; Vegan</h3>
                    </div>
                    <div class="category-card" onclick="filterCategory('all', this)">
                        <img class="cat-icon" src="https://cdn.jsdelivr.net/gh/microsoft/fluentui-emoji@main/assets/Cupcake/3D/cupcake_3d.png" alt="">
                        <h3>Tráng Miệng</h3>
                    </div>
                    <div class="category-card" onclick="filterCategory('all', this)">
                        <img class="cat-icon" src="https://cdn.jsdelivr.net/gh/microsoft/fluentui-emoji@main/assets/Hamburger/3D/hamburger_3d.png" alt="">
                        <h3>Đồ Nướng</h3>
                    </div>
                    <div class="category-card" onclick="filterCategory('all', this)">
                        <img class="cat-icon" src="https://cdn.jsdelivr.net/gh/microsoft/fluentui-emoji@main/assets/Bubble%20tea/3D/bubble_tea_3d.png" alt="">
                        <h3>Đồ Uống</h3>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</section>

<!-- ── RESTAURANTS ── -->
<section id="restaurants" class="restaurants section-padding">
    <div class="container">
        <div class="section-header">
            <span class="subtitle">Đối tác độc quyền</span>
            <h2 class="title">Nhà Hàng Tuyển Chọn</h2>
        </div>

        <c:choose>
            <c:when test="${empty shops}">
                <div class="restaurant-grid">
                    <div class="empty-state">
                        <img src="https://cdn.jsdelivr.net/gh/microsoft/fluentui-emoji@main/assets/Steaming%20bowl/3D/steaming_bowl_3d.png" alt="">
                        <h3>Chưa có nhà hàng nào</h3>
                        <p>Vui lòng quay lại sau nhé!</p>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="restaurant-grid" id="shopGrid">
                    <c:forEach var="shop" items="${shops}">
                        <div class="shop-card"
                             data-name="${fn:escapeXml(fn:toLowerCase(shop.shopName))}"
                             data-desc="${fn:escapeXml(fn:toLowerCase(shop.shopDescription))}"
                             data-addr="${fn:escapeXml(fn:toLowerCase(shop.shopAddress))}"
                             onclick="goToShop(${shop.id})">

                            <div class="shop-img">
                                <c:choose>
                                    <c:when test="${not empty shop.shopLogo}">
                                        <img src="${shop.shopLogo}" alt="${fn:escapeXml(shop.shopName)}"
                                             onerror="this.style.display='none';this.nextElementSibling.style.display='block';">
                                        <img class="fallback-icon" style="display:none;" src="https://cdn.jsdelivr.net/gh/microsoft/fluentui-emoji@main/assets/Fork%20and%20knife%20with%20plate/3D/fork_and_knife_with_plate_3d.png" alt="">
                                    </c:when>
                                    <c:otherwise>
                                        <img class="fallback-icon" src="https://cdn.jsdelivr.net/gh/microsoft/fluentui-emoji@main/assets/Fork%20and%20knife%20with%20plate/3D/fork_and_knife_with_plate_3d.png" alt="">
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <div class="shop-info">
                                <div class="shop-header">
                                    <h3 class="shop-title">${fn:escapeXml(shop.shopName)}</h3>
                                    <span class="shop-badge-open"><i class="fa-solid fa-circle"></i> Đang mở</span>
                                </div>
                                <c:if test="${not empty shop.shopDescription}">
                                    <p class="shop-desc">${fn:escapeXml(shop.shopDescription)}</p>
                                </c:if>
                                <div class="shop-meta">
                                    <c:if test="${not empty shop.shopAddress}">
                                        <div class="shop-meta-row">
                                            <i class="fa-solid fa-location-dot"></i>
                                            <span>${fn:escapeXml(shop.shopAddress)}</span>
                                        </div>
                                    </c:if>
                                    <c:if test="${not empty shop.shopPhone}">
                                        <div class="shop-meta-row">
                                            <i class="fa-solid fa-phone"></i>
                                            <span>${fn:escapeXml(shop.shopPhone)}</span>
                                        </div>
                                    </c:if>
                                </div>
                                <button class="btn-menu" onclick="event.stopPropagation(); goToShop(${shop.id})">
                                    Xem Thực Đơn &nbsp;<i class="fa-solid fa-arrow-right"></i>
                                </button>
                            </div>
                        </div>
                    </c:forEach>
                </div>
                <div id="noResults" class="restaurant-grid" style="display:none;">
                    <div class="empty-state">
                        <img src="https://cdn.jsdelivr.net/gh/microsoft/fluentui-emoji@main/assets/Steaming%20bowl/3D/steaming_bowl_3d.png" alt="">
                        <h3>Không tìm thấy kết quả</h3>
                        <p>Hãy thử từ khoá khác nhé.</p>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</section>

<!-- ── FOOTER ── -->
<footer class="footer">
    <div class="container footer-content">
        <div class="footer-brand">
            <h2>POBFood<span>.</span></h2>
            <p>Nền tảng giao đồ ăn nhanh chóng, tiện lợi và thơm ngon nhất dành cho bạn.</p>
        </div>
        <div class="footer-links">
            <a href="#">Về chúng tôi</a>
            <a href="#">Chính sách bảo mật</a>
            <a href="#">Điều khoản sử dụng</a>
            <a href="${pageContext.request.contextPath}/user/donhang">Đơn hàng</a>
            <a href="${pageContext.request.contextPath}/user/dia-chi">Địa chỉ</a>
        </div>
    </div>
    <div class="footer-bottom container">
        <p>&copy; 2026 POBFood. Đã đăng ký bản quyền.</p>
    </div>
</footer>

<script>
/* ── NAVIGATION ── */
function goToShop(id) {
    window.location.href = '${pageContext.request.contextPath}/user/shop?id=' + id;
}

function filterShops(query) {
    ['navSearch','heroSearch'].forEach(function(id) {
        var el = document.getElementById(id); if (el) el.value = query;
    });
    var q = query.toLowerCase().trim();
    var cards = document.querySelectorAll('#shopGrid .shop-card');
    if (!cards.length) return;
    var visible = 0;
    cards.forEach(function(c) {
        var match = !q || (c.dataset.name||'').includes(q) || (c.dataset.desc||'').includes(q) || (c.dataset.addr||'').includes(q);
        c.style.display = match ? '' : 'none';
        if (match) visible++;
    });
    document.getElementById('noResults').style.display = visible === 0 ? 'grid' : 'none';
    if (q) document.querySelectorAll('.category-card').forEach(function(p) { p.classList.remove('active'); });
}

function filterCategory(cat, btn) {
    document.querySelectorAll('.category-card').forEach(function(p) { p.classList.remove('active'); });
    btn.classList.add('active');
    ['navSearch','heroSearch'].forEach(function(id) { var el = document.getElementById(id); if (el) el.value = ''; });
    document.querySelectorAll('#shopGrid .shop-card').forEach(function(c) { c.style.display = ''; });
    var noRes = document.getElementById('noResults');
    if (noRes) noRes.style.display = 'none';
}

function toggleDropdown() {
    document.getElementById('accountDropdown').classList.toggle('open');
}
document.addEventListener('click', function(e) {
    var w = document.getElementById('avatarWrap');
    if (w && !w.contains(e.target)) document.getElementById('accountDropdown').classList.remove('open');
});

/* ── CART ── */
var cart = [];

document.getElementById('cartBtn').addEventListener('click', function() {
    document.getElementById('cartModal').classList.add('active');
});
document.getElementById('closeCart').addEventListener('click', closeCartModal);
document.getElementById('cartOverlay').addEventListener('click', closeCartModal);

function closeCartModal() {
    document.getElementById('cartModal').classList.remove('active');
}

function updateCartUI() {
    var total = cart.reduce(function(s, i) { return s + i.price * i.qty; }, 0);
    var count = cart.reduce(function(s, i) { return s + i.qty; }, 0);
    document.getElementById('cartCount').textContent = count;
    document.getElementById('cartTotalPrice').textContent = total.toLocaleString('vi-VN') + ' ₫';

    var container = document.getElementById('cartItems');
    if (cart.length === 0) {
        container.innerHTML = '<div class="empty-cart"><img src="https://cdn.jsdelivr.net/gh/microsoft/fluentui-emoji@main/assets/Shopping%20cart/3D/shopping_cart_3d.png" alt=""><p>Giỏ hàng đang trống.</p></div>';
        return;
    }
    container.innerHTML = cart.map(function(item, idx) {
        return '<div class="cart-item">' +
            '<div class="cart-item-info"><h4>' + item.name + '</h4><p>' + (item.price * item.qty).toLocaleString('vi-VN') + ' ₫</p></div>' +
            '<div class="cart-item-actions">' +
                '<button class="qty-btn" onclick="changeQty(' + idx + ',-1)"><i class="fa-solid fa-minus"></i></button>' +
                '<span style="min-width:20px;text-align:center;">' + item.qty + '</span>' +
                '<button class="qty-btn" onclick="changeQty(' + idx + ',1)"><i class="fa-solid fa-plus"></i></button>' +
            '</div>' +
        '</div>';
    }).join('');
}

function changeQty(idx, delta) {
    cart[idx].qty = Math.max(0, cart[idx].qty + delta);
    if (cart[idx].qty === 0) cart.splice(idx, 1);
    updateCartUI();
}

document.getElementById('checkoutBtn').addEventListener('click', function() {
    if (cart.length === 0) { alert('Giỏ hàng đang trống!'); return; }
    window.location.href = '${pageContext.request.contextPath}/user/home';
});

updateCartUI();
</script>
</body>
</html>
