<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
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
    <title>Quản lý yêu cầu shop - Super Admin</title>
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
    </style>
    <script>
        function confirmReject(shopId, shopName) {
            let reason = prompt("Vui lòng nhập lý do từ chối duyệt shop [" + shopName + "]:");
            if (reason === null || reason.trim() === "") {
                alert("Thao tác thất bại: Yêu cầu bắt buộc phải nhập lý do từ chối!");
                return false;
            }
            document.getElementById('reason_' + shopId).value = reason;
            return true;
        }
    </script>
</head>
<body>

    <aside class="sidebar" id="sidebarMain">
       <div class="sidebar-brand" style="flex-direction: column; align-items: flex-start; gap: 10px;">
           <div style="display: flex; align-items: center; justify-content: space-between; gap: 12px; width: 100%;">
               <div style="display: flex; align-items: center; gap: 12px;">
                   <div class="logo-icon">S</div>
                   <div class="brand-text">
                       <span class="brand-title">SUPER</span>
                       <span class="brand-subtitle">ADMIN PANEL</span>
                   </div>
                   <span class="badge-system">SYSTEM</span>
               </div>
               <button type="button" class="sidebar-toggle-btn" id="sidebarToggleBtn" title="Thu gọn/mở rộng menu">
                   <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
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
        <div class="menu-section">
            <div class="menu-title">📊 TỔNG QUAN & PHÂN TÍCH</div>
            <a href="${pageContext.request.contextPath}/tong-quan" class="menu-item">
                <div class="menu-item-left"><span style="font-size: 16px;">⊞</span> <span class="menu-label">Tổng quan hệ thống</span></div>
            </a>
            <a href="${pageContext.request.contextPath}/admin/bao-cao-van-hanh" class="menu-item">
                <div class="menu-item-left"><span style="font-size: 16px;">📈</span> <span class="menu-label">Báo cáo vận hành</span></div>
            </a>

            <div class="menu-title" style="margin-top: 25px;">⚖️ KIỂM DUYỆT & ĐIỀU PHỐI</div>
            <a href="${pageContext.request.contextPath}/super-admin/shop-requests" class="menu-item active">
                <div class="menu-item-left"><span style="font-size: 16px;">🏪</span> <span class="menu-label">Duyệt Shop</span></div>
                <c:if test="${shopChoDuyet > 0}">
                    <span class="badge-count green">${shopChoDuyet} mới</span>
                </c:if>
            </a>
            <a href="${pageContext.request.contextPath}/super-admin/shipper-requests" class="menu-item">
                <div class="menu-item-left"><span style="font-size: 16px;">🛵</span> <span class="menu-label">Duyệt Shipper</span></div>
                <c:if test="${not empty pendingShippers}">
                    <span class="badge-count green">${pendingShippers.size()} mới</span>
                </c:if>
            </a>
            <a href="${pageContext.request.contextPath}/admin/kiem-duyet-noi-dung" class="menu-item">
                <div class="menu-item-left"><span style="font-size: 16px;">🚩</span> <span class="menu-label">Kiểm duyệt nội dung</span></div>
            </a>
            <a href="${pageContext.request.contextPath}/admin/kiem-duyet-binh-luan" class="menu-item">
                <div class="menu-item-left"><span style="font-size: 16px;">💬</span> <span class="menu-label">Kiểm duyệt bình luận</span></div>
            </a>
            <a href="${pageContext.request.contextPath}/admin/appeals" class="menu-item">
                <div class="menu-item-left"><span style="font-size: 16px;">📋</span> <span class="menu-label">Kháng nghị</span></div>
                <c:if test="${pendingCount > 0}">
                    <span class="badge-count green">${pendingCount}</span>
                </c:if>
            </a>

            <div class="menu-title" style="margin-top: 25px;">💰 QUẢN LÝ TÀI CHÍNH</div>
            <a href="#" class="menu-item">
                <div class="menu-item-left"><span style="font-size: 16px;">💵</span> <span class="menu-label">Đối soát doanh thu Shop</span></div>
            </a>
            <a href="${pageContext.request.contextPath}/admin/duyet-rut-tien-shipper" class="menu-item">
                <div class="menu-item-left"><span style="font-size: 16px;">💳</span> <span class="menu-label">Duyệt rút tiền Shipper</span></div>
            </a>

            <div class="menu-title" style="margin-top: 25px;">⚙️ CẤU HÌNH & HỆ THỐNG</div>
            <a href="${pageContext.request.contextPath}/quanlitaikhoan" class="menu-item">
                <div class="menu-item-left"><span style="font-size: 16px;">👤</span> <span class="menu-label">Người dùng</span></div>
            </a>
            <a href="#" class="menu-item">
                <div class="menu-item-left"><span style="font-size: 16px;">🛠️</span> <span class="menu-label">Tham số vận hành</span></div>
            </a>
            <a href="#" class="menu-item">
                <div class="menu-item-left"><span style="font-size: 16px;">📢</span> <span class="menu-label">Truyền thông & Banner</span></div>
            </a>
        </div>
    </aside>

<main class="main">
    <header class="topbar">
        <div style="display:flex;align-items:center;gap:10px;">
            <button type="button" class="menu-toggle-btn" onclick="pobToggleSidebar()">☰</button>
            <h1>🏪 Duyệt yêu cầu Shop</h1>
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
        <c:if test="${not empty loi}">
            <div class="alert alert-danger">⚠️ <c:out value="${loi}"/></div>
        </c:if>

        <div class="panel">
            <div class="panel-header">
                <div class="panel-title">🏪 Danh sách yêu cầu duyệt Shop</div>
                <a class="btn btn-sm btn-outline" href="${pageContext.request.contextPath}/quanlitaikhoan">Quản lý tài khoản</a>
            </div>
            <div class="panel-body" style="padding:0;">
                <c:choose>
                    <c:when test="${empty pendingShops}">
                        <div class="empty-state">
                            <div class="e-icon">🏪</div>
                            <div class="e-title">Hiện không có yêu cầu mở Shop nào đang chờ duyệt</div>
                            <div class="e-sub">Shop có trạng thái pending sẽ xuất hiện tại đây.</div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="dash-table-wrap">
                            <table class="dash-table">
                                <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Người đăng ký / Số điện thoại</th>
                                    <th>Email</th>
                                    <th>Ngày đăng ký</th>
                                    <th>Thao tác xử lý</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach var="account" items="${pendingShops}">
                                    <tr>
                                        <td>#<c:out value="${account.id}"/></td>
                                        <td>
                                            <strong style="color:var(--text-main);"><c:out value="${account.fullName}"/></strong><br>
                                            <span style="font-size:12px;color:var(--text-dim);">📞 <c:out value="${account.phone}"/></span>
                                        </td>
                                        <td><c:out value="${account.email}"/></td>
                                        <td><c:out value="${account.createdAt}"/></td>
                                        <td>
                                            <div style="display:flex;gap:8px;flex-wrap:wrap;">
                                                <a class="btn btn-sm btn-outline" href="${pageContext.request.contextPath}/super-admin/shop-requests?action=detail&id=${account.id}">Chi tiết</a>

                                                <form action="${pageContext.request.contextPath}/super-admin/shop-requests" method="post" style="margin:0;">
                                                    <input type="hidden" name="action" value="accept">
                                                    <input type="hidden" name="id" value="${account.id}">
                                                    <button type="submit" class="btn btn-sm btn-success" onclick="return confirm('Xác nhận DUYỆT hoạt động cho tài khoản [ ${account.userName} ]?');">✓ Duyệt</button>
                                                </form>

                                                <form action="${pageContext.request.contextPath}/super-admin/shop-requests" method="post" style="margin:0;" onsubmit="return confirmReject('${account.id}', '${account.userName}')">
                                                    <input type="hidden" name="action" value="reject">
                                                    <input type="hidden" name="id" value="${account.id}">
                                                    <input type="hidden" name="rejectionReason" id="reason_${account.id}" value="">
                                                    <button type="submit" class="btn btn-sm btn-danger-outline">✕ Từ chối</button>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:otherwise>
                </c:choose>
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
