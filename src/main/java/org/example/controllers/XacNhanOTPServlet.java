package org.example.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.example.daos.AccountDAO;
import org.example.daos.AccountDAOImpl;
import org.example.daos.ShipperProfileDAO;
import org.example.daos.ShipperProfileDAOImpl;
import org.example.models.Account;
import org.example.models.ShipperProfile;
import org.example.utils.EmailUtil;

import javax.mail.MessagingException;
import java.io.IOException;

@WebServlet("/xacnhanotp")
public class XacNhanOTPServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/nhapOTP.jsp").forward(req,resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        Object otpSession = session.getAttribute("otp");
        if (otpSession == null) {
            resp.sendRedirect(req.getContextPath() + "/dangky");
            return;
        }

        String action = req.getParameter("action");
        if ("resend".equals(action)) {
            String email = (String) session.getAttribute("email");
            if (email == null) {
                resp.sendRedirect(req.getContextPath() + "/dangky");
                return;
            }
            String newOtp = String.format("%06d", new java.security.SecureRandom().nextInt(1000000));
            session.setAttribute("otp", newOtp);
            try {
                String subject = "Mã OTP xác nhận đăng ký - POB Food";
                String html = buildOtpEmail(newOtp, email);
                EmailUtil.sendEmail(email, subject, html);
            } catch (MessagingException e) {
                e.printStackTrace();
            }
            resp.sendRedirect(req.getContextPath() + "/xacnhanotp?resent=1");
            return;
        }

        String otp = otpSession.toString();
        String otp1 =  req.getParameter("otp1");
        String otp2 =  req.getParameter("otp2");
        String otp3 =  req.getParameter("otp3");
        String otp4=  req.getParameter("otp4");
        String otp5 =  req.getParameter("otp5");
        String otp6 =  req.getParameter("otp6");
        String otpNguoiDungNhap = otp1+otp2+otp3+otp4+otp5+otp6;
        if (otp.equals(otpNguoiDungNhap)){
            AccountDAO dao = new AccountDAOImpl();
            String username = (String) session.getAttribute("username");
            String pass     = (String) session.getAttribute("password");
            String fullname = (String) session.getAttribute("fullname");
            String phone    = (String) session.getAttribute("phone");
            String email    = (String) session.getAttribute("email");
            long roleId     = getRegisterRoleId(session);

            Account account = new Account();
            account.setUserName(username);
            account.setPassWord(pass);
            account.setEmail(email);
            account.setFullName(fullname);
            account.setPhone(phone);
            account.setRoleId(roleId);

            long newId = dao.createAndReturnId(account);
            boolean created = newId > 0;

            if (created) {
                // Tự động tạo bản ghi profile tương ứng theo role
                if (roleId == 4) {
                    // SHIPPER -> tạo Shipper_Profiles trống
                    ShipperProfileDAO shipperProfileDAO = new ShipperProfileDAOImpl();
                    ShipperProfile sp = new ShipperProfile();
                    sp.setAccountId(newId);
                    shipperProfileDAO.save(sp);
                }

                clearRegisterSession(session);

                if (roleId == 2) {
                    // SHOP: tự đăng nhập luôn và chuyển thẳng đến trang đăng ký thông tin shop
                    Account newAccount = dao.findById(newId);
                    if (newAccount != null) {
                        session.setAttribute("account", newAccount);
                        session.setAttribute("role", newAccount.getRoleId());
                    }
                    resp.sendRedirect(req.getContextPath() + "/shop");
                } else {
                    req.setAttribute("thongbao", "Đăng ký thành công! Vui lòng đăng nhập.");
                    req.getRequestDispatcher("/DangNhap.jsp").forward(req, resp);
                }
                return;
            } else {
                req.setAttribute("loi", "Đăng ký thất bại, vui lòng thử lại!");
                req.getRequestDispatcher("/register.jsp").forward(req, resp);
                return;
            }
        } else {
            req.setAttribute("loi", "Mã OTP không chính xác!");
            req.getRequestDispatcher("/nhapOTP.jsp").forward(req, resp);
            return;
        }
    }


    private long getRegisterRoleId(HttpSession session) {
        Object role = session.getAttribute("registerRoleId");
        if (role instanceof Number) {
            return ((Number) role).longValue();
        }

        try {
            return Long.parseLong(String.valueOf(role));
        } catch (Exception e) {
            return 3L;
        }
    }

    private void clearRegisterSession(HttpSession session) {
        session.removeAttribute("otp");
        session.removeAttribute("username");
        session.removeAttribute("password");
        session.removeAttribute("fullname");
        session.removeAttribute("phone");
        session.removeAttribute("email");
        session.removeAttribute("registerRoleId");
    }

    private String buildOtpEmail(String otp, String email) {
        return """
                <!DOCTYPE html>
                <html>
                <head>
                    <meta charset="UTF-8">
                    <title>Xác nhận OTP</title>
                </head>
                <body style="margin:0;padding:0;font-family:'Segoe UI',Arial,sans-serif;background:#f4f7fb;">
                    <table align="center" border="0" cellpadding="0" cellspacing="0" width="100%%" style="max-width:600px;margin:40px auto;background:#ffffff;border-radius:16px;box-shadow:0 8px 32px rgba(0,0,0,0.08);overflow:hidden;">
                        <tr>
                            <td style="background:linear-gradient(135deg,#1a1a2e,#273053);padding:32px 40px;text-align:center;">
                                <h1 style="color:#ffffff;font-size:24px;font-weight:700;margin:0;">🍔 POB</h1>
                                <p style="color:rgba(255,255,255,0.6);font-size:13px;margin:6px 0 0;">HỆ THỐNG ĐẶT HÀNG</p>
                            </td>
                        </tr>
                        <tr>
                            <td style="padding:40px 40px 30px;">
                                <h2 style="color:#1a1a2e;font-size:20px;margin:0 0 8px;">Gửi lại mã OTP</h2>
                                <p style="color:#666;font-size:15px;line-height:1.6;margin:0 0 24px;">
                                    Bạn vừa yêu cầu gửi lại mã OTP.<br>
                                    Vui lòng nhập mã dưới đây để hoàn tất đăng ký tài khoản POB.
                                </p>
                                <div style="background:#f8f9fc;border-radius:12px;padding:28px;text-align:center;border:1px dashed #d1d5e5;margin-bottom:24px;">
                                    <div style="font-size:11px;color:#888;text-transform:uppercase;letter-spacing:1.5px;margin-bottom:8px;">Mã xác thực (OTP)</div>
                                    <div style="font-size:36px;font-weight:800;color:#273053;letter-spacing:8px;font-family:'Courier New',monospace;">%s</div>
                                    <div style="font-size:12px;color:#999;margin-top:10px;">⏳ Hiệu lực trong <strong>5 phút</strong></div>
                                </div>
                                <p style="color:#999;font-size:12px;text-align:center;">Nếu bạn không yêu cầu điều này, hãy bỏ qua email này.</p>
                            </td>
                        </tr>
                    </table>
                </body>
                </html>
                """.formatted(otp);
    }
}
