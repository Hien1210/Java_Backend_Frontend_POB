<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Xác thực thay đổi thông tin - POB</title>
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Segoe UI', Arial, sans-serif; background: #f0f4f8; min-height: 100vh; display: flex; align-items: center; justify-content: center; padding: 24px; }
        .card { width: 100%; max-width: 420px; background: #fff; border-radius: 20px; box-shadow: 0 20px 60px rgba(26,32,53,0.12); padding: 40px 36px; }
        .logo-badge { width: 40px; height: 40px; border-radius: 12px; background: linear-gradient(135deg,#1a2035,#2d3a6e); display: flex; align-items: center; justify-content: center; color: #fff; font-weight: 800; font-size: 13px; margin-bottom: 20px; }
        h1 { font-size: 22px; font-weight: 800; color: #0f172a; margin-bottom: 6px; }
        .sub { font-size: 13px; color: #94a3b8; margin-bottom: 20px; line-height: 1.6; }
        .alert { display: flex; align-items: center; gap: 10px; border-radius: 12px; padding: 12px 16px; font-size: 13px; font-weight: 500; margin-bottom: 16px; }
        .alert-error { background: #fef2f2; border: 1px solid #fecaca; color: #dc2626; }
        .alert-success { background: #f0fdf4; border: 1px solid #bbf7d0; color: #16a34a; }
        .alert-info { background: #eff6ff; border: 1px solid #bfdbfe; color: #2563eb; }
        .otp-row { display: flex; justify-content: center; gap: 8px; margin-bottom: 20px; }
        .otp-input { width: 42px; height: 52px; border: 1.5px solid #e2e8f0; border-radius: 12px; font-size: 20px; font-weight: 800; text-align: center; color: #0f172a; background: #f8fafc; font-family: inherit; outline: none; }
        .otp-input:focus { border-color: #10b981; background: #fff; box-shadow: 0 0 0 4px rgba(16,185,129,0.12); }
        .btn-primary { width: 100%; background: linear-gradient(135deg,#10b981,#059669); color: #fff; font-weight: 700; font-size: 14px; padding: 13px; border-radius: 12px; border: none; cursor: pointer; font-family: inherit; }
        .resend-wrap { text-align: center; margin-top: 16px; }
        .resend-btn { background: none; border: none; font-size: 12.5px; font-weight: 700; color: #1a2035; cursor: pointer; font-family: inherit; }
        .resend-btn:disabled { opacity: .4; cursor: not-allowed; }
    </style>
</head>
<body>
<div class="card">
    <div class="logo-badge">POB</div>
    <h1>Xác thực thay đổi thông tin</h1>
    <p class="sub">Vì đây là thao tác nhạy cảm (email/thông tin ngân hàng), vui lòng nhập mã OTP 6 số đã gửi tới
        <strong>${maskedEmail}</strong> để hoàn tất.</p>

    <c:if test="${param.resent == '1'}">
        <div class="alert alert-info">🔄 Mã OTP mới đã được gửi lại.</div>
    </c:if>
    <c:if test="${not empty loi}">
        <div class="alert alert-error">⚠️ <c:out value="${loi}"/></div>
    </c:if>

    <form action="${pageContext.request.contextPath}/xac-thuc-thay-doi" method="post">
        <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
        <input type="hidden" name="purpose" value="${purpose}">
        <div class="otp-row">
            <input type="number" name="otp1" min="0" max="9" required class="otp-input">
            <input type="number" name="otp2" min="0" max="9" required class="otp-input">
            <input type="number" name="otp3" min="0" max="9" required class="otp-input">
            <input type="number" name="otp4" min="0" max="9" required class="otp-input">
            <input type="number" name="otp5" min="0" max="9" required class="otp-input">
            <input type="number" name="otp6" min="0" max="9" required class="otp-input">
        </div>
        <button type="submit" class="btn-primary">Xác nhận</button>
    </form>

    <div class="resend-wrap">
        <form action="${pageContext.request.contextPath}/xac-thuc-thay-doi" method="post" style="display:inline;">
            <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
            <input type="hidden" name="purpose" value="${purpose}">
            <input type="hidden" name="action" value="resend">
            <button type="submit" class="resend-btn">🔄 Gửi lại OTP</button>
        </form>
    </div>
</div>
<script>
    var inputs = document.querySelectorAll('.otp-input');
    inputs.forEach(function (input, index) {
        input.addEventListener('focus', function () { this.select(); });
        input.addEventListener('input', function () {
            if (this.value.length > 1) this.value = this.value.slice(0, 1);
            if (this.value !== '' && index < inputs.length - 1) inputs[index + 1].focus();
        });
        input.addEventListener('keydown', function (e) {
            if (e.key === 'Backspace' && this.value === '' && index > 0) inputs[index - 1].focus();
        });
    });
    if (inputs.length > 0) inputs[0].focus();
</script>
</body>
</html>
