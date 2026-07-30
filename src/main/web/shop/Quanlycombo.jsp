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
    <title>Quản lý Combo - ${not empty currentShop.shopName ? currentShop.shopName : 'Cửa hàng'}</title>
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
        .combo-card { background: var(--bg-panel); border: 1px solid var(--border-color); border-radius: var(--radius-md); padding: 18px; margin-bottom: 14px; }
        .combo-name { font-weight: 800; font-size: 15px; color: var(--text-main); }
        .combo-price { color: var(--primary); font-weight: 700; font-size: 14px; }
        .combo-items-list { margin-top: 10px; font-size: 13px; color: var(--text-muted); }
        .form-row { display: flex; gap: 12px; flex-wrap: wrap; }
        .form-row .form-group { flex: 1; min-width: 180px; }
        .item-row { display: flex; gap: 8px; align-items: center; margin-bottom: 8px; }
        .item-row select { flex: 1; }
        .item-row input[type="number"] { width: 70px; }
        .btn-remove-item { background: none; border: none; color: var(--danger); font-size: 18px; cursor: pointer; padding: 0 4px; }
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
        <a href="${pageContext.request.contextPath}/shop/combo" class="menu-item active">
            <span class="mi-left"><span class="mi-icon">🎁</span> Quản lý Combo</span>
        </a>
        <a href="${pageContext.request.contextPath}/shop/flash-sale" class="menu-item">
            <span class="mi-left"><span class="mi-icon">⚡</span> Flash Sale</span>
        </a>
        <div class="menu-title">Tài chính</div>
        <a href="${pageContext.request.contextPath}/shop/vi-tien" class="menu-item">
            <span class="mi-left"><span class="mi-icon">💰</span><span class="mi-label"> Ví tiền Shop</span></span>
        </a>
    </div>
</aside>

<main class="main">
    <header class="topbar">
        <div style="display:flex;align-items:center;gap:10px;">
            <button type="button" class="menu-toggle-btn" onclick="pobToggleSidebar()">☰</button>
            <h1>🎁 Quản lý Combo</h1>
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
            <div class="alert alert-success">✅ Đã lưu combo thành công.</div>
        </c:if>
        <c:if test="${param.deleted eq '1'}">
            <div class="alert alert-danger">🗑️ Đã xóa combo.</div>
        </c:if>
        <c:if test="${param.error eq 'invalid'}">
            <div class="alert alert-danger">⚠️ Thông tin không hợp lệ, vui lòng kiểm tra lại.</div>
        </c:if>

        <div class="dash-card" style="margin-bottom:24px;">
            <div class="dash-card-header"><h3 id="comboFormTitle">➕ Tạo Combo mới</h3></div>
            <div class="dash-card-body">
                <form method="post" action="${pageContext.request.contextPath}/shop/combo" id="comboForm">
                    <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                    <input type="hidden" name="comboId" id="comboIdInput" value="">
                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Tên combo *</label>
                            <input type="text" class="dash-input" name="name" id="comboNameInput" required placeholder="VD: Combo Đôi">
                        </div>
                        <div class="form-group">
                            <label class="form-label">Giá combo (đ) *</label>
                            <input type="number" class="dash-input" name="comboPrice" id="comboPriceInput" min="1000" step="500" required placeholder="VD: 85000">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Mô tả</label>
                        <input type="text" class="dash-input" name="description" id="comboDescInput" placeholder="VD: 2 ly cà phê + 1 bánh mì">
                    </div>

                    <div class="form-group">
                        <label class="form-label">Sản phẩm trong combo</label>
                        <div id="itemRows">
                            <div class="item-row">
                                <select name="productSizeId[]" class="dash-input" style="flex:1;">
                                    <option value="">-- Chọn sản phẩm + size --</option>
                                    <c:forEach items="${allSizes}" var="ps">
                                        <option value="${ps.id}">${fn:escapeXml(productNameById[ps.productId])} — ${fn:escapeXml(ps.sizeName)} (<fmt:formatNumber value="${ps.price}" type="number" maxFractionDigits="0"/>đ)</option>
                                    </c:forEach>
                                </select>
                                <input type="number" name="quantity[]" value="1" min="1" class="dash-input">
                                <button type="button" class="btn-remove-item" onclick="this.parentElement.remove()">✕</button>
                            </div>
                        </div>
                        <button type="button" class="btn btn-outline" style="margin-top:8px;" onclick="addItemRow()">+ Thêm sản phẩm</button>
                    </div>

                    <div style="display:flex;gap:10px;">
                        <button type="submit" class="btn btn-primary" id="comboSubmitBtn">💾 Tạo Combo</button>
                        <button type="button" class="btn btn-outline" id="comboCancelEditBtn" style="display:none;" onclick="cancelEditCombo()">✕ Hủy sửa</button>
                    </div>
                </form>
            </div>
        </div>

        <div class="dash-card">
            <div class="dash-card-header"><h3>📋 Danh sách Combo</h3></div>
            <div class="dash-card-body">
                <c:choose>
                    <c:when test="${empty combos}">
                        <p style="color:var(--text-muted);">Chưa có combo nào.</p>
                    </c:when>
                    <c:otherwise>
                        <c:forEach items="${combos}" var="combo">
                            <div class="combo-card"
                                 data-combo-id="${combo.id}"
                                 data-combo-name="${fn:escapeXml(combo.name)}"
                                 data-combo-price="${combo.comboPrice}"
                                 data-combo-desc="${fn:escapeXml(combo.description)}"
                                 data-combo-items='[<c:forEach items="${combo.items}" var="item" varStatus="is">{"productSizeId":${item.productSizeId},"quantity":${item.quantity}}${is.last ? "" : ","}</c:forEach>]'>
                                <div style="display:flex;justify-content:space-between;align-items:center;">
                                    <div>
                                        <div class="combo-name">🎁 <c:out value="${combo.name}"/></div>
                                        <div class="combo-price"><fmt:formatNumber value="${combo.comboPrice}" type="number" maxFractionDigits="0"/>đ</div>
                                        <c:if test="${not empty combo.description}">
                                            <div style="font-size:12.5px;color:var(--text-muted);margin-top:2px;"><c:out value="${combo.description}"/></div>
                                        </c:if>
                                    </div>
                                    <div style="display:flex;gap:8px;">
                                        <button type="button" class="btn btn-outline btn-sm" onclick="editCombo(this.closest('.combo-card'))">✏️ Sửa</button>
                                        <form method="post" action="${pageContext.request.contextPath}/shop/combo" style="display:inline"
                                              onsubmit="return confirm('Xóa combo này?')">
                                            <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="comboId" value="${combo.id}">
                                            <button type="submit" class="btn btn-danger btn-sm">🗑️ Xóa</button>
                                        </form>
                                    </div>
                                </div>
                                <c:if test="${not empty combo.items}">
                                    <div class="combo-items-list">
                                        <c:forEach items="${combo.items}" var="item">
                                            <div>• <c:out value="${item.productName}"/> — <c:out value="${item.sizeName}"/> x${item.quantity}</div>
                                        </c:forEach>
                                    </div>
                                </c:if>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</main>

<script src="${pageContext.request.contextPath}/assets/js/dashboard.js"></script>
<script>
var ITEM_ROW_TEMPLATE_HTML = document.querySelector('#itemRows .item-row').outerHTML;

function addItemRow(productSizeId, quantity) {
    var wrap = document.createElement('div');
    wrap.innerHTML = ITEM_ROW_TEMPLATE_HTML;
    var row = wrap.firstElementChild;
    row.querySelector('select').value = productSizeId || '';
    row.querySelector('input[type="number"]').value = quantity || '1';
    document.getElementById('itemRows').appendChild(row);
}

function editCombo(card) {
    var comboId = card.dataset.comboId;
    var items = JSON.parse(card.dataset.comboItems || '[]');

    document.getElementById('comboIdInput').value = comboId;
    document.getElementById('comboNameInput').value = card.dataset.comboName || '';
    document.getElementById('comboPriceInput').value = card.dataset.comboPrice || '';
    document.getElementById('comboDescInput').value = card.dataset.comboDesc || '';

    var rowsWrap = document.getElementById('itemRows');
    rowsWrap.innerHTML = '';
    if (items.length === 0) {
        addItemRow();
    } else {
        items.forEach(function (item) {
            addItemRow(item.productSizeId, item.quantity);
        });
    }

    document.getElementById('comboFormTitle').textContent = '✏️ Sửa Combo';
    document.getElementById('comboSubmitBtn').textContent = '💾 Lưu thay đổi';
    document.getElementById('comboCancelEditBtn').style.display = 'inline-block';

    document.getElementById('comboForm').scrollIntoView({ behavior: 'smooth', block: 'start' });
}

function cancelEditCombo() {
    document.getElementById('comboIdInput').value = '';
    document.getElementById('comboForm').reset();

    var rowsWrap = document.getElementById('itemRows');
    rowsWrap.innerHTML = '';
    addItemRow();

    document.getElementById('comboFormTitle').textContent = '➕ Tạo Combo mới';
    document.getElementById('comboSubmitBtn').textContent = '💾 Tạo Combo';
    document.getElementById('comboCancelEditBtn').style.display = 'none';
}
</script>
</body>
</html>
