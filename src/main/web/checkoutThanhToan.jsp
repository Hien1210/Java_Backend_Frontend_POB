<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh toán - POB</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Inter', -apple-system, sans-serif; background: #f0f4f8; min-height: 100vh; }

        /* NAVBAR */
        .navbar { background: #fff; border-bottom: 1px solid #e9edf2; box-shadow: 0 1px 6px rgba(26,32,53,0.06); padding: 0 24px; height: 60px; display: flex; align-items: center; gap: 14px; }
        .nav-logo { display: flex; align-items: center; gap: 10px; text-decoration: none; }
        .nav-logo-badge { width: 36px; height: 36px; border-radius: 10px; background: linear-gradient(135deg,#1a2035,#2d3a6e); display: flex; align-items: center; justify-content: center; color: #fff; font-weight: 800; font-size: 12px; }
        .nav-title { font-size: 16px; font-weight: 800; color: #0f172a; }
        .nav-right { margin-left: auto; display: flex; align-items: center; gap: 16px; }
        .nav-link { font-size: 13px; font-weight: 500; color: #64748b; text-decoration: none; transition: color 0.2s; }
        .nav-link:hover { color: #10b981; }

        /* LAYOUT */
        .page-wrap { max-width: 860px; margin: 0 auto; padding: 32px 20px; display: grid; grid-template-columns: 1fr 360px; gap: 24px; align-items: start; }
        @media (max-width: 700px) { .page-wrap { grid-template-columns: 1fr; } }

        /* CARD */
        .card { background: #fff; border-radius: 20px; border: 1px solid #eef0f4; box-shadow: 0 2px 10px rgba(26,32,53,0.06); padding: 24px; margin-bottom: 18px; }
        .card:last-child { margin-bottom: 0; }
        .card-title { font-size: 15px; font-weight: 800; color: #0f172a; margin-bottom: 18px; display: flex; align-items: center; gap: 8px; }

        /* ALERT */
        .alert { display: flex; align-items: center; gap: 10px; border-radius: 12px; padding: 13px 16px; font-size: 13px; font-weight: 500; margin-bottom: 18px; }
        .alert-error { background: #fef2f2; border: 1px solid #fecaca; color: #dc2626; }

        /* ORDER TABLE */
        .order-table { width: 100%; border-collapse: collapse; }
        .order-table th { font-size: 11px; font-weight: 700; color: #94a3b8; text-transform: uppercase; letter-spacing: 0.05em; padding: 0 0 10px; text-align: left; border-bottom: 1px solid #f1f5f9; }
        .order-table th.r, .order-table td.r { text-align: right; }
        .order-table td { padding: 11px 0; font-size: 13.5px; color: #374151; border-bottom: 1px solid #f8fafc; }
        .shop-row td { font-weight: 700; color: #1a2035; font-size: 12.5px; padding-top: 14px; }
        .shop-row td span { background: #f0f4f8; padding: 3px 10px; border-radius: 8px; }
        .prod-name { font-weight: 600; color: #0f172a; }
        .size-tag { font-size: 11.5px; color: #94a3b8; font-weight: 500; }

        .total-block { margin-top: 14px; padding-top: 14px; border-top: 2px solid #f0f4f8; }
        .total-row { display: flex; justify-content: space-between; align-items: center; font-size: 13.5px; color: #64748b; margin-bottom: 6px; }
        .total-row.grand { font-size: 16px; font-weight: 800; color: #0f172a; margin-top: 8px; }
        .total-row.grand .amt { color: #10b981; }
        .fee-note { font-size: 11.5px; color: #94a3b8; margin-top: 4px; }

        /* FORM */
        .form-group { margin-bottom: 16px; }
        .field-label { display: block; font-size: 11px; font-weight: 700; color: #475569; text-transform: uppercase; letter-spacing: 0.06em; margin-bottom: 6px; }
        .req { color: #dc2626; }
        .input-field, .select-field {
            width: 100%; background: #f8fafc; border: 1.5px solid #e2e8f0;
            border-radius: 12px; padding: 11px 14px;
            font-size: 13.5px; color: #0f172a; font-family: inherit;
            outline: none; transition: border-color 0.2s, box-shadow 0.2s;
        }
        .input-field:focus, .select-field:focus { border-color: #10b981; background: #fff; box-shadow: 0 0 0 4px rgba(16,185,129,0.1); }
        .input-field::placeholder { color: #b0bcc9; }

        /* PAYMENT METHOD */
        .pay-options { display: flex; flex-direction: column; gap: 10px; }
        .pay-option { display: flex; align-items: center; gap: 12px; padding: 13px 16px; border-radius: 14px; border: 1.5px solid #e2e8f0; cursor: pointer; transition: border-color 0.15s, background 0.15s; }
        .pay-option:has(input:checked) { border-color: #10b981; background: #f0fdf4; }
        .pay-option input[type=radio] { accent-color: #10b981; width: 16px; height: 16px; flex-shrink: 0; }
        .pay-option-label { font-size: 13.5px; font-weight: 600; color: #0f172a; }
        .pay-option-sub { font-size: 12px; color: #94a3b8; margin-top: 2px; }

        /* SUBMIT */
        .btn-checkout {
            width: 100%; padding: 15px; border-radius: 14px; border: none;
            background: linear-gradient(135deg, #10b981, #059669);
            color: #fff; font-size: 15px; font-weight: 700;
            cursor: pointer; font-family: inherit;
            box-shadow: 0 4px 18px rgba(16,185,129,0.35);
            transition: all 0.2s;
        }
        .btn-checkout:hover { transform: translateY(-1.5px); box-shadow: 0 6px 24px rgba(16,185,129,0.45); }
        .btn-checkout:active { transform: translateY(0); }

        /* STICKY SIDEBAR */
        .sidebar { position: sticky; top: 80px; }
    </style>
</head>
<body>

<nav class="navbar">
    <a href="${pageContext.request.contextPath}/user/home" class="nav-logo">
        <div class="nav-logo-badge">POB</div>
    </a>
    <span class="nav-title">Thanh toán</span>
    <div class="nav-right">
        <a href="${pageContext.request.contextPath}/user/donhang" class="nav-link">📦 Đơn hàng</a>
        <a href="${pageContext.request.contextPath}/user/home" class="nav-link">← Trang chủ</a>
    </div>
</nav>

<div class="page-wrap">

    <!-- LEFT: order details -->
    <div>
        <c:if test="${not empty error}">
            <div class="alert alert-error">❌ <c:out value="${error}"/></div>
        </c:if>

        <div class="card">
            <div class="card-title">🛒 Giỏ hàng #${cart.id}</div>
            <table class="order-table">
                <thead>
                    <tr>
                        <th>Sản phẩm</th>
                        <th class="r">SL</th>
                        <th class="r">Thành tiền</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${lines}" var="line" varStatus="s">
                        <c:if test="${s.first or line.shopName ne lines[s.index - 1].shopName}">
                            <tr class="shop-row"><td colspan="3"><span>🏪 <c:out value="${line.shopName}"/></span></td></tr>
                        </c:if>
                        <tr>
                            <td>
                                <div class="prod-name"><c:out value="${line.productName}"/></div>
                                <div class="size-tag"><c:out value="${line.sizeName}"/></div>
                            </td>
                            <td class="r">${line.quantity}</td>
                            <td class="r"><fmt:formatNumber value="${line.lineTotal}" type="number"/>đ</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>

            <div class="total-block">
                <div class="total-row"><span>Tạm tính</span><span><fmt:formatNumber value="${subtotal}" type="number"/>đ</span></div>
                <div class="total-row"><span>Phí giao hàng</span><span>15.000đ / shop</span></div>
                <div class="total-row grand"><span>Tổng thanh toán</span><span class="amt"><fmt:formatNumber value="${subtotal + 15000}" type="number"/>đ</span></div>
                <div class="fee-note">* Phí giao hàng cố định 15.000đ mỗi shop</div>
            </div>
        </div>
    </div>

    <!-- RIGHT: form + payment -->
    <div class="sidebar">
        <form method="post" action="${pageContext.request.contextPath}/checkout">
            <input type="hidden" name="cartId" value="${cart.id}">

            <div class="card">
                <div class="card-title">📍 Thông tin nhận hàng</div>

                <div class="form-group">
                    <label class="field-label">Tên người nhận <span class="req">*</span></label>
                    <input type="text" name="receiverName" class="input-field" placeholder="Họ và tên" value="${fn:escapeXml(param.receiverName)}" required>
                </div>
                <div class="form-group">
                    <label class="field-label">Số điện thoại <span class="req">*</span></label>
                    <input type="tel" name="receiverPhone" class="input-field" placeholder="0xxxxxxxxx" value="${fn:escapeXml(param.receiverPhone)}" required>
                </div>
                <div class="form-group">
                    <label class="field-label">Địa chỉ giao hàng <span class="req">*</span></label>
                    <input type="text" name="shippingAddress" class="input-field" placeholder="Số nhà, tên đường, phường, quận, thành phố" value="${fn:escapeXml(param.shippingAddress)}" required>
                </div>
            </div>

            <div class="card">
                <div class="card-title">💳 Phương thức thanh toán</div>
                <div class="pay-options">
                    <label class="pay-option">
                        <input type="radio" name="paymentMethod" value="COD" ${param.paymentMethod ne 'PAYOS' ? 'checked' : ''}>
                        <div>
                            <div class="pay-option-label">💵 Thanh toán khi nhận hàng (COD)</div>
                            <div class="pay-option-sub">Trả tiền mặt khi nhận</div>
                        </div>
                    </label>
                    <label class="pay-option">
                        <input type="radio" name="paymentMethod" value="PAYOS" ${param.paymentMethod eq 'PAYOS' ? 'checked' : ''}>
                        <div>
                            <div class="pay-option-label">📱 Thanh toán online (PayOS)</div>
                            <div class="pay-option-sub">Quét QR — chỉ áp dụng cho 1 shop</div>
                        </div>
                    </label>
                </div>
            </div>

            <button type="submit" class="btn-checkout">✅ Xác nhận đặt hàng</button>
        </form>
    </div>

</div>
</body>
</html>
