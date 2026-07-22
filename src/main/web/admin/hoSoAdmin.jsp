<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
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
    <title>Hồ sơ cá nhân - Super Admin</title>
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
        .dropdown-link.active { color: var(--primary); font-weight: 700; }
        .dropdown-divider { height: 1px; background: var(--border-color); margin: 4px 0; }
        .dropdown-link.danger { color: var(--danger); }
        .dropdown-link.danger:hover { background: var(--danger-light); color: var(--danger); }

        /* Đặc thù trang hồ sơ: layout 2 cột (avatar + info-card / form) */
        .profile-grid { display: grid; grid-template-columns: 280px 1fr; gap: 24px; max-width: 960px; }
        @media (max-width: 700px) { .profile-grid { grid-template-columns: 1fr; } }
        .profile-avatar { width: 100px; height: 100px; border-radius: 50%; margin: 0 auto 16px; background: linear-gradient(135deg, var(--warning), #f97316); display: flex; align-items: center; justify-content: center; font-size: 36px; font-weight: 800; color: #fff; box-shadow: 0 8px 24px rgba(245,158,11,0.35); overflow: hidden; }
        .profile-avatar img { width: 100%; height: 100%; object-fit: cover; border-radius: 50%; }
        #avatarFileInput { display: none; }
        .upload-status { font-size: 12px; color: var(--text-muted); min-height: 18px; margin-top: 8px; }
        .profile-username { font-size: 18px; font-weight: 700; color: var(--text-main); margin-top: 8px; }
        .profile-joined { font-size: 12px; color: var(--text-dim); margin-top: 6px; }
        .form-control:disabled { opacity: 0.6; cursor: not-allowed; }
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
        <a href="${pageContext.request.contextPath}/admin/appeals">
            <li class="menu-item"><span class="menu-item-label-group"><span class="menu-icon">📋</span><span class="menu-label">Kháng nghị</span></span></li>
        </a>

        <div class="menu-title">💰 QUẢN LÝ TÀI CHÍNH</div>
        <a href="#">
            <li class="menu-item"><span class="menu-item-label-group"><span class="menu-icon">💵</span><span class="menu-label">Đối soát doanh thu Shop</span></span></li>
        </a>
        <a href="#">
            <li class="menu-item"><span class="menu-item-label-group"><span class="menu-icon">💳</span><span class="menu-label">Duyệt rút tiền Shipper</span></span></li>
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
            <h1>👤 Hồ sơ cá nhân</h1>
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
        <c:if test="${param.success == '1'}">
            <div class="alert alert-success">✅ Cập nhật hồ sơ thành công!</div>
        </c:if>
        <c:if test="${param.error == '1'}">
            <div class="alert alert-danger">❌ Có lỗi xảy ra, vui lòng thử lại.</div>
        </c:if>

        <div class="profile-grid">

            <!-- CỘT TRÁI: Avatar + thông tin tóm tắt -->
            <div class="info-card">
                <div style="text-align:center;">
                    <div class="profile-avatar" id="profileAvatarCircle">
                        <c:choose>
                            <c:when test="${not empty profile.avatarUrl}">
                                <img src="${profile.avatarUrl}" alt="Avatar" id="avatarPreviewImg"/>
                            </c:when>
                            <c:otherwise>
                                <span id="avatarInitials">${fn:toUpperCase(fn:substring(profile.userName, 0, 2))}</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <input type="file" id="avatarFileInput" accept="image/jpeg,image/png,image/webp"/>
                    <label for="avatarFileInput" class="btn btn-outline btn-sm">📷 Đổi ảnh đại diện</label>
                    <div class="upload-status" id="uploadStatus"></div>
                    <div class="profile-username">${profile.userName}</div>
                    <span class="badge badge-primary">⚡ Super Admin</span>
                    <c:if test="${not empty profile.createdAt}">
                        <div class="profile-joined">Tham gia: ${profile.createdAt}</div>
                    </c:if>
                </div>
                <div style="margin-top:18px;">
                    <div class="info-row"><div class="info-label">📧 Email</div><div class="info-value">${not empty profile.email ? profile.email : 'Chưa cập nhật'}</div></div>
                    <div class="info-row"><div class="info-label">📱 SĐT</div><div class="info-value">${not empty profile.phone ? profile.phone : 'Chưa cập nhật'}</div></div>
                    <div class="info-row"><div class="info-label">🪪 Họ tên</div><div class="info-value">${not empty profile.fullName ? profile.fullName : 'Chưa cập nhật'}</div></div>
                </div>
            </div>

            <!-- CỘT PHẢI: Form chỉnh sửa -->
            <div class="form-card">
                <div class="form-card-title">Chỉnh sửa thông tin</div>
                <form action="${pageContext.request.contextPath}/admin/profile" method="post">
                    <div class="form-group">
                        <label>Tên đăng nhập</label>
                        <input type="text" value="${profile.userName}" disabled/>
                        <div class="form-hint">Tên đăng nhập không thể thay đổi.</div>
                    </div>
                    <div class="form-group">
                        <label>Họ và tên</label>
                        <input type="text" name="fullName" value="${profile.fullName}" placeholder="Nhập họ và tên..."/>
                    </div>
                    <div class="form-group">
                        <label>Email</label>
                        <input type="email" name="email" value="${profile.email}" placeholder="Nhập email..."/>
                    </div>
                    <div class="form-group">
                        <label>Số điện thoại</label>
                        <input type="tel" name="phone" value="${profile.phone}" placeholder="Nhập số điện thoại..."/>
                    </div>
                    <div class="form-actions">
                        <button type="submit" class="btn-save">💾 Lưu thay đổi</button>
                        <button type="button" class="btn-cancel" onclick="history.back()">Huỷ</button>
                    </div>
                </form>
            </div>

        </div>
    </div>
</main>

<!-- Avatar Dropdown (ngoài topbar để tránh backdrop-filter stacking context) -->
<div class="avatar-dropdown" id="avatarDropdown">
    <div class="dropdown-header">
        <div class="d-name">${sessionScope.account.userName}</div>
        <div class="d-email">${sessionScope.account.email}</div>
        <span class="d-role">Super Admin</span>
    </div>
    <div class="dropdown-body">
        <a href="${pageContext.request.contextPath}/admin/profile" class="dropdown-link active">👤 Hồ sơ cá nhân</a>
        <a href="${pageContext.request.contextPath}/admin/change-password" class="dropdown-link">🔒 Đổi mật khẩu</a>
        <div class="dropdown-divider"></div>
        <a href="${pageContext.request.contextPath}/logout" class="dropdown-link danger">🚪 Đăng xuất</a>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/dashboard-theme.js"></script>
<script>
    // Cloudinary unsigned upload
    var CLOUD_NAME = 'jcnsb47f';
    var UPLOAD_PRESET = 'avatar_preset';

    document.getElementById('avatarFileInput').addEventListener('change', function(e) {
        var file = e.target.files[0];
        if (!file) return;
        if (file.size > 2 * 1024 * 1024) {
            document.getElementById('uploadStatus').textContent = '❌ Ảnh tối đa 2MB.';
            return;
        }
        var status = document.getElementById('uploadStatus');
        status.textContent = '⏳ Đang tải lên...';

        var formData = new FormData();
        formData.append('file', file);
        formData.append('upload_preset', UPLOAD_PRESET);
        formData.append('folder', 'avatars');

        fetch('https://api.cloudinary.com/v1_1/' + CLOUD_NAME + '/image/upload', {
            method: 'POST',
            body: formData
        })
        .then(function(r) { return r.json(); })
        .then(function(data) {
            if (!data.secure_url) { status.textContent = '❌ Upload thất bại.'; return; }
            // Chèn transformation vào URL để resize về 150x150
            var url = data.secure_url.replace('/upload/', '/upload/w_150,h_150,c_fill,g_face/');

            // Preview ngay
            var circle = document.getElementById('profileAvatarCircle');
            var initials = document.getElementById('avatarInitials');
            var previewImg = document.getElementById('avatarPreviewImg');
            if (!previewImg) {
                previewImg = document.createElement('img');
                previewImg.id = 'avatarPreviewImg';
                previewImg.style.cssText = 'width:100%;height:100%;object-fit:cover;border-radius:50%;';
                if (initials) initials.style.display = 'none';
                circle.appendChild(previewImg);
            }
            previewImg.src = url;

            // Cập nhật avatar trên topbar (chỉ preview, chưa lưu DB)
            var avatarTopbar = document.getElementById('avatarBtn');
            if (avatarTopbar) {
                avatarTopbar.innerHTML = '<img src="' + url + '" style="width:100%;height:100%;object-fit:cover;border-radius:50%;" />';
            }

            // Ghim URL vào form chính, chỉ lưu DB khi bấm "Lưu thay đổi"
            document.getElementById('avatarUrlInput').value = url;
            status.textContent = '📌 Ảnh đã sẵn sàng, bấm "Lưu thay đổi" để áp dụng.';
        })
        .catch(function() { document.getElementById('uploadStatus').textContent = '❌ Lỗi kết nối.'; });
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
            avatarDropdown.addEventListener('click', function(e) {
                e.stopPropagation();
            });
            document.addEventListener('click', function() {
                avatarDropdown.classList.remove('open');
            });
        }
    });
</script>
</body>
</html>
