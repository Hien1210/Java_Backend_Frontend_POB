<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="currentShop" value="${sessionScope.currentShop}" scope="request"/>

<c:if test="${empty sessionScope.account || sessionScope.account.roleId != 2}">
    <c:redirect url="/dangnhap"/>
</c:if>

<!DOCTYPE html>
<html lang="vi" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Flash Sale - ${not empty currentShop.shopName ? currentShop.shopName : 'Cửa hàng'}</title>
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
        .flash-badge { display: inline-flex; align-items: center; gap: 5px; background: #fff3cd; color: #856404; border: 1px solid #ffc107; border-radius: 6px; padding: 2px 10px; font-size: 11.5px; font-weight: 700; }
        .flash-badge.active { background: #d1fae5; color: #065f46; border-color: #10b981; }
        .form-row { display: flex; gap: 12px; flex-wrap: wrap; }
        .form-row .form-group { flex: 1; min-width: 180px; }
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
        <div class="menu-title">Khuyến mãi</div>
        <a href="${pageContext.request.contextPath}/shop/combo" class="menu-item">
            <span class="mi-left"><span class="mi-icon">🎁</span> Quản lý Combo</span>
        </a>
        <a href="${pageContext.request.contextPath}/shop/flash-sale" class="menu-item active">
            <span class="mi-left"><span class="mi-icon">⚡</span> Flash Sale</span>
        </a>
    </div>
</aside>

<main class="main">
    <header class="topbar">
        <div style="display:flex;align-items:center;gap:10px;">
            <button type="button" class="menu-toggle-btn" onclick="pobToggleSidebar()">☰</button>
            <h1>⚡ Flash Sale</h1>
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
        <c:if test="${param.saved eq '1'}">
            <div class="alert alert-success">✅ Đã tạo Flash Sale thành công.</div>
        </c:if>
        <c:if test="${param.deleted eq '1'}">
            <div class="alert alert-danger">🗑️ Đã xóa Flash Sale.</div>
        </c:if>
        <c:if test="${param.error eq 'invalid'}">
            <div class="alert alert-danger">⚠️ Thông tin không hợp lệ (giá bán phải > 0, thời gian kết thúc phải sau thời gian bắt đầu).</div>
        </c:if>

        <div class="dash-card" style="margin-bottom:24px;">
            <div class="dash-card-header"><h3>➕ Tạo Flash Sale mới</h3></div>
            <div class="dash-card-body">
                <form method="post" action="${pageContext.request.contextPath}/shop/flash-sale">
                    <div class="form-group">
                        <label class="form-label">Sản phẩm &amp; size *</label>
                        <select name="productSizeId" class="dash-input" required>
                            <option value="">-- Chọn sản phẩm + size --</option>
                            <c:forEach items="${allSizes}" var="ps">
                                <option value="${ps.id}">${fn:escapeXml(productNameById[ps.productId])} — ${fn:escapeXml(ps.sizeName)} (Giá gốc: <fmt:formatNumber value="${ps.price}" type="number" maxFractionDigits="0"/>đ)</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Giá Flash Sale (đ) *</label>
                            <input type="number" class="dash-input" name="salePrice" min="1000" step="500" required placeholder="VD: 39000">
                        </div>
                        <div class="form-group">
                            <label class="form-label">Bắt đầu *</label>
                            <input type="datetime-local" class="dash-input" name="startTime" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Kết thúc *</label>
                            <input type="datetime-local" class="dash-input" name="endTime" required>
                        </div>
                    </div>
                    <button type="submit" class="btn btn-primary">⚡ Tạo Flash Sale</button>
                </form>
            </div>
        </div>

        <div class="dash-card">
            <div class="dash-card-header"><h3>📋 Danh sách Flash Sale</h3></div>
            <div class="dash-card-body">
                <c:choose>
                    <c:when test="${empty flashSales}">
                        <p style="color:var(--text-muted);">Chưa có Flash Sale nào.</p>
                    </c:when>
                    <c:otherwise>
                        <table class="dash-table">
                            <thead>
                                <tr>
                                    <th>Sản phẩm</th>
                                    <th>Giá gốc</th>
                                    <th>Giá Flash</th>
                                    <th>Bắt đầu</th>
                                    <th>Kết thúc</th>
                                    <th>Trạng thái</th>
                                    <th></th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${flashSales}" var="fs">
                                    <tr>
                                        <td><strong><c:out value="${fs.productName}"/></strong> — <c:out value="${fs.sizeName}"/></td>
                                        <td><fmt:formatNumber value="${fs.originalPrice}" type="number" maxFractionDigits="0"/>đ</td>
                                        <td style="color:var(--primary);font-weight:700;"><fmt:formatNumber value="${fs.salePrice}" type="number" maxFractionDigits="0"/>đ</td>
                                        <td>${fs.startTime}</td>
                                        <td>${fs.endTime}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${fs.currentlyActive}">
                                                    <span class="flash-badge active">🟢 Đang diễn ra</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="flash-badge">⏸ Không hoạt động</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <form method="post" action="${pageContext.request.contextPath}/shop/flash-sale" style="display:inline"
                                                  onsubmit="return confirm('Xóa Flash Sale này?')">
                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="flashSaleId" value="${fs.id}">
                                                <button type="submit" class="btn btn-danger btn-sm">🗑️</button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</main>

<script src="${pageContext.request.contextPath}/assets/js/dashboard.js"></script>
</body>
</html>
