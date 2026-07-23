<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- BẢO MẬT: KIỂM TRA QUYỀN SUPER ADMIN --%>
<c:if test="${empty sessionScope.account || sessionScope.account.roleId != 1}">
    <c:redirect url="/dangnhap"/>
</c:if>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script>!function(){var t=localStorage.getItem("pob-dashboard-theme")||"light";document.documentElement.setAttribute("data-theme",t)}()</script>
    <title>Đối soát doanh thu Shop - Super Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/theme.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
    <style>
        :root { --primary-hover: var(--primary-dark); --purple: #8b5cf6; }

        .avatar-wrapper { position: relative; }
        .avatar-dropdown { display: none; position: fixed; background: var(--bg-panel); border: 1px solid var(--border-color); border-radius: 12px; box-shadow: var(--dash-shadow-md); min-width: 220px; z-index: 500; }
        .avatar-dropdown.open { display: block; animation: pobFadeUp .18s ease both; }
        .dropdown-header { padding: 14px 16px; border-bottom: 1px solid var(--border-color); }
        .dropdown-header .d-name { font-size: 14px; font-weight: 700; color: var(--text-main); }
        .dropdown-header .d-email { font-size: 12px; color: var(--text-muted); margin-top: 2px; }
        .dropdown-header .d-role { display: inline-block; margin-top: 6px; font-size: 10px; font-weight: 700; padding: 2px 8px; border-radius: 4px; background: var(--primary-light); color: var(--primary); border: 1px solid var(--primary); }
        .dropdown-body { padding: 6px 0 8px; }
        .dropdown-link { display: flex; align-items: center; gap: 10px; padding: 10px 16px; font-size: 13px; color: var(--text-muted); cursor: pointer; }
        .dropdown-link:hover { background: var(--bg-input); color: var(--text-main); }
        .dropdown-divider { height: 1px; background: var(--border-color); margin: 4px 0; }
        .dropdown-link.danger { color: var(--danger); }
        .dropdown-link.danger:hover { background: var(--danger-light); color: var(--danger); }

        .mock-banner { background: var(--warning-light); border: 1px dashed var(--warning); color: var(--warning); border-radius: 8px; padding: 10px 16px; font-size: 12px; font-weight: 700; text-align: center; letter-spacing: 0.3px; }

        /* FILTER BAR */
        .filter-bar { background: var(--bg-panel); border: 1px solid var(--border-color); border-radius: 10px; padding: 18px 20px; display: flex; align-items: flex-end; gap: 18px; flex-wrap: wrap; }
        .filter-field { display: flex; flex-direction: column; gap: 6px; }
        .filter-field label { font-size: 11px; text-transform: uppercase; letter-spacing: 0.5px; color: var(--text-muted); font-weight: 700; }
        .filter-field select,
        .filter-field input[type="date"] { background: var(--bg-input); border: 1px solid var(--border-color); border-radius: 8px; padding: 9px 12px; color: var(--text-main); font-size: 13px; min-width: 180px; }
        .filter-field input[type="date"]::-webkit-calendar-picker-indicator { filter: invert(0.6); cursor: pointer; }
        .btn-filter { background: var(--primary); color: #ffffff; border: none; border-radius: 8px; padding: 10px 22px; font-size: 13px; font-weight: 700; cursor: pointer; transition: all 0.2s ease; }
        .btn-filter:hover { background: var(--primary-hover); transform: translateY(-1px); }

        /* CARDS THỐNG KÊ */
        .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); gap: 20px; }
        .stat-card { background: var(--bg-panel); border: 1px solid var(--border-color); border-radius: 8px; padding: 20px; display: flex; flex-direction: column; border-top: 3px solid var(--border-color); transition: all 0.2s ease;}
        .stat-card:hover { transform: translateY(-3px); box-shadow: 0 6px 14px rgba(0,0,0,0.15); }
        .stat-card.gross { border-top-color: var(--info); }
        .stat-card.fee { border-top-color: var(--warning); }
        .stat-card.payout { border-top-color: var(--primary); }
        .stat-title { font-size: 12px; text-transform: uppercase; color: var(--text-muted); margin-bottom: 10px; font-weight: bold; }
        .stat-value { font-size: 28px; font-weight: bold; color: var(--text-main); }
        .stat-hint { font-size: 11px; color: var(--text-dim); margin-top: 6px; }

        /* PANEL / TABLE */
        .panel { background: var(--bg-panel); border: 1px solid var(--border-color); border-radius: 10px; animation: fadeUp 0.35s ease both; padding: 20px; }
        .panel-title { color: var(--warning); font-size: 14px; font-weight: bold; margin-bottom: 20px; text-transform: uppercase; border-left: 4px solid var(--warning); padding-left: 10px; }
        @keyframes fadeUp {
            from { opacity: 0; transform: translateY(16px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        .table-wrapper { overflow-x: auto; }
        table.recon-table { width: 100%; border-collapse: collapse; font-size: 13px; min-width: 900px; }
        table.recon-table thead th { text-align: left; color: var(--text-muted); font-size: 11px; text-transform: uppercase; letter-spacing: 0.5px; padding: 10px 14px; border-bottom: 1px solid var(--border-color); white-space: nowrap; }
        table.recon-table thead th.num { text-align: right; }
        table.recon-table tbody td { padding: 14px; border-bottom: 1px solid var(--border-color); color: var(--text-main); vertical-align: middle; }
        table.recon-table tbody td.num { text-align: right; font-variant-numeric: tabular-nums; }
        table.recon-table tbody tr:last-child td { border-bottom: none; }
        table.recon-table tbody tr:hover { background: var(--bg-input); }
        .shop-name-cell { display: flex; align-items: center; gap: 10px; }
        .shop-avatar { width: 32px; height: 32px; border-radius: 8px; background: linear-gradient(135deg, var(--info), var(--purple)); color: #fff; display: flex; align-items: center; justify-content: center; font-weight: 700; font-size: 12px; flex-shrink: 0; }
        .shop-name { font-weight: 600; }

        .status-pill { display: inline-flex; align-items: center; gap: 6px; padding: 5px 12px; border-radius: 999px; font-size: 11px; font-weight: 700; white-space: nowrap; }
        .status-pill.paid { background: var(--primary-light); color: var(--primary); }
        .status-pill.pending { background: var(--warning-light); color: var(--warning); }
        .status-pill .dot { width: 6px; height: 6px; border-radius: 50%; background: currentColor; }

        .btn-confirm-pay { background: var(--primary); color: #fff; border: none; border-radius: 6px; padding: 7px 14px; font-size: 12px; font-weight: 700; cursor: pointer; transition: all 0.2s ease; white-space: nowrap; }
        .btn-confirm-pay:hover { background: var(--primary-hover); transform: translateY(-1px); }
        .btn-confirm-pay:disabled { background: var(--border-color); color: var(--text-dim); cursor: not-allowed; transform: none; }

        .table-footer-note { font-size: 11px; color: var(--text-dim); margin-top: 14px; }
    </style>
</head>
<body class="dash-body">

<div class="sidebar-backdrop" id="sidebarBackdrop"></div>
<aside class="sidebar" id="sidebar">
    <div class="sidebar-brand">
        <div class="logo-mark-dash">S</div>
        <div class="brand-text">
            <span class="brand-title">SUPER ADMIN</span>
            <span class="brand-subtitle">👋 ${sessionScope.account.userName}</span>
        </div>
    </div>
    <div class="menu">
        <div class="menu-title">📊 Tổng quan & phân tích</div>
        <a href="${pageContext.request.contextPath}/tong-quan" class="menu-item">
            <span class="mi-left"><span class="mi-icon">⊞</span> Tổng quan hệ thống</span>
        </a>
        <a href="${pageContext.request.contextPath}/admin/bao-cao-van-hanh" class="menu-item">
            <span class="mi-left"><span class="mi-icon">📈</span> Báo cáo vận hành</span>
        </a>

        <div class="menu-title">⚖️ Kiểm duyệt & điều phối</div>
        <a href="${pageContext.request.contextPath}/super-admin/shop-requests" class="menu-item">
            <span class="mi-left"><span class="mi-icon">🏪</span> Duyệt Shop</span>
            <c:if test="${shopChoDuyet > 0}"><span class="menu-badge yellow">${shopChoDuyet} mới</span></c:if>
        </a>
        <a href="${pageContext.request.contextPath}/super-admin/shipper-requests" class="menu-item">
            <span class="mi-left"><span class="mi-icon">🛵</span> Duyệt Shipper</span>
            <c:if test="${not empty pendingShippers}"><span class="menu-badge yellow">${pendingShippers.size()} mới</span></c:if>
        </a>
        <a href="${pageContext.request.contextPath}/admin/kiem-duyet-noi-dung" class="menu-item">
            <span class="mi-left"><span class="mi-icon">🚩</span> Kiểm duyệt nội dung</span>
        </a>
        <a href="${pageContext.request.contextPath}/admin/kiem-duyet-binh-luan" class="menu-item">
            <span class="mi-left"><span class="mi-icon">💬</span> Kiểm duyệt bình luận</span>
        </a>
        <a href="${pageContext.request.contextPath}/admin/khieu-nai" class="menu-item">
            <span class="mi-left"><span class="mi-icon">📢</span> Quản lý khiếu nại</span>
        </a>
        <a href="${pageContext.request.contextPath}/admin/appeals" class="menu-item">
            <span class="mi-left"><span class="mi-icon">📋</span> Kháng nghị</span>
            <c:if test="${pendingCount > 0}"><span class="menu-badge yellow">${pendingCount}</span></c:if>
        </a>

        <div class="menu-title">💰 Quản lý tài chính</div>
        <a href="${pageContext.request.contextPath}/admin/doi-soat-doanh-thu-shop" class="menu-item active">
            <span class="mi-left"><span class="mi-icon">💵</span> Đối soát doanh thu Shop</span>
        </a>
        <a href="${pageContext.request.contextPath}/admin/duyet-rut-tien-shipper" class="menu-item">
            <span class="mi-left"><span class="mi-icon">💳</span> Duyệt rút tiền Shipper</span>
        </a>

        <div class="menu-title">⚙️ Cấu hình & hệ thống</div>
        <a href="${pageContext.request.contextPath}/quanlitaikhoan" class="menu-item">
            <span class="mi-left"><span class="mi-icon">👤</span> Người dùng</span>
        </a>
        <a href="${pageContext.request.contextPath}/admin/tham-so-van-hanh" class="menu-item">
            <span class="mi-left"><span class="mi-icon">🛠️</span> Tham số vận hành</span>
        </a>
    </div>
</aside>

<main class="main">
    <header class="topbar">
        <div style="display:flex;align-items:center;gap:10px;">
            <button type="button" class="menu-toggle-btn" onclick="pobToggleSidebar()">☰</button>
            <h1>ĐỐI SOÁT DOANH THU SHOP</h1>
        </div>
        <div class="topbar-right">
            <button type="button" class="theme-toggle" onclick="pobToggleTheme()" title="Chuyển đổi giao diện"><span data-theme-icon>🌙</span></button>
            <div class="avatar-wrapper" id="avatarWrapper">
                <div class="avatar-circle" id="avatarBtn">
                    <c:choose>
                        <c:when test="${not empty sessionScope.account.avatarUrl}">
                            <img src="${sessionScope.account.avatarUrl}" alt="avatar"/>
                        </c:when>
                        <c:otherwise>${fn:toUpperCase(fn:substring(sessionScope.account.userName, 0, 2))}</c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </header>

        <div class="content">
            <!-- BỘ LỌC -->
            <form class="filter-bar" method="get" action="${pageContext.request.contextPath}/admin/doi-soat-doanh-thu-shop">
                <div class="filter-field">
                    <label for="shopFilter">Cửa hàng</label>
                    <select id="shopFilter" name="shopId">
                        <option value="all" ${shopIdFilter == 'all' ? 'selected' : ''}>Tất cả cửa hàng</option>
                        <c:forEach var="shop" items="${danhSachShop}">
                            <option value="${shop.id}" ${shopIdFilter ne 'all' and shopIdFilter == shop.id ? 'selected' : ''}>${shop.shopName}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="filter-field">
                    <label for="tuNgay">Từ ngày</label>
                    <input type="date" id="tuNgay" name="tuNgay" value="${tuNgay}">
                </div>
                <div class="filter-field">
                    <label for="denNgay">Đến ngày</label>
                    <input type="date" id="denNgay" name="denNgay" value="${denNgay}">
                </div>
                <button type="submit" class="btn-filter">🔍 Lọc đối soát</button>
            </form>

            <!-- KHỐI 3 CARD SỐ LIỆU -->
            <div class="stats-grid">
                <div class="stat-card gross">
                    <span class="stat-title">Tổng doanh thu toàn sàn</span>
                    <span class="stat-value" style="color: var(--info);"><fmt:formatNumber value="${tongDoanhThu}" type="number" groupingUsed="true"/>₫</span>
                    <span class="stat-hint">Gross Revenue • Từ <fmt:parseDate value="${tuNgay}" pattern="yyyy-MM-dd" var="tuNgayDate"/><fmt:formatDate value="${tuNgayDate}" pattern="dd/MM/yyyy"/> đến <fmt:parseDate value="${denNgay}" pattern="yyyy-MM-dd" var="denNgayDate"/><fmt:formatDate value="${denNgayDate}" pattern="dd/MM/yyyy"/></span>
                </div>
                <div class="stat-card fee">
                    <span class="stat-title">Chiết khấu sàn thu về (10%)</span>
                    <span class="stat-value" style="color: var(--warning);"><fmt:formatNumber value="${tongPhiSan}" type="number" groupingUsed="true"/>₫</span>
                    <span class="stat-hint">Tổng phí nền tảng thu trên các đơn thành công</span>
                </div>
                <div class="stat-card payout">
                    <span class="stat-title">Tổng tiền cần thanh toán cho Shop</span>
                    <span class="stat-value" style="color: var(--primary);"><fmt:formatNumber value="${tongNetPayout}" type="number" groupingUsed="true"/>₫</span>
                    <span class="stat-hint">Net Payout • ${soShopChoThanhToan}/${danhSachDoiSoat.size()} Shop chờ thanh toán</span>
                </div>
            </div>

            <!-- BẢNG ĐỐI SOÁT THEO SHOP -->
            <div class="panel">
                <div class="panel-title">■ CHI TIẾT ĐỐI SOÁT THEO TỪNG SHOP</div>
                <div class="table-wrapper">
                    <table class="recon-table">
                        <thead>
                            <tr>
                                <th>Tên Shop</th>
                                <th class="num">Số đơn thành công</th>
                                <th class="num">Tổng doanh thu</th>
                                <th class="num">Phí sàn (10%)</th>
                                <th class="num">Số tiền thực nhận</th>
                                <th>Trạng thái</th>
                                <th></th>
                            </tr>
                        </thead>
                        <tbody id="reconTableBody">
                            <c:forEach var="item" items="${danhSachDoiSoat}">
                                <tr data-shop-id="${item.shopId}">
                                    <td>
                                        <div class="shop-name-cell">
                                            <div class="shop-avatar">${fn:toUpperCase(fn:substring(item.shopName, 0, 2))}</div>
                                            <span class="shop-name">${item.shopName}</span>
                                        </div>
                                    </td>
                                    <td class="num">${item.soDonThanhCong}</td>
                                    <td class="num"><fmt:formatNumber value="${item.tongDoanhThu}" type="number" groupingUsed="true"/>₫</td>
                                    <td class="num" style="color: var(--warning);"><fmt:formatNumber value="${item.phiSan}" type="number" groupingUsed="true"/>₫</td>
                                    <td class="num" style="color: var(--primary); font-weight: 700;"><fmt:formatNumber value="${item.soTienThucNhan}" type="number" groupingUsed="true"/>₫</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${item.daThanhToan}">
                                                <span class="status-pill paid"><span class="dot"></span>Đã thanh toán</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="status-pill pending"><span class="dot"></span>Chờ thanh toán</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <button type="button" class="btn-confirm-pay"
                                                ${item.daThanhToan || item.soDonThanhCong == 0 ? 'disabled' : ''}>
                                            ${item.daThanhToan ? '✔ Đã chi' : '💸 Xác nhận thanh toán'}
                                        </button>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                    <c:if test="${empty danhSachDoiSoat}">
                        <div class="table-footer-note">Không có Shop nào trong hệ thống.</div>
                    </c:if>
                </div>
                <div class="table-footer-note">
                    * Số liệu được tính trực tiếp từ các đơn hàng có trạng thái "Hoàn thành" (DONE) trong khoảng thời gian đã chọn.
                </div>
            </div>
        </div>
    </main>

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

<script src="${pageContext.request.contextPath}/assets/js/dashboard-theme.js"></script>
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
<script>
    /* ===================== XÁC NHẬN THANH TOÁN CHO SHOP (AJAX) ===================== */
        (function () {
            const tbody = document.getElementById('reconTableBody');
            const contextPath = '${pageContext.request.contextPath}';
            const tuNgay = document.getElementById('tuNgay').value;
            const denNgay = document.getElementById('denNgay').value;

            tbody.addEventListener('click', function (e) {
                const btn = e.target.closest('.btn-confirm-pay');
                if (!btn || btn.disabled) return;

                const row = btn.closest('tr');
                const shopId = row.getAttribute('data-shop-id');

                if (!confirm('Xác nhận đã thanh toán khoản đối soát này cho Shop?')) return;

                btn.disabled = true;
                const oldText = btn.textContent;
                btn.textContent = 'Đang xử lý...';

                const params = new URLSearchParams();
                params.set('shopId', shopId);
                params.set('tuNgay', tuNgay);
                params.set('denNgay', denNgay);

                fetch(contextPath + '/admin/doi-soat-doanh-thu-shop', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: params.toString()
                })
                    .then(function (res) { return res.json().then(function (data) { return { ok: res.ok, data: data }; }); })
                    .then(function (result) {
                        if (result.ok && result.data.success) {
                            const statusCell = row.querySelector('.status-pill').parentElement;
                            statusCell.innerHTML = '<span class="status-pill paid"><span class="dot"></span>Đã thanh toán</span>';
                            btn.textContent = '✔ Đã chi';
                            btn.disabled = true;
                        } else {
                            alert(result.data.message || 'Xác nhận thanh toán thất bại.');
                            btn.textContent = oldText;
                            btn.disabled = false;
                        }
                    })
                    .catch(function () {
                        alert('Lỗi kết nối đến máy chủ. Vui lòng thử lại.');
                        btn.textContent = oldText;
                        btn.disabled = false;
                    });
            });
        })();
    </script>
</body>
</html>
