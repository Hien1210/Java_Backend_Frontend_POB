<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>

<c:if test="${empty sessionScope.account || sessionScope.account.roleId != 2}">
    <c:redirect url="/dangnhap"/>
</c:if>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hồ sơ cá nhân - ${sessionScope.account.userName}</title>
    <style>
        :root {
            --bg-base: #FFF8F1; --bg-sidebar: #FFFFFF; --bg-panel: #FFFFFF;
            --bg-input: #FFF3E9; --bg-hover: #FFF1E4; --border: #FBE3CF;
            --text-main: #3A2A1E; --text-muted: #9C8579; --text-dim: #C2A992;
            --primary: #FF7A30; --primary-dk: #E8590C; --primary-lt: rgba(255,122,48,.12);
            --accent: #E63946; --accent-lt: rgba(230,57,70,.10);
            --warning: #FFB703; --success: #2ECC71;
            --sh-sm: 0 2px 6px rgba(58,42,30,.06); --sh-md: 0 8px 20px rgba(58,42,30,.10);
        }
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        a { text-decoration: none; color: inherit; }
        ul { list-style: none; }
        body { background: var(--bg-base); color: var(--text-muted); display: flex; height: 100vh; overflow: hidden; }

        /* SIDEBAR */
        .sidebar { width: 260px; background: var(--bg-sidebar); border-right: 1px solid var(--border); display: flex; flex-direction: column; flex-shrink: 0; }
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
        .menu-item { padding: 12px 24px; display: flex; align-items: center; justify-content: space-between; color: var(--text-muted); font-size: 13.5px; font-weight: 500; transition: all .2s; border-left: 3px solid transparent; }
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
        .content-wrapper { padding: 32px; overflow-y: auto; flex: 1; }

        @keyframes fadeUp { from { opacity: 0; transform: translateY(16px); } to { opacity: 1; transform: translateY(0); } }

        /* PROFILE */
        .profile-grid { display: grid; grid-template-columns: 280px 1fr; gap: 24px; max-width: 960px; }

        .avatar-card { background: var(--bg-panel); border: 1px solid var(--border); border-radius: 14px; padding: 32px 24px; display: flex; flex-direction: column; align-items: center; gap: 16px; animation: fadeUp .35s ease both; text-align: center; box-shadow: var(--sh-sm); }
        .profile-avatar { width: 100px; height: 100px; border-radius: 50%; background: linear-gradient(135deg, var(--warning), var(--primary)); display: flex; align-items: center; justify-content: center; font-size: 36px; font-weight: 800; color: #fff; box-shadow: 0 8px 24px rgba(255,122,48,.35); overflow: hidden; }
        .profile-avatar img { width: 100%; height: 100%; object-fit: cover; border-radius: 50%; }
        .profile-username { font-size: 20px; font-weight: 700; color: var(--text-main); }
        .profile-role-badge { background: var(--primary-lt); color: var(--primary-dk); border: 1px solid var(--primary); font-size: 11px; font-weight: 700; padding: 4px 12px; border-radius: 20px; }
        .profile-info-row { width: 100%; display: flex; align-items: center; gap: 10px; padding: 10px 0; border-top: 1px solid var(--border); font-size: 13px; color: var(--text-muted); }
        .profile-info-row span:first-child { font-size: 16px; }
        .profile-info-row strong { color: var(--text-main); font-size: 13px; }

        .form-card { background: var(--bg-panel); border: 1px solid var(--border); border-radius: 14px; padding: 28px; animation: fadeUp .35s ease .1s both; box-shadow: var(--sh-sm); }
        .form-card-title { font-size: 15px; font-weight: 700; color: var(--text-main); border-left: 4px solid var(--primary); padding-left: 12px; margin-bottom: 24px; }
        .form-group { margin-bottom: 18px; }
        .form-group label { display: block; font-size: 11px; font-weight: 700; text-transform: uppercase; letter-spacing: .5px; color: var(--text-muted); margin-bottom: 8px; }
        .form-group input { width: 100%; padding: 11px 14px; background: var(--bg-input); border: 1px solid var(--border); border-radius: 8px; font-size: 14px; color: var(--text-main); outline: none; transition: border-color .2s; }
        .form-group input:focus { border-color: var(--primary); box-shadow: 0 0 0 3px var(--primary-lt); }
        .form-group input:disabled { opacity: .5; cursor: not-allowed; }
        .form-hint { font-size: 11px; color: var(--text-dim); margin-top: 5px; }
        .form-actions { display: flex; gap: 12px; margin-top: 24px; }
        .btn-save { padding: 11px 24px; background: var(--primary); color: #fff; border: none; border-radius: 8px; font-size: 14px; font-weight: 600; cursor: pointer; transition: all .2s; }
        .btn-save:hover { background: var(--primary-dk); transform: translateY(-1px); }
        .btn-cancel { padding: 11px 20px; background: var(--bg-input); color: var(--text-muted); border: 1px solid var(--border); border-radius: 8px; font-size: 14px; cursor: pointer; transition: all .2s; }
        .btn-cancel:hover { background: var(--border); color: var(--text-main); }

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
        <h2>👤 HỒ SƠ CÁ NHÂN</h2>
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
                <span class="profile-role-badge">🏪 Shop Owner</span>
                <div style="width:100%;border-top:1px solid var(--border);margin-top:8px;"></div>
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
                <form action="${pageContext.request.contextPath}/shop/ho-so" method="post">
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
