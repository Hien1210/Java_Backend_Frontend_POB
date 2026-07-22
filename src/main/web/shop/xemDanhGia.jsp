<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

<c:if test="${empty sessionScope.account || sessionScope.account.roleId != 2}">
    <c:redirect url="/dangnhap"/>
</c:if>

<!DOCTYPE html>
<html lang="vi" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Xem đánh giá - POB Shop</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/theme.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
    <style>
        .avatar-wrapper { position: relative; }
        .avatar-dropdown { display: none; position: fixed; background: var(--bg-panel); border: 1px solid var(--border-color); border-radius: 12px; box-shadow: var(--dash-shadow-md); min-width: 220px; z-index: 500; }
        .avatar-dropdown.open { display: block; animation: pobFadeUp .18s ease both; }
        .dropdown-header { padding: 14px 16px; border-bottom: 1px solid var(--border-color); }
        .dropdown-header .d-name { font-size: 14px; font-weight: 700; color: var(--text-main); }
        .dropdown-header .d-email { font-size: 12px; color: var(--text-muted); margin-top: 2px; }
        .dropdown-header .d-role { display: inline-block; margin-top: 6px; font-size: 10px; font-weight: 700; padding: 2px 8px; border-radius: 4px; background: var(--primary-light); color: var(--primary); border: 1px solid var(--primary); }
        .dropdown-body { padding: 6px 0 8px; }
        .dropdown-link { display: flex; align-items: center; gap: 10px; padding: 10px 16px; font-size: 13px; color: var(--text-muted); cursor: pointer; }
        .dropdown-link:hover { background: var(--bg-input); color: var(--text-main); }
        .dropdown-divider { height: 1px; background: var(--border-color); margin: 4px 0; }
        .dropdown-link.danger { color: var(--danger); }
        .dropdown-link.danger:hover { background: var(--danger-light); color: var(--danger); }

        /* Đặc thù trang đánh giá: banner tổng quan sao + tabs + card đánh giá */
        .overview-card { background: linear-gradient(120deg, var(--primary) 0%, var(--danger) 100%); border-radius: var(--radius-lg); padding: 24px 28px; color: #fff; margin-bottom: 24px; display: flex; align-items: center; justify-content: space-between; box-shadow: var(--dash-shadow-md); }
        .overview-rating { font-size: 52px; font-weight: 900; line-height: 1; }
        .overview-stars { display: flex; gap: 4px; margin: 6px 0; font-size: 20px; }
        .overview-count { font-size: 13px; opacity: .88; }
        .overview-info h2 { font-size: 20px; font-weight: 800; margin-bottom: 4px; }
        .overview-info p { font-size: 13px; opacity: .88; }
        .overview-emoji { font-size: 52px; }

        .tab-bar { display: flex; border-bottom: 1px solid var(--border-color); }
        .tab-btn { flex: 1; padding: 16px; font-size: 14px; font-weight: 600; color: var(--text-muted); background: none; border: none; cursor: pointer; border-bottom: 3px solid transparent; transition: all .2s; display: flex; align-items: center; justify-content: center; gap: 8px; }
        .tab-btn:hover { color: var(--primary-dark); background: var(--bg-hover); }
        .tab-btn.active { color: var(--primary-dark); border-bottom-color: var(--primary); background: var(--primary-light); font-weight: 700; }
        .tab-badge { font-size: 11px; padding: 2px 8px; border-radius: 12px; font-weight: 700; }
        .tab-badge.blue { background: var(--info-light); color: var(--info-dark); }
        .tab-badge.green { background: var(--success-light); color: var(--success-dark); }

        .tab-panel { display: none; padding: 24px; }
        .tab-panel.active { display: block; }

        /* REVIEW CARD */
        .review-list { display: flex; flex-direction: column; gap: 14px; }
        .review-card { background: var(--bg-input); border: 1px solid var(--border-color); border-radius: 12px; padding: 18px; transition: all .2s; }
        .review-card:hover { background: var(--bg-hover); box-shadow: var(--dash-shadow-sm); }
        .review-header { display: flex; align-items: flex-start; justify-content: space-between; margin-bottom: 10px; }
        .reviewer-info { display: flex; align-items: center; gap: 10px; }
        .reviewer-avatar { width: 36px; height: 36px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: 800; font-size: 15px; flex-shrink: 0; }
        .reviewer-avatar.user-type { background: var(--info-light); color: var(--info-dark); }
        .reviewer-avatar.shipper-type { background: var(--success-light); color: var(--success-dark); }
        .reviewer-name { font-size: 14px; font-weight: 700; color: var(--text-main); }
        .reviewer-order { font-size: 12px; color: var(--text-muted); }
        .review-meta { display: flex; align-items: center; gap: 8px; }
        .stars { display: flex; gap: 2px; font-size: 15px; }
        .star-filled { color: var(--warning); }
        .star-empty { color: var(--border-color); }
        .review-date { font-size: 12px; color: var(--text-dim); }
        .review-comment { font-size: 13.5px; color: var(--text-main); line-height: 1.65; padding-top: 4px; }
    </style>
</head>
<body class="dash-body">

<div class="sidebar-backdrop" id="sidebarBackdrop"></div>
<aside class="sidebar" id="sidebar">
    <div class="sidebar-brand">
        <div class="logo-mark-dash">🍔</div>
        <div class="brand-text">
            <span class="brand-title">${not empty shop.shopName ? shop.shopName : 'CỬA HÀNG CỦA TÔI'}</span>
            <span class="brand-subtitle">👋 ${sessionScope.account.userName}</span>
        </div>
    </div>
    <div class="menu">
        <div class="menu-title">Tổng quan</div>
        <a href="${pageContext.request.contextPath}/shop" class="menu-item">
            <span class="mi-left"><span class="mi-icon">📊</span> Trang chủ</span>
        </a>

        <div class="menu-title">Sản phẩm</div>
        <a href="${pageContext.request.contextPath}/shop/products" class="menu-item">
            <span class="mi-left"><span class="mi-icon">🍽️</span> Quản lý sản phẩm</span>
        </a>
        <a href="${pageContext.request.contextPath}/shop/product-types" class="menu-item">
            <span class="mi-left"><span class="mi-icon">📂</span> Quản lý loại sản phẩm</span>
        </a>

        <div class="menu-title">Topping</div>
        <a href="${pageContext.request.contextPath}/shop/toppings" class="menu-item">
            <span class="mi-left"><span class="mi-icon">🧂</span> Quản lý Topping</span>
        </a>
        <a href="${pageContext.request.contextPath}/shop/topping-categories" class="menu-item">
            <span class="mi-left"><span class="mi-icon">🏷️</span> Quản lý loại Topping</span>
        </a>

        <div class="menu-title">Đơn hàng</div>
        <a href="${pageContext.request.contextPath}/shop/pos" class="menu-item">
            <span class="mi-left"><span class="mi-icon">🧾</span> Bấm Bill</span>
        </a>
        <a href="${pageContext.request.contextPath}/shop/bills" class="menu-item">
            <span class="mi-left"><span class="mi-icon">📋</span> Quản lý hóa đơn</span>
        </a>

        <div class="menu-title">Cửa hàng</div>
        <a href="${pageContext.request.contextPath}/shop/profile" class="menu-item">
            <span class="mi-left"><span class="mi-icon">🏪</span> Thông tin cửa hàng</span>
        </a>
        <a href="${pageContext.request.contextPath}/shop/danh-gia" class="menu-item active">
            <span class="mi-left"><span class="mi-icon">⭐</span> Xem đánh giá</span>
        </a>
    </div>
</aside>

<main class="main">
    <header class="topbar">
        <div style="display:flex;align-items:center;gap:10px;">
            <button type="button" class="menu-toggle-btn" onclick="pobToggleSidebar()">☰</button>
            <h1>⭐ Xem đánh giá</h1>
        </div>
        <div class="topbar-right">
            <div class="avatar-wrapper" id="avatarWrapper">
                <div class="avatar-circle" id="avatarBtn">
                    <c:choose>
                        <c:when test="${not empty sessionScope.account.avatarUrl}">
                            <img src="${sessionScope.account.avatarUrl}" alt="avatar"/>
                        </c:when>
                        <c:otherwise>${fn:toUpperCase(fn:substring(sessionScope.account.userName, 0, 2))}</c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </header>

    <div class="content">

        <!-- Overview banner -->
        <div class="overview-card">
            <div>
                <div class="overview-rating"><fmt:formatNumber value="${avgRating}" maxFractionDigits="1"/></div>
                <div class="overview-stars">
                    <c:forEach begin="1" end="5" var="i">
                        <span class="${i <= avgRating ? 'star-filled' : 'star-empty'}">★</span>
                    </c:forEach>
                </div>
                <div class="overview-count">${totalFeedback} đánh giá tổng cộng</div>
            </div>
            <div class="overview-info">
                <h2>${shop.shopName}</h2>
                <p>Đánh giá từ khách hàng và shipper của cửa hàng bạn</p>
            </div>
            <div class="overview-emoji">⭐</div>
        </div>

        <!-- Tab panel -->
        <div class="panel">
            <div class="tab-bar">
                <button class="tab-btn active" onclick="switchTab('user')" id="tab-user">
                    👤 Từ Khách hàng
                    <span class="tab-badge blue">${feedbackUser.size()}</span>
                </button>
                <button class="tab-btn" onclick="switchTab('shipper')" id="tab-shipper">
                    🛵 Từ Shipper
                    <span class="tab-badge green">${feedbackShipper.size()}</span>
                </button>
            </div>

            <!-- Tab User -->
            <div class="tab-panel active" id="panel-user">
                <c:choose>
                    <c:when test="${empty feedbackUser}">
                        <div class="empty-state">
                            <div class="e-icon">💬</div>
                            <div class="e-title">Chưa có đánh giá từ khách hàng</div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="review-list">
                            <c:forEach var="fb" items="${feedbackUser}">
                                <div class="review-card">
                                    <div class="review-header">
                                        <div class="reviewer-info">
                                            <div class="reviewer-avatar user-type">
                                                ${fb.anonymous ? '?' : fn:toUpperCase(fn:substring(fb.reviewerName, 0, 1))}
                                            </div>
                                            <div>
                                                <div class="reviewer-name">${fb.anonymous ? 'Ẩn danh' : fb.reviewerName}</div>
                                                <div class="reviewer-order">Đơn #${fb.orderId}</div>
                                            </div>
                                        </div>
                                        <div class="review-meta">
                                            <div class="stars">
                                                <c:forEach begin="1" end="5" var="i">
                                                    <span class="${i <= fb.rating ? 'star-filled' : 'star-empty'}">★</span>
                                                </c:forEach>
                                            </div>
                                            <span class="review-date">
                                                <fmt:formatDate value="${fb.createdAt}" pattern="dd/MM/yyyy"/>
                                            </span>
                                        </div>
                                    </div>
                                    <c:if test="${not empty fb.comment}">
                                        <div class="review-comment">${fn:escapeXml(fb.comment)}</div>
                                    </c:if>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Tab Shipper -->
            <div class="tab-panel" id="panel-shipper">
                <c:choose>
                    <c:when test="${empty feedbackShipper}">
                        <div class="empty-state">
                            <div class="e-icon">🛵</div>
                            <div class="e-title">Chưa có đánh giá từ shipper</div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="review-list">
                            <c:forEach var="fb" items="${feedbackShipper}">
                                <div class="review-card">
                                    <div class="review-header">
                                        <div class="reviewer-info">
                                            <div class="reviewer-avatar shipper-type">
                                                ${fn:toUpperCase(fn:substring(fb.reviewerName, 0, 1))}
                                            </div>
                                            <div>
                                                <div class="reviewer-name">${fb.reviewerName}</div>
                                                <div class="reviewer-order">Đơn #${fb.orderId}</div>
                                            </div>
                                        </div>
                                        <div class="review-meta">
                                            <div class="stars">
                                                <c:forEach begin="1" end="5" var="i">
                                                    <span class="${i <= fb.rating ? 'star-filled' : 'star-empty'}">★</span>
                                                </c:forEach>
                                            </div>
                                            <span class="review-date">
                                                <fmt:formatDate value="${fb.createdAt}" pattern="dd/MM/yyyy"/>
                                            </span>
                                        </div>
                                    </div>
                                    <c:if test="${not empty fb.comment}">
                                        <div class="review-comment">${fn:escapeXml(fb.comment)}</div>
                                    </c:if>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

    </div>
</main>

<div class="avatar-dropdown" id="avatarDropdown">
    <div class="dropdown-header">
        <div class="d-name">${sessionScope.account.userName}</div>
        <div class="d-email">${sessionScope.account.email}</div>
        <span class="d-role">🏪 Shop Owner</span>
    </div>
    <div class="dropdown-body">
        <a href="${pageContext.request.contextPath}/shop/ho-so" class="dropdown-link">👤 Hồ sơ cá nhân</a>
        <a href="${pageContext.request.contextPath}/shop/doi-mat-khau" class="dropdown-link">🔒 Đổi mật khẩu</a>
        <div class="dropdown-divider"></div>
        <a href="${pageContext.request.contextPath}/logout" class="dropdown-link danger">🚪 Đăng xuất</a>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/dashboard-theme.js"></script>
<script>
    function switchTab(tab) {
        document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
        document.querySelectorAll('.tab-panel').forEach(p => p.classList.remove('active'));
        document.getElementById('tab-' + tab).classList.add('active');
        document.getElementById('panel-' + tab).classList.add('active');
    }

    document.addEventListener('DOMContentLoaded', function() {
        var avatarBtn = document.getElementById('avatarBtn');
        var avatarDropdown = document.getElementById('avatarDropdown');
        if (avatarBtn && avatarDropdown) {
            avatarBtn.addEventListener('click', function(e) {
                e.stopPropagation();
                var rect = avatarBtn.getBoundingClientRect();
                avatarDropdown.style.top = (rect.bottom + 10) + 'px';
                avatarDropdown.style.right = (window.innerWidth - rect.right) + 'px';
                avatarDropdown.classList.toggle('open');
            });
            avatarDropdown.addEventListener('click', function(e) { e.stopPropagation(); });
            document.addEventListener('click', function() { avatarDropdown.classList.remove('open'); });
        }
    });
</script>
</body>
</html>
