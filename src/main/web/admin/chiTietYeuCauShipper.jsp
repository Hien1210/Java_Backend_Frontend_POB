<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:if test="${empty sessionScope.account || sessionScope.account.roleId != 1}">
    <c:redirect url="/dangnhap"/>
</c:if>
<!DOCTYPE html>
<html lang="vi" data-theme="dark">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết Shipper - Super Admin</title>
    <style>
        :root[data-theme="dark"] { --bg-base:#151521; --bg-sidebar:#1e1e2d; --bg-panel:#1e1e2d; --bg-input:#111119; --bg-hover:#1b1b29; --text-main:#ffffff; --text-muted:#a1a5b7; --text-dim:#565674; --border-color:#2b2b40; --topbar-bg:#1e1e2d; }
        :root[data-theme="light"] { --bg-base:#f1f5f9; --bg-sidebar:#ffffff; --bg-panel:#ffffff; --bg-input:#f8fafc; --bg-hover:#f1f5f9; --text-main:#0f172a; --text-muted:#64748b; --text-dim:#94a3b8; --border-color:#e2e8f0; --topbar-bg:#ffffff; }
        :root { --primary:#20d489; --warning:#facc15; --danger:#ef4444; --info:#3b82f6; }
        * { box-sizing:border-box; margin:0; padding:0; transition:background-color 0.3s,border-color 0.3s,color 0.3s; }
        body { font-family:'Segoe UI',Tahoma,Geneva,Verdana,sans-serif; background:var(--bg-base); color:var(--text-muted); display:flex; height:100vh; overflow:hidden; }
        .sidebar { width:260px; background:var(--bg-sidebar); display:flex; flex-direction:column; border-right:1px solid var(--border-color); height:100%; flex-shrink:0; }
        .sidebar-brand { padding:20px 25px; display:flex; flex-direction:column; gap:10px; border-bottom:1px solid var(--border-color); }
        .logo-icon { background:var(--primary); color:#fff; width:32px; height:32px; border-radius:6px; display:flex; align-items:center; justify-content:center; font-weight:bold; font-size:16px; }
        .brand-text { display:flex; flex-direction:column; flex:1; }
        .brand-title { color:var(--text-main); font-weight:700; font-size:14px; }
        .brand-subtitle { color:var(--warning); font-size:10px; }
        .badge-system { background:rgba(32,212,137,0.1); color:var(--primary); font-size:10px; padding:4px 8px; border-radius:4px; border:1px solid var(--primary); }
        .menu-section { padding:15px 0; overflow-y:auto; }
        .menu-title { font-size:11px; text-transform:uppercase; color:var(--text-dim); margin:15px 25px 10px; font-weight:600; }
        .menu-item { padding:12px 25px; display:flex; align-items:center; justify-content:space-between; color:var(--text-muted); text-decoration:none; font-size:13px; transition:all 0.2s; border-left:3px solid transparent; }
        .menu-item:hover { background:var(--bg-hover); color:var(--text-main); transform:translateX(4px); }
        .menu-item.active { background:rgba(32,212,137,0.1); color:var(--primary); border-left-color:var(--primary); }
        .menu-item-left { display:flex; align-items:center; gap:12px; }
        .main-content { flex:1; display:flex; flex-direction:column; overflow:hidden; background:var(--bg-base); }
        .top-header { height:70px; background:var(--topbar-bg); border-bottom:1px solid var(--border-color); display:flex; align-items:center; justify-content:space-between; padding:0 30px; flex-shrink:0; }
        .top-header h2 { color:var(--text-main); font-size:18px; font-weight:600; }
        .header-actions { display:flex; align-items:center; gap:15px; }
        .avatar { width:35px; height:35px; background:var(--warning); border-radius:50%; display:flex; align-items:center; justify-content:center; color:#151521; font-weight:bold; font-size:14px; }
        .theme-toggle { background:var(--bg-input); border:1px solid var(--border-color); width:38px; height:38px; border-radius:8px; cursor:pointer; display:flex; align-items:center; justify-content:center; color:var(--text-main); font-size:16px; }
        .btn-logout { display:flex; align-items:center; gap:6px; padding:8px 14px; border-radius:6px; background:rgba(239,68,68,0.1); color:var(--danger); text-decoration:none; font-size:13px; font-weight:600; border:1px solid transparent; }
        .btn-logout:hover { background:var(--danger); color:white; }
        .content-wrapper { padding:30px; overflow-y:auto; flex:1; }
        .section-title-wrapper { display:flex; align-items:center; gap:10px; margin-bottom:8px; }
        .indicator { width:8px; height:16px; background:var(--warning); border-radius:2px; }
        .section-title { color:var(--warning); font-size:14px; font-weight:700; text-transform:uppercase; }
        .detail-grid { display:grid; grid-template-columns:1fr 1fr; gap:22px; margin-top:20px; }
        .info-card { background:var(--bg-panel); border-radius:10px; padding:24px; border:1px solid var(--border-color); }
        .info-card h3 { color:var(--warning); font-size:14px; font-weight:700; margin-bottom:20px; text-transform:uppercase; border-left:3px solid var(--warning); padding-left:10px; }
        .info-row { display:flex; padding:10px 0; border-bottom:1px solid var(--border-color); }
        .info-row:last-child { border-bottom:none; }
        .info-label { width:140px; font-weight:600; color:var(--text-muted); font-size:13px; }
        .info-value { flex:1; color:var(--text-main); word-break:break-word; font-size:13px; }
        .action-group { display:flex; gap:15px; margin-top:25px; flex-wrap:wrap; }
        .btn { display:inline-block; padding:10px 24px; border-radius:6px; font-weight:600; font-size:13px; transition:all 0.2s; text-align:center; cursor:pointer; text-decoration:none; border:none; }
        .btn:hover { transform:translateY(-2px); box-shadow:0 6px 14px rgba(0,0,0,0.15); }
        .btn-approve { background:var(--primary); color:#151521; }
        .btn-approve:hover { background:#1ab877; }
        .btn-reject { background:var(--danger); color:white; }
        .btn-reject:hover { background:#b91c1c; }
        .btn-back { background:#475569; color:white; display:inline-block; margin-bottom:20px; }
        .btn-back:hover { background:#334155; }
        .badge-pending { background:rgba(250,204,21,0.15); color:var(--warning); border:1px solid var(--warning); padding:3px 10px; border-radius:12px; font-size:12px; font-weight:600; }
        .error-msg { background:rgba(239,68,68,0.1); border:1px solid var(--danger); color:var(--danger); padding:15px; border-radius:8px; margin-bottom:20px; font-weight:bold; }
        .empty { padding:30px; background:var(--bg-panel); color:var(--primary); text-align:center; font-size:15px; border-radius:10px; border:1px dashed var(--border-color); }
        .no-profile { color:var(--text-dim); font-style:italic; }
        @media (max-width:820px) { .detail-grid { grid-template-columns:1fr; } }
    </style>
    <script>
        function confirmReject() {
            return confirm('Xác nhận TỪ CHỐI tài khoản shipper này?\nTài khoản sẽ bị khóa (BLOCKED).');
        }
    </script>
</head>
<body>
<aside class="sidebar">
    <div class="sidebar-brand">
        <div style="display:flex;align-items:center;gap:12px;width:100%">
            <div class="logo-icon">S</div>
            <div class="brand-text"><span class="brand-title">SUPER</span><span class="brand-subtitle">ADMIN PANEL</span></div>
            <span class="badge-system">SYSTEM</span>
        </div>
        <div style="font-size:12px;color:var(--text-muted)">👋 Hi, <strong style="color:var(--primary)">${sessionScope.account.userName}</strong></div>
    </div>
    <div class="menu-section">
        <div class="menu-title">QUẢN LÝ HỆ THỐNG</div>
        <a href="${pageContext.request.contextPath}/tong-quan" class="menu-item"><div class="menu-item-left"><span style="font-size:16px">⊞</span> Tổng quan hệ thống</div></a>
        <a href="${pageContext.request.contextPath}/super-admin/shop-requests" class="menu-item"><div class="menu-item-left"><span style="font-size:16px">🏪</span> Duyệt Shop</div></a>
        <a href="${pageContext.request.contextPath}/super-admin/shipper-requests" class="menu-item active"><div class="menu-item-left"><span style="font-size:16px">🛵</span> Duyệt Shipper</div></a>
        <div class="menu-title" style="margin-top:25px">QUẢN LÝ DỮ LIỆU</div>
        <a href="${pageContext.request.contextPath}/quanlitaikhoan" class="menu-item"><div class="menu-item-left"><span style="font-size:16px">👤</span> Người dùng</div></a>
        <a href="${pageContext.request.contextPath}/Category" class="menu-item"><div class="menu-item-left"><span style="font-size:16px">📂</span> Danh mục món ăn</div></a>
        <a href="${pageContext.request.contextPath}/product" class="menu-item"><div class="menu-item-left"><span style="font-size:16px">🍽️</span> Sản phẩm</div></a>
    </div>
</aside>
<main class="main-content">
    <header class="top-header">
        <h2>CHI TIẾT YÊU CẦU DUYỆT SHIPPER</h2>
        <div class="header-actions">
            <button type="button" class="theme-toggle" id="themeToggleBtn">🌓</button>
            <div class="avatar">AD</div>
            <a href="${pageContext.request.contextPath}/logout" class="btn-logout">🚪 Đăng xuất</a>
        </div>
    </header>
    <div class="content-wrapper">
        <a href="${pageContext.request.contextPath}/super-admin/shipper-requests" class="btn btn-back">← Quay lại danh sách</a>

        <c:if test="${not empty loi}"><div class="error-msg">⚠️ <c:out value="${loi}"/></div></c:if>

        <c:if test="${not empty shipper}">
            <div class="section-title-wrapper">
                <div class="indicator"></div>
                <h1 class="section-title">CHI TIẾT SHIPPER #<c:out value="${shipper.id}"/> &nbsp;<span class="badge-pending">PENDING</span></h1>
            </div>

            <div class="detail-grid">
                <!-- Thông tin tài khoản -->
                <div class="info-card">
                    <h3>👤 THÔNG TIN TÀI KHOẢN</h3>
                    <div class="info-row"><div class="info-label">Họ tên</div><div class="info-value"><c:out value="${shipper.fullName}"/></div></div>
                    <div class="info-row"><div class="info-label">Username</div><div class="info-value">@<c:out value="${shipper.userName}"/></div></div>
                    <div class="info-row"><div class="info-label">Email</div><div class="info-value"><c:out value="${shipper.email}"/></div></div>
                    <div class="info-row"><div class="info-label">Số điện thoại</div><div class="info-value"><c:out value="${shipper.phone}"/></div></div>
                    <div class="info-row"><div class="info-label">Ngày đăng ký</div><div class="info-value"><c:out value="${shipper.createdAt}"/></div></div>
                </div>

                <!-- Thông tin shipper profile -->
                <div class="info-card">
                    <h3>🛵 THÔNG TIN SHIPPER</h3>
                    <c:choose>
                        <c:when test="${not empty profile}">
                            <div class="info-row"><div class="info-label">CCCD</div><div class="info-value"><c:out value="${empty profile.cccd ? '(chưa cung cấp)' : profile.cccd}"/></div></div>
                            <div class="info-row"><div class="info-label">Số GPLX</div><div class="info-value"><c:out value="${empty profile.licenseNumber ? '(chưa cung cấp)' : profile.licenseNumber}"/></div></div>
                            <div class="info-row"><div class="info-label">Loại xe</div><div class="info-value"><c:out value="${empty profile.vehicleType ? '(chưa cung cấp)' : profile.vehicleType}"/></div></div>
                            <div class="info-row"><div class="info-label">Biển số xe</div><div class="info-value"><c:out value="${empty profile.vehiclePlate ? '(chưa cung cấp)' : profile.vehiclePlate}"/></div></div>
                            <div class="info-row"><div class="info-label">Model xe</div><div class="info-value"><c:out value="${empty profile.vehicleModel ? '(chưa cung cấp)' : profile.vehicleModel}"/></div></div>
                            <div class="info-row"><div class="info-label">Số tài khoản NH</div><div class="info-value"><c:out value="${empty profile.bankAccount ? '(chưa cung cấp)' : profile.bankAccount}"/></div></div>
                            <div class="info-row"><div class="info-label">Ngân hàng</div><div class="info-value"><c:out value="${empty profile.bankName ? '(chưa cung cấp)' : profile.bankName}"/></div></div>
                        </c:when>
                        <c:otherwise>
                            <p class="no-profile">Shipper chưa cung cấp thông tin chi tiết.</p>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <div class="action-group">
                <form action="${pageContext.request.contextPath}/super-admin/shipper-requests" method="post">
                    <input type="hidden" name="action" value="accept">
                    <input type="hidden" name="id" value="${shipper.id}">
                    <button type="submit" class="btn btn-approve" onclick="return confirm('Xác nhận DUYỆT shipper [${shipper.userName}]?')">✓ CHẤP NHẬN</button>
                </form>
                <form action="${pageContext.request.contextPath}/super-admin/shipper-requests" method="post">
                    <input type="hidden" name="action" value="reject">
                    <input type="hidden" name="id" value="${shipper.id}">
                    <button type="submit" class="btn btn-reject" onclick="return confirmReject()">✕ TỪ CHỐI</button>
                </form>
            </div>
        </c:if>

        <c:if test="${empty shipper}">
            <div class="empty">Không tìm thấy thông tin shipper.</div>
        </c:if>
    </div>
</main>
<script>
    (function() {
        const html = document.documentElement;
        const btn = document.getElementById('themeToggleBtn');
        html.setAttribute('data-theme', localStorage.getItem('theme') || 'dark');
        btn.addEventListener('click', () => {
            const t = html.getAttribute('data-theme') === 'dark' ? 'light' : 'dark';
            html.setAttribute('data-theme', t);
            localStorage.setItem('theme', t);
        });
    })();
</script>
</body>
</html>
