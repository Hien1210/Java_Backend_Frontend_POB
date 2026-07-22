<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

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
    <title>Tổng quan hệ thống - Super Admin</title>
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
        .stat-card.info .stat-icon { background: var(--info-light); color: var(--info); }
        .stat-card.warning .stat-icon { background: var(--warning-light); color: var(--warning-dark); }
        .stat-card.danger .stat-icon { background: var(--danger-light); color: var(--danger); }
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
    <ul class="menu">
            <div class="menu-title">📊 TỔNG QUAN & PHÂN TÍCH</div>
            <a href="${pageContext.request.contextPath}/tong-quan">
                <li class="menu-item active"><span class="menu-item-label-group"><span class="menu-icon">⊞</span><span class="menu-label">Tổng quan hệ thống</span></span></li>
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
            <a href="#">
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
        <div style="display:flex;align-items:center;gap:10px;">
            <button type="button" class="menu-toggle-btn" onclick="pobToggleSidebar()">☰</button>
            <h1>⊞ Tổng quan hệ thống</h1>
        </div>
        <div class="topbar-right">
            <button type="button" class="theme-toggle" id="themeToggleBtn" onclick="pobToggleTheme()" title="Chuyển đổi giao diện"><span data-theme-icon>🌙</span></button>
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
        <div class="stats-grid">
            <div class="stat-card info">
                <div>
                    <div style="font-size:12px;color:var(--text-dim);font-weight:600;">Tổng tài khoản hệ thống</div>
                    <div class="stat-num">${tongTaiKhoan}</div>
                </div>
                <div class="stat-icon">👥</div>
            </div>
            <div class="stat-card warning">
                <div>
                    <div style="font-size:12px;color:var(--text-dim);font-weight:600;">Shop chờ phê duyệt</div>
                    <div class="stat-num">${shopChoDuyet}</div>
                </div>
                <div class="stat-icon">🏪</div>
            </div>
            <div class="stat-card">
                <div>
                    <div style="font-size:12px;color:var(--text-dim);font-weight:600;">Shipper đang hoạt động</div>
                    <div class="stat-num">${shipperHoatDong}</div>
                </div>
                <div class="stat-icon">🛵</div>
            </div>
            <div class="stat-card danger">
                <div>
                    <div style="font-size:12px;color:var(--text-dim);font-weight:600;">Cảnh báo vi phạm</div>
                    <div class="stat-num">${canhBaoViPham}</div>
                </div>
                <div class="stat-icon">⚠️</div>
            </div>
        </div>

        <div class="panel">
            <div class="panel-header">
                <div class="panel-title">📋 Yêu cầu duyệt shop gần đây</div>
            </div>
            <div class="panel-body" style="padding:0;">
                <div class="dash-table-wrap">
                    <table class="dash-table">
                        <thead>
                        <tr>
                            <th>Người đăng ký</th>
                            <th>Email</th>
                            <th>Ngày đăng ký</th>
                            <th>Trạng thái</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="account" items="${top5Shop}">
                            <tr>
                                <td>
                                    <strong style="color: var(--text-main);">${account.fullName}</strong><br>
                                    <span style="font-size: 12px; color: var(--text-dim);">📞 ${account.phone}</span>
                                </td>
                                <td>${account.email}</td>
                                <td>${account.createdAt}</td>
                                <td><span class="badge badge-warning">⏳ Chờ xử lý</span></td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty top5Shop}">
                            <tr>
                                <td colspan="4">
                                    <div class="empty-state" style="padding:36px 24px;">
                                        <div class="e-icon">🏪</div>
                                        <div class="e-title">Chưa có yêu cầu đăng ký shop nào</div>
                                        <div class="e-sub">Bấm vào menu "Duyệt Shop" để xem toàn bộ danh sách.</div>
                                    </div>
                                </td>
                            </tr>
                        </c:if>
                        </tbody>
                    </table>
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
