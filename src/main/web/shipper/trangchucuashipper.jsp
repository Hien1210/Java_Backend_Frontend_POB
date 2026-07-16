<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="/app-functions" prefix="app" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <script>!function(){var t=localStorage.getItem("shipper-theme")||"light";document.documentElement.setAttribute("data-theme",t)}()</script>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tài xế công nghệ - POB Shipper</title>
    <style>
        /* ================= CẤU HÌNH BIẾN THEME (GREEN & ORANGE) ================= */
        :root[data-theme="dark"] {
            --bg-base: #0f172a;
            --bg-card: #1e293b;
            --bg-input: #0f172a;
            --text-main: #f8fafc;
            --text-muted: #94a3b8;
            --border-color: #334155;
            --topbar-bg: rgba(30, 41, 59, 0.8);
            --shadow: 0 4px 6px -1px rgb(0 0 0 / 0.2);
        }

        :root[data-theme="light"] {
            --bg-base: #f4f7f5;
            --bg-card: #ffffff;
            --bg-input: #f8fafc;
            --text-main: #1e293b;
            --text-muted: #64748b;
            --border-color: #e2e8f0;
            --topbar-bg: rgba(255, 255, 255, 0.85);
            --shadow: 0 4px 12px rgba(0, 0, 0, 0.03);
        }

        :root {
            --primary: #4CAF50;         /* Xanh lá - Trạng thái hoạt động/Thành công */
            --primary-hover: #43a047;
            --primary-light: rgba(76, 175, 80, 0.12);
            --secondary: #FF9800;       /* Cam - Cảnh báo/Đơn hàng mới */
            --secondary-hover: #f57c00;
            --secondary-light: rgba(255, 152, 0, 0.12);
            --danger: #ef4444;
            --font-family: system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
        }

        /* ================= CORE RESET ================= */
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: var(--font-family); transition: background-color 0.25s, border-color 0.25s; }
        body { background-color: var(--bg-base); color: var(--text-main); display: flex; height: 100vh; overflow: hidden; }
        a { text-decoration: none; color: inherit; }

        /* ================= SIDEBAR ================= */
        .sidebar { width: 260px; background-color: var(--bg-card); border-right: 1px solid var(--border-color); display: flex; flex-direction: column; flex-shrink: 0; z-index: 10; }
        .brand { padding: 24px; display: flex; align-items: center; gap: 12px; border-bottom: 1px solid var(--border-color); }
        .logo { background: linear-gradient(135deg, var(--primary), #2e7d32); color: #fff; width: 38px; height: 38px; border-radius: 10px; display: flex; align-items: center; justify-content: center; font-weight: 800; font-size: 18px; box-shadow: 0 4px 10px rgba(76, 175, 80, 0.3); }
        .brand-title { font-weight: 700; font-size: 16px; letter-spacing: 0.5px; }
        .menu { padding: 20px 12px; flex: 1; }
        .menu-item { padding: 14px 16px; display: flex; align-items: center; gap: 12px; color: var(--text-muted); font-size: 14px; font-weight: 600; border-radius: 8px; margin-bottom: 6px; }
        .menu-item:hover { background-color: var(--bg-input); color: var(--text-main); transform: translateX(4px); }
        .menu-item.active { background-color: var(--primary-light); color: var(--primary); }

        /* ================= MAIN LAYOUT ================= */
        .main { flex: 1; display: flex; flex-direction: column; overflow: hidden; }
        .topbar { background-color: var(--topbar-bg); backdrop-filter: blur(10px); -webkit-backdrop-filter: blur(10px); padding: 16px 32px; display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid var(--border-color); }
        .topbar h1 { font-size: 18px; font-weight: 700; display: flex; align-items: center; gap: 8px; }
        .topbar-right { display: flex; align-items: center; gap: 16px; }

        .theme-toggle { background: var(--bg-input); border: 1px solid var(--border-color); width: 38px; height: 38px; border-radius: 8px; cursor: pointer; display: flex; align-items: center; justify-content: center; font-size: 16px; }
        .avatar-circle { background: var(--primary); color: white; width: 38px; height: 38px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: 700; }
        .btn-logout { padding: 8px 16px; border-radius: 8px; background: rgba(239, 68, 68, 0.1); color: var(--danger); font-size: 13px; font-weight: 600; }
        .btn-logout:hover { background: var(--danger); color: white; }

        /* ================= CONTAINER CONTENT ================= */
        .content { padding: 24px 32px; overflow-y: auto; flex: 1; display: flex; flex-direction: column; gap: 24px; animation: fuyIn 0.3s ease-out; }

        /* Thống kê nhanh ngoài trời */
        .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 16px; }
        .stat-card { background: var(--bg-card); border: 1px solid var(--border-color); border-radius: 12px; padding: 20px; box-shadow: var(--shadow); display: flex; justify-content: space-between; align-items: center; }
        .stat-num { font-size: 24px; font-weight: 700; margin-top: 4px; }
        .stat-label { font-size: 12px; color: var(--text-muted); font-weight: 600; text-transform: uppercase; }
        .stat-icon { width: 44px; height: 44px; border-radius: 10px; display: flex; align-items: center; justify-content: center; font-size: 20px; }

        /* ================= TABS ĐƠN HÀNG ================= */
        .tabs-header { display: flex; gap: 8px; border-bottom: 1px solid var(--border-color); padding-bottom: 8px; }
        .tab-btn { padding: 10px 20px; border: none; background: transparent; color: var(--text-muted); font-weight: 700; font-size: 14px; cursor: pointer; position: relative; }
        .tab-btn.active { color: var(--primary); }
        .tab-btn.active::after { content: ''; position: absolute; bottom: -10px; left: 0; width: 100%; height: 3px; background: var(--primary); border-radius: 2px; }

        /* Đơn hàng cards (Tối ưu hiển thị nhanh chân thực) */
        .order-list { display: flex; flex-direction: column; gap: 14px; }
        .order-card { background: var(--bg-card); border: 1px solid var(--border-color); border-radius: 12px; padding: 20px; box-shadow: var(--shadow); position: relative; overflow: hidden; }
        .order-card::before { content: ''; position: absolute; top: 0; left: 0; width: 4px; height: 100%; background: var(--secondary); }
        .order-card.status-shipping::before { background: var(--primary); }
        .order-card.status-done::before { background: #94a3b8; }
        .order-card.status-done { opacity: 0.75; }
        .badge-done { background: rgba(34,197,94,0.1); color: #16a34a; }

        .order-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px; }
        .order-id { font-weight: 700; font-size: 15px; color: var(--text-main); }
        .order-time { font-size: 12px; color: var(--text-muted); }

        /* Tuyến đường giao hàng dạng Timeline */
        .route-timeline { position: relative; padding-left: 24px; margin-bottom: 16px; }
        .route-step { position: relative; margin-bottom: 12px; font-size: 13px; }
        .route-step:last-child { margin-bottom: 0; }
        .route-step::before { content: '•'; position: absolute; left: -18px; top: -2px; font-size: 18px; color: var(--secondary); }
        .route-step.dropoff::before { color: var(--primary); }
        .route-label { font-size: 11px; color: var(--text-muted); font-weight: 600; text-transform: uppercase; }
        .route-text { font-weight: 600; margin-top: 2px; color: var(--text-main); }

        .price-tag { font-size: 16px; font-weight: 700; color: var(--primary); display: flex; align-items: center; gap: 4px; }
        .badge-status { padding: 4px 8px; border-radius: 6px; font-size: 11px; font-weight: 700; text-transform: uppercase; }
        .badge-pending { background: var(--secondary-light); color: var(--secondary); }
        .badge-shipping { background: var(--primary-light); color: var(--primary); }
        .badge-cancelled { background: rgba(239,68,68,0.1); color: #ef4444; }

        /* Nút tương tác nhanh */
        .btn-flex-group { display: flex; gap: 8px; justify-content: flex-end; align-items: center; margin-top: 12px; }
        .btn-action { padding: 10px 18px; border-radius: 8px; font-size: 13px; font-weight: 700; border: none; cursor: pointer; }
        .btn-action-primary { background: var(--primary); color: white; box-shadow: 0 4px 10px rgba(76, 175, 80, 0.2); }
        .btn-action-primary:hover { background: var(--primary-hover); }
        .btn-action-warning { background: var(--secondary); color: white; box-shadow: 0 4px 10px rgba(255, 152, 0, 0.2); }
        .btn-action-warning:hover { background: var(--secondary-hover); }
        .btn-action-outline { background: transparent; border: 1px solid var(--border-color); color: var(--text-main); }
        .btn-action-outline:hover { background: var(--bg-input); }

        /* ================= POPUP MODAL DIALOG DETAILED ================= */
        .modal-backdrop { position: fixed; top: 0; left: 0; width: 100vw; height: 100vh; background: rgba(15, 23, 42, 0.6); backdrop-filter: blur(4px); display: flex; align-items: center; justify-content: center; z-index: 100; opacity: 0; pointer-events: none; transition: all 0.25s; }
        .modal-backdrop.active { opacity: 1; pointer-events: auto; }
        .modal-content { background: var(--bg-card); border: 1px solid var(--border-color); border-radius: 16px; width: 500px; max-width: 92%; max-height: 85vh; overflow-y: auto; box-shadow: 0 20px 25px -5px rgb(0 0 0 / 0.3); transform: scale(0.95); transition: all 0.25s; }
        .modal-backdrop.active .modal-content { transform: scale(1); }
        .modal-header { padding: 18px 24px; border-bottom: 1px solid var(--border-color); display: flex; justify-content: space-between; align-items: center; }
        .modal-close { background: transparent; border: none; color: var(--text-muted); font-size: 20px; cursor: pointer; }
        .modal-body { padding: 24px; display: flex; flex-direction: column; gap: 16px; }

        @keyframes fuyIn { from { opacity: 0; transform: translateY(8px); } to { opacity: 1; transform: translateY(0); } }

        /* ================= CONFIRM POPUP ================= */
        .confirm-modal-backdrop { position: fixed; top: 0; left: 0; width: 100vw; height: 100vh; background: rgba(15,23,42,0.6); backdrop-filter: blur(4px); display: flex; align-items: center; justify-content: center; z-index: 200; opacity: 0; pointer-events: none; transition: all 0.2s; }
        .confirm-modal-backdrop.active { opacity: 1; pointer-events: auto; }
        .confirm-modal { background: var(--bg-card); border: 1px solid var(--border-color); border-radius: 16px; width: 380px; max-width: 92%; padding: 28px 24px 20px; box-shadow: 0 20px 40px rgba(0,0,0,0.35); transform: scale(0.93); transition: all 0.2s; text-align: center; }
        .confirm-modal-backdrop.active .confirm-modal { transform: scale(1); }
        .confirm-icon { font-size: 36px; margin-bottom: 12px; }
        .confirm-title { font-size: 16px; font-weight: 700; color: var(--text-main); margin-bottom: 8px; }
        .confirm-desc { font-size: 13px; color: var(--text-muted); line-height: 1.6; margin-bottom: 22px; }
        .confirm-btns { display: flex; gap: 10px; justify-content: center; }
        .confirm-btn { padding: 10px 24px; border-radius: 9px; font-size: 13px; font-weight: 700; border: none; cursor: pointer; min-width: 100px; }
        .confirm-btn-cancel { background: var(--bg-input); color: var(--text-muted); border: 1px solid var(--border-color); }
        .confirm-btn-cancel:hover { color: var(--text-main); }
        .confirm-btn-ok { background: var(--primary); color: #fff; box-shadow: 0 4px 12px rgba(76,175,80,0.25); }
        .confirm-btn-ok:hover { background: var(--primary-hover); }
        .confirm-btn-warn { background: var(--secondary); color: #fff; box-shadow: 0 4px 12px rgba(255,152,0,0.25); }
        .confirm-btn-warn:hover { background: var(--secondary-hover); }

        /* ================= TOGGLE ONLINE/OFFLINE ================= */
        .online-toggle-wrap { padding: 16px 12px; border-top: 1px solid var(--border-color); }
        .online-toggle-btn {
            width: 100%; padding: 12px 16px; border-radius: 10px; border: none; cursor: pointer;
            display: flex; align-items: center; gap: 10px; font-size: 13px; font-weight: 700;
            transition: all 0.2s; position: relative;
        }
        .online-toggle-btn.is-online {
            background: var(--primary-light); color: var(--primary);
            border: 1.5px solid var(--primary);
        }
        .online-toggle-btn.is-offline {
            background: rgba(239,68,68,0.08); color: #ef4444;
            border: 1.5px solid rgba(239,68,68,0.3);
        }
        .online-toggle-btn:hover { opacity: 0.85; }
        .toggle-dot {
            width: 10px; height: 10px; border-radius: 50%; flex-shrink: 0;
        }
        .toggle-dot.online { background: var(--primary); box-shadow: 0 0 0 3px rgba(76,175,80,0.25); animation: pulse-green 1.5s infinite; }
        .toggle-dot.offline { background: #ef4444; }
        @keyframes pulse-green { 0%,100%{box-shadow:0 0 0 3px rgba(76,175,80,0.25);} 50%{box-shadow:0 0 0 6px rgba(76,175,80,0.1);} }

        /* Badge trạng thái online trên topbar */
        .online-badge {
            display: inline-flex; align-items: center; gap: 6px;
            padding: 5px 12px; border-radius: 20px; font-size: 12px; font-weight: 700;
        }
        .online-badge.online { background: var(--primary-light); color: var(--primary); }
        .online-badge.offline { background: rgba(239,68,68,0.1); color: #ef4444; }

        /* Mobile responsive */
        @media (max-width: 768px) {
            body { flex-direction: column; }
            .sidebar { width: 100%; height: auto; border-right: none; border-bottom: 1px solid var(--border-color); }
            .menu { display: flex; overflow-x: auto; padding: 10px; }
            .menu-item { margin-bottom: 0; white-space: nowrap; }
            .topbar { padding: 12px 16px; }
            .content { padding: 16px; gap: 16px; }
        }
            .avatar-btn { background: var(--primary); color: #fff; width: 38px; height: 38px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: 800; font-size: 13px; cursor: pointer; border: 2px solid transparent; transition: all 0.2s; user-select: none; overflow: hidden; }
        .avatar-btn:hover { border-color: var(--primary); box-shadow: 0 0 0 3px rgba(16,185,129,0.2); }
        .avatar-dropdown { display: none; position: fixed; background: var(--bg-card, #1e293b); border: 1px solid var(--border-color); border-radius: 12px; box-shadow: 0 12px 32px rgba(0,0,0,0.3); min-width: 220px; z-index: 9999; }
        .avatar-dropdown.open { display: block; }
        .dropdown-header { padding: 14px 16px; border-bottom: 1px solid var(--border-color); }
        .dropdown-header .d-name { font-size: 14px; font-weight: 700; color: var(--text-primary, #f8fafc); }
        .dropdown-header .d-email { font-size: 12px; color: var(--text-secondary, #94a3b8); margin-top: 2px; }
        .dropdown-header .d-role { display: inline-block; margin-top: 6px; font-size: 10px; font-weight: 700; padding: 2px 8px; border-radius: 4px; background: rgba(16,185,129,0.15); color: var(--primary); border: 1px solid var(--primary); }
        .dropdown-body { padding: 6px 0 8px; }
        .dropdown-link { display: flex; align-items: center; gap: 10px; padding: 10px 16px; font-size: 13px; color: var(--text-secondary, #94a3b8); transition: background 0.15s; text-decoration: none; }
        .dropdown-link:hover { background: rgba(255,255,255,0.05); color: var(--text-primary, #f8fafc); }
        .dropdown-divider { height: 1px; background: var(--border-color); margin: 4px 0; }
        .dropdown-link.danger { color: var(--danger, #ef4444); }
        .dropdown-link.danger:hover { background: rgba(239,68,68,0.1); }</style>
</head>
<body>

    <aside class="sidebar">
        <div class="brand">
            <div class="logo">🛵</div>
            <div class="brand-text">
                <span class="brand-title">POB SHIPPER</span>
                <c:choose>
                    <c:when test="${sessionScope.account.online}">
                        <div style="font-size: 10px; color: var(--primary); font-weight: bold;">● ĐANG HOẠT ĐỘNG</div>
                    </c:when>
                    <c:otherwise>
                        <div style="font-size: 10px; color: #ef4444; font-weight: bold;">● NGOẠI TUYẾN</div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
        <ul class="menu">
            <a href="${pageContext.request.contextPath}/shipper/donhang">
                <li class="menu-item active"><span>📋 Đơn hàng nhận</span></li>
            </a>
            <a href="${pageContext.request.contextPath}/shipper/nhan-don">
                <li class="menu-item"><span>📥 Nhận đơn mới</span></li>
            </a>
            <a href="${pageContext.request.contextPath}/shipper/dashboard">
                <li class="menu-item"><span>📊 Dashboard</span></li>
            </a>
            <a href="${pageContext.request.contextPath}/shipper/thongbao">
                <li class="menu-item"><span>🔔 Thông báo</span></li>
            </a>
            <a href="${pageContext.request.contextPath}/shipper/profile">
                <li class="menu-item"><span>👤 Hồ sơ tài xế</span></li>
            </a>
            <a href="${pageContext.request.contextPath}/shipper/danh-gia">
                <li class="menu-item"><span>⭐ Đánh giá & Báo cáo</span></li>
            </a>
        </ul>

        <%-- Nút bật/tắt Online/Offline ở cuối sidebar --%>
        <div class="online-toggle-wrap">
            <form id="onlineToggleForm" action="${pageContext.request.contextPath}/shipper/status" method="post">
                <c:choose>
                    <c:when test="${sessionScope.account.online}">
                        <button type="button" class="online-toggle-btn is-online"
                                onclick="openConfirm('confirmOfflineModal')">
                            <span class="toggle-dot online"></span>
                            Đang Online — Nhấn để Offline
                        </button>
                    </c:when>
                    <c:otherwise>
                        <button type="submit" class="online-toggle-btn is-offline">
                            <span class="toggle-dot offline"></span>
                            Đang Offline — Nhấn để Online
                        </button>
                    </c:otherwise>
                </c:choose>
            </form>
        </div>
    </aside>

    <main class="main">
        <header class="topbar">
            <h1>
                Hệ thống điều phối giao hàng
                <c:choose>
                    <c:when test="${sessionScope.account.online}">
                        <span class="online-badge online">● Online</span>
                    </c:when>
                    <c:otherwise>
                        <span class="online-badge offline">● Offline</span>
                    </c:otherwise>
                </c:choose>
            </h1>
            <div class="topbar-right">
                <button type="button" class="theme-toggle" id="themeToggleBtn">🌓</button>
                <div class="avatar-btn" id="avatarBtn"><c:choose><c:when test="${not empty sessionScope.account.avatarUrl}"><img src="${sessionScope.account.avatarUrl}" style="width:100%;height:100%;object-fit:cover;border-radius:50%;"/></c:when><c:otherwise>${fn:toUpperCase(fn:substring(sessionScope.account.userName,0,2))}</c:otherwise></c:choose></div>
            </div>
        </header>

        <div class="content">
            <div class="stats-grid">
                <div class="stat-card">
                    <div>
                        <div class="stat-label">Hoàn thành hôm nay</div>
                        <div class="stat-num">${donHoanThanhHomNay} đơn</div>
                    </div>
                    <div class="stat-icon" style="background: var(--primary-light); color: var(--primary);">✓</div>
                </div>
                <div class="stat-card">
                    <div>
                        <div class="stat-label">Thu nhập hôm nay</div>
                        <div class="stat-num" style="color: var(--primary);">
                            <fmt:formatNumber value="${thuNhapHomNay}" type="number" maxFractionDigits="0"/>đ
                        </div>
                    </div>
                    <div class="stat-icon" style="background: rgba(76,175,80,0.15); color: var(--primary);">💵</div>
                </div>
                <div class="stat-card">
                    <div>
                        <div class="stat-label">Chờ lấy hàng</div>
                        <div class="stat-num" style="color: var(--secondary);">${donChoLayHang} đơn</div>
                    </div>
                    <div class="stat-icon" style="background: var(--secondary-light); color: var(--secondary);">📦</div>
                </div>
                <div class="stat-card">
                    <div>
                        <div class="stat-label">Đang giao</div>
                        <div class="stat-num" style="color: var(--primary);">${donDangGiao} đơn</div>
                    </div>
                    <div class="stat-icon" style="background: var(--primary-light); color: var(--primary);">🛵</div>
                </div>
            </div>

            <div style="display:flex; align-items:center; justify-content:space-between; flex-wrap:wrap; gap:10px;">
                <div class="tabs-header" style="border-bottom:none; padding-bottom:0;">
                    <button class="tab-btn active" onclick="filterOrders('ALL', this)">Tất cả đơn</button>
                    <button class="tab-btn" onclick="filterOrders('READY_FOR_PICKUP', this)">Chờ lấy hàng 🟠</button>
                    <button class="tab-btn" onclick="filterOrders('SHIPPING', this)">Đang giao 🟢</button>
                    <button class="tab-btn" onclick="filterOrders('HISTORY', this)">Lịch sử 📜</button>
                </div>
                <div style="display:flex; align-items:center; gap:8px;">
                    <span style="font-size:12px; font-weight:700; color:var(--text-muted);">Hình thức TT:</span>
                    <select id="paymentFilter" onchange="applyFilters()"
                            style="padding:7px 12px; border-radius:8px; border:1px solid var(--border-color);
                                   background:var(--bg-input); color:var(--text-main); font-size:13px; font-weight:600; cursor:pointer;">
                        <option value="ALL">Tất cả</option>
                        <option value="COD">💵 Tiền mặt (COD)</option>
                        <option value="BANK">📱 QR Chuyển khoản</option>
                        <option value="PAYOS">🏦 PayOS</option>
                    </select>
                </div>
            </div>
            <div style="height:1px; background:var(--border-color); margin-top:4px;"></div>

            <div class="order-list">
                <c:forEach var="order" items="${danhSachDonHang}">
                    <div class="order-card ${order.status == 'SHIPPING' ? 'status-shipping' : ''} ${order.status == 'DONE' ? 'status-done' : ''}"
                         data-status="${order.status}"
                         data-payment="${empty order.paymentMethod ? 'COD' : order.paymentMethod}">
                        <div class="order-header">
                            <span class="order-id">Mã đơn: #<c:out value="${order.id}"/></span>
                            <span class="order-time">🕒 ${app:formatDateTime(order.createdAt)}</span>
                        </div>

                        <div class="route-timeline">
                            <div class="route-step pickup">
                                <div class="route-label">Lấy hàng tại (Shop):</div>
                                <div class="route-text"><c:out value="${order.shopName}"/> - <c:out value="${order.shopAddress}"/></div>
                                <div style="font-size:11px; color: var(--text-muted);">📞 Cửa hàng: <c:out value="${order.shopPhone}"/></div>
                            </div>
                            <div class="route-step dropoff">
                                <div class="route-label">Giao hàng tới (Khách):</div>
                                <div class="route-text"><c:out value="${order.shippingAddress}"/></div>
                                <div style="font-size:11px; color: var(--text-muted);">👤 Người nhận: <c:out value="${order.receiverName}"/> - <c:out value="${order.receiverPhone}"/></div>
                            </div>
                        </div>

                        <div style="display: flex; justify-content: space-between; align-items: center; border-top: 1px dashed var(--border-color); padding-top: 12px;">
                            <div>
                                <div style="font-size: 11px; color: var(--text-muted); font-weight:600;">HÌNH THỨC THANH TOÁN</div>
                                <div style="font-size: 13px; font-weight:700; color: var(--secondary);">
                                    <c:choose>
                                        <c:when test="${order.paymentMethod == 'PAYOS'}">🏦 PayOS</c:when>
                                        <c:when test="${order.paymentMethod == 'BANK'}">📱 QR Chuyển khoản</c:when>
                                        <c:otherwise>💵 Tiền mặt (COD)</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div style="text-align: right;">
                                <span class="badge-status ${order.status == 'SHIPPING' ? 'badge-shipping' : order.status == 'DONE' ? 'badge-done' : order.status == 'CANCELLED' ? 'badge-cancelled' : 'badge-pending'}">
                                    <c:choose>
                                        <c:when test="${order.status == 'READY_FOR_PICKUP'}">📦 Chờ lấy hàng</c:when>
                                        <c:when test="${order.status == 'SHIPPING'}">🛵 Đang giao hàng</c:when>
                                        <c:when test="${order.status == 'DONE'}">✅ Đã giao xong</c:when>
                                        <c:when test="${order.status == 'CANCELLED'}">🚫 Đã huỷ (bom hàng)</c:when>
                                        <c:otherwise><c:out value="${order.status}"/></c:otherwise>
                                    </c:choose>
                                </span>
                                <div class="price-tag" style="margin-top: 4px;">
                                    <fmt:formatNumber value="${order.totalPrice}" type="number" maxFractionDigits="0"/>đ
                                </div>
                            </div>
                        </div>

                        <div class="btn-flex-group">
                            <a href="${pageContext.request.contextPath}/shipper/donhang?action=detail&id=${order.id}">
                                <button type="button" class="btn-action btn-action-outline">Xem chi tiết</button>
                            </a>

                            <form action="${pageContext.request.contextPath}/shipper/donhang" method="post" style="display:inline;">
                                <input type="hidden" name="orderId" value="${order.id}">
                                <c:choose>
                                    <c:when test="${order.status == 'READY_FOR_PICKUP'}">
                                        <input type="hidden" name="action" value="updateStatusToShipping">
                                        <button type="submit" class="btn-action btn-action-warning"> xác nhận đã lấy hàng 📦</button>
                                    </c:when>
                                    <c:when test="${order.status == 'SHIPPING'}">
                                        <input type="hidden" name="action" value="updateStatusToDone">
                                        <button type="button" class="btn-action btn-action-primary"
                                                onclick="openConfirmDone(this.closest('form'))"> Hoàn thành giao đơn 🎉</button>
                                    </c:when>
                                </c:choose>
                            </form>

                        </div>
                    </div>
                </c:forEach>

                <c:if test="${empty danhSachDonHang}">
                    <div style="text-align: center; padding: 48px; color: var(--text-muted); background: var(--bg-card); border-radius: 12px; border: 1px dashed var(--border-color);">
                        📭 Hiện tại không có đơn hàng nào được phân phối cho bạn.
                    </div>
                </c:if>
            </div>
        </div>
    </main>

    <%-- Popup xác nhận Offline --%>
    <div class="confirm-modal-backdrop" id="confirmOfflineModal">
        <div class="confirm-modal">
            <div class="confirm-icon">🔴</div>
            <div class="confirm-title">Tắt chế độ Online?</div>
            <div class="confirm-desc">Bạn sẽ chuyển sang trạng thái <strong>Offline</strong> và không nhận được đơn hàng mới.</div>
            <div class="confirm-btns">
                <button class="confirm-btn confirm-btn-cancel" onclick="closeConfirm('confirmOfflineModal')">Huỷ</button>
                <button class="confirm-btn confirm-btn-warn" onclick="closeConfirm('confirmOfflineModal'); document.getElementById('onlineToggleForm').submit()">Xác nhận Offline</button>
            </div>
        </div>
    </div>

    <%-- Popup xác nhận hoàn thành giao đơn --%>
    <div class="confirm-modal-backdrop" id="confirmDoneModal">
        <div class="confirm-modal">
            <div class="confirm-icon">🎉</div>
            <div class="confirm-title">Xác nhận hoàn thành?</div>
            <div class="confirm-desc">Đơn hàng đã được giao thành công và bạn đã thu tiền COD (nếu có)?</div>
            <div class="confirm-btns">
                <button class="confirm-btn confirm-btn-cancel" onclick="closeConfirm('confirmDoneModal')">Chưa xong</button>
                <button class="confirm-btn confirm-btn-ok" id="confirmDoneBtn" onclick="doConfirmDone()">✅ Đã giao xong</button>
            </div>
        </div>
    </div>

    <div class="modal-backdrop" id="detailModal">
        <div class="modal-content">
            <div class="modal-header">
                <h3 style="font-weight: 700; font-size:16px;">Chi tiết lộ trình đơn hàng</h3>
                <button type="button" class="modal-close" onclick="closeDetailModal()">✕</button>
            </div>
            <div class="modal-body">
                <div style="background: var(--bg-base); padding: 14px; border-radius: 8px;">
                    <div style="font-size: 12px; color: var(--text-muted);">MÃ ĐƠN HÀNG THỰC TẾ</div>
                    <div id="modalOrderId" style="font-weight: 700; font-size: 16px; margin-top: 2px;">#0</div>
                </div>
                <div>
                    <label style="font-size: 11px; text-transform:uppercase; color: var(--text-muted); font-weight:700;">Địa điểm lấy hàng (Cửa hàng)</label>
                    <div id="modalShopName" style="font-weight:600; margin-top:4px; font-size:14px;">Tên cửa hàng</div>
                </div>
                <div>
                    <label style="font-size: 11px; text-transform:uppercase; color: var(--text-muted); font-weight:700;">Địa điểm giao hàng (Khách hàng)</label>
                    <div id="modalAddress" style="font-weight:600; margin-top:4px; font-size:14px;">Địa chỉ giao hàng</div>
                    <div id="modalReceiver" style="font-size:12px; color: var(--text-muted); margin-top:2px;">Người nhận</div>
                </div>
                <div style="border-top: 1px solid var(--border-color); padding-top: 14px; display:flex; justify-content:space-between; align-items:center;">
                    <span style="font-weight: 600; font-size:14px;">Tổng tiền cần thu hộ COD:</span>
                    <span id="modalPrice" style="font-size: 18px; font-weight:800; color: var(--primary);">0đ</span>
                </div>
                <div class="btn-group" style="margin-top: 8px; display:flex; justify-content:flex-end;">
                    <button type="button" class="btn-action btn-action-outline" style="width:100%;" onclick="closeDetailModal()">Đóng Cửa Sổ</button>
                </div>
            </div>
        </div>
    </div>

    <script>
        // --- XỬ LÝ DARK / LIGHT MODE ---
        const themeToggleBtn = document.getElementById('themeToggleBtn');
        const htmlElement = document.documentElement;
        const savedTheme = localStorage.getItem('shipper-theme') || 'light';
        htmlElement.setAttribute('data-theme', savedTheme);

        themeToggleBtn.addEventListener('click', () => {
            const currentTheme = htmlElement.getAttribute('data-theme');
            const newTheme = currentTheme === 'dark' ? 'light' : 'dark';
            htmlElement.setAttribute('data-theme', newTheme);
            localStorage.setItem('shipper-theme', newTheme);
        });

        // --- LỌC ĐƠN HÀNG THEO TRẠNG THÁI + HÌNH THỨC THANH TOÁN ---
        let currentStatus = 'ALL';

        function filterOrders(status, btn) {
            currentStatus = status;
            const tabs = document.querySelectorAll('.tab-btn');
            tabs.forEach(tab => tab.classList.remove('active'));
            if (btn) btn.classList.add('active');
            applyFilters();
        }

        function applyFilters() {
            const paymentVal = document.getElementById('paymentFilter').value;
            const cards = document.querySelectorAll('.order-card');
            let visibleCount = 0;

            cards.forEach(card => {
                const cardStatus  = card.getAttribute('data-status');
                const cardPayment = card.getAttribute('data-payment') || 'COD';

                // Chuẩn hóa payment về 3 nhóm
                const normalizedPayment = (cardPayment === 'PAYOS') ? 'PAYOS'
                                        : (cardPayment === 'BANK')  ? 'BANK'
                                        : 'COD';

                const statusOk = (currentStatus === 'ALL')
                                 || (currentStatus === 'HISTORY' ? (cardStatus === 'DONE' || cardStatus === 'CANCELLED') : cardStatus === currentStatus);

                const paymentOk = (paymentVal === 'ALL') || (normalizedPayment === paymentVal);

                const show = statusOk && paymentOk;
                card.style.display = show ? 'block' : 'none';
                if (show) visibleCount++;
            });

            // Thông báo khi không có kết quả
            let emptyMsg = document.getElementById('emptyFilterMsg');
            if (!emptyMsg) {
                emptyMsg = document.createElement('div');
                emptyMsg.id = 'emptyFilterMsg';
                emptyMsg.style.cssText = 'text-align:center;padding:40px;color:var(--text-muted);background:var(--bg-card);border-radius:12px;border:1px dashed var(--border-color);';
                emptyMsg.innerHTML = '🔍 Không có đơn hàng phù hợp với bộ lọc.';
                document.querySelector('.order-list').appendChild(emptyMsg);
            }
            emptyMsg.style.display = visibleCount === 0 ? 'block' : 'none';
        }


        // --- XỬ LÝ POPUP DIALOG DETAIL ---
        const detailModal = document.getElementById('detailModal');

        function openDetailModal(id, shopName, address, receiver, price, status) {
            document.getElementById('modalOrderId').innerText = '#' + id;
            document.getElementById('modalShopName').innerText = shopName;
            document.getElementById('modalAddress').innerText = address;
            document.getElementById('modalReceiver').innerText = '👤 Khách hàng: ' + receiver;
            document.getElementById('modalPrice').innerText = parseFloat(price).toLocaleString('vi-VN') + 'đ';
            detailModal.classList.add('active');
        }

        function closeDetailModal() {
            detailModal.classList.remove('active');
        }

        // Click ra ngoài đóng modal
        detailModal.addEventListener('click', function(e) {
            if (e.target === detailModal) {
                closeDetailModal();
            }
        });

        // --- CONFIRM POPUP CHUNG ---
        let _pendingDoneForm = null;

        function openConfirm(id) {
            document.getElementById(id).classList.add('active');
        }
        function closeConfirm(id) {
            document.getElementById(id).classList.remove('active');
        }
        function openConfirmDone(form) {
            _pendingDoneForm = form;
            openConfirm('confirmDoneModal');
        }
        function doConfirmDone() {
            closeConfirm('confirmDoneModal');
            if (_pendingDoneForm) _pendingDoneForm.submit();
        }

        // Click backdrop đóng confirm popup
        document.querySelectorAll('.confirm-modal-backdrop').forEach(function(el) {
            el.addEventListener('click', function(e) {
                if (e.target === el) el.classList.remove('active');
            });
        });
    </script>

<div class="avatar-dropdown" id="avatarDropdown">
    <div class="dropdown-header">
        <div class="d-name">${sessionScope.account.userName}</div>
        <div class="d-email">${sessionScope.account.email}</div>
        <span class="d-role">🛵 Shipper</span>
    </div>
    <div class="dropdown-body">
        <a href="${pageContext.request.contextPath}/shipper/ho-so" class="dropdown-link">👤 Hồ sơ cá nhân</a>
        <a href="${pageContext.request.contextPath}/shipper/doi-mat-khau" class="dropdown-link">🔒 Đổi mật khẩu</a>
        <div class="dropdown-divider"></div>
        <a href="${pageContext.request.contextPath}/logout" class="dropdown-link danger">🚪 Đăng xuất</a>
    </div>
</div>
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
</script></body>
</html>