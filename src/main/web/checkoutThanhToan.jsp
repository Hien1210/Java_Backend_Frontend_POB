<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh toán</title>
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f0f2f5;
            color: #333;
        }

        nav {
            background: #2c3e50;
            padding: 0 32px;
            display: flex;
            align-items: center;
            height: 56px;
            gap: 8px;
        }
        nav a {
            color: #ecf0f1;
            text-decoration: none;
            padding: 8px 14px;
            border-radius: 4px;
            font-size: 14px;
        }
        nav a:hover, nav a.active { background: #3d5a73; }

        .container {
            max-width: 760px;
            margin: 32px auto;
            padding: 0 16px;
        }

        .page-header h1 { font-size: 22px; font-weight: 600; color: #2c3e50; margin-bottom: 20px; }

        .card {
            background: #fff;
            border-radius: 8px;
            box-shadow: 0 1px 4px rgba(0,0,0,.08);
            padding: 20px 24px;
            margin-bottom: 20px;
        }
        .card h2 { font-size: 16px; color: #2c3e50; margin-bottom: 14px; }

        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 10px 8px; text-align: left; font-size: 14px; border-bottom: 1px solid #eee; }
        thead th { color: #888; font-weight: 600; font-size: 13px; }
        td.num, th.num { text-align: right; }

        .shop-group { margin-bottom: 12px; }
        .shop-group .shop-name { font-weight: 600; color: #2980b9; margin: 12px 0 4px; }

        .totals { margin-top: 12px; text-align: right; font-size: 14px; }
        .totals .line { margin-bottom: 6px; }
        .totals .grand { font-size: 18px; font-weight: 700; color: #2c3e50; }

        .form-group { margin-bottom: 14px; }
        .form-group label { display: block; font-size: 13px; color: #555; margin-bottom: 4px; }
        .form-group input, .form-group select {
            width: 100%;
            padding: 9px 12px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
        }

        .btn {
            display: inline-block;
            padding: 10px 22px;
            border-radius: 5px;
            text-decoration: none;
            font-size: 14px;
            cursor: pointer;
            border: none;
        }
        .btn-primary { background: #27ae60; color: #fff; width: 100%; font-size: 16px; padding: 12px; }
        .btn-primary:hover { opacity: .9; }

        .alert { padding: 12px 16px; border-radius: 5px; margin-bottom: 16px; font-size: 14px; }
        .alert-error { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }

        .modal-overlay {
            position: fixed; inset: 0; background: rgba(15,22,36,0.55);
            display: flex; align-items: center; justify-content: center;
            z-index: 300; opacity: 0; pointer-events: none; transition: opacity 0.2s;
            padding: 20px;
        }
        .modal-overlay.open { opacity: 1; pointer-events: all; }
        .modal-box {
            background: #fff; border-radius: 12px;
            width: 100%; max-width: 480px; max-height: 90vh; overflow-y: auto;
            padding: 24px; box-shadow: 0 24px 70px rgba(15,22,36,0.22);
        }
        .modal-header-row { display: flex; align-items: center; justify-content: space-between; margin-bottom: 16px; }
        .modal-title-text { font-size: 16px; font-weight: 700; color: #2c3e50; }
        .modal-close-btn { background: none; border: none; cursor: pointer; font-size: 18px; color: #94a3b8; }
        .btn-secondary { background: #eef2f7; color: #2c3e50; }
    </style>
</head>
<body>

<nav>
    <a href="${pageContext.request.contextPath}/user/home">🏠 Trang chủ</a>
    <a href="${pageContext.request.contextPath}/cart">🛒 Giỏ hàng</a>
    <a href="${pageContext.request.contextPath}/checkout" class="active">💳 Thanh toán</a>
</nav>

<div class="container">
    <div class="page-header">
        <h1>💳 Xác nhận hóa đơn thanh toán</h1>
    </div>

    <c:if test="${not empty error}">
        <div class="alert alert-error">❌ ${error}</div>
    </c:if>

    <div class="card">
        <h2>Chi tiết hóa đơn (Giỏ hàng #${cart.id})</h2>
        <table>
            <thead>
                <tr>
                    <th>Sản phẩm</th>
                    <th>Size</th>
                    <th class="num">SL</th>
                    <th class="num">Đơn giá</th>
                    <th class="num">Thành tiền</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${lines}" var="line" varStatus="s">
                    <c:if test="${s.first or line.shopName ne lines[s.index - 1].shopName}">
                        <tr><td colspan="5" class="shop-name">🏪 ${line.shopName}</td></tr>
                    </c:if>
                    <tr>
                        <td>${line.productName}</td>
                        <td>${line.sizeName}</td>
                        <td class="num">${line.quantity}</td>
                        <td class="num"><fmt:formatNumber value="${line.unitPrice}" type="number"/> đ</td>
                        <td class="num"><fmt:formatNumber value="${line.lineTotal}" type="number"/> đ</td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

        <div class="totals">
            <div class="line">Tạm tính: <fmt:formatNumber value="${subtotal}" type="number"/> đ</div>
            <div class="grand">Tổng cộng (chưa gồm phí giao hàng nhập bên dưới)</div>
        </div>
    </div>

    <form method="post" action="${pageContext.request.contextPath}/checkout">
        <input type="hidden" name="cartId" value="${cart.id}">

        <div class="card">
            <h2>Thông tin nhận hàng</h2>

            <div class="form-group">
                <label>Tên người nhận</label>
                <input type="text" name="receiverName"
                    value="${fn:escapeXml(not empty param.receiverName ? param.receiverName : (not empty defaultAddress.receiverName ? defaultAddress.receiverName : account.fullName))}" required>
            </div>
            <div class="form-group">
                <label>Số điện thoại</label>
                <input type="text" name="receiverPhone"
                    value="${fn:escapeXml(not empty param.receiverPhone ? param.receiverPhone : (not empty defaultAddress.receiverPhone ? defaultAddress.receiverPhone : account.phone))}" required>
            </div>
            <div class="form-group">
                <label>Địa chỉ giao hàng</label>
                <input type="text" name="shippingAddress"
                    value="${fn:escapeXml(not empty param.shippingAddress ? param.shippingAddress : defaultAddress.address)}" required>
            </div>

            <input type="hidden" name="orderLocationX" id="mainOrderLat" value="${defaultAddress.locationX}">
            <input type="hidden" name="orderLocationY" id="mainOrderLng" value="${defaultAddress.locationY}">

            <div class="form-group">
                <c:choose>
                    <c:when test="${hasLocation}">
                        <button type="button" class="btn btn-secondary" onclick="openAddrModal()">✏️ Sửa địa chỉ (đã có vị trí trên bản đồ)</button>
                    </c:when>
                    <c:otherwise>
                        <button type="button" class="btn btn-secondary" onclick="openAddrModal()">➕ Thêm địa chỉ (chọn vị trí trên bản đồ)</button>
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="form-group">
                <label>Phương thức thanh toán</label>
                <select name="paymentMethod" required>
                    <option value="COD" ${param.paymentMethod eq 'COD' ? 'selected' : ''}>Thanh toán khi nhận hàng (COD)</option>
                    <option value="PAYOS" ${param.paymentMethod eq 'PAYOS' ? 'selected' : ''}>Thanh toán online qua PayOS (QR Code)</option>
                </select>
            </div>
            <div class="form-group">
                <label>Phí giao hàng (đ) — áp dụng cho mỗi shop trong đơn</label>
                <input type="number" step="1000" min="0" name="deliveryFee" value="${param.deliveryFee != null ? param.deliveryFee : 0}">
            </div>
        </div>

        <button type="submit" class="btn btn-primary">✅ Xác nhận thanh toán</button>
    </form>

    <div class="modal-overlay" id="addrModal" onclick="closeAddrOnBg(event)">
        <div class="modal-box">
            <div class="modal-header-row">
                <span class="modal-title-text">📍 Địa chỉ nhận hàng</span>
                <button type="button" class="modal-close-btn" onclick="closeAddrModal()">✕</button>
            </div>
            <form action="${pageContext.request.contextPath}/user/dia-chi" method="post" onsubmit="return validateAddrModalForm()">
                <input type="hidden" name="action" value="${hasLocation ? 'update' : 'create'}">
                <c:if test="${hasLocation}">
                    <input type="hidden" name="id" value="${defaultAddress.id}">
                </c:if>
                <input type="hidden" name="returnTo" value="checkout">
                <input type="hidden" name="cartId" value="${cart.id}">

                <div class="form-group">
                    <label>Nhãn địa chỉ</label>
                    <select name="label">
                        <option value="Nhà">🏠 Nhà</option>
                        <option value="Công ty">🏢 Công ty</option>
                        <option value="Trường học">🎓 Trường học</option>
                        <option value="Khác">📍 Khác</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>Địa chỉ đầy đủ</label>
                    <textarea name="fullAddress" id="addrFullAddress" rows="2" required><c:out value="${defaultAddress.fullAddress}" /></textarea>
                </div>
                <div class="form-group">
                    <label>Tên người nhận</label>
                    <input type="text" name="receiverName" value="${fn:escapeXml(defaultAddress.receiverName)}" required>
                </div>
                <div class="form-group">
                    <label>Số điện thoại</label>
                    <input type="text" name="receiverPhone" value="${fn:escapeXml(defaultAddress.receiverPhone)}" required>
                </div>
                <div class="form-group">
                    <button type="button" class="btn btn-secondary" onclick="toggleAddrMap()">📍 Chọn trên bản đồ</button>
                    <div id="addrMapWrapper" style="display:none; margin-top:10px;">
                        <div style="display:flex; gap:8px; margin-bottom:8px;">
                            <input type="text" id="addrMapSearchInput" placeholder="Tìm địa chỉ..." style="flex:1;padding:9px 12px;border:1px solid #ddd;border-radius:5px;">
                            <button type="button" id="addrMapSearchBtn" class="btn btn-secondary">Tìm</button>
                        </div>
                        <div id="addrMap" style="height:280px;border-radius:8px;overflow:hidden;"></div>
                    </div>
                    <input type="hidden" name="locationX" id="addrLat" value="${defaultAddress.locationX}">
                    <input type="hidden" name="locationY" id="addrLng" value="${defaultAddress.locationY}">
                </div>
                <c:if test="${!hasLocation}">
                    <label style="display:flex;align-items:center;gap:8px;font-size:13px;margin-bottom:14px;">
                        <input type="checkbox" name="isDefault" value="true" checked> Đặt làm địa chỉ mặc định
                    </label>
                </c:if>
                <button type="submit" class="btn btn-primary">Lưu địa chỉ</button>
            </form>
        </div>
    </div>
</div>

<script>
    function openAddrModal() {
        document.getElementById('addrModal').classList.add('open');
        document.body.style.overflow = 'hidden';
    }
    function closeAddrModal() {
        document.getElementById('addrModal').classList.remove('open');
        document.body.style.overflow = '';
    }
    function closeAddrOnBg(e) {
        if (e.target === document.getElementById('addrModal')) closeAddrModal();
    }

    function validateAddrModalForm() {
        var lat = document.getElementById('addrLat').value;
        var lng = document.getElementById('addrLng').value;
        if (!lat || !lng) {
            alert('Vui lòng chọn vị trí trên bản đồ trước khi lưu.');
            return false;
        }
        return true;
    }

    var addrMapInstance = null;
    var addrMapMarker = null;

    function toggleAddrMap() {
        document.getElementById('addrMapWrapper').style.display = 'block';
        var presetLat = document.getElementById('addrLat').value || null;
        var presetLng = document.getElementById('addrLng').value || null;
        setTimeout(function () { initAddrMap(presetLat, presetLng); }, 50);
    }

    function initAddrMap(presetLat, presetLng) {
        if (addrMapInstance) {
            addrMapInstance.invalidateSize();
            return;
        }

        var defaultLat = 21.0285, defaultLng = 105.8542;
        var startLat = presetLat ? parseFloat(presetLat) : defaultLat;
        var startLng = presetLng ? parseFloat(presetLng) : defaultLng;

        addrMapInstance = L.map('addrMap').setView([startLat, startLng], 15);

        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
            attribution: '&copy; OpenStreetMap contributors',
            maxZoom: 19
        }).addTo(addrMapInstance);

        function updateCoords(lat, lng) {
            document.getElementById('addrLat').value = lat;
            document.getElementById('addrLng').value = lng;
            document.getElementById('mainOrderLat').value = lat;
            document.getElementById('mainOrderLng').value = lng;
        }

        function reverseGeocode(lat, lng) {
            fetch('https://nominatim.openstreetmap.org/reverse?format=json&lat=' + lat + '&lon=' + lng)
                .then(function (res) { return res.json(); })
                .then(function (data) {
                    if (data && data.display_name) {
                        document.getElementById('addrFullAddress').value = data.display_name;
                    }
                })
                .catch(function () { console.warn('Khong the lay dia chi tu toa do'); });
        }

        var addrReverseGeocodeTimer = null;

        function reverseGeocodeDebounced(lat, lng) {
            clearTimeout(addrReverseGeocodeTimer);
            addrReverseGeocodeTimer = setTimeout(function () {
                reverseGeocode(lat, lng);
            }, 500);
        }

        function placeMarker(lat, lng, doReverseGeocode) {
            if (addrMapMarker) {
                addrMapMarker.setLatLng([lat, lng]);
            } else {
                addrMapMarker = L.marker([lat, lng], { draggable: true }).addTo(addrMapInstance);
                addrMapMarker.on('dragend', function () {
                    var pos = addrMapMarker.getLatLng();
                    updateCoords(pos.lat, pos.lng);
                    reverseGeocodeDebounced(pos.lat, pos.lng);
                });
            }
            updateCoords(lat, lng);
            if (doReverseGeocode) reverseGeocode(lat, lng);
        }

        addrMapInstance.on('click', function (e) {
            placeMarker(e.latlng.lat, e.latlng.lng, true);
        });

        if (presetLat && presetLng) {
            placeMarker(startLat, startLng, false);
        } else if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(
                function (pos) { addrMapInstance.setView([pos.coords.latitude, pos.coords.longitude], 15); },
                function () { /* denied - keep default center */ },
                { timeout: 5000 }
            );
        }

        document.getElementById('addrMapSearchBtn').addEventListener('click', function () {
            var query = document.getElementById('addrMapSearchInput').value.trim();
            if (!query) return;
            fetch('https://nominatim.openstreetmap.org/search?format=json&q=' + encodeURIComponent(query) + '&limit=1')
                .then(function (res) { return res.json(); })
                .then(function (results) {
                    if (results && results.length > 0) {
                        var lat = parseFloat(results[0].lat);
                        var lng = parseFloat(results[0].lon);
                        addrMapInstance.setView([lat, lng], 16);
                        placeMarker(lat, lng, true);
                    } else {
                        alert('Không tìm thấy địa chỉ, vui lòng thử tên khác');
                    }
                })
                .catch(function () { alert('Không tìm được địa chỉ, vui lòng thử lại'); });
        });
    }
</script>

</body>
</html>
