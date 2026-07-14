<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${shop.shopName} - POB Food</title>
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

        .topping-label {
            display: flex; align-items: center; justify-content: space-between;
            padding: 9px 12px; border-radius: 10px;
            border: 1.5px solid #e2e8f0; font-size: 13px;
            cursor: default; margin-bottom: 6px; opacity: 0.65;
        }

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
    <a href="${pageContext.request.contextPath}/user/home" class="nav-back">← Trang chủ</a>
    <div class="nav-right">
        <a href="${pageContext.request.contextPath}/user/donhang" class="nav-link">📦 Đơn hàng</a>
    </div>
</nav>

<!-- SHOP HERO -->
<div class="shop-hero">
    <div class="shop-hero-inner">
        <div class="shop-logo-box">
            <c:choose>
                <c:when test="${not empty shop.shopLogo}">
                    <img src="${shop.shopLogo}" alt="${shop.shopName}" onerror="this.parentNode.innerHTML='🍽️'">
                </c:when>
                <c:otherwise>🍽️</c:otherwise>
            </c:choose>
        </div>
        <div>
            <div class="shop-hero-name">${shop.shopName}</div>
            <c:if test="${not empty shop.shopDescription}">
                <div class="shop-hero-desc">${shop.shopDescription}</div>
            </c:if>
            <div class="shop-hero-meta">
                <c:if test="${not empty shop.shopAddress}"><span>📍 ${shop.shopAddress}</span></c:if>
                <c:if test="${not empty shop.shopPhone}"><span>📞 ${shop.shopPhone}</span></c:if>
            </div>
        </div>
    </div>
</div>

<!-- ALERT -->
<c:if test="${param.added eq '1'}">
    <div class="alert-wrap">
        <div class="alert alert-success">
            ✅ Đã thêm vào giỏ hàng!
            <a href="${pageContext.request.contextPath}/checkout?cartId=${param.cartId}">Thanh toán ngay →</a>
        </div>
    </div>
</c:if>

<!-- CATEGORY TABS -->
<c:if test="${not empty categories}">
    <div class="cat-wrap">
        <div class="cat-scroll">
            <button class="cat-pill active" onclick="filterCategory('all', this)">Tất cả</button>
            <c:forEach var="cat" items="${categories}">
                <button class="cat-pill" onclick="filterCategory('${cat.id}', this)">${cat.categoryName}</button>
            </c:forEach>
        </div>
    </div>
</c:if>

<!-- PRODUCTS -->
<div class="products-wrap">
    <c:choose>
        <c:when test="${empty products}">
            <div class="empty-state">
                <div class="empty-icon">🍽️</div>
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
                                    <img src="${p.imageUrl}" alt="${p.productName}" onerror="this.parentNode.innerHTML='🍜'">
                                </c:when>
                                <c:otherwise>🍜</c:otherwise>
                            </c:choose>
                        </div>
                        <div class="product-body">
                            <div class="product-name">${p.productName}</div>
                            <c:if test="${not empty p.description}">
                                <div class="product-desc">${p.description}</div>
                            </c:if>
                            <div class="product-price">
                                <c:choose>
                                    <c:when test="${not empty p.sizes}">từ <fmt:formatNumber value="${p.sizes[0].price}" type="number" groupingUsed="true"/>đ</c:when>
                                    <c:otherwise><fmt:formatNumber value="${p.price}" type="number" groupingUsed="true"/>đ</c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <button class="btn-add-cart"
                                onclick="openModal(${p.id}, '${fn:escapeXml(p.productName)}', ${shop.id},
                                    [<c:forEach var="s" items="${p.sizes}" varStatus="st">{id:${s.id},name:'${fn:escapeXml(s.sizeName)}',price:${s.price}}<c:if test="${!st.last}">,</c:if></c:forEach>])">
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

            <c:if test="${not empty toppings}">
                <div style="margin-bottom:16px;">
                    <div class="section-label">Topping (tham khảo)</div>
                    <c:forEach var="t" items="${toppings}">
                        <div class="topping-label">
                            <span>${t.toppingName}</span>
                            <span style="font-weight:700;">+<fmt:formatNumber value="${t.price}" type="number" groupingUsed="true"/>đ</span>
                        </div>
                    </c:forEach>
                    <p style="font-size:11.5px;color:#94a3b8;margin-top:4px;">* Liên hệ shop để chọn topping khi đặt hàng</p>
                </div>
            </c:if>

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
        <span class="cart-bar-text">🛒 Đã có món trong giỏ</span>
        <a href="${pageContext.request.contextPath}/checkout?cartId=${param.cartId}" class="cart-bar-btn">Thanh toán →</a>
    </div>
</c:if>

<script>
    var currentSizes = [];
    var selectedSizePrice = 0;
    var qty = 1;

    function openModal(productId, productName, shopId, sizes) {
        document.getElementById('modalProductId').value = productId;
        document.getElementById('modalTitle').textContent = productName;
        currentSizes = sizes;
        qty = 1;
        document.getElementById('qtyDisplay').textContent = 1;
        document.getElementById('qtyInput').value = 1;

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

    function updateTotal() {
        var total = selectedSizePrice * qty;
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
        var ss = document.getElementById('sizeSection');
        if (ss && ss.style.display !== 'none') {
            var checked = document.querySelector('input[name="sizeId"]:checked');
            if (!checked) { e.preventDefault(); alert('Vui lòng chọn size!'); }
        }
    });
</script>
</body>
</html>
