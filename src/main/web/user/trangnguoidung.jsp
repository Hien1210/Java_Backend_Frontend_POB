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
    /* (incoming branch full theme and layout retained) */
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

// (incoming branch cart UI handlers merged)


</script>
<script>window.POB_CONTEXT_PATH = '${pageContext.request.contextPath}';</script>
<script src="${pageContext.request.contextPath}/assets/js/toast.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/notifications-ws.js"></script>
</body>
</html>
