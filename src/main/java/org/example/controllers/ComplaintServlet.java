package org.example.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.example.daos.ComplaintDAO;
import org.example.daos.ComplaintDAOImpl;
import org.example.daos.OrderDAO;
import org.example.daos.OrderDAOImpl;
import org.example.models.Account;
import org.example.models.Complaint;
import org.example.models.Order;

import java.io.IOException;
import java.util.List;

/**
 * Khach hang gui khieu nai ve don hang va xem lai trang thai xu ly.
 * GET  /khieu-nai                -> danh sach khieu nai cua khach + form neu co orderId
 * GET  /khieu-nai?orderId=       -> form gui khieu nai cho 1 don cu the
 * POST /khieu-nai                -> luu khieu nai moi
 */
@WebServlet("/khieu-nai")
public class ComplaintServlet extends HttpServlet {

    private final ComplaintDAO complaintDAO = new ComplaintDAOImpl();
    private final OrderDAO orderDAO = new OrderDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Account account = getAccount(req, resp);
        if (account == null) return;

        String orderIdStr = req.getParameter("orderId");
        if (orderIdStr != null) {
            long orderId;
            try {
                orderId = Long.parseLong(orderIdStr);
            } catch (NumberFormatException e) {
                resp.sendRedirect(req.getContextPath() + "/user/donhang");
                return;
            }
            Order order = orderDAO.findById(orderId);
            if (order == null || order.getUserId() != account.getId()) {
                resp.sendRedirect(req.getContextPath() + "/user/donhang?error=1");
                return;
            }
            req.setAttribute("order", order);
        }

        List<Complaint> complaints = complaintDAO.findByAccountId(account.getId());
        req.setAttribute("complaints", complaints);
        req.getRequestDispatcher("/user/khieuNai.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        Account account = getAccount(req, resp);
        if (account == null) return;

        long orderId;
        try {
            orderId = Long.parseLong(req.getParameter("orderId"));
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/khieu-nai?error=invalid");
            return;
        }

        Order order = orderDAO.findById(orderId);
        if (order == null || order.getUserId() != account.getId()) {
            resp.sendRedirect(req.getContextPath() + "/khieu-nai?error=not_found");
            return;
        }

        String subject = normalize(req.getParameter("subject"));
        String content = normalize(req.getParameter("content"));
        if (subject.isEmpty() || content.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/khieu-nai?orderId=" + orderId + "&error=empty");
            return;
        }

        Complaint complaint = new Complaint();
        complaint.setOrderId(orderId);
        complaint.setAccountId(account.getId());
        complaint.setSubject(subject);
        complaint.setContent(content);

        boolean ok = complaintDAO.create(complaint);
        if (ok) {
            resp.sendRedirect(req.getContextPath() + "/khieu-nai?success=1");
        } else {
            resp.sendRedirect(req.getContextPath() + "/khieu-nai?orderId=" + orderId + "&error=fail");
        }
    }

    private String normalize(String value) {
        return value == null ? "" : value.trim();
    }

    private Account getAccount(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null) {
            resp.sendRedirect(req.getContextPath() + "/dangnhap");
            return null;
        }
        Account account = (Account) session.getAttribute("account");
        if (account == null || account.getRoleId() != 3) {
            resp.sendRedirect(req.getContextPath() + "/dangnhap");
            return null;
        }
        return account;
    }
}
