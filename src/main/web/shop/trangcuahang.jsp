<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

<%-- BẢO MẬT: KIỂM TRA QUYỀN SHOP (roleId = 2) --%>
<c:if test="${empty sessionScope.account || sessionScope.account.roleId != 2}">
    <c:redirect url="/dangnhap"/>
</c:if>

<!DOCTYPE html>
<html lang="vi" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trang chủ cửa hàng</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/theme.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
    <style>
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

        /* Đặc thù trang chủ shop: banner chào mừng + biểu đồ */
        .welcome-banner { background: linear-gradient(120deg, var(--primary) 0%, var(--primary-dark) 100%); border-radius: var(--radius-lg); padding: 28px 32px; color: #fff; display: flex; align-items: center; justify-content: space-between; box-shadow: var(--dash-shadow-md); }
        .welcome-banner h1 { font-size: 21px; font-weight: 800; margin-bottom: 6px; }
        .welcome-banner p { font-size: 13px; opacity: .92; }
        .welcome-emoji { font-size: 46px; }
        .stat-icon.green { background: var(--success-light); color: var(--success-dark); }
        .stat-icon.red { background: var(--danger-light); color: var(--danger); }
        .stat-icon.yellow { background: var(--warning-light); color: var(--warning-dark); }
    </style>
</head>
<body class="dash-body">

<div class="sidebar-backdrop" id="sidebarBackdrop"></div>
<aside class="sidebar" id="sidebar">
    <div class="sidebar-brand">
        <div class="logo-mark-dash">🍔</div>
        <div class="brand-text">
            <span class="brand-title">${not empty currentShop.shopName ? currentShop.shopName : 'CỬA HÀNG CỦA TÔI'}</span>
            <span class="brand-subtitle">👋 ${sessionScope.account.userName}</span>
        </div>
    </div>
    <div class="menu">
        <div class="menu-title">Tổng quan</div>
        <a href="${pageContext.request.contextPath}/shop" class="menu-item active">
            <span class="mi-left"><span class="mi-icon">📊</span> Trang chủ</span>
        </a>

        <div class="menu-title">Sản phẩm</div>
        <a href="${pageContext.request.contextPath}/shop/products" class="menu-item">
            <span class="mi-left"><span class="mi-icon">🍽️</span> Quản lý sản phẩm</span>
        </a>
        <a href="${pageContext.request.contextPath}/shop/product-types" class="menu-item">
            <span class="mi-left"><span class="mi-icon">📂</span> Quản lý loại sản phẩm</span>
        </a>

        <div class="menu-title">Topping</div>
        <a href="${pageContext.request.contextPath}/shop/toppings" class="menu-item">
            <span class="mi-left"><span class="mi-icon">🧂</span> Quản lý Topping</span>
        </a>
        <a href="${pageContext.request.contextPath}/shop/topping-categories" class="menu-item">
            <span class="mi-left"><span class="mi-icon">🏷️</span> Quản lý loại Topping</span>
        </a>

        <div class="menu-title">Đơn hàng</div>
        <a href="${pageContext.request.contextPath}/shop/pos" class="menu-item">
            <span class="mi-left"><span class="mi-icon">🧾</span> Bấm Bill</span>
        </a>
        <a href="${pageContext.request.contextPath}/shop/bills" class="menu-item">
            <span class="mi-left"><span class="mi-icon">📋</span> Quản lý hóa đơn</span>
        </a>

        <div class="menu-title">Cửa hàng</div>
        <a href="${pageContext.request.contextPath}/shop/profile" class="menu-item">
            <span class="mi-left"><span class="mi-icon">🏪</span> Thông tin cửa hàng</span>
        </a>
        <a href="${pageContext.request.contextPath}/shop/danh-gia" class="menu-item">
            <span class="mi-left"><span class="mi-icon">⭐</span> Xem đánh giá</span>
        </a>
    </div>
</aside>

<main class="main">
    <header class="topbar">
        <div style="display:flex;align-items:center;gap:10px;">
            <button type="button" class="menu-toggle-btn" onclick="pobToggleSidebar()">☰</button>
            <h1>📊 Trang chủ cửa hàng</h1>
        </div>
        <div class="topbar-right">
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
        <div class="welcome-banner">
            <div>
                <h1>Chào mừng quay lại, ${sessionScope.account.fullName != null ? sessionScope.account.fullName : sessionScope.account.userName}! 👋</h1>
                <p>Đây là tổng quan hoạt động kinh doanh của cửa hàng bạn hôm nay.</p>
            </div>
            <div class="welcome-emoji">🍜</div>
        </div>

        <div class="stats-grid">
            <div class="stat-card">
                <div>
                    <div style="font-size:12px;color:var(--text-dim);font-weight:600;">Doanh thu hôm nay</div>
                    <div class="stat-num"><fmt:formatNumber value="${doanhThuHomNay}" pattern="#,##0"/> đ</div>
                </div>
                <div class="stat-icon green">💰</div>
            </div>
            <div class="stat-card">
                <div>
                    <div style="font-size:12px;color:var(--text-dim);font-weight:600;">Doanh thu tuần này</div>
                    <div class="stat-num"><fmt:formatNumber value="${doanhThuTuanNay}" pattern="#,##0"/> đ</div>
                </div>
                <div class="stat-icon">📅</div>
            </div>
            <div class="stat-card">
                <div>
                    <div style="font-size:12px;color:var(--text-dim);font-weight:600;">Doanh thu tháng này</div>
                    <div class="stat-num"><fmt:formatNumber value="${doanhThuThangNay}" pattern="#,##0"/> đ</div>
                </div>
                <div class="stat-icon yellow">🗓️</div>
            </div>
            <div class="stat-card">
                <div>
                    <div style="font-size:12px;color:var(--text-dim);font-weight:600;">Tổng đơn hàng</div>
                    <div class="stat-num">${tongDon}</div>
                </div>
                <div class="stat-icon red">📦</div>
            </div>
        </div>

        <div class="stats-grid">
            <div class="stat-card">
                <div>
                    <div style="font-size:12px;color:var(--text-dim);font-weight:600;">Đơn hoàn thành</div>
                    <div class="stat-num">${donHoanThanh}</div>
                </div>
                <div class="stat-icon green">✓</div>
            </div>
            <div class="stat-card">
                <div>
                    <div style="font-size:12px;color:var(--text-dim);font-weight:600;">Đơn đã hủy</div>
                    <div class="stat-num">${donHuy}</div>
                </div>
                <div class="stat-icon red">✕</div>
            </div>
            <div class="stat-card">
                <div>
                    <div style="font-size:12px;color:var(--text-dim);font-weight:600;">Tổng sản phẩm</div>
                    <div class="stat-num">${tongSanPham}</div>
                </div>
                <div class="stat-icon">🍽️</div>
            </div>
            <div class="stat-card">
                <div>
                    <div style="font-size:12px;color:var(--text-dim);font-weight:600;">Tổng Topping</div>
                    <div class="stat-num">${tongTopping}</div>
                </div>
                <div class="stat-icon yellow">🧂</div>
            </div>
        </div>

        <div class="panel">
            <div class="panel-header"><div class="panel-title">📈 Doanh thu 7 ngày gần đây</div></div>
            <div class="panel-body"><canvas id="revenueChart" height="90"></canvas></div>
        </div>

        <div class="panel">
            <div class="panel-header"><div class="panel-title">🔥 Top món bán chạy</div></div>
            <div class="panel-body" style="padding:0;">
                <div class="dash-table-wrap">
                    <table class="dash-table">
                        <thead>
                        <tr><th>Sản phẩm</th><th>Số lượng đã bán</th><th>Doanh thu</th></tr>
                        </thead>
                        <tbody>
                        <c:forEach var="sp" items="${topSanPhamBanChay}">
                            <tr>
                                <td><c:out value="${sp.productName}"/></td>
                                <td>${sp.soLuongDaBan}</td>
                                <td><fmt:formatNumber value="${sp.doanhThu}" pattern="#,##0"/> đ</td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty topSanPhamBanChay}">
                            <tr><td colspan="3"><div class="empty-state"><div class="e-icon">🍽️</div><div class="e-title">Chưa có dữ liệu bán hàng.</div></div></td></tr>
                        </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <div class="panel">
            <div class="panel-header"><div class="panel-title">📦 Đơn hàng gần đây</div></div>
            <div class="panel-body" style="padding:0;">
                <div class="dash-table-wrap">
                    <table class="dash-table">
                        <thead>
                        <tr><th>Mã đơn</th><th>Khách hàng</th><th>Tổng tiền</th><th>Trạng thái</th><th>Ngày đặt</th></tr>
                        </thead>
                        <tbody>
                        <c:forEach var="order" items="${donHangGanDay}">
                            <tr>
                                <td>#<c:out value="${order.id}"/></td>
                                <td><c:out value="${order.receiverName}"/></td>
                                <td><fmt:formatNumber value="${order.totalPrice}" pattern="#,##0"/> đ</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${order.staTus == 'DONE'}"><span class="badge badge-success">✓ Hoàn thành</span></c:when>
                                        <c:when test="${order.staTus == 'CANCELLED'}"><span class="badge badge-danger">✕ Đã hủy</span></c:when>
                                        <c:otherwise><span class="badge badge-warning">⏳ ${order.staTus}</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td><c:out value="${order.createdAt}"/></td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty donHangGanDay}">
                            <tr><td colspan="5"><div class="empty-state"><div class="e-icon">📦</div><div class="e-title">Chưa có đơn hàng nào gần đây.</div></div></td></tr>
                        </c:if>
                        </tbody>
                    </table>
                </div>
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

<script src="${pageContext.request.contextPath}/assets/js/dashboard-theme.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    const ctx = document.getElementById('revenueChart');
    const labels = [
        <c:forEach var="d" items="${doanhThu7NgayQua}">'${d.ngay}',</c:forEach>
    ];
    const data = [
        <c:forEach var="d" items="${doanhThu7NgayQua}">${d.doanhThu},</c:forEach>
    ];
    new Chart(ctx, {
        type: 'bar',
        data: {
            labels: labels,
            datasets: [{
                label: 'Doanh thu (đ)',
                data: data,
                backgroundColor: '#FF5722',
                borderRadius: 6
            }]
        },
        options: {
            responsive: true,
            plugins: { legend: { display: false } },
            scales: { y: { beginAtZero: true } }
        }
    });

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
