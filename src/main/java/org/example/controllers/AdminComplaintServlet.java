package org.example.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.example.daos.ComplaintDAO;
import org.example.daos.ComplaintDAOImpl;
import org.example.models.Account;
import org.example.models.Complaint;

import java.io.IOException;
import java.util.List;
import java.util.Locale;

/**
 * Trang "Quan ly khieu nai" (Super Admin) - /admin/khieu-nai
 * GET  ?status=PENDING|PROCESSING|RESOLVED|REJECTED  -> loc danh sach theo trang thai
 * POST action=resolve|reject, complaintId, reply     -> phan hoi + doi trang thai
 */
@WebServlet("/admin/khieu-nai")
public class AdminComplaintServlet extends HttpServlet {

    private final ComplaintDAO complaintDAO = new ComplaintDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!requireAdmin(req, resp)) return;

        String status = req.getParameter("status");
        List<Complaint> complaints = (status == null || status.isBlank())
                ? complaintDAO.findAll()
                : complaintDAO.findByStatus(status.toUpperCase(Locale.ROOT));

        req.setAttribute("complaints", complaints);
        req.setAttribute("statusFilter", status == null ? "" : status.toUpperCase(Locale.ROOT));
        req.setAttribute("pendingCount", complaintDAO.findByStatus("PENDING").size());
        req.getRequestDispatcher("/admin/QuanLyKhieuNai.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!requireAdmin(req, resp)) return;
        req.setCharacterEncoding("UTF-8");

        Account admin = (Account) req.getSession(false).getAttribute("account");
        String action = req.getParameter("action");
        long complaintId = parseLong(req.getParameter("complaintId"));
        String reply = req.getParameter("reply");
        reply = reply == null ? "" : reply.trim();

        if (complaintId <= 0 || reply.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/admin/khieu-nai?error=empty_reply");
            return;
        }

        if ("resolve".equals(action)) {
            complaintDAO.resolve(complaintId, "RESOLVED", reply, admin.getId());
            resp.sendRedirect(req.getContextPath() + "/admin/khieu-nai?success=resolved");
        } else if ("reject".equals(action)) {
            complaintDAO.resolve(complaintId, "REJECTED", reply, admin.getId());
            resp.sendRedirect(req.getContextPath() + "/admin/khieu-nai?success=rejected");
        } else if ("processing".equals(action)) {
            complaintDAO.resolve(complaintId, "PROCESSING", reply, admin.getId());
            resp.sendRedirect(req.getContextPath() + "/admin/khieu-nai?success=processing");
        } else {
            resp.sendRedirect(req.getContextPath() + "/admin/khieu-nai");
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
        try {
            return Long.parseLong(val);
        } catch (Exception e) {
            return 0;
        }
    }
}
