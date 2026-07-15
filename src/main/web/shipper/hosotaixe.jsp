<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <script>!function(){var t=localStorage.getItem("shipper-theme")||"light";document.documentElement.setAttribute("data-theme",t)}()</script>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hồ sơ tài xế - POB Shipper</title>
    <style>
        :root[data-theme="dark"] {
            --bg-base: #0f172a; --bg-card: #1e293b; --bg-input: #0f172a;
            --text-main: #f8fafc; --text-muted: #94a3b8; --border-color: #334155;
            --topbar-bg: rgba(30,41,59,0.8); --shadow: 0 4px 6px -1px rgb(0 0 0/0.2);
        }
        :root[data-theme="light"] {
            --bg-base: #f4f7f5; --bg-card: #ffffff; --bg-input: #f8fafc;
            --text-main: #1e293b; --text-muted: #64748b; --border-color: #e2e8f0;
            --topbar-bg: rgba(255,255,255,0.85); --shadow: 0 4px 12px rgba(0,0,0,0.03);
        }
        :root {
            --primary: #4CAF50; --primary-hover: #43a047; --primary-light: rgba(76,175,80,0.12);
            --secondary: #FF9800; --secondary-hover: #f57c00; --secondary-light: rgba(255,152,0,0.12);
            --danger: #ef4444; --font-family: system-ui,-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,sans-serif;
        }
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: var(--font-family); transition: background-color 0.25s,border-color 0.25s; }
        body { background-color: var(--bg-base); color: var(--text-main); display: flex; height: 100vh; overflow: hidden; }
        a { text-decoration: none; color: inherit; }

        /* SIDEBAR */
        .sidebar { width: 260px; background-color: var(--bg-card); border-right: 1px solid var(--border-color); display: flex; flex-direction: column; flex-shrink: 0; z-index: 10; }
        .brand { padding: 24px; display: flex; align-items: center; gap: 12px; border-bottom: 1px solid var(--border-color); }
        .logo { background: linear-gradient(135deg,var(--primary),#2e7d32); color: #fff; width: 38px; height: 38px; border-radius: 10px; display: flex; align-items: center; justify-content: center; font-weight: 800; font-size: 18px; box-shadow: 0 4px 10px rgba(76,175,80,0.3); }
        .brand-title { font-weight: 700; font-size: 16px; letter-spacing: 0.5px; }
        .menu { padding: 20px 12px; flex: 1; }
        .menu-item { padding: 14px 16px; display: flex; align-items: center; gap: 12px; color: var(--text-muted); font-size: 14px; font-weight: 600; border-radius: 8px; margin-bottom: 6px; cursor: pointer; }
        .menu-item:hover { background-color: var(--bg-input); color: var(--text-main); transform: translateX(4px); }
        .menu-item.active { background-color: var(--primary-light); color: var(--primary); }
        .online-toggle-wrap { padding: 16px 12px; border-top: 1px solid var(--border-color); }
        .online-toggle-btn { width: 100%; padding: 12px 16px; border-radius: 10px; border: none; cursor: pointer; display: flex; align-items: center; gap: 10px; font-size: 13px; font-weight: 700; transition: all 0.2s; }
        .online-toggle-btn.is-online { background: var(--primary-light); color: var(--primary); border: 1.5px solid var(--primary); }
        .online-toggle-btn.is-offline { background: rgba(239,68,68,0.08); color: #ef4444; border: 1.5px solid rgba(239,68,68,0.3); }
        .toggle-dot { width: 10px; height: 10px; border-radius: 50%; flex-shrink: 0; }
        .toggle-dot.online { background: var(--primary); animation: pulse-green 1.5s infinite; }
        .toggle-dot.offline { background: #ef4444; }
        @keyframes pulse-green { 0%,100%{box-shadow:0 0 0 3px rgba(76,175,80,0.25);} 50%{box-shadow:0 0 0 6px rgba(76,175,80,0.1);} }

        /* MAIN */
        .main { flex: 1; display: flex; flex-direction: column; overflow: hidden; }
        .topbar { background-color: var(--topbar-bg); backdrop-filter: blur(10px); padding: 16px 32px; display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid var(--border-color); }
        .topbar h1 { font-size: 18px; font-weight: 700; }
        .topbar-right { display: flex; align-items: center; gap: 16px; }
        .theme-toggle { background: var(--bg-input); border: 1px solid var(--border-color); width: 38px; height: 38px; border-radius: 8px; cursor: pointer; display: flex; align-items: center; justify-content: center; font-size: 16px; }
        .avatar-circle { background: var(--primary); color: white; width: 38px; height: 38px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: 700; }
        .btn-logout { padding: 8px 16px; border-radius: 8px; background: rgba(239,68,68,0.1); color: var(--danger); font-size: 13px; font-weight: 600; }
        .btn-logout:hover { background: var(--danger); color: white; }

        /* CONTENT */
        .content { padding: 28px 32px; overflow-y: auto; flex: 1; display: flex; flex-direction: column; gap: 24px; animation: fadeIn 0.3s ease-out; }
        @keyframes fadeIn { from{opacity:0;transform:translateY(8px)} to{opacity:1;transform:translateY(0)} }

        /* AVATAR HERO */
        .profile-hero { background: var(--bg-card); border: 1px solid var(--border-color); border-radius: 16px; padding: 28px; display: flex; align-items: center; gap: 24px; box-shadow: var(--shadow); }
        .avatar-hero { width: 88px; height: 88px; border-radius: 50%; object-fit: cover; border: 3px solid var(--primary); background: var(--bg-input); display: flex; align-items: center; justify-content: center; font-size: 36px; font-weight: 800; color: var(--primary); flex-shrink: 0; }
        .avatar-hero img { width: 88px; height: 88px; border-radius: 50%; object-fit: cover; }
        .hero-info h2 { font-size: 20px; font-weight: 700; margin-bottom: 4px; }
        .hero-info .sub { font-size: 13px; color: var(--text-muted); }
        .online-pill { display: inline-flex; align-items: center; gap: 5px; padding: 3px 10px; border-radius: 20px; font-size: 11px; font-weight: 700; margin-top: 6px; }
        .online-pill.online { background: var(--primary-light); color: var(--primary); }
        .online-pill.offline { background: rgba(239,68,68,0.1); color: #ef4444; }

        /* SECTION CARDS */
        .section-card { background: var(--bg-card); border: 1px solid var(--border-color); border-radius: 14px; padding: 24px; box-shadow: var(--shadow); }
        .section-title { font-size: 15px; font-weight: 700; margin-bottom: 20px; display: flex; align-items: center; gap: 8px; padding-bottom: 12px; border-bottom: 1px solid var(--border-color); }

        /* FORM */
        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }
        .form-group { display: flex; flex-direction: column; gap: 6px; }
        .form-group.full { grid-column: 1/-1; }
        label { font-size: 12px; font-weight: 700; color: var(--text-muted); text-transform: uppercase; letter-spacing: 0.5px; }
        input[type=text], input[type=email], input[type=password], input[type=url], select {
            padding: 10px 14px; border: 1px solid var(--border-color); border-radius: 8px;
            background: var(--bg-input); color: var(--text-main); font-size: 14px;
            transition: border-color 0.2s;
        }
        input:focus, select:focus { outline: none; border-color: var(--primary); }
        .btn-submit { margin-top: 8px; padding: 11px 24px; background: var(--primary); color: white; border: none; border-radius: 8px; font-size: 14px; font-weight: 700; cursor: pointer; box-shadow: 0 4px 10px rgba(76,175,80,0.2); transition: background 0.2s; }
        .btn-submit:hover { background: var(--primary-hover); }
        .btn-danger { background: var(--danger); box-shadow: 0 4px 10px rgba(239,68,68,0.2); }
        .btn-danger:hover { background: #dc2626; }

        /* ALERT */
        .alert { padding: 12px 16px; border-radius: 8px; font-size: 13px; font-weight: 600; margin-bottom: 4px; }
        .alert-success { background: var(--primary-light); color: var(--primary); border: 1px solid rgba(76,175,80,0.3); }
        .alert-error   { background: rgba(239,68,68,0.08); color: var(--danger); border: 1px solid rgba(239,68,68,0.25); }

        @media (max-width: 768px) {
            body { flex-direction: column; }
            .sidebar { width: 100%; height: auto; border-right: none; border-bottom: 1px solid var(--border-color); }
            .menu { display: flex; overflow-x: auto; padding: 10px; }
            .menu-item { margin-bottom: 0; white-space: nowrap; }
            .content { padding: 16px; }
            .form-grid { grid-template-columns: 1fr; }
            .profile-hero { flex-direction: column; text-align: center; }
        }
            .avatar-btn { background: var(--primary); color: #fff; width: 38px; height: 38px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: 800; font-size: 13px; cursor: pointer; border: 2px solid transparent; transition: all 0.2s; user-select: none; overflow: hidden; }
        .avatar-btn:hover { border-color: var(--primary); box-shadow: 0 0 0 3px rgba(16,185,129,0.2); }
        .avatar-dropdown { display: none; position: fixed; background: var(--bg-card, #1e293b); border: 1px solid var(--border-color); border-radius: 12px; box-shadow: 0 12px 32px rgba(0,0,0,0.3); min-width: 220px; z-index: 9999; }
        .avatar-dropdown.open { display: block; }
        .dropdown-header { padding: 14px 16px; border-bottom: 1px solid var(--border-color); }
        .dropdown-header .d-name { font-size: 14px; font-weight: 700; color: var(--text-primary, #f8fafc); }
        .dropdown-header .d-email { font-size: 12px; color: var(--text-secondary, #94a3b8); margin-top: 2px; }
        .dropdown-header .d-role { display: inline-block; margin-top: 6px; font-size: 10px; font-weight: 700; padding: 2px 8px; border-radius: 4px; background: rgba(16,185,129,0.15); color: var(--primary); border: 1px solid var(--primary); }
        .dropdown-body { padding: 6px 0 8px; }
        .dropdown-link { display: flex; align-items: center; gap: 10px; padding: 10px 16px; font-size: 13px; color: var(--text-secondary, #94a3b8); transition: background 0.15s; text-decoration: none; }
        .dropdown-link:hover { background: rgba(255,255,255,0.05); color: var(--text-primary, #f8fafc); }
        .dropdown-divider { height: 1px; background: var(--border-color); margin: 4px 0; }
        .dropdown-link.danger { color: var(--danger, #ef4444); }
        .dropdown-link.danger:hover { background: rgba(239,68,68,0.1); }</style>
</head>
<body>

<aside class="sidebar">
    <div class="brand">
        <div class="logo">🛵</div>
        <div class="brand-text">
            <span class="brand-title">POB SHIPPER</span>
            <c:choose>
                <c:when test="${sessionScope.account.online}">
                    <div style="font-size:10px;color:var(--primary);font-weight:bold;">● ĐANG HOẠT ĐỘNG</div>
                </c:when>
                <c:otherwise>
                    <div style="font-size:10px;color:#ef4444;font-weight:bold;">● NGOẠI TUYẾN</div>
                </c:otherwise>
            </c:choose>
        </div>
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
            <li class="menu-item active"><span>👤 Hồ sơ tài xế</span></li>
        </a>
        <a href="${pageContext.request.contextPath}/shipper/danh-gia">
            <li class="menu-item"><span>⭐ Đánh giá & Báo cáo</span></li>
        </a>
    </ul>
    <div class="online-toggle-wrap">
        <form action="${pageContext.request.contextPath}/shipper/status" method="post">
            <c:choose>
                <c:when test="${sessionScope.account.online}">
                    <button type="submit" class="online-toggle-btn is-online"
                            onclick="return confirm('Tắt chế độ Online? Bạn sẽ không nhận đơn mới.')">
                        <span class="toggle-dot online"></span>Đang Online — Nhấn để Offline
                    </button>
                </c:when>
                <c:otherwise>
                    <button type="submit" class="online-toggle-btn is-offline">
                        <span class="toggle-dot offline"></span>Đang Offline — Nhấn để Online
                    </button>
                </c:otherwise>
            </c:choose>
        </form>
    </div>
</aside>

<main class="main">
    <header class="topbar">
        <h1>👤 Hồ sơ tài xế</h1>
        <div class="topbar-right">
            <button type="button" class="theme-toggle" id="themeToggleBtn">🌓</button>
            <div class="avatar-btn" id="avatarBtn"><c:choose><c:when test="${not empty sessionScope.account.avatarUrl}"><img src="${sessionScope.account.avatarUrl}" style="width:100%;height:100%;object-fit:cover;border-radius:50%;"/></c:when><c:otherwise>${fn:toUpperCase(fn:substring(sessionScope.account.userName,0,2))}</c:otherwise></c:choose></div>
        </div>
    </header>

    <div class="content">

        <%-- Thông báo --%>
        <c:if test="${not empty param.success}">
            <div class="alert alert-success">✅ ${param.success}</div>
        </c:if>
        <c:if test="${not empty param.error}">
            <div class="alert alert-error">⚠️ ${param.error}</div>
        </c:if>

        <%-- Hero avatar --%>
        <div class="profile-hero">
            <div class="avatar-hero">
                <c:choose>
                    <c:when test="${not empty sessionScope.account.avatarUrl}">
                        <img src="${sessionScope.account.avatarUrl}" alt="Avatar"
                             onerror="this.style.display='none';this.parentNode.innerText='${fn:toUpperCase(fn:substring(sessionScope.account.fullName,0,1))}'"/>
                    </c:when>
                    <c:otherwise>
                        ${fn:toUpperCase(fn:substring(sessionScope.account.fullName,0,1))}
                    </c:otherwise>
                </c:choose>
            </div>
            <div class="hero-info">
                <h2>${sessionScope.account.fullName}</h2>
                <div class="sub">@${sessionScope.account.userName} · ${sessionScope.account.email}</div>
                <div class="sub" style="margin-top:2px;">📞 ${sessionScope.account.phone}</div>
                <c:choose>
                    <c:when test="${sessionScope.account.online}">
                        <span class="online-pill online">● Đang Online</span>
                    </c:when>
                    <c:otherwise>
                        <span class="online-pill offline">● Ngoại tuyến</span>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <%-- 1. Thông tin cá nhân --%>
        <div class="section-card">
            <div class="section-title">📝 Thông tin cá nhân</div>
            <form action="${pageContext.request.contextPath}/shipper/profile" method="post">
                <input type="hidden" name="action" value="updateInfo"/>
                <div class="form-grid">
                    <div class="form-group">
                        <label>Họ và tên *</label>
                        <input type="text" name="fullName" value="${sessionScope.account.fullName}" required placeholder="Nguyễn Văn A"/>
                    </div>
                    <div class="form-group">
                        <label>Số điện thoại</label>
                        <input type="text" name="phone" value="${sessionScope.account.phone}" placeholder="0901234567"/>
                    </div>
                    <div class="form-group">
                        <label>Email *</label>
                        <input type="email" name="email" value="${sessionScope.account.email}" required placeholder="you@example.com"/>
                    </div>
                    <div class="form-group">
                        <label>URL ảnh đại diện</label>
                        <input type="url" name="avatarUrl" value="${sessionScope.account.avatarUrl}" placeholder="https://..."/>
                    </div>
                </div>
                <button type="submit" class="btn-submit" style="margin-top:16px;">💾 Lưu thông tin</button>
            </form>
        </div>

        <%-- 2. Giấy tờ nghề nghiệp --%>
        <div class="section-card">
            <div class="section-title">🪪 Giấy tờ nghề nghiệp</div>
            <form action="${pageContext.request.contextPath}/shipper/profile" method="post">
                <input type="hidden" name="action" value="updateVehicle"/>
                <div class="form-grid">
                    <div class="form-group">
                        <label>Số CCCD / CMND</label>
                        <input type="text" name="cccd" value="${profile.cccd}"
                               placeholder="0123456789" maxlength="20"/>
                    </div>
                    <div class="form-group">
                        <label>Số giấy phép lái xe (GPLX)</label>
                        <input type="text" name="licenseNumber" value="${profile.licenseNumber}"
                               placeholder="010000012345" maxlength="30"/>
                    </div>
                    <div class="form-group">
                        <label>Loại phương tiện *</label>
                        <select name="vehicleType">
                            <option value="">-- Chọn loại --</option>
                            <c:set var="vt" value="${profile.vehicleType}"/>
                            <option value="Xe máy"       ${vt == 'Xe máy'       ? 'selected' : ''}>🏍️ Xe máy</option>
                            <option value="Xe đạp điện"  ${vt == 'Xe đạp điện'  ? 'selected' : ''}>⚡ Xe đạp điện</option>
                            <option value="Xe đạp"       ${vt == 'Xe đạp'       ? 'selected' : ''}>🚲 Xe đạp</option>
                            <option value="Ô tô"         ${vt == 'Ô tô'         ? 'selected' : ''}>🚗 Ô tô</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Biển số xe *</label>
                        <input type="text" name="vehiclePlate" value="${profile.vehiclePlate}"
                               placeholder="51F-123.45" style="text-transform:uppercase;" maxlength="20"/>
                    </div>
                    <div class="form-group full">
                        <label>Nhãn hiệu / Model xe</label>
                        <input type="text" name="vehicleModel" value="${profile.vehicleModel}"
                               placeholder="Honda Wave Alpha 2022"/>
                    </div>
                    <div class="form-group">
                        <label>Số tài khoản ngân hàng</label>
                        <input type="text" name="bankAccount" value="${profile.bankAccount}"
                               placeholder="1234567890" maxlength="30"/>
                    </div>
                    <div class="form-group">
                        <label>Tên ngân hàng</label>
                        <input type="text" name="bankName" value="${profile.bankName}"
                               placeholder="Vietcombank, MB Bank, ..."/>
                    </div>
                </div>
                <button type="submit" class="btn-submit" style="margin-top:16px;">💾 Lưu thông tin nghề nghiệp</button>
            </form>
        </div>

    </div><%-- end content --%>
</main>

<script>
    // Dark/Light mode
    const html = document.documentElement;
    const saved = localStorage.getItem('shipper-theme') || 'light';
    html.setAttribute('data-theme', saved);
    document.getElementById('themeToggleBtn').addEventListener('click', () => {
        const t = html.getAttribute('data-theme') === 'dark' ? 'light' : 'dark';
        html.setAttribute('data-theme', t);
        localStorage.setItem('shipper-theme', t);
    });

    // Tự động cuộn đến thông báo nếu có
    const alert = document.querySelector('.alert');
    if (alert) alert.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
</script>

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
</script></body>
</html>
