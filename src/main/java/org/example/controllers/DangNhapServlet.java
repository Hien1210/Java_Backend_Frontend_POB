package org.example.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.example.daos.AccountDAO;
import org.example.daos.AccountDAOImpl;
import org.example.models.Account;
import org.example.services.AuditLogService;
import org.example.utils.AuditModules;
import org.example.utils.RateLimitUtil;

import java.io.IOException;

@WebServlet("/dangnhap")
public class DangNhapServlet extends HttpServlet {

    private static final int MAX_ATTEMPTS = 5;
    private static final long WINDOW_MILLIS = 15 * 60 * 1000L;
    private static final long LOCKOUT_MILLIS = 15 * 60 * 1000L;

    private final AuditLogService auditLogService = new AuditLogService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
            req.getRequestDispatcher("/DangNhap.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String rateLimitKey = "login:" + req.getRemoteAddr();
        if (RateLimitUtil.isBlocked(rateLimitKey)) {
            long minutes = (RateLimitUtil.remainingSeconds(rateLimitKey) + 59) / 60;
            req.setAttribute("loi", "Bạn đã đăng nhập sai quá nhiều lần. Vui lòng thử lại sau " + minutes + " phút.");
            req.getRequestDispatcher("/DangNhap.jsp").forward(req, resp);
            return;
        }

        AccountDAO dao = new AccountDAOImpl();

        String username = req.getParameter("username");
        String password = req.getParameter("password");

        Account account = dao.DangNhap(username, password);

        if (account != null) {
            RateLimitUtil.reset(rateLimitKey);
            // Kiểm tra tài khoản bị đình chỉ (soft delete)
            if (account.isDeleted()) {
                req.setAttribute("suspended", true);
                req.setAttribute("suspendedAccountId", account.getId());
                req.setAttribute("suspendReason", account.getSuspendReason() != null
                        ? account.getSuspendReason() : "Vi phạm điều khoản sử dụng");
                // Chỉ xác thực đúng mật khẩu mới được phép nộp kháng nghị cho account này
                req.getSession().setAttribute("suspendedAccountId", account.getId());
                req.getRequestDispatcher("/DangNhap.jsp").forward(req, resp);
                return;
            }

            // Kiểm tra tài khoản bị khoá (ví dụ do bom hàng nhiều lần)
            if ("BLOCKED".equalsIgnoreCase(account.getStaTus())) {
                req.setAttribute("suspended", true);
                req.setAttribute("suspendedAccountId", account.getId());
                req.setAttribute("suspendReason", "Tài khoản đã bị khoá do vi phạm (bom hàng nhiều lần)");
                req.getSession().setAttribute("suspendedAccountId", account.getId());
                req.getRequestDispatcher("/DangNhap.jsp").forward(req, resp);
                return;
            }

            // Lưu account vào session
            HttpSession session = req.getSession();
            // Chống session fixation: cấp session ID mới sau khi xác thực thành công
            req.changeSessionId();
            session.setAttribute("account", account);
            session.setAttribute("role", account.getRoleId());

            // ✅ CHUYỂN HƯỚNG THEO ROLE
            int roleId = (int) account.getRoleId();
            switch (roleId) {
                case 1: // SUPER_ADMIN
                    resp.sendRedirect(req.getContextPath() + "/tong-quan");
                    return;
                case 2: // ADMIN (Shop)
                    resp.sendRedirect(req.getContextPath() + "/shop");
                    return;
                case 3: // USER
                    resp.sendRedirect(req.getContextPath() + "/user/home");
                    return;
                case 4: // SHIPPER
                    resp.sendRedirect(req.getContextPath() + "/shipper/donhang");
                    return;
                default:
                    resp.sendRedirect(req.getContextPath() + "/index.jsp");
                    return;
            }


        } else {
            boolean justLocked = RateLimitUtil.recordFailure(rateLimitKey, MAX_ATTEMPTS, WINDOW_MILLIS, LOCKOUT_MILLIS);
            if (justLocked) {
                auditLogService.log(req, null, "Khoá đăng nhập (rate limit)", AuditModules.SECURITY,
                        "IP " + req.getRemoteAddr() + " bị khoá đăng nhập tạm thời sau " + MAX_ATTEMPTS
                                + " lần sai mật khẩu liên tiếp, username thử: " + username,
                        null, "Account");
            }
            req.setAttribute("loi", "Tên đăng nhập hoặc mật khẩu không đúng!");
            req.getRequestDispatcher("/DangNhap.jsp").forward(req, resp);
        }
    }
}
