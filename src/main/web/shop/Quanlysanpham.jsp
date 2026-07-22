<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
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
    <title>Quản lý Sản Phẩm - ${not empty currentShop.shopName ? currentShop.shopName : 'Cửa hàng'}</title>
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

        /* Toolbar bảng: filter + search + đếm kết quả */
        .table-toolbar { padding: 16px 20px; border-bottom: 1px solid var(--border-color); display: flex; align-items: center; justify-content: space-between; gap: 12px; flex-wrap: wrap; }
        .toolbar-left { display: flex; align-items: center; gap: 12px; flex-wrap: wrap; }
        .result-count { font-size: 12px; color: var(--text-dim); }
        .result-count strong { color: var(--text-main); }

        /* Sản phẩm trong bảng */
        .product-img { width: 46px; height: 46px; border-radius: var(--radius-sm); object-fit: cover; background: var(--bg-input); border: 1px solid var(--border-color); display: flex; align-items: center; justify-content: center; font-size: 20px; flex-shrink: 0; }
        .product-info { display: flex; align-items: center; gap: 12px; }
        .product-name { font-weight: 700; color: var(--text-main); }
        .product-category { font-size: 11px; color: var(--text-muted); margin-top: 2px; background: var(--bg-input); padding: 2px 8px; border-radius: 6px; display: inline-block; }
        .product-desc { font-size: 11px; color: var(--text-muted); margin-top: 3px; max-width: 180px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .price-main { font-weight: 800; color: var(--primary-dark); font-size: 14px; }

        /* Size chips */
        .size-list { display: flex; flex-wrap: wrap; gap: 5px; }
        .size-chip { display: inline-flex; align-items: center; gap: 4px; padding: 3px 9px; border-radius: 8px; font-size: 11px; font-weight: 700; background: var(--primary-light); color: var(--primary-dark); border: 1px solid rgba(255,87,34,.3); }
        .size-chip .size-price { color: var(--text-muted); font-weight: 500; }

        .stock-num { font-weight: 700; }
        .stock-num.low { color: var(--danger); }
        .stock-num.ok { color: var(--success-dark); }
        .action-cell { display: flex; gap: 6px; flex-wrap: wrap; justify-content: center; }
        .inline-form { display: inline; }
        .table-footer { padding: 14px 20px; border-top: 1px solid var(--border-color); display: flex; align-items: center; justify-content: space-between; font-size: 12px; color: var(--text-dim); }

        /* Form grid trong modal thêm/sửa sản phẩm */
        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }
        .form-full { grid-column: 1 / -1; }

        /* Size section trong modal */
        .size-section { border: 1px solid var(--border-color); border-radius: var(--radius-md); overflow: hidden; }
        .size-section-header { padding: 12px 16px; background: var(--bg-input); display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid var(--border-color); }
        .size-section-title { font-size: 12px; font-weight: 700; color: var(--text-muted); text-transform: uppercase; letter-spacing: .4px; }
        .size-rows { padding: 12px; }
        .size-row { display: grid; grid-template-columns: 1fr 1fr auto; gap: 8px; align-items: center; margin-bottom: 10px; }
        .size-row:last-child { margin-bottom: 0; }
        .btn-remove-size { width: 32px; height: 32px; border-radius: var(--radius-sm); background: var(--danger-light); color: var(--danger); border: 1px solid var(--danger); cursor: pointer; display: flex; align-items: center; justify-content: center; font-size: 16px; flex-shrink: 0; }
        .btn-remove-size:hover { background: var(--danger); color: #fff; }
        .btn-add-size { margin-top: 8px; padding: 8px 16px; background: var(--primary-light); color: var(--primary-dark); border: 1px dashed var(--primary); border-radius: var(--radius-sm); font-size: 12px; font-weight: 700; cursor: pointer; width: 100%; }
        .btn-add-size:hover { background: var(--primary); color: #fff; border-style: solid; }

        /* Ảnh preview */
        .img-preview { width: 100%; height: 120px; border: 2px dashed var(--border-color); border-radius: var(--radius-md); display: flex; align-items: center; justify-content: center; margin-top: 8px; overflow: hidden; background: var(--bg-input); }
        .img-preview img { width: 100%; height: 100%; object-fit: cover; }
        .img-preview .placeholder { font-size: 28px; color: var(--text-dim); }
        .modal-footer { padding: 20px 26px; border-top: 1px solid var(--border-color); display: flex; justify-content: flex-end; gap: 12px; }
    </style>
</head>
<body class="dash-body">

<div class="sidebar-backdrop" id="sidebarBackdrop"></div>
<aside class="sidebar" id="sidebar">
    <div class="sidebar-brand">
        <div class="logo-mark-dash">🍔</div>
        <div class="brand-text">
            <span class="brand-title">${not empty currentShop.shopName ? currentShop.shopName : 'CỬA HÀNG'}</span>
            <span class="brand-subtitle">👋 ${sessionScope.account.userName}</span>
        </div>
    </div>
    <div class="menu">
        <div class="menu-title">Tổng quan</div>
        <a href="${pageContext.request.contextPath}/shop" class="menu-item">
            <span class="mi-left"><span class="mi-icon">📊</span> Trang chủ</span>
        </a>

        <div class="menu-title">Sản phẩm</div>
        <a href="${pageContext.request.contextPath}/shop/products" class="menu-item active">
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
            <h1>🍽️ Quản lý sản phẩm</h1>
        </div>
        <div class="topbar-right">
            <input type="text" class="dash-input" style="width:220px;"
                   placeholder="🔍 Tìm tên sản phẩm..."
                   oninput="filterProducts(this.value)">
            <a href="${pageContext.request.contextPath}/shop/products?action=trash" class="btn btn-danger-outline btn-sm">🗑️ Thùng rác</a>
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
        <c:if test="${param.success eq 'create'}">
            <div class="alert alert-success">✅ Thêm sản phẩm thành công!</div>
        </c:if>
        <c:if test="${param.success eq 'update'}">
            <div class="alert alert-success">✅ Cập nhật sản phẩm thành công!</div>
        </c:if>
        <c:if test="${param.success eq 'delete'}">
            <div class="alert alert-success">✅ Xóa sản phẩm thành công!</div>
        </c:if>
        <c:if test="${not empty loi}">
            <div class="alert alert-danger">⚠️ <c:out value="${loi}"/></div>
        </c:if>

        <div class="stats-grid">
            <div class="stat-card">
                <div><div style="font-size:12px;color:var(--text-dim);font-weight:600;">Tổng sản phẩm</div><div class="stat-num">${fn:length(danhsach)}</div></div>
                <div class="stat-icon">🍽️</div>
            </div>
            <div class="stat-card">
                <div><div style="font-size:12px;color:var(--text-dim);font-weight:600;">Đang bán</div><div class="stat-num">${soDangBan}</div></div>
                <div class="stat-icon" style="background:var(--success-light);color:var(--success-dark);">✅</div>
            </div>
            <div class="stat-card">
                <div><div style="font-size:12px;color:var(--text-dim);font-weight:600;">Hết hàng</div><div class="stat-num">${soHetHang}</div></div>
                <div class="stat-icon" style="background:var(--warning-light);color:var(--warning-dark);">⏸️</div>
            </div>
            <div class="stat-card">
                <div><div style="font-size:12px;color:var(--text-dim);font-weight:600;">Đã bán</div><div class="stat-num">${tongDaBan}</div></div>
                <div class="stat-icon" style="background:var(--danger-light);color:var(--danger);">📈</div>
            </div>
        </div>

        <div class="panel">
            <div class="table-toolbar">
                <div class="toolbar-left">
                    <select class="dash-input" style="width:auto;" onchange="filterByType(this.value)">
                        <option value="">Tất cả loại</option>
                        <c:forEach var="pt" items="${danhsachLoai}">
                            <option value="${pt.id}"><c:out value="${pt.categoryName}"/></option>
                        </c:forEach>
                    </select>
                    <select class="dash-input" style="width:auto;" onchange="filterByStatus(this.value)">
                        <option value="">Tất cả trạng thái</option>
                        <option value="ACTIVE">✅ Đang bán</option>
                        <option value="HIDDEN">🙈 Tạm ẩn</option>
                        <option value="OUT_OF_STOCK">⏸️ Hết hàng</option>
                    </select>
                    <span class="result-count">Tổng: <strong id="visibleCount">${fn:length(danhsach)}</strong> sản phẩm</span>
                </div>
                <button type="button" class="btn btn-primary" onclick="openProductModal()">➕ Thêm sản phẩm mới</button>
            </div>

            <c:choose>
                <c:when test="${empty danhsach}">
                    <div class="empty-state">
                        <div class="e-icon">🍽️</div>
                        <div class="e-title">Chưa có sản phẩm nào trong cửa hàng.</div>
                        <div class="e-sub"><a href="javascript:void(0)" onclick="openProductModal()" style="color:var(--primary);font-weight:700;">Thêm sản phẩm đầu tiên ngay →</a></div>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="dash-table-wrap">
                        <table class="dash-table" id="productTable">
                            <thead>
                                <tr>
                                    <th>Sản phẩm</th>
                                    <th>Loại SP</th>
                                    <th>Giá bán</th>
                                    <th>Size</th>
                                    <th>Tồn kho</th>
                                    <th>Đã bán</th>
                                    <th>Trạng thái</th>
                                    <th style="text-align:center;">Thao tác</th>
                                </tr>
                            </thead>
                           <tbody>
                               <c:forEach var="product" items="${danhsach}">
                                   <tr data-name="${fn:toLowerCase(product.productName)}"
                                       data-type="${product.categoryId}"
                                       data-status="${fn:toUpperCase(product.staTus)}">

                                       <td>
                                           <div class="product-info">
                                               <div class="product-img">
                                                   <c:choose>
                                                       <c:when test="${not empty product.imageUrl && product.imageUrl != 'null'}">
                                                           <img src="${product.imageUrl}" alt="${product.productName}"
                                                                onerror="this.style.display='none';this.nextSibling.style.display='flex'">
                                                           <span style="display:none">🍽️</span>
                                                       </c:when>
                                                       <c:otherwise>🍽️</c:otherwise>
                                                   </c:choose>
                                               </div>
                                               <div>
                                                   <div class="product-name"><c:out value="${product.productName}"/></div>
                                                   <c:if test="${not empty product.description}">
                                                       <div class="product-desc"><c:out value="${product.description}"/></div>
                                                   </c:if>
                                               </div>
                                           </div>
                                       </td>

                                       <td><span class="product-category"><c:out value="${product.categoryName}"/></span></td>

                                       <td>
                                           <div class="price-main">
                                               <c:choose>
                                                   <c:when test="${not empty product.sizes && product.sizes.size() > 0}">
                                                       <fmt:formatNumber value="${product.sizes[0].price}" type="number" maxFractionDigits="0"/>đ
                                                   </c:when>
                                                   <c:otherwise><span style="color:var(--text-dim);">Chưa có giá</span></c:otherwise>
                                               </c:choose>
                                           </div>
                                       </td>

                                       <td>
                                           <c:choose>
                                               <c:when test="${not empty product.sizes}">
                                                   <div class="size-list">
                                                       <c:forEach var="sz" items="${product.sizes}">
                                                           <span class="size-chip">
                                                               ${sz.sizeName}
                                                               <span class="size-price"><fmt:formatNumber value="${sz.price}" type="number" maxFractionDigits="0"/>đ</span>
                                                           </span>
                                                       </c:forEach>
                                                   </div>
                                               </c:when>
                                               <c:otherwise><span style="font-size:12px;color:var(--text-dim);">Không có size</span></c:otherwise>
                                           </c:choose>
                                       </td>

                                       <td><span class="stock-num ${product.stockQuantity <= 5 ? 'low' : 'ok'}">${product.stockQuantity}</span></td>
                                       <td><strong>${product.soldCount}</strong></td>

                                       <td>
                                           <c:choose>
                                               <c:when test="${fn:toUpperCase(product.staTus) == 'ACTIVE'}"><span class="badge badge-success">✅ Đang bán</span></c:when>
                                               <c:when test="${fn:toUpperCase(product.staTus) == 'HIDDEN'}"><span class="badge badge-danger">🙈 Tạm ẩn</span></c:when>
                                               <c:when test="${fn:toUpperCase(product.staTus) == 'OUT_OF_STOCK'}"><span class="badge badge-warning">⏸️ Hết hàng</span></c:when>
                                               <c:otherwise><span class="badge badge-neutral"><c:out value="${product.staTus}"/></span></c:otherwise>
                                           </c:choose>
                                       </td>

                                       <td>
                                           <div class="action-cell">
                                               <a href="${pageContext.request.contextPath}/shop/products?action=edit&id=${product.id}"
                                                  class="btn btn-sm btn-outline">✏️ Sửa</a>
                                               <form class="inline-form"
                                                     action="${pageContext.request.contextPath}/shop/products"
                                                     method="post"
                                                     onsubmit="return confirm('Xóa sản phẩm «${fn:escapeXml(product.productName)}»?')">
                                                   <input type="hidden" name="action" value="delete">
                                                   <input type="hidden" name="id" value="${product.id}">
                                                   <button type="submit" class="btn btn-sm btn-danger-outline">🗑️</button>
                                               </form>
                                           </div>
                                       </td>
                                   </tr>
                               </c:forEach>
                           </tbody>
                        </table>
                    </div>
                    <div class="table-footer">
                        <span>Hiển thị <strong id="showCount">${fn:length(danhsach)}</strong> sản phẩm</span>
                        <span style="color:var(--text-dim);font-size:11px;">💡 Click ✏️ Sửa để quản lý các size của từng sản phẩm</span>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</main>

<%-- ── MODAL THÊM / SỬA SẢN PHẨM ── --%>
<div class="pob-modal-overlay" id="productModal">
    <div class="pob-modal-box" style="max-width:720px;">
        <div class="modal-header">
            <div class="panel-title">
                <c:choose>
                    <c:when test="${not empty productSua}">✏️ Cập nhật sản phẩm</c:when>
                    <c:otherwise>➕ Thêm sản phẩm mới</c:otherwise>
                </c:choose>
            </div>
            <button type="button" class="modal-close" onclick="closeProductModal()">✕</button>
        </div>
        <div class="modal-body">
            <form action="${pageContext.request.contextPath}/shop/products" method="post" id="productForm">
                <c:choose>
                    <c:when test="${not empty productSua}">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="id" value="${productSua.id}">
                    </c:when>
                    <c:otherwise>
                        <input type="hidden" name="action" value="create">
                    </c:otherwise>
                </c:choose>

                <div class="form-grid">
                    <div class="form-group form-full">
                        <label class="form-label" for="productName">Tên sản phẩm <span class="required">*</span></label>
                        <input type="text" id="productName" name="productName" class="form-control"
                               value="${fn:escapeXml(productSua.productName)}"
                               placeholder="Ví dụ: Cơm tấm sườn bì chả, Bún bò Huế..."
                               required autofocus>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="productTypeId">Loại sản phẩm <span class="required">*</span></label>
                        <select id="productTypeId" name="productTypeId" class="form-select" required>
                            <option value="">-- Chọn loại --</option>
                            <c:forEach var="pt" items="${danhsachLoai}">
                                <option value="${pt.id}" ${productSua.categoryId == pt.id ? 'selected' : ''}>
                                    <c:out value="${pt.categoryName}"/>
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="stockQuantity">Số lượng tồn kho</label>
                        <input type="number" id="stockQuantity" name="stockQuantity" class="form-control"
                               value="${not empty productSua.stockQuantity ? productSua.stockQuantity : 0}"
                               placeholder="0" min="0">
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="soldCount">Số đã bán</label>
                        <input type="number" id="soldCount" name="soldCount" class="form-control"
                               value="${not empty productSua.soldCount ? productSua.soldCount : 0}"
                               placeholder="0" min="0">
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="status">Trạng thái</label>
                        <select id="status" name="status" class="form-select">
                            <option value="ACTIVE"        ${fn:toUpperCase(productSua.staTus) == 'ACTIVE'        ? 'selected' : ''}>✅ Đang bán</option>
                            <option value="HIDDEN"        ${fn:toUpperCase(productSua.staTus) == 'HIDDEN'        ? 'selected' : ''}>🙈 Tạm ẩn</option>
                            <option value="OUT_OF_STOCK"  ${fn:toUpperCase(productSua.staTus) == 'OUT_OF_STOCK'  ? 'selected' : ''}>⏸️ Hết hàng</option>
                        </select>
                    </div>

                    <div class="form-group form-full">
                        <label class="form-label" for="imageUrl">URL ảnh sản phẩm</label>
                        <input type="text" id="imageUrl" name="imageUrl" class="form-control"
                               value="${fn:escapeXml(productSua.imageUrl)}"
                               placeholder="https://..."
                               oninput="previewImage(this.value)">
                        <div class="img-preview" id="imgPreview">
                            <c:choose>
                                <c:when test="${not empty productSua.imageUrl}"><img src="${productSua.imageUrl}" alt="Preview"></c:when>
                                <c:otherwise><span class="placeholder">🖼️</span></c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <div class="form-group form-full">
                        <label class="form-label" for="description">Mô tả sản phẩm</label>
                        <textarea id="description" name="description" class="form-control form-textarea"
                                  placeholder="Mô tả ngắn về nguyên liệu, hương vị..."><c:out value="${productSua.description}"/></textarea>
                    </div>

                    <div class="form-group form-full">
                        <label class="form-label">Size / Khẩu phần (tuỳ chọn)</label>
                        <div class="size-section">
                            <div class="size-section-header">
                                <span class="size-section-title">Danh sách size</span>
                                <span style="font-size:11px;color:var(--text-dim);">Điều chỉnh giá theo size</span>
                            </div>
                            <div class="size-rows" id="sizeRows">
                                <c:choose>
                                    <c:when test="${not empty productSua.sizes}">
                                        <c:forEach var="sz" items="${productSua.sizes}" varStatus="loop">
                                            <div class="size-row">
                                                <input type="text" name="sizeName[]" class="form-control"
                                                       value="${fn:escapeXml(sz.sizeName)}"
                                                       placeholder="Tên size (S, M, L...)">
                                                <input type="number" name="sizePrice[]" class="form-control"
                                                       value="${sz.price}"
                                                       placeholder="Giá size (đ)" min="0" step="500">
                                                <button type="button" class="btn-remove-size" onclick="removeSize(this)">×</button>
                                            </div>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="size-row">
                                            <input type="text" name="sizeName[]" class="form-control" placeholder="Tên size (S, M, L...)">
                                            <input type="number" name="sizePrice[]" class="form-control" placeholder="Giá size (đ)" min="0" step="500">
                                            <button type="button" class="btn-remove-size" onclick="removeSize(this)">×</button>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div style="padding:0 12px 12px;">
                                <button type="button" class="btn-add-size" onclick="addSizeRow()">＋ Thêm size</button>
                            </div>
                        </div>
                    </div>
                </div>

                <c:if test="${not empty loi}">
                    <div class="alert alert-danger" style="margin-top:16px;">⚠️ <c:out value="${loi}"/></div>
                </c:if>
            </form>
        </div>
        <div class="modal-footer">
            <button type="button" class="btn btn-ghost" onclick="closeProductModal()">Hủy</button>
            <button type="submit" form="productForm" class="btn btn-primary">
                <c:choose>
                    <c:when test="${not empty productSua}">💾 Lưu thay đổi</c:when>
                    <c:otherwise>➕ Thêm sản phẩm</c:otherwise>
                </c:choose>
            </button>
        </div>
    </div>
</div>

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
    const modal = document.getElementById('productModal');
    const isEditMode = ${ not empty productSua ? 'true' : 'false' };
    const hasError   = ${ not empty loi ? 'true' : 'false' };

    function openProductModal() { modal.classList.add('open'); }
    function closeProductModal() {
        modal.classList.remove('open');
        if (isEditMode) {
            window.location.href = '${pageContext.request.contextPath}/shop/products';
        }
    }
    modal.addEventListener('click', e => { if (e.target === modal) closeProductModal(); });
    document.addEventListener('DOMContentLoaded', () => {
        if (isEditMode || hasError) openProductModal();
    });

    function addSizeRow() {
        const container = document.getElementById('sizeRows');
        const row = document.createElement('div');
        row.className = 'size-row';
        row.innerHTML = `
            <input type="text"   name="sizeName[]"  class="form-control" placeholder="Tên size (S, M, L...)">
            <input type="number" name="sizePrice[]" class="form-control" placeholder="Giá size (đ)" min="0" step="500">
            <button type="button" class="btn-remove-size" onclick="removeSize(this)">×</button>
        `;
        container.appendChild(row);
        row.querySelector('input').focus();
    }
    function removeSize(btn) {
        const rows = document.querySelectorAll('.size-row');
        if (rows.length > 1) {
            btn.closest('.size-row').remove();
        } else {
            btn.closest('.size-row').querySelectorAll('input').forEach(i => i.value = '');
        }
    }

    function previewImage(url) {
        const wrap = document.getElementById('imgPreview');
        if (!url) {
            wrap.innerHTML = '<span class="placeholder">🖼️</span>';
            return;
        }
        wrap.innerHTML = '<img src="' + url + '" alt="Preview" onerror="this.parentNode.innerHTML=\'<span class=placeholder>🖼️</span>\'">';
    }

    function filterProducts(keyword) { applyFilters(); }
    function filterByType(typeId) { applyFilters(); }
    function filterByStatus(status) { applyFilters(); }

    function applyFilters() {
        const kw     = document.querySelector('.topbar-right .dash-input').value.toLowerCase().trim();
        const selects = document.querySelectorAll('.toolbar-left select');
        const typeId = selects[0] ? selects[0].value : '';
        const status = selects[1] ? selects[1].value : '';

        const rows = document.querySelectorAll('#productTable tbody tr');
        let visible = 0;
        rows.forEach(row => {
            const name  = (row.getAttribute('data-name')   || '').toLowerCase();
            const rType = row.getAttribute('data-type')    || '';
            const rStat = row.getAttribute('data-status')  || '';
            const show  = (!kw || name.includes(kw))
                       && (!typeId || rType === typeId)
                       && (!status || rStat === status);
            row.style.display = show ? '' : 'none';
            if (show) visible++;
        });
        const el = document.getElementById('visibleCount');
        if (el) el.textContent = visible;
        const sel = document.getElementById('showCount');
        if (sel) sel.textContent = visible;
    }

    document.querySelectorAll('.alert').forEach(el => {
        setTimeout(() => {
            el.style.transition = 'opacity .5s';
            el.style.opacity = '0';
            setTimeout(() => el.remove(), 500);
        }, 4000);
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
