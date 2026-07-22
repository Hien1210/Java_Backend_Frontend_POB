<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Tìm quán ăn - POB Food</title>
<script src="https://cdn.tailwindcss.com"></script>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<style>
:root {
  --primary: #FF7A30;
  --primary-dark: #D95A1A;
  --primary-light: rgba(255,122,48,.12);
  --bg-base: #FFF8F1;
  --bg-card: #FFFFFF;
  --text-main: #1C1E32;
  --text-muted: #6B7280;
  --hero-from: #1C1E32;
  --hero-to: #0f1624;
  --border: #E5E7EB;
  --shadow-sm: 0 1px 3px rgba(0,0,0,.06);
  --shadow-md: 0 4px 16px rgba(0,0,0,.08);
  --shadow-lg: 0 8px 28px rgba(0,0,0,.12);
}
* { font-family: 'Inter', system-ui, -apple-system, sans-serif; box-sizing: border-box; }
body { margin: 0; background: var(--bg-base); color: var(--text-main); }

/* NAVBAR */
.navbar {
  position: sticky; top: 0; z-index: 50;
  background: var(--bg-card);
  border-bottom: 1px solid var(--border);
  box-shadow: var(--shadow-sm);
  padding: 0 20px; height: 58px;
  display: flex; align-items: center; gap: 14px;
}
.nav-logo {
  width: 36px; height: 36px; border-radius: 10px;
  background: linear-gradient(135deg, var(--primary), #FF9A5C);
  display: flex; align-items: center; justify-content: center;
  color: #fff; font-weight: 800; font-size: 14px; flex-shrink: 0;
}
.nav-brand { font-size: 16px; font-weight: 700; color: var(--text-main); white-space: nowrap; }
.nav-search {
  flex: 1; max-width: 420px; position: relative;
}
.nav-search input {
  width: 100%; padding: 9px 14px 9px 38px;
  border-radius: 10px; border: 1.5px solid var(--border);
  font-size: 13.5px; background: #F9FAFB;
  transition: border-color .15s, box-shadow .15s;
}
.nav-search input:focus {
  outline: none; border-color: var(--primary);
  box-shadow: 0 0 0 3px var(--primary-light);
}
.nav-search .s-icon {
  position: absolute; left: 12px; top: 50%; transform: translateY(-50%);
  color: #9CA3AF; pointer-events: none;
}
.nav-links { display: flex; align-items: center; gap: 6px; margin-left: auto; }
.nav-link {
  display: inline-flex; align-items: center; gap: 5px;
  padding: 8px 12px; border-radius: 8px;
  font-size: 13px; font-weight: 500; color: var(--text-muted);
  text-decoration: none; transition: all .15s; white-space: nowrap;
}
.nav-link:hover { background: var(--primary-light); color: var(--primary); }
.nav-link svg { flex-shrink: 0; }

/* AVATAR */
.avatar-btn {
  width: 34px; height: 34px; border-radius: 50%;
  background: linear-gradient(135deg, var(--primary), #FF9A5C);
  color: #fff; font-size: 13px; font-weight: 700;
  display: flex; align-items: center; justify-content: center;
  cursor: pointer; border: none; position: relative;
}
.dropdown {
  position: absolute; top: calc(100% + 8px); right: 0;
  background: #fff; border: 1px solid var(--border);
  border-radius: 12px; box-shadow: var(--shadow-lg);
  min-width: 200px; overflow: hidden;
  display: none; z-index: 100;
}
.dropdown.open { display: block; }
.dropdown-header { padding: 14px 16px; border-bottom: 1px solid #F3F4F6; }
.dropdown-header .name { font-size: 13.5px; font-weight: 700; color: var(--text-main); }
.dropdown-header .email { font-size: 11.5px; color: #9CA3AF; margin-top: 2px; }
.dropdown a, .dropdown button {
  display: flex; align-items: center; gap: 8px;
  width: 100%; padding: 10px 16px;
  font-size: 13px; font-weight: 500; color: #4B5563;
  text-align: left; background: none; border: none;
  cursor: pointer; text-decoration: none; transition: background .1s;
}
.dropdown a:hover, .dropdown button:hover { background: #F9FAFB; color: var(--primary); }
.dropdown .divider { height: 1px; background: #F3F4F6; margin: 4px 0; }

/* HERO */
.hero {
  background: linear-gradient(135deg, var(--hero-from) 0%, #1a1f3a 50%, var(--hero-to) 100%);
  padding: 36px 24px 40px; text-align: center;
  position: relative; overflow: hidden;
}
.hero::before {
  content: ''; position: absolute; top: -80px; right: -80px;
  width: 280px; height: 280px; border-radius: 50%;
  background: radial-gradient(circle, rgba(255,122,48,.15) 0%, transparent 70%);
}
.hero::after {
  content: ''; position: absolute; bottom: -60px; left: -60px;
  width: 200px; height: 200px; border-radius: 50%;
  background: radial-gradient(circle, rgba(99,102,241,.12) 0%, transparent 70%);
}
.hero-inner { position: relative; z-index: 1; max-width: 600px; margin: 0 auto; }
.hero-title { font-size: 26px; font-weight: 800; color: #fff; margin-bottom: 6px; line-height: 1.25; }
.hero-sub { font-size: 14px; color: rgba(255,255,255,.5); margin-bottom: 20px; }
.hero-search {
  position: relative; max-width: 480px; margin: 0 auto;
}
.hero-search input {
  width: 100%; padding: 13px 20px 13px 44px;
  border-radius: 14px; border: none;
  font-size: 14px; color: var(--text-main);
  box-shadow: 0 4px 24px rgba(0,0,0,.2);
}
.hero-search .s-icon {
  position: absolute; left: 16px; top: 50%; transform: translateY(-50%);
  color: #9CA3AF; pointer-events: none;
}

/* CATEGORY CAROUSEL */
.cat-section {
  max-width: 1200px; margin: -22px auto 0; padding: 0 20px;
  position: relative; z-index: 10;
}
.cat-scroll {
  display: flex; gap: 10px; overflow-x: auto;
  padding: 14px 4px; scroll-behavior: smooth;
  -webkit-overflow-scrolling: touch;
}
.cat-scroll::-webkit-scrollbar { display: none; }
.cat-pill {
  flex-shrink: 0; padding: 8px 20px;
  border-radius: 99px; font-size: 13.5px; font-weight: 600;
  border: 1.5px solid var(--border); background: #fff;
  color: var(--text-muted); cursor: pointer;
  white-space: nowrap; transition: all .15s;
  user-select: none;
}
.cat-pill:hover { border-color: var(--primary); color: var(--primary); }
.cat-pill.active {
  background: linear-gradient(135deg, var(--primary), #FF9A5C);
  color: #fff; border-color: transparent;
  box-shadow: 0 2px 10px rgba(255,122,48,.3);
}

/* SHOP GRID */
.shop-section { max-width: 1200px; margin: 0 auto; padding: 24px 20px 60px; }
.section-head {
  display: flex; align-items: baseline; justify-content: space-between;
  margin-bottom: 20px;
}
.section-head .left {}
.section-title { font-size: 20px; font-weight: 800; color: var(--text-main); }
.section-sub { font-size: 13px; color: var(--text-muted); margin-top: 2px; }
.section-action {
  font-size: 13px; font-weight: 600; color: var(--primary);
  cursor: pointer; transition: opacity .15s;
}
.section-action:hover { opacity: .75; }

.shop-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
  gap: 18px;
}
.shop-card {
  background: var(--bg-card); border-radius: 16px;
  border: 1px solid #f0f0f0;
  box-shadow: var(--shadow-sm);
  overflow: hidden; cursor: pointer;
  transition: transform .2s, box-shadow .2s;
}
.shop-card:hover {
  transform: translateY(-4px);
  box-shadow: var(--shadow-lg);
}
.shop-img {
  height: 140px; position: relative;
  background: linear-gradient(135deg, #f3f4f6, #e5e7eb);
  display: flex; align-items: center; justify-content: center;
  overflow: hidden;
}
.shop-img img { width: 100%; height: 100%; object-fit: cover; }
.shop-img .fallback-icon { color: #9CA3AF; }
.shop-badge {
  position: absolute; top: 10px; right: 10px;
  background: #DCFCE7; color: #16A34A;
  font-size: 11px; font-weight: 700;
  padding: 3px 10px; border-radius: 99px;
  display: inline-flex; align-items: center; gap: 4px;
}
.shop-badge::before {
  content: ''; width: 6px; height: 6px; border-radius: 50%;
  background: #16A34A; display: inline-block;
}
.shop-body { padding: 14px 16px 16px; }
.shop-name {
  font-size: 15px; font-weight: 700; color: var(--text-main);
  line-height: 1.3; margin-bottom: 4px;
  overflow: hidden; text-overflow: ellipsis; white-space: nowrap;
}
.shop-desc {
  font-size: 13px; color: #9CA3AF;
  display: -webkit-box; -webkit-line-clamp: 2;
  -webkit-box-orient: vertical; overflow: hidden;
  margin-bottom: 8px; min-height: 36px;
}
.shop-meta { display: flex; flex-direction: column; gap: 3px; margin-bottom: 12px; }
.shop-meta-row {
  display: flex; align-items: flex-start; gap: 6px;
  font-size: 12px; color: #9CA3AF;
}
.shop-meta-row svg { flex-shrink: 0; margin-top: 1px; }
.shop-meta-row span {
  overflow: hidden; text-overflow: ellipsis;
  white-space: nowrap;
}
.btn-shop {
  width: 100%; padding: 10px; border-radius: 10px;
  background: linear-gradient(135deg, var(--primary), #FF9A5C);
  color: #fff; font-size: 13.5px; font-weight: 600;
  text-align: center; border: none; cursor: pointer;
  transition: opacity .15s, transform .15s;
  box-shadow: 0 3px 12px rgba(255,122,48,.25);
}
.btn-shop:hover { opacity: .9; transform: translateY(-1px); }

/* EMPTY STATE */
.empty-state {
  text-align: center; padding: 64px 24px; color: #D1D5DB;
}
.empty-icon { margin-bottom: 12px; }
.empty-title { font-size: 16px; font-weight: 600; color: #9CA3AF; margin-bottom: 4px; }
.empty-hint { font-size: 13px; color: #D1D5DB; }

/* FOOTER */
.footer {
  text-align: center; padding: 24px;
  font-size: 12.5px; color: #C4C4C4;
  border-top: 1px solid #f0f0f0;
}

/* RESPONSIVE */
@media (max-width: 640px) {
  .nav-search { display: none; }
  .nav-links .hide-mobile { display: none; }
  .hero-title { font-size: 22px; }
  .hero-sub { font-size: 13px; }
  .shop-grid { grid-template-columns: 1fr 1fr; gap: 12px; }
  .shop-img { height: 120px; }
  .shop-body { padding: 10px 12px 14px; }
  .shop-name { font-size: 13.5px; }
  .shop-desc { font-size: 11.5px; min-height: 30px; }
  .btn-shop { font-size: 12px; padding: 8px; }
  .cat-pill { font-size: 12.5px; padding: 7px 16px; }
}
</style>
</head>
<body>

<!-- ===== NAVBAR ===== -->
<nav class="navbar">
  <div class="nav-logo">POB</div>
  <span class="nav-brand">POB Food</span>

  <div class="nav-search">
    <svg class="s-icon" width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/></svg>
    <input id="navSearch" type="text" placeholder="Tìm quán, món ăn..." oninput="filterShops(this.value)">
  </div>

  <div class="nav-links">
    <a href="${pageContext.request.contextPath}/user/donhang" class="nav-link hide-mobile">
      <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="m7.5 4.27 9 5.15"/><path d="M21 8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16Z"/><path d="m3.3 7 8.7 5 8.7-5"/><path d="M12 22V12"/></svg>
      <span>Đơn hàng</span>
    </a>
    <a href="${pageContext.request.contextPath}/user/dia-chi" class="nav-link hide-mobile">
      <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20 10c0 6-8 12-8 12s-8-6-8-12a8 8 0 0 1 16 0Z"/><circle cx="12" cy="10" r="3"/></svg>
      <span>Địa chỉ</span>
    </a>
    <div class="relative" id="avatarWrap" style="margin-left:4px;">
      <button class="avatar-btn" onclick="toggleDropdown()" aria-label="Tài khoản">${fn:substring(not empty account.fullName ? account.fullName : account.userName, 0, 1)}</button>
      <div class="dropdown" id="accountDropdown">
        <div class="dropdown-header">
          <div class="name">${not empty account.fullName ? account.fullName : account.userName}</div>
          <c:if test="${not empty account.email}"><div class="email">${account.email}</div></c:if>
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

<!-- ===== HERO ===== -->
<div class="hero">
  <div class="hero-inner">
    <h1 class="hero-title">🍽️ Tìm quán ăn ngon gần bạn</h1>
    <p class="hero-sub">Khám phá các quán ăn hấp dẫn, đặt đồ ăn dễ dàng</p>
    <div class="hero-search">
      <svg class="s-icon" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/></svg>
      <input id="heroSearch" type="text" placeholder="Tìm quán ăn, món ăn..." oninput="filterShops(this.value)">
    </div>
  </div>
</div>

<!-- ===== CATEGORY CAROUSEL ===== -->
<c:if test="${not empty categories}">
<div class="cat-section">
  <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:2px;">
    <span style="font-size:13px;font-weight:600;color:var(--text-muted);">Khám phá theo loại</span>
    <span style="font-size:11.5px;color:#D1D5DB;">&larr; cuộn ngang &rarr;</span>
  </div>
  <div class="cat-scroll" id="catScroll">
    <button class="cat-pill active" onclick="filterCategory('all', this)">Tất cả</button>
    <c:forEach var="cat" items="${categories}">
      <button class="cat-pill" data-cat="${fn:escapeXml(cat.categoryName)}" onclick="filterCategory('${fn:escapeXml(cat.categoryName)}', this)">${fn:escapeXml(cat.categoryName)}</button>
    </c:forEach>
  </div>
</div>
</c:if>

<!-- ===== SHOP GRID ===== -->
<div class="shop-section">
  <div class="section-head">
    <div class="left">
      <div class="section-title">Cửa hàng đang mở</div>
      <div class="section-sub" id="shopCount">
        <c:choose>
          <c:when test="${empty shops}">0 cửa hàng</c:when>
          <c:otherwise>${shops.size()} cửa hàng đang phục vụ</c:otherwise>
        </c:choose>
      </div>
    </div>
    <span class="section-action" onclick="filterShops('')">Xem tất cả</span>
  </div>

  <c:choose>
    <c:when test="${empty shops}">
      <div class="empty-state">
        <div class="empty-icon">
          <svg width="56" height="56" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><path d="M3 2v7c0 1.1.9 2 2 2h4a2 2 0 0 0 2-2V2"/><path d="M7 2v20"/><path d="M21 15V2a5 5 0 0 0-5 5v6c0 1.1.9 2 2 2h3Zm0 0v7"/></svg>
        </div>
        <div class="empty-title">Chưa có quán ăn nào</div>
        <div class="empty-hint">Vui lòng quay lại sau nhé!</div>
      </div>
    </c:when>
    <c:otherwise>
      <div class="shop-grid" id="shopGrid">
        <c:forEach var="shop" items="${shops}">
          <div class="shop-card" data-name="${fn:escapeXml(fn:toLowerCase(shop.shopName))}" data-desc="${fn:escapeXml(fn:toLowerCase(shop.shopDescription))}" data-addr="${fn:escapeXml(fn:toLowerCase(shop.shopAddress))}" onclick="goToShop(${shop.id})">

            <div class="shop-img">
              <c:choose>
                <c:when test="${not empty shop.shopLogo}">
                  <img src="${shop.shopLogo}" alt="${fn:escapeXml(shop.shopName)}" onerror="this.style.visibility='hidden';this.nextElementSibling.style.display='flex';">
                  <svg class="fallback-icon" width="44" height="44" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" style="display:none;position:absolute;"><path d="M3 2v7c0 1.1.9 2 2 2h4a2 2 0 0 0 2-2V2"/><path d="M7 2v20"/><path d="M21 15V2a5 5 0 0 0-5 5v6c0 1.1.9 2 2 2h3Zm0 0v7"/></svg>
                </c:when>
                <c:otherwise>
                  <svg class="fallback-icon" width="44" height="44" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><path d="M3 2v7c0 1.1.9 2 2 2h4a2 2 0 0 0 2-2V2"/><path d="M7 2v20"/><path d="M21 15V2a5 5 0 0 0-5 5v6c0 1.1.9 2 2 2h3Zm0 0v7"/></svg>
                </c:otherwise>
              </c:choose>
              <span class="shop-badge">Đang mở</span>
            </div>

            <div class="shop-body">
              <div class="shop-name" title="${fn:escapeXml(shop.shopName)}">${fn:escapeXml(shop.shopName)}</div>
              <c:if test="${not empty shop.shopDescription}">
                <div class="shop-desc">${fn:escapeXml(shop.shopDescription)}</div>
              </c:if>
              <div class="shop-meta">
                <c:if test="${not empty shop.shopAddress}">
                  <div class="shop-meta-row">
                    <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20 10c0 6-8 12-8 12s-8-6-8-12a8 8 0 0 1 16 0Z"/><circle cx="12" cy="10" r="3"/></svg>
                    <span>${fn:escapeXml(shop.shopAddress)}</span>
                  </div>
                </c:if>
                <c:if test="${not empty shop.shopPhone}">
                  <div class="shop-meta-row">
                    <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72c.127.96.362 1.903.7 2.81a2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45c.907.338 1.85.573 2.81.7A2 2 0 0 1 22 16.92Z"/></svg>
                    <span>${fn:escapeXml(shop.shopPhone)}</span>
                  </div>
                </c:if>
              </div>
              <button class="btn-shop">Xem thực đơn &rarr;</button>
            </div>

          </div>
        </c:forEach>
      </div>
    </c:otherwise>
  </c:choose>

  <div id="noResults" class="empty-state" style="display:none;">
    <div class="empty-icon">
      <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/></svg>
    </div>
    <div class="empty-title">Không tìm thấy quán nào</div>
    <div class="empty-hint">Thử từ khoá khác nhé</div>
  </div>
</div>

<!-- ===== FOOTER ===== -->
<div class="footer">
  &copy; 2024 POB Food &nbsp;·&nbsp; Đặt đồ ăn dễ dàng
</div>

<!-- ===== SCRIPTS ===== -->
<script>
function goToShop(shopId) {
  window.location.href = '${pageContext.request.contextPath}/user/shop?id=' + shopId;
}

function filterShops(query) {
  ['navSearch','heroSearch'].forEach(function(id) {
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
  var noRes = document.getElementById('noResults');
  var cnt = document.getElementById('shopCount');
  if (noRes) noRes.style.display = visible === 0 ? 'block' : 'none';
  if (cnt) {
    cnt.textContent = q
      ? visible + ' cửa hàng khớp với "' + query + '"'
      : visible + ' cửa hàng đang phục vụ';
  }
  // deactivate category pills on text search
  if (q) deactivateAllPills();
}

function filterCategory(catName, btn) {
  document.querySelectorAll('.cat-pill').forEach(function(p) { p.classList.remove('active'); });
  btn.classList.add('active');
  var cards = document.querySelectorAll('#shopGrid .shop-card');
  var visible = 0;
  cards.forEach(function(card) { card.style.display = ''; visible++; });
  var noRes = document.getElementById('noResults');
  var cnt = document.getElementById('shopCount');
  if (noRes) noRes.style.display = 'none';
  if (cnt) cnt.textContent = visible + ' cửa hàng đang phục vụ';
  // clear text search to avoid confusion
  ['navSearch','heroSearch'].forEach(function(id) {
    var el = document.getElementById(id);
    if (el) el.value = '';
  });
}

function deactivateAllPills() {
  document.querySelectorAll('.cat-pill').forEach(function(p) { p.classList.remove('active'); });
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
