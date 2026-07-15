<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:if test="${empty sessionScope.account || sessionScope.account.roleId != 1}">
    <c:redirect url="/dangnhap"/>
</c:if>

<!DOCTYPE html>
<html lang="vi" data-theme="dark">
<head>
    <meta charset="UTF-8">
    <title>Đổi mật khẩu - Super Admin</title>
    <style>
        :root[data-theme="dark"] {
            --bg-base: #0f172a; --bg-sidebar: #1e293b; --bg-panel: #1e293b;
            --bg-input: #0f172a; --bg-hover: #1e293b;
            --text-main: #f8fafc; --text-muted: #94a3b8; --text-dim: #64748b;
            --border-color: #334155; --topbar-bg: rgba(30, 41, 59, 0.8);
        }
        :root[data-theme="light"] {
            --bg-base: #f1f5f9; --bg-sidebar: #ffffff; --bg-panel: #ffffff;
            --bg-input: #f8fafc; --bg-hover: #f1f5f9;
            --text-main: #0f172a; --text-muted: #64748b; --text-dim: #94a3b8;
            --border-color: #e2e8f0; --topbar-bg: rgba(255, 255, 255, 0.8);
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
        .sidebar { width: 260px; background-color: var(--bg-sidebar); border-right: 1px solid var(--border-color); display: flex; flex-direction: column; flex-shrink: 0; z-index: 10; }
        .brand { padding: 24px; display: flex; flex-direction: column; gap: 10px; border-bottom: 1px solid var(--border-color); }
        .brand-row { display: flex; align-items: center; gap: 12px; }
        .logo { background: linear-gradient(135deg, var(--primary), #3b82f6); color: #fff; width: 36px; height: 36px; border-radius: 10px; display: flex; align-items: center; justify-content: center; font-weight: 800; font-size: 18px; box-shadow: 0 4px 12px rgba(16,185,129,0.3); }
        .brand-title { color: var(--text-main); font-weight: 700; font-size: 15px; }
        .menu { padding: 16px 12px; flex: 1; overflow-y: auto; overflow-x: hidden; }
        .menu-title { font-size: 11px; color: var(--text-dim); font-weight: 700; margin: 16px 12px 8px; letter-spacing: 1px; text-transform: uppercase; }
        .menu-item { padding: 11px 20px; display: flex; align-items: center; justify-content: space-between; color: var(--text-muted); font-size: 13px; transition: all 0.2s; border-radius: 8px; margin-bottom: 3px; }
        .menu-item:hover { background: var(--bg-input); color: var(--text-main); transform: translateX(4px); }
        .menu-item.active { background: var(--primary-light); color: var(--primary); font-weight: 600; }

        /* MAIN */
        .main { flex: 1; display: flex; flex-direction: column; overflow: hidden; }
        .topbar { background-color: var(--topbar-bg); backdrop-filter: blur(12px); -webkit-backdrop-filter: blur(12px); padding: 16px 32px; display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid var(--border-color); }
        .topbar h1 { color: var(--text-main); font-size: 18px; font-weight: 700; }
        .topbar-right { display: flex; align-items: center; gap: 16px; }
        .theme-toggle { background: var(--bg-input); border: 1px solid var(--border-color); width: 38px; height: 38px; border-radius: 8px; cursor: pointer; display: flex; align-items: center; justify-content: center; color: var(--text-main); font-size: 16px; }
        .theme-toggle:hover { background: var(--border-color); }
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
        .dropdown-link.danger:hover { background: var(--danger-light); }

        /* CONTENT */
        .content { padding: 40px 32px; overflow-y: auto; flex: 1; display: flex; align-items: flex-start; justify-content: center; }

        @keyframes fadeUp { from { opacity: 0; transform: translateY(16px); } to { opacity: 1; transform: translateY(0); } }

        /* CARD */
        .pw-card { background: var(--bg-panel); border: 1px solid var(--border-color); border-radius: 14px; padding: 36px; width: 100%; max-width: 480px; animation: fadeUp 0.35s ease both; }
        .pw-icon { width: 60px; height: 60px; border-radius: 16px; background: var(--primary-light); border: 1px solid var(--primary); display: flex; align-items: center; justify-content: center; font-size: 28px; margin-bottom: 20px; }
        .pw-title { font-size: 20px; font-weight: 700; color: var(--text-main); margin-bottom: 6px; }
        .pw-desc { font-size: 13px; color: var(--text-muted); margin-bottom: 28px; }

        .form-group { margin-bottom: 20px; position: relative; }
        .form-group label { display: block; font-size: 11px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px; color: var(--text-muted); margin-bottom: 8px; }
        .input-wrap { position: relative; }
        .input-wrap input { width: 100%; padding: 12px 44px 12px 14px; background: var(--bg-input); border: 1px solid var(--border-color); border-radius: 8px; font-size: 14px; color: var(--text-main); outline: none; transition: border-color 0.2s; }
        .input-wrap input:focus { border-color: var(--primary); box-shadow: 0 0 0 3px var(--primary-light); }
        .toggle-pw { position: absolute; right: 12px; top: 50%; transform: translateY(-50%); background: none; border: none; cursor: pointer; color: var(--text-dim); font-size: 18px; padding: 0; line-height: 1; }
        .toggle-pw:hover { color: var(--text-main); }

        .strength-bar { height: 4px; border-radius: 2px; background: var(--border-color); margin-top: 8px; overflow: hidden; }
        .strength-fill { height: 100%; border-radius: 2px; transition: width 0.3s, background 0.3s; width: 0; }
        .strength-label { font-size: 11px; margin-top: 4px; }

        .form-actions { display: flex; gap: 12px; margin-top: 28px; }
        .btn-save { flex: 1; padding: 12px; background: var(--primary); color: #fff; border: none; border-radius: 8px; font-size: 14px; font-weight: 700; cursor: pointer; transition: all 0.2s; }
        .btn-save:hover { background: var(--primary-hover); transform: translateY(-1px); }
        .btn-cancel { padding: 12px 20px; background: var(--bg-input); color: var(--text-muted); border: 1px solid var(--border-color); border-radius: 8px; font-size: 14px; cursor: pointer; transition: all 0.2s; }
        .btn-cancel:hover { background: var(--border-color); color: var(--text-main); }

        .alert { padding: 13px 16px; border-radius: 8px; font-size: 13px; font-weight: 600; margin-bottom: 20px; display: flex; align-items: center; gap: 8px; }
        .alert-success { background: var(--primary-light); color: var(--primary); border: 1px solid var(--primary); }
        .alert-error   { background: var(--danger-light);  color: var(--danger);  border: 1px solid var(--danger); }
    </style>
</head>
<body>

<aside class="sidebar">
    <div class="brand">
        <div class="brand-row">
            <div class="logo">S</div>
            <span class="brand-title">SUPER ADMIN</span>
        </div>
        <div style="font-size: 12px; color: var(--text-muted); padding-left: 2px;">
            👋 Hi, <strong style="color: var(--primary);">${sessionScope.account.userName}</strong>
        </div>
    </div>
    <ul class="menu">
        <div class="menu-title">Quản lý hệ thống</div>
        <a href="${pageContext.request.contextPath}/tong-quan">
            <li class="menu-item"><span>⊞ Tổng quan hệ thống</span></li>
        </a>
        <a href="${pageContext.request.contextPath}/super-admin/shop-requests">
            <li class="menu-item"><span>🏪 Duyệt Shop</span></li>
        </a>
        <li class="menu-item"><span>🛵 Duyệt Shipper</span></li>
        <div class="menu-title">Quản lý Dữ liệu</div>
        <a href="${pageContext.request.contextPath}/quanlitaikhoan">
            <li class="menu-item"><span>👤 Người dùng</span></li>
        </a>
        <a href="${pageContext.request.contextPath}/admin/appeals">
            <li class="menu-item"><span>📋 Kháng nghị</span></li>
        </a>
        <a href="${pageContext.request.contextPath}/Category" class="menu-item">
            <span>📂 Danh mục món ăn</span>
        </a>
        <a href="${pageContext.request.contextPath}/product" class="menu-item">
            <span>🍽️ Sản phẩm</span>
        </a>
    </ul>
</aside>

<main class="main">
    <header class="topbar">
        <h1>🔒 Đổi mật khẩu</h1>
        <div class="topbar-right">
            <button class="theme-toggle" id="themeToggleBtn">🌓</button>
            <div class="avatar-btn" id="avatarBtn">
                    <c:choose>
                        <c:when test="${not empty sessionScope.account.avatarUrl}">
                            <img src="${sessionScope.account.avatarUrl}" style="width:100%;height:100%;object-fit:cover;border-radius:50%;"/>
                        </c:when>
                        <c:otherwise>${fn:toUpperCase(fn:substring(sessionScope.account.userName, 0, 2))}</c:otherwise>
                    </c:choose>
                </div>
        </div>
    </header>

    <div class="content">
        <div class="pw-card">
            <div class="pw-icon">🔒</div>
            <div class="pw-title">Đổi mật khẩu</div>
            <div class="pw-desc">Mật khẩu mới phải có ít nhất 6 ký tự.</div>

            <c:if test="${param.success == '1'}">
                <div class="alert alert-success">✅ Đổi mật khẩu thành công!</div>
            </c:if>
            <c:if test="${param.error == 'wrong_current'}">
                <div class="alert alert-error">❌ Mật khẩu hiện tại không đúng.</div>
            </c:if>
            <c:if test="${param.error == 'not_match'}">
                <div class="alert alert-error">❌ Mật khẩu mới và xác nhận không khớp.</div>
            </c:if>
            <c:if test="${param.error == 'too_short'}">
                <div class="alert alert-error">❌ Mật khẩu mới phải có ít nhất 6 ký tự.</div>
            </c:if>
            <c:if test="${param.error == 'server'}">
                <div class="alert alert-error">❌ Có lỗi xảy ra, vui lòng thử lại.</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/admin/change-password" method="post">
                <div class="form-group">
                    <label>Mật khẩu hiện tại</label>
                    <div class="input-wrap">
                        <input type="password" name="currentPassword" id="currentPassword" placeholder="Nhập mật khẩu hiện tại..." required/>
                        <button type="button" class="toggle-pw" onclick="togglePw('currentPassword', this)">👁️</button>
                    </div>
                </div>

                <div class="form-group">
                    <label>Mật khẩu mới</label>
                    <div class="input-wrap">
                        <input type="password" name="newPassword" id="newPassword" placeholder="Nhập mật khẩu mới..." required oninput="checkStrength(this.value)"/>
                        <button type="button" class="toggle-pw" onclick="togglePw('newPassword', this)">👁️</button>
                    </div>
                    <div class="strength-bar"><div class="strength-fill" id="strengthFill"></div></div>
                    <div class="strength-label" id="strengthLabel"></div>
                </div>

                <div class="form-group">
                    <label>Xác nhận mật khẩu mới</label>
                    <div class="input-wrap">
                        <input type="password" name="confirmPassword" id="confirmPassword" placeholder="Nhập lại mật khẩu mới..." required oninput="checkMatch()"/>
                        <button type="button" class="toggle-pw" onclick="togglePw('confirmPassword', this)">👁️</button>
                    </div>
                    <div class="strength-label" id="matchLabel"></div>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn-save">🔒 Đổi mật khẩu</button>
                    <button type="button" class="btn-cancel" onclick="history.back()">Huỷ</button>
                </div>
            </form>
        </div>
    </div>
</main>

<!-- Avatar Dropdown -->
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


