<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>

<c:if test="${empty sessionScope.account || sessionScope.account.roleId != 1}">
    <c:redirect url="/dangnhap"/>
</c:if>

<!DOCTYPE html>
<html lang="vi" data-theme="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kháng nghị tài khoản - Super Admin</title>
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

        .sidebar { width: 260px; background-color: var(--bg-sidebar); border-right: 1px solid var(--border-color); display: flex; flex-direction: column; flex-shrink: 0; }
        .brand { padding: 20px; display: flex; flex-direction: column; gap: 10px; border-bottom: 1px solid var(--border-color); }
        .brand-row { display: flex; align-items: center; gap: 12px; }
        .logo { background: var(--primary); color: #fff; width: 32px; height: 32px; border-radius: 6px; display: flex; align-items: center; justify-content: center; font-weight: bold; }
        .brand-title { color: var(--text-main); font-weight: bold; font-size: 14px; }
        .menu { padding: 15px 0; flex: 1; overflow-y: auto; overflow-x: hidden; }
        .menu-title { font-size: 11px; color: var(--text-dim); font-weight: bold; margin: 15px 20px 10px; text-transform: uppercase; }
        .menu-item { padding: 12px 20px; display: flex; align-items: center; justify-content: space-between; color: var(--text-muted); font-size: 14px; transition: all 0.2s; border-left: 3px solid transparent; }
        .menu-item:hover { background-color: var(--bg-input); color: var(--text-main); transform: translateX(4px); }
        .menu-item.active { background-color: var(--primary-light); color: var(--primary); font-weight: 600; }
        .badge { font-size: 10px; padding: 3px 8px; border-radius: 10px; background: var(--border-color); color: var(--text-main); }
        .badge.red { background: var(--danger); color: #fff; font-weight: 700; }

        .main { flex: 1; display: flex; flex-direction: column; overflow: hidden; }
        .topbar { background-color: var(--topbar-bg); backdrop-filter: blur(12px); -webkit-backdrop-filter: blur(12px); padding: 15px 30px; display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid var(--border-color); }
        .topbar h1 { color: var(--text-main); font-size: 18px; font-weight: bold; }
        .topbar-right { display: flex; align-items: center; gap: 15px; }
        .avatar-circle { background: var(--warning); color: #0f172a; width: 36px; height: 36px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: bold; font-size: 13px; }
        .theme-toggle { background: var(--bg-input); border: 1px solid var(--border-color); width: 38px; height: 38px; border-radius: 8px; cursor: pointer; display: flex; align-items: center; justify-content: center; color: var(--text-main); font-size: 16px; }
        .btn-logout { display: flex; align-items: center; gap: 6px; padding: 8px 14px; border-radius: 6px; background: rgba(239,68,68,0.1); color: var(--danger); font-size: 13px; font-weight: 600; }
        .btn-logout:hover { background: var(--danger); color: white; }

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

        /* APPEAL CARD */
        .appeal-list { display: flex; flex-direction: column; gap: 14px; }
        .appeal-card { background: var(--bg-input); border: 1px solid var(--border-color); border-radius: 10px; animation: fadeUp 0.35s ease both; padding: 18px 20px; }
        .appeal-card.pending { border-left: 4px solid var(--warning); }
        .appeal-card.approved { border-left: 4px solid var(--primary); }
        .appeal-card.rejected { border-left: 4px solid var(--danger); }

        .appeal-header { display: flex; align-items: flex-start; justify-content: space-between; margin-bottom: 12px; gap: 12px; }
        .appeal-user { display: flex; align-items: center; gap: 10px; }
        .avatar-sm { width: 36px; height: 36px; border-radius: 50%; background: rgba(250,204,21,0.15); color: var(--warning); display: flex; align-items: center; justify-content: center; font-weight: 800; font-size: 14px; flex-shrink: 0; }
        .appeal-name { font-size: 14px; font-weight: 700; color: var(--text-main); }
        .appeal-email { font-size: 12px; color: var(--text-muted); }
        .appeal-time { font-size: 11px; color: var(--text-dim); white-space: nowrap; }

        .label-row { font-size: 11px; font-weight: 700; text-transform: uppercase; color: var(--text-dim); margin-bottom: 5px; letter-spacing: 0.4px; }
        .reason-box { background: rgba(239,68,68,0.07); border: 1px solid rgba(239,68,68,0.2); border-radius: 6px; padding: 9px 12px; font-size: 13px; color: var(--text-muted); margin-bottom: 12px; }
        .message-box { background: var(--bg-hover); border: 1px solid var(--border-color); border-radius: 6px; padding: 10px 14px; font-size: 13px; color: var(--text-main); line-height: 1.6; margin-bottom: 14px; }

        .status-badge { display: inline-flex; align-items: center; gap: 5px; padding: 4px 12px; border-radius: 20px; font-size: 11px; font-weight: 700; }
        .status-pending { background: rgba(250,204,21,0.12); color: var(--warning); }
        .status-approved { background: rgba(32,212,137,0.12); color: var(--primary); }
        .status-rejected { background: rgba(239,68,68,0.1); color: var(--danger); }

        .admin-note-input { width: 100%; background: var(--bg-input); border: 1px solid var(--border-color); border-radius: 6px; padding: 9px 12px; color: var(--text-main); font-size: 13px; font-family: inherit; resize: vertical; outline: none; margin-bottom: 10px; }
        .admin-note-input:focus { border-color: var(--primary); }

        .action-row { display: flex; gap: 10px; }
        .btn-approve { background: rgba(32,212,137,0.12); border: 1.5px solid var(--primary); color: var(--primary); padding: 8px 18px; border-radius: 7px; font-size: 13px; font-weight: 700; cursor: pointer; transition: 0.15s; }
        .btn-approve:hover { background: var(--primary); color: #0f172a; }
        .btn-reject { background: rgba(239,68,68,0.08); border: 1.5px solid var(--danger); color: var(--danger); padding: 8px 18px; border-radius: 7px; font-size: 13px; font-weight: 700; cursor: pointer; transition: 0.15s; }
        .btn-reject:hover { background: var(--danger); color: #fff; }

        .admin-reply { background: rgba(32,212,137,0.06); border: 1px solid rgba(32,212,137,0.2); border-radius: 6px; padding: 9px 12px; font-size: 13px; color: var(--text-muted); margin-top: 10px; }

        .empty-state { text-align: center; padding: 48px 20px; color: var(--text-dim); }
        .empty-state .icon { font-size: 48px; margin-bottom: 12px; }

        .toast { position: fixed; bottom: 24px; right: 24px; padding: 13px 20px; border-radius: 8px; font-size: 13px; font-weight: 600; z-index: 999; display: none; }
        .toast.success { background: rgba(32,212,137,0.15); border: 1px solid var(--primary); color: var(--primary); }
    
        @keyframes fadeUp {
            from { opacity: 0; transform: translateY(16px); }
            to   { opacity: 1; transform: translateY(0); }
        }        </style>
</head>
<body>

<aside class="sidebar">
    <div class="brand">
        <div class="brand-row">
            <div class="logo">S</div>
            <span class="brand-title">SUPER ADMIN</span>
        </div>
        <div style="font-size:12px;color:var(--text-muted);">
            👋 Hi, <strong style="color:var(--primary);">${sessionScope.account.userName}</strong>
        </div>
    </div>
    <ul class="menu">
        <div class="menu-title">Quản lý hệ thống</div>
        <a href="${pageContext.request.contextPath}/tong-quan">
            <li class="menu-item"><span>⊞ Tổng quan hệ thống</span></li>
        </a>
        <a href="${pageContext.request.contextPath}/super-admin/shop-requests">
            <li class="menu-item"><span>🏪 Duyệt Shop</span></li>
        </a>
        <li class="menu-item"><span>🛵 Duyệt Shipper</span></li>
        <div class="menu-title">Quản lý Dữ liệu</div>
        <a href="${pageContext.request.contextPath}/quanlitaikhoan">
            <li class="menu-item"><span>👤 Người dùng</span></li>
        </a>
        <a href="${pageContext.request.contextPath}/admin/appeals">
            <li class="menu-item active">
                <span>📋 Kháng nghị</span>
                <c:if test="${pendingCount > 0}">
                    <span class="badge red">${pendingCount}</span>
                </c:if>
            </li>
        </a>
        <a href="${pageContext.request.contextPath}/Category">
            <li class="menu-item"><span>📂 Danh mục món ăn</span></li>
        </a>
        <a href="${pageContext.request.contextPath}/product">
            <li class="menu-item"><span>🍽️ Sản phẩm</span></li>
        </a>
    </ul>
</aside>

<main class="main">
    <header class="topbar">
        <h1>📋 Xử lý kháng nghị tài khoản</h1>
        <div class="topbar-right">
            <button class="theme-toggle" id="themeToggleBtn">🌓</button>
            <div class="avatar-circle">${fn:toUpperCase(fn:substring(sessionScope.account.userName, 0, 2))}</div>
            <a href="${pageContext.request.contextPath}/logout" class="btn-logout">🚪 Đăng xuất</a>
        </div>
    </header>

    <div class="content">

        <c:if test="${param.success == 'approved'}">
            <div style="background:rgba(32,212,137,0.1);border:1px solid var(--primary);color:var(--primary);padding:12px 16px;border-radius:8px;font-size:13px;font-weight:600;">
                ✅ Đã mở lại tài khoản thành công!
            </div>
        </c:if>
        <c:if test="${param.success == 'rejected'}">
            <div style="background:rgba(239,68,68,0.08);border:1px solid var(--danger);color:var(--danger);padding:12px 16px;border-radius:8px;font-size:13px;font-weight:600;">
                🚫 Đã từ chối kháng nghị.
            </div>
        </c:if>

        <div class="panel">
            <div class="panel-title">
                Danh sách kháng nghị
                <c:if test="${pendingCount > 0}">
                    <span class="badge red">${pendingCount} chờ xử lý</span>
                </c:if>
            </div>

            <div class="tab-bar">
                <button class="tab-btn active" onclick="switchTab('pending')">⏳ Chờ xử lý (${pendingCount})</button>
                <button class="tab-btn" onclick="switchTab('all')">📂 Tất cả (${allAppeals.size()})</button>
            </div>

            <!-- Tab chờ xử lý -->
            <div class="tab-panel active" id="tab-pending">
                <c:choose>
                    <c:when test="${empty pendingAppeals}">
                        <div class="empty-state">
                            <div class="icon">✅</div>
                            <p>Không có kháng nghị nào đang chờ xử lý</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="appeal-list">
                            <c:forEach var="ap" items="${pendingAppeals}">
                                <div class="appeal-card pending">
                                    <div class="appeal-header">
                                        <div class="appeal-user">
                                            <div class="avatar-sm">${fn:toUpperCase(fn:substring(ap.username, 0, 1))}</div>
                                            <div>
                                                <div class="appeal-name">${ap.username}
                                                    <c:if test="${not empty ap.fullName}">
                                                        <span style="font-weight:400;font-size:12px;color:var(--text-muted);">(${ap.fullName})</span>
                                                    </c:if>
                                                </div>
                                                <div class="appeal-email">${ap.email}</div>
                                            </div>
                                        </div>
                                        <div style="display:flex;flex-direction:column;align-items:flex-end;gap:4px;">
                                            <span class="status-badge status-pending">⏳ Chờ xử lý</span>
                                            <span class="appeal-time">
                                                ${ap.createdAt.dayOfMonth}/${ap.createdAt.monthValue}/${ap.createdAt.year}
                                                ${ap.createdAt.hour}:<c:set var="m" value="${ap.createdAt.minute}"/><c:if test="${m < 10}">0</c:if>${m}
                                            </span>
                                        </div>
                                    </div>

                                    <div class="label-row">Lý do bị đình chỉ</div>
                                    <div class="reason-box">${fn:escapeXml(ap.suspendReason)}</div>

                                    <div class="label-row">Nội dung kháng nghị</div>
                                    <div class="message-box">${fn:escapeXml(ap.message)}</div>

                                    <form method="post" action="${pageContext.request.contextPath}/admin/appeals">
                                        <input type="hidden" name="appealId" value="${ap.id}"/>
                                        <input type="hidden" name="accountId" value="${ap.accountId}"/>
                                        <textarea class="admin-note-input" name="adminNote" rows="2"
                                            placeholder="Ghi chú của Admin (tuỳ chọn)..."></textarea>
                                        <div class="action-row">
                                            <button type="submit" name="action" value="approve" class="btn-approve">
                                                ✅ Mở lại tài khoản
                                            </button>
                                            <button type="submit" name="action" value="reject" class="btn-reject">
                                                🚫 Từ chối kháng nghị
                                            </button>
                                        </div>
                                    </form>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Tab tất cả -->
            <div class="tab-panel" id="tab-all">
                <c:choose>
                    <c:when test="${empty allAppeals}">
                        <div class="empty-state">
                            <div class="icon">📭</div>
                            <p>Chưa có kháng nghị nào</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="appeal-list">
                            <c:forEach var="ap" items="${allAppeals}">
                                <div class="appeal-card ${fn:toLowerCase(ap.status)}">
                                    <div class="appeal-header">
                                        <div class="appeal-user">
                                            <div class="avatar-sm">${fn:toUpperCase(fn:substring(ap.username, 0, 1))}</div>
                                            <div>
                                                <div class="appeal-name">${ap.username}</div>
                                                <div class="appeal-email">${ap.email}</div>
                                            </div>
                                        </div>
                                        <div style="display:flex;flex-direction:column;align-items:flex-end;gap:4px;">
                                            <c:choose>
                                                <c:when test="${ap.status == 'PENDING'}"><span class="status-badge status-pending">⏳ Chờ xử lý</span></c:when>
                                                <c:when test="${ap.status == 'APPROVED'}"><span class="status-badge status-approved">✅ Đã mở lại</span></c:when>
                                                <c:when test="${ap.status == 'REJECTED'}"><span class="status-badge status-rejected">🚫 Từ chối</span></c:when>
                                            </c:choose>
                                            <span class="appeal-time">
                                                ${ap.createdAt.dayOfMonth}/${ap.createdAt.monthValue}/${ap.createdAt.year}
                                                ${ap.createdAt.hour}:<c:set var="m" value="${ap.createdAt.minute}"/><c:if test="${m < 10}">0</c:if>${m}
                                            </span>
                                        </div>
                                    </div>
                                    <div class="label-row">Nội dung kháng nghị</div>
                                    <div class="message-box">${fn:escapeXml(ap.message)}</div>
                                    <c:if test="${not empty ap.adminNote}">
                                        <div class="label-row">Ghi chú Admin</div>
                                        <div class="admin-reply">${fn:escapeXml(ap.adminNote)}</div>
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

<div class="toast success" id="toastEl"></div>

<script>
    const html = document.documentElement;
    const saved = localStorage.getItem('adminTheme') || 'dark';
    html.setAttribute('data-theme', saved);
    document.getElementById('themeToggleBtn').addEventListener('click', () => {
        const next = html.getAttribute('data-theme') === 'dark' ? 'light' : 'dark';
        html.setAttribute('data-theme', next);
        localStorage.setItem('adminTheme', next);
    });

    function switchTab(name) {
        document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
        document.querySelectorAll('.tab-panel').forEach(p => p.classList.remove('active'));
        document.getElementById('tab-' + name).classList.add('active');
        event.currentTarget.classList.add('active');
    }
</script>
</body>
</html>


