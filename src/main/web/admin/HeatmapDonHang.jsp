<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%-- BẢO MẬT: KIỂM TRA QUYỀN SUPER ADMIN --%>
<c:if test="${empty sessionScope.account || sessionScope.account.roleId != 1}">
    <c:redirect url="/dangnhap"/>
</c:if>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script>!function(){var t=localStorage.getItem("pob-dashboard-theme")||"light";document.documentElement.setAttribute("data-theme",t)}()</script>
    <title>Heatmap khu vực đặt hàng - Super Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/theme.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css">
    <style>
        :root[data-theme="dark"] {
            --bg-base: #0f172a;
            --bg-sidebar: #1e293b;
            --bg-panel: #1e293b;
            --bg-input: #0f172a;
            --bg-hover: #1e293b;
            --text-main: #f8fafc;
            --text-muted: #94a3b8;
            --text-dim: #64748b;
            --border-color: #334155;
            --topbar-bg: rgba(30, 41, 59, 0.8);
        }

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

        .filter-bar { background: var(--bg-panel); border: 1px solid var(--border-color); border-radius: 10px; padding: 18px 20px; display: flex; align-items: flex-end; gap: 18px; flex-wrap: wrap; }
        .filter-field { display: flex; flex-direction: column; gap: 6px; }
        .filter-field label { font-size: 11px; text-transform: uppercase; letter-spacing: 0.5px; color: var(--text-muted); font-weight: 700; }
        .filter-field input[type="date"] { background: var(--bg-input); border: 1px solid var(--border-color); border-radius: 8px; padding: 9px 12px; color: var(--text-main); font-size: 13px; }
        .btn-filter { background: var(--primary); color: #ffffff; border: none; border-radius: 8px; padding: 10px 22px; font-size: 13px; font-weight: 700; cursor: pointer; }
        .btn-filter:hover { background: var(--primary-hover); }

        .heatmap-panel { background: var(--bg-panel); border: 1px solid var(--border-color); border-radius: 10px; padding: 18px 20px; margin-top: 20px; }
        .heatmap-panel .panel-title { margin-bottom: 12px; }
        #heatmapMap { width: 100%; height: 560px; border-radius: 8px; border: 1px solid var(--border-color); }
        .heatmap-empty { padding: 40px; text-align: center; color: var(--text-dim); font-size: 13px; }
    </style>
</head>
<body class="dash-body">
<div class="sidebar-backdrop" id="sidebarBackdrop"></div>
<aside class="sidebar" id="sidebar">
    <div class="sidebar-brand">
        <div class="logo-mark-dash">
            <c:choose>
                <c:when test="${not empty sessionScope.account.logoUrl}">
                    <img src="${sessionScope.account.logoUrl}" alt="logo" class="logo-mark-img"/>
                </c:when>
                <c:otherwise>S</c:otherwise>
            </c:choose>
        </div>
        <div class="brand-text">
            <span class="brand-title">SUPER ADMIN</span>
            <span class="brand-subtitle">👋 ${sessionScope.account.userName}</span>
        </div>
    <button type="button" class="sidebar-toggle-btn" id="sidebarToggleBtn" onclick="pobToggleSidebar()" title="Thu gọn / mở rộng menu">
        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><polyline points="15 18 9 12 15 6"></polyline></svg>
    </button>
    </div>
    <div class="menu">
        <div class="menu-group">
        <div class="menu-title" onclick="pobToggleMenuGroup(this)"><span>📊 Tổng quan &amp; phân tích</span><span class="menu-caret">▾</span></div>
        <a href="${pageContext.request.contextPath}/tong-quan" class="menu-item">
            <span class="mi-left"><span class="mi-icon">⊞</span><span class="mi-label"> Tổng quan hệ thống</span></span>
        </a>
        <a href="${pageContext.request.contextPath}/admin/bao-cao-van-hanh" class="menu-item">
            <span class="mi-left"><span class="mi-icon">📈</span><span class="mi-label"> Báo cáo vận hành</span></span>
        </a>
        <a href="${pageContext.request.contextPath}/admin/heatmap-don-hang" class="menu-item active">
            <span class="mi-left"><span class="mi-icon">🗺️</span><span class="mi-label"> Heatmap đặt hàng</span></span>
        </a>

        </div>
        <div class="menu-group">
        <div class="menu-title" onclick="pobToggleMenuGroup(this)"><span>⚖️ Kiểm duyệt &amp; điều phối</span><span class="menu-caret">▾</span></div>
        <a href="${pageContext.request.contextPath}/super-admin/shop-requests" class="menu-item">
            <span class="mi-left"><span class="mi-icon">🏪</span><span class="mi-label"> Duyệt Shop</span></span>
            <c:if test="${shopChoDuyet > 0}"><span class="menu-badge yellow">${shopChoDuyet}</span></c:if>
        </a>
        <a href="${pageContext.request.contextPath}/super-admin/shipper-requests" class="menu-item">
            <span class="mi-left"><span class="mi-icon">🛵</span><span class="mi-label"> Duyệt Shipper</span></span>
            <c:if test="${not empty pendingShippers}"><span class="menu-badge yellow">${pendingShippers.size()}</span></c:if>
        </a>
        <a href="${pageContext.request.contextPath}/admin/kiem-duyet-noi-dung" class="menu-item">
            <span class="mi-left"><span class="mi-icon">🚩</span><span class="mi-label"> Kiểm duyệt nội dung</span></span>
            <c:if test="${not empty pendingProducts}"><span class="menu-badge yellow">${pendingProducts.size()}</span></c:if>
        </a>
        <a href="${pageContext.request.contextPath}/admin/kiem-duyet-binh-luan" class="menu-item">
            <span class="mi-left"><span class="mi-icon">💬</span><span class="mi-label"> Kiểm duyệt bình luận</span></span>
        </a>
        <a href="${pageContext.request.contextPath}/admin/khieu-nai" class="menu-item">
            <span class="mi-left"><span class="mi-icon">📢</span><span class="mi-label"> Quản lý khiếu nại</span></span>
        </a>
        <a href="${pageContext.request.contextPath}/admin/appeals" class="menu-item">
            <span class="mi-left"><span class="mi-icon">📋</span><span class="mi-label"> Kháng nghị</span></span>
            <c:if test="${pendingCount > 0}"><span class="menu-badge yellow">${pendingCount}</span></c:if>
        </a>

        </div>
        <div class="menu-group">
        <div class="menu-title" onclick="pobToggleMenuGroup(this)"><span>💰 Quản lý tài chính</span><span class="menu-caret">▾</span></div>
        <a href="${pageContext.request.contextPath}/admin/doi-soat-doanh-thu-shop" class="menu-item">
            <span class="mi-left"><span class="mi-icon">💵</span><span class="mi-label"> Đối soát doanh thu Shop</span></span>
        </a>
        <a href="${pageContext.request.contextPath}/admin/duyet-rut-tien-shipper" class="menu-item">
            <span class="mi-left"><span class="mi-icon">💳</span><span class="mi-label"> Duyệt rút tiền Shipper</span></span>
        </a>
        <a href="${pageContext.request.contextPath}/admin/vouchers" class="menu-item">
            <span class="mi-left"><span class="mi-icon">🎟️</span><span class="mi-label"> Voucher / Khuyến mãi</span></span>
        </a>

        </div>
        <div class="menu-group">
        <div class="menu-title" onclick="pobToggleMenuGroup(this)"><span>⚙️ Cấu hình &amp; hệ thống</span><span class="menu-caret">▾</span></div>
        <a href="${pageContext.request.contextPath}/quanlitaikhoan" class="menu-item">
            <span class="mi-left"><span class="mi-icon">👤</span><span class="mi-label"> Người dùng</span></span>
        </a>
        <a href="${pageContext.request.contextPath}/admin/tham-so-van-hanh" class="menu-item">
            <span class="mi-left"><span class="mi-icon">🛠️</span><span class="mi-label"> Tham số vận hành</span></span>
        </a>
        <a href="${pageContext.request.contextPath}/admin/faq" class="menu-item">
            <span class="mi-left"><span class="mi-icon">❓</span><span class="mi-label"> FAQ / Hướng dẫn</span></span>
        </a>
        <a href="${pageContext.request.contextPath}/admin/audit-logs" class="menu-item">
            <span class="mi-left"><span class="mi-icon">🕒</span><span class="mi-label"> Nhật ký hệ thống</span></span>
        </a>
        </div>
    </div>
</aside>

<main class="main">
    <header class="topbar">
        <div style="display:flex;align-items:center;gap:10px;">
            <button type="button" class="menu-toggle-btn" onclick="pobToggleSidebar()">☰</button>
            <h1>HEATMAP KHU VỰC ĐẶT HÀNG</h1>
        </div>
        <div class="topbar-right">
            <button type="button" class="theme-toggle" onclick="pobToggleTheme()" title="Chuyển đổi giao diện"><span data-theme-icon>🌙</span></button>
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
        <form class="filter-bar" method="get" action="${pageContext.request.contextPath}/admin/heatmap-don-hang">
            <div class="filter-field">
                <label for="tuNgay">Từ ngày</label>
                <input type="date" id="tuNgay" name="tuNgay" value="${tuNgay}" max="${denNgay}">
            </div>
            <div class="filter-field">
                <label for="denNgay">Đến ngày</label>
                <input type="date" id="denNgay" name="denNgay" value="${denNgay}" min="${tuNgay}">
            </div>
            <button type="submit" class="btn-filter">🔍 Xem heatmap</button>
        </form>

        <div class="heatmap-panel">
            <div class="panel-title">■ MẬT ĐỘ ĐƠN HÀNG (${soDiem} đơn có toạ độ, từ ${tuNgay} đến ${denNgay})</div>
            <c:choose>
                <c:when test="${soDiem > 0}">
                    <div id="heatmapMap"></div>
                </c:when>
                <c:otherwise>
                    <div class="heatmap-empty">🗺️ Không có đơn hàng nào có toạ độ trong khoảng thời gian đã chọn.</div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</main>

<div class="avatar-dropdown" id="avatarDropdown">
    <div class="dropdown-header">
        <div class="d-name">${sessionScope.account.userName}</div>
        <div class="d-email">${sessionScope.account.email}</div>
        <span class="d-role">Super Admin</span>
    </div>
    <div class="dropdown-body">
        <a href="${pageContext.request.contextPath}/admin/profile" class="dropdown-link">👤 Hồ sơ cá nhân</a>
        <a href="${pageContext.request.contextPath}/admin/change-password" class="dropdown-link">🔒 Đổi mật khẩu</a>
        <div class="dropdown-divider"></div>
        <a href="${pageContext.request.contextPath}/logout" class="dropdown-link danger">🚪 Đăng xuất</a>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/dashboard-theme.js"></script>
<script>
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

<c:if test="${soDiem > 0}">
    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
    <script src="https://unpkg.com/leaflet.heat@0.2.0/dist/leaflet-heat.js"></script>
    <script>
        var points = ${heatmapPointsJson};
        var map = L.map('heatmapMap');
        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
            attribution: '&copy; OpenStreetMap contributors',
            maxZoom: 19
        }).addTo(map);

        var bounds = L.latLngBounds(points.map(function(p) { return [p[0], p[1]]; }));
        map.fitBounds(bounds.pad(0.15));

        L.heatLayer(points, { radius: 22, blur: 18, maxZoom: 17 }).addTo(map);
    </script>
</c:if>
</body>
</html>
