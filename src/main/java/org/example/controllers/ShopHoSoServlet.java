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

import java.io.IOException;

@WebServlet("/shop/ho-so")
public class ShopHoSoServlet extends HttpServlet {

    private final AccountDAO accountDAO = new AccountDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("account") == null) {
            resp.sendRedirect(req.getContextPath() + "/dangnhap");
            return;
        }
        Account account = (Account) session.getAttribute("account");
        if (account.getRoleId() != 2) {
            resp.sendRedirect(req.getContextPath() + "/dangnhap");
            return;
        }
        Account fresh = accountDAO.findById(account.getId());
        req.setAttribute("profile", fresh);
        req.getRequestDispatcher("/shop/hoSoShop.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("account") == null) {
            resp.sendRedirect(req.getContextPath() + "/dangnhap");
            return;
        }
        Account account = (Account) session.getAttribute("account");
        if (account.getRoleId() != 2) {
            resp.sendRedirect(req.getContextPath() + "/dangnhap");
            return;
        }

        String fullName  = req.getParameter("fullName");
        String phone     = req.getParameter("phone");
        String email     = req.getParameter("email");
        String avatarUrl = req.getParameter("avatarUrl");

        account.setFullName(fullName != null ? fullName.trim() : "");
        account.setPhone(phone != null ? phone.trim() : "");
        account.setEmail(email != null ? email.trim() : "");
        if (avatarUrl != null && avatarUrl.trim().startsWith("https://res.cloudinary.com/")) {
            account.setAvatarUrl(avatarUrl.trim());
        }

        boolean ok = accountDAO.update(account);
        if (ok) {
            session.setAttribute("account", account);
            resp.sendRedirect(req.getContextPath() + "/shop/ho-so?success=1");
        } else {
            resp.sendRedirect(req.getContextPath() + "/shop/ho-so?error=1");
        }
    }
}
