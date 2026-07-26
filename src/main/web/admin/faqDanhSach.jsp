<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<c:if test="${empty sessionScope.account || sessionScope.account.roleId != 1}">
    <c:redirect url="/dangnhap"/>
</c:if>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script>!function(){var t=localStorage.getItem("pob-dashboard-theme")||"light";document.documentElement.setAttribute("data-theme",t)}()</script>
    <title>FAQ / Hướng dẫn - Super Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/theme.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
    <style>
        .avatar-wrapper { position: relative; }
        .avatar-dropdown { display: none; position: fixed; background: var(--bg-panel); border: 1px solid var(--border-color); border-radius: 12px; box-shadow: var(--dash-shadow-md); min-width: 220px; z-index: 500; }
        .avatar-dropdown.open { display: block; }
        .dropdown-header { padding: 14px 16px; border-bottom: 1px solid var(--border-color); }
        .dropdown-header .d-name { font-size: 14px; font-weight: 700; color: var(--text-main); }
        .dropdown-header .d-email { font-size: 12px; color: var(--text-muted); margin-top: 2px; }
        .dropdown-body { padding: 6px 0 8px; }
        .dropdown-link { display: flex; align-items: center; gap: 10px; padding: 10px 16px; font-size: 13px; color: var(--text-muted); cursor: pointer; }
        .dropdown-link:hover { background: var(--bg-input); color: var(--text-main); }
        .dropdown-divider { height: 1px; background: var(--border-color); margin: 4px 0; }
        .dropdown-link.danger { color: var(--danger); }

        .panel { padding: 22px; margin-bottom: 20px; }
        .toolbar { display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px; }
        .cell-question { max-width: 360px; }
        .badge-category { display: inline-block; font-size: 11px; font-weight: 700; padding: 3px 10px; border-radius: 20px; background: var(--primary-light); color: var(--primary); white-space: nowrap; }
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
        <a href="${pageContext.request.contextPath}/admin/heatmap-don-hang" class="menu-item">
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
        <a href="${pageContext.request.contextPath}/admin/faq" class="menu-item active">
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
            <h1>❓ FAQ / Hướng dẫn</h1>
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

        <c:if test="${param.success == 'insert'}"><div class="alert alert-success">✅ Đã tạo FAQ thành công!</div></c:if>
        <c:if test="${param.success == 'update'}"><div class="alert alert-success">✅ Đã cập nhật FAQ thành công!</div></c:if>
        <c:if test="${param.success == 'delete'}"><div class="alert alert-success">✅ Đã xoá FAQ thành công!</div></c:if>
        <c:if test="${param.error == 'delete'}"><div class="alert alert-danger">⚠️ Xoá FAQ thất bại, vui lòng thử lại.</div></c:if>
        <c:if test="${not empty loi}"><div class="alert alert-danger">⚠️ <c:out value="${loi}"/></div></c:if>

        <div class="toolbar">
            <div style="font-size:13px;color:var(--text-muted);">Tổng số: <strong>${danhSachFaq.size()}</strong> FAQ</div>
            <a href="${pageContext.request.contextPath}/admin/faq?action=new" class="btn btn-primary">+ Thêm FAQ</a>
        </div>

        <div class="panel">
            <div class="panel-title" style="margin-bottom: 16px;">Danh sách FAQ / Hướng dẫn</div>

            <div class="dash-table-wrap">
                <table class="dash-table">
                    <thead>
                        <tr>
                            <th>STT</th>
                            <th>Câu hỏi</th>
                            <th>Danh mục</th>
                            <th>Thứ tự hiển thị</th>
                            <th>Người tạo</th>
                            <th>Ngày tạo</th>
                            <th>Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty danhSachFaq}">
                                <tr><td colspan="7" class="empty-state">Chưa có FAQ nào.</td></tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="f" items="${danhSachFaq}" varStatus="st">
                                    <tr>
                                        <td>${st.index + 1}</td>
                                        <td class="cell-question">${fn:escapeXml(f.question)}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty f.category}"><span class="badge-category">${fn:escapeXml(f.category)}</span></c:when>
                                                <c:otherwise><span style="color:var(--text-dim);">—</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>${f.displayOrder}</td>
                                        <td>${not empty f.createdByName ? f.createdByName : '—'}</td>
                                        <td style="color:var(--text-muted);font-size:12px;">${f.createdAt}</td>
                                        <td style="white-space:nowrap;">
                                            <a href="${pageContext.request.contextPath}/admin/faq?action=edit&id=${f.id}" class="btn btn-sm btn-ghost">✏️ Sửa</a>
                                            <form method="post" action="${pageContext.request.contextPath}/admin/faq" style="display:inline;" onsubmit="return confirm('Xoá FAQ này?');">
                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="id" value="${f.id}">
                                                <button type="submit" class="btn btn-sm btn-danger">🗑️ Xoá</button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
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
