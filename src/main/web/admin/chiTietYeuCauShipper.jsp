<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:if test="${empty sessionScope.account || sessionScope.account.roleId != 1}">
    <c:redirect url="/dangnhap"/>
</c:if>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script>!function(){var t=localStorage.getItem("pob-dashboard-theme")||"light";document.documentElement.setAttribute("data-theme",t)}()</script>
    <title>Chi tiết Shipper - Super Admin</title>
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
        function confirmReject() {
            return confirm('Xác nhận TỪ CHỐI tài khoản shipper này?\nTài khoản sẽ bị khóa (BLOCKED).');
        }
    </script>
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
        <a href="${pageContext.request.contextPath}/super-admin/shipper-requests" class="menu-item active">
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
        <a href="${pageContext.request.contextPath}/admin/faq" class="menu-item">
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
            <h1>🛵 Chi tiết yêu cầu duyệt Shipper</h1>
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
            <a href="${pageContext.request.contextPath}/super-admin/shipper-requests" class="btn btn-ghost">← Quay lại danh sách</a>
        </div>

        <c:if test="${not empty loi}"><div class="alert alert-danger">⚠️ <c:out value="${loi}"/></div></c:if>

        <c:if test="${not empty shipper}">
            <div style="display:flex;align-items:center;gap:12px;">
                <h2 style="font-size:16px;font-weight:800;color:var(--text-main);">Chi tiết Shipper #<c:out value="${shipper.id}"/></h2>
                <span class="badge badge-warning">⏳ PENDING</span>
            </div>

            <div class="detail-grid">
                <div class="info-card">
                    <h3>👤 Thông tin tài khoản</h3>
                    <div class="info-row"><div class="info-label">Họ tên</div><div class="info-value"><c:out value="${shipper.fullName}"/></div></div>
                    <div class="info-row"><div class="info-label">Username</div><div class="info-value">@<c:out value="${shipper.userName}"/></div></div>
                    <div class="info-row"><div class="info-label">Email</div><div class="info-value"><c:out value="${shipper.email}"/></div></div>
                    <div class="info-row"><div class="info-label">Số điện thoại</div><div class="info-value"><c:out value="${shipper.phone}"/></div></div>
                    <div class="info-row"><div class="info-label">Ngày đăng ký</div><div class="info-value"><c:out value="${shipper.createdAt}"/></div></div>
                </div>

                <div class="info-card">
                    <h3>🛵 Thông tin shipper</h3>
                    <c:choose>
                        <c:when test="${not empty profile}">
                            <div class="info-row"><div class="info-label">CCCD</div><div class="info-value"><c:out value="${empty profile.cccd ? '(chưa cung cấp)' : profile.cccd}"/></div></div>
                            <div class="info-row"><div class="info-label">Số GPLX</div><div class="info-value"><c:out value="${empty profile.licenseNumber ? '(chưa cung cấp)' : profile.licenseNumber}"/></div></div>
                            <div class="info-row"><div class="info-label">Loại xe</div><div class="info-value"><c:out value="${empty profile.vehicleType ? '(chưa cung cấp)' : profile.vehicleType}"/></div></div>
                            <div class="info-row"><div class="info-label">Biển số xe</div><div class="info-value"><c:out value="${empty profile.vehiclePlate ? '(chưa cung cấp)' : profile.vehiclePlate}"/></div></div>
                            <div class="info-row"><div class="info-label">Model xe</div><div class="info-value"><c:out value="${empty profile.vehicleModel ? '(chưa cung cấp)' : profile.vehicleModel}"/></div></div>
                            <div class="info-row"><div class="info-label">Số tài khoản NH</div><div class="info-value"><c:out value="${empty profile.bankAccount ? '(chưa cung cấp)' : profile.bankAccount}"/></div></div>
                            <div class="info-row"><div class="info-label">Ngân hàng</div><div class="info-value"><c:out value="${empty profile.bankName ? '(chưa cung cấp)' : profile.bankName}"/></div></div>
                        </c:when>
                        <c:otherwise>
                            <p style="color:var(--text-dim);font-style:italic;font-size:13px;">Shipper chưa cung cấp thông tin chi tiết.</p>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="info-card" style="grid-column:1/-1;">
                    <h3>🪪 Giấy tờ đối chiếu</h3>
                    <div style="display:flex;gap:16px;flex-wrap:wrap;">
                        <div style="flex:1;min-width:200px;">
                            <div class="info-label" style="margin-bottom:8px;">Ảnh CCCD / CMND - Mặt trước</div>
                            <c:choose>
                                <c:when test="${not empty profile.idCardFrontUrl}">
                                    <a href="${profile.idCardFrontUrl}" target="_blank">
                                        <img src="${profile.idCardFrontUrl}" alt="CCCD mặt trước" style="width:100%;max-width:260px;border-radius:8px;border:1px solid var(--border-color);"/>
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <p style="color:var(--text-dim);font-style:italic;font-size:13px;">Chưa upload ảnh CCCD mặt trước.</p>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div style="flex:1;min-width:200px;">
                            <div class="info-label" style="margin-bottom:8px;">Ảnh CCCD / CMND - Mặt sau</div>
                            <c:choose>
                                <c:when test="${not empty profile.idCardBackUrl}">
                                    <a href="${profile.idCardBackUrl}" target="_blank">
                                        <img src="${profile.idCardBackUrl}" alt="CCCD mặt sau" style="width:100%;max-width:260px;border-radius:8px;border:1px solid var(--border-color);"/>
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <p style="color:var(--text-dim);font-style:italic;font-size:13px;">Chưa upload ảnh CCCD mặt sau.</p>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div style="flex:1;min-width:200px;">
                            <div class="info-label" style="margin-bottom:8px;">Ảnh GPLX - Mặt trước</div>
                            <c:choose>
                                <c:when test="${not empty profile.licenseFrontUrl}">
                                    <a href="${profile.licenseFrontUrl}" target="_blank">
                                        <img src="${profile.licenseFrontUrl}" alt="GPLX mặt trước" style="width:100%;max-width:260px;border-radius:8px;border:1px solid var(--border-color);"/>
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <p style="color:var(--text-dim);font-style:italic;font-size:13px;">Chưa upload ảnh GPLX mặt trước.</p>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div style="flex:1;min-width:200px;">
                            <div class="info-label" style="margin-bottom:8px;">Ảnh GPLX - Mặt sau</div>
                            <c:choose>
                                <c:when test="${not empty profile.licenseBackUrl}">
                                    <a href="${profile.licenseBackUrl}" target="_blank">
                                        <img src="${profile.licenseBackUrl}" alt="GPLX mặt sau" style="width:100%;max-width:260px;border-radius:8px;border:1px solid var(--border-color);"/>
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <p style="color:var(--text-dim);font-style:italic;font-size:13px;">Chưa upload ảnh GPLX mặt sau.</p>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>

            <div style="display:flex;gap:14px;flex-wrap:wrap;align-items:flex-start;">
                <form action="${pageContext.request.contextPath}/super-admin/shipper-requests" method="post">
<input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                    <input type="hidden" name="action" value="accept">
                    <input type="hidden" name="id" value="${shipper.id}">
                    <button type="submit" class="btn btn-success" onclick="return confirm('Xác nhận DUYỆT shipper [${shipper.userName}]?')">✓ Chấp nhận</button>
                </form>
                <form action="${pageContext.request.contextPath}/super-admin/shipper-requests" method="post" style="display:flex;gap:8px;flex-wrap:wrap;align-items:flex-start;">
<input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                    <input type="hidden" name="action" value="reject">
                    <input type="hidden" name="id" value="${shipper.id}">
                    <input type="text" name="reason" class="form-control" placeholder="Lý do từ chối (không bắt buộc)..." style="flex:1;min-width:260px;width:auto;">
                    <button type="submit" class="btn btn-danger" onclick="return confirmReject()">✕ Từ chối</button>
                </form>
            </div>
        </c:if>

        <c:if test="${empty shipper}">
            <div class="empty-state">
                <div class="e-icon">🛵</div>
                <div class="e-title">Không tìm thấy thông tin shipper.</div>
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
<script src="${pageContext.request.contextPath}/assets/js/pixel-cat.js"></script>
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
