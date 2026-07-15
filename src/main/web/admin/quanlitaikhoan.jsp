<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<c:if test="${empty sessionScope.account || sessionScope.account.roleId != 1}">
    <c:redirect url="/dangnhap"/>
</c:if>

<!DOCTYPE html>
<html lang="vi" data-theme="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý tài khoản - Super Admin</title>
    <style>
        :root[data-theme="dark"] {
            --bg-base: #151521; --bg-sidebar: #1e1e2d; --bg-panel: #1e1e2d;
            --bg-input: #1a1a27; --bg-hover: #1b1b29;
            --text-main: #ffffff; --text-muted: #a1a5b7; --text-dim: #565674;
            --border-color: #2b2b40; --topbar-bg: #1a1a27;
        }
        :root[data-theme="light"] {
            --bg-base: #f1f5f9; --bg-sidebar: #ffffff; --bg-panel: #ffffff;
            --bg-input: #f8fafc; --bg-hover: #f1f5f9;
            --text-main: #0f172a; --text-muted: #64748b; --text-dim: #94a3b8;
            --border-color: #e2e8f0; --topbar-bg: #ffffff;
        }
        :root { --primary: #20d489; --warning: #facc15; --danger: #ef4444; --info: #3b82f6; }

        * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; transition: background-color 0.3s, border-color 0.3s, color 0.3s; }
        body { background-color: var(--bg-base); color: var(--text-muted); display: flex; height: 100vh; overflow: hidden; }
        a { text-decoration: none; color: inherit; }
        ul { list-style: none; }

        /* SIDEBAR */
        .sidebar { width: 250px; background-color: var(--bg-sidebar); border-right: 1px solid var(--border-color); display: flex; flex-direction: column; flex-shrink: 0; }
        .brand { padding: 20px; display: flex; flex-direction: column; align-items: flex-start; gap: 10px; border-bottom: 1px solid var(--border-color); }
        .brand-row { display: flex; align-items: center; gap: 12px; width: 100%; }
        .logo { background: var(--primary); color: #fff; width: 32px; height: 32px; border-radius: 6px; display: flex; align-items: center; justify-content: center; font-weight: bold; }
        .brand-title { color: var(--text-main); font-weight: bold; font-size: 14px; }
        .menu { padding: 15px 0; flex: 1; overflow-y: auto; }
        .menu-title { font-size: 11px; color: var(--text-dim); font-weight: bold; margin: 15px 20px 10px; text-transform: uppercase; }
        .menu-item { padding: 12px 20px; display: flex; align-items: center; justify-content: space-between; color: var(--text-muted); font-size: 14px; transition: all 0.2s; border-left: 3px solid transparent; }
        .menu-item:hover { background-color: var(--bg-hover); color: var(--text-main); transform: translateX(4px); }
        .menu-item.active { background-color: var(--bg-hover); color: var(--text-main); border-left-color: var(--primary); }
        .badge { font-size: 10px; padding: 3px 8px; border-radius: 10px; background: var(--border-color); color: var(--text-main); }
        .badge.yellow { background: var(--warning); color: #151521; font-weight: 600; }

        /* MAIN */
        .main { flex: 1; display: flex; flex-direction: column; overflow: hidden; }
        .topbar { background-color: var(--topbar-bg); padding: 15px 30px; display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid var(--border-color); }
        .topbar h1 { color: var(--text-main); font-size: 18px; font-weight: bold; }
        .topbar-right { display: flex; align-items: center; gap: 15px; }
        .theme-toggle { background: var(--bg-input); border: 1px solid var(--border-color); width: 38px; height: 38px; border-radius: 8px; cursor: pointer; display: flex; align-items: center; justify-content: center; color: var(--text-main); font-size: 16px; }
        .theme-toggle:hover { background: var(--border-color); }

        .content { padding: 25px 30px; overflow-y: auto; flex: 1; display: flex; flex-direction: column; gap: 20px; }

        /* PANEL */
        .panel { background: var(--bg-panel); border: 1px solid var(--border-color); border-radius: 10px; animation: fadeUp 0.35s ease both; padding: 20px; }
        .panel-title { color: var(--warning); font-size: 14px; font-weight: bold; margin-bottom: 16px; text-transform: uppercase; border-left: 4px solid var(--warning); padding-left: 10px; }

        /* TOOLBAR */
        .toolbar { display: flex; align-items: center; gap: 12px; margin-bottom: 16px; flex-wrap: wrap; }
        .search-input { flex: 1; min-width: 200px; background: var(--bg-input); border: 1px solid var(--border-color); border-radius: 6px; padding: 9px 14px; color: var(--text-main); font-size: 13px; outline: none; }
        .search-input:focus { border-color: var(--primary); }
        .btn { padding: 9px 16px; border-radius: 6px; font-size: 13px; font-weight: 600; cursor: pointer; border: none; transition: all 0.2s; }
        .btn-primary { background: var(--primary); color: #151521; }
        .btn-primary:hover { opacity: 0.88; }
        .btn-info { background: rgba(59,130,246,0.12); color: var(--info); border: 1px solid var(--info); }
        .btn-info:hover { background: var(--info); color: #fff; }

        /* TABLE */
        table { width: 100%; border-collapse: collapse; }
        th { padding: 12px 10px; font-size: 11px; color: var(--text-dim); text-transform: uppercase; border-bottom: 1px solid var(--border-color); white-space: nowrap; }
        td { padding: 14px 10px; border-bottom: 1px solid var(--border-color); font-size: 13px; color: var(--text-main); }
        tr:last-child td { border-bottom: none; }
        tr:hover td { background-color: var(--bg-hover); }

        .role-badge { display: inline-block; padding: 3px 10px; border-radius: 12px; font-size: 11px; font-weight: 700; }
        .role-1 { background: rgba(250,204,21,0.15); color: var(--warning); }
        .role-2 { background: rgba(59,130,246,0.12); color: var(--info); }
        .role-3 { background: rgba(32,212,137,0.12); color: var(--primary); }
        .role-4 { background: rgba(168,85,247,0.12); color: #a855f7; }

        /* DROPDOWN ACTION */
        .action-wrap { position: relative; display: inline-block; }
        .btn-dots { background: var(--bg-input); border: 1px solid var(--border-color); border-radius: 6px; width: 32px; height: 32px; cursor: pointer; display: flex; align-items: center; justify-content: center; font-size: 18px; color: var(--text-muted); transition: all 0.15s; }
        .btn-dots:hover { background: var(--border-color); color: var(--text-main); }
        .dropdown-menu { display: none; position: absolute; right: 0; top: 36px; background: var(--bg-panel); border: 1px solid var(--border-color); border-radius: 8px; box-shadow: 0 8px 24px rgba(0,0,0,0.3); min-width: 180px; z-index: 100; overflow: hidden; }
        .dropdown-menu.open { display: block; }
        .dropdown-item { display: flex; align-items: center; gap: 10px; padding: 11px 16px; font-size: 13px; color: var(--text-muted); cursor: pointer; transition: background 0.15s; border: none; background: none; width: 100%; text-align: left; }
        .dropdown-item:hover { background: var(--bg-hover); color: var(--text-main); }
        .dropdown-item.edit:hover { color: var(--info); }
        .dropdown-item.soft-del:hover { color: var(--warning); }
        .dropdown-item.hard-del:hover { color: var(--danger); }
        .dropdown-divider { height: 1px; background: var(--border-color); margin: 4px 0; }

        /* MODAL XÁC NHẬN */
        .modal-backdrop { display: none; position: fixed; inset: 0; background: rgba(0,0,0,0.55); z-index: 200; align-items: center; justify-content: center; }
        .modal-backdrop.open { display: flex; }
        .modal-box { background: var(--bg-panel); border: 1px solid var(--border-color); border-radius: 12px; padding: 28px; max-width: 420px; width: 90%; box-shadow: 0 20px 60px rgba(0,0,0,0.4); }
        .modal-icon { font-size: 36px; margin-bottom: 14px; }
        .modal-title { font-size: 17px; font-weight: 700; color: var(--text-main); margin-bottom: 8px; }
        .modal-desc { font-size: 13px; color: var(--text-muted); line-height: 1.6; margin-bottom: 20px; }
        .modal-desc strong { color: var(--danger); }
        .modal-actions { display: flex; gap: 10px; justify-content: flex-end; }
        .btn-cancel { background: var(--bg-input); border: 1px solid var(--border-color); color: var(--text-muted); padding: 9px 18px; border-radius: 6px; cursor: pointer; font-size: 13px; font-weight: 600; }
        .btn-cancel:hover { background: var(--border-color); }
        .btn-confirm-soft { background: rgba(250,204,21,0.15); border: 1px solid var(--warning); color: var(--warning); padding: 9px 18px; border-radius: 6px; cursor: pointer; font-size: 13px; font-weight: 700; }
        .btn-confirm-soft:hover { background: var(--warning); color: #151521; }
        .btn-confirm-hard { background: rgba(239,68,68,0.12); border: 1px solid var(--danger); color: var(--danger); padding: 9px 18px; border-radius: 6px; cursor: pointer; font-size: 13px; font-weight: 700; }
        .btn-confirm-hard:hover { background: var(--danger); color: #fff; }

        /* TOAST */
        .toast { position: fixed; bottom: 24px; right: 24px; padding: 14px 20px; border-radius: 8px; font-size: 13px; font-weight: 600; box-shadow: 0 4px 16px rgba(0,0,0,0.3); z-index: 999; display: none; }
        .toast.success { background: rgba(32,212,137,0.15); border: 1px solid var(--primary); color: var(--primary); }
        .toast.error { background: rgba(239,68,68,0.1); border: 1px solid var(--danger); color: var(--danger); }

        .empty-row { text-align: center; padding: 36px; color: var(--text-dim); font-size: 13px; }
    
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
</head>
<body>

<aside class="sidebar">
    <div class="brand">
        <div class="brand-row">
            <div class="logo">S</div>
            <span class="brand-title">SUPER ADMIN</span>
        </div>
        <div style="font-size:12px;color:var(--text-muted);padding-left:2px;">
            👋 Hi, <strong style="color:var(--primary);">${sessionScope.account.userName}</strong>
        </div>
    </div>
    <ul class="menu">
        <div class="menu-title">Quản lý hệ thống</div>
        <a href="${pageContext.request.contextPath}/tong-quan">
            <li class="menu-item"><span>⊞ Tổng quan hệ thống</span></li>
        </a>
        <a href="${pageContext.request.contextPath}/super-admin/shop-requests">
            <li class="menu-item">
                <span>🏪 Duyệt Shop</span>
                <c:if test="${pendingShopsCount > 0}">
                    <span class="badge yellow">${pendingShopsCount} mới</span>
                </c:if>
            </li>
        </a>
        <li class="menu-item"><span>🛵 Duyệt Shipper</span></li>
        <div class="menu-title">Quản lý Dữ liệu</div>
        <a href="${pageContext.request.contextPath}/quanlitaikhoan">
            <li class="menu-item active"><span>👤 Người dùng</span></li>
        </a>
        <a href="${pageContext.request.contextPath}/admin/appeals">
            <li class="menu-item"><span>📋 Kháng nghị</span></li>
        </a>
    </ul>
</aside>

<main class="main">
    <header class="topbar">
        <h1>👤 Quản lý tài khoản</h1>
        <div class="topbar-right">
            <button class="theme-toggle" id="themeToggleBtn">🌓</button>
            <div class="avatar-wrapper" id="avatarWrapper">
                <div class="avatar-btn" id="avatarBtn">${fn:toUpperCase(fn:substring(sessionScope.account.userName, 0, 2))}</div>
                </div>
        </div>
    </header>

    <div class="content">

        <%-- THÔNG BÁO --%>
        <c:if test="${not empty loi}">
            <div style="background:rgba(239,68,68,0.1);border:1px solid var(--danger);color:var(--danger);padding:12px 16px;border-radius:8px;font-size:13px;font-weight:600;">
                ⚠️ ${loi}
            </div>
        </c:if>

        <!-- BẢNG DANH SÁCH TÀI KHOẢN -->
        <div class="panel">
            <div class="panel-title">Danh sách tài khoản</div>

            <!-- Toolbar tìm kiếm + thêm -->
            <div class="toolbar">
                <form method="post" action="${pageContext.request.contextPath}/quanlitaikhoan" style="display:flex;gap:8px;flex:1;">
                    <input type="hidden" name="action" value="search"/>
                    <input type="text" class="search-input" name="searchKeyword"
                           placeholder="🔍 Tìm theo username hoặc email..."
                           value="${searchKeyword}"/>
                    <button type="submit" class="btn btn-primary">Tìm kiếm</button>
                </form>
                <a href="${pageContext.request.contextPath}/quanlitaikhoan" class="btn btn-info">↺ Làm mới</a>
            </div>

            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Username</th>
                        <th>Họ tên</th>
                        <th>Email</th>
                        <th>SĐT</th>
                        <th>Vai trò</th>
                        <th style="text-align:center;">Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty danhsach}">
                            <tr><td colspan="7" class="empty-row">Không có tài khoản nào</td></tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="acc" items="${danhsach}">
                                <tr>
                                    <td style="color:var(--text-dim);">#${acc.id}</td>
                                    <td style="font-weight:600;">${acc.userName}</td>
                                    <td>${acc.fullName}</td>
                                    <td style="color:var(--text-muted);">${acc.email}</td>
                                    <td style="color:var(--text-muted);">${acc.phone}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${acc.roleId == 1}"><span class="role-badge role-1">SUPER ADMIN</span></c:when>
                                            <c:when test="${acc.roleId == 2}"><span class="role-badge role-2">SHOP</span></c:when>
                                            <c:when test="${acc.roleId == 3}"><span class="role-badge role-3">KHÁCH HÀNG</span></c:when>
                                            <c:when test="${acc.roleId == 4}"><span class="role-badge role-4">SHIPPER</span></c:when>
                                            <c:otherwise><span class="role-badge">${acc.roleId}</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td style="text-align:center;">
                                        <c:choose>
                                            <c:when test="${acc.id == sessionScope.account.id}">
                                                <span style="font-size:11px;color:var(--text-dim);">(Tài khoản của bạn)</span>
                                            </c:when>
                                            <c:when test="${acc.roleId == 1}">
                                                <span style="font-size:11px;color:var(--text-dim);">—</span>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="action-wrap">
                                                    <button class="btn-dots" onclick="toggleDropdown(this)" title="Tùy chọn">⋮</button>
                                                    <div class="dropdown-menu">
                                                        <a href="${pageContext.request.contextPath}/quanlitaikhoan?action=edit&id=${acc.id}">
                                                            <button class="dropdown-item edit">✏️ Sửa thông tin</button>
                                                        </a>
                                                        <div class="dropdown-divider"></div>
                                                        <button class="dropdown-item soft-del"
                                                                onclick="openSoftModal(${acc.id}, '${fn:escapeXml(acc.userName)}')">
                                                            🗂️ Xóa tạm thời
                                                        </button>
                                                        <button class="dropdown-item hard-del"
                                                                onclick="openHardModal(${acc.id}, '${fn:escapeXml(acc.userName)}')">
                                                            🗑️ Xóa vĩnh viễn
                                                        </button>
                                                    </div>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>

    </div>
</main>

<!-- MODAL XÓA TẠM THỜI -->
<div class="modal-backdrop" id="modalSoft">
    <div class="modal-box">
        <div class="modal-icon">🗂️</div>
        <div class="modal-title">Xóa tạm thời tài khoản?</div>
        <div class="modal-desc">
            Tài khoản <strong id="softName"></strong> sẽ bị ẩn khỏi hệ thống nhưng vẫn còn trong Database.<br>
            Có thể khôi phục lại sau.
        </div>
        <div class="modal-actions">
            <button class="btn-cancel" onclick="closeModal('modalSoft')">Hủy</button>
            <form method="post" action="${pageContext.request.contextPath}/quanlitaikhoan" style="margin:0">
                <input type="hidden" name="action" value="delete"/>
                <input type="hidden" name="deleteType" value="soft"/>
                <input type="hidden" name="id" id="softId"/>
                <button type="submit" class="btn-confirm-soft">🗂️ Xóa tạm thời</button>
            </form>
        </div>
    </div>
</div>

<!-- MODAL XÓA VĨNH VIỄN -->
<div class="modal-backdrop" id="modalHard">
    <div class="modal-box">
        <div class="modal-icon">⚠️</div>
        <div class="modal-title">Xóa vĩnh viễn tài khoản?</div>
        <div class="modal-desc">
            Tài khoản <strong id="hardName"></strong> sẽ bị <strong>xóa hoàn toàn khỏi Database</strong>.<br>
            Hành động này <strong>không thể hoàn tác</strong>. Mọi dữ liệu liên quan sẽ bị mất.
        </div>
        <div class="modal-actions">
            <button class="btn-cancel" onclick="closeModal('modalHard')">Hủy</button>
            <form method="post" action="${pageContext.request.contextPath}/quanlitaikhoan" style="margin:0">
                <input type="hidden" name="action" value="delete"/>
                <input type="hidden" name="deleteType" value="hard"/>
                <input type="hidden" name="id" id="hardId"/>
                <button type="submit" class="btn-confirm-hard">🗑️ Xóa vĩnh viễn</button>
            </form>
        </div>
    </div>
</div>

<!-- TOAST -->
<div class="toast success" id="toastEl"></div>

<script>
    // Theme toggle
    const html = document.documentElement;
    const saved = localStorage.getItem('adminTheme') || 'dark';
    html.setAttribute('data-theme', saved);
    document.getElementById('themeToggleBtn').addEventListener('click', () => {
        const next = html.getAttribute('data-theme') === 'dark' ? 'light' : 'dark';
        html.setAttribute('data-theme', next);
        localStorage.setItem('adminTheme', next);
    });

    // Dropdown toggle
    function toggleDropdown(btn) {
        const menu = btn.nextElementSibling;
        const isOpen = menu.classList.contains('open');
        document.querySelectorAll('.dropdown-menu.open').forEach(m => m.classList.remove('open'));
        if (!isOpen) menu.classList.add('open');
    }
    document.addEventListener('click', e => {
        if (!e.target.closest('.action-wrap')) {
            document.querySelectorAll('.dropdown-menu.open').forEach(m => m.classList.remove('open'));
        }
    });

    // Modal soft delete
    function openSoftModal(id, name) {
        document.querySelectorAll('.dropdown-menu.open').forEach(m => m.classList.remove('open'));
        document.getElementById('softId').value = id;
        document.getElementById('softName').textContent = name;
        document.getElementById('modalSoft').classList.add('open');
    }

    // Modal hard delete
    function openHardModal(id, name) {
        document.querySelectorAll('.dropdown-menu.open').forEach(m => m.classList.remove('open'));
        document.getElementById('hardId').value = id;
        document.getElementById('hardName').textContent = name;
        document.getElementById('modalHard').classList.add('open');
    }

    function closeModal(id) {
        document.getElementById(id).classList.remove('open');
    }

    // Đóng modal khi click backdrop
    document.querySelectorAll('.modal-backdrop').forEach(el => {
        el.addEventListener('click', e => {
            if (e.target === el) el.classList.remove('open');
        });
    });

    // Toast thông báo kết quả
    const urlParams = new URLSearchParams(window.location.search);
    const successParam = urlParams.get('success');
    if (successParam) {
        const toast = document.getElementById('toastEl');
        const messages = { delete: '✅ Đã xóa tài khoản thành công', create: '✅ Tạo tài khoản thành công', update: '✅ Cập nhật tài khoản thành công' };
        toast.textContent = messages[successParam] || '✅ Thành công';
        toast.style.display = 'block';
        setTimeout(() => toast.style.display = 'none', 3500);
    }
        // Avatar dropdown
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
                document.addEventListener('click', function() {
                    avatarDropdown.classList.remove('open');
                });
            }
        });    </script>
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
</body>
</html>











