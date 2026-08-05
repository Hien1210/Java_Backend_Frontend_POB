package org.example.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.example.daos.*;
import org.example.models.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/user/add-combo-to-cart")
public class UserAddComboServlet extends HttpServlet {

    private final ComboDAO comboDAO = new ComboDAOImpl();
    private final CartDAO cartDAO = new CartDAOImpl();
    private final CartItemDAO cartItemDAO = new CartItemDAOImpl();
    private final ProductDAO productDAO = new ProductDAOImpl();
    private final ProductSizeDAO productSizeDAO = new ProductSizeDAOImpl();
    private final ShopDAO shopDAO = new ShopDAOImpl();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession(false);
        Account account = session == null ? null : (Account) session.getAttribute("account");
        if (account == null || account.getRoleId() != 3) {
            resp.sendRedirect(req.getContextPath() + "/dangnhap");
            return;
        }

        long comboId = parseLong(req.getParameter("comboId"));
        long shopId  = parseLong(req.getParameter("shopId"));

        if (comboId <= 0 || shopId <= 0) {
            resp.sendRedirect(req.getContextPath() + "/user/shop?id=" + shopId + "&error=invalid");
            return;
        }

        Shop shop = shopDAO.selectShopById(shopId);
        if (shop == null) {
            resp.sendRedirect(req.getContextPath() + "/user/shop?id=" + shopId + "&error=invalid");
            return;
        }
        if (!shop.isOpenNow()) {
            resp.sendRedirect(req.getContextPath() + "/user/shop?id=" + shopId + "&error=shop_closed");
            return;
        }

        Combo combo = comboDAO.findById(comboId);
        if (combo == null || combo.getShopId() != shopId) {
            resp.sendRedirect(req.getContextPath() + "/user/shop?id=" + shopId + "&error=invalid_combo");
            return;
        }

        List<ComboItem> comboItems = comboDAO.findItemsByComboId(comboId);
        if (comboItems == null || comboItems.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/user/shop?id=" + shopId + "&error=empty_combo");
            return;
        }

        // Neu bat ky san pham size nao trong combo da het hang, tu choi ca combo (khong the giao
        // 1 combo thieu mon) - tranh dat duoc combo chua mon da het hang.
        for (ComboItem item : comboItems) {
            ProductSize size = productSizeDAO.findById(item.getProductSizeId());
            if (size == null || size.isOutOfStock()) {
                resp.sendRedirect(req.getContextPath() + "/user/shop?id=" + shopId + "&error=combo_out_of_stock");
                return;
            }
        }

        Cart cart = cartDAO.findByUserId(account.getId());
        long cartId;
        if (cart == null) {
            Cart newCart = new Cart();
            newCart.setUserId(account.getId());
            cartId = cartDAO.createAndReturnId(newCart);
            if (cartId <= 0) {
                resp.sendRedirect(req.getContextPath() + "/user/shop?id=" + shopId + "&error=cart_fail");
                return;
            }
        } else {
            cartId = cart.getId();
        }

        List<CartItem> existingItems = cartItemDAO.findByCartId(cartId);
        if (!existingItems.isEmpty()) {
            long existingShopId = -1;
            Product existingProduct = productDAO.findById(existingItems.get(0).getProductId());
            if (existingProduct != null) existingShopId = existingProduct.getShopId();

            if (existingShopId != shopId) {
                boolean confirmSwitch = "1".equals(req.getParameter("confirmSwitchShop"));
                if (!confirmSwitch) {
                    resp.sendRedirect(req.getContextPath() + "/user/shop?id=" + shopId + "&error=shop_conflict");
                    return;
                }
                for (CartItem oldItem : existingItems) {
                    cartItemDAO.delete(oldItem.getId());
                }
            }
        }

        for (ComboItem item : comboItems) {
            CartItem existing = cartItemDAO.findByCartIdProductSize(cartId, item.getProductId(), item.getProductSizeId());
            if (existing != null) {
                cartItemDAO.incrementQuantity(existing.getId(), item.getQuantity());
            } else {
                CartItem newItem = new CartItem();
                newItem.setCartId(cartId);
                newItem.setProductId(item.getProductId());
                newItem.setProductSizeId(item.getProductSizeId());
                newItem.setQuantity(item.getQuantity());
                cartItemDAO.createAndReturnId(newItem);
            }
        }

        resp.sendRedirect(req.getContextPath() + "/user/shop?id=" + shopId + "&added=1&cartId=" + cartId);
    }

    private long parseLong(String val) {
        try { return Long.parseLong(val); } catch (Exception e) { return 0; }
    }
}
