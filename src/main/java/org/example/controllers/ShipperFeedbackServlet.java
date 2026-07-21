package org.example.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.example.daos.*;
import org.example.models.Account;
import org.example.models.Feedback;

import java.io.IOException;

/**
 * Shipper gửi feedback cho Shop
 * GET  /shipper/feedback?orderId=  → form
 * POST /shipper/feedback           → lưu
 */
@WebServlet("/shipper/feedback")
public class ShipperFeedbackServlet extends HttpServlet {

    private final FeedbackDAO feedbackDAO = new FeedbackDAOImpl();
    private final OrderDAO    orderDAO    = new OrderDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Account account = getShipper(req, resp);
        if (account == null) return;

        if (!account.isOnline()) {
            resp.sendRedirect(req.getContextPath() + "/shipper/danh-gia?error=offline");
            return;
        }

        String orderIdStr = req.getParameter("orderId");
        if (orderIdStr == null) {
            resp.sendRedirect(req.getContextPath() + "/shipper/danh-gia");
            return;
        }

        long orderId = Long.parseLong(orderIdStr);
        var order = orderDAO.findById(orderId);
        if (order == null) { resp.sendRedirect(req.getContextPath() + "/shipper/danh-gia"); return; }

        if (!feedbackDAO.canFeedback(orderId, "SHIPPER", account.getId(), "SHOP", order.getShopId())) {
            resp.sendRedirect(req.getContextPath() + "/shipper/danh-gia?error=noquyen");
            return;
        }

        if (feedbackDAO.existsByOrderAndType(orderId, "SHIPPER", "SHOP")) {
            resp.sendRedirect(req.getContextPath() + "/shipper/danh-gia?error=dadanhgia");
            return;
        }

        req.setAttribute("orderId", orderId);
        req.setAttribute("order",   order);
        req.getRequestDispatcher("/shipper/guiFeedback.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Account account = getShipper(req, resp);
        if (account == null) return;

        if (!account.isOnline()) {
            resp.sendRedirect(req.getContextPath() + "/shipper/danh-gia?error=offline");
            return;
        }

        long orderId; int rating;
        try {
            orderId = Long.parseLong(req.getParameter("orderId"));
            rating  = Integer.parseInt(req.getParameter("rating"));
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/shipper/danh-gia"); return;
        }
        String comment = req.getParameter("comment");

        var order = orderDAO.findById(orderId);
        if (order == null || !feedbackDAO.canFeedback(orderId, "SHIPPER", account.getId(), "SHOP", order.getShopId())) {
            resp.sendRedirect(req.getContextPath() + "/shipper/danh-gia");
            return;
        }
        if (feedbackDAO.existsByOrderAndType(orderId, "SHIPPER", "SHOP")) {
            resp.sendRedirect(req.getContextPath() + "/shipper/danh-gia");
            return;
        }

        Feedback f = new Feedback();
        f.setOrderId(orderId);
        f.setReviewerType("SHIPPER");
        f.setReviewerId(account.getId());
        f.setTargetType("SHOP");
        f.setTargetId(order.getShopId());
        f.setRating(rating);
        f.setComment(comment);
        f.setAnonymous(false); // Shipper không ẩn danh

        feedbackDAO.save(f);

        req.getSession().setAttribute("thongbao_feedback", "Cảm ơn bạn đã đánh giá shop!");
        resp.sendRedirect(req.getContextPath() + "/shipper/danh-gia");
    }

    private Account getShipper(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null) { resp.sendRedirect(req.getContextPath() + "/dangnhap"); return null; }
        Account account = (Account) session.getAttribute("account");
        if (account == null || account.getRoleId() != 4) {
            resp.sendRedirect(req.getContextPath() + "/dangnhap");
            return null;
        }
        return account;
    }
}
