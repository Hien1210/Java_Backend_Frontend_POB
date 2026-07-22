<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- BẢO MẬT: KIỂM TRA QUYỀN SUPER ADMIN --%>
<c:if test="${empty sessionScope.account || sessionScope.account.roleId != 1}">
    <c:redirect url="/dangnhap"/>
</c:if>

<!DOCTYPE html>
<html lang="vi" data-theme="dark">
<head>
    <meta charset="UTF-8">
    <title>Đối soát doanh thu Shop - Super Admin</title>
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
            --warning-light: rgba(245, 158, 11, 0.15);
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

        .mock-banner { background: var(--warning-light); border: 1px dashed var(--warning); color: var(--warning); border-radius: 8px; padding: 10px 16px; font-size: 12px; font-weight: 700; text-align: center; letter-spacing: 0.3px; }

        /* FILTER BAR */
        .filter-bar { background: var(--bg-panel); border: 1px solid var(--border-color); border-radius: 10px; padding: 18px 20px; display: flex; align-items: flex-end; gap: 18px; flex-wrap: wrap; }
        .filter-field { display: flex; flex-direction: column; gap: 6px; }
        .filter-field label { font-size: 11px; text-transform: uppercase; letter-spacing: 0.5px; color: var(--text-muted); font-weight: 700; }
        .filter-field select,
        .filter-field input[type="date"] { background: var(--bg-input); border: 1px solid var(--border-color); border-radius: 8px; padding: 9px 12px; color: var(--text-main); font-size: 13px; min-width: 180px; }
        .filter-field input[type="date"]::-webkit-calendar-picker-indicator { filter: invert(0.6); cursor: pointer; }
        .btn-filter { background: var(--primary); color: #ffffff; border: none; border-radius: 8px; padding: 10px 22px; font-size: 13px; font-weight: 700; cursor: pointer; transition: all 0.2s ease; }
        .btn-filter:hover { background: var(--primary-hover); transform: translateY(-1px); }

        /* CARDS THỐNG KÊ */
        .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); gap: 20px; }
        .stat-card { background: var(--bg-panel); border: 1px solid var(--border-color); border-radius: 8px; padding: 20px; display: flex; flex-direction: column; border-top: 3px solid var(--border-color); transition: all 0.2s ease;}
        .stat-card:hover { transform: translateY(-3px); box-shadow: 0 6px 14px rgba(0,0,0,0.15); }
        .stat-card.gross { border-top-color: var(--info); }
        .stat-card.fee { border-top-color: var(--warning); }
        .stat-card.payout { border-top-color: var(--primary); }
        .stat-title { font-size: 12px; text-transform: uppercase; color: var(--text-muted); margin-bottom: 10px; font-weight: bold; }
        .stat-value { font-size: 28px; font-weight: bold; color: var(--text-main); }
        .stat-hint { font-size: 11px; color: var(--text-dim); margin-top: 6px; }

        /* PANEL / TABLE */
        .panel { background: var(--bg-panel); border: 1px solid var(--border-color); border-radius: 10px; animation: fadeUp 0.35s ease both; padding: 20px; }
        .panel-title { color: var(--warning); font-size: 14px; font-weight: bold; margin-bottom: 20px; text-transform: uppercase; border-left: 4px solid var(--warning); padding-left: 10px; }
        @keyframes fadeUp {
            from { opacity: 0; transform: translateY(16px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        .table-wrapper { overflow-x: auto; }
        table.recon-table { width: 100%; border-collapse: collapse; font-size: 13px; min-width: 900px; }
        table.recon-table thead th { text-align: left; color: var(--text-muted); font-size: 11px; text-transform: uppercase; letter-spacing: 0.5px; padding: 10px 14px; border-bottom: 1px solid var(--border-color); white-space: nowrap; }
        table.recon-table thead th.num { text-align: right; }
        table.recon-table tbody td { padding: 14px; border-bottom: 1px solid var(--border-color); color: var(--text-main); vertical-align: middle; }
        table.recon-table tbody td.num { text-align: right; font-variant-numeric: tabular-nums; }
        table.recon-table tbody tr:last-child td { border-bottom: none; }
        table.recon-table tbody tr:hover { background: var(--bg-input); }
        .shop-name-cell { display: flex; align-items: center; gap: 10px; }
        .shop-avatar { width: 32px; height: 32px; border-radius: 8px; background: linear-gradient(135deg, var(--info), var(--purple)); color: #fff; display: flex; align-items: center; justify-content: center; font-weight: 700; font-size: 12px; flex-shrink: 0; }
        .shop-name { font-weight: 600; }

        .status-pill { display: inline-flex; align-items: center; gap: 6px; padding: 5px 12px; border-radius: 999px; font-size: 11px; font-weight: 700; white-space: nowrap; }
        .status-pill.paid { background: var(--primary-light); color: var(--primary); }
        .status-pill.pending { background: var(--warning-light); color: var(--warning); }
        .status-pill .dot { width: 6px; height: 6px; border-radius: 50%; background: currentColor; }

        .btn-confirm-pay { background: var(--primary); color: #fff; border: none; border-radius: 6px; padding: 7px 14px; font-size: 12px; font-weight: 700; cursor: pointer; transition: all 0.2s ease; white-space: nowrap; }
        .btn-confirm-pay:hover { background: var(--primary-hover); transform: translateY(-1px); }
        .btn-confirm-pay:disabled { background: var(--border-color); color: var(--text-dim); cursor: not-allowed; transform: none; }

        .table-footer-note { font-size: 11px; color: var(--text-dim); margin-top: 14px; }

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
                <li class="menu-item"><span class="menu-item-label-group"><span class="menu-icon">📈</span><span class="menu-label">Báo cáo vận hành</span></span></li>
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
                <li class="menu-item active"><span class="menu-item-label-group"><span class="menu-icon">💵</span><span class="menu-label">Đối soát doanh thu Shop</span></span></li>
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
            <h1>ĐỐI SOÁT DOANH THU SHOP</h1>
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
            <!-- BỘ LỌC -->
            <form class="filter-bar" method="get" action="${pageContext.request.contextPath}/admin/doi-soat-doanh-thu-shop">
                <div class="filter-field">
                    <label for="shopFilter">Cửa hàng</label>
                    <select id="shopFilter" name="shopId">
                        <option value="all" ${shopIdFilter == 'all' ? 'selected' : ''}>Tất cả cửa hàng</option>
                        <c:forEach var="shop" items="${danhSachShop}">
                            <option value="${shop.id}" ${shopIdFilter ne 'all' and shopIdFilter == shop.id ? 'selected' : ''}>${shop.shopName}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="filter-field">
                    <label for="tuNgay">Từ ngày</label>
                    <input type="date" id="tuNgay" name="tuNgay" value="${tuNgay}">
                </div>
                <div class="filter-field">
                    <label for="denNgay">Đến ngày</label>
                    <input type="date" id="denNgay" name="denNgay" value="${denNgay}">
                </div>
                <button type="submit" class="btn-filter">🔍 Lọc đối soát</button>
            </form>

            <!-- KHỐI 3 CARD SỐ LIỆU -->
            <div class="stats-grid">
                <div class="stat-card gross">
                    <span class="stat-title">Tổng doanh thu toàn sàn</span>
                    <span class="stat-value" style="color: var(--info);"><fmt:formatNumber value="${tongDoanhThu}" type="number" groupingUsed="true"/>₫</span>
                    <span class="stat-hint">Gross Revenue • Từ <fmt:parseDate value="${tuNgay}" pattern="yyyy-MM-dd" var="tuNgayDate"/><fmt:formatDate value="${tuNgayDate}" pattern="dd/MM/yyyy"/> đến <fmt:parseDate value="${denNgay}" pattern="yyyy-MM-dd" var="denNgayDate"/><fmt:formatDate value="${denNgayDate}" pattern="dd/MM/yyyy"/></span>
                </div>
                <div class="stat-card fee">
                    <span class="stat-title">Chiết khấu sàn thu về (10%)</span>
                    <span class="stat-value" style="color: var(--warning);"><fmt:formatNumber value="${tongPhiSan}" type="number" groupingUsed="true"/>₫</span>
                    <span class="stat-hint">Tổng phí nền tảng thu trên các đơn thành công</span>
                </div>
                <div class="stat-card payout">
                    <span class="stat-title">Tổng tiền cần thanh toán cho Shop</span>
                    <span class="stat-value" style="color: var(--primary);"><fmt:formatNumber value="${tongNetPayout}" type="number" groupingUsed="true"/>₫</span>
                    <span class="stat-hint">Net Payout • ${soShopChoThanhToan}/${danhSachDoiSoat.size()} Shop chờ thanh toán</span>
                </div>
            </div>

            <!-- BẢNG ĐỐI SOÁT THEO SHOP -->
            <div class="panel">
                <div class="panel-title">■ CHI TIẾT ĐỐI SOÁT THEO TỪNG SHOP</div>
                <div class="table-wrapper">
                    <table class="recon-table">
                        <thead>
                            <tr>
                                <th>Tên Shop</th>
                                <th class="num">Số đơn thành công</th>
                                <th class="num">Tổng doanh thu</th>
                                <th class="num">Phí sàn (10%)</th>
                                <th class="num">Số tiền thực nhận</th>
                                <th>Trạng thái</th>
                                <th></th>
                            </tr>
                        </thead>
                        <tbody id="reconTableBody">
                            <c:forEach var="item" items="${danhSachDoiSoat}">
                                <tr data-shop-id="${item.shopId}">
                                    <td>
                                        <div class="shop-name-cell">
                                            <div class="shop-avatar">${fn:toUpperCase(fn:substring(item.shopName, 0, 2))}</div>
                                            <span class="shop-name">${item.shopName}</span>
                                        </div>
                                    </td>
                                    <td class="num">${item.soDonThanhCong}</td>
                                    <td class="num"><fmt:formatNumber value="${item.tongDoanhThu}" type="number" groupingUsed="true"/>₫</td>
                                    <td class="num" style="color: var(--warning);"><fmt:formatNumber value="${item.phiSan}" type="number" groupingUsed="true"/>₫</td>
                                    <td class="num" style="color: var(--primary); font-weight: 700;"><fmt:formatNumber value="${item.soTienThucNhan}" type="number" groupingUsed="true"/>₫</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${item.daThanhToan}">
                                                <span class="status-pill paid"><span class="dot"></span>Đã thanh toán</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="status-pill pending"><span class="dot"></span>Chờ thanh toán</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <button type="button" class="btn-confirm-pay"
                                                ${item.daThanhToan || item.soDonThanhCong == 0 ? 'disabled' : ''}>
                                            ${item.daThanhToan ? '✔ Đã chi' : '💸 Xác nhận thanh toán'}
                                        </button>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                    <c:if test="${empty danhSachDoiSoat}">
                        <div class="table-footer-note">Không có Shop nào trong hệ thống.</div>
                    </c:if>
                </div>
                <div class="table-footer-note">
                    * Số liệu được tính trực tiếp từ các đơn hàng có trạng thái "Hoàn thành" (DONE) trong khoảng thời gian đã chọn.
                </div>
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

        /* ===================== XÁC NHẬN THANH TOÁN CHO SHOP (AJAX) ===================== */
        (function () {
            const tbody = document.getElementById('reconTableBody');
            const contextPath = '${pageContext.request.contextPath}';
            const tuNgay = document.getElementById('tuNgay').value;
            const denNgay = document.getElementById('denNgay').value;

            tbody.addEventListener('click', function (e) {
                const btn = e.target.closest('.btn-confirm-pay');
                if (!btn || btn.disabled) return;

                const row = btn.closest('tr');
                const shopId = row.getAttribute('data-shop-id');

                if (!confirm('Xác nhận đã thanh toán khoản đối soát này cho Shop?')) return;

                btn.disabled = true;
                const oldText = btn.textContent;
                btn.textContent = 'Đang xử lý...';

                const params = new URLSearchParams();
                params.set('shopId', shopId);
                params.set('tuNgay', tuNgay);
                params.set('denNgay', denNgay);

                fetch(contextPath + '/admin/doi-soat-doanh-thu-shop', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: params.toString()
                })
                    .then(function (res) { return res.json().then(function (data) { return { ok: res.ok, data: data }; }); })
                    .then(function (result) {
                        if (result.ok && result.data.success) {
                            const statusCell = row.querySelector('.status-pill').parentElement;
                            statusCell.innerHTML = '<span class="status-pill paid"><span class="dot"></span>Đã thanh toán</span>';
                            btn.textContent = '✔ Đã chi';
                            btn.disabled = true;
                        } else {
                            alert(result.data.message || 'Xác nhận thanh toán thất bại.');
                            btn.textContent = oldText;
                            btn.disabled = false;
                        }
                    })
                    .catch(function () {
                        alert('Lỗi kết nối đến máy chủ. Vui lòng thử lại.');
                        btn.textContent = oldText;
                        btn.disabled = false;
                    });
            });
        })();
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
</body>
</html>
