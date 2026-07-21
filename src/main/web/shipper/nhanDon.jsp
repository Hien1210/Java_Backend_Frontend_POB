<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script>!function(){var t=localStorage.getItem("pob-dashboard-theme")||"light";document.documentElement.setAttribute("data-theme",t)}()</script>
    <title>Nhận đơn - POB Shipper</title>
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

        .online-toggle-btn { width: 100%; padding: 12px 16px; border-radius: var(--radius-sm); border: none; cursor: pointer; display: flex; align-items: center; gap: 10px; font-size: 13px; font-weight: 700; }
        .online-toggle-btn.is-online { background: var(--success-light); color: var(--success-dark); border: 1.5px solid var(--success); }
        .online-toggle-btn.is-offline { background: var(--danger-light); color: var(--danger); border: 1.5px solid var(--danger); }
        .toggle-dot { width: 10px; height: 10px; border-radius: 50%; flex-shrink: 0; }
        .toggle-dot.online { background: var(--success); animation: pobBlink 1.5s infinite; }
        .toggle-dot.offline { background: var(--danger); }

        /* Order cards */
        .order-card { background: var(--bg-panel); border: 1px solid var(--border-color); border-radius: var(--radius-md); padding: 20px; box-shadow: var(--dash-shadow-sm); position: relative; overflow: hidden; transition: box-shadow .2s; }
        .order-card:hover { box-shadow: var(--dash-shadow-md); }
        .order-card::before { content: ''; position: absolute; top: 0; left: 0; width: 4px; height: 100%; background: var(--warning); }

        .route-timeline { display: flex; flex-direction: column; gap: 10px; margin: 14px 0; }
        .route-label { font-size: 11px; color: var(--text-dim); font-weight: 700; text-transform: uppercase; margin-bottom: 2px; }
        .route-text { font-weight: 700; color: var(--text-main); }
        .route-sub { font-size: 11px; color: var(--text-dim); margin-top: 2px; }

        .order-footer { display: flex; flex-wrap: wrap; gap: 12px; justify-content: space-between; align-items: center; border-top: 1px dashed var(--border-color); padding-top: 14px; margin-top: 4px; }
        .price-wrap { display: flex; flex-direction: column; gap: 2px; }
        .price-label { font-size: 11px; color: var(--text-dim); font-weight: 700; text-transform: uppercase; }
        .price-val { font-size: 16px; font-weight: 800; color: var(--primary); }
        .fee-val { font-size: 13px; font-weight: 700; color: var(--warning-dark); }
        .badge-payos { background: rgba(139,92,246,.14); color: #8b5cf6; }
    </style>
</head>
<body class="dash-body">

<div class="sidebar-backdrop" id="sidebarBackdrop"></div>
<aside class="sidebar" id="sidebar">
    <div class="sidebar-brand">
        <div class="logo-mark-dash">🛵</div>
        <div class="brand-text">
            <span class="brand-title">POB SHIPPER</span>
            <c:choose>
                <c:when test="${sessionScope.account.online}">
                    <span class="brand-subtitle" style="color:var(--success);">● Đang hoạt động</span>
                </c:when>
                <c:otherwise>
                    <span class="brand-subtitle" style="color:var(--danger);">● Ngoại tuyến</span>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
    <div class="menu">
        <div class="menu-title">Công việc</div>
        <a href="${pageContext.request.contextPath}/shipper/donhang" class="menu-item">
            <span class="mi-left"><span class="mi-icon">📋</span> Đơn hàng nhận</span>
        </a>
        <a href="${pageContext.request.contextPath}/shipper/nhan-don" class="menu-item active">
            <span class="mi-left"><span class="mi-icon">📥</span> Nhận đơn mới</span>
        </a>
        <a href="${pageContext.request.contextPath}/shipper/dashboard" class="menu-item">
            <span class="mi-left"><span class="mi-icon">📊</span> Dashboard</span>
        </a>
        <a href="${pageContext.request.contextPath}/shipper/thongbao" class="menu-item">
            <span class="mi-left"><span class="mi-icon">🔔</span> Thông báo</span>
        </a>

        <div class="menu-title">Tài khoản</div>
        <a href="${pageContext.request.contextPath}/shipper/profile" class="menu-item">
            <span class="mi-left"><span class="mi-icon">🚙</span> Hồ sơ tài xế</span>
        </a>
        <a href="${pageContext.request.contextPath}/shipper/danh-gia" class="menu-item">
            <span class="mi-left"><span class="mi-icon">⭐</span> Đánh giá &amp; Báo cáo</span>
        </a>
    </div>
    <div class="sidebar-foot">
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
        <div style="display:flex;align-items:center;gap:10px;">
            <button type="button" class="menu-toggle-btn" onclick="pobToggleSidebar()">☰</button>
            <h1>📥 Danh sách đơn chờ nhận</h1>
        </div>
        <div class="topbar-right">
            <button type="button" class="theme-toggle" id="themeToggleBtn" onclick="pobToggleTheme()" title="Chuyển đổi giao diện"><span data-theme-icon>🌙</span></button>
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

        <c:if test="${not sessionScope.account.online}">
            <div class="alert alert-warning">⚠️ Bạn đang <strong>Offline</strong> — Bật Online ở sidebar để có thể nhận đơn.</div>
        </c:if>
        <c:if test="${param.error eq 'taken'}">
            <div class="alert alert-danger">❌ Đơn hàng này vừa được shipper khác nhận trước. Vui lòng chọn đơn khác.</div>
        </c:if>
        <c:if test="${param.error eq 'offline'}">
            <div class="alert alert-danger">❌ Bạn cần bật <strong>Online</strong> trước khi nhận đơn.</div>
        </c:if>

        <div style="display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:10px;">
            <div>
                <span style="font-size:14px;font-weight:700;color:var(--text-dim);">
                    Có <span style="color:var(--warning-dark);font-size:18px;">${fn:length(availableOrders)}</span>
                    đơn đang chờ shipper nhận
                </span>
            </div>
            <a href="${pageContext.request.contextPath}/shipper/nhan-don" class="btn btn-outline btn-sm">🔄 Làm mới</a>
        </div>

        <c:choose>
            <c:when test="${empty availableOrders}">
                <div class="empty-state">
                    <div class="e-icon">📭</div>
                    <div class="e-title">Không có đơn nào chờ nhận</div>
                    <div class="e-sub">Hãy bật Online và chờ đơn mới từ hệ thống.</div>
                </div>
            </c:when>
            <c:otherwise>
                <c:forEach var="order" items="${availableOrders}">
                    <div class="order-card">
                        <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:4px;">
                            <span style="font-weight:800;font-size:15px;color:var(--text-main);">Đơn #${order.id}</span>
                            <span style="font-size:11px;color:var(--text-dim);">🕒 ${order.createdAt}</span>
                        </div>

                        <div class="route-timeline">
                            <div class="route-step">
                                <div class="route-label">🏪 Lấy hàng tại</div>
                                <div class="route-text">${order.shopName}</div>
                                <div class="route-sub">📍 ${order.shopAddress}</div>
                                <div class="route-sub">📞 ${order.shopPhone}</div>
                            </div>
                            <div style="border-left:2px dashed var(--border-color);margin-left:6px;height:14px;"></div>
                            <div class="route-step">
                                <div class="route-label">🏠 Giao tới khách</div>
                                <div class="route-text">${order.receiverName}</div>
                                <div class="route-sub">📍 ${order.shippingAddress}</div>
                                <div class="route-sub">📞 ${order.receiverPhone}</div>
                            </div>
                        </div>

                        <div class="order-footer">
                            <div style="display:flex;gap:20px;align-items:flex-end;flex-wrap:wrap;">
                                <div class="price-wrap">
                                    <div class="price-label">Tổng đơn</div>
                                    <div class="price-val"><fmt:formatNumber value="${order.totalPrice}" type="number" maxFractionDigits="0"/>đ</div>
                                </div>
                                <div class="price-wrap">
                                    <div class="price-label">Phí ship</div>
                                    <div class="fee-val"><fmt:formatNumber value="${order.deliveryFee}" type="number" maxFractionDigits="0"/>đ</div>
                                </div>
                                <div>
                                    <c:choose>
                                        <c:when test="${order.paymentMethod == 'PAYOS'}"><span class="badge badge-payos">🏦 PayOS</span></c:when>
                                        <c:when test="${order.paymentMethod == 'BANK'}"><span class="badge badge-info">📱 QR</span></c:when>
                                        <c:otherwise><span class="badge badge-warning">💵 COD</span></c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <c:choose>
                                <c:when test="${sessionScope.account.online}">
                                    <form action="${pageContext.request.contextPath}/shipper/nhan-don" method="post">
                                        <input type="hidden" name="orderId" value="${order.id}">
                                        <button type="submit" class="btn btn-primary" onclick="return confirm('Xác nhận nhận đơn #${order.id}?')">✅ Nhận đơn này</button>
                                    </form>
                                </c:when>
                                <c:otherwise>
                                    <button disabled class="btn" style="background:var(--gray-200);color:var(--text-dim);cursor:not-allowed;">🔴 Cần Online</button>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>

    </div>
</main>

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
</body>
</html>
