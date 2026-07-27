<%@ page pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đổi mật khẩu - POB</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/theme-space.css">
    <style>
        .mini-nav { background: var(--bg-panel-solid); border-bottom: 1px solid var(--border-color); padding: 16px 24px; display: flex; align-items: center; gap: 16px; }
        .mini-nav .logo { width: 36px; height: 36px; border-radius: var(--radius-sm); background: linear-gradient(135deg, var(--primary), var(--secondary)); color: #fff; display: flex; align-items: center; justify-content: center; font-weight: 800; font-size: 13px; box-shadow: var(--glow-primary); }
        .mini-nav .title { font-size: 17px; font-weight: 800; color: var(--text-main); }
        .mini-nav .nav-links { margin-left: auto; display: flex; align-items: center; gap: 18px; }
        .mini-nav .nav-links a { font-size: 13px; color: var(--text-muted); }
        .mini-nav .nav-links a:hover { color: var(--secondary); }

        .container { max-width: 480px; margin: 0 auto; padding: 32px 16px; }
        .pw-card { padding: 32px; }
        .pw-icon { width: 56px; height: 56px; border-radius: var(--radius-md); background: rgba(139,92,246,.15); border: 1px solid var(--primary); display: flex; align-items: center; justify-content: center; font-size: 26px; margin-bottom: 18px; }
        .pw-title { font-size: 19px; font-weight: 800; color: var(--text-main); margin-bottom: 4px; }
        .pw-desc { font-size: 13px; color: var(--text-muted); margin-bottom: 24px; }
        .form-group { margin-bottom: 16px; }
        .form-group label { display: block; font-size: 13px; font-weight: 700; color: var(--text-main); margin-bottom: 6px; }
        .input-wrap { position: relative; }
        .input-wrap input { width: 100%; padding: 10px 44px 10px 12px; border-radius: var(--radius-sm); border: 1.5px solid var(--border-color); background: var(--bg-input); color: var(--text-main); font-size: 13.5px; }
        .toggle-pw { position: absolute; right: 10px; top: 50%; transform: translateY(-50%); background: none; border: none; cursor: pointer; color: var(--text-muted); font-size: 17px; padding: 0; line-height: 1; }
        .toggle-pw:hover { color: var(--text-main); }
        .strength-bar { height: 4px; border-radius: 2px; background: var(--border-color); margin-top: 8px; overflow: hidden; }
        .strength-fill { height: 100%; border-radius: 2px; transition: width .3s, background .3s; width: 0; }
        .strength-label { font-size: 11px; margin-top: 4px; }
        .match-msg { font-size: 12px; margin-top: 5px; }
        .match-ok { color: var(--success); }
        .match-err { color: var(--danger); }
        .form-actions { display: flex; gap: 10px; margin-top: 8px; }
        .btn-submit { padding: 10px 22px; border-radius: var(--radius-pill); border: none; background: var(--primary); color: #fff; font-weight: 700; font-size: 13.5px; cursor: pointer; }
        .btn-cancel { padding: 10px 22px; border-radius: var(--radius-pill); border: 1px solid var(--border-color); background: transparent; color: var(--text-muted); font-weight: 700; font-size: 13.5px; cursor: pointer; }
    </style>
</head>
<body class="space-scope">
<div class="starfield"></div>

<div class="mini-nav">
    <div class="logo">POB</div>
    <span class="title">Đổi mật khẩu</span>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/user/donhang">📦 Đơn hàng</a>
        <a href="${pageContext.request.contextPath}/user/thong-bao" style="position:relative;">🔔 Thông báo<span data-notif-badge style="display:${unreadNotifCount > 0 ? 'inline-block' : 'none'};margin-left:4px;background:#ef4444;color:#fff;border-radius:999px;font-size:10px;min-width:16px;height:16px;line-height:16px;text-align:center;padding:0 3px;font-weight:700;">${unreadNotifCount}</span></a>
        <a href="${pageContext.request.contextPath}/user/home">← Trang chủ</a>
    </div>
</div>

<div class="container">
    <div class="card pw-card">
        <div class="pw-icon">🔒</div>
        <div class="pw-title">Đổi mật khẩu</div>
        <div class="pw-desc">Nhập mật khẩu hiện tại và mật khẩu mới để cập nhật.</div>

        <c:if test="${param.success == '1'}">
            <div class="alert alert-success" style="margin-bottom:16px;">✅ Đổi mật khẩu thành công!</div>
        </c:if>
        <c:if test="${param.error == 'wrong_current'}">
            <div class="alert alert-danger" style="margin-bottom:16px;">❌ Mật khẩu hiện tại không đúng.</div>
        </c:if>
        <c:if test="${param.error == 'not_match'}">
            <div class="alert alert-danger" style="margin-bottom:16px;">❌ Mật khẩu xác nhận không khớp.</div>
        </c:if>
        <c:if test="${param.error == 'too_short'}">
            <div class="alert alert-danger" style="margin-bottom:16px;">❌ Mật khẩu mới phải có ít nhất 6 ký tự.</div>
        </c:if>
        <c:if test="${param.error == 'server'}">
            <div class="alert alert-danger" style="margin-bottom:16px;">❌ Có lỗi xảy ra, vui lòng thử lại.</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/user/doi-mat-khau" method="post">
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
