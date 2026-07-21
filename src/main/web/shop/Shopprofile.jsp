<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<c:set var="currentShop" value="${sessionScope.currentShop}" scope="request"/>

<%-- BẢO MẬT: KIỂM TRA QUYỀN SHOP (roleId = 2) --%>
<c:if test="${empty sessionScope.account || sessionScope.account.roleId != 2}">
    <c:redirect url="/dangnhap"/>
</c:if>

<!DOCTYPE html>
<html lang="vi" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thông tin cửa hàng - ${not empty currentShop.shopName ? currentShop.shopName : 'Cửa hàng'}</title>
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

        /* Layout 2 cột: form chỉnh sửa + panel tổng quan */
        .page-grid { display: grid; grid-template-columns: 1fr 360px; gap: 24px; align-items: start; }
        @media (max-width: 960px) { .page-grid { grid-template-columns: 1fr; } }
        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }
        .form-full { grid-column: 1 / -1; }
        .secret-field { display: flex; gap: 8px; align-items: center; }
        .secret-field .form-control { flex: 1; }
        .btn-toggle-secret { flex-shrink: 0; width: 40px; height: 40px; border: 1px solid var(--border-color); border-radius: var(--radius-sm); background: var(--bg-input); cursor: pointer; font-size: 16px; }
        .btn-toggle-secret:hover { background: var(--border-color); }

        .logo-preview-wrap { display: flex; flex-direction: column; align-items: center; gap: 14px; margin-bottom: 20px; }
        .logo-preview { width: 120px; height: 120px; border-radius: var(--radius-lg); border: 2px dashed var(--border-color); background: var(--bg-input); display: flex; align-items: center; justify-content: center; overflow: hidden; font-size: 40px; color: var(--text-dim); }
        .logo-preview img { width: 100%; height: 100%; object-fit: cover; }

        .profile-info-row { display: flex; justify-content: space-between; align-items: center; padding: 10px 0; border-bottom: 1px solid var(--border-color); font-size: 13px; gap: 10px; }
        .profile-info-row:last-child { border-bottom: none; }
        .profile-info-row .lbl { color: var(--text-muted); font-weight: 600; }
        .profile-info-row .val { color: var(--text-main); font-weight: 700; text-align: right; }
        .reject-box { background: var(--danger-light); border: 1px solid var(--danger); border-radius: var(--radius-sm); padding: 12px 14px; margin-top: 14px; font-size: 12px; color: var(--danger); line-height: 1.6; }
        .reject-box strong { display: block; margin-bottom: 4px; }
    </style>
</head>
<body class="dash-body">

<div class="sidebar-backdrop" id="sidebarBackdrop"></div>
<aside class="sidebar" id="sidebar">
    <div class="sidebar-brand">
        <div class="logo-mark-dash">🍔</div>
        <div class="brand-text">
            <span class="brand-title">${not empty currentShop.shopName ? currentShop.shopName : 'CỬA HÀNG'}</span>
            <span class="brand-subtitle">👋 ${sessionScope.account.userName}</span>
        </div>
    </div>
    <div class="menu">
        <div class="menu-title">Tổng quan</div>
        <a href="${pageContext.request.contextPath}/shop" class="menu-item">
            <span class="mi-left"><span class="mi-icon">📊</span> Trang chủ</span>
        </a>

        <div class="menu-title">Sản phẩm</div>
        <a href="${pageContext.request.contextPath}/shop/products" class="menu-item">
            <span class="mi-left"><span class="mi-icon">🍽️</span> Quản lý sản phẩm</span>
        </a>
        <a href="${pageContext.request.contextPath}/shop/product-types" class="menu-item">
            <span class="mi-left"><span class="mi-icon">📂</span> Quản lý loại sản phẩm</span>
        </a>

        <div class="menu-title">Topping</div>
        <a href="${pageContext.request.contextPath}/shop/toppings" class="menu-item">
            <span class="mi-left"><span class="mi-icon">🧂</span> Quản lý Topping</span>
        </a>
        <a href="${pageContext.request.contextPath}/shop/topping-categories" class="menu-item">
            <span class="mi-left"><span class="mi-icon">🏷️</span> Quản lý loại Topping</span>
        </a>

        <div class="menu-title">Đơn hàng</div>
        <a href="${pageContext.request.contextPath}/shop/pos" class="menu-item">
            <span class="mi-left"><span class="mi-icon">🧾</span> Bấm Bill</span>
        </a>
        <a href="${pageContext.request.contextPath}/shop/bills" class="menu-item">
            <span class="mi-left"><span class="mi-icon">📋</span> Quản lý hóa đơn</span>
        </a>

        <div class="menu-title">Cửa hàng</div>
        <a href="${pageContext.request.contextPath}/shop/profile" class="menu-item active">
            <span class="mi-left"><span class="mi-icon">🏪</span> Thông tin cửa hàng</span>
        </a>
        <a href="${pageContext.request.contextPath}/shop/danh-gia" class="menu-item">
            <span class="mi-left"><span class="mi-icon">⭐</span> Xem đánh giá</span>
        </a>
    </div>
</aside>

<main class="main">
    <header class="topbar">
        <div style="display:flex;align-items:center;gap:10px;">
            <button type="button" class="menu-toggle-btn" onclick="pobToggleSidebar()">☰</button>
            <h1>🏪 Thông tin cửa hàng của tôi</h1>
        </div>
        <div class="topbar-right">
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
        <c:if test="${param.success eq 'update'}">
            <div class="alert alert-success">✅ Cập nhật thông tin cửa hàng thành công!</div>
        </c:if>
        <c:if test="${not empty loi}">
            <div class="alert alert-danger">⚠️ <c:out value="${loi}"/></div>
        </c:if>

        <c:set var="formShop" value="${not empty shopForm ? shopForm : currentShop}"/>

        <div class="page-grid">
            <section class="panel">
                <div class="panel-header"><div class="panel-title">✏️ Chỉnh sửa thông tin cửa hàng</div></div>
                <div class="panel-body">
                    <form action="${pageContext.request.contextPath}/shop/profile" method="post" id="shopProfileForm">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="id" value="${currentShop.id}">

                        <div class="form-grid">
                            <div class="form-group form-full">
                                <label class="form-label" for="shopName">Tên cửa hàng <span class="required">*</span></label>
                                <input type="text" id="shopName" name="shopName" class="form-control"
                                       value="${fn:escapeXml(formShop.shopName)}"
                                       placeholder="Ví dụ: Quán Cơm Tấm Cô Ba..."
                                       required autofocus>
                            </div>

                            <div class="form-group form-full">
                                <label class="form-label" for="shopDescription">Mô tả cửa hàng</label>
                                <textarea id="shopDescription" name="shopDescription" class="form-control form-textarea"
                                          placeholder="Giới thiệu ngắn về cửa hàng của bạn..."><c:out value="${formShop.shopDescription}"/></textarea>
                            </div>

                            <div class="form-group form-full">
                                <label class="form-label" for="shopAddress">Địa chỉ <span class="required">*</span></label>
                                <input type="text" id="shopAddress" name="shopAddress" class="form-control"
                                       value="${fn:escapeXml(formShop.shopAddress)}"
                                       placeholder="Số nhà, đường, quận/huyện, tỉnh/thành..."
                                       required>
                            </div>

                            <div class="form-group">
                                <label class="form-label" for="shopPhone">Số điện thoại <span class="required">*</span></label>
                                <input type="text" id="shopPhone" name="shopPhone" class="form-control"
                                       value="${fn:escapeXml(formShop.shopPhone)}"
                                       placeholder="09xx xxx xxx"
                                       required>
                            </div>

                            <div class="form-group">
                                <label class="form-label" for="shopLogo">URL ảnh Logo</label>
                                <input type="text" id="shopLogo" name="shopLogo" class="form-control"
                                       value="${fn:escapeXml(formShop.shopLogo)}"
                                       placeholder="https://..."
                                       oninput="previewLogo(this.value)">
                                <div class="form-hint">Dán đường dẫn ảnh logo để hiển thị bên cạnh.</div>
                            </div>

                            <div class="form-group form-full">
                                <label class="form-label" for="clientKey">Client ID</label>
                                <div class="secret-field">
                                    <input type="password" id="clientKey" name="clientKey" class="form-control"
                                           value="${fn:escapeXml(formShop.clientKey)}"
                                           placeholder="Client ID dùng cho cổng thanh toán..." autocomplete="off">
                                    <button type="button" class="btn-toggle-secret" onclick="toggleSecret('clientKey', this)">👁</button>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="form-label" for="apiKey">API Key</label>
                                <div class="secret-field">
                                    <input type="password" id="apiKey" name="apiKey" class="form-control"
                                           value="${fn:escapeXml(formShop.apiKey)}"
                                           placeholder="API Key..." autocomplete="off">
                                    <button type="button" class="btn-toggle-secret" onclick="toggleSecret('apiKey', this)">👁</button>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="form-label" for="checkSumKey">Checksum Key</label>
                                <div class="secret-field">
                                    <input type="password" id="checkSumKey" name="checkSumKey" class="form-control"
                                           value="${fn:escapeXml(formShop.checkSumKey)}"
                                           placeholder="Checksum Key..." autocomplete="off">
                                    <button type="button" class="btn-toggle-secret" onclick="toggleSecret('checkSumKey', this)">👁</button>
                                </div>
                            </div>
                        </div>

                        <div style="display:flex;gap:10px;margin-top:8px;flex-wrap:wrap;">
                            <button type="submit" class="btn btn-primary">💾 Lưu thay đổi</button>
                            <a href="${pageContext.request.contextPath}/shop" class="btn btn-ghost">✕ Hủy</a>
                        </div>
                    </form>
                </div>
            </section>

            <section class="panel">
                <div class="panel-header"><div class="panel-title">📋 Tổng quan</div></div>
                <div class="panel-body">
                    <div class="logo-preview-wrap">
                        <div class="logo-preview" id="logoPreview">
                            <c:choose>
                                <c:when test="${not empty currentShop.shopLogo}">
                                    <img src="${currentShop.shopLogo}" alt="Logo" onerror="this.parentNode.innerHTML='🏪'">
                                </c:when>
                                <c:otherwise>🏪</c:otherwise>
                            </c:choose>
                        </div>
                        <c:choose>
                            <c:when test="${fn:toUpperCase(currentShop.status) == 'APPROVED' || fn:toUpperCase(currentShop.status) == 'ACCEPT' || fn:toUpperCase(currentShop.status) == 'ACTIVE'}">
                                <span class="badge badge-success">✅ Đã duyệt - Đang hoạt động</span>
                            </c:when>
                            <c:when test="${fn:toUpperCase(currentShop.status) == 'REJECT' || fn:toUpperCase(currentShop.status) == 'REJECTED'}">
                                <span class="badge badge-danger">✕ Bị từ chối</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge badge-warning">⏳ Chờ duyệt</span>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div class="profile-info-row"><span class="lbl">Mã cửa hàng</span><span class="val">#${currentShop.id}</span></div>
                    <div class="profile-info-row"><span class="lbl">Tên cửa hàng</span><span class="val"><c:out value="${currentShop.shopName}"/></span></div>
                    <div class="profile-info-row"><span class="lbl">Số điện thoại</span><span class="val"><c:out value="${currentShop.shopPhone}"/></span></div>
                    <div class="profile-info-row"><span class="lbl">Chủ sở hữu</span><span class="val"><c:out value="${sessionScope.account.userName}"/></span></div>

                    <c:if test="${(fn:toUpperCase(currentShop.status) == 'REJECT' || fn:toUpperCase(currentShop.status) == 'REJECTED') && not empty currentShop.rejectionReason}">
                        <div class="reject-box">
                            <strong>⚠️ Lý do từ chối lần trước:</strong>
                            <c:out value="${currentShop.rejectionReason}"/>
                        </div>
                    </c:if>
                </div>
            </section>
        </div>
    </div>
</main>

<div class="avatar-dropdown" id="avatarDropdown">
    <div class="dropdown-header">
        <div class="d-name">${sessionScope.account.userName}</div>
        <div class="d-email">${sessionScope.account.email}</div>
        <span class="d-role">🏪 Shop Owner</span>
    </div>
    <div class="dropdown-body">
        <a href="${pageContext.request.contextPath}/shop/ho-so" class="dropdown-link">👤 Hồ sơ cá nhân</a>
        <a href="${pageContext.request.contextPath}/shop/doi-mat-khau" class="dropdown-link">🔒 Đổi mật khẩu</a>
        <div class="dropdown-divider"></div>
        <a href="${pageContext.request.contextPath}/logout" class="dropdown-link danger">🚪 Đăng xuất</a>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/dashboard-theme.js"></script>
<script>
    function previewLogo(url) {
        const wrap = document.getElementById('logoPreview');
        if (!url) { wrap.innerHTML = '🏪'; return; }
        wrap.innerHTML = '<img src="' + url + '" alt="Logo" onerror="this.parentNode.innerHTML=\'🏪\'">';
    }

    function toggleSecret(inputId, btn) {
        const input = document.getElementById(inputId);
        const hidden = input.type === 'password';
        input.type = hidden ? 'text' : 'password';
        btn.textContent = hidden ? '🙈' : '👁';
    }

    document.querySelectorAll('.alert').forEach(el => {
        setTimeout(() => {
            el.style.transition = 'opacity .5s';
            el.style.opacity = '0';
            setTimeout(() => el.remove(), 500);
        }, 4000);
    });

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
