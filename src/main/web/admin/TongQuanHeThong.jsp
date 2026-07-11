<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%-- BẢO MẬT: KIỂM TRA QUYỀN SUPER ADMIN --%>
<c:if test="${empty sessionScope.account || sessionScope.account.roleId != 1}">
    <c:redirect url="/dangnhap"/>
</c:if>

<!DOCTYPE html>
<html lang="vi" data-theme="dark">
<head>
    <meta charset="UTF-8">
    <title>Tổng quan hệ thống - Super Admin</title>
    <style>
        /* ================= BIẾN THEME (DARK/LIGHT) ================= */
        :root[data-theme="dark"] {
            --bg-base: #0f172a;
            --bg-sidebar: #1e293b;
            --bg-panel: #1e293b;
            --bg-input: #0f172a;
            --bg-hover: #1e293b;
            --text-main: #f8fafc;
            --text-muted: #94a3b8;
            --text-dim: #64748b;
            --border-color: #334155;
            --topbar-bg: rgba(30, 41, 59, 0.8);
            --shadow-sm: 0 1px 2px 0 rgb(0 0 0 / 0.05);
            --shadow-md: 0 4px 6px -1px rgb(0 0 0 / 0.1);
        }

        :root[data-theme="light"] {
            --bg-base: #f1f5f9;
            --bg-sidebar: #ffffff;
            --bg-panel: #ffffff;
            --bg-input: #f8fafc;
            --bg-hover: #f1f5f9;
            --text-main: #0f172a;
            --text-muted: #64748b;
            --text-dim: #94a3b8;
            --border-color: #e2e8f0;
            --topbar-bg: rgba(255, 255, 255, 0.8);
            --shadow-sm: 0 1px 3px 0 rgba(0,0,0,0.1);
            --shadow-md: 0 4px 6px -1px rgba(0,0,0,0.05);
        }

        :root {
            --primary: #10b981;
            --primary-hover: #059669;
            --primary-light: rgba(16, 185, 129, 0.15);
            --warning: #f59e0b;
            --danger: #ef4444;
            --danger-light: rgba(239, 68, 68, 0.1);
            --info: #3b82f6;
            --font-family: system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
        }

        * { box-sizing: border-box; margin: 0; padding: 0; font-family: var(--font-family); transition: background-color 0.3s ease, border-color 0.3s ease, color 0.3s ease; }
        body { background-color: var(--bg-base); color: var(--text-muted); display: flex; height: 100vh; overflow: hidden; }
        a { text-decoration: none; color: inherit; }
        ul { list-style: none; }

        /* SIDEBAR */
        .sidebar { width: 260px; background-color: var(--bg-sidebar); border-right: 1px solid var(--border-color); display: flex; flex-direction: column; flex-shrink: 0; box-shadow: var(--shadow-sm); z-index: 10; }
        .brand { padding: 24px; display: flex; align-items: center; gap: 12px; border-bottom: 1px solid var(--border-color); }
        .logo { background: linear-gradient(135deg, var(--primary), #3b82f6); color: #fff; width: 36px; height: 36px; border-radius: 10px; display: flex; align-items: center; justify-content: center; font-weight: 800; font-size: 18px; box-shadow: 0 4px 12px rgba(16, 185, 129, 0.3); }
        .brand-text { display: flex; flex-direction: column; }
        .brand-title { color: var(--text-main); font-weight: 700; font-size: 15px; letter-spacing: 0.5px; }
        .badge-system { background: var(--primary-light); color: var(--primary); font-size: 10px; padding: 3px 6px; border-radius: 4px; border: 1px solid var(--primary); margin-left: auto; }

        .menu { padding: 20px 12px; flex: 1; overflow-y: auto; overflow-x: hidden; }
        .menu-title { font-size: 11px; color: var(--text-muted); font-weight: 700; margin: 20px 12px 8px; letter-spacing: 1px; text-transform: uppercase; }
        .menu-item { padding: 12px 20px; display: flex; align-items: center; justify-content: space-between; color: var(--text-muted); font-size: 14px; transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1); border-radius: 8px; margin-bottom: 4px; font-weight: 500; }
        .menu-item:hover { background-color: var(--bg-input); color: var(--text-main); transform: translateX(4px); }
        .menu-item.active { background-color: var(--primary-light); color: var(--primary); font-weight: 600; }
        .badge { font-size: 10px; padding: 3px 8px; border-radius: 10px; background: var(--border-color); color: var(--text-main); }
        .badge.yellow { background: var(--warning); color: #0f172a; font-weight: 600; }

        /* MAIN CONTENT */
        .main { flex: 1; display: flex; flex-direction: column; overflow: hidden; }
        .topbar { background-color: var(--topbar-bg); backdrop-filter: blur(12px); -webkit-backdrop-filter: blur(12px); padding: 16px 32px; display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid var(--border-color); }
        .topbar h1 { color: var(--text-main); font-size: 20px; font-weight: 700; letter-spacing: -0.5px; }
        .topbar-right { display: flex; align-items: center; gap: 20px; }
        .avatar-circle { background: var(--warning); color: #151521; width: 38px; height: 38px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: 700; font-size: 14px; box-shadow: var(--shadow-sm); }

        /* Nút chuyển đổi Dark/Light */
        .theme-toggle { background: var(--bg-input); border: 1px solid var(--border-color); width: 38px; height: 38px; border-radius: 8px; cursor: pointer; display: flex; align-items: center; justify-content: center; color: var(--text-main); font-size: 16px; transition: all 0.2s ease; }
        .theme-toggle:hover { background: var(--border-color); transform: scale(1.05); }

        .content { padding: 25px 30px; overflow-y: auto; flex: 1; display: flex; flex-direction: column; gap: 25px; }

        /* CARDS THỐNG KÊ */
        .stats-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px; }
        .stat-card { background: var(--bg-panel); border: 1px solid var(--border-color); border-radius: 8px; padding: 20px; display: flex; flex-direction: column; border-top: 3px solid var(--border-color); transition: all 0.2s ease;}
        .stat-card:hover { transform: translateY(-3px); box-shadow: 0 6px 14px rgba(0,0,0,0.15); }
        .stat-card:nth-child(1) { border-top-color: var(--info); }
        .stat-card:nth-child(2) { border-top-color: var(--warning); }
        .stat-card:nth-child(3) { border-top-color: var(--primary); }
        .stat-card:nth-child(4) { border-top-color: var(--danger); }
        .stat-title { font-size: 12px; text-transform: uppercase; color: var(--text-muted); margin-bottom: 10px; font-weight: bold; }
        .stat-value { font-size: 28px; font-weight: bold; color: var(--text-main); }

        /* BẢNG DỮ LIỆU */
        .panel { background: var(--bg-panel); border: 1px solid var(--border-color); border-radius: 10px; animation: fadeUp 0.35s ease both; padding: 20px; }
        .panel-title { color: var(--warning); font-size: 14px; font-weight: bold; margin-bottom: 20px; text-transform: uppercase; border-left: 4px solid var(--warning); padding-left: 10px; }
        table { width: 100%; border-collapse: collapse; text-align: left; }
        th { padding: 12px 10px; font-size: 11px; color: var(--text-dim); text-transform: uppercase; border-bottom: 1px solid var(--border-color); }
        td { padding: 15px 10px; border-bottom: 1px solid var(--border-color); font-size: 13px; color: var(--text-main); }
        tr:hover td { background-color: var(--primary-light); }

        .btn-logout { display: flex; align-items: center; gap: 6px; padding: 10px 16px; border-radius: 8px; background: var(--danger-light); color: var(--danger); text-decoration: none; font-size: 13px; font-weight: 600; transition: all 0.2s ease; }
        .btn-logout:hover { background: var(--danger); color: white; transform: translateY(-1px); }
    
        @keyframes fadeUp {
            from { opacity: 0; transform: translateY(16px); }
            to   { opacity: 1; transform: translateY(0); }
        }        </style>
</head>
<body>

    <aside class="sidebar">
        <div class="brand" style="flex-direction: column; align-items: flex-start; gap: 10px;">
            <div style="display: flex; align-items: center; gap: 12px; width: 100%;">
                <div class="logo">S</div>
                <div class="brand-text">
                    <span class="brand-title">SUPER ADMIN</span>
                </div>
            </div>
            <div style="font-size: 12px; color: var(--text-muted); padding-left: 2px;">
                👋 Hi, <strong style="color: var(--primary);">${sessionScope.account.userName}</strong>
            </div>
        </div>
        <ul class="menu">
            <div class="menu-title">Quản lý hệ thống</div>
            <a href="${pageContext.request.contextPath}/tong-quan">
                <li class="menu-item active"><span>⊞ Tổng quan hệ thống</span></li>
            </a>
            <a href="${pageContext.request.contextPath}/super-admin/shop-requests">
                <li class="menu-item">
                    <span>🏪 Duyệt Shop</span>
                    <c:if test="${shopChoDuyet > 0}">
                        <span class="badge yellow">${shopChoDuyet} mới</span>
                    </c:if>
                </li>
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
                <div class="menu-item-left"><span style="font-size: 16px;">📂</span> Danh mục món ăn</div>
            </a>
            <a href="${pageContext.request.contextPath}/product" class="menu-item">
                <div class="menu-item-left"><span style="font-size: 16px;">🍽️</span> Sản phẩm</div>
            </a>

        </ul>
    </aside>

    <main class="main">
        <header class="topbar">
            <h1>TỔNG QUAN HỆ THỐNG DỮ LIỆU</h1>
            <div class="topbar-right">
                <button type="button" class="theme-toggle" id="themeToggleBtn" title="Chuyển đổi giao diện">🌓</button>
                <div class="avatar-circle">AD</div>
                <a href="${pageContext.request.contextPath}/logout" class="btn-logout">🚪 Đăng xuất</a>
            </div>
        </header>

        <div class="content">
            <!-- 4 CARD THỐNG KÊ -->
            <div class="stats-grid">
                <div class="stat-card">
                    <span class="stat-title">Tổng Tài Khoản Hệ Thống</span>
                    <span class="stat-value">${tongTaiKhoan}</span>
                </div>
                <div class="stat-card">
                    <span class="stat-title">Shop Chờ Phê Duyệt</span>
                    <span class="stat-value" style="color: var(--warning);">${shopChoDuyet}</span>
                </div>
                <div class="stat-card">
                    <span class="stat-title">Shipper Đang Hoạt Động</span>
                    <span class="stat-value" style="color: var(--primary);">${shipperHoatDong}</span>
                </div>
                <div class="stat-card">
                    <span class="stat-title">Cảnh Báo Vi Phạm</span>
                    <span class="stat-value" style="color: var(--danger);">${canhBaoViPham}</span>
                </div>
            </div>

            <!-- BẢNG TOP 5 YÊU CẦU DUYỆT SHOP -->
            <div class="panel">
                <div class="panel-title">■ YÊU CẦU DUYỆT SHOP GẦN ĐÂY</div>
                <table>
                    <thead>
                        <tr>
                            <th>Người đăng ký</th>
                            <th>Email</th>
                            <th>Ngày đăng ký</th>
                            <th>Trạng thái</th>
                        </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="account" items="${top5Shop}">
                            <tr>
                                <td>
                                    <strong style="color: var(--text-main);">${account.fullName}</strong><br>
                                    <span style="font-size: 12px; color: var(--text-dim);">📞 ${account.phone}</span>
                                </td>
                                <td style="color: var(--text-muted);">${account.email}</td>
                                <td style="color: var(--text-muted);">${account.createdAt}</td>
                                <td style="color: var(--warning); font-weight: bold;">⏳ Chờ xử lý</td>
                            </tr>
                        </c:forEach>

                        <c:if test="${empty top5Shop}">
                            <tr>
                                <td colspan="4" style="text-align: center; color: var(--text-dim); padding: 20px;">
                                    🏪 Hiện chưa có yêu cầu đăng ký shop nào.<br>
                                    Bấm vào menu <b>"Duyệt Shop"</b> để xem toàn bộ danh sách từ Database.
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </main>

    <script>
        (function () {
            const htmlElement = document.documentElement;
            const themeToggleBtn = document.getElementById('themeToggleBtn');
            const savedTheme = localStorage.getItem('theme') || 'dark';
            htmlElement.setAttribute('data-theme', savedTheme);

            themeToggleBtn.addEventListener('click', () => {
                const currentTheme = htmlElement.getAttribute('data-theme');
                const newTheme = currentTheme === 'dark' ? 'light' : 'dark';
                htmlElement.setAttribute('data-theme', newTheme);
                localStorage.setItem('theme', newTheme);
            });
        })();
    </script>
</body>
</html>


