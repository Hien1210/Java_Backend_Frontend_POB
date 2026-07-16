<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hóa đơn - POB</title>
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

        /* PAGE */
        .page-wrap { max-width: 680px; margin: 0 auto; padding: 32px 20px 48px; }

        /* ALERT */
        .alert-success { display: flex; align-items: center; gap: 10px; border-radius: 14px; padding: 14px 18px; background: #f0fdf4; border: 1px solid #bbf7d0; color: #16a34a; font-size: 14px; font-weight: 600; margin-bottom: 24px; }

        /* BILL CARD */
        .bill-card {
            background: #fff; border-radius: 20px; border: 1px solid #eef0f4;
            box-shadow: 0 4px 20px rgba(26,32,53,0.08);
            overflow: hidden; margin-bottom: 20px;
            animation: fadeIn 0.35s cubic-bezier(0.16,1,0.3,1);
        }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(12px); } to { opacity: 1; transform: translateY(0); } }

        /* BILL HEADER */
        .bill-header {
            background: linear-gradient(140deg, #1a2035 0%, #0f1624 100%);
            padding: 24px 28px; text-align: center; position: relative; overflow: hidden;
        }
        .bill-header::before { content: ''; position: absolute; top: -40px; right: -40px; width: 160px; height: 160px; border-radius: 50%; background: radial-gradient(circle, rgba(16,185,129,0.15) 0%, transparent 70%); }
        .bill-brand { font-size: 13px; font-weight: 700; color: rgba(255,255,255,0.45); letter-spacing: 0.1em; text-transform: uppercase; margin-bottom: 4px; }
        .bill-title { font-size: 22px; font-weight: 800; color: #fff; margin-bottom: 6px; }
        .bill-order-id { font-size: 13px; color: rgba(255,255,255,0.5); }

        /* STATUS BADGE */
        .status-badge {
            display: inline-flex; align-items: center; gap: 5px;
            padding: 5px 14px; border-radius: 99px;
            font-size: 12px; font-weight: 700; margin-top: 10px;
            background: rgba(16,185,129,0.2); color: #10b981;
        }

        /* BILL BODY */
        .bill-body { padding: 24px 28px; }

        .info-section { margin-bottom: 20px; }
        .info-title { font-size: 11px; font-weight: 700; color: #94a3b8; text-transform: uppercase; letter-spacing: 0.06em; margin-bottom: 10px; }
        .info-row { display: flex; justify-content: space-between; align-items: flex-start; gap: 12px; font-size: 13.5px; margin-bottom: 7px; }
        .info-row .lbl { color: #94a3b8; font-weight: 500; flex-shrink: 0; }
        .info-row .val { color: #0f172a; font-weight: 600; text-align: right; }

        /* DIVIDER */
        .divider { height: 1px; background: repeating-linear-gradient(90deg, #e2e8f0 0, #e2e8f0 6px, transparent 6px, transparent 12px); margin: 18px 0; }

        /* PRODUCT TABLE */
        .prod-table { width: 100%; border-collapse: collapse; }
        .prod-table th { font-size: 11px; font-weight: 700; color: #94a3b8; text-transform: uppercase; letter-spacing: 0.05em; padding: 0 0 10px; text-align: left; border-bottom: 1px solid #f1f5f9; }
        .prod-table th.r, .prod-table td.r { text-align: right; }
        .prod-table td { padding: 10px 0; font-size: 13.5px; color: #374151; border-bottom: 1px solid #f8fafc; }
        .prod-name { font-weight: 600; color: #0f172a; }
        .prod-size { font-size: 11.5px; color: #94a3b8; }
        .topping-tag { font-size: 11px; color: #10b981; background: #f0fdf4; border-radius: 6px; padding: 1px 6px; margin-top: 2px; display: inline-block; }

        /* TOTALS */
        .total-block { margin-top: 16px; }
        .total-row { display: flex; justify-content: space-between; font-size: 13.5px; color: #64748b; margin-bottom: 6px; }
        .total-row.grand { font-size: 17px; font-weight: 800; color: #0f172a; margin-top: 10px; padding-top: 10px; border-top: 2px solid #f0f4f8; }
        .total-row.grand .amt { color: #10b981; }

        /* ACTIONS */
        .bill-actions { padding: 0 28px 24px; display: flex; gap: 10px; }
        .btn-print {
            flex: 1; padding: 13px; border-radius: 14px; border: none;
            background: linear-gradient(135deg, #1a2035, #2d3a6e);
            color: #fff; font-size: 14px; font-weight: 700;
            cursor: pointer; font-family: inherit; transition: opacity 0.2s;
        }
        .btn-print:hover { opacity: 0.88; }
        .btn-orders {
            padding: 13px 20px; border-radius: 14px;
            border: 1.5px solid #e2e8f0; font-size: 13.5px; font-weight: 600;
            color: #475569; background: transparent; text-decoration: none;
            display: flex; align-items: center; justify-content: center;
            font-family: inherit; transition: background 0.15s;
        }
        .btn-orders:hover { background: #f1f5f9; }

        @media print { .navbar, .bill-actions, .alert-success { display: none; } }
    </style>
</head>
<body>

<nav class="navbar">
    <a href="${pageContext.request.contextPath}/user/home" class="nav-logo">
        <div class="nav-logo-badge">POB</div>
    </a>
    <span class="nav-title">Hóa đơn</span>
    <div class="nav-right">
        <a href="${pageContext.request.contextPath}/user/donhang" class="nav-link" style="display:inline-flex;align-items:center;gap:5px;">
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"/><polyline points="3.27 6.96 12 12.01 20.73 6.96"/><line x1="12" y1="22.08" x2="12" y2="12"/></svg>
            Đơn hàng
        </a>
        <a href="${pageContext.request.contextPath}/user/home" class="nav-link">← Trang chủ</a>
    </div>
</nav>

<div class="page-wrap">

    <c:if test="${not empty bills}">
        <div class="alert-success"><svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg> Đặt hàng thành công! Dưới đây là hóa đơn của bạn.</div>
    </c:if>

    <c:forEach items="${bills}" var="bill">
        <div class="bill-card">

            <div class="bill-header">
                <div class="bill-brand">POB Food</div>
                <div class="bill-title" style="display:flex;align-items:center;justify-content:center;gap:8px;">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M4 2h16a1 1 0 0 1 1 1v18l-3-2-3 2-3-2-3 2-3-2-3 2V3a1 1 0 0 1 1-1z"/><line x1="8" y1="7" x2="16" y2="7"/><line x1="8" y1="11" x2="16" y2="11"/><line x1="8" y1="15" x2="12" y2="15"/></svg>
                    Hóa đơn thanh toán</div>
                <div class="bill-order-id">Mã đơn #${bill.order.id} &nbsp;·&nbsp; <c:out value="${bill.shopName}"/></div>
                <div class="status-badge">● <c:out value="${bill.order.staTus}"/></div>
            </div>

            <div class="bill-body">

                <div class="info-section">
                    <div class="info-title">Thông tin nhận hàng</div>
                    <div class="info-row"><span class="lbl">Người nhận</span><span class="val"><c:out value="${bill.order.receiverName}"/></span></div>
                    <div class="info-row"><span class="lbl">Số điện thoại</span><span class="val"><c:out value="${bill.order.receiverPhone}"/></span></div>
                    <div class="info-row"><span class="lbl">Địa chỉ</span><span class="val"><c:out value="${bill.order.shippingAddress}"/></span></div>
                    <div class="info-row"><span class="lbl">Thanh toán</span><span class="val"><c:out value="${bill.order.paymentMethod}"/></span></div>
                    <div class="info-row">
                        <span class="lbl">Thời gian</span>
                        <span class="val">
                            ${fn:substring(bill.order.createdAt.toString(), 11, 16)}
                            ${fn:substring(bill.order.createdAt.toString(), 8, 10)}/${fn:substring(bill.order.createdAt.toString(), 5, 7)}/${fn:substring(bill.order.createdAt.toString(), 0, 4)}
                        </span>
                    </div>
                </div>

                <div class="divider"></div>

                <table class="prod-table">
                    <thead>
                        <tr>
                            <th>Sản phẩm</th>
                            <th class="r">SL</th>
                            <th class="r">Đơn giá</th>
                            <th class="r">Thành tiền</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${bill.lines}" var="line">
                            <tr>
                                <td>
                                    <div class="prod-name"><c:out value="${line.productName}"/></div>
                                    <div class="prod-size"><c:out value="${line.sizeName}"/></div>
                                    <c:forEach items="${line.toppings}" var="tp">
                                        <span class="topping-tag">+ <c:out value="${tp.toppingName}"/> x${tp.quantity} (<fmt:formatNumber value="${tp.price}" type="number"/>đ)</span><br>
                                    </c:forEach>
                                </td>
                                <td class="r">${line.quantity}</td>
                                <td class="r"><fmt:formatNumber value="${line.price}" type="number"/>đ</td>
                                <td class="r"><fmt:formatNumber value="${line.lineTotal}" type="number"/>đ</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>

                <div class="total-block">
                    <div class="total-row"><span>Tạm tính</span><span><fmt:formatNumber value="${bill.subtotal}" type="number"/>đ</span></div>
                    <div class="total-row"><span>Phí giao hàng</span><span><fmt:formatNumber value="${bill.order.deliveryFee}" type="number"/>đ</span></div>
                    <div class="total-row grand"><span>Tổng thanh toán</span><span class="amt"><fmt:formatNumber value="${bill.order.totalPrice}" type="number"/>đ</span></div>
                </div>

            </div>

            <div class="bill-actions">
                <button class="btn-print" onclick="window.print()" style="display:flex;align-items:center;justify-content:center;gap:7px;">
                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="6 9 6 2 18 2 18 9"/><path d="M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2h-2"/><rect x="6" y="14" width="12" height="8"/></svg>
                    In hóa đơn</button>
                <a href="${pageContext.request.contextPath}/user/donhang" class="btn-orders" style="gap:6px;">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"/><polyline points="3.27 6.96 12 12.01 20.73 6.96"/><line x1="12" y1="22.08" x2="12" y2="12"/></svg>
                    Đơn hàng</a>
            </div>

        </div>
    </c:forEach>

    <c:if test="${empty bills}">
        <div style="text-align:center;padding:64px 24px;background:#fff;border-radius:20px;border:1px solid #eef0f4;">
            <div style="margin-bottom:14px;"><svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="#cbd5e1" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" style="margin:0 auto;"><path d="M4 2h16a1 1 0 0 1 1 1v18l-3-2-3 2-3-2-3 2-3-2-3 2V3a1 1 0 0 1 1-1z"/><line x1="8" y1="7" x2="16" y2="7"/><line x1="8" y1="11" x2="16" y2="11"/><line x1="8" y1="15" x2="12" y2="15"/></svg></div>
            <div style="font-size:16px;font-weight:600;color:#64748b;">Không tìm thấy hóa đơn.</div>
            <a href="${pageContext.request.contextPath}/user/donhang" style="display:inline-block;margin-top:12px;font-size:13.5px;font-weight:700;color:#10b981;text-decoration:none;">Xem đơn hàng →</a>
        </div>
    </c:if>

</div>
</body>
</html>
