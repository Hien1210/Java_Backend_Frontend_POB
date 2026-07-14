<%@ page pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký - POB</title>
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
        .error-inline { color: #dc2626; font-size: 11px; margin-top: 3px; display: block; }

        .role-btn {
            flex: 1; text-align: center;
            border: 1.5px solid #e2e8f0;
            border-radius: 10px;
            padding: 10px 8px;
            font-size: 12px;
            font-weight: 600;
            color: #64748b;
            background: #f8fafc;
            text-decoration: none;
            transition: all 0.2s;
            display: block;
        }
        .role-btn:hover { border-color: #3b5bdb; color: #3b5bdb; background: #eff3ff; }

        /* Right panel steps */
        .step-item {
            display: flex; align-items: flex-start; gap: 12px;
            padding: 14px 0;
            border-bottom: 1px solid rgba(255,255,255,0.07);
        }
        .step-item:last-child { border-bottom: none; }
        .step-num {
            width: 28px; height: 28px; border-radius: 8px;
            background: rgba(255,255,255,0.1);
            display: flex; align-items: center; justify-content: center;
            font-size: 13px; font-weight: 700; color: #f4dcb7;
            flex-shrink: 0;
        }

        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(24px) scale(0.97); }
            to   { opacity: 1; transform: translateY(0) scale(1); }
        }
        .animate-in { animation: fadeInUp 0.45s ease-out forwards; }

        .form-scroll::-webkit-scrollbar { width: 4px; }
        .form-scroll::-webkit-scrollbar-track { background: transparent; }
        .form-scroll::-webkit-scrollbar-thumb { background: #e2e8f0; border-radius: 10px; }
    </style>
</head>

<body class="flex items-center justify-center min-h-screen p-4">

    <div class="card-wrap flex w-full max-w-[1020px] rounded-2xl overflow-hidden shadow-2xl animate-in">

        <!-- ===== LEFT: FORM ===== -->
        <div class="form-scroll w-full md:w-[45%] bg-white flex flex-col px-9 py-8 overflow-y-auto"
             style="max-height: 95vh;">

            <!-- Logo -->
            <div class="flex items-center gap-3 mb-6">
                <div class="w-10 h-10 rounded-xl flex items-center justify-center text-white font-extrabold text-base"
                     style="background: linear-gradient(135deg,#273155,#3d4f7c);">POB</div>
                <div>
                    <p class="text-xs font-semibold text-gray-400 uppercase tracking-widest">Hệ thống đặt hàng</p>
                </div>
            </div>

            <!-- Title -->
            <div class="mb-5">
                <h1 class="text-2xl font-extrabold text-[#1e293b] mb-1">Tạo tài khoản 🎉</h1>
                <p class="text-sm text-gray-500">Đăng ký để bắt đầu trải nghiệm POB</p>
            </div>

            <!-- Error -->
            <% if (request.getAttribute("loi") != null && !((String)request.getAttribute("loi")).isEmpty()) { %>
                <div class="error-box mb-4">
                    <svg width="15" height="15" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
                    <%= request.getAttribute("loi") %>
                </div>
            <% } %>

            <!-- Form -->
            <form action="${pageContext.request.contextPath}/dangky" method="post"
                  onsubmit="return validatePassword()" class="flex flex-col gap-3">

                <input type="hidden" name="role_id" value="3">

                <!-- Row: Họ tên + SĐT -->
                <div class="grid grid-cols-2 gap-3">
                    <div>
                        <label class="field-label">Họ và tên</label>
                        <div class="relative">
                            <svg class="field-icon" width="15" height="15" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/></svg>
                            <input type="text" name="fullname" value="${not empty fullname ? fullname : param.fullname}" required
                                   placeholder="Nguyễn Văn A" class="input-field">
                        </div>
                    </div>
                    <div>
                        <label class="field-label">Số điện thoại</label>
                        <div class="relative">
                            <svg class="field-icon" width="15" height="15" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 5a2 2 0 012-2h3.28a1 1 0 01.948.684l1.498 4.493a1 1 0 01-.502 1.21l-2.257 1.13a11.042 11.042 0 005.516 5.516l1.13-2.257a1 1 0 011.21-.502l4.493 1.498a1 1 0 01.684.949V19a2 2 0 01-2 2h-1C9.716 21 3 14.284 3 6V5z"/></svg>
                            <input type="tel" name="phone" value="${not empty phone ? phone : param.phone}" required
                                   placeholder="0901 234 567" class="input-field">
                        </div>
                    </div>
                </div>

                <!-- Username -->
                <div>
                    <label class="field-label">Tên đăng nhập</label>
                    <div class="relative">
                        <svg class="field-icon" width="15" height="15" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 6H5a2 2 0 00-2 2v9a2 2 0 002 2h14a2 2 0 002-2V8a2 2 0 00-2-2h-5m-4 0V5a2 2 0 114 0v1m-4 0a2 2 0 104 0m-5 8a2 2 0 100-4 2 2 0 000 4zm0 0c1.306 0 2.417.835 2.83 2M9 14a3.001 3.001 0 00-2.83 2M15 11h3m-3 4h2"/></svg>
                        <input type="text" name="username" value="${not empty username ? username : param.username}" required
                               placeholder="Tên đăng nhập duy nhất" class="input-field">
                    </div>
                </div>

                <!-- Email -->
                <div>
                    <label class="field-label">Email</label>
                    <div class="relative">
                        <svg class="field-icon" width="15" height="15" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"/></svg>
                        <input type="email" name="email" value="${not empty email ? email : param.email}" required
                               placeholder="email@example.com" class="input-field">
                    </div>
                </div>

                <!-- Row: Mật khẩu + Xác nhận -->
                <div class="grid grid-cols-2 gap-3">
                    <div>
                        <label class="field-label">Mật khẩu</label>
                        <div class="relative">
                            <svg class="field-icon" width="15" height="15" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"/></svg>
                            <input type="password" name="password" id="password" required
                                   placeholder="8–16 ký tự" class="input-field" style="padding-right:36px;">
                            <button type="button" onclick="togglePassword('password', this)" class="field-icon-right">
                                <svg class="eye-show w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"/></svg>
                                <svg class="eye-hide w-4 h-4 hidden" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13.875 18.825A10.05 10.05 0 0112 19c-4.478 0-8.268-2.943-9.543-7a9.97 9.97 0 011.563-3.029m5.858.908a3 3 0 114.243 4.243M9.878 9.878l4.242 4.242M9.88 9.88l-3.29-3.29m7.532 7.532l3.29 3.29M3 3l3.59 3.59m0 0A9.953 9.953 0 0112 5c4.478 0 8.268 2.943 9.543 7a10.025 10.025 0 01-4.132 5.411m0 0L21 21"/></svg>
                            </button>
                        </div>
                    </div>
                    <div>
                        <label class="field-label">Xác nhận mật khẩu</label>
                        <div class="relative">
                            <svg class="field-icon" width="15" height="15" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z"/></svg>
                            <input type="password" name="confirm_password" id="confirm_password" required
                                   placeholder="Nhập lại mật khẩu" class="input-field" style="padding-right:36px;">
                            <button type="button" onclick="togglePassword('confirm_password', this)" class="field-icon-right">
                                <svg class="eye-show w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"/></svg>
                                <svg class="eye-hide w-4 h-4 hidden" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13.875 18.825A10.05 10.05 0 0112 19c-4.478 0-8.268-2.943-9.543-7a9.97 9.97 0 011.563-3.029m5.858.908a3 3 0 114.243 4.243M9.878 9.878l4.242 4.242M9.88 9.88l-3.29-3.29m7.532 7.532l3.29 3.29M3 3l3.59 3.59m0 0A9.953 9.953 0 0112 5c4.478 0 8.268 2.943 9.543 7a10.025 10.025 0 01-4.132 5.411m0 0L21 21"/></svg>
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Error inline -->
                <span id="passwordError" class="error-inline"></span>

                <!-- Submit -->
                <button type="submit" class="btn-submit mt-1">Đăng ký khách hàng</button>

                <!-- Login link -->
                <p class="text-center text-xs text-gray-500">
                    Đã có tài khoản?
                    <a href="${pageContext.request.contextPath}/dangnhap"
                       class="text-[#273155] font-bold hover:underline">Đăng nhập ngay</a>
                </p>
            </form>

            <!-- Other roles -->
            <div class="mt-4 pt-4 border-t border-gray-100">
                <p class="text-center text-[10px] font-semibold text-gray-400 uppercase tracking-widest mb-3">
                    Đăng ký theo vai trò khác
                </p>
                <div class="flex gap-3">
                    <a href="${pageContext.request.contextPath}/dangky-shop" class="role-btn">🏪 Shop</a>
                    <a href="${pageContext.request.contextPath}/dangky-shipper" class="role-btn">🛵 Shipper</a>
                </div>
            </div>
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
                    Tham gia POB<br>ngay hôm nay,<br>
                    <span style="color: #f4dcb7;">hoàn toàn miễn phí.</span>
                </h2>
                <p class="text-white/50 text-sm leading-relaxed mb-8">
                    Chỉ mất 1 phút để tạo tài khoản và bắt đầu đặt hàng.
                </p>

                <div>
                    <div class="step-item">
                        <div class="step-num">1</div>
                        <div>
                            <p class="text-white font-semibold text-sm">Tạo tài khoản</p>
                            <p class="text-white/45 text-xs mt-0.5">Điền thông tin và xác nhận email OTP</p>
                        </div>
                    </div>
                    <div class="step-item">
                        <div class="step-num">2</div>
                        <div>
                            <p class="text-white font-semibold text-sm">Khám phá cửa hàng</p>
                            <p class="text-white/45 text-xs mt-0.5">Duyệt qua hàng trăm món ăn hấp dẫn</p>
                        </div>
                    </div>
                    <div class="step-item">
                        <div class="step-num">3</div>
                        <div>
                            <p class="text-white font-semibold text-sm">Đặt hàng & thưởng thức</p>
                            <p class="text-white/45 text-xs mt-0.5">Giao hàng nhanh, thanh toán linh hoạt</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Bottom -->
            <p class="text-white/25 text-xs">© 2025 POB — All rights reserved</p>
        </div>

    </div>

    <script>
        function validatePassword() {
            var password = document.getElementById("password").value.trim();
            var confirm = document.getElementById("confirm_password").value.trim();
            var errorMsg = document.getElementById("passwordError");
            if (!password) { errorMsg.textContent = "⚠️ Mật khẩu không được để trống!"; return false; }
            if (password.length < 8 || password.length > 16) { errorMsg.textContent = "⚠️ Mật khẩu phải từ 8 đến 16 ký tự!"; return false; }
            if (password.includes(" ")) { errorMsg.textContent = "⚠️ Mật khẩu không được chứa khoảng trắng!"; return false; }
            if (password !== confirm) { errorMsg.textContent = "⚠️ Mật khẩu xác nhận không khớp!"; return false; }
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
</body>
</html>
