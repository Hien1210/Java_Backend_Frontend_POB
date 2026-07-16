<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh toán thất bại</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            font-family: 'Inter', 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f0f4f8;
            color: #0f172a;
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            padding: 20px;
        }
        .card {
            background: #fff;
            border: 1px solid #eef0f4;
            border-radius: 20px;
            box-shadow: 0 2px 20px rgba(26,32,53,0.08);
            padding: 40px 36px;
            max-width: 440px;
            width: 100%;
            text-align: center;
        }
        .icon-wrap {
            width: 72px;
            height: 72px;
            border-radius: 50%;
            background: #fef2f2;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 18px;
        }
        h1 { font-size: 20px; font-weight: 800; color: #dc2626; margin-bottom: 10px; }
        p.msg { font-size: 14px; color: #64748b; margin-bottom: 20px; line-height: 1.6; }
        p.order-id {
            font-size: 13px;
            color: #374151;
            font-weight: 600;
            background: #f0f4f8;
            border-radius: 10px;
            padding: 10px 14px;
            margin-bottom: 24px;
        }
        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 7px;
            padding: 12px 24px;
            border-radius: 10px;
            text-decoration: none;
            font-size: 14px;
            font-weight: 700;
            font-family: inherit;
        }
        .btn-primary {
            background: linear-gradient(135deg,#10b981,#059669);
            color: #fff;
            box-shadow: 0 4px 12px rgba(16,185,129,0.28);
            transition: transform 0.15s, box-shadow 0.15s;
        }
        .btn-primary:hover { transform: translateY(-1px); box-shadow: 0 6px 16px rgba(16,185,129,0.35); }
    </style>
</head>
<body>
    <div class="card">
        <div class="icon-wrap">
            <svg width="34" height="34" viewBox="0 0 24 24" fill="none" stroke="#dc2626" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><line x1="15" y1="9" x2="9" y2="15"/><line x1="9" y1="9" x2="15" y2="15"/></svg>
        </div>
        <h1>Thanh toán không thành công</h1>
        <p class="msg">
            <c:out value="${not empty loi ? loi : 'Giao dich PayOS da bi huy hoac khong thanh cong. Vui long thu lai.'}"/>
        </p>
        <c:if test="${not empty order}">
            <p class="order-id">Mã đơn hàng: #${order.id}</p>
        </c:if>
        <a href="${pageContext.request.contextPath}/cart" class="btn btn-primary">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="9" cy="21" r="1"/><circle cx="20" cy="21" r="1"/><path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"/></svg>
            Về giỏ hàng
        </a>
    </div>
</body>
</html>
