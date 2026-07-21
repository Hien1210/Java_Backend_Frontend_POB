<%@ page pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đánh giá - POB</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/theme-space.css">
    <style>
        body { display: flex; align-items: center; justify-content: center; padding: 20px; }
        .fb-card { max-width: 480px; width: 100%; padding: 32px; }
        .fb-head { display: flex; align-items: center; gap: 12px; margin-bottom: 22px; }
        .fb-logo { width: 42px; height: 42px; border-radius: var(--radius-sm); background: linear-gradient(135deg, var(--primary), var(--secondary)); color: #fff; display: flex; align-items: center; justify-content: center; font-weight: 800; font-size: 13px; box-shadow: var(--glow-primary); }
        .fb-title { font-size: 17px; font-weight: 800; color: var(--text-main); }
        .fb-sub { font-size: 12px; color: var(--text-dim); margin-top: 2px; }

        .star-row { display: flex; gap: 8px; justify-content: center; }
        .star-btn { cursor: pointer; transition: transform .1s; font-size: 36px; color: rgba(255,255,255,.15); line-height: 1; }
        .star-btn:hover, .star-btn.active { color: var(--warning); transform: scale(1.15); filter: drop-shadow(0 0 8px rgba(251,191,36,.5)); }
        .rating-label { text-align: center; font-size: 13.5px; font-weight: 700; color: var(--warning); margin-top: 8px; }

        .fb-anon { display: flex; align-items: center; gap: 8px; margin-bottom: 20px; cursor: pointer; user-select: none; font-size: 13px; color: var(--text-muted); }
        .fb-anon input { width: 16px; height: 16px; accent-color: var(--primary); }
        .fb-actions { display: flex; gap: 12px; margin-top: 24px; }
        .fb-actions .btn { flex: 1; }
    </style>
</head>
<body class="space-scope">
<div class="starfield"></div>

<div class="card fb-card">

    <div class="fb-head">
        <div class="fb-logo">POB</div>
        <div>
            <h1 class="fb-title">Đánh giá ${targetType eq 'SHOP' ? 'Cửa hàng' : 'Shipper'}</h1>
            <p class="fb-sub">Đơn hàng #${orderId}</p>
        </div>
    </div>

    <form action="${pageContext.request.contextPath}/feedback" method="post">
        <input type="hidden" name="orderId"    value="${orderId}">
        <input type="hidden" name="targetType" value="${targetType}">
        <input type="hidden" name="rating"     id="ratingInput" value="5">

        <!-- Sao -->
        <div class="form-group">
            <label class="form-label">Mức độ hài lòng</label>
            <div class="star-row" id="starRow">
                <span class="star-btn active" data-val="1">★</span>
                <span class="star-btn active" data-val="2">★</span>
                <span class="star-btn active" data-val="3">★</span>
                <span class="star-btn active" data-val="4">★</span>
                <span class="star-btn active" data-val="5">★</span>
            </div>
            <p class="rating-label" id="ratingLabel">Rất hài lòng</p>
        </div>

        <!-- Bình luận -->
        <div class="form-group">
            <label class="form-label">Nhận xét của bạn</label>
            <textarea class="form-textarea" name="comment" rows="4" placeholder="Chia sẻ trải nghiệm của bạn..."></textarea>
        </div>

        <!-- Ẩn danh (chỉ User → Shop) -->
        <c:if test="${targetType eq 'SHOP'}">
        <label class="fb-anon">
            <input type="checkbox" name="is_anonymous" value="true">
            Đăng đánh giá ẩn danh
        </label>
        </c:if>

        <!-- Buttons -->
        <div class="fb-actions">
            <a href="${pageContext.request.contextPath}/user/donhang" class="btn btn-ghost">Hủy</a>
            <button type="submit" class="btn btn-primary">Gửi đánh giá</button>
        </div>
    </form>
</div>

<script>
    var labels = ['', 'Rất tệ', 'Không hài lòng', 'Bình thường', 'Hài lòng', 'Rất hài lòng'];
    var stars  = document.querySelectorAll('.star-btn');
    var input  = document.getElementById('ratingInput');
    var label  = document.getElementById('ratingLabel');

    function setRating(val) {
        input.value = val;
        label.textContent = labels[val];
        stars.forEach(function (s) { s.classList.toggle('active', parseInt(s.dataset.val) <= val); });
    }

    stars.forEach(function (s) {
        s.addEventListener('click', function () { setRating(parseInt(s.dataset.val)); });
        s.addEventListener('mouseover', function () {
            stars.forEach(function (x) { x.classList.toggle('active', parseInt(x.dataset.val) <= parseInt(s.dataset.val)); });
        });
        s.addEventListener('mouseout', function () { setRating(parseInt(input.value)); });
    });

    setRating(5);
</script>
</body>
</html>
