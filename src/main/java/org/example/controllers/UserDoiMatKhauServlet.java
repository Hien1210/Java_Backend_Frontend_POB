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
import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;

/**
 * Đổi mật khẩu cho tài khoản Khách hàng (User, roleId=3).
 * URL : /user/doi-mat-khau
 * JSP : /user/doiMatKhauUser.jsp
 * (Đúng theo pattern của ShopDoiMatKhauServlet/ShipperDoiMatKhauServlet — trước đó vai trò User
 * chưa có servlet này dù JSP đã có sẵn link, gây lỗi 404.)
 */
@WebServlet("/user/doi-mat-khau")
public class UserDoiMatKhauServlet extends HttpServlet {

    private final AccountDAO accountDAO = new AccountDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Account account = requireUser(req, resp);
        if (account == null) return;
        req.setAttribute("unreadNotifCount", new org.example.daos.NotificationDAOImpl().countUnread(account.getId()));
        req.getRequestDispatcher("/user/doiMatKhauUser.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Account account = requireUser(req, resp);
        if (account == null) return;

        String currentPassword = req.getParameter("currentPassword");
        String newPassword     = req.getParameter("newPassword");
        String confirmPassword = req.getParameter("confirmPassword");

        Account fresh = accountDAO.findById(account.getId());
        if (fresh == null || currentPassword == null || !BCrypt.checkpw(currentPassword, fresh.getPassWord())) {
            resp.sendRedirect(req.getContextPath() + "/user/doi-mat-khau?error=wrong_current");
            return;
        }
        if (newPassword == null || !newPassword.equals(confirmPassword)) {
            resp.sendRedirect(req.getContextPath() + "/user/doi-mat-khau?error=not_match");
            return;
        }
        if (newPassword.length() < 6) {
            resp.sendRedirect(req.getContextPath() + "/user/doi-mat-khau?error=too_short");
            return;
        }

        String hashed = BCrypt.hashpw(newPassword, BCrypt.gensalt());
        boolean ok = accountDAO.capNhatMatKhauTheoEmail(account.getEmail(), hashed);
        if (ok) {
            req.getSession().invalidate();
            resp.sendRedirect(req.getContextPath() + "/dangnhap?success=password_changed");
        } else {
            resp.sendRedirect(req.getContextPath() + "/user/doi-mat-khau?error=server");
        }
    }

    private Account requireUser(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        Account account = session == null ? null : (Account) session.getAttribute("account");
        if (account == null || account.getRoleId() != 3) {
            resp.sendRedirect(req.getContextPath() + "/dangnhap");
            return null;
        }
        return account;
    }
}
