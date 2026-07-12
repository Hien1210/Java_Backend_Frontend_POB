<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="vi" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hồ sơ cá nhân - Shipper</title>
    <style>
        :root[data-theme="dark"] {
            --bg-base: #0f172a; --bg-card: #1e293b; --bg-input: #0f172a;
            --text-main: #f8fafc; --text-muted: #94a3b8; --text-dim: #64748b;
            --border-color: #334155; --topbar-bg: rgba(30,41,59,0.8);
        }
        :root[data-theme="light"] {
            --bg-base: #f4f7f5; --bg-card: #ffffff; --bg-input: #f8fafc;
            --text-main: #1e293b; --text-muted: #64748b; --text-dim: #94a3b8;
            --border-color: #e2e8f0; --topbar-bg: rgba(255,255,255,0.85);
        }
        :root {
            --primary: #4CAF50; --primary-hover: #43a047; --primary-light: rgba(76,175,80,0.12);
            --secondary: #FF9800; --danger: #ef4444;
            --font-family: system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
        }
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: var(--font-family); transition: background-color 0.25s, border-color 0.25s; }
        a { text-decoration: none; color: inherit; }
        body { background: var(--bg-base); color: var(--text-muted); display: flex; height: 100vh; overflow: hidden; }

        /* SIDEBAR */
        .sidebar { width: 260px; background: var(--bg-card); border-right: 1px solid var(--border-color); display: flex; flex-direction: column; flex-shrink: 0; z-index: 10; }
        .brand { padding: 24px; display: flex; align-items: center; gap: 12px; border-bottom: 1px solid var(--border-color); }
        .logo { background: linear-gradient(135deg, var(--primary), #2e7d32); color: #fff; width: 38px; height: 38px; border-radius: 10px; display: flex; align-items: center; justify-content: center; font-weight: 800; font-size: 18px; box-shadow: 0 4px 10px rgba(76,175,80,0.3); }
        .brand-title { font-weight: 700; font-size: 16px; color: var(--text-main); }
        .menu { padding: 20px 12px; flex: 1; list-style: none; }
        .menu-item { padding: 14px 16px; display: flex; align-items: center; gap: 12px; color: var(--text-muted); font-size: 14px; font-weight: 600; border-radius: 8px; margin-bottom: 6px; transition: all 0.2s; }
        .menu-item:hover { background: var(--bg-input); color: var(--text-main); transform: translateX(4px); }
        .menu-item.active { background: var(--primary-light); color: var(--primary); }

        /* MAIN */
        .main { flex: 1; display: flex; flex-direction: column; overflow: hidden; }
        .topbar { background: var(--topbar-bg); backdrop-filter: blur(10px); padding: 16px 32px; display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid var(--border-color); }
        .topbar h1 { font-size: 18px; font-weight: 700; color: var(--text-main); }
        .topbar-right { display: flex; align-items: center; gap: 16px; }
        .theme-toggle { background: var(--bg-input); border: 1px solid var(--border-color); width: 38px; height: 38px; border-radius: 8px; cursor: pointer; display: flex; align-items: center; justify-content: center; font-size: 16px; }
        .avatar-btn { background: var(--primary); color: #fff; width: 38px; height: 38px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: 800; font-size: 13px; cursor: pointer; border: 2px solid transparent; transition: all 0.2s; user-select: none; overflow: hidden; }
        .avatar-btn:hover { border-color: var(--primary); box-shadow: 0 0 0 3px rgba(76,175,80,0.2); }
        .avatar-dropdown { display: none; position: fixed; background: var(--bg-card); border: 1px solid var(--border-color); border-radius: 12px; box-shadow: 0 12px 32px rgba(0,0,0,0.15); min-width: 220px; z-index: 9999; }
        .avatar-dropdown.open { display: block; }
        .dropdown-header { padding: 14px 16px; border-bottom: 1px solid var(--border-color); }
        .dropdown-header .d-name { font-size: 14px; font-weight: 700; color: var(--text-main); }
        .dropdown-header .d-email { font-size: 12px; color: var(--text-muted); margin-top: 2px; }
        .dropdown-header .d-role { display: inline-block; margin-top: 6px; font-size: 10px; font-weight: 700; padding: 2px 8px; border-radius: 4px; background: var(--primary-light); color: var(--primary); border: 1px solid var(--primary); }
        .dropdown-body { padding: 6px 0 8px; }
        .dropdown-link { display: flex; align-items: center; gap: 10px; padding: 10px 16px; font-size: 13px; color: var(--text-muted); transition: background 0.15s; text-decoration: none; }
        .dropdown-link:hover { background: var(--bg-input); color: var(--text-main); }
        .dropdown-divider { height: 1px; background: var(--border-color); margin: 4px 0; }
        .dropdown-link.danger { color: var(--danger); }
        .dropdown-link.danger:hover { background: rgba(239,68,68,0.1); }

        /* CONTENT */
        .content { padding: 32px; overflow-y: auto; flex: 1; }
        @keyframes fadeUp { from { opacity: 0; transform: translateY(16px); } to { opacity: 1; transform: translateY(0); } }

        /* PROFILE */
        .profile-grid { display: grid; grid-template-columns: 280px 1fr; gap: 24px; max-width: 960px; }
        .avatar-card { background: var(--bg-card); border: 1px solid var(--border-color); border-radius: 14px; padding: 32px 24px; display: flex; flex-direction: column; align-items: center; gap: 16px; animation: fadeUp .35s ease both; text-align: center; }
        .profile-avatar { width: 100px; height: 100px; border-radius: 50%; background: linear-gradient(135deg, var(--secondary), var(--primary)); display: flex; align-items: center; justify-content: center; font-size: 36px; font-weight: 800; color: #fff; box-shadow: 0 8px 24px rgba(76,175,80,.35); overflow: hidden; }
        .profile-avatar img { width: 100%; height: 100%; object-fit: cover; border-radius: 50%; }
        .profile-username { font-size: 20px; font-weight: 700; color: var(--text-main); }
        .profile-role-badge { background: var(--primary-light); color: var(--primary); border: 1px solid var(--primary); font-size: 11px; font-weight: 700; padding: 4px 12px; border-radius: 20px; }
        .profile-info-row { width: 100%; display: flex; align-items: center; gap: 10px; padding: 10px 0; border-top: 1px solid var(--border-color); font-size: 13px; color: var(--text-muted); }
        .profile-info-row span:first-child { font-size: 16px; }
        .profile-info-row strong { color: var(--text-main); font-size: 13px; }

        .form-card { background: var(--bg-card); border: 1px solid var(--border-color); border-radius: 14px; padding: 28px; animation: fadeUp .35s ease .1s both; }
        .form-card-title { font-size: 15px; font-weight: 700; color: var(--text-main); border-left: 4px solid var(--primary); padding-left: 12px; margin-bottom: 24px; }
        .form-group { margin-bottom: 18px; }
        .form-group label { display: block; font-size: 11px; font-weight: 700; text-transform: uppercase; letter-spacing: .5px; color: var(--text-muted); margin-bottom: 8px; }
        .form-group input { width: 100%; padding: 11px 14px; background: var(--bg-input); border: 1px solid var(--border-color); border-radius: 8px; font-size: 14px; color: var(--text-main); outline: none; transition: border-color .2s; }
        .form-group input:focus { border-color: var(--primary); box-shadow: 0 0 0 3px var(--primary-light); }
        .form-group input:disabled { opacity: .5; cursor: not-allowed; }
        .form-hint { font-size: 11px; color: var(--text-dim); margin-top: 5px; }
        .form-actions { display: flex; gap: 12px; margin-top: 24px; }
        .btn-save { padding: 11px 24px; background: var(--primary); color: #fff; border: none; border-radius: 8px; font-size: 14px; font-weight: 600; cursor: pointer; transition: all .2s; }
        .btn-save:hover { background: var(--primary-hover); transform: translateY(-1px); }
        .btn-cancel { padding: 11px 20px; background: var(--bg-input); color: var(--text-muted); border: 1px solid var(--border-color); border-radius: 8px; font-size: 14px; cursor: pointer; }
        .btn-cancel:hover { background: var(--border-color); color: var(--text-main); }

        .alert { padding: 13px 16px; border-radius: 8px; font-size: 13px; font-weight: 600; margin-bottom: 20px; display: flex; align-items: center; gap: 8px; }
        .alert-success { background: var(--primary-light); color: var(--primary); border: 1px solid var(--primary); }
        .alert-error { background: rgba(239,68,68,.1); color: var(--danger); border: 1px solid var(--danger); }
    </style>
</head>
<body>

<aside class="sidebar">
    <div class="brand">
        <div class="logo">🛵</div>
        <span class="brand-title">POB SHIPPER</span>
    </div>
    <ul class="menu">
        <a href="${pageContext.request.contextPath}/shipper/donhang">
            <li class="menu-item"><span>📋 Đơn hàng nhận</span></li>
        </a>
        <a href="${pageContext.request.contextPath}/shipper/nhan-don">
            <li class="menu-item"><span>📥 Nhận đơn mới</span></li>
        </a>
        <a href="${pageContext.request.contextPath}/shipper/dashboard">
            <li class="menu-item"><span>📊 Dashboard</span></li>
        </a>
        <a href="${pageContext.request.contextPath}/shipper/thongbao">
            <li class="menu-item"><span>🔔 Thông báo</span></li>
        </a>
        <a href="${pageContext.request.contextPath}/shipper/profile">
            <li class="menu-item"><span>👤 Hồ sơ tài xế</span></li>
        </a>
        <a href="${pageContext.request.contextPath}/shipper/danh-gia">
            <li class="menu-item"><span>⭐ Đánh giá & Báo cáo</span></li>
        </a>
    </ul>
</aside>

<main class="main">
    <header class="topbar">
        <h1>👤 Hồ sơ cá nhân</h1>
        <div class="topbar-right">
            <button class="theme-toggle" id="themeToggleBtn">🌓</button>
            <div class="avatar-btn" id="avatarBtn">
                <c:choose>
                    <c:when test="${not empty sessionScope.account.avatarUrl}">
                        <img src="${sessionScope.account.avatarUrl}" style="width:100%;height:100%;object-fit:cover;border-radius:50%;"/>
                    </c:when>
                    <c:otherwise>${fn:toUpperCase(fn:substring(sessionScope.account.userName,0,2))}</c:otherwise>
                </c:choose>
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
            <div class="avatar-card">
                <div class="profile-avatar">
                    <c:choose>
                        <c:when test="${not empty profile.avatarUrl}">
                            <img src="${profile.avatarUrl}" alt="Avatar"/>
                        </c:when>
                        <c:otherwise>${fn:toUpperCase(fn:substring(profile.userName,0,2))}</c:otherwise>
                    </c:choose>
                </div>
                <div class="profile-username">${profile.userName}</div>
                <span class="profile-role-badge">🛵 Shipper</span>
                <div style="width:100%;border-top:1px solid var(--border-color);margin-top:8px;"></div>
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

            <div class="form-card">
                <div class="form-card-title">Chỉnh sửa thông tin</div>
                <form action="${pageContext.request.contextPath}/shipper/ho-so" method="post">
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

<script>
    (function() {
        var html = document.documentElement;
        var btn = document.getElementById('themeToggleBtn');
        var saved = localStorage.getItem('shipperTheme') || 'light';
        html.setAttribute('data-theme', saved);
        if (btn) btn.addEventListener('click', function() {
            var t = html.getAttribute('data-theme') === 'dark' ? 'light' : 'dark';
            html.setAttribute('data-theme', t);
            localStorage.setItem('shipperTheme', t);
        });
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
</body>
</html>
