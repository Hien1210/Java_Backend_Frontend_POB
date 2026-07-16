<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="/app-functions" prefix="app" %>
<c:if test="${empty sessionScope.account || sessionScope.account.roleId != 1}">
    <c:redirect url="/dangnhap"/>
</c:if>
<!DOCTYPE html>
<html lang="vi" data-theme="dark">
<head>
    <meta charset="UTF-8">
    <title>Duyệt Shipper - Super Admin</title>
    <style>
        :root[data-theme="dark"] { --bg-base:#151521; --bg-sidebar:#1e1e2d; --bg-panel:#1e1e2d; --bg-input:#111119; --bg-hover:#1b1b29; --text-main:#ffffff; --text-muted:#a1a5b7; --text-dim:#565674; --border-color:#2b2b40; --topbar-bg:#1e1e2d; --shadow-md:0 4px 6px rgba(0,0,0,0.15); }
        :root[data-theme="light"] { --bg-base:#f1f5f9; --bg-sidebar:#ffffff; --bg-panel:#ffffff; --bg-input:#f8fafc; --bg-hover:#f1f5f9; --text-main:#0f172a; --text-muted:#64748b; --text-dim:#94a3b8; --border-color:#e2e8f0; --topbar-bg:#ffffff; --shadow-md:0 4px 6px rgba(0,0,0,0.06); }
        :root { --primary:#20d489; --warning:#facc15; --danger:#ef4444; --info:#3b82f6; }
        * { box-sizing:border-box; margin:0; padding:0; transition:background-color 0.3s,border-color 0.3s,color 0.3s; }
        body { font-family:'Segoe UI',Tahoma,Geneva,Verdana,sans-serif; background:var(--bg-base); color:var(--text-muted); display:flex; height:100vh; overflow:hidden; }
        .sidebar { width:260px; background:var(--bg-sidebar); display:flex; flex-direction:column; border-right:1px solid var(--border-color); height:100%; flex-shrink:0; }
        .sidebar-brand { padding:20px 25px; display:flex; align-items:center; gap:12px; border-bottom:1px solid var(--border-color); flex-direction:column; align-items:flex-start; gap:10px; }
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
        .badge-count { font-size:10px; padding:3px 8px; border-radius:12px; background:var(--border-color); color:var(--text-main); }
        .badge-count.green { background:var(--primary); color:#151521; font-weight:600; }
        .main-content { flex:1; display:flex; flex-direction:column; overflow:hidden; background:var(--bg-base); }
        .top-header { height:70px; background:var(--topbar-bg); border-bottom:1px solid var(--border-color); display:flex; align-items:center; justify-content:space-between; padding:0 30px; flex-shrink:0; }
        .top-header h2 { color:var(--text-main); font-size:18px; font-weight:600; }
        .header-actions { display:flex; align-items:center; gap:15px; }
        .avatar { width:35px; height:35px; background:var(--warning); border-radius:50%; display:flex; align-items:center; justify-content:center; color:#151521; font-weight:bold; font-size:14px; }
        .theme-toggle { background:var(--bg-input); border:1px solid var(--border-color); width:38px; height:38px; border-radius:8px; cursor:pointer; display:flex; align-items:center; justify-content:center; color:var(--text-main); font-size:16px; }
        .theme-toggle:hover { background:var(--border-color); }
        .btn-logout { display:flex; align-items:center; gap:6px; padding:8px 14px; border-radius:6px; background:rgba(239,68,68,0.1); color:var(--danger); text-decoration:none; font-size:13px; font-weight:600; border:1px solid transparent; }
        .btn-logout:hover { background:var(--danger); color:white; }
        .content-wrapper { padding:30px; overflow-y:auto; flex:1; }
        .section-header { display:flex; justify-content:space-between; align-items:flex-start; margin-bottom:20px; }
        .section-title-wrapper { display:flex; align-items:center; gap:10px; margin-bottom:8px; }
        .indicator { width:8px; height:16px; background:var(--warning); border-radius:2px; }
        .section-title { color:var(--warning); font-size:14px; font-weight:700; text-transform:uppercase; }
        .section-desc { color:var(--text-muted); font-size:13px; margin-left:18px; }
        .section-desc strong { color:var(--text-main); }
        .table-card { background:var(--bg-panel); border-radius:10px; overflow:hidden; border:1px solid var(--border-color); box-shadow:var(--shadow-md); }
        table { width:100%; border-collapse:collapse; }
        th,td { padding:16px 20px; text-align:left; }
        th { background:var(--bg-input); color:var(--text-muted); font-size:12px; font-weight:600; text-transform:uppercase; border-bottom:1px solid var(--border-color); }
        td { border-bottom:1px solid var(--border-color); color:var(--text-main); font-size:14px; vertical-align:middle; }
        tr:hover td { background:var(--bg-hover); }
        tr:last-child td { border-bottom:none; }
        .action-group { display:flex; gap:8px; align-items:center; }
        .btn { display:inline-block; padding:6px 12px; border-radius:6px; font-weight:600; font-size:11px; transition:all 0.2s; text-align:center; text-transform:uppercase; cursor:pointer; text-decoration:none; border:1px solid transparent; background:transparent; }
        .btn:hover { transform:translateY(-2px); box-shadow:var(--shadow-md); }
        .btn-info { background:rgba(37,99,235,0.15); color:#60a5fa; border-color:var(--info); }
        .btn-info:hover { background:var(--info); color:white; }
        .btn-approve { background:rgba(32,212,137,0.15); color:var(--primary); border-color:var(--primary); }
        .btn-approve:hover { background:var(--primary); color:#151521; }
        .btn-reject { background:rgba(239,68,68,0.15); color:var(--danger); border-color:var(--danger); }
        .btn-reject:hover { background:var(--danger); color:white; }
        .empty { padding:30px; background:var(--bg-panel); color:var(--primary); text-align:center; font-size:15px; border-radius:10px; border:1px dashed var(--border-color); }
        .error-msg { background:rgba(239,68,68,0.1); border:1px solid var(--danger); color:var(--danger); padding:15px; border-radius:8px; margin-bottom:20px; font-weight:bold; }
        .success-msg { background:rgba(32,212,137,0.1); border:1px solid var(--primary); color:var(--primary); padding:15px; border-radius:8px; margin-bottom:20px; font-weight:bold; }
    </style>
    <script>
        function confirmReject(id, name) {
            if (!confirm('Xác nhận TỪ CHỐI tài khoản shipper [' + name + ']?\nTài khoản sẽ bị khóa (BLOCKED).')) return false;
            return true;
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
        <a href="${pageContext.request.contextPath}/super-admin/shipper-requests" class="menu-item active">
            <div class="menu-item-left"><span style="font-size:16px">🛵</span> Duyệt Shipper</div>
            <c:if test="${not empty pendingShippers}"><span class="badge-count green">${pendingShippers.size()} mới</span></c:if>
        </a>
        <div class="menu-title" style="margin-top:25px">QUẢN LÝ DỮ LIỆU</div>
        <a href="${pageContext.request.contextPath}/quanlitaikhoan" class="menu-item"><div class="menu-item-left"><span style="font-size:16px">👤</span> Người dùng</div></a>
        <a href="${pageContext.request.contextPath}/Category" class="menu-item"><div class="menu-item-left"><span style="font-size:16px">📂</span> Danh mục món ăn</div></a>
        <a href="${pageContext.request.contextPath}/product" class="menu-item"><div class="menu-item-left"><span style="font-size:16px">🍽️</span> Sản phẩm</div></a>
    </div>
</aside>
<main class="main-content">
    <header class="top-header">
        <h2>HỆ THỐNG DUYỆT SHIPPER</h2>
        <div class="header-actions">
            <button type="button" class="theme-toggle" id="themeToggleBtn">🌓</button>
            <div class="avatar">AD</div>
            <a href="${pageContext.request.contextPath}/logout" class="btn-logout">🚪 Đăng xuất</a>
        </div>
    </header>
    <div class="content-wrapper">
        <c:if test="${not empty loi}"><div class="error-msg">⚠️ <c:out value="${loi}"/></div></c:if>
        <c:if test="${param.success == 'accepted'}"><div class="success-msg">✅ Đã duyệt shipper thành công!</div></c:if>
        <c:if test="${param.success == 'rejected'}"><div class="success-msg">✅ Đã từ chối shipper.</div></c:if>

        <div class="section-header">
            <div>
                <div class="section-title-wrapper"><div class="indicator"></div><h1 class="section-title">DANH SÁCH SHIPPER CHỜ DUYỆT</h1></div>
                <p class="section-desc">Tài khoản shipper có trạng thái <strong>PENDING</strong> chờ xét duyệt.</p>
            </div>
        </div>

        <c:choose>
            <c:when test="${empty pendingShippers}">
                <div class="empty">Hiện không có tài khoản Shipper nào đang chờ duyệt.</div>
            </c:when>
            <c:otherwise>
                <div class="table-card">
                    <table>
                        <thead>
                        <tr>
                            <th>#</th>
                            <th>Họ tên / Username</th>
                            <th>Email</th>
                            <th>Số điện thoại</th>
                            <th>Ngày đăng ký</th>
                            <th>Thao tác</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="s" items="${pendingShippers}" varStatus="vs">
                            <tr>
                                <td style="color:var(--warning);font-weight:bold">${vs.index + 1}</td>
                                <td>
                                    <strong><c:out value="${s.fullName}"/></strong><br>
                                    <span style="font-size:12px;color:var(--text-dim)">@<c:out value="${s.userName}"/></span>
                                </td>
                                <td><c:out value="${s.email}"/></td>
                                <td>📞 <c:out value="${s.phone}"/></td>
                                <td>${app:formatDateTime(s.createdAt)}</td>
                                <td>
                                    <div class="action-group">
                                        <a class="btn btn-info" href="${pageContext.request.contextPath}/super-admin/shipper-requests?action=detail&id=${s.id}">Chi tiết</a>
                                        <form action="${pageContext.request.contextPath}/super-admin/shipper-requests" method="post" style="margin:0">
                                            <input type="hidden" name="action" value="accept">
                                            <input type="hidden" name="id" value="${s.id}">
                                            <button type="submit" class="btn btn-approve" onclick="return confirm('Xác nhận DUYỆT shipper [${s.userName}]?')">✓ Duyệt</button>
                                        </form>
                                        <form action="${pageContext.request.contextPath}/super-admin/shipper-requests" method="post" style="margin:0">
                                            <input type="hidden" name="action" value="reject">
                                            <input type="hidden" name="id" value="${s.id}">
                                            <button type="submit" class="btn btn-reject" onclick="return confirmReject('${s.id}', '${s.userName}')">✕ Từ chối</button>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:otherwise>
        </c:choose>
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
    <script src="${pageContext.request.contextPath}/assets/js/toast.js"></script>
</body>
</html>
