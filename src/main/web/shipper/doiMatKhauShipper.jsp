<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <script>!function(){var t=localStorage.getItem("shipper-theme")||"light";document.documentElement.setAttribute("data-theme",t)}()</script>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đổi mật khẩu - Shipper</title>
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
        .logo { background: linear-gradient(135deg, var(--primary), #2e7d32); color: #fff; width: 38px; height: 38px; border-radius: 10px; display: flex; align-items: center; justify-content: center; font-weight: 800; font-size: 18px; }
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
        .content { padding: 40px 32px; overflow-y: auto; flex: 1; display: flex; align-items: flex-start; justify-content: center; }
        @keyframes fadeUp { from { opacity: 0; transform: translateY(16px); } to { opacity: 1; transform: translateY(0); } }

        .pw-card { background: var(--bg-card); border: 1px solid var(--border-color); border-radius: 14px; padding: 36px; width: 100%; max-width: 480px; animation: fadeUp .35s ease both; }
        .pw-icon { width: 60px; height: 60px; border-radius: 16px; background: var(--primary-light); border: 1px solid var(--primary); display: flex; align-items: center; justify-content: center; font-size: 28px; margin-bottom: 20px; }
        .pw-title { font-size: 20px; font-weight: 700; color: var(--text-main); margin-bottom: 6px; }
        .pw-desc { font-size: 13px; color: var(--text-muted); margin-bottom: 28px; }

        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; font-size: 11px; font-weight: 700; text-transform: uppercase; letter-spacing: .5px; color: var(--text-muted); margin-bottom: 8px; }
        .input-wrap { position: relative; }
        .input-wrap input { width: 100%; padding: 12px 44px 12px 14px; background: var(--bg-input); border: 1px solid var(--border-color); border-radius: 8px; font-size: 14px; color: var(--text-main); outline: none; transition: border-color .2s; }
        .input-wrap input:focus { border-color: var(--primary); box-shadow: 0 0 0 3px var(--primary-light); }
        .toggle-pw { position: absolute; right: 12px; top: 50%; transform: translateY(-50%); background: none; border: none; cursor: pointer; color: var(--text-dim); font-size: 18px; padding: 0; }
        .toggle-pw:hover { color: var(--text-main); }
        .strength-bar { height: 4px; border-radius: 2px; background: var(--border-color); margin-top: 8px; overflow: hidden; }
        .strength-fill { height: 100%; border-radius: 2px; transition: width .3s, background .3s; width: 0; }
        .strength-label { font-size: 11px; margin-top: 4px; color: var(--text-dim); }
        .match-msg { font-size: 12px; margin-top: 5px; }
        .match-ok { color: var(--primary); }
        .match-err { color: var(--danger); }
        .form-actions { margin-top: 28px; display: flex; gap: 12px; }
        .btn-save { flex: 1; padding: 13px; background: var(--primary); color: #fff; border: none; border-radius: 8px; font-size: 15px; font-weight: 700; cursor: pointer; transition: all .2s; }
        .btn-save:hover { background: var(--primary-hover); transform: translateY(-1px); }
        .btn-cancel { padding: 13px 20px; background: var(--bg-input); color: var(--text-muted); border: 1px solid var(--border-color); border-radius: 8px; font-size: 14px; cursor: pointer; }
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
        <h1>🔒 Đổi mật khẩu</h1>
        <div class="topbar-right">
            <button type="button" class="theme-toggle" id="themeToggleBtn" onclick="(function(){var t=document.documentElement.getAttribute('data-theme')==='dark'?'light':'dark';document.documentElement.setAttribute('data-theme',t);localStorage.setItem('shipper-theme',t)})()">🌓</button>
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
        <div class="pw-card">
            <div class="pw-icon">🔒</div>
            <div class="pw-title">Đổi mật khẩu</div>
            <div class="pw-desc">Nhập mật khẩu hiện tại và mật khẩu mới để cập nhật.</div>

            <c:if test="${param.success == '1'}">
                <div class="alert alert-success">✅ Đổi mật khẩu thành công!</div>
            </c:if>
            <c:if test="${param.error == 'wrong_current'}">
                <div class="alert alert-error">❌ Mật khẩu hiện tại không đúng.</div>
            </c:if>
            <c:if test="${param.error == 'not_match'}">
                <div class="alert alert-error">❌ Mật khẩu xác nhận không khớp.</div>
            </c:if>
            <c:if test="${param.error == 'too_short'}">
                <div class="alert alert-error">❌ Mật khẩu mới phải có ít nhất 6 ký tự.</div>
            </c:if>
            <c:if test="${param.error == 'server'}">
                <div class="alert alert-error">❌ Có lỗi xảy ra, vui lòng thử lại.</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/shipper/doi-mat-khau" method="post">
                <div class="form-group">
                    <label>Mật khẩu hiện tại</label>
                    <div class="input-wrap">
                        <input type="password" id="currentPassword" name="currentPassword" placeholder="Nhập mật khẩu hiện tại..." required/>
                        <button type="button" class="toggle-pw" onclick="togglePw('currentPassword',this)">👁️</button>
                    </div>
                </div>
                <div class="form-group">
                    <label>Mật khẩu mới</label>
                    <div class="input-wrap">
                        <input type="password" id="newPassword" name="newPassword" placeholder="Nhập mật khẩu mới..." required oninput="checkStrength(this.value);checkMatch();"/>
                        <button type="button" class="toggle-pw" onclick="togglePw('newPassword',this)">👁️</button>
                    </div>
                    <div class="strength-bar"><div class="strength-fill" id="strengthFill"></div></div>
                    <div class="strength-label" id="strengthLabel"></div>
                </div>
                <div class="form-group">
                    <label>Xác nhận mật khẩu mới</label>
                    <div class="input-wrap">
                        <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Nhập lại mật khẩu mới..." required oninput="checkMatch();"/>
                        <button type="button" class="toggle-pw" onclick="togglePw('confirmPassword',this)">👁️</button>
                    </div>
                    <div class="match-msg" id="matchMsg"></div>
                </div>
                <div class="form-actions">
                    <button type="submit" class="btn-save">🔒 Đổi mật khẩu</button>
                    <button type="button" class="btn-cancel" onclick="history.back()">Huỷ</button>
                </div>
            </form>
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
function togglePw(id, btn) {
    var input = document.getElementById(id);
    input.type = input.type === 'password' ? 'text' : 'password';
    btn.textContent = input.type === 'password' ? '👁️' : '🙈';
}
function checkStrength(val) {
    var fill = document.getElementById('strengthFill');
    var label = document.getElementById('strengthLabel');
    var levels = [
        { w:'20%', color:'#ef4444', text:'Rất yếu' },
        { w:'40%', color:'#f97316', text:'Yếu' },
        { w:'60%', color:'#eab308', text:'Trung bình' },
        { w:'80%', color:'#3b82f6', text:'Mạnh' },
        { w:'100%', color:'#22c55e', text:'Rất mạnh' }
    ];
    if (!val) { fill.style.width='0'; label.textContent=''; return; }
    var score = 0;
    if (val.length >= 6) score++;
    if (val.length >= 8) score++;
    if (val.length >= 10) score++;
    if (/[A-Z]/.test(val)) score++;
    if (/[0-9]/.test(val)) score++;
    if (/[^A-Za-z0-9]/.test(val)) score++;
    var lvl = score<=1?0:score<=2?1:score<=3?2:score<=4?3:4;
    fill.style.width = levels[lvl].w;
    fill.style.background = levels[lvl].color;
    label.textContent = levels[lvl].text;
    label.style.color = levels[lvl].color;
}
function checkMatch() {
    var np = document.getElementById('newPassword').value;
    var cp = document.getElementById('confirmPassword').value;
    var msg = document.getElementById('matchMsg');
    if (!cp) { msg.textContent=''; return; }
    if (np===cp) { msg.textContent='✅ Mật khẩu khớp'; msg.className='match-msg match-ok'; }
    else { msg.textContent='❌ Chưa khớp'; msg.className='match-msg match-err'; }
}
(function() {
    var html = document.documentElement;
    var btn = document.getElementById('themeToggleBtn');
    var saved = localStorage.getItem('shipper-theme') || 'light';
    html.setAttribute('data-theme', saved);
    if (btn) btn.addEventListener('click', function() {
        var t = html.getAttribute('data-theme') === 'dark' ? 'light' : 'dark';
        html.setAttribute('data-theme', t);
        localStorage.setItem('shipper-theme', t);
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
