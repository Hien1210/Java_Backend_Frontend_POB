package org.example.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.example.daos.AppealDAO;
import org.example.daos.AppealDAOImpl;
import org.example.models.Account;
import org.example.models.AccountAppeal;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/appeals")
public class AppealReviewServlet extends HttpServlet {

    private final AppealDAO dao = new AppealDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!requireAdmin(req, resp)) return;

        List<AccountAppeal> pending = dao.findPending();
        List<AccountAppeal> all = dao.findAll();
        req.setAttribute("pendingAppeals", pending);
        req.setAttribute("allAppeals", all);
        req.setAttribute("pendingCount", pending.size());
        req.getRequestDispatcher("/admin/appeals.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!requireAdmin(req, resp)) return;
        req.setCharacterEncoding("UTF-8");

        String action = req.getParameter("action");
        long appealId = parseLong(req.getParameter("appealId"));
        long accountId = parseLong(req.getParameter("accountId"));
        String adminNote = req.getParameter("adminNote");
        if (adminNote == null) adminNote = "";

        if ("approve".equals(action)) {
            dao.approve(appealId, accountId, adminNote.trim());
            resp.sendRedirect(req.getContextPath() + "/admin/appeals?success=approved");
        } else if ("reject".equals(action)) {
            dao.reject(appealId, adminNote.trim());
            resp.sendRedirect(req.getContextPath() + "/admin/appeals?success=rejected");
        } else {
            resp.sendRedirect(req.getContextPath() + "/admin/appeals");
        }
    }

    private boolean requireAdmin(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        Account account = session != null ? (Account) session.getAttribute("account") : null;
        if (account == null || account.getRoleId() != 1) {
            resp.sendRedirect(req.getContextPath() + "/dangnhap");
            return false;
        }
        return true;
    }

    private long parseLong(String val) {
        try { return Long.parseLong(val); } catch (Exception e) { return 0; }
    }
}
