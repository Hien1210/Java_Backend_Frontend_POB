package org.example.utils;

import jakarta.servlet.http.HttpSession;

import javax.mail.MessagingException;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.SecureRandom;
import java.util.HashMap;
import java.util.Map;

/**
 * OTP dung chung de xac thuc lai (re-auth) khi mot tai khoan DANG DANG NHAP doi thong tin nhay
 * cam (email, thong tin ngan hang nhan tien...). Khac voi OTP dang ky (XacNhanOTPServlet) vi day
 * khong tao tai khoan moi ma chi xac nhan thay doi tren tai khoan da ton tai - luu tam du lieu
 * moi vao session duoi 1 "purpose" rieng (vd "shop_bank", "admin_profile") cho toi khi xac thuc
 * OTP xong moi thuc su ghi xuong DB.
 */
public final class SensitiveInfoOtpUtil {

    private static final long OTP_TTL_MILLIS = 5 * 60 * 1000L;
    private static final int MAX_FAIL = 5;

    private SensitiveInfoOtpUtil() {
    }

    public enum VerifyResult { OK, WRONG, EXPIRED, LOCKED, NOT_FOUND }

    public static void generateAndSend(HttpSession session, String purpose, String sendToEmail,
                                        Map<String, String> pendingData) throws MessagingException {
        String otp = String.format("%06d", new SecureRandom().nextInt(1_000_000));
        session.setAttribute(key(purpose, "otp"), otp);
        session.setAttribute(key(purpose, "exp"), System.currentTimeMillis() + OTP_TTL_MILLIS);
        session.setAttribute(key(purpose, "fail"), 0);
        session.setAttribute(key(purpose, "data"), new HashMap<>(pendingData));
        session.setAttribute(key(purpose, "email"), sendToEmail);

        try {
            EmailUtil.sendEmail(sendToEmail, "Mã OTP xác nhận thay đổi thông tin - POB Food", buildOtpEmail(otp));
        } catch (java.io.UnsupportedEncodingException e) {
            throw new MessagingException("Loi encode email", e);
        }
    }

    public static VerifyResult verify(HttpSession session, String purpose, String inputOtp) {
        Object otpObj = session.getAttribute(key(purpose, "otp"));
        if (otpObj == null) return VerifyResult.NOT_FOUND;

        Long exp = (Long) session.getAttribute(key(purpose, "exp"));
        if (exp == null || System.currentTimeMillis() > exp) {
            clear(session, purpose);
            return VerifyResult.EXPIRED;
        }

        if (inputOtp != null && MessageDigest.isEqual(
                otpObj.toString().getBytes(StandardCharsets.UTF_8),
                inputOtp.getBytes(StandardCharsets.UTF_8))) {
            return VerifyResult.OK;
        }

        int fail = 1;
        Object failObj = session.getAttribute(key(purpose, "fail"));
        if (failObj instanceof Integer) fail = (Integer) failObj + 1;
        if (fail >= MAX_FAIL) {
            clear(session, purpose);
            return VerifyResult.LOCKED;
        }
        session.setAttribute(key(purpose, "fail"), fail);
        return VerifyResult.WRONG;
    }

    @SuppressWarnings("unchecked")
    public static Map<String, String> getPendingData(HttpSession session, String purpose) {
        Object data = session.getAttribute(key(purpose, "data"));
        return data instanceof Map ? (Map<String, String>) data : null;
    }

    public static String getPendingEmail(HttpSession session, String purpose) {
        Object email = session.getAttribute(key(purpose, "email"));
        return email == null ? null : email.toString();
    }

    public static void clear(HttpSession session, String purpose) {
        session.removeAttribute(key(purpose, "otp"));
        session.removeAttribute(key(purpose, "exp"));
        session.removeAttribute(key(purpose, "fail"));
        session.removeAttribute(key(purpose, "data"));
        session.removeAttribute(key(purpose, "email"));
    }

    private static String key(String purpose, String suffix) {
        return "sotp_" + purpose + "_" + suffix;
    }

    private static String buildOtpEmail(String otp) {
        return """
                <!DOCTYPE html>
                <html>
                <head><meta charset="UTF-8"><title>Xác nhận OTP</title></head>
                <body style="margin:0;padding:0;font-family:'Segoe UI',Arial,sans-serif;background:#f4f7fb;">
                    <table align="center" border="0" cellpadding="0" cellspacing="0" width="100%%" style="max-width:600px;margin:40px auto;background:#ffffff;border-radius:16px;box-shadow:0 8px 32px rgba(0,0,0,0.08);overflow:hidden;">
                        <tr>
                            <td style="background:linear-gradient(135deg,#1a1a2e,#273053);padding:32px 40px;text-align:center;">
                                <h1 style="color:#ffffff;font-size:24px;font-weight:700;margin:0;">🍔 POB</h1>
                                <p style="color:rgba(255,255,255,0.6);font-size:13px;margin:6px 0 0;">XÁC THỰC THAY ĐỔI THÔNG TIN</p>
                            </td>
                        </tr>
                        <tr>
                            <td style="padding:40px 40px 30px;">
                                <h2 style="color:#1a1a2e;font-size:20px;margin:0 0 8px;">Xác nhận thay đổi thông tin</h2>
                                <p style="color:#666;font-size:15px;line-height:1.6;margin:0 0 24px;">
                                    Bạn (hoặc ai đó đang đăng nhập vào tài khoản của bạn) vừa yêu cầu thay đổi thông tin nhạy cảm
                                    (email hoặc thông tin ngân hàng nhận tiền). Nhập mã bên dưới để xác nhận.<br>
                                    <strong>Nếu bạn không yêu cầu điều này, vui lòng bỏ qua email và đổi mật khẩu ngay.</strong>
                                </p>
                                <div style="background:#f8f9fc;border-radius:12px;padding:28px;text-align:center;border:1px dashed #d1d5e5;margin-bottom:24px;">
                                    <div style="font-size:11px;color:#888;text-transform:uppercase;letter-spacing:1.5px;margin-bottom:8px;">Mã xác thực (OTP)</div>
                                    <div style="font-size:36px;font-weight:800;color:#273053;letter-spacing:8px;font-family:'Courier New',monospace;">%s</div>
                                    <div style="font-size:12px;color:#999;margin-top:10px;">⏳ Hiệu lực trong <strong>5 phút</strong></div>
                                </div>
                            </td>
                        </tr>
                    </table>
                </body>
                </html>
                """.formatted(otp);
    }
}
