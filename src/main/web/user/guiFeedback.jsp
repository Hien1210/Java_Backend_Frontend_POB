<%@ page pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đánh giá - POB</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            font-family: 'Inter', -apple-system, sans-serif;
            background: #f0f4f8;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 24px;
        }

        .card {
            background: #fff;
            border-radius: 24px;
            box-shadow: 0 12px 48px rgba(26,32,53,0.11);
            width: 100%;
            max-width: 480px;
            padding: 36px 36px 32px;
            animation: fadeIn 0.35s cubic-bezier(0.16,1,0.3,1);
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px) scale(0.98); }
            to   { opacity: 1; transform: translateY(0) scale(1); }
        }

        /* HEADER */
        .card-header { display: flex; align-items: center; gap: 14px; margin-bottom: 28px; }
        .logo-badge {
            width: 44px; height: 44px; border-radius: 14px;
            background: linear-gradient(135deg, #1a2035, #2d3a6e);
            display: flex; align-items: center; justify-content: center;
            color: #fff; font-weight: 800; font-size: 13px;
            box-shadow: 0 4px 12px rgba(26,32,53,0.25); flex-shrink: 0;
        }
        .card-title { font-size: 18px; font-weight: 800; color: #0f172a; margin-bottom: 2px; }
        .card-sub   { font-size: 12px; color: #94a3b8; }

        /* STARS */
        .section { margin-bottom: 22px; }
        .section-label { font-size: 12.5px; font-weight: 700; color: #475569; text-transform: uppercase; letter-spacing: 0.06em; margin-bottom: 14px; }

        .star-row { display: flex; justify-content: center; gap: 10px; margin-bottom: 10px; }
        .star-btn {
            font-size: 38px; color: #e2e8f0;
            cursor: pointer; transition: color 0.12s, transform 0.12s;
            user-select: none; line-height: 1;
        }
        .star-btn:hover, .star-btn.active { color: #f59e0b; transform: scale(1.18); }

        .rating-label {
            text-align: center; font-size: 13.5px; font-weight: 700;
            color: #f59e0b; min-height: 20px;
        }

        /* TEXTAREA */
        .textarea-field {
            width: 100%; background: #f8fafc; border: 1.5px solid #e2e8f0;
            border-radius: 14px; padding: 13px 14px;
            font-size: 13.5px; color: #0f172a; font-family: inherit;
            resize: none; outline: none;
            transition: border-color 0.2s, box-shadow 0.2s, background 0.2s;
            line-height: 1.6;
        }
        .textarea-field:focus { border-color: #10b981; background: #fff; box-shadow: 0 0 0 4px rgba(16,185,129,0.1); }
        .textarea-field::placeholder { color: #b0bcc9; }

        /* CHECKBOX */
        .anon-label {
            display: flex; align-items: center; gap: 10px;
            font-size: 13.5px; color: #374151; cursor: pointer;
            margin-bottom: 22px; user-select: none;
        }
        .anon-label input[type=checkbox] { width: 16px; height: 16px; accent-color: #10b981; cursor: pointer; border-radius: 4px; }

        /* ACTIONS */
        .action-row { display: flex; gap: 10px; }
        .btn-cancel {
            flex: 0 0 auto; padding: 13px 22px;
            border-radius: 14px; border: 1.5px solid #e2e8f0;
            font-size: 13.5px; font-weight: 600; color: #475569;
            background: transparent; text-decoration: none;
            display: flex; align-items: center; justify-content: center;
            transition: background 0.15s; font-family: inherit;
        }
        .btn-cancel:hover { background: #f1f5f9; }

        .btn-submit {
            flex: 1; padding: 14px;
            border-radius: 14px; border: none;
            background: linear-gradient(135deg, #10b981, #059669);
            color: #fff; font-size: 14px; font-weight: 700;
            cursor: pointer; font-family: inherit;
            box-shadow: 0 4px 16px rgba(16,185,129,0.35);
            transition: all 0.2s;
        }
        .btn-submit:hover { transform: translateY(-1.5px); box-shadow: 0 6px 22px rgba(16,185,129,0.45); }
        .btn-submit:active { transform: translateY(0); }
    </style>
</head>
<body>

<div class="card">

    <div class="card-header">
        <div class="logo-badge">POB</div>
        <div>
            <div class="card-title">
                Đánh giá <c:choose><c:when test="${targetType eq 'SHOP'}">Cửa hàng</c:when><c:otherwise>Shipper</c:otherwise></c:choose>
            </div>
            <div class="card-sub">Đơn hàng #<c:out value="${orderId}"/></div>
        </div>
    </div>

    <form action="${pageContext.request.contextPath}/feedback" method="post">
        <input type="hidden" name="orderId"    value="${orderId}">
        <input type="hidden" name="targetType" value="${targetType}">
        <input type="hidden" name="rating"     id="ratingInput" value="5">

        <!-- SAO -->
        <div class="section">
            <div class="section-label">Mức độ hài lòng</div>
            <div class="star-row" id="starRow">
                <span class="star-btn active" data-val="1">★</span>
                <span class="star-btn active" data-val="2">★</span>
                <span class="star-btn active" data-val="3">★</span>
                <span class="star-btn active" data-val="4">★</span>
                <span class="star-btn active" data-val="5">★</span>
            </div>
            <div class="rating-label" id="ratingLabel">Rất hài lòng</div>
        </div>

        <!-- NHẬN XÉT -->
        <div class="section">
            <div class="section-label">Nhận xét của bạn</div>
            <textarea name="comment" rows="4" placeholder="Chia sẻ trải nghiệm của bạn với chúng tôi..." class="textarea-field"></textarea>
        </div>

        <!-- ẨN DANH (chỉ User → Shop) -->
        <c:if test="${targetType eq 'SHOP'}">
        <label class="anon-label">
            <input type="checkbox" name="is_anonymous" value="true">
            <span>Đăng đánh giá ẩn danh</span>
        </label>
        </c:if>

        <div class="action-row">
            <a href="${pageContext.request.contextPath}/user/donhang" class="btn-cancel">Hủy</a>
            <button type="submit" class="btn-submit">Gửi đánh giá ✓</button>
        </div>
    </form>
</div>

<script>
    const labels = ['', 'Rất tệ', 'Không hài lòng', 'Bình thường', 'Hài lòng', 'Rất hài lòng'];
    const stars  = document.querySelectorAll('.star-btn');
    const input  = document.getElementById('ratingInput');
    const label  = document.getElementById('ratingLabel');

    function setRating(val) {
        input.value = val;
        label.textContent = labels[val];
        stars.forEach(s => s.classList.toggle('active', parseInt(s.dataset.val) <= val));
    }

    stars.forEach(s => {
        s.addEventListener('click',    () => setRating(parseInt(s.dataset.val)));
        s.addEventListener('mouseover',() => stars.forEach(x => x.classList.toggle('active', parseInt(x.dataset.val) <= parseInt(s.dataset.val))));
        s.addEventListener('mouseout', () => setRating(parseInt(input.value)));
    });

    setRating(5);
</script>
</body>
</html>
