<%@ page pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đổi mật khẩu - POB</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/user-theme.css">
    <style>
        :root {
            --bg:      #FFFBF8;
            --surface: #FFFFFF;
            --surface-lt: #FFF4EC;
            --gold:    #FF5A1F;
            --text:    #241C15;
            --muted:   #8A7B6C;
            --border:  #F1E4D6;
            --font-b:  'Plus Jakarta Sans', sans-serif;
            --tr: all .25s ease;
        }
        *, *::before, *::after { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: var(--font-b); background: var(--bg); color: var(--text); min-height: 100vh; }
        a { text-decoration: none; color: inherit; transition: var(--tr); }

        /* NAVBAR */
        .navbar {
            background: rgba(255,251,248,.92); backdrop-filter: blur(14px);
            border-bottom: 1px solid var(--border);
            height: 74px; display: flex; align-items: center;
            padding: 0 30px; position: sticky; top: 0; z-index: 100; gap: 16px;
        }
        .nav-logo { font-size: 1.55rem; font-weight: 800; letter-spacing: -.5px; }
        .nav-logo span { color: var(--gold); }
        .nav-title { font-size: .95rem; font-weight: 700; color: var(--text); }
        .nav-sep { width: 1px; height: 20px; background: var(--border); }
        .nav-right { margin-left: auto; display: flex; gap: 10px; }
        .nav-link {
            display: inline-flex; align-items: center; gap: 7px; position: relative;
            padding: 9px 18px; font-size: .85rem; font-weight: 700;
            color: var(--muted); border: 1.5px solid var(--border); border-radius: 50px;
        }
        .nav-link:hover { color: var(--gold); border-color: var(--gold); background: var(--surface-lt); }

        .container { max-width: 480px; margin: 0 auto; padding: 40px 20px 80px; }

        .alert { display: flex; align-items: center; gap: 10px; padding: 14px 18px; margin-bottom: 20px; border-radius: 14px; border: 1px solid; font-size: .9rem; font-weight: 600; }
        .alert-success { background: #EAFBF1; border-color: #BBF0CF; color: #15803D; }
        .alert-danger  { background: #FEECEF; border-color: #FBD0D8; color: #E11D48; }

        .pw-card { background: var(--surface); border: 1px solid var(--border); border-radius: 20px; box-shadow: 0 4px 18px rgba(60,30,10,.06); padding: 32px; }
        .pw-icon { width: 56px; height: 56px; border-radius: 16px; background: var(--surface-lt); border: 1px solid var(--gold); display: flex; align-items: center; justify-content: center; font-size: 26px; margin-bottom: 18px; }
        .pw-title { font-size: 19px; font-weight: 800; color: var(--text); margin-bottom: 4px; }
        .pw-desc { font-size: 13px; color: var(--muted); margin-bottom: 24px; }
        .form-group { margin-bottom: 16px; }
        .form-group label { display: block; font-size: 13px; font-weight: 700; color: var(--text); margin-bottom: 6px; }
        .input-wrap { position: relative; }
        .input-wrap input { width: 100%; padding: 11px 44px 11px 14px; border-radius: 10px; border: 1.5px solid var(--border); background: var(--surface-lt); color: var(--text); font-size: 13.5px; font-family: var(--font-b); }
        .input-wrap input:focus { outline: none; border-color: var(--gold); background: var(--surface); }
        .toggle-pw { position: absolute; right: 10px; top: 50%; transform: translateY(-50%); background: none; border: none; cursor: pointer; color: var(--muted); font-size: 17px; padding: 0; line-height: 1; }
        .toggle-pw:hover { color: var(--text); }
        .strength-bar { height: 4px; border-radius: 2px; background: var(--border); margin-top: 8px; overflow: hidden; }
        .strength-fill { height: 100%; border-radius: 2px; transition: width .3s, background .3s; width: 0; }
        .strength-label { font-size: 11px; margin-top: 4px; }
        .match-msg { font-size: 12px; margin-top: 5px; }
        .match-ok { color: #15803D; }
        .match-err { color: #E11D48; }
        .form-actions { display: flex; gap: 10px; margin-top: 8px; }
        .btn-submit { padding: 11px 24px; border-radius: 50px; border: none; background: linear-gradient(135deg, var(--gold), #E14A0F); color: #fff; font-weight: 700; font-size: 13.5px; cursor: pointer; box-shadow: 0 8px 22px rgba(255,90,31,.32); }
        .btn-submit:hover { filter: brightness(1.05); }
        .btn-cancel { padding: 11px 24px; border-radius: 50px; border: 1.5px solid var(--border); background: var(--surface); color: var(--muted); font-weight: 700; font-size: 13.5px; cursor: pointer; }
        .btn-cancel:hover { color: var(--gold); border-color: var(--gold); background: var(--surface-lt); }
    </style>
</head>
<body>

<div class="navbar">
    <div class="nav-logo"><span>POB</span></div>
    <div class="nav-sep"></div>
    <span class="nav-title">Đổi mật khẩu</span>
    <div class="nav-right">
        <a href="${pageContext.request.contextPath}/user/donhang" class="nav-link">📦 Đơn hàng</a>
        <a href="${pageContext.request.contextPath}/user/thong-bao" class="nav-link">🔔 Thông báo<span data-notif-badge style="display:${unreadNotifCount > 0 ? 'inline-block' : 'none'};margin-left:2px;background:#E11D48;color:#fff;border-radius:999px;font-size:10px;min-width:16px;height:16px;line-height:16px;text-align:center;padding:0 3px;font-weight:700;">${unreadNotifCount}</span></a>
        <a href="${pageContext.request.contextPath}/user/home" class="nav-link">← Trang chủ</a>
    </div>
</div>

<div class="container">
    <div class="pw-card">
        <div class="pw-icon">🔒</div>
        <div class="pw-title">Đổi mật khẩu</div>
        <div class="pw-desc">Nhập mật khẩu hiện tại và mật khẩu mới để cập nhật.</div>

        <c:if test="${param.success == '1'}">
            <div class="alert alert-success">✅ Đổi mật khẩu thành công!</div>
        </c:if>
        <c:if test="${param.error == 'wrong_current'}">
            <div class="alert alert-danger">❌ Mật khẩu hiện tại không đúng.</div>
        </c:if>
        <c:if test="${param.error == 'not_match'}">
            <div class="alert alert-danger">❌ Mật khẩu xác nhận không khớp.</div>
        </c:if>
        <c:if test="${param.error == 'too_short'}">
            <div class="alert alert-danger">❌ Mật khẩu mới phải có ít nhất 6 ký tự.</div>
        </c:if>
        <c:if test="${param.error == 'server'}">
            <div class="alert alert-danger">❌ Có lỗi xảy ra, vui lòng thử lại.</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/user/doi-mat-khau" method="post">
<input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
            <div class="form-group">
                <label>Mật khẩu hiện tại</label>
                <div class="input-wrap">
                    <input type="password" id="currentPassword" name="currentPassword" placeholder="Nhập mật khẩu hiện tại..." required>
                    <button type="button" class="toggle-pw" onclick="togglePw('currentPassword', this)">👁️</button>
                </div>
            </div>
            <div class="form-group">
                <label>Mật khẩu mới</label>
                <div class="input-wrap">
                    <input type="password" id="newPassword" name="newPassword" placeholder="Nhập mật khẩu mới..." required oninput="checkStrength(this.value); checkMatch();">
                    <button type="button" class="toggle-pw" onclick="togglePw('newPassword', this)">👁️</button>
                </div>
                <div class="strength-bar"><div class="strength-fill" id="strengthFill"></div></div>
                <div class="strength-label" id="strengthLabel"></div>
            </div>
            <div class="form-group">
                <label>Xác nhận mật khẩu mới</label>
                <div class="input-wrap">
                    <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Nhập lại mật khẩu mới..." required oninput="checkMatch();">
                    <button type="button" class="toggle-pw" onclick="togglePw('confirmPassword', this)">👁️</button>
                </div>
                <div class="match-msg" id="matchMsg"></div>
            </div>
            <div class="form-actions">
                <button type="submit" class="btn-submit">🔒 Đổi mật khẩu</button>
                <button type="button" class="btn-cancel" onclick="history.back()">Huỷ</button>
            </div>
        </form>
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
        { min: 0,  w: '20%', color: '#ef4444', text: 'Rất yếu' },
        { min: 4,  w: '40%', color: '#f97316', text: 'Yếu' },
        { min: 6,  w: '60%', color: '#eab308', text: 'Trung bình' },
        { min: 8,  w: '80%', color: '#3b82f6', text: 'Mạnh' },
        { min: 10, w: '100%', color: '#22c55e', text: 'Rất mạnh' }
    ];
    if (!val) { fill.style.width = '0'; label.textContent = ''; return; }
    var score = 0;
    if (val.length >= 6) score++;
    if (val.length >= 8) score++;
    if (val.length >= 10) score++;
    if (/[A-Z]/.test(val)) score++;
    if (/[0-9]/.test(val)) score++;
    if (/[^A-Za-z0-9]/.test(val)) score++;
    var lvl = score <= 1 ? 0 : score <= 2 ? 1 : score <= 3 ? 2 : score <= 4 ? 3 : 4;
    fill.style.width = levels[lvl].w;
    fill.style.background = levels[lvl].color;
    label.textContent = levels[lvl].text;
    label.style.color = levels[lvl].color;
}

function checkMatch() {
    var np = document.getElementById('newPassword').value;
    var cp = document.getElementById('confirmPassword').value;
    var msg = document.getElementById('matchMsg');
    if (!cp) { msg.textContent = ''; return; }
    if (np === cp) { msg.textContent = '✅ Mật khẩu khớp'; msg.className = 'match-msg match-ok'; }
    else { msg.textContent = '❌ Chưa khớp'; msg.className = 'match-msg match-err'; }
}
</script>
<script>window.POB_CONTEXT_PATH = '${pageContext.request.contextPath}';</script>
<script src="${pageContext.request.contextPath}/assets/js/toast.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/notifications-ws.js"></script>
</body>
</html>
