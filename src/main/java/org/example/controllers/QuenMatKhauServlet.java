package org.example.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.example.daos.AccountDAO;
import org.example.daos.AccountDAOImpl;
import org.example.services.AuditLogService;
import org.example.utils.AuditModules;
import org.example.utils.EmailUtil;
import org.example.utils.RateLimitUtil;
import org.mindrot.jbcrypt.BCrypt;

import javax.mail.MessagingException;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.SecureRandom;

@WebServlet("/quenmatkhau")
public class QuenMatKhauServlet extends HttpServlet {
    private static final long OTP_TTL_MILLIS = 5 * 60 * 1000L;
    private static final int MAX_OTP_FAIL = 5;
    private static final int MAX_RESEND = 3;
    private static final long RESEND_WINDOW_MILLIS = 10 * 60 * 1000L;
    private static final long RESEND_LOCKOUT_MILLIS = 10 * 60 * 1000L;

    private final AuditLogService auditLogService = new AuditLogService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/quenmatkhau.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        String action = req.getParameter("action");

        if ("reset".equals(action)) {
            doiMatKhau(req, resp);
        } else {
            guiOtp(req, resp);
        }
    }
    private String buildResetPasswordEmail(String otp, String email) {
        return """
        <!DOCTYPE html>
        <html>
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Đặt lại mật khẩu</title>
        </head>
        <body style="margin:0;padding:0;font-family:'Segoe UI',Arial,sans-serif;background:#f4f7fb;">
            <table align="center" border="0" cellpadding="0" cellspacing="0" width="100%%" style="max-width:600px;margin:40px auto;background:#ffffff;border-radius:16px;box-shadow:0 8px 32px rgba(0,0,0,0.08);overflow:hidden;">
                <tr>
                    <td style="background:linear-gradient(135deg,#1a1a2e,#273053);padding:32px 40px;text-align:center;">
                        <h1 style="color:#ffffff;font-size:24px;font-weight:700;margin:0;letter-spacing:1px;">🔐 POB</h1>
                        <p style="color:rgba(255,255,255,0.6);font-size:13px;margin:6px 0 0;letter-spacing:2px;">HỆ THỐNG ĐẶT HÀNG</p>
                    </td>
                </tr>
                <tr>
                    <td style="padding:40px 40px 30px;">
                        <h2 style="color:#1a1a2e;font-size:20px;font-weight:600;margin:0 0 8px;">Đặt lại mật khẩu</h2>
                        <p style="color:#666;font-size:15px;line-height:1.6;margin:0 0 24px;">
                            Chào bạn,<br>
                            Chúng tôi nhận được yêu cầu đặt lại mật khẩu cho tài khoản của bạn.
                            Vui lòng nhập mã OTP dưới đây để hoàn tất.
                        </p>
                        
                        <div style="background:#f8f9fc;border-radius:12px;padding:28px;text-align:center;border:1px dashed #d1d5e5;margin-bottom:24px;">
                            <div style="font-size:11px;color:#888;text-transform:uppercase;letter-spacing:1.5px;margin-bottom:8px;">Mã xác thực (OTP)</div>
                            <div style="font-size:36px;font-weight:800;color:#273053;letter-spacing:8px;font-family:'Courier New',monospace;">%s</div>
                            <div style="font-size:12px;color:#999;margin-top:10px;">⏳ Hiệu lực trong <strong>5 phút</strong></div>
                        </div>
                        
                        <div style="background:#fef3c7;border-radius:8px;padding:14px 18px;border-left:4px solid #facc15;margin-bottom:24px;">
                            <p style="color:#92400e;font-size:13px;margin:0;">📧 Yêu cầu từ email: <strong>%s</strong></p>
                        </div>
                        
                        <p style="color:#888;font-size:13px;line-height:1.6;margin:0 0 8px;">
                            Nếu bạn không yêu cầu đặt lại mật khẩu, vui lòng bỏ qua email này và thông báo cho chúng tôi.
                        </p>
                        <p style="color:#aaa;font-size:12px;margin:0;">
                            Mã OTP có hiệu lực trong 5 phút. Không chia sẻ mã này với bất kỳ ai.
                        </p>
                    </td>
                </tr>
                <tr>
                    <td style="background:#f8f9fc;padding:20px 40px;text-align:center;border-top:1px solid #e9ecef;">
                        <p style="color:#999;font-size:12px;margin:0;">
                            © 2025 POB - Hệ thống đặt hàng<br>
                            <span style="color:#bbb;">Email này được gửi tự động, vui lòng không trả lời.</span>
                        </p>
                    </td>
                </tr>
            </table>
        </body>
        </html>
        """.formatted(otp, email);
    }



    private void guiOtp(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        AccountDAO dao = new AccountDAOImpl();
        String email = layGiaTri(req.getParameter("email"));

        if (email.isEmpty()) {
            req.setAttribute("loi", "Vui lòng nhập email!");
            req.getRequestDispatcher("/quenmatkhau.jsp").forward(req, resp);
            return;
        }

        // Rate-limit theo IP: PHAI ap dung TRUOC buoc kiem tra ton tai o duoi. Neu khong, ke tan
        // cong co the do email da dang ky khong gioi han (enumeration) vi buoc kiem tra ton tai
        // luon chay truoc va tra ve thong bao phan biet duoc ("Email chua duoc dang ky!").
        String resendKey = "forgototp:" + RateLimitUtil.getClientIp(req);
        if (RateLimitUtil.isBlocked(resendKey)) {
            req.setAttribute("loi", "Vui lòng đợi trước khi yêu cầu gửi lại OTP.");
            req.getRequestDispatcher("/quenmatkhau.jsp").forward(req, resp);
            return;
        }
        boolean resendJustLocked = RateLimitUtil.recordFailure(resendKey, MAX_RESEND, RESEND_WINDOW_MILLIS, RESEND_LOCKOUT_MILLIS);
        if (resendJustLocked) {
            auditLogService.log(req, null, "Khoá gửi lại OTP quên mật khẩu (rate limit)", AuditModules.SECURITY,
                    "IP " + RateLimitUtil.getClientIp(req) + " bị khoá gửi lại OTP quên mật khẩu tạm thời sau " + MAX_RESEND
                            + " lần gửi liên tiếp, email: " + email,
                    null, "Account");
        }

        if (!dao.tonTaiEmail(email)) {
            req.setAttribute("loi", "Email chưa được đăng ký!");
            req.getRequestDispatcher("/quenmatkhau.jsp").forward(req, resp);
            return;
        }

        String otp = String.format("%06d", new SecureRandom().nextInt(1000000));
        try {
            // ✅ Gửi email HTML thay vì plain text
            String htmlContent = buildResetPasswordEmail(otp, email);
            EmailUtil.sendEmail(email, "🔑 Đặt lại mật khẩu POB", htmlContent);
        } catch (MessagingException e) {
            req.setAttribute("loi", "Không thể gửi email, vui lòng thử lại!");
            req.getRequestDispatcher("/quenmatkhau.jsp").forward(req, resp);
            return;
        }

        HttpSession session = req.getSession();
        session.setAttribute("forgotPasswordEmail", email);
        session.setAttribute("forgotPasswordOtp", otp);
        session.removeAttribute("forgotPasswordOtpFailCount");

        session.setAttribute("forgotPasswordOtpExpiredAt", System.currentTimeMillis() + OTP_TTL_MILLIS);


        hienThiFormDoiMatKhau(req, resp, "Mã OTP đã được gửi tới email của bạn.", null);
    }

    private void doiMatKhau(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null
                || session.getAttribute("forgotPasswordEmail") == null
                || session.getAttribute("forgotPasswordOtp") == null) {
            req.setAttribute("loi", "Phiên đặt lại mật khẩu đã hết hạn, vui lòng gửi OTP lại!");
            req.getRequestDispatcher("/quenmatkhau.jsp").forward(req, resp);
            return;
        }

        Long expiredAt = (Long) session.getAttribute("forgotPasswordOtpExpiredAt");
        if (expiredAt == null || System.currentTimeMillis() > expiredAt) {
            xoaSessionQuenMatKhau(session);
            req.setAttribute("loi", "OTP đã hết hạn, vui lòng gửi OTP lại!");
            req.getRequestDispatcher("/quenmatkhau.jsp").forward(req, resp);
            return;
        }

        String otp = layGiaTri(req.getParameter("otp"));
        String password = layGiaTri(req.getParameter("password"));
        String confirmPassword = layGiaTri(req.getParameter("confirm_password"));

        if (otp.isEmpty() || password.isEmpty() || confirmPassword.isEmpty()) {
            hienThiFormDoiMatKhau(req, resp, null, "Vui lòng nhập đầy đủ thông tin!");
            return;
        }

        if (!password.equals(confirmPassword)) {
            hienThiFormDoiMatKhau(req, resp, null, "Mật khẩu xác nhận không khớp!");
            return;
        }

        String otpTrongSession = (String) session.getAttribute("forgotPasswordOtp");
        if (!MessageDigest.isEqual(otpTrongSession.getBytes(StandardCharsets.UTF_8), otp.getBytes(StandardCharsets.UTF_8))) {
            int failCount = 1;
            Object failCountObj = session.getAttribute("forgotPasswordOtpFailCount");
            if (failCountObj instanceof Integer) {
                failCount = (Integer) failCountObj + 1;
            }
            if (failCount >= MAX_OTP_FAIL) {
                String failEmail = (String) session.getAttribute("forgotPasswordEmail");
                auditLogService.log(req, null, "Khoá xác nhận OTP quên mật khẩu (nhập sai quá nhiều lần)", AuditModules.SECURITY,
                        "IP " + RateLimitUtil.getClientIp(req) + " nhập sai OTP quên mật khẩu " + failCount
                                + " lần liên tiếp, email: " + failEmail,
                        null, "Account");
                xoaSessionQuenMatKhau(session);
                req.setAttribute("loi", "Bạn đã nhập sai quá nhiều lần, vui lòng gửi lại OTP.");
                req.getRequestDispatcher("/quenmatkhau.jsp").forward(req, resp);
                return;
            }
            session.setAttribute("forgotPasswordOtpFailCount", failCount);
            hienThiFormDoiMatKhau(req, resp, null, "OTP không đúng!");
            return;
        }

        String email = (String) session.getAttribute("forgotPasswordEmail");
        String matKhauMaHoa = BCrypt.hashpw(password, BCrypt.gensalt(12));
        AccountDAO dao = new AccountDAOImpl();

        if (dao.capNhatMatKhauTheoEmail(email, matKhauMaHoa)) {
            xoaSessionQuenMatKhau(session);
            req.setAttribute("thongbao", "Đổi mật khẩu thành công, vui lòng đăng nhập.");
            req.getRequestDispatcher("/DangNhap.jsp").forward(req, resp);
        } else {
            hienThiFormDoiMatKhau(req, resp, null, "Không thể đổi mật khẩu, vui lòng thử lại!");
        }
    }

    private void hienThiFormDoiMatKhau(HttpServletRequest req, HttpServletResponse resp, String thongbao, String loi)
            throws ServletException, IOException {
        req.setAttribute("step", "reset");
        if (thongbao != null) {
            req.setAttribute("thongbao", thongbao);
        }
        if (loi != null) {
            req.setAttribute("loi", loi);
        }
        req.getRequestDispatcher("/quenmatkhau.jsp").forward(req, resp);
    }

    private void xoaSessionQuenMatKhau(HttpSession session) {
        session.removeAttribute("forgotPasswordEmail");
        session.removeAttribute("forgotPasswordOtp");
        session.removeAttribute("forgotPasswordOtpExpiredAt");
        session.removeAttribute("forgotPasswordOtpFailCount");
    }

    private String layGiaTri(String value) {
        return value == null ? "" : value.trim();
    }
}


