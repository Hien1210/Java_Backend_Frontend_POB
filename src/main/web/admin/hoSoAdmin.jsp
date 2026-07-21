<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="/app-functions" prefix="app" %>

<c:if test="${empty sessionScope.account || sessionScope.account.roleId != 1}">
    <c:redirect url="/dangnhap"/>
</c:if>

<!DOCTYPE html>
<html lang="vi" data-theme="dark">
<head>
    <meta charset="UTF-8">
    <title>Hồ sơ cá nhân - Super Admin</title>
    <style>
        :root[data-theme="dark"] {
            --bg-base: #0f172a; --bg-sidebar: #1e293b; --bg-panel: #1e293b;
            --bg-input: #0f172a; --bg-hover: #1e293b;
            --text-main: #f8fafc; --text-muted: #94a3b8; --text-dim: #64748b;
            --border-color: #334155; --topbar-bg: rgba(30, 41, 59, 0.8);
            --shadow-md: 0 4px 6px rgba(0,0,0,0.15);
        }
        :root[data-theme="light"] {
            --bg-base: #f1f5f9; --bg-sidebar: #ffffff; --bg-panel: #ffffff;
            --bg-input: #f8fafc; --bg-hover: #f1f5f9;
            --text-main: #0f172a; --text-muted: #64748b; --text-dim: #94a3b8;
            --border-color: #e2e8f0; --topbar-bg: rgba(255, 255, 255, 0.8);
            --shadow-md: 0 4px 6px rgba(0,0,0,0.06);
        }
        :root {
            --primary: #10b981; --primary-hover: #059669;
            --primary-light: rgba(16, 185, 129, 0.15);
            --warning: #f59e0b; --danger: #ef4444;
            --danger-light: rgba(239, 68, 68, 0.1);
            --font-family: system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
        }

        * { box-sizing: border-box; margin: 0; padding: 0; font-family: var(--font-family); transition: background-color 0.3s, border-color 0.3s, color 0.3s; }
        body { background-color: var(--bg-base); color: var(--text-muted); display: flex; height: 100vh; overflow: hidden; }
        a { text-decoration: none; color: inherit; }
        ul { list-style: none; }

        /* SIDEBAR */
        .sidebar { width: 260px; background-color: var(--bg-sidebar); border-right: 1px solid var(--border-color); display: flex; flex-direction: column; flex-shrink: 0; z-index: 10; transition: width 0.3s ease; overflow: hidden; }
        .brand { padding: 24px; display: flex; flex-direction: column; gap: 10px; border-bottom: 1px solid var(--border-color); transition: padding 0.3s ease; }
        .brand-row { display: flex; align-items: center; justify-content: space-between; gap: 12px; }
        .logo { background: linear-gradient(135deg, var(--primary), #3b82f6); color: #fff; width: 36px; height: 36px; border-radius: 10px; display: flex; align-items: center; justify-content: center; font-weight: 800; font-size: 18px; box-shadow: 0 4px 12px rgba(16,185,129,0.3); flex-shrink: 0; }
        .brand-title { color: var(--text-main); font-weight: 700; font-size: 15px; }
        .sidebar-toggle-btn { background: var(--bg-input); border: 1px solid var(--border-color); width: 30px; height: 30px; border-radius: 6px; display: flex; align-items: center; justify-content: center; color: var(--text-main); cursor: pointer; flex-shrink: 0; transition: all 0.2s ease; }
        .sidebar-toggle-btn:hover { background: var(--border-color); }
        .menu { padding: 16px 12px; flex: 1; overflow-y: auto; overflow-x: hidden; }
        .menu-title { font-size: 11px; color: var(--text-dim); font-weight: 700; margin: 16px 12px 8px; letter-spacing: 1px; text-transform: uppercase; white-space: nowrap; }
        .menu-item { padding: 11px 20px; display: flex; align-items: center; justify-content: space-between; color: var(--text-muted); font-size: 13px; transition: all 0.2s; border-radius: 8px; margin-bottom: 3px; white-space: nowrap; }
        .menu-item:hover { background: var(--bg-input); color: var(--text-main); transform: translateX(4px); }
        .menu-item.active { background: var(--primary-light); color: var(--primary); font-weight: 600; }
        .menu-item-label-group { display: flex; align-items: center; gap: 8px; overflow: hidden; }
        .badge { font-size: 10px; padding: 2px 7px; border-radius: 10px; background: var(--border-color); color: var(--text-main); flex-shrink: 0; }
        .badge.yellow { background: var(--warning); color: #0f172a; font-weight: 600; }

        .sidebar.collapsed { width: 84px; }
        .sidebar.collapsed .brand { padding: 16px 8px; }
        .sidebar.collapsed .brand-row { flex-direction: column; gap: 10px; }
        .sidebar.collapsed .brand-title,
        .sidebar.collapsed .sidebar-hi,
        .sidebar.collapsed .menu-title,
        .sidebar.collapsed .menu-label,
        .sidebar.collapsed .badge { display: none; }
        .sidebar.collapsed .menu-item { justify-content: center; padding: 11px 0; }
        .sidebar.collapsed .menu-item:hover { transform: none; }
        .sidebar.collapsed .menu-item-label-group { gap: 0; }

        /* Custom scrollbar cho sidebar */
        .sidebar::-webkit-scrollbar,
        .menu::-webkit-scrollbar { width: 6px; }
        .sidebar::-webkit-scrollbar-track,
        .menu::-webkit-scrollbar-track { background: var(--bg-sidebar); }
        .sidebar::-webkit-scrollbar-thumb,
        .menu::-webkit-scrollbar-thumb { background: var(--border-color); border-radius: 9999px; }
        .sidebar::-webkit-scrollbar-thumb:hover,
        .menu::-webkit-scrollbar-thumb:hover { background: var(--text-dim); }
        .menu { scrollbar-width: thin; scrollbar-color: var(--border-color) var(--bg-sidebar); }

        /* MAIN */
        .main { flex: 1; display: flex; flex-direction: column; overflow: hidden; transition: all 0.3s ease; }
        .topbar { background-color: var(--topbar-bg); backdrop-filter: blur(12px); -webkit-backdrop-filter: blur(12px); padding: 16px 32px; display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid var(--border-color); }
        .topbar h1 { color: var(--text-main); font-size: 18px; font-weight: 700; }
        .topbar-right { display: flex; align-items: center; gap: 16px; }
        .theme-toggle { background: var(--bg-input); border: 1px solid var(--border-color); width: 38px; height: 38px; border-radius: 8px; cursor: pointer; display: flex; align-items: center; justify-content: center; color: var(--text-main); font-size: 16px; }
        .theme-toggle:hover { background: var(--border-color); }
        .avatar-wrapper { position: relative; }
        .avatar-btn { background: var(--warning); color: #0f172a; width: 38px; height: 38px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: 800; font-size: 13px; cursor: pointer; border: 2px solid transparent; transition: all 0.2s; user-select: none; }
        .avatar-btn:hover { border-color: var(--warning); box-shadow: 0 0 0 3px rgba(245,158,11,0.2); }
        .avatar-dropdown { display: none; position: fixed; right: auto; top: auto; background: var(--bg-panel); border: 1px solid var(--border-color); border-radius: 12px; box-shadow: 0 12px 32px rgba(0,0,0,0.3); min-width: 220px; z-index: 500; animation: fadeUp 0.2s ease both; }
        .avatar-dropdown.open { display: block; }
        .dropdown-header { padding: 14px 16px; border-bottom: 1px solid var(--border-color); }
        .dropdown-header .d-name { font-size: 14px; font-weight: 700; color: var(--text-main); }
        .dropdown-header .d-email { font-size: 12px; color: var(--text-muted); margin-top: 2px; }
        .dropdown-header .d-role { display: inline-block; margin-top: 6px; font-size: 10px; font-weight: 700; padding: 2px 8px; border-radius: 4px; background: var(--primary-light); color: var(--primary); border: 1px solid var(--primary); }
        .dropdown-body { padding: 6px 0 8px; }
        .dropdown-link { display: flex; align-items: center; gap: 10px; padding: 10px 16px; font-size: 13px; color: var(--text-muted); cursor: pointer; transition: background 0.15s; text-decoration: none; }
        .dropdown-link:hover { background: var(--bg-input); color: var(--text-main); }
        .dropdown-divider { height: 1px; background: var(--border-color); margin: 4px 0; }
        .dropdown-link.danger { color: var(--danger); }
        .dropdown-link.danger:hover { background: var(--danger-light); color: var(--danger); }

        /* CONTENT */
        .content { padding: 32px; overflow-y: auto; flex: 1; }

        @keyframes fadeUp { from { opacity: 0; transform: translateY(16px); } to { opacity: 1; transform: translateY(0); } }

        /* PROFILE LAYOUT */
        .profile-grid { display: grid; grid-template-columns: 280px 1fr; gap: 24px; max-width: 960px; }

        /* CARD TRÁI — AVATAR */
        .avatar-card { background: var(--bg-panel); border: 1px solid var(--border-color); border-radius: 14px; padding: 32px 24px; display: flex; flex-direction: column; align-items: center; gap: 16px; animation: fadeUp 0.35s ease both; text-align: center; }
        .profile-avatar { width: 100px; height: 100px; border-radius: 50%; background: linear-gradient(135deg, var(--warning), #f97316); display: flex; align-items: center; justify-content: center; font-size: 36px; font-weight: 800; color: #fff; box-shadow: 0 8px 24px rgba(245,158,11,0.35); overflow: hidden; position: relative; }
        .profile-avatar img { width: 100%; height: 100%; object-fit: cover; border-radius: 50%; }
        .avatar-upload-btn { background: var(--bg-input); border: 1px dashed var(--border-color); color: var(--text-muted); font-size: 12px; padding: 7px 14px; border-radius: 8px; cursor: pointer; transition: all 0.2s; }
        .avatar-upload-btn:hover { border-color: var(--primary); color: var(--primary); }
        #avatarFileInput { display: none; }
        .upload-status { font-size: 12px; color: var(--text-muted); min-height: 18px; }
        .profile-username { font-size: 20px; font-weight: 700; color: var(--text-main); }
        .profile-role-badge { background: var(--primary-light); color: var(--primary); border: 1px solid var(--primary); font-size: 11px; font-weight: 700; padding: 4px 12px; border-radius: 20px; }
        .profile-joined { font-size: 12px; color: var(--text-dim); }
        .profile-info-row { width: 100%; display: flex; align-items: center; gap: 10px; padding: 10px 0; border-top: 1px solid var(--border-color); font-size: 13px; color: var(--text-muted); }
        .profile-info-row span:first-child { font-size: 16px; }
        .profile-info-row strong { color: var(--text-main); font-size: 13px; }

        /* CARD PHẢI — FORM */
        .form-card { background: var(--bg-panel); border: 1px solid var(--border-color); border-radius: 14px; padding: 28px; animation: fadeUp 0.35s ease 0.1s both; }
        .form-card-title { font-size: 15px; font-weight: 700; color: var(--text-main); border-left: 4px solid var(--primary); padding-left: 12px; margin-bottom: 24px; }
        .form-group { margin-bottom: 18px; }
        .form-group label { display: block; font-size: 11px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px; color: var(--text-muted); margin-bottom: 8px; }
        .form-group input { width: 100%; padding: 11px 14px; background: var(--bg-input); border: 1px solid var(--border-color); border-radius: 8px; font-size: 14px; color: var(--text-main); outline: none; transition: border-color 0.2s; }
        .form-group input:focus { border-color: var(--primary); box-shadow: 0 0 0 3px var(--primary-light); }
        .form-group input:disabled { opacity: 0.5; cursor: not-allowed; }
        .form-hint { font-size: 11px; color: var(--text-dim); margin-top: 5px; }
        .form-actions { display: flex; gap: 12px; margin-top: 24px; }
        .btn-save { padding: 11px 24px; background: var(--primary); color: #fff; border: none; border-radius: 8px; font-size: 14px; font-weight: 600; cursor: pointer; transition: all 0.2s; }
        .btn-save:hover { background: var(--primary-hover); transform: translateY(-1px); }
        .btn-cancel { padding: 11px 20px; background: var(--bg-input); color: var(--text-muted); border: 1px solid var(--border-color); border-radius: 8px; font-size: 14px; cursor: pointer; transition: all 0.2s; }
        .btn-cancel:hover { background: var(--border-color); color: var(--text-main); }

        /* ALERT */
        .alert { padding: 13px 16px; border-radius: 8px; font-size: 13px; font-weight: 600; margin-bottom: 20px; display: flex; align-items: center; gap: 8px; }
        .alert-success { background: var(--primary-light); color: var(--primary); border: 1px solid var(--primary); }
        .alert-error { background: var(--danger-light); color: var(--danger); border: 1px solid var(--danger); }
    </style>
</head>
<body>

<aside class="sidebar" id="sidebarMain">
    <div class="brand">
        <div class="brand-row">
            <div style="display: flex; align-items: center; gap: 12px;">
                <div class="logo">S</div>
                <span class="brand-title">SUPER ADMIN</span>
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
    <ul class="menu">
        <div class="menu-title">📊 TỔNG QUAN & PHÂN TÍCH</div>
        <a href="${pageContext.request.contextPath}/tong-quan">
            <li class="menu-item"><span class="menu-item-label-group"><span class="menu-icon">⊞</span><span class="menu-label">Tổng quan hệ thống</span></span></li>
        </a>
        <a href="${pageContext.request.contextPath}/admin/bao-cao-van-hanh">
            <li class="menu-item"><span class="menu-item-label-group"><span class="menu-icon">📈</span><span class="menu-label">Báo cáo vận hành</span></span></li>
        </a>

        <div class="menu-title">⚖️ KIỂM DUYỆT & ĐIỀU PHỐI</div>
        <a href="${pageContext.request.contextPath}/super-admin/shop-requests">
            <li class="menu-item"><span class="menu-item-label-group"><span class="menu-icon">🏪</span><span class="menu-label">Duyệt Shop</span></span></li>
        </a>
        <a href="${pageContext.request.contextPath}/super-admin/shipper-requests">
            <li class="menu-item"><span class="menu-item-label-group"><span class="menu-icon">🛵</span><span class="menu-label">Duyệt Shipper</span></span></li>
        </a>
        <a href="${pageContext.request.contextPath}/admin/kiem-duyet-noi-dung">
            <li class="menu-item"><span class="menu-item-label-group"><span class="menu-icon">🚩</span><span class="menu-label">Kiểm duyệt nội dung</span></span></li>
        </a>
        <a href="${pageContext.request.contextPath}/admin/kiem-duyet-binh-luan">
            <li class="menu-item"><span class="menu-item-label-group"><span class="menu-icon">💬</span><span class="menu-label">Kiểm duyệt bình luận</span></span></li>
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
        <h1>👤 Hồ sơ cá nhân</h1>
        <div class="topbar-right">
            <button class="theme-toggle" id="themeToggleBtn">🌓</button>
            <div class="avatar-wrapper">
                <div class="avatar-btn" id="avatarBtn">
                    <c:choose>
                        <c:when test="${not empty sessionScope.account.avatarUrl}">
                            <img src="${sessionScope.account.avatarUrl}" style="width:100%;height:100%;object-fit:cover;border-radius:50%;"/>
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
            <div class="alert alert-error">❌ Có lỗi xảy ra, vui lòng thử lại.</div>
        </c:if>

        <div class="profile-grid">

            <!-- CỘT TRÁI: Avatar + thông tin tóm tắt -->
            <div class="avatar-card">
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
                <label for="avatarFileInput" class="avatar-upload-btn">📷 Đổi ảnh đại diện</label>
                <div class="upload-status" id="uploadStatus"></div>
                <div class="profile-username">${profile.userName}</div>
                <span class="profile-role-badge">⚡ Super Admin</span>
                <c:if test="${not empty profile.createdAt}">
                    <div class="profile-joined">Tham gia: ${app:formatDateTime(profile.createdAt)}</div>
                </c:if>
                <div style="width:100%; border-top: 1px solid var(--border-color); margin-top: 8px;"></div>
                <div class="profile-info-row">
                    <span>📧</span>
                    <strong>${not empty profile.email ? profile.email : 'Chưa cập nhật'}</strong>
                </div>
                <div class="profile-info-row">
                    <span>📱</span>
                    <strong>${not empty profile.phone ? profile.phone : 'Chưa cập nhật'}</strong>
                </div>
                <div class="profile-info-row">
                    <span>🪪</span>
                    <strong>${not empty profile.fullName ? profile.fullName : 'Chưa cập nhật'}</strong>
                </div>
            </div>

            <!-- CỘT PHẢI: Form chỉnh sửa -->
            <div class="form-card">
                <div class="form-card-title">Chỉnh sửa thông tin</div>
                <form action="${pageContext.request.contextPath}/admin/profile" method="post">
                    <input type="hidden" name="avatarUrl" id="avatarUrlInput" value="${profile.avatarUrl}"/>
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

<script>
    (function() {
        var html = document.documentElement;
        var btn = document.getElementById('themeToggleBtn');
        var saved = localStorage.getItem('theme') || 'dark';
        html.setAttribute('data-theme', saved);
        if (btn) btn.addEventListener('click', function() {
            var t = html.getAttribute('data-theme') === 'dark' ? 'light' : 'dark';
            html.setAttribute('data-theme', t);
            localStorage.setItem('theme', t);
        });
    })();

    // Thu gọn/mở rộng Sidebar
    (function () {
        const sidebarEl = document.getElementById('sidebarMain');
        const sidebarToggleBtn = document.getElementById('sidebarToggleBtn');
        if (!sidebarEl || !sidebarToggleBtn) return;

        if (localStorage.getItem('sidebarCollapsed') === 'true') {
            sidebarEl.classList.add('collapsed');
        }

        sidebarToggleBtn.addEventListener('click', () => {
            sidebarEl.classList.toggle('collapsed');
            localStorage.setItem('sidebarCollapsed', sidebarEl.classList.contains('collapsed'));
        });
    })();

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
    <script src="${pageContext.request.contextPath}/assets/js/toast.js"></script>
</body>
</html>


