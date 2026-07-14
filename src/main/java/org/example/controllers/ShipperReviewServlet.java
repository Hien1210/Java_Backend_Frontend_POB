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
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * Trang "Đánh giá & Báo cáo" của Shipper
 * GET /shipper/danh-gia — danh sách đơn DONE + trạng thái đã feedback / bom hàng chưa
 */
@WebServlet("/shipper/danh-gia")
public class ShipperReviewServlet extends HttpServlet {

    private final OrderDAO    orderDAO    = new OrderDAOImpl();
    private final FeedbackDAO feedbackDAO = new FeedbackDAOImpl();
    private final ShopDAO     shopDAO     = new ShopDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null) { resp.sendRedirect(req.getContextPath() + "/dangnhap"); return; }
        Account account = (Account) session.getAttribute("account");
        if (account == null || account.getRoleId() != 4) {
            resp.sendRedirect(req.getContextPath() + "/dangnhap");
            return;
        }

        // Lấy tất cả đơn của shipper, lọc chỉ lấy DONE
        List<Order> doneOrders = orderDAO.findByShipperId(account.getId())
                .stream()
                .filter(o -> "DONE".equalsIgnoreCase(o.getStaTus()))
                .collect(Collectors.toList());

        // Tên shop và trạng thái feedback / bom hàng
        Map<Long, String>  shopNames      = new HashMap<>();
        Map<Long, Boolean> feedbackShop   = new HashMap<>();
        Map<Long, Boolean> bomHangDone    = new HashMap<>();

        for (Order o : doneOrders) {
            long shopId = o.getShopId();
            if (!shopNames.containsKey(shopId)) {
                Shop shop = shopDAO.selectShopById(shopId);
                shopNames.put(shopId, shop != null ? shop.getShopName() : "Shop #" + shopId);
            }
            feedbackShop.put(o.getId(),
                    feedbackDAO.existsByOrderAndType(o.getId(), "SHIPPER", "SHOP"));

            // Kiểm tra đơn này đã bị báo bom hàng chưa (USER feedback với rating thấp không liên quan —
            // ở đây chỉ cần biết shipper đã bấm "Báo bom hàng" cho đơn này chưa)
            // Dùng OrderLog hoặc đơn giản là check qua một flag; tạm thời dùng comment placeholder
            bomHangDone.put(o.getId(), false); // TODO: thêm bảng/flag nếu cần track per-order
        }

        req.setAttribute("doneOrders",   doneOrders);
        req.setAttribute("shopNames",    shopNames);
        req.setAttribute("feedbackShop", feedbackShop);
        req.setAttribute("bomHangDone",  bomHangDone);
        req.setAttribute("tenShipper",   account.getFullName() != null ? account.getFullName() : account.getUserName());
        req.getRequestDispatcher("/shipper/danhGia.jsp").forward(req, resp);
    }
}
