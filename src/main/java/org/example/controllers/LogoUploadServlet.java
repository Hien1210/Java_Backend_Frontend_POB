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

@WebServlet("/admin/update-logo")
public class LogoUploadServlet extends HttpServlet {

    private final AccountDAO accountDAO = new AccountDAOImpl();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("account") == null) {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }
        Account account = (Account) session.getAttribute("account");
        if (account.getRoleId() != 1) {
            resp.setStatus(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String logoUrl = req.getParameter("logoUrl");
        if (logoUrl == null || logoUrl.isBlank()) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        // Chỉ chấp nhận URL từ Cloudinary
        if (!logoUrl.startsWith("https://res.cloudinary.com/")) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        boolean ok = accountDAO.updateLogo(account.getId(), logoUrl);
        if (ok) {
            account.setLogoUrl(logoUrl);
            session.setAttribute("account", account);
            resp.setStatus(HttpServletResponse.SC_OK);
        } else {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}
