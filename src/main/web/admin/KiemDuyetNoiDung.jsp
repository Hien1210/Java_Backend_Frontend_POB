<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<c:if test="${empty sessionScope.account || sessionScope.account.roleId != 1}">
    <c:redirect url="/dangnhap"/>
</c:if>

<!-- MOCK-DATA: trang nay dang o giai doan lam giao dien truoc, chua noi DB/servlet thuc -->

<!DOCTYPE html>
<html lang="vi" data-theme="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kiểm duyệt nội dung - Super Admin</title>
    <style>
        :root[data-theme="dark"] {
            --bg-base: #0f172a; --bg-sidebar: #1e293b; --bg-panel: #1e293b;
            --bg-input: #0f172a; --bg-hover: #1e293b;
            --text-main: #f8fafc; --text-muted: #94a3b8; --text-dim: #565674;
            --border-color: #334155; --topbar-bg: rgba(30, 41, 59, 0.8);
        }
        :root[data-theme="light"] {
            --bg-base: #f1f5f9; --bg-sidebar: #ffffff; --bg-panel: #ffffff;
            --bg-input: #f8fafc; --bg-hover: #f1f5f9;
            --text-main: #0f172a; --text-muted: #64748b; --text-dim: #94a3b8;
            --border-color: #e2e8f0; --topbar-bg: rgba(255, 255, 255, 0.8);
        }
        :root { --primary: #10b981; --warning: #f59e0b;
            --primary-hover: #059669;
            --primary-light: rgba(16, 185, 129, 0.15);
            --danger-light: rgba(239, 68, 68, 0.1);
            --font-family: system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif; --danger: #ef4444; --info: #3b82f6; }

        * { box-sizing: border-box; margin: 0; padding: 0; font-family: var(--font-family); transition: background-color 0.3s, border-color 0.3s, color 0.3s; }
        body { background-color: var(--bg-base); color: var(--text-muted); display: flex; height: 100vh; overflow: hidden; }
        a { text-decoration: none; color: inherit; }
        ul { list-style: none; }

        .sidebar { width: 260px; background-color: var(--bg-sidebar); border-right: 1px solid var(--border-color); display: flex; flex-direction: column; flex-shrink: 0; transition: width 0.3s ease; overflow: hidden; }
        .brand { padding: 20px; display: flex; flex-direction: column; gap: 10px; border-bottom: 1px solid var(--border-color); transition: padding 0.3s ease; }
        .brand-row { display: flex; align-items: center; justify-content: space-between; gap: 12px; }
        .logo { background: var(--primary); color: #fff; width: 32px; height: 32px; border-radius: 6px; display: flex; align-items: center; justify-content: center; font-weight: bold; flex-shrink: 0; }
        .brand-title { color: var(--text-main); font-weight: bold; font-size: 14px; }
        .sidebar-toggle-btn { background: var(--bg-input); border: 1px solid var(--border-color); width: 30px; height: 30px; border-radius: 6px; display: flex; align-items: center; justify-content: center; color: var(--text-main); cursor: pointer; flex-shrink: 0; transition: all 0.2s ease; }
        .sidebar-toggle-btn:hover { background: var(--border-color); }
        .menu { padding: 15px 12px; flex: 1; overflow-y: auto; overflow-x: hidden; }
        .menu-title { font-size: 11px; color: var(--text-dim); font-weight: bold; margin: 15px 8px 10px; text-transform: uppercase; white-space: nowrap; }
        .menu-item { padding: 12px 16px; display: flex; align-items: center; justify-content: space-between; color: var(--text-muted); font-size: 14px; transition: all 0.2s; border-radius: 8px; margin-bottom: 4px; white-space: nowrap; }
        .menu-item:hover { background-color: var(--bg-input); color: var(--text-main); transform: translateX(4px); }
        .menu-item.active { background-color: var(--primary-light); color: var(--primary); font-weight: 600; }
        .menu-item-label-group { display: flex; align-items: center; gap: 8px; overflow: hidden; }
        .badge { font-size: 10px; padding: 3px 8px; border-radius: 10px; background: var(--border-color); color: var(--text-main); flex-shrink: 0; }
        .badge.red { background: var(--danger); color: #fff; font-weight: 700; }

        .sidebar.collapsed { width: 84px; }
        .sidebar.collapsed .brand { padding: 16px 8px; }
        .sidebar.collapsed .brand-row { flex-direction: column; gap: 10px; }
        .sidebar.collapsed .brand-title,
        .sidebar.collapsed .sidebar-hi,
        .sidebar.collapsed .menu-title,
        .sidebar.collapsed .menu-label,
        .sidebar.collapsed .badge { display: none; }
        .sidebar.collapsed .menu-item { justify-content: center; padding: 12px 0; }
        .sidebar.collapsed .menu-item:hover { transform: none; }
        .sidebar.collapsed .menu-item-label-group { gap: 0; }

        /* Custom scrollbar cho sidebar */
        .sidebar::-webkit-scrollbar,
        .menu::-webkit-scrollbar,
        .content::-webkit-scrollbar { width: 6px; }
        .sidebar::-webkit-scrollbar-track,
        .menu::-webkit-scrollbar-track,
        .content::-webkit-scrollbar-track { background: var(--bg-sidebar); }
        .sidebar::-webkit-scrollbar-thumb,
        .menu::-webkit-scrollbar-thumb,
        .content::-webkit-scrollbar-thumb { background: var(--border-color); border-radius: 9999px; }
        .sidebar::-webkit-scrollbar-thumb:hover,
        .menu::-webkit-scrollbar-thumb:hover,
        .content::-webkit-scrollbar-thumb:hover { background: var(--text-dim); }
        .menu, .content { scrollbar-width: thin; scrollbar-color: var(--border-color) var(--bg-sidebar); }

        .main { flex: 1; display: flex; flex-direction: column; overflow: hidden; transition: all 0.3s ease; }
        .topbar { background-color: var(--topbar-bg); backdrop-filter: blur(12px); -webkit-backdrop-filter: blur(12px); padding: 15px 30px; display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid var(--border-color); }
        .topbar h1 { color: var(--text-main); font-size: 18px; font-weight: bold; }
        .topbar-right { display: flex; align-items: center; gap: 15px; }
        .theme-toggle { background: var(--bg-input); border: 1px solid var(--border-color); width: 38px; height: 38px; border-radius: 8px; cursor: pointer; display: flex; align-items: center; justify-content: center; color: var(--text-main); font-size: 16px; }

        .content { padding: 28px 30px; overflow-y: auto; flex: 1; display: flex; flex-direction: column; gap: 20px; }

        .mock-note { background: rgba(59,130,246,0.08); border: 1px solid rgba(59,130,246,0.35); color: var(--info); padding: 11px 16px; border-radius: 8px; font-size: 12.5px; font-weight: 600; display: flex; align-items: center; gap: 8px; }

        .panel { background: var(--bg-panel); border: 1px solid var(--border-color); border-radius: 10px; animation: fadeUp 0.35s ease both; padding: 22px; }
        .panel-title { font-size: 14px; font-weight: bold; text-transform: uppercase; border-left: 4px solid var(--primary); padding-left: 10px; color: var(--text-main); margin-bottom: 18px; display: flex; align-items: center; justify-content: space-between; }

        /* TABS */
        .tab-bar { display: flex; gap: 4px; border-bottom: 1px solid var(--border-color); margin-bottom: 20px; }
        .tab-btn { padding: 10px 18px; font-size: 13px; font-weight: 600; color: var(--text-muted); background: none; border: none; cursor: pointer; border-bottom: 3px solid transparent; transition: all 0.2s; }
        .tab-btn:hover { color: var(--text-main); }
        .tab-btn.active { color: var(--primary); border-bottom-color: var(--primary); }
        .tab-panel { display: none; }
        .tab-panel.active { display: block; }

        /* MODERATION CARD (dung chung cho binh luan + mon an) */
        .mod-list { display: flex; flex-direction: column; gap: 14px; }
        .mod-card { background: var(--bg-input); border: 1px solid var(--border-color); border-radius: 10px; animation: fadeUp 0.35s ease both; padding: 18px 20px; transition: opacity 0.25s ease, transform 0.25s ease; }
        .mod-card.pending { border-left: 4px solid var(--warning); }
        .mod-card.removing { opacity: 0; transform: translateX(20px) scale(0.98); }

        .mod-header { display: flex; align-items: flex-start; justify-content: space-between; margin-bottom: 12px; gap: 12px; }
        .mod-user { display: flex; align-items: center; gap: 10px; }
        .avatar-sm { width: 36px; height: 36px; border-radius: 50%; background: rgba(250,204,21,0.15); color: var(--warning); display: flex; align-items: center; justify-content: center; font-weight: 800; font-size: 14px; flex-shrink: 0; }
        .mod-name { font-size: 14px; font-weight: 700; color: var(--text-main); }
        .mod-sub { font-size: 12px; color: var(--text-muted); }
        .mod-time { font-size: 11px; color: var(--text-dim); white-space: nowrap; }

        .label-row { font-size: 11px; font-weight: 700; text-transform: uppercase; color: var(--text-dim); margin-bottom: 6px; letter-spacing: 0.4px; }
        .message-box { background: var(--bg-hover); border: 1px solid var(--border-color); border-radius: 6px; padding: 10px 14px; font-size: 13px; color: var(--text-main); line-height: 1.6; margin-bottom: 14px; }

        /* Content dac thu cho mon an: anh thumbnail + thong tin */
        .food-row { display: flex; gap: 14px; align-items: center; background: var(--bg-hover); border: 1px solid var(--border-color); border-radius: 8px; padding: 12px 14px; margin-bottom: 14px; }
        .food-thumb { width: 64px; height: 64px; border-radius: 8px; flex-shrink: 0; display: flex; align-items: center; justify-content: center; font-size: 28px; background: linear-gradient(135deg, rgba(16,185,129,0.18), rgba(59,130,246,0.18)); border: 1px solid var(--border-color); }
        .food-info .food-name { font-size: 14px; font-weight: 700; color: var(--text-main); margin-bottom: 3px; }
        .food-info .food-shop { font-size: 12px; color: var(--text-muted); }
        .food-info .food-price { font-size: 13px; font-weight: 700; color: var(--primary); margin-top: 4px; }

        .reason-tags { display: flex; flex-wrap: wrap; gap: 6px; margin-bottom: 14px; }
        .reason-tag { font-size: 11px; font-weight: 700; padding: 4px 11px; border-radius: 20px; display: flex; align-items: center; gap: 5px; }
        .reason-tag.danger { background: rgba(239,68,68,0.1); border: 1px solid rgba(239,68,68,0.3); color: var(--danger); }
        .reason-tag.warn { background: rgba(250,204,21,0.12); border: 1px solid rgba(250,204,21,0.35); color: var(--warning); }
        .reason-tag.info { background: rgba(59,130,246,0.1); border: 1px solid rgba(59,130,246,0.3); color: var(--info); }

        .action-row { display: flex; gap: 10px; }
        .btn-approve { background: rgba(32,212,137,0.12); border: 1.5px solid var(--primary); color: var(--primary); padding: 8px 18px; border-radius: 7px; font-size: 13px; font-weight: 700; cursor: pointer; transition: 0.15s; }
        .btn-approve:hover { background: var(--primary); color: #0f172a; }
        .btn-reject { background: rgba(239,68,68,0.08); border: 1.5px solid var(--danger); color: var(--danger); padding: 8px 18px; border-radius: 7px; font-size: 13px; font-weight: 700; cursor: pointer; transition: 0.15s; }
        .btn-reject:hover { background: var(--danger); color: #fff; }

        .empty-state { text-align: center; padding: 48px 20px; color: var(--text-dim); }
        .empty-state .icon { font-size: 48px; margin-bottom: 12px; }

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
    <div class="brand">
        <div class="brand-row">
            <div style="display: flex; align-items: center; gap: 12px;">
                <div class="logo">S</div>
                <span class="brand-title">SUPER ADMIN</span>
            </div>
            <button type="button" class="sidebar-toggle-btn" id="sidebarToggleBtn" title="Thu gọn/mở rộng menu">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <line x1="3" y1="6" x2="21" y2="6"></line>
                    <line x1="3" y1="12" x2="21" y2="12"></line>
                    <line x1="3" y1="18" x2="21" y2="18"></line>
                </svg>
            </button>
        </div>
        <div class="sidebar-hi" style="font-size:12px;color:var(--text-muted);">
            👋 Hi, <strong style="color:var(--primary);">${sessionScope.account.userName}</strong>
        </div>
    </div>
    <ul class="menu">
        <div class="menu-title">📊 TỔNG QUAN & PHÂN TÍCH</div>
        <a href="${pageContext.request.contextPath}/tong-quan">
            <li class="menu-item"><span class="menu-item-label-group"><span class="menu-icon">⊞</span><span class="menu-label">Tổng quan hệ thống</span></span></li>
        </a>
        <a href="#">
            <li class="menu-item"><span class="menu-item-label-group"><span class="menu-icon">📈</span><span class="menu-label">Báo cáo vận hành</span></span></li>
        </a>

        <div class="menu-title">⚖️ KIỂM DUYỆT & ĐIỀU PHỐI</div>
        <a href="${pageContext.request.contextPath}/super-admin/shop-requests">
            <li class="menu-item">
                <span class="menu-item-label-group"><span class="menu-icon">🏪</span><span class="menu-label">Duyệt Shop</span></span>
                <c:if test="${shopChoDuyet > 0}">
                    <span class="badge red">${shopChoDuyet}</span>
                </c:if>
            </li>
        </a>
        <a href="${pageContext.request.contextPath}/super-admin/shipper-requests">
            <li class="menu-item">
                <span class="menu-item-label-group"><span class="menu-icon">🛵</span><span class="menu-label">Duyệt Shipper</span></span>
                <c:if test="${not empty pendingShippers}">
                    <span class="badge red">${pendingShippers.size()}</span>
                </c:if>
            </li>
        </a>
        <a href="${pageContext.request.contextPath}/admin/kiem-duyet-noi-dung">
            <li class="menu-item active">
                <span class="menu-item-label-group"><span class="menu-icon">🚩</span><span class="menu-label">Kiểm duyệt nội dung</span></span>
                <span class="badge red">7</span>
            </li>
        </a>
        <a href="${pageContext.request.contextPath}/admin/appeals">
            <li class="menu-item">
                <span class="menu-item-label-group"><span class="menu-icon">📋</span><span class="menu-label">Kháng nghị</span></span>
                <c:if test="${pendingCount > 0}">
                    <span class="badge red">${pendingCount}</span>
                </c:if>
            </li>
        </a>

        <div class="menu-title">💰 QUẢN LÝ TÀI CHÍNH</div>
        <a href="#">
            <li class="menu-item"><span class="menu-item-label-group"><span class="menu-icon">💵</span><span class="menu-label">Đối soát doanh thu Shop</span></span></li>
        </a>
        <a href="#">
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
        <h1>🚩 Kiểm duyệt nội dung</h1>
        <div class="topbar-right">
            <button class="theme-toggle" id="themeToggleBtn">🌓</button>
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

        <div class="mock-note">
            🧪 Giao diện đang ở bản dựng mock-data (chưa nối Servlet/DAO thật) — dùng để duyệt trực quan trước khi làm phần backend.
        </div>

        <div class="panel">
            <div class="panel-title">
                Hàng đợi kiểm duyệt
                <span class="badge red">7 chờ duyệt</span>
            </div>

            <div class="tab-bar">
                <button class="tab-btn active" onclick="switchTab('comment')">💬 Bình luận chờ duyệt (4)</button>
                <button class="tab-btn" onclick="switchTab('food')">🍜 Món ăn chờ duyệt (3)</button>
            </div>

            <!-- Tab: Bình luận chờ duyệt -->
            <div class="tab-panel active" id="tab-comment">
                <div class="mod-list" id="list-comment">

                    <div class="mod-card pending">
                        <div class="mod-header">
                            <div class="mod-user">
                                <div class="avatar-sm">N</div>
                                <div>
                                    <div class="mod-name">nguyenvana92</div>
                                    <div class="mod-sub">Bình luận tại đơn hàng #DH20458 · Trà Sữa Bảo Anh</div>
                                </div>
                            </div>
                            <div class="mod-time">12 phút trước</div>
                        </div>

                        <div class="label-row">Nội dung bình luận</div>
                        <div class="message-box">"Đồ ăn dở tệ, thái độ ship như c*t, đừng bao giờ mua ở đây!!!"</div>

                        <div class="reason-tags">
                            <span class="reason-tag danger">🔞 Chứa từ khóa nhạy cảm</span>
                        </div>

                        <div class="action-row">
                            <button type="button" class="btn-approve" onclick="mockApprove(this)">✅ Phê duyệt</button>
                            <button type="button" class="btn-reject" onclick="mockReject(this)">🚫 Từ chối (Ẩn/Xóa)</button>
                        </div>
                    </div>

                    <div class="mod-card pending">
                        <div class="mod-header">
                            <div class="mod-user">
                                <div class="avatar-sm">T</div>
                                <div>
                                    <div class="mod-name">tranthib_88</div>
                                    <div class="mod-sub">Bình luận tại đơn hàng #DH20461 · Cơm Tấm Sườn Bì</div>
                                </div>
                            </div>
                            <div class="mod-time">27 phút trước</div>
                        </div>

                        <div class="label-row">Nội dung bình luận</div>
                        <div class="message-box">"Shop này lừa đảo, giao thiếu đồ mà không hoàn tiền, mọi người cẩn thận."</div>

                        <div class="reason-tags">
                            <span class="reason-tag warn">🚨 Bị người dùng báo cáo (5 lượt)</span>
                        </div>

                        <div class="action-row">
                            <button type="button" class="btn-approve" onclick="mockApprove(this)">✅ Phê duyệt</button>
                            <button type="button" class="btn-reject" onclick="mockReject(this)">🚫 Từ chối (Ẩn/Xóa)</button>
                        </div>
                    </div>

                    <div class="mod-card pending">
                        <div class="mod-header">
                            <div class="mod-user">
                                <div class="avatar-sm">L</div>
                                <div>
                                    <div class="mod-name">lehoang_food</div>
                                    <div class="mod-sub">Bình luận tại đơn hàng #DH20470 · Pizza Hải Sản</div>
                                </div>
                            </div>
                            <div class="mod-time">1 giờ trước</div>
                        </div>

                        <div class="label-row">Nội dung bình luận</div>
                        <div class="message-box">"Liên hệ ngay 09xx-xxx-xxx để được giảm giá 50% khi đặt trực tiếp, né app nha mọi người 😉"</div>

                        <div class="reason-tags">
                            <span class="reason-tag info">📵 Nghi vấn spam/quảng cáo ngoài luồng</span>
                        </div>

                        <div class="action-row">
                            <button type="button" class="btn-approve" onclick="mockApprove(this)">✅ Phê duyệt</button>
                            <button type="button" class="btn-reject" onclick="mockReject(this)">🚫 Từ chối (Ẩn/Xóa)</button>
                        </div>
                    </div>

                    <div class="mod-card pending">
                        <div class="mod-header">
                            <div class="mod-user">
                                <div class="avatar-sm">P</div>
                                <div>
                                    <div class="mod-name">phamminhq</div>
                                    <div class="mod-sub">Bình luận tại đơn hàng #DH20475 · Bún Bò Huế Cô Ba</div>
                                </div>
                            </div>
                            <div class="mod-time">2 giờ trước</div>
                        </div>

                        <div class="label-row">Nội dung bình luận</div>
                        <div class="message-box">"Ship trễ 40 phút, canh nguội ngắt, đánh giá 1 sao xứng đáng."</div>

                        <div class="reason-tags">
                            <span class="reason-tag warn">🚨 Bị người dùng báo cáo (2 lượt)</span>
                        </div>

                        <div class="action-row">
                            <button type="button" class="btn-approve" onclick="mockApprove(this)">✅ Phê duyệt</button>
                            <button type="button" class="btn-reject" onclick="mockReject(this)">🚫 Từ chối (Ẩn/Xóa)</button>
                        </div>
                    </div>

                </div>
                <div class="empty-state" id="empty-comment" style="display:none;">
                    <div class="icon">✅</div>
                    <p>Không còn bình luận nào đang chờ duyệt</p>
                </div>
            </div>

            <!-- Tab: Món ăn chờ duyệt -->
            <div class="tab-panel" id="tab-food">
                <div class="mod-list" id="list-food">

                    <div class="mod-card pending">
                        <div class="mod-header">
                            <div class="mod-user">
                                <div class="avatar-sm">S</div>
                                <div>
                                    <div class="mod-name">Shop Bếp Nhà Mai</div>
                                    <div class="mod-sub">Đăng món ăn mới</div>
                                </div>
                            </div>
                            <div class="mod-time">18 phút trước</div>
                        </div>

                        <div class="label-row">Món ăn chờ duyệt</div>
                        <div class="food-row">
                            <div class="food-thumb">🍔</div>
                            <div class="food-info">
                                <div class="food-name">Combo Burger "Ngon Bá Cháy" Sale Sốc 90%</div>
                                <div class="food-shop">Danh mục: Đồ ăn nhanh</div>
                                <div class="food-price">45.000 đ</div>
                            </div>
                        </div>

                        <div class="reason-tags">
                            <span class="reason-tag danger">🔞 Tên món chứa từ khóa giật gân/nhạy cảm</span>
                        </div>

                        <div class="action-row">
                            <button type="button" class="btn-approve" onclick="mockApprove(this)">✅ Phê duyệt</button>
                            <button type="button" class="btn-reject" onclick="mockReject(this)">🚫 Từ chối (Ẩn/Xóa)</button>
                        </div>
                    </div>

                    <div class="mod-card pending">
                        <div class="mod-header">
                            <div class="mod-user">
                                <div class="avatar-sm">Q</div>
                                <div>
                                    <div class="mod-name">Quán Ăn Vặt Bà Tư</div>
                                    <div class="mod-sub">Đăng món ăn mới</div>
                                </div>
                            </div>
                            <div class="mod-time">55 phút trước</div>
                        </div>

                        <div class="label-row">Món ăn chờ duyệt</div>
                        <div class="food-row">
                            <div class="food-thumb">🖼️</div>
                            <div class="food-info">
                                <div class="food-name">Bánh Tráng Trộn Đặc Biệt</div>
                                <div class="food-shop">Danh mục: Ăn vặt</div>
                                <div class="food-price">25.000 đ</div>
                            </div>
                        </div>

                        <div class="reason-tags">
                            <span class="reason-tag info">🖼️ Hình ảnh mờ/không rõ món ăn</span>
                        </div>

                        <div class="action-row">
                            <button type="button" class="btn-approve" onclick="mockApprove(this)">✅ Phê duyệt</button>
                            <button type="button" class="btn-reject" onclick="mockReject(this)">🚫 Từ chối (Ẩn/Xóa)</button>
                        </div>
                    </div>

                    <div class="mod-card pending">
                        <div class="mod-header">
                            <div class="mod-user">
                                <div class="avatar-sm">H</div>
                                <div>
                                    <div class="mod-name">Highlands Coffee - CN Quận 3</div>
                                    <div class="mod-sub">Cập nhật món ăn</div>
                                </div>
                            </div>
                            <div class="mod-time">3 giờ trước</div>
                        </div>

                        <div class="label-row">Món ăn chờ duyệt</div>
                        <div class="food-row">
                            <div class="food-thumb">☕</div>
                            <div class="food-info">
                                <div class="food-name">Freeze Trà Xanh</div>
                                <div class="food-shop">Danh mục: Đồ uống</div>
                                <div class="food-price">1.000 đ</div>
                            </div>
                        </div>

                        <div class="reason-tags">
                            <span class="reason-tag warn">🚨 Bị người dùng báo cáo giá sai (4 lượt)</span>
                        </div>

                        <div class="action-row">
                            <button type="button" class="btn-approve" onclick="mockApprove(this)">✅ Phê duyệt</button>
                            <button type="button" class="btn-reject" onclick="mockReject(this)">🚫 Từ chối (Ẩn/Xóa)</button>
                        </div>
                    </div>

                </div>
                <div class="empty-state" id="empty-food" style="display:none;">
                    <div class="icon">✅</div>
                    <p>Không còn món ăn nào đang chờ duyệt</p>
                </div>
            </div>

        </div>
    </div>
</main>

<script>
    const html = document.documentElement;
    const saved = localStorage.getItem('adminTheme') || 'dark';
    html.setAttribute('data-theme', saved);
    document.getElementById('themeToggleBtn').addEventListener('click', () => {
        const next = html.getAttribute('data-theme') === 'dark' ? 'light' : 'dark';
        html.setAttribute('data-theme', next);
        localStorage.setItem('adminTheme', next);
    });

    // Thu gọn/mở rộng Sidebar
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

    function switchTab(name) {
        document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
        document.querySelectorAll('.tab-panel').forEach(p => p.classList.remove('active'));
        document.getElementById('tab-' + name).classList.add('active');
        event.currentTarget.classList.add('active');
    }

    // Mock: cac nut Phe duyet/Tu choi chi xu ly o client (chua goi servlet that)
    function mockRemoveCard(btn, toastType, toastMsg) {
        const card = btn.closest('.mod-card');
        const list = card.closest('.mod-list');
        card.classList.add('removing');
        setTimeout(() => {
            card.remove();
            if (list && list.children.length === 0) {
                const emptyEl = document.getElementById('empty-' + list.id.replace('list-', ''));
                if (emptyEl) emptyEl.style.display = 'block';
            }
        }, 250);
        if (window.showToast) window.showToast(toastType, toastMsg);
    }
    function mockApprove(btn) { mockRemoveCard(btn, 'success', 'Đã phê duyệt nội dung (mock).'); }
    function mockReject(btn) { mockRemoveCard(btn, 'error', 'Đã từ chối và ẩn nội dung (mock).'); }

    // Avatar dropdown
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
<!-- Avatar Dropdown (đặt ngoài topbar để tránh backdrop-filter stacking context) -->
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
<script src="${pageContext.request.contextPath}/assets/js/toast.js"></script>
</body>
</html>
