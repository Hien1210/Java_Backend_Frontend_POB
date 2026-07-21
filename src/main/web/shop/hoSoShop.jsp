<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>

<c:if test="${empty sessionScope.account || sessionScope.account.roleId != 2}">
    <c:redirect url="/dangnhap"/>
</c:if>

<!DOCTYPE html>
<html lang="vi" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hồ sơ cá nhân - ${sessionScope.account.userName}</title>
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

        /* Đặc thù trang hồ sơ: layout 2 cột (avatar+info / form) + khung upload avatar Cloudinary */
        .profile-grid { display: grid; grid-template-columns: 280px 1fr; gap: 24px; max-width: 960px; }
        @media (max-width: 700px) { .profile-grid { grid-template-columns: 1fr; } }
        .profile-avatar { width: 100px; height: 100px; border-radius: 50%; margin: 0 auto 16px; background: linear-gradient(135deg, var(--warning), var(--primary)); display: flex; align-items: center; justify-content: center; font-size: 36px; font-weight: 800; color: #fff; box-shadow: 0 8px 24px rgba(255,87,34,.35); overflow: hidden; }
        .profile-avatar img { width: 100%; height: 100%; object-fit: cover; border-radius: 50%; }
        .profile-username { font-size: 18px; font-weight: 700; color: var(--text-main); margin-top: 4px; }
        #uploadProgressBar { display: none; width: 100%; height: 4px; background: var(--border-color); border-radius: 2px; overflow: hidden; margin-top: 10px; }
        #uploadProgressBar .bar { height: 100%; width: 0%; background: var(--primary); transition: width .3s; }
    </style>
</head>
<body class="dash-body">

<div class="sidebar-backdrop" id="sidebarBackdrop"></div>
<aside class="sidebar" id="sidebar">
    <div class="sidebar-brand">
        <div class="logo-mark-dash">🍔</div>
        <div class="brand-text">
            <span class="brand-title">${not empty sessionScope.currentShop.shopName ? sessionScope.currentShop.shopName : 'CỬA HÀNG'}</span>
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
        <a href="${pageContext.request.contextPath}/shop/profile" class="menu-item">
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
            <h1>👤 Hồ sơ cá nhân</h1>
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

        <c:if test="${param.success == '1'}">
            <div class="alert alert-success">✅ Cập nhật hồ sơ thành công!</div>
        </c:if>
        <c:if test="${param.error == '1'}">
            <div class="alert alert-danger">❌ Có lỗi xảy ra, vui lòng thử lại.</div>
        </c:if>

        <div class="profile-grid">
            <div class="info-card">
                <div style="text-align:center;">
                    <div class="profile-avatar">
                        <c:choose>
                            <c:when test="${not empty profile.avatarUrl}">
                                <img src="${profile.avatarUrl}" alt="Avatar"/>
                            </c:when>
                            <c:otherwise>${fn:toUpperCase(fn:substring(profile.userName,0,2))}</c:otherwise>
                        </c:choose>
                    </div>
                    <div class="profile-username">${profile.userName}</div>
                    <span class="badge badge-primary">🏪 Shop Owner</span>
                    <div style="margin-top:14px;">
                        <input type="file" id="avatarFileInput" accept="image/*" style="display:none;"/>
                        <button type="button" class="btn btn-outline btn-sm" onclick="document.getElementById('avatarFileInput').click()">📷 Đổi ảnh đại diện</button>
                        <div id="uploadProgressBar"><div class="bar" id="uploadBar"></div></div>
                        <div id="uploadMsg" style="font-size:12px;color:var(--text-muted);margin-top:6px;"></div>
                    </div>
                </div>
                <div style="margin-top:18px;">
                    <div class="info-row"><div class="info-label">📧 Email</div><div class="info-value">${not empty profile.email ? profile.email : 'Chưa cập nhật'}</div></div>
                    <div class="info-row"><div class="info-label">📱 SĐT</div><div class="info-value">${not empty profile.phone ? profile.phone : 'Chưa cập nhật'}</div></div>
                    <div class="info-row"><div class="info-label">🪪 Họ tên</div><div class="info-value">${not empty profile.fullName ? profile.fullName : 'Chưa cập nhật'}</div></div>
                </div>
            </div>

            <div class="panel">
                <div class="panel-header"><div class="panel-title">📝 Chỉnh sửa thông tin</div></div>
                <div class="panel-body">
                    <form action="${pageContext.request.contextPath}/shop/ho-so" method="post">
                        <div class="form-group">
                            <label class="form-label">Tên đăng nhập</label>
                            <input type="text" class="form-control" value="${profile.userName}" disabled/>
                            <div class="form-hint">Tên đăng nhập không thể thay đổi.</div>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Họ và tên</label>
                            <input type="text" class="form-control" name="fullName" value="${profile.fullName}" placeholder="Nhập họ và tên..."/>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Email</label>
                            <input type="email" class="form-control" name="email" value="${profile.email}" placeholder="Nhập email..."/>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Số điện thoại</label>
                            <input type="tel" class="form-control" name="phone" value="${profile.phone}" placeholder="Nhập số điện thoại..."/>
                        </div>
                        <div class="form-actions" style="display:flex;gap:12px;margin-top:8px;">
                            <button type="submit" class="btn btn-primary">💾 Lưu thay đổi</button>
                            <button type="button" class="btn btn-ghost" onclick="history.back()">Huỷ</button>
                        </div>
                    </form>
                </div>
            </div>
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
        <a href="${pageContext.request.contextPath}/shop/ho-so" class="dropdown-link" style="color:var(--primary);font-weight:700;">👤 Hồ sơ cá nhân</a>
        <a href="${pageContext.request.contextPath}/shop/doi-mat-khau" class="dropdown-link">🔒 Đổi mật khẩu</a>
        <div class="dropdown-divider"></div>
        <a href="${pageContext.request.contextPath}/logout" class="dropdown-link danger">🚪 Đăng xuất</a>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/dashboard-theme.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function() {
    // Avatar dropdown
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

    // Cloudinary avatar upload
    var CLOUD_NAME = 'jcnsb47f';
    var UPLOAD_PRESET = 'avatar_preset';

    document.getElementById('avatarFileInput').addEventListener('change', function(e) {
        var file = e.target.files[0];
        if (!file) return;

        var progressBar = document.getElementById('uploadProgressBar');
        var bar = document.getElementById('uploadBar');
        var msg = document.getElementById('uploadMsg');

        progressBar.style.display = 'block';
        bar.style.width = '10%';
        msg.textContent = 'Đang tải ảnh lên...';

        var formData = new FormData();
        formData.append('file', file);
        formData.append('upload_preset', UPLOAD_PRESET);
        formData.append('folder', 'avatars');

        var xhr = new XMLHttpRequest();
        xhr.open('POST', 'https://api.cloudinary.com/v1_1/' + CLOUD_NAME + '/image/upload', true);

        xhr.upload.onprogress = function(ev) {
            if (ev.lengthComputable) {
                var pct = Math.round((ev.loaded / ev.total) * 70);
                bar.style.width = (10 + pct) + '%';
            }
        };

        xhr.onload = function() {
            if (xhr.status === 200) {
                var result = JSON.parse(xhr.responseText);
                var rawUrl = result.secure_url;
                // Áp transformation crop mặt
                var avatarUrl = rawUrl.replace('/upload/', '/upload/w_150,h_150,c_fill,g_face/');

                bar.style.width = '90%';
                msg.textContent = 'Đang lưu...';

                // Gửi URL về server
                var saveXhr = new XMLHttpRequest();
                saveXhr.open('POST', '${pageContext.request.contextPath}/shop/update-avatar', true);
                saveXhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
                saveXhr.onload = function() {
                    bar.style.width = '100%';
                    if (saveXhr.status === 200) {
                        msg.style.color = 'var(--success)';
                        msg.textContent = '✅ Cập nhật ảnh đại diện thành công!';

                        // Cập nhật preview ngay
                        var profileAvatarEl = document.querySelector('.profile-avatar');
                        profileAvatarEl.innerHTML = '<img src="' + avatarUrl + '" alt="Avatar" style="width:100%;height:100%;object-fit:cover;border-radius:50%;"/>';

                        var topbarBtn = document.getElementById('avatarBtn');
                        topbarBtn.innerHTML = '<img src="' + avatarUrl + '" style="width:100%;height:100%;object-fit:cover;border-radius:50%;"/>';

                        setTimeout(function() {
                            progressBar.style.display = 'none';
                            bar.style.width = '0%';
                            msg.textContent = '';
                        }, 2500);
                    } else {
                        msg.style.color = 'var(--danger)';
                        msg.textContent = '❌ Lưu ảnh thất bại, thử lại.';
                    }
                };
                saveXhr.send('avatarUrl=' + encodeURIComponent(avatarUrl));
            } else {
                msg.style.color = 'var(--danger)';
                msg.textContent = '❌ Tải ảnh lên thất bại.';
                bar.style.width = '0%';
            }
        };

        xhr.onerror = function() {
            msg.style.color = 'var(--danger)';
            msg.textContent = '❌ Lỗi kết nối Cloudinary.';
        };

        xhr.send(formData);
    });
});
</script>
</body>
</html>
