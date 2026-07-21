<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script>!function(){var t=localStorage.getItem("pob-dashboard-theme")||"light";document.documentElement.setAttribute("data-theme",t)}()</script>
    <title>Hồ sơ tài xế - POB Shipper</title>
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

        .online-toggle-btn { width: 100%; padding: 12px 16px; border-radius: var(--radius-sm); border: none; cursor: pointer; display: flex; align-items: center; gap: 10px; font-size: 13px; font-weight: 700; }
        .online-toggle-btn.is-online { background: var(--success-light); color: var(--success-dark); border: 1.5px solid var(--success); }
        .online-toggle-btn.is-offline { background: var(--danger-light); color: var(--danger); border: 1.5px solid var(--danger); }
        .toggle-dot { width: 10px; height: 10px; border-radius: 50%; flex-shrink: 0; }
        .toggle-dot.online { background: var(--success); animation: pobBlink 1.5s infinite; }
        .toggle-dot.offline { background: var(--danger); }

        /* Avatar hero */
        .profile-hero { background: var(--bg-panel); border: 1px solid var(--border-color); border-radius: var(--radius-lg); padding: 28px; display: flex; align-items: center; gap: 24px; box-shadow: var(--dash-shadow-sm); flex-wrap: wrap; }
        .avatar-hero { width: 88px; height: 88px; border-radius: 50%; object-fit: cover; border: 3px solid var(--primary); background: var(--bg-input); display: flex; align-items: center; justify-content: center; font-size: 36px; font-weight: 800; color: var(--primary); flex-shrink: 0; }
        .avatar-hero img { width: 88px; height: 88px; border-radius: 50%; object-fit: cover; }
        .hero-info h2 { font-size: 20px; font-weight: 800; margin-bottom: 4px; color: var(--text-main); }
        .hero-info .sub { font-size: 13px; color: var(--text-dim); }
        .online-pill { display: inline-flex; align-items: center; gap: 5px; padding: 3px 10px; border-radius: var(--radius-pill); font-size: 11px; font-weight: 700; margin-top: 6px; }
        .online-pill.online { background: var(--success-light); color: var(--success-dark); }
        .online-pill.offline { background: var(--danger-light); color: var(--danger); }

        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }
        .form-grid .form-group.full { grid-column: 1/-1; }
        @media (max-width: 768px) { .form-grid { grid-template-columns: 1fr; } }
    </style>
</head>
<body class="dash-body">

<div class="sidebar-backdrop" id="sidebarBackdrop"></div>
<aside class="sidebar" id="sidebar">
    <div class="sidebar-brand">
        <div class="logo-mark-dash">🛵</div>
        <div class="brand-text">
            <span class="brand-title">POB SHIPPER</span>
            <c:choose>
                <c:when test="${sessionScope.account.online}">
                    <span class="brand-subtitle" style="color:var(--success);">● Đang hoạt động</span>
                </c:when>
                <c:otherwise>
                    <span class="brand-subtitle" style="color:var(--danger);">● Ngoại tuyến</span>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
    <div class="menu">
        <div class="menu-title">Công việc</div>
        <a href="${pageContext.request.contextPath}/shipper/donhang" class="menu-item">
            <span class="mi-left"><span class="mi-icon">📋</span> Đơn hàng nhận</span>
        </a>
        <a href="${pageContext.request.contextPath}/shipper/nhan-don" class="menu-item">
            <span class="mi-left"><span class="mi-icon">📥</span> Nhận đơn mới</span>
        </a>
        <a href="${pageContext.request.contextPath}/shipper/dashboard" class="menu-item">
            <span class="mi-left"><span class="mi-icon">📊</span> Dashboard</span>
        </a>
        <a href="${pageContext.request.contextPath}/shipper/thongbao" class="menu-item">
            <span class="mi-left"><span class="mi-icon">🔔</span> Thông báo</span>
        </a>

        <div class="menu-title">Tài khoản</div>
        <a href="${pageContext.request.contextPath}/shipper/profile" class="menu-item active">
            <span class="mi-left"><span class="mi-icon">🚙</span> Hồ sơ tài xế</span>
        </a>
        <a href="${pageContext.request.contextPath}/shipper/danh-gia" class="menu-item">
            <span class="mi-left"><span class="mi-icon">⭐</span> Đánh giá &amp; Báo cáo</span>
        </a>
    </div>
    <div class="sidebar-foot">
        <form action="${pageContext.request.contextPath}/shipper/status" method="post">
            <c:choose>
                <c:when test="${sessionScope.account.online}">
                    <button type="submit" class="online-toggle-btn is-online"
                            onclick="return confirm('Tắt chế độ Online? Bạn sẽ không nhận đơn mới.')">
                        <span class="toggle-dot online"></span>Đang Online — Nhấn để Offline
                    </button>
                </c:when>
                <c:otherwise>
                    <button type="submit" class="online-toggle-btn is-offline">
                        <span class="toggle-dot offline"></span>Đang Offline — Nhấn để Online
                    </button>
                </c:otherwise>
            </c:choose>
        </form>
    </div>
</aside>

<main class="main">
    <header class="topbar">
        <div style="display:flex;align-items:center;gap:10px;">
            <button type="button" class="menu-toggle-btn" onclick="pobToggleSidebar()">☰</button>
            <h1>👤 Hồ sơ tài xế</h1>
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

        <c:if test="${not empty param.success}">
            <div class="alert alert-success">✅ ${param.success}</div>
        </c:if>
        <c:if test="${not empty param.error}">
            <div class="alert alert-danger">⚠️ ${param.error}</div>
        </c:if>

        <div class="profile-hero">
            <div class="avatar-hero">
                <c:choose>
                    <c:when test="${not empty sessionScope.account.avatarUrl}">
                        <img src="${sessionScope.account.avatarUrl}" alt="Avatar"
                             onerror="this.style.display='none';this.parentNode.innerText='${fn:toUpperCase(fn:substring(sessionScope.account.fullName,0,1))}'"/>
                    </c:when>
                    <c:otherwise>
                        ${fn:toUpperCase(fn:substring(sessionScope.account.fullName,0,1))}
                    </c:otherwise>
                </c:choose>
            </div>
            <div class="hero-info">
                <h2>${sessionScope.account.fullName}</h2>
                <div class="sub">@${sessionScope.account.userName} · ${sessionScope.account.email}</div>
                <div class="sub" style="margin-top:2px;">📞 ${sessionScope.account.phone}</div>
                <c:choose>
                    <c:when test="${sessionScope.account.online}">
                        <span class="online-pill online">● Đang Online</span>
                    </c:when>
                    <c:otherwise>
                        <span class="online-pill offline">● Ngoại tuyến</span>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <div class="panel">
            <div class="panel-header"><div class="panel-title">📝 Thông tin cá nhân</div></div>
            <div class="panel-body">
                <form action="${pageContext.request.contextPath}/shipper/profile" method="post">
                    <input type="hidden" name="action" value="updateInfo"/>
                    <div class="form-grid">
                        <div class="form-group">
                            <label class="form-label">Họ và tên <span class="required">*</span></label>
                            <input type="text" class="form-control" name="fullName" value="${sessionScope.account.fullName}" required placeholder="Nguyễn Văn A"/>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Số điện thoại</label>
                            <input type="text" class="form-control" name="phone" value="${sessionScope.account.phone}" placeholder="0901234567"/>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Email <span class="required">*</span></label>
                            <input type="email" class="form-control" name="email" value="${sessionScope.account.email}" required placeholder="you@example.com"/>
                        </div>
                        <div class="form-group">
                            <label class="form-label">URL ảnh đại diện</label>
                            <input type="url" class="form-control" name="avatarUrl" value="${sessionScope.account.avatarUrl}" placeholder="https://..."/>
                        </div>
                    </div>
                    <button type="submit" class="btn btn-primary" style="margin-top:16px;">💾 Lưu thông tin</button>
                </form>
            </div>
        </div>

        <div class="panel">
            <div class="panel-header"><div class="panel-title">🪪 Giấy tờ nghề nghiệp</div></div>
            <div class="panel-body">
                <form action="${pageContext.request.contextPath}/shipper/profile" method="post">
                    <input type="hidden" name="action" value="updateVehicle"/>
                    <div class="form-grid">
                        <div class="form-group">
                            <label class="form-label">Số CCCD / CMND</label>
                            <input type="text" class="form-control" name="cccd" value="${profile.cccd}" placeholder="0123456789" maxlength="20"/>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Số giấy phép lái xe (GPLX)</label>
                            <input type="text" class="form-control" name="licenseNumber" value="${profile.licenseNumber}" placeholder="010000012345" maxlength="30"/>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Loại phương tiện <span class="required">*</span></label>
                            <select name="vehicleType" class="form-select">
                                <option value="">-- Chọn loại --</option>
                                <c:set var="vt" value="${profile.vehicleType}"/>
                                <option value="Xe máy" ${vt == 'Xe máy' ? 'selected' : ''}>🏍️ Xe máy</option>
                                <option value="Xe đạp điện" ${vt == 'Xe đạp điện' ? 'selected' : ''}>⚡ Xe đạp điện</option>
                                <option value="Xe đạp" ${vt == 'Xe đạp' ? 'selected' : ''}>🚲 Xe đạp</option>
                                <option value="Ô tô" ${vt == 'Ô tô' ? 'selected' : ''}>🚗 Ô tô</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Biển số xe <span class="required">*</span></label>
                            <input type="text" class="form-control" name="vehiclePlate" value="${profile.vehiclePlate}" placeholder="51F-123.45" style="text-transform:uppercase;" maxlength="20"/>
                        </div>
                        <div class="form-group full">
                            <label class="form-label">Nhãn hiệu / Model xe</label>
                            <input type="text" class="form-control" name="vehicleModel" value="${profile.vehicleModel}" placeholder="Honda Wave Alpha 2022"/>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Số tài khoản ngân hàng</label>
                            <input type="text" class="form-control" name="bankAccount" value="${profile.bankAccount}" placeholder="1234567890" maxlength="30"/>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Tên ngân hàng</label>
                            <input type="text" class="form-control" name="bankName" value="${profile.bankName}" placeholder="Vietcombank, MB Bank, ..."/>
                        </div>
                    </div>
                    <button type="submit" class="btn btn-primary" style="margin-top:16px;">💾 Lưu thông tin nghề nghiệp</button>
                </form>
            </div>
        </div>

    </div>
</main>

<div class="avatar-dropdown" id="avatarDropdown">
    <div class="dropdown-header">
        <div class="d-name">${sessionScope.account.userName}</div>
        <div class="d-email">${sessionScope.account.email}</div>
        <span class="d-role">🛵 Shipper</span>
    </div>
    <div class="dropdown-body">
        <a href="${pageContext.request.contextPath}/shipper/ho-so" class="dropdown-link">👤 Hồ sơ cá nhân</a>
        <a href="${pageContext.request.contextPath}/shipper/doi-mat-khau" class="dropdown-link">🔒 Đổi mật khẩu</a>
        <div class="dropdown-divider"></div>
        <a href="${pageContext.request.contextPath}/logout" class="dropdown-link danger">🚪 Đăng xuất</a>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/dashboard-theme.js"></script>
<script>
    var alertBox = document.querySelector('.alert');
    if (alertBox) alertBox.scrollIntoView({ behavior: 'smooth', block: 'nearest' });

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
