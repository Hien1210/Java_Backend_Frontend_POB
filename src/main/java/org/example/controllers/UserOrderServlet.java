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
import org.example.models.Shop;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;

@WebServlet("/user/donhang")
public class UserOrderServlet extends HttpServlet {

    /** Khach duoc phep tu huy don PENDING sau khi da dat qua 5 phut (truoc khi bi he thong tu dong huy o phut thu 10). */
    private static final int CANCELABLE_AFTER_MINUTES = 5;

    private final OrderDAO orderDAO = new OrderDAOImpl();
    private final FeedbackDAO feedbackDAO = new FeedbackDAOImpl();
    private final ShopDAO shopDAO = new ShopDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null) { resp.sendRedirect(req.getContextPath() + "/dangnhap"); return; }
        Account account = (Account) session.getAttribute("account");
        if (account == null || account.getRoleId() != 3) {
            resp.sendRedirect(req.getContextPath() + "/dangnhap");
            return;
        }

        List<Order> orders = orderDAO.findByUserId(account.getId());

        // Gắn tên shop và trạng thái đã feedback cho mỗi đơn
        java.util.Map<Long, String> shopNames = new java.util.HashMap<>();
        java.util.Map<Long, double[]> shopCoords = new java.util.HashMap<>();
        java.util.Map<Long, Boolean> feedbackShop = new java.util.HashMap<>();
        java.util.Map<Long, Boolean> feedbackShipper = new java.util.HashMap<>();
        java.util.Map<Long, Boolean> cancelable = new java.util.HashMap<>();

        for (Order o : orders) {
            long shopId = o.getShopId();
            if (!shopNames.containsKey(shopId)) {
                Shop shop = shopDAO.selectShopById(shopId);
                shopNames.put(shopId, shop != null ? shop.getShopName() : "Shop #" + shopId);
                if (shop != null && shop.getLocationX() != null && shop.getLocationY() != null) {
                    shopCoords.put(shopId, new double[]{shop.getLocationX(), shop.getLocationY()});
                }
            }
            feedbackShop.put(o.getId(),
                    feedbackDAO.existsByOrderAndType(o.getId(), "USER", "SHOP"));
            feedbackShipper.put(o.getId(),
                    feedbackDAO.existsByOrderAndType(o.getId(), "USER", "SHIPPER"));
            cancelable.put(o.getId(), isCancelableNow(o));
        }

        req.setAttribute("orders", orders);
        req.setAttribute("shopNames", shopNames);
        req.setAttribute("shopCoords", shopCoords);
        req.setAttribute("feedbackShop", feedbackShop);
        req.setAttribute("feedbackShipper", feedbackShipper);
        req.setAttribute("cancelable", cancelable);
        req.getRequestDispatcher("/user/donhang.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null) { resp.sendRedirect(req.getContextPath() + "/dangnhap"); return; }
        Account account = (Account) session.getAttribute("account");
        if (account == null || account.getRoleId() != 3) {
            resp.sendRedirect(req.getContextPath() + "/dangnhap");
            return;
        }

        if (!"cancel".equals(req.getParameter("action"))) {
            resp.sendRedirect(req.getContextPath() + "/user/donhang");
            return;
        }

        long orderId;
        try {
            orderId = Long.parseLong(req.getParameter("orderId"));
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/user/donhang?error=missing");
            return;
        }

        Order order = orderDAO.findById(orderId);
        if (order == null || order.getUserId() != account.getId()) {
            resp.sendRedirect(req.getContextPath() + "/user/donhang?error=not_found");
            return;
        }

        if (!isCancelableNow(order)) {
            resp.sendRedirect(req.getContextPath() + "/user/donhang?error=cannot_cancel");
            return;
        }

        boolean ok = orderDAO.updateStatus(orderId, "CANCELLED");
        resp.sendRedirect(req.getContextPath() + "/user/donhang?" + (ok ? "success=order_cancelled" : "error=server"));
    }

    /** Chi cho huy khi don con PENDING va da qua CANCELABLE_AFTER_MINUTES phut ke tu luc dat. */
    private boolean isCancelableNow(Order order) {
        if (order == null || !"PENDING".equalsIgnoreCase(order.getStaTus())) {
            return false;
        }
        if (order.getCreatedAt() == null) {
            return false;
        }
        return order.getCreatedAt().plusMinutes(CANCELABLE_AFTER_MINUTES).isBefore(LocalDateTime.now());
    }
}
