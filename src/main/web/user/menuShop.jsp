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
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        * { font-family: 'Inter', sans-serif; }

        .navbar {
            background: #fff;
            border-bottom: 1px solid #e5e7eb;
            box-shadow: 0 1px 4px rgba(0,0,0,.06);
            position: sticky; top: 0; z-index: 50;
        }

        .shop-hero {
            background: linear-gradient(135deg, #273155 0%, #3d4f7c 100%);
            padding: 32px 24px 28px;
        }

        .cat-pill {
            padding: 6px 16px;
            border-radius: 99px;
            font-size: 13px;
            font-weight: 600;
            border: 1.5px solid #e5e7eb;
            background: #fff;
            color: #64748b;
            cursor: pointer;
            white-space: nowrap;
            transition: all .15s;
        }
        .cat-pill.active, .cat-pill:hover {
            background: #273155;
            color: #fff;
            border-color: #273155;
        }

        .product-card {
            background: #fff;
            border-radius: 16px;
            border: 1px solid #f0f0f0;
            box-shadow: 0 2px 8px rgba(0,0,0,.05);
            overflow: hidden;
            display: flex;
            flex-direction: column;
            transition: box-shadow .18s, transform .18s;
        }
        .product-card:hover {
            box-shadow: 0 6px 20px rgba(39,49,85,.12);
            transform: translateY(-2px);
        }

        .product-img {
            height: 160px;
            background: linear-gradient(135deg,#f8f9ff,#eef0fa);
            display: flex; align-items: center; justify-content: center;
            font-size: 48px;
            overflow: hidden;
        }
        .product-img img { width:100%; height:100%; object-fit:cover; }

        .product-body { padding: 14px; flex: 1; display: flex; flex-direction: column; gap: 4px; }
        .product-name { font-size: 14px; font-weight: 700; color: #1e293b; line-height: 1.3; }
        .product-desc { font-size: 12px; color: #94a3b8;
            display: -webkit-box; -webkit-line-clamp: 2;
            -webkit-box-orient: vertical; overflow: hidden; }
        .product-price { font-size: 15px; font-weight: 800; color: #273155; margin-top: auto; padding-top: 8px; }

        .btn-add {
            margin: 0 14px 14px;
            padding: 9px;
            border-radius: 10px;
            background: linear-gradient(135deg, #273155, #3d4f7c);
            color: #fff;
            font-size: 13px;
            font-weight: 600;
            text-align: center;
            cursor: pointer;
            border: none;
            transition: opacity .15s;
        }
        .btn-add:hover { opacity: .85; }

        /* Modal */
        .modal-overlay {
            position: fixed; inset: 0; background: rgba(0,0,0,.45);
            display: flex; align-items: flex-end; justify-content: center;
            z-index: 200; opacity: 0; pointer-events: none;
            transition: opacity .2s;
        }
        .modal-overlay.open { opacity: 1; pointer-events: all; }
        .modal-box {
            background: #fff; border-radius: 20px 20px 0 0;
            padding: 24px; width: 100%; max-width: 480px;
            transform: translateY(40px);
            transition: transform .2s;
            max-height: 90vh; overflow-y: auto;
        }
        .modal-overlay.open .modal-box { transform: translateY(0); }

        .size-radio { display: none; }
        .size-label {
            display: inline-flex; align-items: center; gap: 6px;
            padding: 6px 14px; border-radius: 8px;
            border: 1.5px solid #e5e7eb; font-size: 13px;
            font-weight: 500; cursor: pointer; transition: all .12s;
        }
        .size-radio:checked + .size-label {
            background: #273155; color: #fff; border-color: #273155;
        }

        .topping-check { display: none; }
        .topping-label {
            display: flex; align-items: center; justify-content: space-between;
            padding: 8px 12px; border-radius: 8px;
            border: 1.5px solid #e5e7eb; font-size: 13px;
            cursor: pointer; transition: all .12s; margin-bottom: 6px;
        }
        .topping-check:checked + .topping-label {
            background: #eef0fa; border-color: #273155; color: #273155; font-weight: 600;
        }

        .cart-bar {
            position: fixed; bottom: 0; left: 0; right: 0;
            background: #273155; color: #fff;
            padding: 14px 20px;
            display: flex; align-items: center; justify-content: space-between;
            z-index: 100; transform: translateY(100%);
            transition: transform .25s;
        }
        .cart-bar.visible { transform: translateY(0); }
    </style>
</head>
<body class="bg-gray-50 min-h-screen pb-20">

<!-- NAVBAR -->
<nav class="navbar px-5 py-3 flex items-center gap-3">
    <a href="${pageContext.request.contextPath}/user/home"
       class="flex items-center gap-1 text-gray-500 hover:text-gray-800 text-sm font-medium">
        ← Trang chủ
    </a>
    <div class="ml-auto flex items-center gap-4">
        <a href="${pageContext.request.contextPath}/user/donhang"
           class="text-sm font-medium text-gray-600 hover:text-indigo-700">📦 Đơn hàng</a>
    </div>
</nav>

<!-- SHOP HERO -->
<div class="shop-hero">
    <div class="max-w-4xl mx-auto flex items-center gap-5">
        <div class="w-20 h-20 rounded-2xl overflow-hidden bg-white flex-shrink-0 flex items-center justify-center text-4xl shadow">
            <c:choose>
                <c:when test="${not empty shop.shopLogo}">
                    <img src="${shop.shopLogo}" alt="${shop.shopName}"
                         style="width:100%;height:100%;object-fit:cover;"
                         onerror="this.parentNode.innerHTML='🍽️'">
                </c:when>
                <c:otherwise>🍽️</c:otherwise>
            </c:choose>
        </div>
        <div>
            <h1 class="text-2xl font-extrabold text-white">${shop.shopName}</h1>
            <c:if test="${not empty shop.shopDescription}">
                <p class="text-indigo-200 text-sm mt-1">${shop.shopDescription}</p>
            </c:if>
            <div class="flex flex-wrap gap-3 mt-2">
                <c:if test="${not empty shop.shopAddress}">
                    <span class="text-indigo-300 text-xs">📍 ${shop.shopAddress}</span>
                </c:if>
                <c:if test="${not empty shop.shopPhone}">
                    <span class="text-indigo-300 text-xs">📞 ${shop.shopPhone}</span>
                </c:if>
            </div>
        </div>
    </div>
</div>

<!-- Thông báo -->
<div class="max-w-4xl mx-auto px-4">
    <c:if test="${param.added eq '1'}">
        <div class="bg-green-50 border border-green-200 text-green-700 rounded-xl px-4 py-3 mt-4 text-sm font-medium">
            ✅ Đã thêm vào giỏ hàng!
            <a href="${pageContext.request.contextPath}/checkout?cartId=${param.cartId}"
               class="ml-2 underline font-bold">Thanh toán ngay →</a>
        </div>
    </c:if>
</div>

<!-- CATEGORY TABS -->
<c:if test="${not empty categories}">
    <div class="max-w-4xl mx-auto px-4 mt-5">
        <div class="flex gap-2 overflow-x-auto pb-2 scrollbar-hide">
            <button class="cat-pill active" onclick="filterCategory('all', this)">Tất cả</button>
            <c:forEach var="cat" items="${categories}">
                <button class="cat-pill" onclick="filterCategory('${cat.id}', this)">${cat.categoryName}</button>
            </c:forEach>
        </div>
    </div>
</c:if>

<!-- PRODUCTS -->
<div class="max-w-4xl mx-auto px-4 py-5">
    <c:choose>
        <c:when test="${empty products}">
            <div class="text-center py-16 text-gray-400">
                <div class="text-5xl mb-3">🍽️</div>
                <p class="font-semibold">Quán chưa có sản phẩm nào</p>
            </div>
        </c:when>
        <c:otherwise>
            <div class="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-4 gap-4" id="productGrid">
                <c:forEach var="p" items="${products}">
                    <div class="product-card" data-cat="${p.categoryId}">
                        <div class="product-img">
                            <c:choose>
                                <c:when test="${not empty p.imageUrl}">
                                    <img src="${p.imageUrl}" alt="${p.productName}"
                                         onerror="this.parentNode.innerHTML='🍜'">
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
                                    <c:when test="${not empty p.sizes}">
                                        từ <fmt:formatNumber value="${p.sizes[0].price}" type="number" groupingUsed="true"/>đ
                                    </c:when>
                                    <c:otherwise>
                                        <fmt:formatNumber value="${p.price}" type="number" groupingUsed="true"/>đ
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <button class="btn-add"
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

<!-- MODAL THÊM VÀO GIỎ -->
<div class="modal-overlay" id="modalOverlay" onclick="closeModalOnBg(event)">
    <div class="modal-box">
        <div class="flex items-center justify-between mb-4">
            <h3 class="text-base font-bold text-gray-800" id="modalTitle">Chọn tùy chọn</h3>
            <button onclick="closeModal()" class="text-gray-400 hover:text-gray-700 text-xl font-bold leading-none">×</button>
        </div>

        <form action="${pageContext.request.contextPath}/user/add-to-cart" method="post" id="addToCartForm">
            <input type="hidden" name="productId" id="modalProductId">
            <input type="hidden" name="shopId" value="${shop.id}">

            <!-- Chọn size -->
            <div id="sizeSection">
                <div class="text-sm font-semibold text-gray-700 mb-2">Chọn size <span class="text-red-500">*</span></div>
                <div class="flex flex-wrap gap-2" id="sizeOptions"></div>
            </div>

            <!-- Topping (hiển thị thông tin, không lưu DB vì model chưa hỗ trợ) -->
            <c:if test="${not empty toppings}">
                <div class="mt-4">
                    <div class="text-sm font-semibold text-gray-700 mb-2">Topping (tham khảo)</div>
                    <c:forEach var="t" items="${toppings}">
                        <div class="topping-label" style="cursor:default; opacity:.7;">
                            <span>${t.toppingName}</span>
                            <span class="font-semibold">+<fmt:formatNumber value="${t.price}" type="number" groupingUsed="true"/>đ</span>
                        </div>
                    </c:forEach>
                    <p class="text-xs text-gray-400 mt-1">* Liên hệ shop để chọn topping khi đặt hàng</p>
                </div>
            </c:if>

            <!-- Số lượng -->
            <div class="mt-4">
                <div class="text-sm font-semibold text-gray-700 mb-2">Số lượng</div>
                <div class="flex items-center gap-3">
                    <button type="button" onclick="changeQty(-1)"
                            class="w-9 h-9 rounded-lg border border-gray-200 text-lg font-bold flex items-center justify-center hover:bg-gray-100">−</button>
                    <span id="qtyDisplay" class="text-base font-bold w-6 text-center">1</span>
                    <button type="button" onclick="changeQty(1)"
                            class="w-9 h-9 rounded-lg border border-gray-200 text-lg font-bold flex items-center justify-center hover:bg-gray-100">+</button>
                    <input type="hidden" name="quantity" id="qtyInput" value="1">
                </div>
            </div>

            <!-- Tổng giá -->
            <div class="mt-4 bg-gray-50 rounded-xl px-4 py-3 flex justify-between items-center">
                <span class="text-sm text-gray-600">Tạm tính</span>
                <span class="font-extrabold text-gray-800" id="totalPrice">—</span>
            </div>

            <button type="submit" id="submitBtn"
                    class="mt-4 w-full py-3 rounded-xl font-bold text-white text-sm"
                    style="background: linear-gradient(135deg,#273155,#3d4f7c);">
                Thêm vào giỏ hàng
            </button>
        </form>
    </div>
</div>

<!-- CART BAR (hiện sau khi thêm) -->
<c:if test="${param.added eq '1'}">
    <div class="cart-bar visible" id="cartBar">
        <span class="text-sm font-semibold">🛒 Đã có món trong giỏ</span>
        <a href="${pageContext.request.contextPath}/checkout?cartId=${param.cartId}"
           class="bg-white text-gray-800 text-sm font-bold px-4 py-2 rounded-lg">
            Thanh toán →
        </a>
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
                if (i === 0) {
                    input.checked = true;
                    selectedSizePrice = s.price;
                }
                input.addEventListener('change', function() {
                    selectedSizePrice = s.price;
                    updateTotal();
                });
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

    function closeModal() {
        document.getElementById('modalOverlay').classList.remove('open');
    }

    function closeModalOnBg(e) {
        if (e.target === document.getElementById('modalOverlay')) closeModal();
    }

    function changeQty(delta) {
        qty = Math.max(1, qty + delta);
        document.getElementById('qtyDisplay').textContent = qty;
        document.getElementById('qtyInput').value = qty;
        updateTotal();
    }

    function updateTotal() {
        var total = selectedSizePrice * qty;
        document.getElementById('totalPrice').textContent =
            total > 0 ? total.toLocaleString('vi-VN') + 'đ' : '—';
    }

    function filterCategory(catId, btn) {
        document.querySelectorAll('.cat-pill').forEach(function(p) { p.classList.remove('active'); });
        btn.classList.add('active');

        document.querySelectorAll('#productGrid .product-card').forEach(function(card) {
            if (catId === 'all' || card.dataset.cat === catId) {
                card.style.display = '';
            } else {
                card.style.display = 'none';
            }
        });
    }

    document.getElementById('addToCartForm').addEventListener('submit', function(e) {
        var sizeSection = document.getElementById('sizeSection');
        if (sizeSection.style.display !== 'none') {
            var checked = document.querySelector('input[name="sizeId"]:checked');
            if (!checked) {
                e.preventDefault();
                alert('Vui lòng chọn size!');
            }
        }
    });
</script>
</body>
</html>
