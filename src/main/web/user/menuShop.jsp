<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><c:out value="${shop.shopName}"/> - POB Food</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Inter', -apple-system, sans-serif; background: #f0f4f8; min-height: 100vh; padding-bottom: 80px; }

        /* NAVBAR */
        .navbar { background: #fff; border-bottom: 1px solid #e9edf2; box-shadow: 0 1px 6px rgba(26,32,53,0.06); padding: 0 24px; height: 56px; display: flex; align-items: center; gap: 14px; position: sticky; top: 0; z-index: 50; }
        .nav-back { display: flex; align-items: center; gap: 5px; font-size: 13.5px; font-weight: 600; color: #64748b; text-decoration: none; transition: color 0.2s; }
        .nav-back:hover { color: #10b981; }
        .nav-right { margin-left: auto; }
        .nav-link  { font-size: 13px; font-weight: 500; color: #64748b; text-decoration: none; transition: color 0.2s; }
        .nav-link:hover { color: #10b981; }

        /* SHOP HERO */
        .shop-hero { background: linear-gradient(140deg, #1a2035 0%, #0f1624 100%); padding: 28px 24px 24px; position: relative; overflow: hidden; }
        .shop-hero::before { content: ''; position: absolute; top: -60px; right: -60px; width: 260px; height: 260px; border-radius: 50%; background: radial-gradient(circle, rgba(16,185,129,0.12) 0%, transparent 70%); }
        .shop-hero-inner { max-width: 800px; margin: 0 auto; display: flex; align-items: center; gap: 18px; position: relative; z-index: 1; }
        .shop-logo-box { width: 76px; height: 76px; border-radius: 18px; overflow: hidden; background: #fff; flex-shrink: 0; display: flex; align-items: center; justify-content: center; font-size: 36px; box-shadow: 0 4px 16px rgba(0,0,0,0.2); }
        .shop-logo-box img { width: 100%; height: 100%; object-fit: cover; }
        .shop-hero-name { font-size: 22px; font-weight: 800; color: #fff; letter-spacing: -0.01em; margin-bottom: 4px; }
        .shop-hero-desc { font-size: 13px; color: rgba(255,255,255,0.5); margin-bottom: 8px; }
        .shop-hero-meta { display: flex; flex-wrap: wrap; gap: 12px; }
        .shop-hero-meta span { font-size: 12px; color: rgba(255,255,255,0.4); display: flex; align-items: center; gap: 4px; }

        /* ALERT */
        .alert-wrap { max-width: 800px; margin: 0 auto; padding: 0 20px; }
        .alert { display: flex; align-items: center; gap: 10px; border-radius: 12px; padding: 13px 16px; font-size: 13px; font-weight: 500; margin-top: 14px; }
        .alert-success { background: #f0fdf4; border: 1px solid #bbf7d0; color: #16a34a; }
        .alert a { color: #059669; font-weight: 700; text-decoration: none; margin-left: 4px; }

        /* CATEGORY TABS */
        .cat-wrap { max-width: 800px; margin: 0 auto; padding: 16px 20px 4px; }
        .cat-scroll { display: flex; gap: 8px; overflow-x: auto; padding-bottom: 4px; }
        .cat-scroll::-webkit-scrollbar { display: none; }
        .cat-pill {
            padding: 7px 18px; border-radius: 99px; font-size: 13px; font-weight: 600;
            border: 1.5px solid #e2e8f0; background: #fff; color: #64748b;
            cursor: pointer; white-space: nowrap; transition: all 0.15s; font-family: inherit;
        }
        .cat-pill.active, .cat-pill:hover { background: #1a2035; color: #fff; border-color: #1a2035; }
        .cat-pill.active { background: linear-gradient(135deg,#10b981,#059669); border-color: transparent; }

        /* PRODUCTS */
        .products-wrap { max-width: 800px; margin: 0 auto; padding: 16px 20px; }
        .product-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(180px, 1fr)); gap: 14px; }

        .product-card {
            background: #fff; border-radius: 16px; border: 1px solid #eef0f4;
            box-shadow: 0 2px 8px rgba(26,32,53,0.06);
            overflow: hidden; display: flex; flex-direction: column;
            transition: transform 0.18s, box-shadow 0.18s;
        }
        .product-card:hover { transform: translateY(-3px); box-shadow: 0 8px 24px rgba(26,32,53,0.12); }

        .product-img { height: 150px; background: linear-gradient(135deg,#f0f4f8,#e8ecf2); display: flex; align-items: center; justify-content: center; font-size: 48px; overflow: hidden; }
        .product-img img { width: 100%; height: 100%; object-fit: cover; }

        .product-body { padding: 13px; flex: 1; display: flex; flex-direction: column; gap: 4px; }
        .product-name  { font-size: 13.5px; font-weight: 700; color: #0f172a; line-height: 1.3; }
        .product-desc  { font-size: 12px; color: #94a3b8; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; }
        .product-price { font-size: 14px; font-weight: 800; color: #10b981; margin-top: auto; padding-top: 8px; }

        .btn-add-cart {
            margin: 0 13px 13px; padding: 9px;
            border-radius: 10px; background: linear-gradient(135deg,#10b981,#059669);
            color: #fff; font-size: 13px; font-weight: 600;
            text-align: center; cursor: pointer; border: none; font-family: inherit;
            transition: opacity 0.15s; box-shadow: 0 3px 10px rgba(16,185,129,0.25);
        }
        .btn-add-cart:hover { opacity: 0.88; }

        /* MODAL */
        .modal-overlay {
            position: fixed; inset: 0; background: rgba(15,22,36,0.5);
            display: flex; align-items: flex-end; justify-content: center;
            z-index: 200; opacity: 0; pointer-events: none; transition: opacity 0.2s;
        }
        .modal-overlay.open { opacity: 1; pointer-events: all; }
        .modal-box {
            background: #fff; border-radius: 24px 24px 0 0;
            padding: 24px; width: 100%; max-width: 480px;
            transform: translateY(50px); transition: transform 0.25s;
            max-height: 90vh; overflow-y: auto;
        }
        .modal-overlay.open .modal-box { transform: translateY(0); }

        .modal-header { display: flex; align-items: center; justify-content: space-between; margin-bottom: 18px; }
        .modal-title  { font-size: 16px; font-weight: 800; color: #0f172a; }
        .modal-close  { background: none; border: none; font-size: 22px; color: #94a3b8; cursor: pointer; font-weight: 700; line-height: 1; padding: 2px; }
        .modal-close:hover { color: #0f172a; }

        .section-label { font-size: 12.5px; font-weight: 700; color: #475569; text-transform: uppercase; letter-spacing: 0.05em; margin-bottom: 10px; }
        .req { color: #dc2626; }

        .size-radio { display: none; }
        .size-label {
            display: inline-flex; align-items: center; gap: 6px;
            padding: 7px 16px; border-radius: 10px;
            border: 1.5px solid #e2e8f0; font-size: 13px;
            font-weight: 500; cursor: pointer; transition: all 0.12s; font-family: inherit;
        }
        .size-radio:checked + .size-label { background: #1a2035; color: #fff; border-color: #1a2035; }

        .topping-row {
            display: flex; align-items: center; justify-content: space-between;
            padding: 9px 12px; border-radius: 10px;
            border: 1.5px solid #e2e8f0; font-size: 13px;
            margin-bottom: 6px; transition: border-color 0.12s, background 0.12s;
        }
        .topping-row.active { border-color: #10b981; background: #f0fdf4; }
        .topping-name { flex: 1; color: #0f172a; font-weight: 500; }
        .topping-price { font-size: 12px; color: #10b981; font-weight: 700; margin-right: 10px; }
        .topping-qty-wrap { display: flex; align-items: center; gap: 6px; }
        .t-btn {
            width: 26px; height: 26px; border-radius: 8px;
            border: 1.5px solid #e2e8f0; background: #f8fafc;
            font-size: 16px; font-weight: 700; line-height: 1;
            display: flex; align-items: center; justify-content: center;
            cursor: pointer; color: #374151; transition: all 0.12s;
        }
        .t-btn:hover { border-color: #10b981; color: #10b981; background: #f0fdf4; }
        .t-qty { font-size: 13px; font-weight: 700; color: #0f172a; min-width: 16px; text-align: center; }

        .qty-row { display: flex; align-items: center; gap: 12px; }
        .qty-btn { width: 36px; height: 36px; border-radius: 10px; border: 1.5px solid #e2e8f0; font-size: 20px; font-weight: 600; display: flex; align-items: center; justify-content: center; background: #f8fafc; cursor: pointer; transition: all 0.12s; color: #374151; }
        .qty-btn:hover { border-color: #10b981; color: #10b981; background: #f0fdf4; }
        .qty-display { font-size: 16px; font-weight: 800; color: #0f172a; min-width: 24px; text-align: center; }

        .price-summary { background: #f8fafc; border-radius: 14px; padding: 14px 16px; display: flex; justify-content: space-between; align-items: center; margin-top: 16px; }
        .price-label { font-size: 13px; color: #64748b; }
        .price-total { font-size: 18px; font-weight: 800; color: #10b981; }

        .btn-add-to-cart { width: 100%; margin-top: 14px; padding: 14px; border-radius: 14px; background: linear-gradient(135deg,#10b981,#059669); color: #fff; font-size: 14px; font-weight: 700; border: none; cursor: pointer; font-family: inherit; box-shadow: 0 4px 16px rgba(16,185,129,0.35); transition: all 0.2s; }
        .btn-add-to-cart:hover { opacity: 0.9; transform: translateY(-1px); }

        /* EMPTY */
        .empty-state { text-align: center; padding: 64px 24px; color: #94a3b8; }
        .empty-icon  { font-size: 52px; margin-bottom: 12px; }
        .empty-title { font-size: 16px; font-weight: 600; color: #64748b; }

        /* CART BAR */
        .cart-bar {
            position: fixed; bottom: 0; left: 0; right: 0;
            background: linear-gradient(135deg,#1a2035,#0f1624);
            color: #fff; padding: 14px 24px;
            display: flex; align-items: center; justify-content: space-between;
            z-index: 100; transform: translateY(100%); transition: transform 0.25s;
            box-shadow: 0 -4px 20px rgba(26,32,53,0.25);
        }
        .cart-bar.visible { transform: translateY(0); }
        .cart-bar-text { font-size: 13.5px; font-weight: 600; }
        .cart-bar-btn { background: #10b981; color: #fff; font-size: 13px; font-weight: 700; padding: 9px 20px; border-radius: 10px; text-decoration: none; transition: opacity 0.15s; }
        .cart-bar-btn:hover { opacity: 0.88; }

        @media (max-width: 600px) {
            .product-grid { grid-template-columns: 1fr 1fr; gap: 10px; }
            .shop-hero-name { font-size: 18px; }
        }
    </style>
</head>
<body>

<!-- NAVBAR -->
<nav class="navbar">
    <a href="${pageContext.request.contextPath}/user/home" class="nav-back">
        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
        Trang chủ
    </a>
    <div class="nav-right" style="display:flex;align-items:center;gap:16px;">
        <a href="${pageContext.request.contextPath}/user/cart" class="nav-link" style="display:flex;align-items:center;gap:5px;">
            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="9" cy="21" r="1"/><circle cx="20" cy="21" r="1"/><path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"/></svg>
            Giỏ hàng
        </a>
        <a href="${pageContext.request.contextPath}/user/donhang" class="nav-link" style="display:flex;align-items:center;gap:5px;">
            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"/><polyline points="3.27 6.96 12 12.01 20.73 6.96"/><line x1="12" y1="22.08" x2="12" y2="12"/></svg>
            Đơn hàng
        </a>
    </div>
</nav>

<!-- SHOP HERO -->
<div class="shop-hero">
    <div class="shop-hero-inner">
        <div class="shop-logo-box">
            <c:choose>
                <c:when test="${not empty shop.shopLogo}">
                    <img src="${fn:escapeXml(shop.shopLogo)}" alt="${fn:escapeXml(shop.shopName)}" onerror="this.style.visibility='hidden'">
                </c:when>
                <c:otherwise><svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="#94a3b8" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><path d="M3 2v7c0 1.1.9 2 2 2h4a2 2 0 0 0 2-2V2M7 2v20M21 15V2a5 5 0 0 0-5 5v6c0 1.1.9 2 2 2h3zM21 15v7"/></svg></c:otherwise>
            </c:choose>
        </div>
        <div>
            <div class="shop-hero-name"><c:out value="${shop.shopName}"/></div>
            <c:if test="${not empty shop.shopDescription}">
                <div class="shop-hero-desc"><c:out value="${shop.shopDescription}"/></div>
            </c:if>
            <div class="shop-hero-meta">
                <c:if test="${not empty shop.shopAddress}"><span><svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="flex-shrink:0;"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/></svg> <c:out value="${shop.shopAddress}"/></span></c:if>
                <c:if test="${not empty shop.shopPhone}"><span><svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="flex-shrink:0;"><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72c.127.96.361 1.903.7 2.81a2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45c.907.339 1.85.573 2.81.7A2 2 0 0 1 22 16.92z"/></svg> <c:out value="${shop.shopPhone}"/></span></c:if>
            </div>
        </div>
    </div>
</div>

<!-- ALERT -->
<c:if test="${param.added eq '1'}">
    <div class="alert-wrap">
        <div class="alert alert-success">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
            Đã thêm vào giỏ hàng!
            <a href="${pageContext.request.contextPath}/checkout?cartId=${fn:escapeXml(param.cartId)}">Thanh toán ngay →</a>
        </div>
    </div>
</c:if>

<!-- CATEGORY TABS -->
<c:if test="${not empty categories}">
    <div class="cat-wrap">
        <div class="cat-scroll">
            <button class="cat-pill active" onclick="filterCategory('all', this)">Tất cả</button>
            <c:forEach var="cat" items="${categories}">
                <button class="cat-pill" data-cat-id="${cat.id}" onclick="filterCategory(this.dataset.catId, this)"><c:out value="${cat.categoryName}"/></button>
            </c:forEach>
        </div>
    </div>
</c:if>

<!-- PRODUCTS -->
<div class="products-wrap">
    <c:choose>
        <c:when test="${empty products}">
            <div class="empty-state">
                <div class="empty-icon"><svg width="52" height="52" viewBox="0 0 24 24" fill="none" stroke="#cbd5e1" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" style="margin:0 auto;"><path d="M3 2v7c0 1.1.9 2 2 2h4a2 2 0 0 0 2-2V2M7 2v20M21 15V2a5 5 0 0 0-5 5v6c0 1.1.9 2 2 2h3zM21 15v7"/></svg></div>
                <div class="empty-title">Quán chưa có sản phẩm nào</div>
            </div>
        </c:when>
        <c:otherwise>
            <div class="product-grid" id="productGrid">
                <c:forEach var="p" items="${products}">
                    <div class="product-card" data-cat="${p.categoryId}">
                        <div class="product-img">
                            <c:choose>
                                <c:when test="${not empty p.imageUrl}">
                                    <img src="${fn:escapeXml(p.imageUrl)}" alt="${fn:escapeXml(p.productName)}" onerror="this.style.visibility='hidden'">
                                </c:when>
                                <c:otherwise><svg width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="#94a3b8" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><path d="M3 2v7c0 1.1.9 2 2 2h4a2 2 0 0 0 2-2V2M7 2v20M21 15V2a5 5 0 0 0-5 5v6c0 1.1.9 2 2 2h3zM21 15v7"/></svg></c:otherwise>
                            </c:choose>
                        </div>
                        <div class="product-body">
                            <div class="product-name"><c:out value="${p.productName}"/></div>
                            <c:if test="${not empty p.description}">
                                <div class="product-desc"><c:out value="${p.description}"/></div>
                            </c:if>
                            <div class="product-price">
                                <c:choose>
                                    <c:when test="${not empty p.sizes}">từ <fmt:formatNumber value="${p.sizes[0].price}" type="number" groupingUsed="true"/>đ</c:when>
                                    <c:otherwise><fmt:formatNumber value="${p.price}" type="number" groupingUsed="true"/>đ</c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <button class="btn-add-cart"
                                data-product-id="${p.id}"
                                data-product-name="${fn:escapeXml(p.productName)}"
                                data-sizes='[<c:forEach var="s" items="${p.sizes}" varStatus="st">{"id":${s.id},"name":"${fn:escapeXml(s.sizeName)}","price":${s.price}}<c:if test="${!st.last}">,</c:if></c:forEach>]'
                                onclick="openProductModal(this)">
                            + Thêm vào giỏ
                        </button>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<!-- MODAL THÊM GIỎ -->
<div class="modal-overlay" id="modalOverlay" onclick="closeModalOnBg(event)">
    <div class="modal-box">
        <div class="modal-header">
            <span class="modal-title" id="modalTitle">Chọn tùy chọn</span>
            <button class="modal-close" onclick="closeModal()">×</button>
        </div>

        <form action="${pageContext.request.contextPath}/user/add-to-cart" method="post" id="addToCartForm">
            <input type="hidden" name="productId" id="modalProductId">
            <input type="hidden" name="shopId" value="${shop.id}">

            <div id="sizeSection" style="margin-bottom:16px;">
                <div class="section-label">Chọn size <span class="req">*</span></div>
                <div style="display:flex;flex-wrap:wrap;gap:8px;" id="sizeOptions"></div>
            </div>

            <div id="toppingSection" style="margin-bottom:16px;display:none;">
                <div class="section-label">Chọn topping</div>
                <div id="toppingOptions"></div>
            </div>

            <div style="margin-bottom:16px;">
                <div class="section-label">Số lượng</div>
                <div class="qty-row">
                    <button type="button" class="qty-btn" onclick="changeQty(-1)">−</button>
                    <span class="qty-display" id="qtyDisplay">1</span>
                    <button type="button" class="qty-btn" onclick="changeQty(1)">+</button>
                    <input type="hidden" name="quantity" id="qtyInput" value="1">
                </div>
            </div>

            <div class="price-summary">
                <span class="price-label">Tạm tính</span>
                <span class="price-total" id="totalPrice">—</span>
            </div>

            <button type="submit" id="submitBtn" class="btn-add-to-cart">Thêm vào giỏ hàng</button>
        </form>
    </div>
</div>

<!-- CART BAR -->
<c:if test="${param.added eq '1'}">
    <div class="cart-bar visible" id="cartBar">
        <span class="cart-bar-text" style="display:flex;align-items:center;gap:6px;">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="9" cy="21" r="1"/><circle cx="20" cy="21" r="1"/><path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"/></svg>
            Đã có món trong giỏ
        </span>
        <a href="${pageContext.request.contextPath}/user/cart" class="cart-bar-btn" style="margin-right:8px;">Xem giỏ hàng</a>
        <a href="${pageContext.request.contextPath}/checkout?cartId=${fn:escapeXml(param.cartId)}" class="cart-bar-btn">Thanh toán →</a>
    </div>
</c:if>

<script>
    var SHOP_TOPPINGS = [
        <c:forEach var="t" items="${toppings}" varStatus="st">
        {id: ${t.id}, name: "${fn:escapeXml(t.toppingName)}", price: ${t.price}}<c:if test="${!st.last}">,</c:if>
        </c:forEach>
    ];

    var currentSizes = [];
    var selectedSizePrice = 0;
    var qty = 1;

    function openProductModal(btn) {
        var productId   = btn.dataset.productId;
        var productName = btn.dataset.productName;
        var sizes       = JSON.parse(btn.dataset.sizes || '[]');
        document.getElementById('modalProductId').value = productId;
        document.getElementById('modalTitle').textContent = productName;
        currentSizes = sizes;
        qty = 1;
        document.getElementById('qtyDisplay').textContent = 1;
        document.getElementById('qtyInput').value = 1;

        // Sizes
        var sizeSection = document.getElementById('sizeSection');
        var sizeOptions = document.getElementById('sizeOptions');
        sizeOptions.innerHTML = '';
        if (sizes && sizes.length > 0) {
            sizeSection.style.display = 'block';
            sizes.forEach(function(s, i) {
                var id = 'size_' + s.id;
                var input = document.createElement('input');
                input.type = 'radio'; input.name = 'sizeId'; input.value = s.id;
                input.id = id; input.className = 'size-radio';
                if (i === 0) { input.checked = true; selectedSizePrice = s.price; }
                input.addEventListener('change', function() { selectedSizePrice = s.price; updateTotal(); });
                var label = document.createElement('label');
                label.htmlFor = id; label.className = 'size-label';
                label.textContent = s.name + ' (' + s.price.toLocaleString('vi-VN') + 'đ)';
                sizeOptions.appendChild(input);
                sizeOptions.appendChild(label);
            });
        } else {
            sizeSection.style.display = 'none';
            selectedSizePrice = 0;
        }

        // Toppings
        var toppingSection = document.getElementById('toppingSection');
        var toppingOptions = document.getElementById('toppingOptions');
        toppingOptions.innerHTML = '';
        if (SHOP_TOPPINGS && SHOP_TOPPINGS.length > 0) {
            toppingSection.style.display = 'block';
            SHOP_TOPPINGS.forEach(function(t) {
                var row = document.createElement('div');
                row.className = 'topping-row';
                row.dataset.toppingId = t.id;
                row.dataset.price = t.price;
                row.innerHTML =
                    '<span class="topping-name">' + t.name + '</span>' +
                    '<span class="topping-price">+' + t.price.toLocaleString('vi-VN') + 'đ</span>' +
                    '<div class="topping-qty-wrap">' +
                        '<button type="button" class="t-btn" onclick="changeToppingQty(this,-1)">−</button>' +
                        '<span class="t-qty">0</span>' +
                        '<button type="button" class="t-btn" onclick="changeToppingQty(this,1)">+</button>' +
                    '</div>';
                toppingOptions.appendChild(row);
            });
        } else {
            toppingSection.style.display = 'none';
        }

        updateTotal();
        document.getElementById('modalOverlay').classList.add('open');
    }

    function closeModal() { document.getElementById('modalOverlay').classList.remove('open'); }
    function closeModalOnBg(e) { if (e.target === document.getElementById('modalOverlay')) closeModal(); }

    function changeQty(delta) {
        qty = Math.max(1, qty + delta);
        document.getElementById('qtyDisplay').textContent = qty;
        document.getElementById('qtyInput').value = qty;
        updateTotal();
    }

    function changeToppingQty(btn, delta) {
        var row = btn.closest('.topping-row');
        var qtyEl = row.querySelector('.t-qty');
        var cur = parseInt(qtyEl.textContent) || 0;
        var next = Math.max(0, cur + delta);
        qtyEl.textContent = next;
        row.classList.toggle('active', next > 0);
        updateTotal();
    }

    function updateTotal() {
        var toppingTotal = 0;
        document.querySelectorAll('#toppingOptions .topping-row').forEach(function(row) {
            var q = parseInt(row.querySelector('.t-qty').textContent) || 0;
            if (q > 0) toppingTotal += parseFloat(row.dataset.price) * q;
        });
        var total = selectedSizePrice * qty + toppingTotal;
        document.getElementById('totalPrice').textContent = total > 0 ? total.toLocaleString('vi-VN') + 'đ' : '—';
    }

    function filterCategory(catId, btn) {
        document.querySelectorAll('.cat-pill').forEach(function(p) { p.classList.remove('active'); });
        btn.classList.add('active');
        document.querySelectorAll('#productGrid .product-card').forEach(function(card) {
            card.style.display = (catId === 'all' || card.dataset.cat === catId) ? '' : 'none';
        });
    }

    document.getElementById('addToCartForm').addEventListener('submit', function(e) {
        // Inject topping hidden inputs từ qty display
        document.querySelectorAll('input[name="toppingId"]').forEach(function(el) { el.remove(); });
        document.querySelectorAll('input[name="toppingQty"]').forEach(function(el) { el.remove(); });
        document.querySelectorAll('#toppingOptions .topping-row').forEach(function(row) {
            var q = parseInt(row.querySelector('.t-qty').textContent) || 0;
            if (q > 0) {
                var h1 = document.createElement('input'); h1.type='hidden'; h1.name='toppingId'; h1.value=row.dataset.toppingId;
                var h2 = document.createElement('input'); h2.type='hidden'; h2.name='toppingQty'; h2.value=q;
                document.getElementById('addToCartForm').appendChild(h1);
                document.getElementById('addToCartForm').appendChild(h2);
            }
        });

        var ss = document.getElementById('sizeSection');
        if (ss && ss.style.display !== 'none') {
            var checked = document.querySelector('input[name="sizeId"]:checked');
            if (!checked) { e.preventDefault(); alert('Vui lòng chọn size!'); }
        }
    });
</script>
</body>
</html>
