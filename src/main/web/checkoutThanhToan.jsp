<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh toán</title>
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
                <label>Tên người nhận</label>
                <input type="text" name="receiverName" value="${param.receiverName}" required>
            </div>
            <div class="form-group">
                <label>Số điện thoại</label>
                <input type="text" name="receiverPhone" value="${param.receiverPhone}" required>
            </div>
            <div class="form-group">
                <label>Địa chỉ giao hàng</label>
                <input type="text" name="shippingAddress" value="${param.shippingAddress}" required>
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
</div>

</div>
</body>
</html>
