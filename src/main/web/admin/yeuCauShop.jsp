<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="/app-functions" prefix="app" %>

<%-- BẢO MẬT: KIỂM TRA QUYỀN SUPER ADMIN --%>
<c:if test="${empty sessionScope.account || sessionScope.account.roleId != 1}">
    <c:redirect url="/dangnhap"/>
</c:if>

<!DOCTYPE html>
<html lang="vi" data-theme="dark">
<head>
    <meta charset="UTF-8">
    <title>Quản lý yêu cầu shop - Super Admin</title>
    <style>
        /* ================= BIẾN THEME (DARK/LIGHT) ================= */
        :root[data-theme="dark"] {
            --bg-base: #0f172a;
            --bg-sidebar: #1e293b;
            --bg-panel: #1e293b;
            --bg-input: #111119;
            --bg-hover: #1e293b;
            --text-main: #f8fafc;
            --text-muted: #94a3b8;
            --text-dim: #565674;
            --border-color: #334155;
            --topbar-bg: rgba(30, 41, 59, 0.8);
            --shadow-md: 0 4px 6px rgba(0,0,0,0.15);
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
            --shadow-md: 0 4px 6px rgba(0,0,0,0.06);
        }

        :root {
            --primary: #10b981;
            --warning: #f59e0b;
            --primary-hover: #059669;
            --primary-light: rgba(16, 185, 129, 0.15);
            --danger-light: rgba(239, 68, 68, 0.1);
            --font-family: system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
            --danger: #ef4444;
            --info: #3b82f6;
        }

        /* Reset cơ bản */
        * { box-sizing: border-box; margin: 0; padding: 0; transition: background-color 0.3s ease, border-color 0.3s ease, color 0.3s ease; }
        body { font-family: var(--font-family); background-color: var(--bg-base); color: var(--text-muted); display: flex; height: 100vh; overflow: hidden; }

        /* Sidebar */
        .sidebar { width: 260px; background-color: var(--bg-sidebar); display: flex; flex-direction: column; border-right: 1px solid var(--border-color); height: 100%; flex-shrink: 0; transition: width 0.3s ease; overflow: hidden; }
        .sidebar-brand { padding: 20px 25px; display: flex; align-items: center; gap: 12px; border-bottom: 1px solid var(--border-color); transition: padding 0.3s ease; }
        .logo-icon { background: linear-gradient(135deg, var(--primary), #3b82f6); color: #fff; width: 36px; height: 36px; border-radius: 10px; display: flex; align-items: center; justify-content: center; font-weight: 800; font-size: 18px; box-shadow: 0 4px 12px rgba(16, 185, 129, 0.3); flex-shrink: 0; }
        .brand-text { display: flex; flex-direction: column; flex: 1; }
        .brand-title { color: var(--text-main); font-weight: 700; font-size: 14px; letter-spacing: 0.5px; }
        .brand-subtitle { color: var(--warning); font-size: 10px; }
        .badge-system { background: var(--primary-light); color: var(--primary); font-size: 10px; padding: 4px 8px; border-radius: 4px; border: 1px solid var(--primary); flex-shrink: 0; }
        .sidebar-toggle-btn { background: var(--bg-input); border: 1px solid var(--border-color); width: 30px; height: 30px; border-radius: 6px; display: flex; align-items: center; justify-content: center; color: var(--text-main); cursor: pointer; flex-shrink: 0; transition: all 0.2s ease; }
        .sidebar-toggle-btn:hover { background: var(--border-color); }

        .menu-section { padding: 15px 12px; overflow-y: auto; overflow-x: hidden; }
        .menu-title { font-size: 11px; text-transform: uppercase; color: var(--text-dim); margin: 15px 8px 10px; font-weight: 600; letter-spacing: 0.5px; white-space: nowrap; }
        .menu-item { padding: 12px 16px; display: flex; align-items: center; justify-content: space-between; color: var(--text-muted); text-decoration: none; font-size: 13px; transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1); border-radius: 8px; margin-bottom: 4px; white-space: nowrap; }
        .menu-item:hover { background-color: var(--bg-input); color: var(--text-main); transform: translateX(4px); }
        .menu-item.active { background-color: var(--primary-light); color: var(--primary); font-weight: 600; }
        .menu-item-left { display: flex; align-items: center; gap: 12px; overflow: hidden; }
        .badge-count { font-size: 10px; padding: 3px 8px; border-radius: 12px; background: var(--border-color); color: var(--text-main); flex-shrink: 0; }
        .badge-count.green { background: var(--primary); color: #0f172a; font-weight: 600; }

        .sidebar.collapsed { width: 84px; }
        .sidebar.collapsed .sidebar-brand { padding: 16px 8px; }
        .sidebar.collapsed .sidebar-brand > div:first-child { flex-direction: column; gap: 10px; }
        .sidebar.collapsed .brand-text,
        .sidebar.collapsed .badge-system,
        .sidebar.collapsed .sidebar-hi,
        .sidebar.collapsed .menu-title,
        .sidebar.collapsed .menu-label,
        .sidebar.collapsed .badge-count { display: none; }
        .sidebar.collapsed .menu-item { justify-content: center; padding: 12px 0; }
        .sidebar.collapsed .menu-item:hover { transform: none; }
        .sidebar.collapsed .menu-item-left { gap: 0; }

        /* Custom scrollbar cho sidebar */
        .sidebar::-webkit-scrollbar,
        .menu-section::-webkit-scrollbar { width: 6px; }
        .sidebar::-webkit-scrollbar-track,
        .menu-section::-webkit-scrollbar-track { background: var(--bg-sidebar); }
        .sidebar::-webkit-scrollbar-thumb,
        .menu-section::-webkit-scrollbar-thumb { background: var(--border-color); border-radius: 9999px; }
        .sidebar::-webkit-scrollbar-thumb:hover,
        .menu-section::-webkit-scrollbar-thumb:hover { background: var(--text-dim); }
        .menu-section { scrollbar-width: thin; scrollbar-color: var(--border-color) var(--bg-sidebar); }

        /* Main Content & Header */
        .main-content { flex: 1; display: flex; flex-direction: column; overflow: hidden; background-color: var(--bg-base); transition: all 0.3s ease; }
        .top-header { height: 70px; background-color: var(--topbar-bg); border-bottom: 1px solid var(--border-color); display: flex; align-items: center; justify-content: space-between; padding: 0 30px; flex-shrink: 0; }
        .top-header h2 { color: var(--text-main); font-size: 18px; font-weight: 600; }
        .header-actions { display: flex; align-items: center; gap: 15px; }
        .search-bar { background-color: var(--bg-input); border: 1px solid var(--border-color); border-radius: 6px; padding: 8px 15px; color: var(--text-main); width: 280px; outline: none; font-size: 13px; }
        .search-bar:focus { border-color: var(--primary); }
        .avatar { width: 35px; height: 35px; background-color: var(--warning); border-radius: 50%; display: flex; align-items: center; justify-content: center; color: #0f172a; font-weight: bold; font-size: 14px; }

        /* Nút chuyển đổi Dark/Light */
        .theme-toggle { background: var(--bg-input); border: 1px solid var(--border-color); width: 38px; height: 38px; border-radius: 8px; cursor: pointer; display: flex; align-items: center; justify-content: center; color: var(--text-main); font-size: 16px; transition: all 0.2s ease; }
        .theme-toggle:hover { background: var(--border-color); transform: scale(1.08) rotate(15deg); }

        .content-wrapper { padding: 30px; overflow-y: auto; flex: 1; }
        .section-header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 20px; }
        .section-title-wrapper { display: flex; align-items: center; gap: 10px; margin-bottom: 8px; }
        .indicator { width: 8px; height: 16px; background-color: var(--warning); border-radius: 2px; }
        .section-title { color: var(--warning); font-size: 14px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px; }
        .section-desc { color: var(--text-muted); font-size: 13px; margin-left: 18px; }
        .section-desc strong { color: var(--text-main); }

        /* Bảng dữ liệu JSTL */
        .table-card { background-color: var(--bg-panel); border-radius: 10px; overflow: hidden; border: 1px solid var(--border-color); box-shadow: var(--shadow-md); animation: fadeUp 0.35s ease both; }
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 16px 20px; text-align: left; }
        th { background-color: var(--bg-input); color: var(--text-muted); font-size: 12px; font-weight: 600; text-transform: uppercase; border-bottom: 1px solid var(--border-color); }
        td { border-bottom: 1px solid var(--border-color); color: var(--text-main); font-size: 14px; vertical-align: middle; }
        tr td { transition: background-color 0.2s ease, box-shadow 0.2s ease; }
        tr:hover td { background-color: var(--bg-hover); box-shadow: inset 3px 0 0 var(--primary); }
        tr:last-child td { border-bottom: none; }
        td strong { color: var(--text-main); font-weight: 600; }

        /* Hệ thống nút thao tác */
        .action-group { display: flex; gap: 8px; align-items: center; }
        .btn { display: inline-block; padding: 6px 12px; border-radius: 6px; font-weight: 600; font-size: 11px; transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1); text-align: center; text-transform: uppercase; cursor: pointer; text-decoration: none; border: 1px solid transparent; background: transparent;}
        .btn:hover { transform: translateY(-2px); box-shadow: var(--shadow-md); }
        .btn:active { transform: translateY(0); }

        .btn-info { background: rgba(37, 99, 235, 0.15); color: #60a5fa; border-color: var(--info); }
        .btn-info:hover { background: var(--info); color: white; }

        .btn-approve { background: rgba(32, 212, 137, 0.15); color: var(--primary); border-color: var(--primary); }
        .btn-approve:hover { background: var(--primary); color: #0f172a; }

        .btn-reject { background: rgba(239, 68, 68, 0.15); color: var(--danger); border-color: var(--danger); }
        .btn-reject:hover { background: var(--danger); color: white; }

        .btn-header { background: transparent; border-color: var(--warning); color: var(--warning); font-size: 12px; padding: 8px 16px;}
        .btn-header:hover { background: var(--warning); color: #0f172a; }

        .empty { margin: 0; padding: 30px; background: var(--bg-panel); color: var(--primary); text-align: center; font-size: 15px; border-radius: 10px; border: 1px dashed var(--border-color); animation: fadeUp 0.35s ease both; }

        /* Hiển thị lỗi từ Servlet */
        .error-msg { background: var(--danger-light); border: 1px solid var(--danger); color: var(--danger); padding: 15px; border-radius: 8px; margin-bottom: 20px; font-weight: bold; }
    
        @keyframes fadeUp {
            from { opacity: 0; transform: translateY(16px); }
            to   { opacity: 1; transform: translateY(0); }
        }        
        /* AVATAR DROPDOWN */
        .avatar-wrapper { position: relative; }
        .avatar-btn { background: var(--warning); color: #0f172a; width: 38px; height: 38px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: 800; font-size: 13px; cursor: pointer; border: 2px solid transparent; transition: all 0.2s; user-select: none; }
        .avatar-btn:hover { border-color: var(--warning); box-shadow: 0 0 0 3px rgba(245,158,11,0.2); }
        .avatar-dropdown { display: none; position: fixed; right: auto; top: auto;  background: var(--bg-panel); border: 1px solid var(--border-color); border-radius: 12px; box-shadow: 0 12px 32px rgba(0,0,0,0.3); min-width: 220px; z-index: 500; animation: fadeUp 0.2s ease both; }
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
        .dropdown-link.danger:hover { background: var(--danger-light); color: var(--danger); }        </style>

    <script>
        function confirmReject(shopId, shopName) {
            let reason = prompt("Vui lòng nhập lý do từ chối duyệt shop [" + shopName + "]:");
            if (reason === null || reason.trim() === "") {
                alert("Thao tác thất bại: Yêu cầu bắt buộc phải nhập lý do từ chối!");
                return false;
            }
            document.getElementById('reason_' + shopId).value = reason;
            return true;
        }
    </script>
</head>
<body>

    <aside class="sidebar" id="sidebarMain">
       <div class="sidebar-brand" style="flex-direction: column; align-items: flex-start; gap: 10px;">
           <div style="display: flex; align-items: center; justify-content: space-between; gap: 12px; width: 100%;">
               <div style="display: flex; align-items: center; gap: 12px;">
                   <div class="logo-icon">S</div>
                   <div class="brand-text">
                       <span class="brand-title">SUPER</span>
                       <span class="brand-subtitle">ADMIN PANEL</span>
                   </div>
                   <span class="badge-system">SYSTEM</span>
               </div>
               <button type="button" class="sidebar-toggle-btn" id="sidebarToggleBtn" title="Thu gọn/mở rộng menu">
                   <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                       <line x1="3" y1="6" x2="21" y2="6"></line>
                       <line x1="3" y1="12" x2="21" y2="12"></line>
                       <line x1="3" y1="18" x2="21" y2="18"></line>
                   </svg>
               </button>
           </div>
           <div class="sidebar-hi" style="font-size: 12px; color: var(--text-muted); padding-left: 2px;">
               👋 Hi, <strong style="color: var(--primary);">${sessionScope.account.userName}</strong>
           </div>
       </div>
        <div class="menu-section">
            <div class="menu-title">📊 TỔNG QUAN & PHÂN TÍCH</div>
            <a href="${pageContext.request.contextPath}/tong-quan" class="menu-item">
                <div class="menu-item-left"><span style="font-size: 16px;">⊞</span> <span class="menu-label">Tổng quan hệ thống</span></div>
            </a>
            <a href="#" class="menu-item">
                <div class="menu-item-left"><span style="font-size: 16px;">📈</span> <span class="menu-label">Báo cáo vận hành</span></div>
            </a>

            <div class="menu-title" style="margin-top: 25px;">⚖️ KIỂM DUYỆT & ĐIỀU PHỐI</div>
            <a href="${pageContext.request.contextPath}/super-admin/shop-requests" class="menu-item active">
                <div class="menu-item-left"><span style="font-size: 16px;">🏪</span> <span class="menu-label">Duyệt Shop</span></div>
                <c:if test="${shopChoDuyet > 0}">
                    <span class="badge-count green">${shopChoDuyet} mới</span>
                </c:if>
            </a>
            <a href="${pageContext.request.contextPath}/super-admin/shipper-requests" class="menu-item">
                <div class="menu-item-left"><span style="font-size: 16px;">🛵</span> <span class="menu-label">Duyệt Shipper</span></div>
                <c:if test="${not empty pendingShippers}">
                    <span class="badge-count green">${pendingShippers.size()} mới</span>
                </c:if>
            </a>
            <a href="${pageContext.request.contextPath}/admin/kiem-duyet-noi-dung" class="menu-item">
                <div class="menu-item-left"><span style="font-size: 16px;">🚩</span> <span class="menu-label">Kiểm duyệt nội dung</span></div>
            </a>
            <a href="${pageContext.request.contextPath}/admin/appeals" class="menu-item">
                <div class="menu-item-left"><span style="font-size: 16px;">📋</span> <span class="menu-label">Kháng nghị</span></div>
                <c:if test="${pendingCount > 0}">
                    <span class="badge-count green">${pendingCount}</span>
                </c:if>
            </a>

            <div class="menu-title" style="margin-top: 25px;">💰 QUẢN LÝ TÀI CHÍNH</div>
            <a href="#" class="menu-item">
                <div class="menu-item-left"><span style="font-size: 16px;">💵</span> <span class="menu-label">Đối soát doanh thu Shop</span></div>
            </a>
            <a href="#" class="menu-item">
                <div class="menu-item-left"><span style="font-size: 16px;">💳</span> <span class="menu-label">Duyệt rút tiền Shipper</span></div>
            </a>

            <div class="menu-title" style="margin-top: 25px;">⚙️ CẤU HÌNH & HỆ THỐNG</div>
            <a href="${pageContext.request.contextPath}/quanlitaikhoan" class="menu-item">
                <div class="menu-item-left"><span style="font-size: 16px;">👤</span> <span class="menu-label">Người dùng</span></div>
            </a>
            <a href="#" class="menu-item">
                <div class="menu-item-left"><span style="font-size: 16px;">🛠️</span> <span class="menu-label">Tham số vận hành</span></div>
            </a>
            <a href="#" class="menu-item">
                <div class="menu-item-left"><span style="font-size: 16px;">📢</span> <span class="menu-label">Truyền thông & Banner</span></div>
            </a>
        </div>
    </aside>

    <main class="main-content">
        <header class="top-header">
            <h2>HỆ THỐNG XỬ LÝ PHÊ DUYỆT & AN NINH TÀI KHOẢN</h2>
            <div class="header-actions">
                <input type="text" class="search-bar" placeholder="Nhập tên Shop cần xử lý...">
                <button type="button" class="theme-toggle" id="themeToggleBtn" title="Chuyển đổi giao diện">🌓</button>
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

        <div class="content-wrapper">
            <c:if test="${not empty loi}">
                <div class="error-msg">⚠️ <c:out value="${loi}"/></div>
            </c:if>

            <div class="section-header">
                <div>
                    <div class="section-title-wrapper">
                        <div class="indicator"></div>
                        <h1 class="section-title">QUẢN LÝ YÊU CẦU DUYỆT SHOP</h1>
                    </div>
                    <p class="section-desc">Danh sách này chỉ hiển thị shop có trạng thái <strong>pending</strong> từ Database.</p>
                </div>
                <a class="btn btn-header" href="${pageContext.request.contextPath}/quanlitaikhoan">Quản lý tài khoản</a>
            </div>

            <c:choose>
                <c:when test="${empty pendingShops}">
                    <div class="empty">Hiện không có yêu cầu mở Shop nào đang chờ duyệt.</div>
                </c:when>
                <c:otherwise>
                    <div class="table-card">
                        <table>
                            <thead>
                            <tr>
                                <th>ID</th>
                                <th>Người đăng ký / Số điện thoại</th>
                                <th>Email</th>
                                <th>Ngày đăng ký</th>
                                <th>Thao tác xử lý</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="account" items="${pendingShops}">
                                <tr>
                                    <td style="color: var(--warning); font-weight: bold;">#<c:out value="${account.id}"/></td>
                                    <td>
                                        <strong><c:out value="${account.fullName}"/></strong><br>
                                        <span style="font-size: 12px; color: var(--text-dim);">📞 <c:out value="${account.phone}"/></span>
                                    </td>
                                    <td><c:out value="${account.email}"/></td>
                                    <td>${app:formatDateTime(account.createdAt)}</td>
                                    <td>
                                        <div class="action-group">
                                            <a class="btn btn-info" href="${pageContext.request.contextPath}/super-admin/shop-requests?action=detail&id=${account.id}">Chi tiết</a>

                                            <form action="${pageContext.request.contextPath}/super-admin/shop-requests" method="post" style="margin: 0;">
                                                <input type="hidden" name="action" value="accept"> <input type="hidden" name="id" value="${account.id}">
                                                <button type="submit" class="btn btn-approve" onclick="return confirm('Xác nhận DUYỆT hoạt động cho tài khoản [ ${account.userName} ]?');">✓ Duyệt</button>
                                            </form>

                                            <form action="${pageContext.request.contextPath}/super-admin/shop-requests" method="post" style="margin: 0;" onsubmit="return confirmReject('${account.id}', '${account.userName}')">
                                                <input type="hidden" name="action" value="reject">
                                                <input type="hidden" name="id" value="${account.id}">
                                                <input type="hidden" name="rejectionReason" id="reason_${account.id}" value="">
                                                <button type="submit" class="btn btn-reject">✕ Từ chối</button>
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

        // Thu gọn/mở rộng Sidebar
        (function () {
            const sidebarEl = document.getElementById('sidebarMain');
            const sidebarToggleBtn = document.getElementById('sidebarToggleBtn');
            if (!sidebarEl || !sidebarToggleBtn) return;

            if (localStorage.getItem('sidebarCollapsed') === 'true') {
                sidebarEl.classList.add('collapsed');
            }

            sidebarToggleBtn.addEventListener('click', () => {
                sidebarEl.classList.toggle('collapsed');
                localStorage.setItem('sidebarCollapsed', sidebarEl.classList.contains('collapsed'));
            });
        })();
    </script>


        <!-- Avatar Dropdown (đặt ngoài topbar để tránh backdrop-filter stacking context) -->
    <div class="avatar-dropdown" id="avatarDropdown">
        <div class="dropdown-header">
            <div class="d-name">${sessionScope.account.userName}</div>
            <div class="d-email">${sessionScope.account.email}</div>
            <span class="d-role">Super Admin</span>
        </div>
        <div class="dropdown-body">
            <a href="${pageContext.request.contextPath}/admin/profile" class="dropdown-link">👤 Hồ sơ cá nhân</a>
            <a href="${pageContext.request.contextPath}/admin/change-password" class="dropdown-link">🔒 Đổi mật khẩu</a>
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
                avatarDropdown.addEventListener('click', function(e) {
                    e.stopPropagation();
                });
                document.addEventListener('click', function() {
                    avatarDropdown.classList.remove('open');
                });
            }
        });
    </script>
</body>
</html>
















