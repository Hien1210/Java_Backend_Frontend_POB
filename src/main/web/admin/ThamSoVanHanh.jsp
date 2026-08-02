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
    <title>Tham số vận hành - Super Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/theme.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
    <style>
        :root { --primary-hover: var(--primary-dark); --purple: #8b5cf6; }

        .panel { background: var(--bg-panel); border: 1px solid var(--border-color); border-radius: 10px; animation: fadeUp 0.35s ease both; padding: 22px; margin-bottom: 20px; }
        .panel-title { font-size: 14px; font-weight: bold; text-transform: uppercase; border-left: 4px solid var(--primary); padding-left: 10px; color: var(--text-main); margin-bottom: 18px; display: flex; align-items: center; justify-content: space-between; }

        .form-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(260px, 1fr)); gap: 18px 24px; }
        .form-field label { display: block; font-size: 12.5px; font-weight: 700; color: var(--text-muted); margin-bottom: 8px; }
        .form-field .input-wrap { position: relative; }
        .form-field input[type="number"] {
            width: 100%; padding: 10px 14px; border-radius: 8px; border: 1px solid var(--border-color);
            background: var(--bg-input); color: var(--text-main); font-size: 14px; font-weight: 600;
        }
        .form-field input[type="number"]:focus { outline: none; border-color: var(--primary); }
        .form-field .unit { position: absolute; right: 14px; top: 50%; transform: translateY(-50%); font-size: 12px; color: var(--text-dim); font-weight: 700; pointer-events: none; }

        .save-bar { display: flex; justify-content: flex-end; margin-top: 4px; }
        .btn-save { background: var(--primary); color: #ffffff; border: none; padding: 12px 28px; border-radius: 8px; font-size: 14px; font-weight: 800; cursor: pointer; transition: 0.15s; }
        .btn-save:hover { background: var(--primary-hover); }

        @keyframes fadeUp {
            from { opacity: 0; transform: translateY(16px); }
            to   { opacity: 1; transform: translateY(0); }
        }
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
            <span class="brand-subtitle">👋 ${fn:escapeXml(sessionScope.account.userName)}</span>
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
        <a href="${pageContext.request.contextPath}/admin/duyet-rut-tien-shop" class="menu-item">
            <span class="mi-left"><span class="mi-icon">🏪</span><span class="mi-label"> Duyệt rút tiền Shop</span></span>
        </a>
        <a href="${pageContext.request.contextPath}/admin/hoan-tien" class="menu-item">
            <span class="mi-left"><span class="mi-icon">↩️</span><span class="mi-label"> Hoàn tiền khách hàng</span></span>
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
        <a href="${pageContext.request.contextPath}/admin/tham-so-van-hanh" class="menu-item active">
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
            <h1>🛠️ Tham số vận hành</h1>
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
        <form method="post" action="${pageContext.request.contextPath}/admin/tham-so-van-hanh">
<input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">

            <div class="panel">
                <div class="panel-title">💰 Cấu hình Tài chính</div>
                <div class="form-grid">
                    <div class="form-field">
                        <label>Phí hoa hồng thu từ Shop (%)</label>
                        <div class="input-wrap">
                            <input type="number" step="0.01" min="0" max="100" name="commissionPercent" value="${config.commissionPercent}" required>
                            <span class="unit">%</span>
                        </div>
                    </div>
                    <div class="form-field">
                        <label>Phí cố định trên mỗi đơn (đ)</label>
                        <div class="input-wrap">
                            <input type="number" step="1" min="0" name="fixedFeePerOrder" value="${config.fixedFeePerOrder}" required>
                            <span class="unit">đ</span>
                        </div>
                    </div>
                </div>
            </div>

            <div class="panel">
                <div class="panel-title">🛵 Cấu hình Giao hàng</div>
                <div class="form-grid">
                    <div class="form-field">
                        <label>Phí Ship 2km đầu tiên (đ)</label>
                        <div class="input-wrap">
                            <input type="number" step="1" min="0" name="shippingFeeFirst2Km" value="${config.shippingFeeFirst2Km}" required>
                            <span class="unit">đ</span>
                        </div>
                    </div>
                    <div class="form-field">
                        <label>Phí Ship mỗi km tiếp theo (đ)</label>
                        <div class="input-wrap">
                            <input type="number" step="1" min="0" name="shippingFeePerKm" value="${config.shippingFeePerKm}" required>
                            <span class="unit">đ</span>
                        </div>
                    </div>
                    <div class="form-field">
                        <label>Bán kính giao hàng tối đa (km)</label>
                        <div class="input-wrap">
                            <input type="number" step="0.1" min="0" name="maxDeliveryRadiusKm" value="${config.maxDeliveryRadiusKm}" required>
                            <span class="unit">km</span>
                        </div>
                    </div>
                </div>
            </div>

            <div class="panel">
                <div class="panel-title">⏱️ Cấu hình Thời gian</div>
                <div class="form-grid">
                    <div class="form-field">
                        <label>Thời gian Shop phải nhận đơn (Phút)</label>
                        <div class="input-wrap">
                            <input type="number" step="1" min="1" name="shopAcceptOrderMinutes" value="${config.shopAcceptOrderMinutes}" required>
                            <span class="unit">phút</span>
                        </div>
                    </div>
                    <div class="form-field">
                        <label>Thời gian tự động hoàn thành đơn (Giờ)</label>
                        <div class="input-wrap">
                            <input type="number" step="1" min="1" name="autoCompleteOrderHours" value="${config.autoCompleteOrderHours}" required>
                            <span class="unit">giờ</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- PayOS hệ thống (escrow) -->
            <div class="panel" style="margin-top:24px;">
                <div class="panel-title">
                    💳 PayOS Hệ thống (Tài khoản giữ tiền hộ)
                    <span style="font-size:11px;font-weight:400;color:var(--text-muted);">Dùng cho đặt hàng online — tiền khách vào tài khoản này, admin giải ngân cho shop/shipper</span>
                </div>
                <div class="form-grid">
                    <div class="form-field">
                        <label>Client ID</label>
                        <div class="input-wrap">
                            <input type="text" name="payosClientId" value="${config.payosClientId}" placeholder="Nhập Client ID từ PayOS Dashboard" style="width:100%;padding:10px 14px;border:1.5px solid var(--border);border-radius:8px;background:var(--bg-input);color:var(--text-main);font-size:14px;">
                        </div>
                    </div>
                    <div class="form-field">
                        <label>API Key</label>
                        <div class="input-wrap">
                            <input type="text" name="payosApiKey" value="${config.payosApiKey}" placeholder="Nhập API Key từ PayOS Dashboard" style="width:100%;padding:10px 14px;border:1.5px solid var(--border);border-radius:8px;background:var(--bg-input);color:var(--text-main);font-size:14px;">
                        </div>
                    </div>
                    <div class="form-field">
                        <label>Checksum Key</label>
                        <div class="input-wrap">
                            <input type="text" name="payosChecksumKey" value="${config.payosChecksumKey}" placeholder="Nhập Checksum Key từ PayOS Dashboard" style="width:100%;padding:10px 14px;border:1.5px solid var(--border);border-radius:8px;background:var(--bg-input);color:var(--text-main);font-size:14px;">
                        </div>
                    </div>
                </div>
            </div>

            <div class="save-bar">
                <button type="submit" class="btn-save">💾 Lưu thay đổi</button>
            </div>
        </form>
    </div>
</main>

<div class="avatar-dropdown" id="avatarDropdown">
    <div class="dropdown-header">
        <div class="d-name">${fn:escapeXml(sessionScope.account.userName)}</div>
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
    (function () {
        const params = new URLSearchParams(window.location.search);
        const success = params.get('success');
        if (!success || !window.showToast) return;
        if (success === 'saved') window.showToast('success', 'Đã lưu tham số vận hành.');
        else if (success === 'failed') window.showToast('error', 'Lưu thất bại, vui lòng thử lại.');
        else if (success === 'invalid') window.showToast('error', params.get('msg') || 'Giá trị nhập không hợp lệ.');
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
<script src="${pageContext.request.contextPath}/assets/js/toast.js"></script>
</body>
</html>
