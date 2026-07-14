<%@ page pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập - POB</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        * { font-family: 'Inter', sans-serif; }

        body {
            background: #0f172a;
            background-image: url(/image.png);
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
        }
        body::before {
            content: '';
            position: fixed;
            inset: 0;
            background: rgba(10, 15, 35, 0.65);
            backdrop-filter: blur(2px);
            z-index: 0;
        }
        .card-wrap { position: relative; z-index: 1; }

        .field-label {
            display: block;
            font-size: 11px;
            font-weight: 600;
            color: #64748b;
            margin-bottom: 5px;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }
        .input-field {
            width: 100%;
            background: #f8fafc;
            border: 1.5px solid #e2e8f0;
            border-radius: 10px;
            padding: 10px 14px 10px 40px;
            font-size: 13px;
            color: #1e293b;
            font-weight: 500;
            outline: none;
            transition: border-color 0.2s, box-shadow 0.2s, background 0.2s;
        }
        .input-field:focus {
            border-color: #3b5bdb;
            background: #fff;
            box-shadow: 0 0 0 3px rgba(59,91,219,0.1);
        }
        .input-field::placeholder { color: #94a3b8; font-weight: 400; font-size: 12px; }

        input:-webkit-autofill {
            -webkit-box-shadow: 0 0 0 30px #f8fafc inset !important;
        }

        .field-icon {
            position: absolute;
            left: 13px;
            bottom: 11px;
            color: #94a3b8;
            pointer-events: none;
        }
        .field-icon-right {
            position: absolute;
            right: 11px;
            bottom: 9px;
            background: none;
            border: none;
            cursor: pointer;
            color: #94a3b8;
            padding: 2px;
            transition: color 0.2s;
        }
        .field-icon-right:hover { color: #3b5bdb; }

        .btn-submit {
            width: 100%;
            background: linear-gradient(135deg, #273155 0%, #3d4f7c 100%);
            color: #fff;
            font-weight: 700;
            font-size: 13px;
            letter-spacing: 0.04em;
            padding: 12px;
            border-radius: 10px;
            border: none;
            cursor: pointer;
            transition: opacity 0.2s, transform 0.15s, box-shadow 0.2s;
            box-shadow: 0 4px 14px rgba(39,49,85,0.35);
        }
        .btn-submit:hover { opacity: 0.92; transform: translateY(-1px); }
        .btn-submit:active { transform: translateY(0); }

        .error-box {
            background: #fef2f2; border: 1px solid #fecaca; border-radius: 8px;
            padding: 9px 13px; color: #dc2626; font-size: 12px; font-weight: 500;
            display: flex; align-items: center; gap: 7px;
        }
        .success-box {
            background: #f0fdf4; border: 1px solid #bbf7d0; border-radius: 8px;
            padding: 9px 13px; color: #16a34a; font-size: 12px; font-weight: 500;
            display: flex; align-items: center; gap: 7px;
        }
        .error-inline { color: #dc2626; font-size: 11px; margin-top: 3px; display: block; }

        /* Right panel features */
        .feature-item {
            display: flex; align-items: flex-start; gap: 12px;
            padding: 14px 0;
            border-bottom: 1px solid rgba(255,255,255,0.07);
        }
        .feature-item:last-child { border-bottom: none; }
        .feature-icon {
            width: 36px; height: 36px; border-radius: 10px;
            background: rgba(255,255,255,0.1);
            display: flex; align-items: center; justify-content: center;
            font-size: 17px; flex-shrink: 0;
        }

        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(24px) scale(0.97); }
            to   { opacity: 1; transform: translateY(0) scale(1); }
        }
        .animate-in { animation: fadeInUp 0.45s ease-out forwards; }
    </style>
</head>

<body class="flex items-center justify-center min-h-screen p-4">

    <div class="card-wrap flex w-full max-w-[940px] rounded-2xl overflow-hidden shadow-2xl animate-in">

        <!-- ===== LEFT: FORM ===== -->
        <div class="w-full md:w-[45%] bg-white flex flex-col px-9 py-9">

            <!-- Logo -->
            <div class="flex items-center gap-3 mb-7">
                <div class="w-10 h-10 rounded-xl flex items-center justify-center text-white font-extrabold text-base"
                     style="background: linear-gradient(135deg,#273155,#3d4f7c);">POB</div>
                <div>
                    <p class="text-xs font-semibold text-gray-400 uppercase tracking-widest">Hệ thống đặt hàng</p>
                </div>
            </div>

            <!-- Title -->
            <div class="mb-6">
                <h1 class="text-2xl font-extrabold text-[#1e293b] mb-1">Đăng nhập</h1>
                <p class="text-sm text-gray-500">Chào mừng trở lại! Hãy đăng nhập để tiếp tục.</p>
            </div>

            <!-- Error / Success -->
            <% if (request.getAttribute("loi") != null && !((String)request.getAttribute("loi")).isEmpty()) { %>
                <div class="error-box mb-4">
                    <svg width="15" height="15" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
                    <%= request.getAttribute("loi") %>
                </div>
            <% } %>
            <% if (request.getAttribute("thongbao") != null && !((String)request.getAttribute("thongbao")).isEmpty()) { %>
                <div class="success-box mb-4">
                    <svg width="15" height="15" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
                    <%= request.getAttribute("thongbao") %>
                </div>
            <% } %>

            <!-- Form -->
            <form action="${pageContext.request.contextPath}/dangnhap" method="post"
                  onsubmit="return validateLogin()" class="flex flex-col gap-4">

                <!-- Username -->
                <div>
                    <label class="field-label">Tên đăng nhập</label>
                    <div class="relative">
                        <svg class="field-icon" width="15" height="15" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/></svg>
                        <input type="text" name="username" required
                               placeholder="Nhập tên đăng nhập" class="input-field">
                    </div>
                </div>

                <!-- Password -->
                <div>
                    <label class="field-label">Mật khẩu</label>
                    <div class="relative">
                        <svg class="field-icon" width="15" height="15" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"/></svg>
                        <input type="password" name="password" id="password" required
                               placeholder="Nhập mật khẩu" class="input-field" style="padding-right:36px;">
                        <button type="button" onclick="togglePassword('password', this)" class="field-icon-right">
                            <svg class="eye-show w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"/></svg>
                            <svg class="eye-hide w-4 h-4 hidden" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13.875 18.825A10.05 10.05 0 0112 19c-4.478 0-8.268-2.943-9.543-7a9.97 9.97 0 011.563-3.029m5.858.908a3 3 0 114.243 4.243M9.878 9.878l4.242 4.242M9.88 9.88l-3.29-3.29m7.532 7.532l3.29 3.29M3 3l3.59 3.59m0 0A9.953 9.953 0 0112 5c4.478 0 8.268 2.943 9.543 7a10.025 10.025 0 01-4.132 5.411m0 0L21 21"/></svg>
                        </button>
                    </div>
                    <span id="passwordError" class="error-inline"></span>
                </div>

                <!-- Forgot -->
                <div class="text-right -mt-2">
                    <a href="${pageContext.request.contextPath}/quenmatkhau"
                       class="text-xs text-[#273155] font-semibold hover:underline">Quên mật khẩu?</a>
                </div>

                <!-- Submit -->
                <button type="submit" class="btn-submit">Đăng nhập</button>

                <!-- Register link -->
                <p class="text-center text-xs text-gray-500">
                    Chưa có tài khoản?
                    <a href="${pageContext.request.contextPath}/dangky"
                       class="text-[#273155] font-bold hover:underline">Đăng ký ngay</a>
                </p>
            </form>
        </div>

        <!-- ===== RIGHT: DECORATIVE ===== -->
        <div class="hidden md:flex md:w-[55%] relative flex-col justify-between px-12 py-10"
             style="background: linear-gradient(150deg, #1a2744 0%, #273155 50%, #1e3a5f 100%);">

            <!-- Top brand -->
            <div class="flex items-center gap-3">
                <div class="w-9 h-9 rounded-lg bg-white/10 flex items-center justify-center text-white font-extrabold text-sm">POB</div>
                <span class="text-white/50 text-sm font-medium">Hệ thống đặt hàng trực tuyến</span>
            </div>

            <!-- Center -->
            <div>
                <h2 class="text-white text-4xl font-extrabold leading-tight mb-3">
                    Đặt hàng dễ dàng,<br>giao hàng nhanh chóng,<br>
                    <span style="color: #f4dcb7;">mọi lúc mọi nơi.</span>
                </h2>
                <p class="text-white/50 text-sm leading-relaxed mb-8">
                    Đăng nhập để tiếp tục trải nghiệm dịch vụ đặt hàng thông minh của POB.
                </p>

                <div>
                    <div class="feature-item">
                        <div class="feature-icon">🛒</div>
                        <div>
                            <p class="text-white font-semibold text-sm">Đặt hàng dễ dàng</p>
                            <p class="text-white/45 text-xs mt-0.5">Chọn món, đặt hàng chỉ với vài thao tác</p>
                        </div>
                    </div>
                    <div class="feature-item">
                        <div class="feature-icon">🚀</div>
                        <div>
                            <p class="text-white font-semibold text-sm">Giao hàng nhanh</p>
                            <p class="text-white/45 text-xs mt-0.5">Shipper xác nhận và giao hàng tận nơi</p>
                        </div>
                    </div>
                    <div class="feature-item">
                        <div class="feature-icon">📍</div>
                        <div>
                            <p class="text-white font-semibold text-sm">Theo dõi đơn hàng</p>
                            <p class="text-white/45 text-xs mt-0.5">Cập nhật trạng thái đơn hàng theo thời gian thực</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Bottom -->
            <p class="text-white/25 text-xs">© 2025 POB — All rights reserved</p>
        </div>

    </div>

    <script>
        function validateLogin() {
            var password = document.getElementById("password").value.trim();
            var errorMsg = document.getElementById("passwordError");
            if (!password) { errorMsg.textContent = "⚠️ Mật khẩu không được để trống!"; return false; }
            if (password.length < 8 || password.length > 16) { errorMsg.textContent = "⚠️ Mật khẩu phải từ 8 đến 16 ký tự!"; return false; }
            if (password.includes(" ")) { errorMsg.textContent = "⚠️ Mật khẩu không được chứa khoảng trắng!"; return false; }
            errorMsg.textContent = "";
            return true;
        }

        function togglePassword(id, btn) {
            var input = document.getElementById(id);
            var show = btn.querySelector('.eye-show');
            var hide = btn.querySelector('.eye-hide');
            if (input.type === 'password') {
                input.type = 'text';
                show.classList.add('hidden');
                hide.classList.remove('hidden');
            } else {
                input.type = 'password';
                show.classList.remove('hidden');
                hide.classList.add('hidden');
            }
        }
    </script>

<%-- POPUP TÀI KHOẢN BỊ ĐÌNH CHỈ --%>
<% if (Boolean.TRUE.equals(request.getAttribute("suspended"))) {
   String suspendReason = (String) request.getAttribute("suspendReason");
   if (suspendReason == null) suspendReason = "Vi phạm điều khoản sử dụng";
   Object accountIdObj = request.getAttribute("suspendedAccountId");
   long suspendedAccountId = accountIdObj != null ? ((Number) accountIdObj).longValue() : 0;
   boolean appealSent = "1".equals(request.getParameter("appealSent"));
   String appealError = request.getParameter("appealError");
%>
<style>
    .suspend-backdrop { position: fixed; inset: 0; background: rgba(0,0,0,0.6); backdrop-filter: blur(5px); display: flex; align-items: center; justify-content: center; z-index: 999; }
    .suspend-box { background: #fff; border-radius: 18px; padding: 36px 32px; max-width: 460px; width: 92%; box-shadow: 0 24px 64px rgba(0,0,0,0.25); animation: popIn 0.3s cubic-bezier(0.34,1.56,0.64,1); }
    @keyframes popIn { from { transform: scale(0.85); opacity: 0; } to { transform: scale(1); opacity: 1; } }
    .suspend-icon { font-size: 52px; text-align: center; margin-bottom: 14px; }
    .suspend-title { font-size: 20px; font-weight: 800; color: #dc2626; margin-bottom: 10px; text-align: center; }
    .suspend-reason-label { font-size: 11px; font-weight: 700; color: #9ca3af; text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 6px; }
    .suspend-reason-box { background: #fef2f2; border: 1px solid #fecaca; border-radius: 8px; padding: 11px 14px; font-size: 13px; color: #7f1d1d; font-weight: 500; line-height: 1.6; margin-bottom: 18px; }
    .suspend-desc { font-size: 13px; color: #6b7280; margin-bottom: 20px; line-height: 1.6; text-align: center; }
    .suspend-divider { border: none; border-top: 1px solid #e5e7eb; margin: 18px 0; }
    .appeal-section { }
    .appeal-title { font-size: 14px; font-weight: 700; color: #374151; margin-bottom: 8px; display: flex; align-items: center; gap: 6px; }
    .appeal-textarea { width: 100%; border: 1px solid #d1d5db; border-radius: 8px; padding: 10px 13px; font-size: 13px; color: #111827; font-family: inherit; resize: vertical; outline: none; min-height: 80px; transition: border 0.2s; }
    .appeal-textarea:focus { border-color: #3b82f6; box-shadow: 0 0 0 3px rgba(59,130,246,0.12); }
    .appeal-hint { font-size: 11px; color: #9ca3af; margin-top: 4px; margin-bottom: 14px; }
    .btn-row { display: flex; gap: 10px; }
    .btn-appeal { flex: 1; background: #3b82f6; color: #fff; border: none; border-radius: 10px; padding: 11px; font-size: 13px; font-weight: 700; cursor: pointer; transition: background 0.2s; }
    .btn-appeal:hover { background: #2563eb; }
    .btn-close { background: #f3f4f6; color: #6b7280; border: none; border-radius: 10px; padding: 11px 18px; font-size: 13px; font-weight: 600; cursor: pointer; }
    .btn-close:hover { background: #e5e7eb; }
    .appeal-success { background: #f0fdf4; border: 1px solid #86efac; border-radius: 8px; padding: 12px 14px; color: #166534; font-size: 13px; font-weight: 600; text-align: center; margin-bottom: 14px; }
    .appeal-error { background: #fef2f2; border: 1px solid #fecaca; border-radius: 8px; padding: 10px 14px; color: #dc2626; font-size: 13px; margin-bottom: 12px; }
</style>
<div class="suspend-backdrop" id="suspendModal">
    <div class="suspend-box">
        <div class="suspend-icon">🚫</div>
        <div class="suspend-title">Tài khoản bị đình chỉ</div>
        <div class="suspend-reason-label">Lý do</div>
        <div class="suspend-reason-box"><%= suspendReason %></div>
        <div class="suspend-desc">Tài khoản của bạn đã bị Admin tạm thời đình chỉ hoạt động.</div>

        <hr class="suspend-divider"/>

        <div class="appeal-section">
            <div class="appeal-title">📝 Gửi kháng nghị</div>

            <% if (appealSent) { %>
            <div class="appeal-success">✅ Kháng nghị của bạn đã được gửi! Admin sẽ xem xét sớm nhất có thể.</div>
            <button class="btn-close" style="width:100%;" onclick="document.getElementById('suspendModal').style.display='none'">Đóng</button>
            <% } else { %>

            <% if ("duplicate".equals(appealError)) { %>
            <div class="appeal-error">⚠️ Bạn đã có một kháng nghị đang chờ xử lý. Vui lòng chờ Admin phản hồi.</div>
            <% } else if (appealError != null) { %>
            <div class="appeal-error">⚠️ Có lỗi xảy ra. Vui lòng thử lại.</div>
            <% } %>

            <form method="post" action="<%= request.getContextPath() %>/appeal">
                <input type="hidden" name="accountId" value="<%= suspendedAccountId %>"/>
                <textarea class="appeal-textarea" name="message" required
                    placeholder="Mô tả lý do bạn cho rằng tài khoản bị đình chỉ nhầm..."></textarea>
                <div class="appeal-hint">Nội dung sẽ được gửi đến Admin để xem xét và xử lý.</div>
                <div class="btn-row">
                    <button type="button" class="btn-close" onclick="document.getElementById('suspendModal').style.display='none'">Đóng</button>
                    <button type="submit" class="btn-appeal">📨 Gửi kháng nghị</button>
                </div>
            </form>
            <% } %>
        </div>
    </div>
</div>
<% } %>

</body>
</html>
