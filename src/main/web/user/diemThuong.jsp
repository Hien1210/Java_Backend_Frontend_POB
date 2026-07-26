<%@ page pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Điểm thưởng - POB</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/theme-space.css">
    <style>
        .mini-nav { background: var(--bg-panel-solid); border-bottom: 1px solid var(--border-color); padding: 16px 24px; display: flex; align-items: center; gap: 16px; }
        .mini-nav .logo { width: 36px; height: 36px; border-radius: var(--radius-sm); background: linear-gradient(135deg, var(--primary), var(--secondary)); color: #fff; display: flex; align-items: center; justify-content: center; font-weight: 800; font-size: 13px; box-shadow: var(--glow-primary); }
        .mini-nav .title { font-size: 17px; font-weight: 800; color: var(--text-main); }
        .mini-nav .nav-links { margin-left: auto; display: flex; align-items: center; gap: 18px; }
        .mini-nav .nav-links a { font-size: 13px; color: var(--text-muted); }
        .mini-nav .nav-links a:hover { color: var(--secondary); }

        .container { max-width: 640px; margin: 0 auto; padding: 32px 16px; }
        .card { padding: 24px; margin-bottom: 20px; }
        .points-hero { text-align: center; padding: 32px 20px; }
        .points-value { font-size: 46px; font-weight: 900; color: var(--secondary); text-shadow: var(--glow-primary); }
        .points-label { font-size: 13px; color: var(--text-muted); margin-top: 4px; }
        .points-hint { font-size: 12.5px; color: var(--text-dim); margin-top: 14px; }
        .btn-redeem { display: block; width: 100%; padding: 12px; margin-top: 18px; border-radius: var(--radius-pill); border: none; background: var(--primary); color: #fff; font-weight: 700; font-size: 14px; cursor: pointer; }
        .btn-redeem:disabled { opacity: .4; cursor: not-allowed; }
        .voucher-result { background: rgba(34,211,238,.1); border: 1px dashed var(--secondary); border-radius: var(--radius-sm); padding: 14px; text-align: center; font-size: 13.5px; color: var(--text-main); margin-top: 16px; }
    </style>
</head>
<body class="space-scope">
<div class="starfield"></div>

<div class="mini-nav">
    <div class="logo">POB</div>
    <span class="title">Điểm thưởng</span>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/user/donhang">📦 Đơn hàng</a>
        <a href="${pageContext.request.contextPath}/user/thong-bao" style="position:relative;">🔔 Thông báo<span data-notif-badge style="display:${unreadNotifCount > 0 ? 'inline-block' : 'none'};margin-left:4px;background:#ef4444;color:#fff;border-radius:999px;font-size:10px;min-width:16px;height:16px;line-height:16px;text-align:center;padding:0 3px;font-weight:700;">${unreadNotifCount}</span></a>
        <a href="${pageContext.request.contextPath}/user/home">← Trang chủ</a>
    </div>
</div>

<div class="container">
    <c:if test="${not empty thanhCong}">
        <div class="voucher-result">${thanhCong}</div>
    </c:if>
    <c:if test="${not empty loi}">
        <div class="alert alert-danger" style="margin-bottom:20px;">❌ <c:out value="${loi}"/></div>
    </c:if>

    <div class="card points-hero">
        <div class="points-value">${diem}</div>
        <div class="points-label">điểm thưởng hiện có</div>
        <div class="points-hint">Tích điểm: mỗi 10.000đ giá trị đơn hàng thành công = 1 điểm.<br>
            Đổi <strong>${pointsPerVoucher}</strong> điểm lấy 1 voucher giảm
            <fmt:formatNumber value="${voucherValue}" type="number"/>đ (dùng 1 lần).</div>

        <form method="post" action="${pageContext.request.contextPath}/user/diem-thuong">
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
