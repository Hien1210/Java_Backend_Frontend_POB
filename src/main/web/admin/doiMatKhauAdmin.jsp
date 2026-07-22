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
    <title>Đổi mật khẩu - Super Admin</title>
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

        /* Đặc thù trang đổi mật khẩu: nút hiện/ẩn mật khẩu + thanh đo độ mạnh */
        .input-wrap { position: relative; }
        .input-wrap .form-control { padding-right: 44px; }
        .toggle-pw { position: absolute; right: 12px; top: 50%; transform: translateY(-50%); background: none; border: none; cursor: pointer; color: var(--text-dim); font-size: 18px; padding: 0; line-height: 1; }
        .toggle-pw:hover { color: var(--text-main); }
        .strength-bar { height: 4px; border-radius: 2px; background: var(--border-color); margin-top: 8px; overflow: hidden; }
        .strength-fill { height: 100%; border-radius: 2px; transition: width 0.3s, background 0.3s; width: 0; }
        .strength-label { font-size: 11px; margin-top: 4px; }
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
            <h1>🔒 Đổi mật khẩu</h1>
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
        <div class="panel" style="max-width:480px;">
            <div class="panel-header">
                <div class="panel-title">🔒 Đổi mật khẩu</div>
            </div>
            <div class="panel-body">
                <p style="font-size:13px;color:var(--text-muted);margin-bottom:20px;">Mật khẩu mới phải có ít nhất 6 ký tự.</p>

                <c:if test="${param.success == '1'}">
                    <div class="alert alert-success">✅ Đổi mật khẩu thành công!</div>
                </c:if>
                <c:if test="${param.error == 'wrong_current'}">
                    <div class="alert alert-danger">❌ Mật khẩu hiện tại không đúng.</div>
                </c:if>
                <c:if test="${param.error == 'not_match'}">
                    <div class="alert alert-danger">❌ Mật khẩu mới và xác nhận không khớp.</div>
                </c:if>
                <c:if test="${param.error == 'too_short'}">
                    <div class="alert alert-danger">❌ Mật khẩu mới phải có ít nhất 6 ký tự.</div>
                </c:if>
                <c:if test="${param.error == 'server'}">
                    <div class="alert alert-danger">❌ Có lỗi xảy ra, vui lòng thử lại.</div>
                </c:if>

                <form action="${pageContext.request.contextPath}/admin/change-password" method="post">
                    <div class="form-group">
                        <label class="form-label">Mật khẩu hiện tại</label>
                        <div class="input-wrap">
                            <input type="password" class="form-control" name="currentPassword" id="currentPassword" placeholder="Nhập mật khẩu hiện tại..." required/>
                            <button type="button" class="toggle-pw" onclick="togglePw('currentPassword', this)">👁️</button>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Mật khẩu mới</label>
                        <div class="input-wrap">
                            <input type="password" class="form-control" name="newPassword" id="newPassword" placeholder="Nhập mật khẩu mới..." required oninput="checkStrength(this.value)"/>
                            <button type="button" class="toggle-pw" onclick="togglePw('newPassword', this)">👁️</button>
                        </div>
                        <div class="strength-bar"><div class="strength-fill" id="strengthFill"></div></div>
                        <div class="strength-label" id="strengthLabel"></div>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Xác nhận mật khẩu mới</label>
                        <div class="input-wrap">
                            <input type="password" class="form-control" name="confirmPassword" id="confirmPassword" placeholder="Nhập lại mật khẩu mới..." required oninput="checkMatch()"/>
                            <button type="button" class="toggle-pw" onclick="togglePw('confirmPassword', this)">👁️</button>
                        </div>
                        <div class="strength-label" id="matchLabel"></div>
                    </div>

                    <div class="form-actions" style="display:flex;gap:12px;margin-top:8px;">
                        <button type="submit" class="btn btn-primary">🔒 Đổi mật khẩu</button>
                        <button type="button" class="btn btn-ghost" onclick="history.back()">Huỷ</button>
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
        <span class="d-role">Super Admin</span>
    </div>
    <div class="dropdown-body">
        <a href="${pageContext.request.contextPath}/admin/profile" class="dropdown-link">👤 Hồ sơ cá nhân</a>
        <a href="${pageContext.request.contextPath}/admin/change-password" class="dropdown-link active">🔒 Đổi mật khẩu</a>
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

    function togglePw(id, btn) {
        var input = document.getElementById(id);
        if (input.type === 'password') {
            input.type = 'text';
            btn.textContent = '🙈';
        } else {
            input.type = 'password';
            btn.textContent = '👁️';
        }
    }

    function checkStrength(val) {
        var fill = document.getElementById('strengthFill');
        var label = document.getElementById('strengthLabel');
        var score = 0;
        if (val.length >= 6)  score++;
        if (val.length >= 10) score++;
        if (/[A-Z]/.test(val)) score++;
        if (/[0-9]/.test(val)) score++;
        if (/[^A-Za-z0-9]/.test(val)) score++;

        var colors  = ['#ef4444','#f97316','#f59e0b','#10b981','#059669'];
        var labels  = ['','Rất yếu','Yếu','Trung bình','Mạnh','Rất mạnh'];
        var lColors = ['','#ef4444','#f97316','#f59e0b','#10b981','#059669'];
        fill.style.width = (score * 20) + '%';
        fill.style.background = colors[score - 1] || 'transparent';
        label.textContent = labels[score] || '';
        label.style.color = lColors[score] || 'transparent';
    }

    function checkMatch() {
        var np = document.getElementById('newPassword').value;
        var cp = document.getElementById('confirmPassword').value;
        var lbl = document.getElementById('matchLabel');
        if (cp.length === 0) { lbl.textContent = ''; return; }
        if (np === cp) {
            lbl.textContent = '✅ Mật khẩu khớp';
            lbl.style.color = '#10b981';
        } else {
            lbl.textContent = '❌ Mật khẩu không khớp';
            lbl.style.color = '#ef4444';
        }
    }
</script>
</body>
</html>
