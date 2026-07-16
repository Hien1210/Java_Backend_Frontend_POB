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

@WebServlet("/shipper/doi-mat-khau")
public class ShipperDoiMatKhauServlet extends HttpServlet {

    private final AccountDAO accountDAO = new AccountDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("account") == null) {
            resp.sendRedirect(req.getContextPath() + "/dangnhap");
            return;
        }
        Account account = (Account) session.getAttribute("account");
        if (account.getRoleId() != 4) {
            resp.sendRedirect(req.getContextPath() + "/dangnhap");
            return;
        }
        req.getRequestDispatcher("/shipper/doiMatKhauShipper.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("account") == null) {
            resp.sendRedirect(req.getContextPath() + "/dangnhap");
            return;
        }
        Account account = (Account) session.getAttribute("account");
        if (account.getRoleId() != 4) {
            resp.sendRedirect(req.getContextPath() + "/dangnhap");
            return;
        }

        String currentPassword = req.getParameter("currentPassword");
        String newPassword     = req.getParameter("newPassword");
        String confirmPassword = req.getParameter("confirmPassword");

        Account fresh = accountDAO.findById(account.getId());
        if (!BCrypt.checkpw(currentPassword, fresh.getPassWord())) {
            resp.sendRedirect(req.getContextPath() + "/shipper/doi-mat-khau?error=wrong_current");
            return;
        }
        if (!newPassword.equals(confirmPassword)) {
            resp.sendRedirect(req.getContextPath() + "/shipper/doi-mat-khau?error=not_match");
            return;
        }
        if (newPassword.length() < 6) {
            resp.sendRedirect(req.getContextPath() + "/shipper/doi-mat-khau?error=too_short");
            return;
        }

        String hashed = BCrypt.hashpw(newPassword, BCrypt.gensalt());
        boolean ok = accountDAO.capNhatMatKhauTheoEmail(account.getEmail(), hashed);
        if (ok) {
            session.invalidate();
            resp.sendRedirect(req.getContextPath() + "/dangnhap?success=password_changed");
        } else {
            resp.sendRedirect(req.getContextPath() + "/shipper/doi-mat-khau?error=server");
        }
    }
}
