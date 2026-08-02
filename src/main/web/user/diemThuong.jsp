<%@ page pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Điểm thưởng - POB</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/user-theme.css">
    <style>
        :root {
            --bg:      #FFFBF8;
            --surface: #FFFFFF;
            --surface-lt: #FFF4EC;
            --gold:    #FF5A1F;
            --text:    #241C15;
            --muted:   #8A7B6C;
            --border:  #F1E4D6;
            --font-b:  'Plus Jakarta Sans', sans-serif;
            --tr: all .25s ease;
        }
        *, *::before, *::after { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: var(--font-b); background: var(--bg); color: var(--text); min-height: 100vh; }
        a { text-decoration: none; color: inherit; transition: var(--tr); }

        /* NAVBAR */
        .navbar {
            background: rgba(255,251,248,.92); backdrop-filter: blur(14px);
            border-bottom: 1px solid var(--border);
            height: 74px; display: flex; align-items: center;
            padding: 0 30px; position: sticky; top: 0; z-index: 100; gap: 16px;
        }
        .nav-logo { font-size: 1.55rem; font-weight: 800; letter-spacing: -.5px; }
        .nav-logo span { color: var(--gold); }
        .nav-title { font-size: .95rem; font-weight: 700; color: var(--text); }
        .nav-sep { width: 1px; height: 20px; background: var(--border); }
        .nav-right { margin-left: auto; display: flex; gap: 10px; }
        .nav-link {
            display: inline-flex; align-items: center; gap: 7px; position: relative;
            padding: 9px 18px; font-size: .85rem; font-weight: 700;
            color: var(--muted); border: 1.5px solid var(--border); border-radius: 50px;
        }
        .nav-link:hover { color: var(--gold); border-color: var(--gold); background: var(--surface-lt); }

        .container { max-width: 640px; margin: 0 auto; padding: 40px 20px 80px; }

        .alert { display: flex; align-items: center; gap: 10px; padding: 14px 18px; margin-bottom: 20px; border-radius: 14px; border: 1px solid; font-size: .9rem; font-weight: 600; }
        .alert-danger { background: #FEECEF; border-color: #FBD0D8; color: #E11D48; }

        .card { background: var(--surface); border: 1px solid var(--border); border-radius: 20px; box-shadow: 0 4px 18px rgba(60,30,10,.06); padding: 24px; margin-bottom: 20px; }
        .points-hero { text-align: center; padding: 32px 20px; }
        .points-value { font-size: 46px; font-weight: 900; color: var(--gold); }
        .points-label { font-size: 13px; color: var(--muted); margin-top: 4px; }
        .points-hint { font-size: 12.5px; color: var(--muted); margin-top: 14px; line-height: 1.6; }
        .btn-redeem { display: block; width: 100%; padding: 13px; margin-top: 18px; border-radius: 50px; border: none; background: linear-gradient(135deg, var(--gold), #E14A0F); color: #fff; font-weight: 700; font-size: 14px; cursor: pointer; box-shadow: 0 8px 22px rgba(255,90,31,.32); }
        .btn-redeem:hover { filter: brightness(1.05); }
        .btn-redeem:disabled { opacity: .4; cursor: not-allowed; box-shadow: none; }
        .voucher-result { background: var(--surface-lt); border: 1px dashed var(--gold); border-radius: 12px; padding: 14px; text-align: center; font-size: 13.5px; color: var(--text); margin-bottom: 20px; }
    </style>
</head>
<body>

<div class="navbar">
    <div class="nav-logo">POBFood<span>.</span></div>
    <div class="nav-sep"></div>
    <span class="nav-title">Điểm thưởng</span>
    <div class="nav-right">
        <a href="${pageContext.request.contextPath}/user/thong-bao" class="nav-link" style="position:relative;">
            🔔 Thông báo
            <span data-notif-badge style="display:${unreadNotifCount > 0 ? 'inline-block' : 'none'};position:absolute;top:-4px;right:-8px;background:#ef4444;color:#fff;border-radius:999px;font-size:10px;min-width:16px;height:16px;line-height:16px;text-align:center;padding:0 3px;font-weight:700;">${unreadNotifCount}</span>
        </a>
        <a href="${pageContext.request.contextPath}/user/donhang" class="nav-link">📦 Đơn hàng</a>
        <a href="${pageContext.request.contextPath}/user/dia-chi" class="nav-link">📍 Địa chỉ</a>
        <a href="${pageContext.request.contextPath}/user/cart" class="nav-link">🛒 Giỏ hàng</a>
        <a href="${pageContext.request.contextPath}/user/home" class="nav-link">🏠 Trang chủ</a>
    </div>
</div>

<div class="container">
    <c:if test="${not empty thanhCong}">
        <div class="voucher-result">${thanhCong}</div>
    </c:if>
    <c:if test="${not empty loi}">
        <div class="alert alert-danger">❌ <c:out value="${loi}"/></div>
    </c:if>

    <div class="card points-hero">
        <div class="points-value">${diem}</div>
        <div class="points-label">điểm thưởng hiện có</div>
        <div class="points-hint">Tích điểm: mỗi 10.000đ giá trị đơn hàng thành công = 1 điểm.<br>
            Đổi <strong>${pointsPerVoucher}</strong> điểm lấy 1 voucher giảm
            <fmt:formatNumber value="${voucherValue}" type="number"/>đ (dùng 1 lần).</div>

        <form method="post" action="${pageContext.request.contextPath}/user/diem-thuong">
<input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
            <input type="hidden" name="action" value="redeem">
            <button type="submit" class="btn-redeem" ${diem < pointsPerVoucher ? 'disabled' : ''}>
                🎁 Đổi ${pointsPerVoucher} điểm lấy voucher
            </button>
        </form>
    </div>
</div>
<script>window.POB_CONTEXT_PATH = '${pageContext.request.contextPath}';</script>
<script src="${pageContext.request.contextPath}/assets/js/toast.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/notifications-ws.js"></script>
</body>
</html>
