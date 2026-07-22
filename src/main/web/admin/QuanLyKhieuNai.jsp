<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="/app-functions" prefix="app" %>

<c:if test="${empty sessionScope.account || sessionScope.account.roleId != 1}">
    <c:redirect url="/dangnhap"/>
</c:if>

<!DOCTYPE html>
<html lang="vi" data-theme="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý khiếu nại - Super Admin</title>
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

        .filter-bar { display: flex; gap: 8px; margin-bottom: 18px; }
        .filter-btn { padding: 8px 16px; border-radius: 20px; border: 1.5px solid var(--border-color); background: var(--bg-input); color: var(--text-muted); font-size: 12.5px; font-weight: 700; cursor: pointer; }
        .filter-btn.active { border-color: var(--primary); color: var(--primary); background: var(--primary-light); }

        .mod-list { display: flex; flex-direction: column; gap: 14px; }
        .mod-card { background: var(--bg-input); border: 1px solid var(--border-color); border-radius: 10px; animation: fadeUp 0.35s ease both; padding: 18px 20px; }
        .mod-card.pending { border-left: 4px solid var(--warning); }
        .mod-card.processing { border-left: 4px solid var(--info); }
        .mod-card.resolved { border-left: 4px solid var(--primary); }
        .mod-card.rejected { border-left: 4px solid var(--danger); }

        .mod-header { display: flex; align-items: flex-start; justify-content: space-between; margin-bottom: 12px; gap: 12px; flex-wrap: wrap; }
        .mod-user { display: flex; align-items: center; gap: 10px; }
        .avatar-sm { width: 36px; height: 36px; border-radius: 50%; background: rgba(250,204,21,0.15); color: var(--warning); display: flex; align-items: center; justify-content: center; font-weight: 800; font-size: 14px; flex-shrink: 0; }
        .mod-name { font-size: 14px; font-weight: 700; color: var(--text-main); }
        .mod-sub { font-size: 12px; color: var(--text-muted); }
        .mod-time { font-size: 11px; color: var(--text-dim); white-space: nowrap; }

        .label-row { font-size: 11px; font-weight: 700; text-transform: uppercase; color: var(--text-dim); margin-bottom: 6px; letter-spacing: 0.4px; }
        .message-box { background: var(--bg-hover); border: 1px solid var(--border-color); border-radius: 6px; padding: 10px 14px; font-size: 13px; color: var(--text-main); line-height: 1.6; margin-bottom: 14px; white-space: pre-wrap; }
        .reply-box { background: rgba(16,185,129,0.08); border: 1px solid rgba(16,185,129,0.3); border-radius: 6px; padding: 10px 14px; font-size: 13px; color: var(--text-main); line-height: 1.6; margin-bottom: 10px; }

        .status-pill { font-size: 11px; font-weight: 700; padding: 4px 11px; border-radius: 20px; display: inline-block; white-space: nowrap; }
        .status-pill.pending { background: rgba(250,204,21,0.12); border: 1px solid var(--warning); color: var(--warning); }
        .status-pill.processing { background: rgba(59,130,246,0.1); border: 1px solid var(--info); color: var(--info); }
        .status-pill.resolved { background: rgba(16,185,129,0.12); border: 1px solid var(--primary); color: var(--primary); }
        .status-pill.rejected { background: rgba(239,68,68,0.1); border: 1px solid var(--danger); color: var(--danger); }

        .reply-form { display: flex; gap: 8px; margin-top: 10px; }
        .reply-form textarea { flex: 1; min-height: 44px; resize: vertical; padding: 8px 10px; border-radius: 6px; border: 1.5px solid var(--border-color); background: var(--bg-input); color: var(--text-main); font-size: 13px; }
        .reply-actions { display: flex; flex-direction: column; gap: 6px; }
        .btn-approve { background: rgba(32,212,137,0.12); border: 1.5px solid var(--primary); color: var(--primary); padding: 8px 14px; border-radius: 7px; font-size: 12.5px; font-weight: 700; cursor: pointer; transition: 0.15s; white-space: nowrap; }
        .btn-approve:hover { background: var(--primary); color: #0f172a; }
        .btn-reject { background: rgba(239,68,68,0.08); border: 1.5px solid var(--danger); color: var(--danger); padding: 8px 14px; border-radius: 7px; font-size: 12.5px; font-weight: 700; cursor: pointer; transition: 0.15s; white-space: nowrap; }
        .btn-reject:hover { background: var(--danger); color: #fff; }

        .empty-state { text-align: center; padding: 48px 20px; color: var(--text-dim); }
        .empty-state .icon { font-size: 48px; margin-bottom: 12px; }

        @keyframes fadeUp {
            from { opacity: 0; transform: translateY(16px); }
            to   { opacity: 1; transform: translateY(0); }
        }
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
            </li>
        </a>
        <a href="${pageContext.request.contextPath}/super-admin/shipper-requests">
            <li class="menu-item">
                <span class="menu-item-label-group"><span class="menu-icon">🛵</span><span class="menu-label">Duyệt Shipper</span></span>
            </li>
        </a>
        <a href="${pageContext.request.contextPath}/admin/kiem-duyet-noi-dung">
            <li class="menu-item">
                <span class="menu-item-label-group"><span class="menu-icon">🚩</span><span class="menu-label">Kiểm duyệt nội dung</span></span>
            </li>
        </a>
        <a href="${pageContext.request.contextPath}/admin/kiem-duyet-binh-luan">
            <li class="menu-item">
                <span class="menu-item-label-group"><span class="menu-icon">💬</span><span class="menu-label">Kiểm duyệt bình luận</span></span>
            </li>
        </a>
        <a href="${pageContext.request.contextPath}/admin/khieu-nai">
            <li class="menu-item active">
                <span class="menu-item-label-group"><span class="menu-icon">📢</span><span class="menu-label">Quản lý khiếu nại</span></span>
                <c:if test="${pendingCount > 0}">
                    <span class="badge red">${pendingCount}</span>
                </c:if>
            </li>
        </a>
        <a href="${pageContext.request.contextPath}/admin/appeals">
            <li class="menu-item">
                <span class="menu-item-label-group"><span class="menu-icon">📋</span><span class="menu-label">Kháng nghị</span></span>
            </li>
        </a>

        <div class="menu-title">⚙️ CẤU HÌNH & HỆ THỐNG</div>
        <a href="${pageContext.request.contextPath}/quanlitaikhoan">
            <li class="menu-item"><span class="menu-item-label-group"><span class="menu-icon">👤</span><span class="menu-label">Người dùng</span></span></li>
        </a>
    </ul>
</aside>

<main class="main">
    <header class="topbar">
        <h1>📢 Quản lý khiếu nại đơn hàng</h1>
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

        <c:if test="${param.success eq 'resolved'}">
            <div class="alert alert-success" style="background:rgba(16,185,129,.12);border:1px solid var(--primary);color:var(--primary);padding:12px 16px;border-radius:8px;font-size:13px;">✅ Đã đánh dấu khiếu nại là đã giải quyết.</div>
        </c:if>
        <c:if test="${param.success eq 'rejected'}">
            <div style="background:rgba(239,68,68,.1);border:1px solid var(--danger);color:var(--danger);padding:12px 16px;border-radius:8px;font-size:13px;">🚫 Đã từ chối khiếu nại.</div>
        </c:if>
        <c:if test="${param.error eq 'empty_reply'}">
            <div style="background:rgba(239,68,68,.1);border:1px solid var(--danger);color:var(--danger);padding:12px 16px;border-radius:8px;font-size:13px;">⚠️ Vui lòng nhập nội dung phản hồi trước khi xử lý.</div>
        </c:if>

        <div class="panel">
            <div class="panel-title">
                Danh sách khiếu nại
                <c:if test="${not empty complaints}">
                    <span class="badge">${complaints.size()} khiếu nại</span>
                </c:if>
            </div>

            <div class="filter-bar">
                <a href="${pageContext.request.contextPath}/admin/khieu-nai" class="filter-btn ${empty statusFilter ? 'active' : ''}">Tất cả</a>
                <a href="${pageContext.request.contextPath}/admin/khieu-nai?status=PENDING" class="filter-btn ${statusFilter eq 'PENDING' ? 'active' : ''}">⏳ Chờ xử lý</a>
                <a href="${pageContext.request.contextPath}/admin/khieu-nai?status=PROCESSING" class="filter-btn ${statusFilter eq 'PROCESSING' ? 'active' : ''}">🔄 Đang xử lý</a>
                <a href="${pageContext.request.contextPath}/admin/khieu-nai?status=RESOLVED" class="filter-btn ${statusFilter eq 'RESOLVED' ? 'active' : ''}">✅ Đã giải quyết</a>
                <a href="${pageContext.request.contextPath}/admin/khieu-nai?status=REJECTED" class="filter-btn ${statusFilter eq 'REJECTED' ? 'active' : ''}">❌ Từ chối</a>
            </div>

            <div class="mod-list">
                <c:forEach var="c" items="${complaints}">
                    <div class="mod-card ${fn:toLowerCase(c.status)}">
                        <div class="mod-header">
                            <div class="mod-user">
                                <div class="avatar-sm">${fn:toUpperCase(fn:substring(empty c.accountName ? '?' : c.accountName, 0, 1))}</div>
                                <div>
                                    <div class="mod-name">${empty c.accountName ? 'Khách hàng' : c.accountName}</div>
                                    <div class="mod-sub">Khiếu nại đơn <strong>#${c.orderId}</strong> — <c:out value="${c.subject}"/></div>
                                </div>
                            </div>
                            <div style="display:flex;align-items:center;gap:8px;">
                                <span class="status-pill ${fn:toLowerCase(c.status)}">
                                    <c:choose>
                                        <c:when test="${c.status eq 'PENDING'}">⏳ Chờ xử lý</c:when>
                                        <c:when test="${c.status eq 'PROCESSING'}">🔄 Đang xử lý</c:when>
                                        <c:when test="${c.status eq 'RESOLVED'}">✅ Đã giải quyết</c:when>
                                        <c:otherwise>❌ Từ chối</c:otherwise>
                                    </c:choose>
                                </span>
                                <div class="mod-time">${app:formatDateTime(c.createdAt)}</div>
                            </div>
                        </div>

                        <div class="label-row">Nội dung khiếu nại</div>
                        <div class="message-box"><c:out value="${c.content}"/></div>

                        <c:if test="${not empty c.adminReply}">
                            <div class="label-row">Phản hồi của Admin</div>
                            <div class="reply-box"><c:out value="${c.adminReply}"/></div>
                        </c:if>

                        <c:if test="${c.status eq 'PENDING' || c.status eq 'PROCESSING'}">
                            <form method="post" action="${pageContext.request.contextPath}/admin/khieu-nai" class="reply-form">
                                <input type="hidden" name="complaintId" value="${c.id}"/>
                                <textarea name="reply" placeholder="Nhập phản hồi cho khách hàng..." required></textarea>
                                <div class="reply-actions">
                                    <button type="submit" name="action" value="resolve" class="btn-approve">✅ Giải quyết</button>
                                    <button type="submit" name="action" value="reject" class="btn-reject">🚫 Từ chối</button>
                                </div>
                            </form>
                        </c:if>
                    </div>
                </c:forEach>

                <div class="empty-state" style="${empty complaints ? 'display:block;' : 'display:none;'}">
                    <div class="icon">📭</div>
                    <p>Không có khiếu nại nào khớp bộ lọc.</p>
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
            avatarDropdown.addEventListener('click', function(e) { e.stopPropagation(); });
            document.addEventListener('click', function() { avatarDropdown.classList.remove('open'); });
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
</body>
</html>
