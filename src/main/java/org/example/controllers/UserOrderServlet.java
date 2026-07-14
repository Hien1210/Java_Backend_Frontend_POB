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
import java.util.List;

@WebServlet("/user/donhang")
public class UserOrderServlet extends HttpServlet {

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
        java.util.Map<Long, Boolean> feedbackShop = new java.util.HashMap<>();
        java.util.Map<Long, Boolean> feedbackShipper = new java.util.HashMap<>();

        for (Order o : orders) {
            long shopId = o.getShopId();
            if (!shopNames.containsKey(shopId)) {
                Shop shop = shopDAO.selectShopById(shopId);
                shopNames.put(shopId, shop != null ? shop.getShopName() : "Shop #" + shopId);
            }
            feedbackShop.put(o.getId(),
                    feedbackDAO.existsByOrderAndType(o.getId(), "USER", "SHOP"));
            feedbackShipper.put(o.getId(),
                    feedbackDAO.existsByOrderAndType(o.getId(), "USER", "SHIPPER"));
        }

        req.setAttribute("orders", orders);
        req.setAttribute("shopNames", shopNames);
        req.setAttribute("feedbackShop", feedbackShop);
        req.setAttribute("feedbackShipper", feedbackShipper);
        req.getRequestDispatcher("/user/donhang.jsp").forward(req, resp);
    }
}
