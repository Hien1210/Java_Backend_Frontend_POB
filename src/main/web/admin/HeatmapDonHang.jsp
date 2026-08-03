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
    <title>Dashboard Phân Tích Mật Độ Đơn Hàng - Super Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/theme.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css">
    <link rel="stylesheet" href="https://unpkg.com/leaflet.markercluster@1.5.3/dist/MarkerCluster.css">
    <link rel="stylesheet" href="https://unpkg.com/leaflet.markercluster@1.5.3/dist/MarkerCluster.Default.css">
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

        .filter-bar { background: var(--bg-panel); border: 1px solid var(--border-color); border-radius: 12px; padding: 18px 20px; display: flex; align-items: flex-end; gap: 18px; flex-wrap: wrap; margin-bottom: 20px; box-shadow: var(--shadow-sm); }
        .filter-field { display: flex; flex-direction: column; gap: 6px; }
        .filter-field label { font-size: 11px; text-transform: uppercase; letter-spacing: 0.5px; color: var(--text-muted); font-weight: 700; }
        .filter-field input[type="date"] { background: var(--bg-input); border: 1px solid var(--border-color); border-radius: 8px; padding: 9px 12px; color: var(--text-main); font-size: 13px; }
        .btn-filter { background: var(--primary); color: #ffffff; border: none; border-radius: 8px; padding: 10px 22px; font-size: 13px; font-weight: 700; cursor: pointer; transition: background .15s, transform .1s; }
        .btn-filter:hover { background: var(--primary-dark); }
        .btn-filter:active { transform: scale(0.97); }

        /* KPI STAT CARDS */
        .kpi-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(210px, 1fr)); gap: 16px; margin-bottom: 20px; }
        .kpi-card { background: var(--bg-panel); border: 1px solid var(--border-color); border-radius: 12px; padding: 16px 20px; display: flex; align-items: center; gap: 14px; box-shadow: var(--shadow-sm); }
        .kpi-icon { width: 46px; height: 46px; border-radius: 10px; display: flex; align-items: center; justify-content: center; font-size: 22px; flex-shrink: 0; }
        .kpi-icon.blue { background: rgba(59, 130, 246, 0.12); color: #3b82f6; }
        .kpi-icon.green { background: rgba(34, 197, 94, 0.12); color: #22c55e; }
        .kpi-icon.orange { background: rgba(255, 87, 34, 0.12); color: #FF5722; }
        .kpi-icon.purple { background: rgba(168, 85, 247, 0.12); color: #a855f7; }
        .kpi-info { display: flex; flex-direction: column; }
        .kpi-label { font-size: 12px; color: var(--text-muted); font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; }
        .kpi-value { font-size: 22px; font-weight: 800; color: var(--text-main); line-height: 1.2; margin-top: 2px; }

        /* DASHBOARD MAIN LAYOUT */
        .dash-content-grid { display: grid; grid-template-columns: 1fr 340px; gap: 20px; align-items: start; }
        @media (max-width: 1024px) { .dash-content-grid { grid-template-columns: 1fr; } }

        .map-wrapper-card { background: var(--bg-panel); border: 1px solid var(--border-color); border-radius: 12px; padding: 18px 20px; box-shadow: var(--shadow-sm); position: relative; }
        .map-header { display: flex; align-items: center; justify-content: space-between; margin-bottom: 14px; flex-wrap: wrap; gap: 10px; }
        .map-title { font-size: 15px; font-weight: 700; color: var(--text-main); display: flex; align-items: center; gap: 8px; }

        /* View Mode Controls */
        .view-mode-toggle { display: inline-flex; background: var(--bg-input); padding: 4px; border-radius: 8px; border: 1px solid var(--border-color); gap: 4px; }
        .view-mode-btn { border: none; background: transparent; padding: 6px 12px; font-size: 12px; font-weight: 600; color: var(--text-muted); border-radius: 6px; cursor: pointer; transition: all .15s; }
        .view-mode-btn.active { background: var(--primary); color: #fff; box-shadow: 0 2px 6px rgba(255,87,34,.3); }

        #heatmapMap { width: 100%; height: 580px; border-radius: 10px; border: 1px solid var(--border-color); z-index: 1; }

        /* Legend overlay on map */
        .map-legend { background: var(--bg-panel); border: 1px solid var(--border-color); border-radius: 8px; padding: 10px 14px; font-size: 12px; color: var(--text-main); box-shadow: 0 4px 12px rgba(0,0,0,0.15); display: flex; align-items: center; gap: 12px; flex-wrap: wrap; margin-top: 12px; }
        .legend-item { display: flex; align-items: center; gap: 6px; font-weight: 600; }
        .legend-dot { width: 12px; height: 12px; border-radius: 50%; display: inline-block; }

        /* Top regions panel */
        .regions-panel { background: var(--bg-panel); border: 1px solid var(--border-color); border-radius: 12px; padding: 18px 20px; box-shadow: var(--shadow-sm); }
        .regions-title { font-size: 15px; font-weight: 700; color: var(--text-main); margin-bottom: 14px; display: flex; align-items: center; justify-content: space-between; }
        .region-list { display: flex; flex-direction: column; gap: 10px; max-height: 595px; overflow-y: auto; padding-right: 4px; }
        .region-item { background: var(--bg-input); border: 1px solid var(--border-color); border-radius: 10px; padding: 12px 14px; cursor: pointer; transition: all .15s; }
        .region-item:hover { border-color: var(--primary); transform: translateX(3px); background: rgba(255, 87, 34, 0.05); }
        .region-head { display: flex; justify-content: space-between; align-items: center; margin-bottom: 6px; }
        .region-name { font-size: 13.5px; font-weight: 700; color: var(--text-main); }
        .region-count { font-size: 12px; font-weight: 700; color: var(--primary); background: var(--primary-light); padding: 2px 8px; border-radius: 12px; }
        .region-progress-bg { height: 6px; background: rgba(0,0,0,0.08); border-radius: 3px; overflow: hidden; }
        .region-progress-bar { height: 100%; background: linear-gradient(90deg, #FF5722, #f59e0b); border-radius: 3px; }

        /* Leaflet popup styling */
        .leaflet-popup-content-wrapper { border-radius: 10px; padding: 4px; box-shadow: 0 8px 24px rgba(0,0,0,0.2); }
        .popup-order-card { font-family: inherit; font-size: 13px; line-height: 1.4; color: #1e293b; min-width: 210px; }
        .popup-order-title { font-weight: 700; color: #FF5722; font-size: 14px; margin-bottom: 6px; border-bottom: 1px solid #eee; padding-bottom: 4px; display: flex; justify-content: space-between; }
        .popup-order-info { margin-bottom: 4px; font-size: 12px; color: #475569; }
        .popup-order-info strong { color: #0f172a; }
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
            <a href="${pageContext.request.contextPath}/admin/duyet-rut-tien-shop" class="menu-item">
                <span class="mi-left"><span class="mi-icon">🏪</span><span class="mi-label"> Duyệt rút tiền Shop</span></span>
            </a>
            <a href="${pageContext.request.contextPath}/admin/hoan-tien" class="menu-item">
                <span class="mi-left"><span class="mi-icon">↩️</span><span class="mi-label"> Hoàn tiền khách hàng</span></span>
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
            <h1>HEATMAP &amp; PHÂN TÍCH ĐƠN HÀNG</h1>
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
        <!-- Filter Bar -->
        <form class="filter-bar" method="get" action="${pageContext.request.contextPath}/admin/heatmap-don-hang">
            <div class="filter-field">
                <label for="tuNgay">Từ ngày</label>
                <input type="date" id="tuNgay" name="tuNgay" value="${tuNgay}" max="${denNgay}">
            </div>
            <div class="filter-field">
                <label for="denNgay">Đến ngày</label>
                <input type="date" id="denNgay" name="denNgay" value="${denNgay}" min="${tuNgay}">
            </div>
            <button type="submit" class="btn-filter">🔍 Lọc dữ liệu</button>
        </form>

        <!-- KPI Cards -->
        <div class="kpi-grid">
            <div class="kpi-card">
                <div class="kpi-icon blue">📦</div>
                <div class="kpi-info">
                    <span class="kpi-label">Tổng số đơn</span>
                    <span class="kpi-value">${tongSoDon}</span>
                </div>
            </div>
            <div class="kpi-card">
                <div class="kpi-icon green">📍</div>
                <div class="kpi-info">
                    <span class="kpi-label">Có định vị GPS</span>
                    <span class="kpi-value">${soDiemGps}</span>
                </div>
            </div>
            <div class="kpi-card">
                <div class="kpi-icon purple">🏙️</div>
                <div class="kpi-info">
                    <span class="kpi-label">Số Khu Vực</span>
                    <span class="kpi-value" id="kpiRegionCount">--</span>
                </div>
            </div>
            <div class="kpi-card">
                <div class="kpi-icon orange">🔥</div>
                <div class="kpi-info">
                    <span class="kpi-label">Hot Nhất</span>
                    <span class="kpi-value" id="kpiTopRegion" style="font-size: 16px;">--</span>
                </div>
            </div>
        </div>

        <c:choose>
            <c:when test="${tongSoDon > 0}">
                <!-- Main Dashboard Content Grid -->
                <div class="dash-content-grid">
                    <!-- Left: Map Container -->
                    <div class="map-wrapper-card">
                        <div class="map-header">
                            <div class="map-title">🗺️ Mật Độ &amp; Cụm Đơn Hàng (${soDiem} điểm biểu diễn)</div>
                            <div class="view-mode-toggle">
                                <button type="button" class="view-mode-btn active" onclick="setMapViewMode('both')">Chế độ xem cả 2</button>
                                <button type="button" class="view-mode-btn" onclick="setMapViewMode('heat')">Chỉ Heatmap</button>
                                <button type="button" class="view-mode-btn" onclick="setMapViewMode('cluster')">Chỉ Marker Cluster</button>
                            </div>
                        </div>

                        <div id="heatmapMap"></div>

                        <!-- Legend -->
                        <div class="map-legend">
                            <span style="font-weight: 700; margin-right: 4px;">Chú thích mật độ:</span>
                            <div class="legend-item"><span class="legend-dot" style="background:#3b82f6;"></span> 🔵 1-5 đơn</div>
                            <div class="legend-item"><span class="legend-dot" style="background:#22c55e;"></span> 🟢 6-15 đơn</div>
                            <div class="legend-item"><span class="legend-dot" style="background:#eab308;"></span> 🟡 16-30 đơn</div>
                            <div class="legend-item"><span class="legend-dot" style="background:#f97316;"></span> 🟠 31-60 đơn</div>
                            <div class="legend-item"><span class="legend-dot" style="background:#ef4444;"></span> 🔴 &gt;60 đơn</div>
                        </div>
                    </div>

                    <!-- Right: Top Regions / Top Shops Panel -->
                    <div class="regions-panel">
                        <div class="regions-title">
                            <span>🔥 TOP KHU VỰC &amp; SHOP</span>
                            <span style="font-size: 12px; color: var(--text-muted); font-weight: normal;">Click để phóng tới</span>
                        </div>
                        <div class="region-list" id="regionListContainer">
                            <!-- Populated dynamically by JS -->
                        </div>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="heatmap-empty">
                    <div style="font-size: 40px; margin-bottom: 12px;">📦</div>
                    <div style="font-size: 16px; font-weight: 700; color: var(--text-main); margin-bottom: 6px;">Không có đơn đặt hàng nào</div>
                    <div style="color: var(--text-muted);">Không tìm thấy đơn hàng nào phát sinh trong khoảng thời gian từ <strong>${tuNgay}</strong> đến <strong>${denNgay}</strong>.</div>
                </div>
            </c:otherwise>
        </c:choose>
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
<script src="${pageContext.request.contextPath}/assets/js/pob-dialog.js"></script>
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

<c:if test="${tongSoDon > 0}">
<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
<script src="https://unpkg.com/leaflet.heat@0.2.0/dist/leaflet-heat.js"></script>
<script src="https://unpkg.com/leaflet.markercluster@1.5.3/dist/leaflet.markercluster.js"></script>
<script>
    var heatmapPoints = ${heatmapPointsJson};
    var orderDetails = ${orderDetailsJson};

    var map = L.map('heatmapMap');
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: '&copy; OpenStreetMap contributors',
        maxZoom: 19
    }).addTo(map);

        var bounds = L.latLngBounds(points.map(function(p) { return [p[0], p[1]]; }));
        map.fitBounds(bounds.pad(0.15));

        // 4. View Mode Switching
        window.setMapViewMode = function(mode) {
            document.querySelectorAll('.view-mode-btn').forEach(function(btn) { btn.classList.remove('active'); });
            if (event && event.target) event.target.classList.add('active');

            if (mode === 'both') {
                if (!map.hasLayer(heatLayer)) map.addLayer(heatLayer);
                if (!map.hasLayer(markersCluster)) map.addLayer(markersCluster);
            } else if (mode === 'heat') {
                if (!map.hasLayer(heatLayer)) map.addLayer(heatLayer);
                if (map.hasLayer(markersCluster)) map.removeLayer(markersCluster);
            } else if (mode === 'cluster') {
                if (map.hasLayer(heatLayer)) map.removeLayer(heatLayer);
                if (!map.hasLayer(markersCluster)) map.addLayer(markersCluster);
            }
        };

        // 5. Render Top Regions List & KPIs
        var sortedRegions = Object.keys(regionMap).map(function(key) {
            return { name: key, count: regionMap[key].count, points: regionMap[key].points };
        }).sort(function(a, b) { return b.count - a.count; });

        document.getElementById('kpiRegionCount').textContent = sortedRegions.length;
        if (sortedRegions.length > 0) {
            document.getElementById('kpiTopRegion').textContent = sortedRegions[0].name;
        }

        var maxCount = sortedRegions.length > 0 ? sortedRegions[0].count : 1;
        var regionContainer = document.getElementById('regionListContainer');
        regionContainer.innerHTML = '';

        sortedRegions.forEach(function(reg) {
            var percent = Math.round((reg.count / maxCount) * 100);
            var itemEl = document.createElement('div');
            itemEl.className = 'region-item';
            itemEl.innerHTML =
                '<div class="region-head">' +
                '  <span class="region-name">📍 ' + escapeHtml(reg.name) + '</span>' +
                '  <span class="region-count">' + reg.count + ' đơn</span>' +
                '</div>' +
                '<div class="region-progress-bg">' +
                '  <div class="region-progress-bar" style="width:' + percent + '%;"></div>' +
                '</div>';

            itemEl.addEventListener('click', function() {
                var regBounds = L.latLngBounds(reg.points);
                map.fitBounds(regBounds.pad(0.25));
            });

            regionContainer.appendChild(itemEl);
        });
    }

    // Helpers
    function extractGroupKey(addr, shopName) {
        if (shopName && shopName.trim()) {
            return shopName.trim();
        }
        if (addr && addr.trim()) {
            var parts = addr.split(',');
            if (parts.length >= 1) {
                return parts[parts.length - 1].trim();
            }
        }
        return 'Khu vực Trung tâm';
    }

    function escapeHtml(str) {
        if (!str) return '';
        var d = document.createElement('div');
        d.appendChild(document.createTextNode(str));
        return d.innerHTML;
    }
</script>
</c:if>
</body>
</html>
