<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="/app-functions" prefix="app" %>

<c:if test="${empty sessionScope.account || sessionScope.account.roleId != 1}">
    <c:redirect url="/dangnhap"/>
</c:if>

<!-- Tab "Mon an cho duyet" va Tab "Quan ly Tu khoa cam" deu da noi Servlet/DAO that.
     Tab binh luan rieng da chuyen sang trang /admin/kiem-duyet-binh-luan. -->

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
        .food-thumb { width: 64px; height: 64px; border-radius: 8px; flex-shrink: 0; display: flex; align-items: center; justify-content: center; font-size: 28px; background: linear-gradient(135deg, rgba(16,185,129,0.18), rgba(59,130,246,0.18)); border: 1px solid var(--border-color); overflow: hidden; }
        .food-thumb img { width: 100%; height: 100%; object-fit: cover; }
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

        /* Quan ly Tu khoa cam (Banned Words) */
        .word-input-row { display: flex; gap: 10px; margin-bottom: 20px; }
        .word-input-row input[type="text"] { flex: 1; background: var(--bg-input); border: 1px solid var(--border-color); border-radius: 7px; padding: 10px 14px; font-size: 13px; color: var(--text-main); outline: none; }
        .word-input-row input[type="text"]:focus { border-color: var(--primary); }
        .btn-add-word { background: var(--primary); border: none; color: #0f172a; padding: 0 20px; border-radius: 7px; font-size: 13px; font-weight: 700; cursor: pointer; transition: 0.15s; white-space: nowrap; }
        .btn-add-word:hover { background: var(--primary-hover); }
        .word-list { display: flex; flex-wrap: wrap; gap: 10px; }
        .word-pill { display: flex; align-items: center; gap: 10px; background: var(--bg-input); border: 1px solid var(--border-color); border-radius: 20px; padding: 8px 8px 8px 16px; font-size: 13px; color: var(--text-main); }
        .word-pill .word-text { font-weight: 600; }
        .word-pill .btn-delete-word { background: rgba(239,68,68,0.1); border: 1px solid rgba(239,68,68,0.3); color: var(--danger); width: 24px; height: 24px; border-radius: 50%; cursor: pointer; font-size: 13px; line-height: 1; display: flex; align-items: center; justify-content: center; transition: 0.15s; }
        .word-pill .btn-delete-word:hover { background: var(--danger); color: #fff; }

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
        <a href="${pageContext.request.contextPath}/admin/bao-cao-van-hanh">
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
                <c:if test="${not empty pendingProducts}">
                    <span class="badge red">${pendingProducts.size()}</span>
                </c:if>
            </li>
        </a>
        <a href="${pageContext.request.contextPath}/admin/kiem-duyet-binh-luan">
            <li class="menu-item"><span class="menu-item-label-group"><span class="menu-icon">💬</span><span class="menu-label">Kiểm duyệt bình luận</span></span></li>
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

        <div class="panel">
            <div class="panel-title">
                Hàng đợi kiểm duyệt
                <c:if test="${not empty pendingProducts}">
                    <span class="badge red">${pendingProducts.size()} món ăn chờ duyệt</span>
                </c:if>
            </div>

            <div class="tab-bar">
                <button class="tab-btn active" onclick="switchTab('food')">🍜 Món ăn chờ duyệt (${pendingProducts.size()})</button>
                <button class="tab-btn" onclick="switchTab('bannedwords')">🔞 Quản lý Từ khóa cấm (${bannedWords.size()})</button>
            </div>

            <!-- Tab: Món ăn chờ duyệt (dữ liệu thật từ bảng Products, status = PENDING_REVIEW) -->
            <div class="tab-panel active" id="tab-food">
                <div class="mod-list" id="list-food">
                    <c:forEach var="p" items="${pendingProducts}">
                        <div class="mod-card pending">
                            <div class="mod-header">
                                <div class="mod-user">
                                    <div class="avatar-sm">${fn:toUpperCase(fn:substring(p.shopName, 0, 1))}</div>
                                    <div>
                                        <div class="mod-name">${p.shopName}</div>
                                        <div class="mod-sub">Đăng món ăn mới</div>
                                    </div>
                                </div>
                                <div class="mod-time">${app:formatDateTime(p.createdAt)}</div>
                            </div>

                            <div class="label-row">Món ăn chờ duyệt</div>
                            <div class="food-row">
                                <div class="food-thumb">
                                    <c:choose>
                                        <c:when test="${not empty p.imageUrl}">
                                            <img src="${p.imageUrl}" alt="${p.productName}"/>
                                        </c:when>
                                        <c:otherwise>🍽️</c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="food-info">
                                    <div class="food-name">${p.productName}</div>
                                    <div class="food-shop">${p.description}</div>
                                </div>
                            </div>

                            <div class="reason-tags">
                                <span class="reason-tag info">🆕 Sản phẩm mới cần Super Admin duyệt</span>
                            </div>

                            <form method="post" action="${pageContext.request.contextPath}/admin/kiem-duyet-noi-dung">
                                <input type="hidden" name="productId" value="${p.id}"/>
                                <div class="action-row">
                                    <button type="submit" name="action" value="approve" class="btn-approve">✅ Phê duyệt (Cho phép hiển thị)</button>
                                    <button type="submit" name="action" value="reject" class="btn-reject">🚫 Từ chối (Ẩn/Xóa)</button>
                                </div>
                            </form>
                        </div>
                    </c:forEach>
                </div>
                <div class="empty-state" id="empty-food" style="${empty pendingProducts ? '' : 'display:none;'}">
                    <div class="icon">✅</div>
                    <p>Không còn món ăn nào đang chờ duyệt</p>
                </div>
            </div>

            <!-- Tab: Quản lý Từ khóa cấm (dữ liệu thật từ bảng BannedWords) -->
            <div class="tab-panel" id="tab-bannedwords">
                <form method="post" action="${pageContext.request.contextPath}/admin/kiem-duyet-noi-dung" class="word-input-row">
                    <input type="hidden" name="action" value="addWord"/>
                    <input type="text" name="word" placeholder="Nhập từ cấm mới..." maxlength="100" required/>
                    <button type="submit" class="btn-add-word">➕ Thêm từ cấm</button>
                </form>

                <div class="word-list" id="list-bannedwords">
                    <c:forEach var="bw" items="${bannedWords}">
                        <div class="word-pill">
                            <span class="word-text">${bw.word}</span>
                            <form method="post" action="${pageContext.request.contextPath}/admin/kiem-duyet-noi-dung" style="display:inline;">
                                <input type="hidden" name="action" value="deleteWord"/>
                                <input type="hidden" name="wordId" value="${bw.id}"/>
                                <button type="submit" class="btn-delete-word" title="Xóa từ cấm">✕</button>
                            </form>
                        </div>
                    </c:forEach>
                </div>
                <div class="empty-state" id="empty-bannedwords" style="${empty bannedWords ? '' : 'display:none;'}">
                    <div class="icon">🔞</div>
                    <p>Chưa có từ cấm nào trong danh sách</p>
                </div>
            </div>

        </div>
    </div>
</main>

<script>
    const html = document.documentElement;
    const saved = localStorage.getItem('theme') || 'dark';
    html.setAttribute('data-theme', saved);
    document.getElementById('themeToggleBtn').addEventListener('click', () => {
        const next = html.getAttribute('data-theme') === 'dark' ? 'light' : 'dark';
        html.setAttribute('data-theme', next);
        localStorage.setItem('theme', next);
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

    // Toast sau khi PRG redirect ve tu form submit (approve/reject mon an, them/xoa tu cam)
    (function () {
        const params = new URLSearchParams(window.location.search);
        const success = params.get('success');
        if (!success || !window.showToast) return;
        if (success === 'approved') window.showToast('success', 'Đã phê duyệt nội dung.');
        else if (success === 'rejected') window.showToast('error', 'Đã từ chối và ẩn nội dung.');
        else if (success === 'wordAdded') window.showToast('success', 'Đã thêm từ cấm mới.');
        else if (success === 'wordDeleted') window.showToast('error', 'Đã xóa từ cấm.');
    })();

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
