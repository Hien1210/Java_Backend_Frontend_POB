package org.example.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.example.daos.FeedbackDAO;
import org.example.daos.FeedbackDAOImpl;
import org.example.models.Account;
import org.example.models.Feedback;

import java.io.IOException;
import java.util.List;

/**
 * Trang "Kiểm duyệt bình luận" (Super Admin) - /admin/kiem-duyet-binh-luan
 */
@WebServlet("/admin/kiem-duyet-binh-luan")
public class KiemDuyetBinhLuanServlet extends HttpServlet {

    private final FeedbackDAO feedbackDAO = new FeedbackDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!requireAdmin(req, resp)) return;

        List<Feedback> pendingComments = feedbackDAO.findPendingReview();
        List<Feedback> historyComments = feedbackDAO.findHistory();
        req.setAttribute("pendingComments", pendingComments);
        req.setAttribute("historyComments", historyComments);
        req.getRequestDispatcher("/admin/KiemDuyetBinhLuan.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!requireAdmin(req, resp)) return;
        req.setCharacterEncoding("UTF-8");

        String action = req.getParameter("action");
        long feedbackId = parseLong(req.getParameter("feedbackId"));

        if ("approve".equals(action)) {
            feedbackDAO.updateStatus(feedbackId, "VISIBLE");
            resp.sendRedirect(req.getContextPath() + "/admin/kiem-duyet-binh-luan?success=approved");
        } else if ("reject".equals(action)) {
            feedbackDAO.updateStatus(feedbackId, "REMOVED");
            resp.sendRedirect(req.getContextPath() + "/admin/kiem-duyet-binh-luan?success=rejected");
        } else {
            resp.sendRedirect(req.getContextPath() + "/admin/kiem-duyet-binh-luan");
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
