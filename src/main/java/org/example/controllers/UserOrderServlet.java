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

    /** Fallback neu chua doc duoc SystemConfig.shopAcceptOrderMinutes (xem getCancelableAfterMinutes()). */
    private static final int DEFAULT_AUTO_CANCEL_MINUTES = 10;
    /** Doi toi thieu bao nhieu phut truoc moc he thong se tu dong huy, de khach van kip tu huy truoc. */
    private static final int CANCEL_BUFFER_MINUTES = 5;

    private final OrderDAO orderDAO = new OrderDAOImpl();
    private final FeedbackDAO feedbackDAO = new FeedbackDAOImpl();
    private final ShopDAO shopDAO = new ShopDAOImpl();
    private final SystemConfigDAO systemConfigDAO = new SystemConfigDAOImpl();

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

        AccountDAO accountDAO = new AccountDAOImpl();
        java.util.Map<Long, Shop> shopMap = new java.util.HashMap<>();
        java.util.Map<Long, Account> shipperMap = new java.util.HashMap<>();
        java.util.Map<Long, org.example.models.BillView> billMap = new java.util.HashMap<>();
        java.util.Map<Long, String> shopNames = new java.util.HashMap<>();
        java.util.Map<Long, double[]> shopCoords = new java.util.HashMap<>();
        java.util.Map<Long, Boolean> feedbackShop = new java.util.HashMap<>();
        java.util.Map<Long, Boolean> feedbackShipper = new java.util.HashMap<>();
        java.util.Map<Long, Boolean> cancelable = new java.util.HashMap<>();

        for (Order o : orders) {
            long shopId = o.getShopId();
            if (!shopMap.containsKey(shopId)) {
                Shop shop = shopDAO.selectShopById(shopId);
                if (shop != null) {
                    shopMap.put(shopId, shop);
                    shopNames.put(shopId, shop.getShopName());
                    if (shop.getLocationX() != null && shop.getLocationY() != null) {
                        shopCoords.put(shopId, new double[]{shop.getLocationX(), shop.getLocationY()});
                    }
                } else {
                    shopNames.put(shopId, "Shop #" + shopId);
                }
            }
            if (o.getShipperId() > 0 && !shipperMap.containsKey(o.getShipperId())) {
                Account shipper = accountDAO.findById(o.getShipperId());
                if (shipper != null) {
                    shipperMap.put(o.getShipperId(), shipper);
                }
            }
            try {
                org.example.models.BillView bill = org.example.utils.BillUtil.build(o);
                billMap.put(o.getId(), bill);
            } catch (Exception e) {
                // ignore if bill build fails
            }

            feedbackShop.put(o.getId(), feedbackDAO.existsByOrderAndType(o.getId(), "USER", "SHOP"));
            feedbackShipper.put(o.getId(), feedbackDAO.existsByOrderAndType(o.getId(), "USER", "SHIPPER"));
            cancelable.put(o.getId(), isCancelableNow(o));
        }

        req.setAttribute("orders", orders);
        req.setAttribute("shopMap", shopMap);
        req.setAttribute("shipperMap", shipperMap);
        req.setAttribute("billMap", billMap);
        req.setAttribute("shopNames", shopNames);
        req.setAttribute("shopCoords", shopCoords);
        req.setAttribute("feedbackShop", feedbackShop);
        req.setAttribute("feedbackShipper", feedbackShipper);
        req.setAttribute("cancelable", cancelable);
        req.setAttribute("unreadNotifCount", new NotificationDAOImpl().countUnread(account.getId()));
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

        // Nếu đã thanh toán qua PayOS → set REFUNDED để khách có thể yêu cầu hoàn tiền
        boolean wasPaid = "PAID".equalsIgnoreCase(order.getPaymentStatus());
        // Dung ban CAS atomic thay vi cancelOrder() thuong (chi guard "status <> CANCELLED"): giua
        // luc doc order o tren va luc goi ham nay, don co the vua bi Shop xac nhan sang CONFIRMED -
        // dieu kien "status <> CANCELLED" van khop nham, huy oan don da duoc Shop xu ly.
        boolean ok = orderDAO.cancelOrderIfStatus(orderId, "Khách hàng tự hủy", "PENDING");
        if (ok && wasPaid) {
            // Tìm shop để lấy PayOS keys và hủy link
            org.example.daos.ShopDAO shopDAO = new org.example.daos.ShopDAOImpl();
            org.example.models.Shop shop = shopDAO.selectShopById(order.getShopId());
            if (shop != null && shop.getClientKey() != null && shop.getApiKey() != null) {
                org.example.utils.PayOSUtil.cancelPaymentLink(shop.getClientKey(), shop.getApiKey(), orderId, "Khách hàng hủy đơn");
            }
            orderDAO.updatePaymentStatus(orderId, order.getShopId(), "REFUNDED");
        }
        String redirect = ok
            ? (wasPaid ? "success=order_cancelled&refund=1" : "success=order_cancelled")
            : "error=server";
        resp.sendRedirect(req.getContextPath() + "/user/donhang?" + redirect);
    }

    /** Chi cho huy khi don con PENDING va da qua getCancelableAfterMinutes() phut ke tu luc dat. */
    private boolean isCancelableNow(Order order) {
        if (order == null || !"PENDING".equalsIgnoreCase(order.getStaTus())) {
            return false;
        }
        if (order.getCreatedAt() == null) {
            return false;
        }
        return order.getCreatedAt().plusMinutes(getCancelableAfterMinutes()).isBefore(LocalDateTime.now());
    }

    /**
     * Moc phut ma tu do khach duoc phep tu huy don PENDING. Lay dong theo
     * SystemConfig.shopAcceptOrderMinutes (moc ma OrderAutoCancelListener dung de tu dong huy),
     * tru di CANCEL_BUFFER_MINUTES phut de dam bao khach luon co co hoi tu huy truoc khi he thong
     * tu dong huy - tranh truong hop hardcode co dinh bi lech neu Admin doi tham so nay.
     */
    private int getCancelableAfterMinutes() {
        var config = systemConfigDAO.get();
        int autoCancelMinutes = (config != null && config.getShopAcceptOrderMinutes() > 0)
                ? config.getShopAcceptOrderMinutes() : DEFAULT_AUTO_CANCEL_MINUTES;
        return Math.max(1, autoCancelMinutes - CANCEL_BUFFER_MINUTES);
    }
}
