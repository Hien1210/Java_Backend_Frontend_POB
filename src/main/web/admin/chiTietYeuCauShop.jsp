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
    <title>Chi tiết yêu cầu shop - Super Admin</title>
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
        function askRejectReason() {
            var reason = prompt("Nhập lý do từ chối yêu cầu shop:");
            if (reason === null) { return false; }
            if (reason.trim() === "") {
                alert("Vui lòng nhập lý do từ chối.");
                return false;
            }
            document.getElementById("rejectionReason").value = reason.trim();
            return true;
        }
    </script>
</head>
<body class="dash-body">

<<<<<<< HEAD
<div class="sidebar-backdrop" id="sidebarBackdrop"></div>
<aside class="sidebar" id="sidebar">
    <div class="sidebar-brand">
        <div class="logo-mark-dash">S</div>
        <div class="brand-text">
            <span class="brand-title">SUPER ADMIN</span>
            <span class="brand-subtitle">👋 ${sessionScope.account.userName}</span>
=======
    <aside class="sidebar" id="sidebarMain">
       <div class="sidebar-brand" style="flex-direction: column; align-items: flex-start; gap: 10px;">
                  <div style="display: flex; align-items: center; gap: 12px; width: 100%;">
                      <div class="logo-icon">S</div>
                      <div class="brand-text">
                          <span class="brand-title">SUPER</span>
                          <span class="brand-subtitle">ADMIN PANEL</span>
                      </div>
                      <span class="badge-system">SYSTEM</span>
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
            <a href="${pageContext.request.contextPath}/admin/doi-soat-doanh-thu-shop" class="menu-item">
                <div class="menu-item-left"><span style="font-size: 16px;">💵</span> <span class="menu-label">Đối soát doanh thu Shop</span></div>
            </a>
            <a href="#" class="menu-item">
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
>>>>>>> ThanhHien_TY00243
        </div>
    </div>
    <div class="menu">
        <div class="menu-title">Quản lý hệ thống</div>
        <a href="${pageContext.request.contextPath}/tong-quan" class="menu-item">
            <span class="mi-left"><span class="mi-icon">⊞</span> Tổng quan hệ thống</span>
        </a>
        <a href="${pageContext.request.contextPath}/super-admin/shop-requests" class="menu-item active">
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
        <a href="${pageContext.request.contextPath}/admin/appeals" class="menu-item">
            <span class="mi-left"><span class="mi-icon">📋</span> Kháng nghị</span>
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
            <h1>🏪 Chi tiết yêu cầu duyệt Shop</h1>
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
        <div>
            <a href="${pageContext.request.contextPath}/super-admin/shop-requests" class="btn btn-ghost">← Quay lại danh sách</a>
        </div>

        <c:if test="${not empty loi}">
            <div class="alert alert-danger">⚠️ <c:out value="${loi}"/></div>
        </c:if>

        <c:if test="${not empty shop}">
            <div>
                <h2 style="font-size:16px;font-weight:800;color:var(--text-main);margin-bottom:4px;">Yêu cầu đăng ký shop — Mã #<c:out value="${shop.id}"/></h2>
                <p style="font-size:13px;color:var(--text-muted);">Xem thông tin chi tiết cửa hàng yêu cầu mở shop.</p>
            </div>

            <div class="info-card" style="max-width:800px;">
                <h3>🏪 Thông tin đăng ký shop</h3>
                <div class="info-row"><div class="info-label">ID</div><div class="info-value"><c:out value="${shop.id}"/></div></div>
                <div class="info-row"><div class="info-label">Tên shop</div><div class="info-value"><c:out value="${shop.shopName}"/></div></div>
                <div class="info-row"><div class="info-label">Mô tả</div><div class="info-value"><c:out value="${shop.shopDescription}"/></div></div>
                <div class="info-row"><div class="info-label">Địa chỉ</div><div class="info-value"><c:out value="${shop.shopAddress}"/></div></div>
                <div class="info-row"><div class="info-label">Số điện thoại</div><div class="info-value"><c:out value="${shop.shopPhone}"/></div></div>
                <div class="info-row"><div class="info-label">Trạng thái</div><div class="info-value"><c:out value="${shop.status}"/></div></div>
                <div class="info-row"><div class="info-label">Ngày tạo</div><div class="info-value"><c:out value="${shop.createdAt}"/></div></div>
            </div>

            <div style="display:flex;gap:14px;flex-wrap:wrap;">
                <form action="${pageContext.request.contextPath}/super-admin/shop-requests" method="post">
                    <input type="hidden" name="action" value="accept">
                    <input type="hidden" name="id" value="${shop.id}">
                    <button type="submit" class="btn btn-success" onclick="return confirm('Xác nhận DUYỆT cửa hàng [${shop.shopName}]?')">✓ Chấp nhận</button>
                </form>
                <form action="${pageContext.request.contextPath}/super-admin/shop-requests" method="post" onsubmit="return askRejectReason()">
                    <input type="hidden" name="action" value="reject">
                    <input type="hidden" name="id" value="${shop.id}">
                    <input type="hidden" name="rejectionReason" id="rejectionReason">
                    <button type="submit" class="btn btn-danger">✕ Từ chối</button>
                </form>
            </div>
        </c:if>

        <c:if test="${empty shop}">
            <div class="empty-state">
                <div class="e-icon">🏪</div>
                <div class="e-title">Không tìm thấy thông tin yêu cầu mở shop.</div>
            </div>
        </c:if>
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
