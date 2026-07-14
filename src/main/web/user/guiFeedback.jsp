<%@ page pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đánh giá - POB</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        * { font-family: 'Inter', sans-serif; }
        .star-btn { cursor: pointer; transition: transform 0.1s; font-size: 36px; color: #d1d5db; }
        .star-btn:hover, .star-btn.active { color: #f59e0b; transform: scale(1.15); }
        textarea:focus { outline: none; box-shadow: 0 0 0 3px rgba(59,91,219,0.12); }
    </style>
</head>
<body class="bg-gray-50 min-h-screen flex items-center justify-center p-4">

<div class="bg-white rounded-2xl shadow-lg w-full max-w-lg p-8">

    <!-- Header -->
    <div class="flex items-center gap-3 mb-6">
        <div class="w-10 h-10 rounded-xl flex items-center justify-center text-white font-extrabold text-base"
             style="background: linear-gradient(135deg,#273155,#3d4f7c);">POB</div>
        <div>
            <h1 class="text-lg font-extrabold text-gray-800">
                Đánh giá ${targetType eq 'SHOP' ? 'Cửa hàng' : 'Shipper'}
            </h1>
            <p class="text-xs text-gray-400">Đơn hàng #${orderId}</p>
        </div>
    </div>

    <form action="${pageContext.request.contextPath}/feedback" method="post">
        <input type="hidden" name="orderId"    value="${orderId}">
        <input type="hidden" name="targetType" value="${targetType}">
        <input type="hidden" name="rating"     id="ratingInput" value="5">

        <!-- Sao -->
        <div class="mb-5">
            <p class="text-sm font-semibold text-gray-700 mb-3">Mức độ hài lòng</p>
            <div class="flex gap-2 justify-center" id="starRow">
                <span class="star-btn active" data-val="1">★</span>
                <span class="star-btn active" data-val="2">★</span>
                <span class="star-btn active" data-val="3">★</span>
                <span class="star-btn active" data-val="4">★</span>
                <span class="star-btn active" data-val="5">★</span>
            </div>
            <p class="text-center text-sm text-amber-500 font-semibold mt-2" id="ratingLabel">Rất hài lòng</p>
        </div>

        <!-- Bình luận -->
        <div class="mb-5">
            <label class="block text-sm font-semibold text-gray-700 mb-2">Nhận xét của bạn</label>
            <textarea name="comment" rows="4" placeholder="Chia sẻ trải nghiệm của bạn..."
                      class="w-full border border-gray-200 rounded-xl p-3 text-sm resize-none bg-gray-50
                             focus:bg-white focus:border-blue-400 transition"></textarea>
        </div>

        <!-- Ẩn danh (chỉ User → Shop) -->
        <c:if test="${targetType eq 'SHOP'}">
        <label class="flex items-center gap-2 mb-5 cursor-pointer select-none">
            <input type="checkbox" name="is_anonymous" value="true"
                   class="w-4 h-4 accent-[#273155] rounded">
            <span class="text-sm text-gray-600">Đăng đánh giá ẩn danh</span>
        </label>
        </c:if>

        <!-- Buttons -->
        <div class="flex gap-3">
            <a href="${pageContext.request.contextPath}/user/donhang"
               class="flex-1 text-center py-3 border border-gray-200 rounded-xl text-sm font-semibold text-gray-500 hover:bg-gray-50 transition">
                Hủy
            </a>
            <button type="submit"
                    class="flex-1 py-3 rounded-xl text-white text-sm font-bold transition hover:opacity-90"
                    style="background: linear-gradient(135deg,#273155,#3d4f7c);">
                Gửi đánh giá
            </button>
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
        stars.forEach(s => {
            s.classList.toggle('active', parseInt(s.dataset.val) <= val);
        });
    }

    stars.forEach(s => {
        s.addEventListener('click', () => setRating(parseInt(s.dataset.val)));
        s.addEventListener('mouseover', () => {
            stars.forEach(x => x.classList.toggle('active', parseInt(x.dataset.val) <= parseInt(s.dataset.val)));
        });
        s.addEventListener('mouseout', () => setRating(parseInt(input.value)));
    });

    setRating(5);
</script>
</body>
</html>
