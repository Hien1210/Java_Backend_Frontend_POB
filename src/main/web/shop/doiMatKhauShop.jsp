<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<c:if test="${empty sessionScope.account || sessionScope.account.roleId != 2}">
    <c:redirect url="/dangnhap"/>
</c:if>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đổi mật khẩu - ${sessionScope.account.userName}</title>
    <style>
        :root {
            --bg-base: #FFF8F1; --bg-sidebar: #FFFFFF; --bg-panel: #FFFFFF;
            --bg-input: #FFF3E9; --bg-hover: #FFF1E4; --border: #FBE3CF;
            --text-main: #3A2A1E; --text-muted: #9C8579; --text-dim: #C2A992;
            --primary: #FF7A30; --primary-dk: #E8590C; --primary-lt: rgba(255,122,48,.12);
            --accent: #E63946; --accent-lt: rgba(230,57,70,.10);
            --warning: #FFB703; --success: #2ECC71;
        }
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        a { text-decoration: none; color: inherit; }
        body { background: var(--bg-base); color: var(--text-muted); display: flex; height: 100vh; overflow: hidden; }

        /* SIDEBAR */
        .sidebar { width: 260px; background: var(--bg-sidebar); border-right: 1px solid var(--border); display: flex; flex-direction: column; flex-shrink: 0; overflow-x: hidden; }
        .sidebar-brand { padding: 22px 24px; display: flex; flex-direction: column; gap: 10px; border-bottom: 1px solid var(--border); }
        .brand-row { display: flex; align-items: center; gap: 12px; }
        .logo-icon { background: linear-gradient(135deg, var(--primary), var(--accent)); color: #fff; width: 38px; height: 38px; border-radius: 10px; display: flex; align-items: center; justify-content: center; font-weight: 800; font-size: 18px; box-shadow: 0 4px 10px rgba(255,122,48,.35); }
        .brand-text { display: flex; flex-direction: column; }
        .brand-title { color: var(--text-main); font-weight: 800; font-size: 15px; }
        .brand-subtitle { color: var(--primary); font-size: 11px; font-weight: 600; }
        .hi-owner { font-size: 12px; color: var(--text-muted); }
        .hi-owner strong { color: var(--primary-dk); }
        .menu-section { padding: 16px 0; overflow-y: auto; flex: 1; }
        .menu-title { font-size: 11px; text-transform: uppercase; color: var(--text-dim); margin: 16px 24px 8px; font-weight: 700; letter-spacing: .5px; }
        .menu-item { padding: 12px 24px; display: flex; align-items: center; color: var(--text-muted); font-size: 13.5px; font-weight: 500; transition: all .2s; border-left: 3px solid transparent; }
        .menu-item:hover { background: var(--bg-hover); color: var(--primary-dk); transform: translateX(4px); }
        .menu-item.active { background: var(--primary-lt); color: var(--primary-dk); border-left-color: var(--primary); font-weight: 700; }
        .menu-item-left { display: flex; align-items: center; gap: 12px; }

        /* MAIN */
        .main-content { flex: 1; display: flex; flex-direction: column; overflow: hidden; }
        .top-header { height: 72px; background: var(--bg-sidebar); border-bottom: 1px solid var(--border); display: flex; align-items: center; justify-content: space-between; padding: 0 32px; flex-shrink: 0; }
        .top-header h2 { color: var(--text-main); font-size: 19px; font-weight: 800; }
        .header-actions { display: flex; align-items: center; gap: 16px; }
        .avatar-btn { background: linear-gradient(135deg, var(--warning), var(--primary)); color: #fff; width: 38px; height: 38px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: 800; font-size: 13px; cursor: pointer; border: 2px solid transparent; transition: all .2s; user-select: none; overflow: hidden; }
        .avatar-btn:hover { border-color: var(--primary); box-shadow: 0 0 0 3px rgba(255,122,48,.2); }
        .avatar-dropdown { display: none; position: fixed; background: var(--bg-panel); border: 1px solid var(--border); border-radius: 12px; box-shadow: 0 12px 32px rgba(58,42,30,.15); min-width: 220px; z-index: 9999; }
        .avatar-dropdown.open { display: block; }
        .dropdown-header { padding: 14px 16px; border-bottom: 1px solid #e2c9b8; }
        .dropdown-header .d-name { font-size: 14px; font-weight: 700; color: var(--text-main); }
        .dropdown-header .d-email { font-size: 12px; color: var(--text-muted); margin-top: 2px; }
        .dropdown-header .d-role { display: inline-block; margin-top: 6px; font-size: 10px; font-weight: 700; padding: 2px 8px; border-radius: 4px; background: var(--primary-lt); color: var(--primary-dk); border: 1px solid var(--primary); }
        .dropdown-body { padding: 6px 0 8px; }
        .dropdown-link { display: flex; align-items: center; gap: 10px; padding: 10px 16px; font-size: 13px; color: var(--text-muted); transition: background .15s; text-decoration: none; }
        .dropdown-link:hover { background: var(--bg-hover); color: var(--text-main); }
        .dropdown-divider { height: 1px; background: #e2c9b8; margin: 4px 0; }
        .dropdown-link.danger { color: var(--accent); }
        .dropdown-link.danger:hover { background: var(--accent-lt); }

        /* CONTENT */
        .content-wrapper { padding: 40px 32px; overflow-y: auto; flex: 1; display: flex; align-items: flex-start; justify-content: center; }

        @keyframes fadeUp { from { opacity: 0; transform: translateY(16px); } to { opacity: 1; transform: translateY(0); } }

        /* CARD */
        .pw-card { background: var(--bg-panel); border: 1px solid var(--border); border-radius: 14px; padding: 36px; width: 100%; max-width: 480px; animation: fadeUp .35s ease both; box-shadow: 0 2px 6px rgba(58,42,30,.06); }
        .pw-icon { width: 60px; height: 60px; border-radius: 16px; background: var(--primary-lt); border: 1px solid var(--primary); display: flex; align-items: center; justify-content: center; font-size: 28px; margin-bottom: 20px; }
        .pw-title { font-size: 20px; font-weight: 700; color: var(--text-main); margin-bottom: 6px; }
        .pw-desc { font-size: 13px; color: var(--text-muted); margin-bottom: 28px; }

        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; font-size: 11px; font-weight: 700; text-transform: uppercase; letter-spacing: .5px; color: var(--text-muted); margin-bottom: 8px; }
        .input-wrap { position: relative; }
        .input-wrap input { width: 100%; padding: 12px 44px 12px 14px; background: var(--bg-input); border: 1px solid var(--border); border-radius: 8px; font-size: 14px; color: var(--text-main); outline: none; transition: border-color .2s; }
        .input-wrap input:focus { border-color: var(--primary); box-shadow: 0 0 0 3px var(--primary-lt); }
        .toggle-pw { position: absolute; right: 12px; top: 50%; transform: translateY(-50%); background: none; border: none; cursor: pointer; color: var(--text-dim); font-size: 18px; padding: 0; }
        .toggle-pw:hover { color: var(--text-main); }

        .strength-bar { height: 4px; border-radius: 2px; background: var(--border); margin-top: 8px; overflow: hidden; }
        .strength-fill { height: 100%; border-radius: 2px; transition: width .3s, background .3s; width: 0; }
        .strength-label { font-size: 11px; margin-top: 4px; color: var(--text-dim); }

        .match-msg { font-size: 12px; margin-top: 5px; }
        .match-ok { color: var(--success); }
        .match-err { color: var(--accent); }

        .form-actions { margin-top: 28px; display: flex; gap: 12px; }
        .btn-save { flex: 1; padding: 13px; background: var(--primary); color: #fff; border: none; border-radius: 8px; font-size: 15px; font-weight: 700; cursor: pointer; transition: all .2s; }
        .btn-save:hover { background: var(--primary-dk); transform: translateY(-1px); }
        .btn-cancel { padding: 13px 20px; background: var(--bg-input); color: var(--text-muted); border: 1px solid var(--border); border-radius: 8px; font-size: 14px; cursor: pointer; transition: all .2s; }
        .btn-cancel:hover { background: var(--border); }

        .alert { padding: 13px 16px; border-radius: 8px; font-size: 13px; font-weight: 600; margin-bottom: 20px; display: flex; align-items: center; gap: 8px; }
        .alert-success { background: rgba(46,204,113,.12); color: #27ae60; border: 1px solid #27ae60; }
        .alert-error { background: var(--accent-lt); color: var(--accent); border: 1px solid var(--accent); }
    </style>
</head>
<body>

<aside class="sidebar">
    <div class="sidebar-brand">
        <div class="brand-row">
            <div class="logo-icon">🍔</div>
            <div class="brand-text">
                <span class="brand-title">${not empty sessionScope.currentShop.shopName ? sessionScope.currentShop.shopName : 'CỬA HÀNG'}</span>
                <span class="brand-subtitle">SHOP OWNER</span>
            </div>
        </div>
        <div class="hi-owner">👋 Hi, <strong>${sessionScope.account.userName}</strong></div>
    </div>
    <div class="menu-section">
        <div class="menu-title">Tổng quan</div>
        <a href="${pageContext.request.contextPath}/shop" class="menu-item">
            <div class="menu-item-left"><span style="font-size:16px;">📊</span> Trang chủ</div>
        </a>
        <div class="menu-title">Sản phẩm</div>
        <a href="${pageContext.request.contextPath}/shop/products" class="menu-item">
            <div class="menu-item-left"><span style="font-size:16px;">🍽️</span> Quản lý sản phẩm</div>
        </a>
        <a href="${pageContext.request.contextPath}/shop/product-types" class="menu-item">
            <div class="menu-item-left"><span style="font-size:16px;">📂</span> Quản lý loại sản phẩm</div>
        </a>
        <div class="menu-title">Topping</div>
        <a href="${pageContext.request.contextPath}/shop/toppings" class="menu-item">
            <div class="menu-item-left"><span style="font-size:16px;">🧂</span> Quản lý Topping</div>
        </a>
        <a href="${pageContext.request.contextPath}/shop/topping-categories" class="menu-item">
            <div class="menu-item-left"><span style="font-size:16px;">🏷️</span> Quản lý loại Topping</div>
        </a>
        <div class="menu-title">Đơn hàng</div>
        <a href="${pageContext.request.contextPath}/shop/pos" class="menu-item">
            <div class="menu-item-left"><span style="font-size:16px;">🧾</span> Bấm Bill</div>
        </a>
        <a href="${pageContext.request.contextPath}/shop/bills" class="menu-item">
            <div class="menu-item-left"><span style="font-size:16px;">📋</span> Quản lý hóa đơn</div>
        </a>
        <div class="menu-title">Cửa hàng</div>
        <a href="${pageContext.request.contextPath}/shop/profile" class="menu-item">
            <div class="menu-item-left"><span style="font-size:16px;">🏪</span> Thông tin cửa hàng</div>
        </a>
        <a href="${pageContext.request.contextPath}/shop/danh-gia" class="menu-item">
            <div class="menu-item-left"><span style="font-size:16px;">⭐</span> Xem đánh giá</div>
        </a>
    </div>
</aside>

<main class="main-content">
    <header class="top-header">
        <h2>🔒 ĐỔI MẬT KHẨU</h2>
        <div class="header-actions">
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

    <div class="content-wrapper">
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

            <form action="${pageContext.request.contextPath}/shop/doi-mat-khau" method="post">
                <div class="form-group">
                    <label>Mật khẩu hiện tại</label>
                    <div class="input-wrap">
                        <input type="password" id="currentPassword" name="currentPassword" placeholder="Nhập mật khẩu hiện tại..." required/>
                        <button type="button" class="toggle-pw" onclick="togglePw('currentPassword', this)">👁️</button>
                    </div>
                </div>
                <div class="form-group">
                    <label>Mật khẩu mới</label>
                    <div class="input-wrap">
                        <input type="password" id="newPassword" name="newPassword" placeholder="Nhập mật khẩu mới..." required oninput="checkStrength(this.value); checkMatch();"/>
                        <button type="button" class="toggle-pw" onclick="togglePw('newPassword', this)">👁️</button>
                    </div>
                    <div class="strength-bar"><div class="strength-fill" id="strengthFill"></div></div>
                    <div class="strength-label" id="strengthLabel"></div>
                </div>
                <div class="form-group">
                    <label>Xác nhận mật khẩu mới</label>
                    <div class="input-wrap">
                        <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Nhập lại mật khẩu mới..." required oninput="checkMatch();"/>
                        <button type="button" class="toggle-pw" onclick="togglePw('confirmPassword', this)">👁️</button>
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
        <span class="d-role">🏪 Shop Owner</span>
    </div>
    <div class="dropdown-body">
        <a href="${pageContext.request.contextPath}/shop/ho-so" class="dropdown-link">👤 Hồ sơ cá nhân</a>
        <a href="${pageContext.request.contextPath}/shop/doi-mat-khau" class="dropdown-link">🔒 Đổi mật khẩu</a>
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
