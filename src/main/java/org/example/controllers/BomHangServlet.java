package org.example.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.example.daos.*;
import org.example.models.Account;
import org.example.models.Order;

import java.io.IOException;

/**
 * Shipper báo cáo user bom hàng (từ chối nhận đơn)
 * POST /shipper/bom-hang  { orderId }
 * Khi bom_count > 6 → khoá tài khoản user
 */
@WebServlet("/shipper/bom-hang")
public class BomHangServlet extends HttpServlet {

    private static final int BOM_LOCK_THRESHOLD = 6;

    private final FeedbackDAO feedbackDAO = new FeedbackDAOImpl();
    private final OrderDAO    orderDAO    = new OrderDAOImpl();
    private final AccountDAO  accountDAO  = new AccountDAOImpl();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null) { resp.sendRedirect(req.getContextPath() + "/dangnhap"); return; }
        Account shipper = (Account) session.getAttribute("account");
        if (shipper == null || shipper.getRoleId() != 4) {
            resp.sendRedirect(req.getContextPath() + "/dangnhap");
            return;
        }

        String orderIdStr = req.getParameter("orderId");
        if (orderIdStr == null) { resp.sendRedirect(req.getContextPath() + "/shipper/donhang"); return; }

        long orderId;
        try { orderId = Long.parseLong(orderIdStr); }
        catch (NumberFormatException e) { resp.sendRedirect(req.getContextPath() + "/shipper/donhang"); return; }
        Order order  = orderDAO.findById(orderId);

        // Kiểm tra đơn thuộc shipper này và đang ở trạng thái phù hợp
        if (order == null || order.getShipperId() != shipper.getId()) {
            resp.sendRedirect(req.getContextPath() + "/shipper/donhang");
            return;
        }

        if (!"SHIPPING".equals(order.getStaTus())) {
            resp.sendRedirect(req.getContextPath() + "/shipper/donhang");
            return;
        }

        long userId = order.getUserId();

        // Tăng bom_count
        int newCount = feedbackDAO.incrementBomCount(userId);

        // Nếu vượt ngưỡng → khoá tài khoản
        if (newCount > BOM_LOCK_THRESHOLD) {
            accountDAO.updateAccountStatus(userId, "BLOCKED");
        }

        // Huỷ đơn vì user từ chối nhận hàng
        orderDAO.cancelOrder(orderId, "Khách bom hàng (từ chối nhận)");

        resp.sendRedirect(req.getContextPath() + "/shipper/donhang?success=bomreported");
    }
}
