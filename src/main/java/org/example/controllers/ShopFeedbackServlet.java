package org.example.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.example.daos.*;
import org.example.models.Account;
import org.example.models.Shop;

import java.io.IOException;

/**
 * Shop xem danh sách feedback của mình (2 tab: từ User và từ Shipper)
 * GET /shop/danh-gia
 */
@WebServlet("/shop/danh-gia")
public class ShopFeedbackServlet extends HttpServlet {

    private final FeedbackDAO feedbackDAO = new FeedbackDAOImpl();
    private final ShopDAO     shopDAO     = new ShopDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null) { resp.sendRedirect(req.getContextPath() + "/dangnhap"); return; }
        Account account = (Account) session.getAttribute("account");
        if (account == null || account.getRoleId() != 2) {
            resp.sendRedirect(req.getContextPath() + "/dangnhap");
            return;
        }

        Shop shop = shopDAO.selectShopByOwnerId(account.getId());
        if (shop == null) { resp.sendRedirect(req.getContextPath() + "/shop"); return; }

        long shopId = shop.getId();

        req.setAttribute("feedbackUser",    feedbackDAO.findByTarget("SHOP", shopId, "USER"));
        req.setAttribute("feedbackShipper", feedbackDAO.findByTarget("SHOP", shopId, "SHIPPER"));
        req.setAttribute("avgRating",       feedbackDAO.avgRating("SHOP", shopId));
        req.setAttribute("totalFeedback",   feedbackDAO.countByTarget("SHOP", shopId));
        req.setAttribute("shop",            shop);

        req.getRequestDispatcher("/shop/xemDanhGia.jsp").forward(req, resp);
    }
}
