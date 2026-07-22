<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="currentShop" value="${sessionScope.currentShop}" scope="request"/>

<%-- BẢO MẬT: KIỂM TRA QUYỀN SHOP (roleId = 2) --%>
<c:if test="${empty sessionScope.account || sessionScope.account.roleId != 2}">
    <c:redirect url="/dangnhap"/>
</c:if>

<!DOCTYPE html>
<html lang="vi" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hóa đơn - ${not empty currentShop.shopName ? currentShop.shopName : 'Cửa hàng'}</title>
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

        /* Bộ lọc danh sách hóa đơn */
        .filter-bar { display: flex; gap: 10px; flex-wrap: wrap; margin-bottom: 18px; align-items: center; }
        .filter-bar input[type="text"] { width: 220px; }
        .filter-bar a.clear { font-size: 12.5px; color: var(--text-dim); font-weight: 600; }
        .action-cell { display: flex; gap: 6px; flex-wrap: wrap; }
        .inline-form { display: inline; }
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
        <a href="${pageContext.request.contextPath}/shop" class="menu-item">
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
        <a href="${pageContext.request.contextPath}/shop/bills" class="menu-item active">
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
            <h1>📋 Quản lý hóa đơn / đơn hàng</h1>
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
        <c:if test="${not empty loi}">
            <div class="alert alert-danger">⚠️ <c:out value="${loi}"/></div>
        </c:if>
        <c:if test="${param.error eq 'not_found'}">
            <div class="alert alert-danger">⚠️ Không tìm thấy đơn hàng hoặc đơn không thuộc shop của bạn!</div>
        </c:if>
        <c:if test="${param.success eq 'confirmed'}">
            <div class="alert alert-success">✅ Đã xác nhận đơn hàng! Hãy chuẩn bị món.</div>
        </c:if>
        <c:if test="${param.success eq 'prepared'}">
            <div class="alert alert-success">📦 Đã chuẩn bị xong món! Shipper có thể nhận đơn ngay.</div>
        </c:if>
        <c:if test="${param.success eq 'assigned'}">
            <div class="alert alert-success">🛵 Đã gán shipper cho đơn hàng.</div>
        </c:if>
        <c:if test="${param.success eq 'cancelled'}">
            <div class="alert alert-danger">🚫 Đã hủy đơn hàng.</div>
        </c:if>
        <c:if test="${param.error eq 'already_assigned'}">
            <div class="alert alert-danger">⚠️ Đơn đã có shipper nhận trước đó rồi.</div>
        </c:if>
        <c:if test="${param.error eq 'invalid_shipper'}">
            <div class="alert alert-danger">⚠️ Vui lòng chọn shipper để gán.</div>
        </c:if>

        <form class="filter-bar" method="get" action="${pageContext.request.contextPath}/shop/bills">
            <input type="text" class="dash-input" name="q" placeholder="🔍 Tìm theo mã đơn / tên khách / SĐT..." value="${fn:escapeXml(q)}">
            <input type="date" class="dash-input" name="date" value="${dateFilter}">
            <select class="dash-input" name="status">
                <option value="" ${empty statusFilter ? 'selected' : ''}>Tất cả</option>
                <option value="UNPAID" ${statusFilter == 'UNPAID' ? 'selected' : ''}>Chưa thanh toán</option>
                <option value="PAID" ${statusFilter == 'PAID' ? 'selected' : ''}>Đã thanh toán</option>
                <option value="CANCELLED" ${statusFilter == 'CANCELLED' ? 'selected' : ''}>Hủy</option>
            </select>
            <select class="dash-input" name="method">
                <option value="" ${empty methodFilter ? 'selected' : ''}>Tất cả hình thức</option>
                <option value="COD" ${methodFilter == 'COD' ? 'selected' : ''}>💵 Tiền mặt</option>
                <option value="BANK" ${methodFilter == 'BANK' ? 'selected' : ''}>📱 QR chuyển khoản</option>
                <option value="PAYOS" ${methodFilter == 'PAYOS' ? 'selected' : ''}>🏦 PayOS</option>
            </select>
            <button type="submit" class="btn btn-primary">Lọc</button>
            <a href="${pageContext.request.contextPath}/shop/bills" class="clear">✕ Xóa lọc</a>
        </form>

        <section class="panel">
            <div class="panel-header">
                <div class="panel-title">📋 Danh sách đơn hàng</div>
            </div>
            <div class="panel-body" style="padding:0;">
                <c:choose>
                    <c:when test="${empty orderList}">
                        <div class="empty-state">
                            <div class="e-icon">🧾</div>
                            <div class="e-title">Không có đơn hàng nào khớp với bộ lọc.</div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="dash-table-wrap">
                            <table class="dash-table">
                                <thead>
                                <tr>
                                    <th>Mã đơn</th>
                                    <th>Người nhận</th>
                                    <th>Địa chỉ</th>
                                    <th>Tổng tiền</th>
                                    <th>Hình thức</th>
                                    <th>Thanh toán</th>
                                    <th>Trạng thái đơn</th>
                                    <th>Ngày tạo</th>
                                    <th>Thao tác</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach var="o" items="${orderList}">
                                    <tr>
                                        <td>#${o.id}</td>
                                        <td>
                                            <strong><c:out value="${o.receiverName}"/></strong><br>
                                            <c:out value="${o.receiverPhone}"/>
                                        </td>
                                        <td><c:out value="${o.shippingAddress}"/></td>
                                        <td><fmt:formatNumber value="${o.totalPrice}" type="number"/> đ</td>
                                        <td>
                                            <c:set var="pm" value="${fn:toUpperCase(o.paymentMethod)}"/>
                                            <c:choose>
                                                <c:when test="${pm == 'BANK'}"><span class="badge badge-info">📱 QR chuyển khoản</span></c:when>
                                                <c:when test="${pm == 'PAYOS'}"><span class="badge badge-info">🏦 PayOS</span></c:when>
                                                <c:otherwise><span class="badge badge-neutral">💵 Tiền mặt</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:set var="pst" value="${fn:toUpperCase(o.paymentStatus)}"/>
                                            <c:choose>
                                                <c:when test="${pst == 'PAID'}"><span class="badge badge-success">✅ Đã thanh toán</span></c:when>
                                                <c:when test="${pst == 'PENDING'}"><span class="badge badge-warning">⏳ Đang chờ</span></c:when>
                                                <c:otherwise><span class="badge badge-danger">⛔ Chưa thanh toán</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:set var="ds" value="${fn:toUpperCase(o.staTus)}"/>
                                            <c:choose>
                                                <c:when test="${ds == 'PENDING'}"><span class="badge badge-warning">⏳ Chờ xác nhận</span></c:when>
                                                <c:when test="${ds == 'CONFIRMED'}"><span class="badge badge-info">👨‍🍳 Đang chuẩn bị món</span></c:when>
                                                <c:when test="${ds == 'READY_FOR_PICKUP'}">
                                                    <span class="badge badge-info">📦 ${o.shipperId > 0 ? 'Đã gán shipper' : 'Chờ shipper'}</span>
                                                </c:when>
                                                <c:when test="${ds == 'SHIPPING'}"><span class="badge badge-warning">🚚 Đang giao</span></c:when>
                                                <c:when test="${ds == 'DELIVERED'}"><span class="badge badge-success">✅ Đã giao</span></c:when>
                                                <c:when test="${ds == 'CANCELLED'}"><span class="badge badge-danger">🚫 Đã hủy</span></c:when>
                                                <c:otherwise><span class="badge badge-neutral">${o.staTus}</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>${o.createdAt}</td>
                                        <td>
                                            <div class="action-cell">
                                                <a href="${pageContext.request.contextPath}/shop/bills?action=view&as=modal&id=${o.id}" class="btn btn-sm btn-primary">🧾 Xem</a>
                                                <c:if test="${fn:toUpperCase(o.staTus) == 'PENDING'}">
                                                    <form method="post" action="${pageContext.request.contextPath}/shop/bills" class="inline-form">
                                                        <input type="hidden" name="action" value="confirm"/>
                                                        <input type="hidden" name="orderId" value="${o.id}"/>
                                                        <button type="submit" class="btn btn-sm btn-success">✅ Xác nhận</button>
                                                    </form>
                                                    <form method="post" action="${pageContext.request.contextPath}/shop/bills" class="inline-form"
                                                          onsubmit="return confirm('Từ chối đơn #${o.id}?')">
                                                        <input type="hidden" name="action" value="cancel"/>
                                                        <input type="hidden" name="orderId" value="${o.id}"/>
                                                        <button type="submit" class="btn btn-sm btn-danger">❌ Từ chối</button>
                                                    </form>
                                                </c:if>
                                                <c:if test="${fn:toUpperCase(o.staTus) == 'CONFIRMED'}">
                                                    <form method="post" action="${pageContext.request.contextPath}/shop/bills" class="inline-form">
                                                        <input type="hidden" name="action" value="prepared"/>
                                                        <input type="hidden" name="orderId" value="${o.id}"/>
                                                        <button type="submit" class="btn btn-sm btn-success">📦 Đã chuẩn bị</button>
                                                    </form>
                                                    <form method="post" action="${pageContext.request.contextPath}/shop/bills" class="inline-form"
                                                          onsubmit="return confirm('Hủy đơn #${o.id}?')">
                                                        <input type="hidden" name="action" value="cancel"/>
                                                        <input type="hidden" name="orderId" value="${o.id}"/>
                                                        <button type="submit" class="btn btn-sm btn-danger">❌ Hủy</button>
                                                    </form>
                                                </c:if>
                                                <c:if test="${fn:toUpperCase(o.staTus) == 'READY_FOR_PICKUP' && o.shipperId <= 0}">
                                                    <form method="post" action="${pageContext.request.contextPath}/shop/bills" class="inline-form">
                                                        <input type="hidden" name="action" value="assignShipper"/>
                                                        <input type="hidden" name="orderId" value="${o.id}"/>
                                                        <select name="shipperId" class="dash-input" style="padding:4px 6px;font-size:12.5px;" required>
                                                            <option value="">-- Chọn shipper --</option>
                                                            <c:forEach var="sh" items="${onlineShippers}">
                                                                <option value="${sh.id}">${sh.fullName != null ? sh.fullName : sh.userName}</option>
                                                            </c:forEach>
                                                        </select>
                                                        <button type="submit" class="btn btn-sm btn-primary">🛵 Gán</button>
                                                    </form>
                                                </c:if>
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
        </section>
    </div>
</main>

<%@ include file="_invoiceModal.jspf" %>

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
