<%@ page pageEncoding="utf-8"%>
<%
    String emailGui = null;
    if (session.getAttribute("email") != null) {
        emailGui = (String) session.getAttribute("email");
    } else if (session.getAttribute("forgotPasswordEmail") != null) {
        emailGui = (String) session.getAttribute("forgotPasswordEmail");
    }
    String emailAn = "";
    if (emailGui != null && !emailGui.isEmpty()) {
        int atIndex = emailGui.indexOf("@");
        if (atIndex > 3) {
            emailAn = emailGui.substring(0, 3) + "***" + emailGui.substring(atIndex);
        } else if (atIndex > 0) {
            emailAn = emailGui.substring(0, 1) + "***" + emailGui.substring(atIndex);
        } else {
            emailAn = emailGui;
        }
    }
    String loi  = (String) request.getAttribute("loi");
    boolean coLoi = (loi != null && !loi.isEmpty());
    boolean daGuiLai = "1".equals(request.getParameter("resent"));
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Xác nhận OTP - POB</title>
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

        /* OTP inputs */
        .otp-input {
            width: 48px;
            height: 58px;
            border: 1.5px solid #e2e8f0;
            border-radius: 12px;
            font-size: 24px;
            font-weight: 800;
            text-align: center;
            color: #1e293b;
            background: #f8fafc;
            outline: none;
            transition: border-color 0.2s, box-shadow 0.2s, background 0.2s;
            -moz-appearance: textfield;
        }
        .otp-input::-webkit-inner-spin-button,
        .otp-input::-webkit-outer-spin-button { -webkit-appearance: none; margin: 0; }
        .otp-input:focus {
            border-color: #3b5bdb;
            background: #fff;
            box-shadow: 0 0 0 3px rgba(59,91,219,0.12);
        }
        .otp-input.error {
            border-color: #ef4444;
            background: #fff5f5;
            box-shadow: 0 0 0 3px rgba(239,68,68,0.1);
        }

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
            transition: opacity 0.2s, transform 0.15s;
            box-shadow: 0 4px 14px rgba(39,49,85,0.35);
        }
        .btn-submit:hover { opacity: 0.92; transform: translateY(-1px); }
        .btn-submit:active { transform: translateY(0); }

        /* Right panel */
        .info-item {
            display: flex; align-items: flex-start; gap: 12px;
            padding: 14px 0;
            border-bottom: 1px solid rgba(255,255,255,0.07);
        }
        .info-item:last-child { border-bottom: none; }
        .info-icon {
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

        @keyframes shake {
            0%,100%{transform:translateX(0)} 20%{transform:translateX(-6px)}
            40%{transform:translateX(6px)}  60%{transform:translateX(-4px)}
            80%{transform:translateX(4px)}
        }
        .shake { animation: shake 0.4s ease-out; }
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
                <p class="text-xs font-semibold text-gray-400 uppercase tracking-widest">Hệ thống đặt hàng</p>
            </div>

            <!-- Title -->
            <div class="mb-6">
                <h1 class="text-2xl font-extrabold text-[#1e293b] mb-1">Xác nhận OTP</h1>
                <p class="text-sm text-gray-500">Nhập mã 6 số đã được gửi đến email của bạn.</p>
            </div>

            <!-- Email notice -->
            <% if (!emailAn.isEmpty()) { %>
            <div class="flex items-center gap-2 bg-[#f0fdf4] border border-[#bbf7d0] rounded-xl px-4 py-3 mb-5">
                <svg width="16" height="16" fill="none" viewBox="0 0 24 24" stroke="#16a34a"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"/></svg>
                <p class="text-xs text-green-700 font-medium">Mã OTP đã gửi đến <strong><%= emailAn %></strong></p>
            </div>
            <% } %>

            <!-- Resent success -->
            <% if (daGuiLai) { %>
            <div class="flex items-center gap-2 bg-[#eff6ff] border border-[#bfdbfe] rounded-xl px-4 py-3 mb-5">
                <svg width="16" height="16" fill="none" viewBox="0 0 24 24" stroke="#2563eb"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
                <p class="text-xs text-blue-700 font-medium">Mã OTP mới đã được gửi lại vào email của bạn.</p>
            </div>
            <% } %>

            <!-- Error -->
            <% if (coLoi) { %>
            <div id="errorBox" class="flex items-center gap-2 bg-[#fef2f2] border border-[#fecaca] rounded-xl px-4 py-3 mb-5 shake">
                <svg width="16" height="16" fill="none" viewBox="0 0 24 24" stroke="#dc2626"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
                <p class="text-xs text-red-600 font-medium"><%= loi %></p>
            </div>
            <% } %>

            <!-- OTP Form -->
            <form action="${pageContext.request.contextPath}/xacnhanotp" method="post" id="otpForm">
                <div class="flex justify-center gap-3 mb-6">
                    <input type="number" name="otp1" min="0" max="9" required
                           class="otp-input <%= coLoi ? "error" : "" %>">
                    <input type="number" name="otp2" min="0" max="9" required
                           class="otp-input <%= coLoi ? "error" : "" %>">
                    <input type="number" name="otp3" min="0" max="9" required
                           class="otp-input <%= coLoi ? "error" : "" %>">
                    <input type="number" name="otp4" min="0" max="9" required
                           class="otp-input <%= coLoi ? "error" : "" %>">
                    <input type="number" name="otp5" min="0" max="9" required
                           class="otp-input <%= coLoi ? "error" : "" %>">
                    <input type="number" name="otp6" min="0" max="9" required
                           class="otp-input <%= coLoi ? "error" : "" %>">
                </div>

                <button type="submit" class="btn-submit">Xác nhận</button>
            </form>

            <!-- Resend OTP -->
            <form action="${pageContext.request.contextPath}/xacnhanotp" method="post" class="mt-4 text-center">
                <input type="hidden" name="action" value="resend">
                <button type="submit" id="btnResend"
                        class="text-xs font-semibold text-[#273155] hover:underline disabled:opacity-40 disabled:cursor-not-allowed disabled:no-underline"
                        <%= daGuiLai ? "disabled" : "" %>>
                    🔄 Gửi lại OTP<span id="countdownText"></span>
                </button>
            </form>

            <!-- Back -->
            <div class="text-center mt-4 pt-4 border-t border-gray-100">
                <a href="${pageContext.request.contextPath}/dangky"
                   class="text-xs text-[#273155] font-bold hover:underline">← Quay lại đăng ký</a>
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
                    Bảo mật tài khoản<br>bằng xác thực<br>
                    <span style="color: #f4dcb7;">hai bước.</span>
                </h2>
                <p class="text-white/50 text-sm leading-relaxed mb-8">
                    Mã OTP giúp đảm bảo chỉ bạn mới có thể tạo tài khoản với email này.
                </p>

                <div>
                    <div class="info-item">
                        <div class="info-icon">📧</div>
                        <div>
                            <p class="text-white font-semibold text-sm">Kiểm tra email</p>
                            <p class="text-white/45 text-xs mt-0.5">Mã OTP 6 số gửi vào hộp thư của bạn</p>
                        </div>
                    </div>
                    <div class="info-item">
                        <div class="info-icon">⏱️</div>
                        <div>
                            <p class="text-white font-semibold text-sm">Có hiệu lực 5 phút</p>
                            <p class="text-white/45 text-xs mt-0.5">Nhập mã trước khi hết thời gian hiệu lực</p>
                        </div>
                    </div>
                    <div class="info-item">
                        <div class="info-icon">🔒</div>
                        <div>
                            <p class="text-white font-semibold text-sm">Không chia sẻ mã</p>
                            <p class="text-white/45 text-xs mt-0.5">POB sẽ không bao giờ hỏi mã OTP của bạn</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Bottom -->
            <p class="text-white/25 text-xs">© 2025 POB — All rights reserved</p>
        </div>

    </div>

    <script>
        const inputs = document.querySelectorAll('.otp-input');

        inputs.forEach((input, index) => {
            input.addEventListener('focus', function() {
                this.classList.remove('error');
                this.select();
            });

            input.addEventListener('input', function() {
                if (this.value.length > 1) this.value = this.value.slice(0, 1);
                if (this.value !== '' && index < inputs.length - 1) {
                    inputs[index + 1].focus();
                }
            });

            input.addEventListener('keydown', function(e) {
                if (e.key === 'Backspace' && this.value === '' && index > 0) {
                    inputs[index - 1].focus();
                }
            });
        });

        // Auto-focus ô đầu tiên
        if (inputs.length > 0) inputs[0].focus();

        // Countdown cho nút Gửi lại OTP
        const btnResend = document.getElementById('btnResend');
        const countdownText = document.getElementById('countdownText');
        const justResent = <%= daGuiLai %>;

        function startCountdown(seconds) {
            btnResend.disabled = true;
            let remaining = seconds;
            countdownText.textContent = ' (' + remaining + 's)';
            const timer = setInterval(() => {
                remaining--;
                if (remaining <= 0) {
                    clearInterval(timer);
                    btnResend.disabled = false;
                    countdownText.textContent = '';
                } else {
                    countdownText.textContent = ' (' + remaining + 's)';
                }
            }, 1000);
        }

        if (justResent) {
            startCountdown(60);
        }
    </script>
</body>
</html>
