<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="/app-functions" prefix="app" %>

<%-- BẢO MẬT: KIỂM TRA QUYỀN SUPER ADMIN --%>
<c:if test="${empty sessionScope.account || sessionScope.account.roleId != 1}">
    <c:redirect url="/dangnhap"/>
</c:if>

<!DOCTYPE html>
<html lang="vi" data-theme="dark">
<head>
    <meta charset="UTF-8">
    <title>Báo cáo vận hành - Super Admin</title>
    <style>
        /* ================= BIẾN THEME (DARK/LIGHT) ================= */
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
            --shadow-sm: 0 1px 2px 0 rgb(0 0 0 / 0.05);
            --shadow-md: 0 4px 6px -1px rgb(0 0 0 / 0.1);
        }

        :root[data-theme="light"] {
            --bg-base: #f1f5f9;
            --bg-sidebar: #ffffff;
            --bg-panel: #ffffff;
            --bg-input: #f8fafc;
            --bg-hover: #f1f5f9;
            --text-main: #0f172a;
            --text-muted: #64748b;
            --text-dim: #94a3b8;
            --border-color: #e2e8f0;
            --topbar-bg: rgba(255, 255, 255, 0.8);
            --shadow-sm: 0 1px 3px 0 rgba(0,0,0,0.1);
            --shadow-md: 0 4px 6px -1px rgba(0,0,0,0.05);
        }

        :root {
            --primary: #10b981;
            --primary-hover: #059669;
            --primary-light: rgba(16, 185, 129, 0.15);
            --warning: #f59e0b;
            --danger: #ef4444;
            --danger-light: rgba(239, 68, 68, 0.1);
            --info: #3b82f6;
            --purple: #8b5cf6;
            --font-family: system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
        }

        * { box-sizing: border-box; margin: 0; padding: 0; font-family: var(--font-family); transition: background-color 0.3s ease, border-color 0.3s ease, color 0.3s ease; }
        body { background-color: var(--bg-base); color: var(--text-muted); display: flex; height: 100vh; overflow: hidden; }
        a { text-decoration: none; color: inherit; }
        ul { list-style: none; }

        /* SIDEBAR */
        .sidebar { width: 260px; background-color: var(--bg-sidebar); border-right: 1px solid var(--border-color); display: flex; flex-direction: column; flex-shrink: 0; box-shadow: var(--shadow-sm); z-index: 10; transition: width 0.3s ease; overflow: hidden; }
        .brand { padding: 24px; display: flex; align-items: center; gap: 12px; border-bottom: 1px solid var(--border-color); transition: padding 0.3s ease; }
        .logo { background: linear-gradient(135deg, var(--primary), #3b82f6); color: #fff; width: 36px; height: 36px; border-radius: 10px; display: flex; align-items: center; justify-content: center; font-weight: 800; font-size: 18px; box-shadow: 0 4px 12px rgba(16, 185, 129, 0.3); flex-shrink: 0; }
        .brand-text { display: flex; flex-direction: column; }
        .brand-title { color: var(--text-main); font-weight: 700; font-size: 15px; letter-spacing: 0.5px; }
        .badge-system { background: var(--primary-light); color: var(--primary); font-size: 10px; padding: 3px 6px; border-radius: 4px; border: 1px solid var(--primary); margin-left: auto; }

        .sidebar-toggle-btn { background: var(--bg-input); border: 1px solid var(--border-color); width: 30px; height: 30px; border-radius: 6px; display: flex; align-items: center; justify-content: center; color: var(--text-main); cursor: pointer; flex-shrink: 0; transition: all 0.2s ease; }
        .sidebar-toggle-btn:hover { background: var(--border-color); }

        .menu { padding: 20px 12px; flex: 1; overflow-y: auto; overflow-x: hidden; }

        .sidebar::-webkit-scrollbar,
        .menu::-webkit-scrollbar { width: 6px; }
        .sidebar::-webkit-scrollbar-track,
        .menu::-webkit-scrollbar-track { background: var(--bg-sidebar); }
        .sidebar::-webkit-scrollbar-thumb,
        .menu::-webkit-scrollbar-thumb { background: var(--border-color); border-radius: 9999px; }
        .sidebar::-webkit-scrollbar-thumb:hover,
        .menu::-webkit-scrollbar-thumb:hover { background: var(--text-dim); }
        .menu { scrollbar-width: thin; scrollbar-color: var(--border-color) var(--bg-sidebar); }
        .menu-title { font-size: 11px; color: var(--text-muted); font-weight: 700; margin: 20px 12px 8px; letter-spacing: 1px; text-transform: uppercase; white-space: nowrap; }
        .menu-item { padding: 12px 20px; display: flex; align-items: center; justify-content: space-between; color: var(--text-muted); font-size: 14px; transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1); border-radius: 8px; margin-bottom: 4px; font-weight: 500; white-space: nowrap; }
        .menu-item:hover { background-color: var(--bg-input); color: var(--text-main); transform: translateX(4px); }
        .menu-item.active { background-color: var(--primary-light); color: var(--primary); font-weight: 600; }
        .menu-item-label-group { display: flex; align-items: center; gap: 8px; overflow: hidden; }
        .badge { font-size: 10px; padding: 3px 8px; border-radius: 10px; background: var(--border-color); color: var(--text-main); flex-shrink: 0; }
        .badge.yellow { background: var(--warning); color: #0f172a; font-weight: 600; }

        .sidebar.collapsed { width: 84px; }
        .sidebar.collapsed .brand { padding: 16px 8px; }
        .sidebar.collapsed .brand > div:first-child { flex-direction: column; gap: 10px; }
        .sidebar.collapsed .brand-text,
        .sidebar.collapsed .sidebar-hi,
        .sidebar.collapsed .menu-title,
        .sidebar.collapsed .menu-label,
        .sidebar.collapsed .badge { display: none; }
        .sidebar.collapsed .menu-item { justify-content: center; padding: 12px 0; }
        .sidebar.collapsed .menu-item:hover { transform: none; }
        .sidebar.collapsed .menu-item-label-group { gap: 0; }

        /* MAIN CONTENT */
        .main { flex: 1; display: flex; flex-direction: column; overflow: hidden; transition: all 0.3s ease; }
        .topbar { background-color: var(--topbar-bg); backdrop-filter: blur(12px); -webkit-backdrop-filter: blur(12px); padding: 16px 32px; display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid var(--border-color); }
        .topbar h1 { color: var(--text-main); font-size: 20px; font-weight: 700; letter-spacing: -0.5px; }
        .topbar-right { display: flex; align-items: center; gap: 20px; }

        .theme-toggle { background: var(--bg-input); border: 1px solid var(--border-color); width: 38px; height: 38px; border-radius: 8px; cursor: pointer; display: flex; align-items: center; justify-content: center; color: var(--text-main); font-size: 16px; transition: all 0.2s ease; }
        .theme-toggle:hover { background: var(--border-color); transform: scale(1.05); }

        .content { padding: 25px 30px; overflow-y: auto; flex: 1; display: flex; flex-direction: column; gap: 25px; }

        /* FILTER BAR */
        .filter-bar { background: var(--bg-panel); border: 1px solid var(--border-color); border-radius: 10px; padding: 18px 20px; display: flex; align-items: flex-end; gap: 18px; flex-wrap: wrap; }
        .filter-field { display: flex; flex-direction: column; gap: 6px; }
        .filter-field label { font-size: 11px; text-transform: uppercase; letter-spacing: 0.5px; color: var(--text-muted); font-weight: 700; }
        .filter-field input[type="date"] { background: var(--bg-input); border: 1px solid var(--border-color); border-radius: 8px; padding: 9px 12px; color: var(--text-main); font-size: 13px; }
        .filter-field input[type="date"]::-webkit-calendar-picker-indicator { filter: invert(0.6); cursor: pointer; }
        .btn-filter { background: var(--primary); color: #ffffff; border: none; border-radius: 8px; padding: 10px 22px; font-size: 13px; font-weight: 700; cursor: pointer; transition: all 0.2s ease; }
        .btn-filter:hover { background: var(--primary-hover); transform: translateY(-1px); }

        /* CARDS THỐNG KÊ */
        .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 20px; }
        .stat-card { background: var(--bg-panel); border: 1px solid var(--border-color); border-radius: 8px; padding: 20px; display: flex; flex-direction: column; border-top: 3px solid var(--border-color); transition: all 0.2s ease;}
        .stat-card:hover { transform: translateY(-3px); box-shadow: 0 6px 14px rgba(0,0,0,0.15); }
        .stat-card:nth-child(1) { border-top-color: var(--info); }
        .stat-card:nth-child(2) { border-top-color: var(--primary); }
        .stat-card:nth-child(3) { border-top-color: var(--warning); }
        .stat-card:nth-child(4) { border-top-color: var(--purple); }
        .stat-title { font-size: 12px; text-transform: uppercase; color: var(--text-muted); margin-bottom: 10px; font-weight: bold; }
        .stat-value { font-size: 28px; font-weight: bold; color: var(--text-main); }
        .stat-hint { font-size: 11px; color: var(--text-dim); margin-top: 6px; }

        /* LAYOUT 2 CỘT THÂN DƯỚI */
        .dashboard-grid { display: grid; grid-template-columns: 1.2fr 1fr; gap: 25px; }
        @media (max-width: 1100px) { .dashboard-grid { grid-template-columns: 1fr; } }
        .chart-container { position: relative; height: 340px; }

        .panel { background: var(--bg-panel); border: 1px solid var(--border-color); border-radius: 10px; animation: fadeUp 0.35s ease both; padding: 20px; }
        .panel-title { color: var(--warning); font-size: 14px; font-weight: bold; margin-bottom: 20px; text-transform: uppercase; border-left: 4px solid var(--warning); padding-left: 10px; }
        .legend-list { display: flex; flex-direction: column; gap: 14px; margin-top: 10px; }
        .legend-row { display: flex; align-items: center; justify-content: space-between; font-size: 13px; color: var(--text-main); }
        .legend-dot { display: inline-block; width: 10px; height: 10px; border-radius: 50%; margin-right: 8px; }
        .legend-count { color: var(--text-muted); font-weight: 600; }

        @keyframes fadeUp {
            from { opacity: 0; transform: translateY(16px); }
            to   { opacity: 1; transform: translateY(0); }
        }
        /* AVATAR DROPDOWN */
        .avatar-wrapper { position: relative; }
        .avatar-btn { background: var(--warning); color: #0f172a; width: 38px; height: 38px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: 800; font-size: 13px; cursor: pointer; border: 2px solid transparent; transition: all 0.2s; user-select: none; }
        .avatar-btn:hover { border-color: var(--warning); box-shadow: 0 0 0 3px rgba(245,158,11,0.2); }
        .avatar-dropdown { display: none; position: fixed; right: auto; top: auto; background: var(--bg-panel); border: 1px solid var(--border-color); border-radius: 12px; box-shadow: 0 12px 32px rgba(0,0,0,0.3); min-width: 220px; z-index: 500; animation: fadeUp 0.2s ease both; }
        .avatar-dropdown.open { display: block; }
        .dropdown-header { padding: 14px 16px; border-bottom: 1px solid var(--border-color); }
        .dropdown-header .d-name { font-size: 14px; font-weight: 700; color: var(--text-main); }
        .dropdown-header .d-email { font-size: 12px; color: var(--text-muted); margin-top: 2px; }
        .dropdown-header .d-role { display: inline-block; margin-top: 6px; font-size: 10px; font-weight: 700; padding: 2px 8px; border-radius: 4px; background: var(--primary-light); color: var(--primary); border: 1px solid var(--primary); }
        .dropdown-body { padding: 6px 0 8px; }
        .dropdown-link { display: flex; align-items: center; gap: 10px; padding: 10px 16px; font-size: 13px; color: var(--text-muted); cursor: pointer; transition: background 0.15s; text-decoration: none; }
        .dropdown-link:hover { background: var(--bg-input); color: var(--text-main); }
        .dropdown-divider { height: 1px; background: var(--border-color); margin: 4px 0; }
        .dropdown-link.danger { color: var(--danger); }
        .dropdown-link.danger:hover { background: var(--danger-light); color: var(--danger); }
    </style>
</head>
<body>

    <aside class="sidebar" id="sidebarMain">
        <div class="brand" style="flex-direction: column; align-items: flex-start; gap: 10px;">
            <div style="display: flex; align-items: center; justify-content: space-between; gap: 12px; width: 100%;">
                <div style="display: flex; align-items: center; gap: 12px;">
                    <div class="logo">S</div>
                    <div class="brand-text">
                        <span class="brand-title">SUPER ADMIN</span>
                    </div>
                </div>
                <button type="button" class="sidebar-toggle-btn" id="sidebarToggleBtn" title="Thu gọn/Mở rộng menu">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <line x1="3" y1="6" x2="21" y2="6"></line>
                        <line x1="3" y1="12" x2="21" y2="12"></line>
                        <line x1="3" y1="18" x2="21" y2="18"></line>
                    </svg>
                </button>
            </div>
            <div class="sidebar-hi" style="font-size: 12px; color: var(--text-muted); padding-left: 2px;">
                👋 Hi, <strong style="color: var(--primary);">${sessionScope.account.userName}</strong>
            </div>
        </div>
        <ul class="menu">
            <div class="menu-title">📊 TỔNG QUAN & PHÂN TÍCH</div>
            <a href="${pageContext.request.contextPath}/tong-quan">
                <li class="menu-item"><span class="menu-item-label-group"><span class="menu-icon">⊞</span><span class="menu-label">Tổng quan hệ thống</span></span></li>
            </a>
            <a href="${pageContext.request.contextPath}/admin/bao-cao-van-hanh">
                <li class="menu-item active"><span class="menu-item-label-group"><span class="menu-icon">📈</span><span class="menu-label">Báo cáo vận hành</span></span></li>
            </a>

            <div class="menu-title">⚖️ KIỂM DUYỆT & ĐIỀU PHỐI</div>
            <a href="${pageContext.request.contextPath}/super-admin/shop-requests">
                <li class="menu-item">
                    <span class="menu-item-label-group"><span class="menu-icon">🏪</span><span class="menu-label">Duyệt Shop</span></span>
                    <c:if test="${shopChoDuyet > 0}">
                        <span class="badge yellow">${shopChoDuyet} mới</span>
                    </c:if>
                </li>
            </a>
            <a href="${pageContext.request.contextPath}/super-admin/shipper-requests">
                <li class="menu-item">
                    <span class="menu-item-label-group"><span class="menu-icon">🛵</span><span class="menu-label">Duyệt Shipper</span></span>
                    <c:if test="${not empty pendingShippers}">
                        <span class="badge yellow">${pendingShippers.size()} mới</span>
                    </c:if>
                </li>
            </a>
            <a href="${pageContext.request.contextPath}/admin/kiem-duyet-noi-dung">
                <li class="menu-item"><span class="menu-item-label-group"><span class="menu-icon">🚩</span><span class="menu-label">Kiểm duyệt nội dung</span></span></li>
            </a>
            <a href="${pageContext.request.contextPath}/admin/kiem-duyet-binh-luan">
                <li class="menu-item"><span class="menu-item-label-group"><span class="menu-icon">💬</span><span class="menu-label">Kiểm duyệt bình luận</span></span></li>
            </a>
            <a href="${pageContext.request.contextPath}/admin/appeals">
                <li class="menu-item">
                    <span class="menu-item-label-group"><span class="menu-icon">📋</span><span class="menu-label">Kháng nghị</span></span>
                    <c:if test="${pendingCount > 0}">
                        <span class="badge yellow">${pendingCount}</span>
                    </c:if>
                </li>
            </a>

            <div class="menu-title">💰 QUẢN LÝ TÀI CHÍNH</div>
            <a href="${pageContext.request.contextPath}/admin/doi-soat-doanh-thu-shop">
                <li class="menu-item"><span class="menu-item-label-group"><span class="menu-icon">💵</span><span class="menu-label">Đối soát doanh thu Shop</span></span></li>
            </a>
            <a href="${pageContext.request.contextPath}/admin/duyet-rut-tien-shipper">
                <li class="menu-item"><span class="menu-item-label-group"><span class="menu-icon">💳</span><span class="menu-label">Duyệt rút tiền Shipper</span></span></li>
            </a>

            <div class="menu-title">⚙️ CẤU HÌNH & HỆ THỐNG</div>
            <a href="${pageContext.request.contextPath}/quanlitaikhoan">
                <li class="menu-item"><span class="menu-item-label-group"><span class="menu-icon">👤</span><span class="menu-label">Người dùng</span></span></li>
            </a>
            <a href="#">
                <li class="menu-item"><span class="menu-item-label-group"><span class="menu-icon">🛠️</span><span class="menu-label">Tham số vận hành</span></span></li>
            </a>
            <a href="#">
                <li class="menu-item"><span class="menu-item-label-group"><span class="menu-icon">📢</span><span class="menu-label">Truyền thông & Banner</span></span></li>
            </a>
        </ul>
    </aside>

    <main class="main">
        <header class="topbar">
            <h1>BÁO CÁO VẬN HÀNH</h1>
            <div class="topbar-right">
                <button type="button" class="theme-toggle" id="themeToggleBtn" title="Chuyển đổi giao diện">🌓</button>
                <div class="avatar-wrapper" id="avatarWrapper">
                <div class="avatar-btn" id="avatarBtn">
                    <c:choose>
                        <c:when test="${not empty sessionScope.account.avatarUrl}">
                            <img src="${sessionScope.account.avatarUrl}" style="width:100%;height:100%;object-fit:cover;border-radius:50%;"/>
                        </c:when>
                        <c:otherwise>${fn:toUpperCase(fn:substring(sessionScope.account.userName, 0, 2))}</c:otherwise>
                    </c:choose>
                </div>
                </div>
            </div>
        </header>

        <div class="content">
            <!-- BỘ LỌC NGÀY -->
            <form class="filter-bar" method="get" action="${pageContext.request.contextPath}/admin/bao-cao-van-hanh">
                <div class="filter-field">
                    <label for="tuNgay">Từ ngày</label>
                    <input type="date" id="tuNgay" name="tuNgay" value="${tuNgay}" max="${denNgay}">
                </div>
                <div class="filter-field">
                    <label for="denNgay">Đến ngày</label>
                    <input type="date" id="denNgay" name="denNgay" value="${denNgay}" min="${tuNgay}">
                </div>
                <button type="submit" class="btn-filter">🔍 Xem báo cáo</button>
            </form>

            <!-- KHỐI THỐNG KÊ NHANH -->
            <div class="stats-grid">
                <div class="stat-card">
                    <span class="stat-title">Tổng Đơn Hàng Phát Sinh</span>
                    <span class="stat-value">${tongDonHang}</span>
                    <span class="stat-hint">Từ ${tuNgay} đến ${denNgay}</span>
                </div>
                <div class="stat-card">
                    <span class="stat-title">Tỷ Lệ Hoàn Thành Đơn</span>
                    <span class="stat-value" style="color: var(--primary);"><fmt:formatNumber value="${tyLeHoanThanh}" pattern="#,##0.0"/>%</span>
                    <span class="stat-hint">${donThanhCong} / ${tongDonHang} đơn thành công</span>
                </div>
                <div class="stat-card">
                    <span class="stat-title">Thời Gian Giao Hàng Trung Bình</span>
                    <c:choose>
                        <c:when test="${not empty thoiGianGiaoTrungBinh}">
                            <span class="stat-value" style="color: var(--warning);"><fmt:formatNumber value="${thoiGianGiaoTrungBinh}" pattern="#,##0.0"/> phút</span>
                        </c:when>
                        <c:otherwise>
                            <span class="stat-value" style="color: var(--warning);">--</span>
                        </c:otherwise>
                    </c:choose>
                    <span class="stat-hint">Từ lúc Shop xác nhận đến khi giao xong</span>
                </div>
                <div class="stat-card">
                    <span class="stat-title">Khung Giờ Đặt Hàng Cao Điểm</span>
                    <c:choose>
                        <c:when test="${not empty khungGioCaoDiem}">
                            <span class="stat-value" style="color: var(--purple);">${khungGioCaoDiem}</span>
                        </c:when>
                        <c:otherwise>
                            <span class="stat-value" style="color: var(--purple);">--</span>
                        </c:otherwise>
                    </c:choose>
                    <span class="stat-hint">Giờ có nhiều đơn phát sinh nhất</span>
                </div>
            </div>

            <!-- BIỂU ĐỒ TRẠNG THÁI ĐƠN HÀNG -->
            <div class="dashboard-grid">
                <div class="panel chart-panel">
                    <div class="panel-title">■ TỶ LỆ TRẠNG THÁI ĐƠN HÀNG</div>
                    <div class="chart-container">
                        <canvas id="orderStatusChart"></canvas>
                    </div>
                </div>

                <div class="panel">
                    <div class="panel-title">■ CHI TIẾT SỐ ĐƠN THEO TRẠNG THÁI</div>
                    <div class="legend-list">
                        <div class="legend-row">
                            <span><span class="legend-dot" style="background: #00ff9d;"></span>Thành công</span>
                            <span class="legend-count">${donThanhCong}</span>
                        </div>
                        <div class="legend-row">
                            <span><span class="legend-dot" style="background: #ff3860;"></span>Đã hủy</span>
                            <span class="legend-count">${donDaHuy}</span>
                        </div>
                        <div class="legend-row">
                            <span><span class="legend-dot" style="background: #ff9100;"></span>Đang giao</span>
                            <span class="legend-count">${donDangGiao}</span>
                        </div>
                    </div>
                    <c:if test="${tongDonHang == 0}">
                        <p style="margin-top: 16px; font-size: 12px; color: var(--text-dim);">
                            📊 Không có đơn hàng nào phát sinh trong khoảng thời gian đã chọn.
                        </p>
                    </c:if>
                </div>
            </div>

            <!-- BIỂU ĐỒ THỐNG KÊ LÝ DO HỦY ĐƠN -->
            <div class="panel">
                <div class="panel-title">■ THỐNG KÊ LÝ DO HỦY ĐƠN</div>
                <c:choose>
                    <c:when test="${not empty lyDoHuyDon}">
                        <div class="chart-container">
                            <canvas id="cancelReasonChart"></canvas>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <p style="font-size: 12px; color: var(--text-dim);">
                            📊 Không có đơn hàng nào bị hủy trong khoảng thời gian đã chọn.
                        </p>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </main>

    <script>
        (function () {
            const htmlElement = document.documentElement;
            const themeToggleBtn = document.getElementById('themeToggleBtn');
            const savedTheme = localStorage.getItem('theme') || 'dark';
            htmlElement.setAttribute('data-theme', savedTheme);

            themeToggleBtn.addEventListener('click', () => {
                const currentTheme = htmlElement.getAttribute('data-theme');
                const newTheme = currentTheme === 'dark' ? 'light' : 'dark';
                htmlElement.setAttribute('data-theme', newTheme);
                localStorage.setItem('theme', newTheme);
            });
        })();
        (function () {
            const sidebarEl = document.getElementById('sidebarMain');
            const sidebarToggleBtn = document.getElementById('sidebarToggleBtn');
            if (!sidebarEl || !sidebarToggleBtn) return;

            if (localStorage.getItem('sidebarCollapsed') === 'true') {
                sidebarEl.classList.add('collapsed');
            }

            sidebarToggleBtn.addEventListener('click', () => {
                sidebarEl.classList.toggle('collapsed');
                localStorage.setItem('sidebarCollapsed', sidebarEl.classList.contains('collapsed'));
            });
        })();
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
                avatarDropdown.addEventListener('click', function(e) {
                    e.stopPropagation();
                });
                document.addEventListener('click', function() {
                    avatarDropdown.classList.remove('open');
                });
            }
        });
    </script>
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

    <!-- BIỂU ĐỒ TRÒN TRẠNG THÁI ĐƠN HÀNG (Chart.js) -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script>
        const statusTextColor = getComputedStyle(document.documentElement).getPropertyValue('--text-muted').trim();

        new Chart(document.getElementById('orderStatusChart'), {
            type: 'doughnut',
            data: {
                labels: ['Thành công', 'Đã hủy', 'Đang giao'],
                datasets: [{
                    data: [${donThanhCong}, ${donDaHuy}, ${donDangGiao}],
                    backgroundColor: ['#00ff9d', '#ff3860', '#ff9100'],
                    borderColor: getComputedStyle(document.documentElement).getPropertyValue('--bg-panel').trim(),
                    borderWidth: 3,
                    hoverOffset: 8
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                cutout: '65%',
                plugins: {
                    legend: { position: 'bottom', labels: { color: statusTextColor, padding: 16 } },
                    tooltip: { backgroundColor: '#1e293b', borderColor: '#334155', borderWidth: 1 }
                }
            }
        });
    </script>

    <!-- BIỂU ĐỒ CỘT LÝ DO HỦY ĐƠN (Chart.js) -->
    <c:if test="${not empty lyDoHuyDon}">
        <script>
            (function () {
                const cancelReasonLabels = [];
                const cancelReasonCounts = [];
                <c:forEach var="entry" items="${lyDoHuyDon}">
                cancelReasonLabels.push("${fn:escapeXml(entry.key)}");
                cancelReasonCounts.push(${entry.value});
                </c:forEach>

                const axisTextColor = getComputedStyle(document.documentElement).getPropertyValue('--text-muted').trim();
                const gridColor = getComputedStyle(document.documentElement).getPropertyValue('--border-color').trim();

                new Chart(document.getElementById('cancelReasonChart'), {
                    type: 'bar',
                    data: {
                        labels: cancelReasonLabels,
                        datasets: [{
                            label: 'Số đơn hủy',
                            data: cancelReasonCounts,
                            backgroundColor: '#ff3860',
                            borderRadius: 6,
                            maxBarThickness: 48
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: {
                            legend: { display: false },
                            tooltip: { backgroundColor: '#1e293b', borderColor: '#334155', borderWidth: 1 }
                        },
                        scales: {
                            x: { ticks: { color: axisTextColor }, grid: { color: gridColor } },
                            y: { beginAtZero: true, ticks: { color: axisTextColor, precision: 0 }, grid: { color: gridColor } }
                        }
                    }
                });
            })();
        </script>
    </c:if>
</body>
</html>
