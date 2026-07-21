<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>

<c:if test="${empty sessionScope.account || sessionScope.account.roleId != 1}">
    <c:redirect url="/dangnhap"/>
</c:if>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script>!function(){var t=localStorage.getItem("pob-dashboard-theme")||"light";document.documentElement.setAttribute("data-theme",t)}()</script>
    <title>Kháng nghị tài khoản - Super Admin</title>
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

        /* TABS */
        .tab-bar { display: flex; gap: 4px; border-bottom: 1px solid var(--border-color); margin-bottom: 20px; }
        .tab-btn { padding: 10px 18px; font-size: 13px; font-weight: 700; color: var(--text-muted); background: none; border: none; cursor: pointer; border-bottom: 3px solid transparent; }
        .tab-btn:hover { color: var(--text-main); }
        .tab-btn.active { color: var(--primary); border-bottom-color: var(--primary); }
        .tab-panel { display: none; }
        .tab-panel.active { display: block; }

        /* APPEAL CARD */
        .appeal-list { display: flex; flex-direction: column; gap: 14px; }
        .appeal-card { background: var(--bg-input); border: 1px solid var(--border-color); border-radius: var(--radius-md); padding: 18px 20px; animation: pobFadeUp .3s ease both; }
        .appeal-card.pending { border-left: 4px solid var(--warning); }
        .appeal-card.approved { border-left: 4px solid var(--success); }
        .appeal-card.rejected { border-left: 4px solid var(--danger); }

        .appeal-header { display: flex; align-items: flex-start; justify-content: space-between; margin-bottom: 12px; gap: 12px; flex-wrap: wrap; }
        .appeal-user { display: flex; align-items: center; gap: 10px; }
        .avatar-sm { width: 36px; height: 36px; border-radius: 50%; background: var(--warning-light); color: var(--warning-dark); display: flex; align-items: center; justify-content: center; font-weight: 800; font-size: 14px; flex-shrink: 0; }
        .appeal-name { font-size: 14px; font-weight: 700; color: var(--text-main); }
        .appeal-email { font-size: 12px; color: var(--text-muted); }
        .appeal-time { font-size: 11px; color: var(--text-dim); white-space: nowrap; }

        .label-row { font-size: 11px; font-weight: 700; text-transform: uppercase; color: var(--text-dim); margin-bottom: 5px; letter-spacing: .4px; }
        .reason-box { background: var(--danger-light); border: 1px solid rgba(239,68,68,.25); border-radius: 6px; padding: 9px 12px; font-size: 13px; color: var(--text-main); margin-bottom: 12px; }
        .message-box { background: var(--bg-hover); border: 1px solid var(--border-color); border-radius: 6px; padding: 10px 14px; font-size: 13px; color: var(--text-main); line-height: 1.6; margin-bottom: 14px; }
        .admin-reply { background: var(--success-light); border: 1px solid rgba(34,197,94,.25); border-radius: 6px; padding: 9px 12px; font-size: 13px; color: var(--text-main); margin-top: 10px; }

        .admin-note-input { width: 100%; background: var(--bg-input); border: 1px solid var(--border-color); border-radius: 6px; padding: 9px 12px; color: var(--text-main); font-size: 13px; font-family: inherit; resize: vertical; outline: none; margin-bottom: 10px; }
        .admin-note-input:focus { border-color: var(--primary); }

        .action-row { display: flex; gap: 10px; flex-wrap: wrap; }
    </style>
</head>
<body class="dash-body">

<div class="sidebar-backdrop" id="sidebarBackdrop"></div>
<aside class="sidebar" id="sidebar">
    <div class="sidebar-brand">
        <div class="logo-mark-dash">S</div>
        <div class="brand-text">
            <span class="brand-title">SUPER ADMIN</span>
            <span class="brand-subtitle">👋 ${sessionScope.account.userName}</span>
        </div>
    </div>
    <div class="menu">
        <div class="menu-title">Quản lý hệ thống</div>
        <a href="${pageContext.request.contextPath}/tong-quan" class="menu-item">
            <span class="mi-left"><span class="mi-icon">⊞</span> Tổng quan hệ thống</span>
        </a>
        <a href="${pageContext.request.contextPath}/super-admin/shop-requests" class="menu-item">
            <span class="mi-left"><span class="mi-icon">🏪</span> Duyệt Shop</span>
            <c:if test="${shopChoDuyet > 0}"><span class="menu-badge yellow">${shopChoDuyet} mới</span></c:if>
        </a>
        <a href="${pageContext.request.contextPath}/super-admin/shipper-requests" class="menu-item">
            <span class="mi-left"><span class="mi-icon">🛵</span> Duyệt Shipper</span>
        </a>

        <div class="menu-title">Quản lý dữ liệu</div>
        <a href="${pageContext.request.contextPath}/quanlitaikhoan" class="menu-item">
            <span class="mi-left"><span class="mi-icon">👤</span> Người dùng</span>
        </a>
        <a href="${pageContext.request.contextPath}/admin/appeals" class="menu-item active">
            <span class="mi-left"><span class="mi-icon">📋</span> Kháng nghị</span>
            <c:if test="${pendingCount > 0}"><span class="menu-badge" style="background:var(--danger);color:#fff;">${pendingCount}</span></c:if>
        </a>
        <a href="${pageContext.request.contextPath}/Category" class="menu-item">
            <span class="mi-left"><span class="mi-icon">📂</span> Danh mục món ăn</span>
        </a>
        <a href="${pageContext.request.contextPath}/product" class="menu-item">
            <span class="mi-left"><span class="mi-icon">🍽️</span> Sản phẩm</span>
        </a>
    </div>
</aside>

<main class="main">
    <header class="topbar">
        <div style="display:flex;align-items:center;gap:10px;">
            <button type="button" class="menu-toggle-btn" onclick="pobToggleSidebar()">☰</button>
            <h1>📋 Xử lý kháng nghị tài khoản</h1>
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
        <c:if test="${param.success == 'approved'}">
            <div class="alert alert-success">✅ Đã mở lại tài khoản thành công!</div>
        </c:if>
        <c:if test="${param.success == 'rejected'}">
            <div class="alert alert-danger">🚫 Đã từ chối kháng nghị.</div>
        </c:if>

        <div class="panel">
            <div class="panel-header">
                <div class="panel-title">Danh sách kháng nghị</div>
                <c:if test="${pendingCount > 0}">
                    <span class="badge badge-danger">${pendingCount} chờ xử lý</span>
                </c:if>
            </div>
            <div class="panel-body">
                <div class="tab-bar">
                    <button class="tab-btn active" onclick="switchTab('pending')">⏳ Chờ xử lý (${pendingCount})</button>
                    <button class="tab-btn" onclick="switchTab('all')">📂 Tất cả (${allAppeals.size()})</button>
                </div>

                <!-- Tab chờ xử lý -->
                <div class="tab-panel active" id="tab-pending">
                    <c:choose>
                        <c:when test="${empty pendingAppeals}">
                            <div class="empty-state">
                                <div class="e-icon">✅</div>
                                <div class="e-title">Không có kháng nghị nào đang chờ xử lý</div>
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
                                                <span class="badge badge-warning">⏳ Chờ xử lý</span>
                                                <span class="appeal-time">
                                                    ${ap.createdAt.dayOfMonth}/${ap.createdAt.monthValue}/${ap.createdAt.year}
                                                    ${ap.createdAt.hour}:<c:set var="m" value="${ap.createdAt.minute}"/><c:if test="${m < 10}">0</c:if>${m}
                                                </span>
                                            </div>
                                        </div>

                                        <div class="label-row">Lý do bị đình chỉ</div>
                                        <c:choose>
                                            <c:when test="${not empty ap.suspendReason}">
                                                <div class="reason-box">${fn:escapeXml(ap.suspendReason)}</div>
                                            </c:when>
                                            <c:when test="${ap.accountStatus == 'BLOCKED'}">
                                                <div class="reason-box">🚫 Tài khoản bị khoá tự động do bom hàng nhiều lần (quá 6 lần từ chối nhận hàng)</div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="reason-box">Không rõ lý do</div>
                                            </c:otherwise>
                                        </c:choose>

                                        <div class="label-row">Nội dung kháng nghị</div>
                                        <div class="message-box">${fn:escapeXml(ap.message)}</div>

                                        <form method="post" action="${pageContext.request.contextPath}/admin/appeals">
                                            <input type="hidden" name="appealId" value="${ap.id}"/>
                                            <input type="hidden" name="accountId" value="${ap.accountId}"/>
                                            <textarea class="admin-note-input" name="adminNote" rows="2"
                                                placeholder="Ghi chú của Admin (tuỳ chọn)..."></textarea>
                                            <div class="action-row">
                                                <button type="submit" name="action" value="approve" class="btn btn-success">✅ Mở lại tài khoản</button>
                                                <button type="submit" name="action" value="reject" class="btn btn-danger-outline">🚫 Từ chối kháng nghị</button>
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
                                <div class="e-icon">📭</div>
                                <div class="e-title">Chưa có kháng nghị nào</div>
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
                                                    <c:when test="${ap.status == 'PENDING'}"><span class="badge badge-warning">⏳ Chờ xử lý</span></c:when>
                                                    <c:when test="${ap.status == 'APPROVED'}"><span class="badge badge-success">✅ Đã mở lại</span></c:when>
                                                    <c:when test="${ap.status == 'REJECTED'}"><span class="badge badge-danger">🚫 Từ chối</span></c:when>
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
    function switchTab(name) {
        document.querySelectorAll('.tab-btn').forEach(function(b) { b.classList.remove('active'); });
        document.querySelectorAll('.tab-panel').forEach(function(p) { p.classList.remove('active'); });
        document.getElementById('tab-' + name).classList.add('active');
        event.currentTarget.classList.add('active');
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
