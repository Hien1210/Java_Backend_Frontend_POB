<%@ page pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đánh giá Shop - POB</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/theme.css">
    <style>
        body { background: var(--gray-50); min-height: 100vh; display: flex; align-items: center; justify-content: center; padding: 20px; }
        .fb-card { background: var(--white); border-radius: var(--radius-lg); box-shadow: var(--shadow-lg); width: 100%; max-width: 480px; padding: 32px; }
        .fb-head { display: flex; align-items: center; gap: 12px; margin-bottom: 22px; }
        .fb-logo { width: 42px; height: 42px; border-radius: var(--radius-sm); background: linear-gradient(135deg, var(--primary), var(--primary-dark)); color: #fff; display: flex; align-items: center; justify-content: center; font-weight: 800; font-size: 13px; box-shadow: 0 4px 10px rgba(255,87,34,.35); }
        .fb-title { font-size: 17px; font-weight: 800; color: var(--gray-800); }
        .fb-sub { font-size: 12px; color: var(--gray-400); margin-top: 2px; }

        .star-row { display: flex; gap: 8px; justify-content: center; }
        .star-btn { cursor: pointer; transition: transform .1s; font-size: 36px; color: var(--gray-200); line-height: 1; }
        .star-btn:hover, .star-btn.active { color: var(--warning); transform: scale(1.15); }
        .rating-label { text-align: center; font-size: 13.5px; font-weight: 700; color: var(--warning-dark); margin-top: 8px; }

        .fb-actions { display: flex; gap: 12px; margin-top: 24px; }
        .fb-actions .btn { flex: 1; }
    </style>
</head>
<body>

<div class="fb-card">

    <div class="fb-head">
        <div class="fb-logo">POB</div>
        <div>
            <div class="fb-title">Đánh giá Cửa hàng</div>
            <div class="fb-sub">Đơn hàng #${orderId}</div>
        </div>
    </div>

    <form action="${pageContext.request.contextPath}/shipper/feedback" method="post">
        <input type="hidden" name="orderId" value="${orderId}">
        <input type="hidden" name="rating" id="ratingInput" value="5">

        <!-- Sao -->
        <div class="form-group">
            <label class="form-label">Mức độ hài lòng với cửa hàng</label>
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
            <label class="form-label">Nhận xét về cửa hàng</label>
            <textarea class="form-textarea" name="comment" rows="4"
                      placeholder="Đóng gói hàng, thái độ phục vụ, chuẩn bị đơn..."></textarea>
        </div>

        <!-- Buttons -->
        <div class="fb-actions">
            <a href="${pageContext.request.contextPath}/shipper/donhang" class="btn btn-ghost">Hủy</a>
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
