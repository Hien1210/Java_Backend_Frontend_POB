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

@WebServlet("/admin/change-password")
public class AdminChangePasswordServlet extends HttpServlet {

    private final AccountDAO accountDAO = new AccountDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("account") == null) {
            resp.sendRedirect(req.getContextPath() + "/dangnhap");
            return;
        }
        Account account = (Account) session.getAttribute("account");
        if (account.getRoleId() != 1) {
            resp.sendRedirect(req.getContextPath() + "/dangnhap");
            return;
        }
        req.getRequestDispatcher("/admin/doiMatKhauAdmin.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("account") == null) {
            resp.sendRedirect(req.getContextPath() + "/dangnhap");
            return;
        }
        Account account = (Account) session.getAttribute("account");
        if (account.getRoleId() != 1) {
            resp.sendRedirect(req.getContextPath() + "/dangnhap");
            return;
        }

        String currentPassword = req.getParameter("currentPassword");
        String newPassword     = req.getParameter("newPassword");
        String confirmPassword = req.getParameter("confirmPassword");

        // Lấy account mới nhất từ DB để có password hash đúng
        Account fresh = accountDAO.findById(account.getId());

        // Kiểm tra mật khẩu hiện tại
        if (!BCrypt.checkpw(currentPassword, fresh.getPassWord())) {
            resp.sendRedirect(req.getContextPath() + "/admin/change-password?error=wrong_current");
            return;
        }

        // Kiểm tra mật khẩu mới và xác nhận khớp nhau
        if (newPassword == null || !newPassword.equals(confirmPassword)) {
            resp.sendRedirect(req.getContextPath() + "/admin/change-password?error=not_match");
            return;
        }

        // Kiểm tra độ dài tối thiểu
        if (newPassword.length() < 6) {
            resp.sendRedirect(req.getContextPath() + "/admin/change-password?error=too_short");
            return;
        }

        // Hash mật khẩu mới và lưu
        String hashed = BCrypt.hashpw(newPassword, BCrypt.gensalt());
        boolean ok = accountDAO.capNhatMatKhauTheoEmail(fresh.getEmail(), hashed);

        if (ok) {
            session.invalidate();
            resp.sendRedirect(req.getContextPath() + "/dangnhap?success=password_changed");
        } else {
            resp.sendRedirect(req.getContextPath() + "/admin/change-password?error=server");
        }
    }
}
