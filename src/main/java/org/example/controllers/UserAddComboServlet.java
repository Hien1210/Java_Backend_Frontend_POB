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

        // Quy doi Combos.combo_price (gia tron goi) thanh gia/don vi cho tung CartItem con, ty le
        // theo gia tri goc (sizePrice * quantity) cua tung mon trong combo, "khoa" vao Cart_Items
        // luc them - tranh checkout/gio hang tinh lai theo gia le tung mon (bo qua uu dai combo).
        // Dong cuoi cung nhan phan du lam tron de tong cac dong luon khop chinh xac combo_price.
        double totalNormalValue = 0;
        for (ComboItem item : comboItems) {
            totalNormalValue += item.getSizePrice() * item.getQuantity();
        }
        double comboPrice = combo.getComboPrice();
        double[] allocatedTotalByItem = new double[comboItems.size()];
        double allocatedSoFar = 0;
        for (int i = 0; i < comboItems.size(); i++) {
            if (i == comboItems.size() - 1) {
                allocatedTotalByItem[i] = comboPrice - allocatedSoFar;
            } else {
                double weight = totalNormalValue > 0 ? (comboItems.get(i).getSizePrice() * comboItems.get(i).getQuantity()) / totalNormalValue : 1.0 / comboItems.size();
                allocatedTotalByItem[i] = Math.round(comboPrice * weight);
                allocatedSoFar += allocatedTotalByItem[i];
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

        for (int i = 0; i < comboItems.size(); i++) {
            ComboItem item = comboItems.get(i);
            double comboUnitPrice = allocatedTotalByItem[i] / item.getQuantity();

            // Chi gop so luong voi 1 CartItem dang thuoc DUNG combo nay (khong gop nham vao mon le
            // hoac combo khac) - giu nguyen don gia combo da khoa cho ca dong.
            CartItem existing = cartItemDAO.findByCartIdProductSizeCombo(cartId, item.getProductId(), item.getProductSizeId(), comboId);
            if (existing != null) {
                cartItemDAO.incrementQuantity(existing.getId(), item.getQuantity());
            } else {
                cartItemDAO.createComboItem(cartId, item.getProductId(), item.getProductSizeId(),
                        item.getQuantity(), comboId, comboUnitPrice);
            }
        }

        resp.sendRedirect(req.getContextPath() + "/user/shop?id=" + shopId + "&added=1&cartId=" + cartId);
    }

    private long parseLong(String val) {
        try { return Long.parseLong(val); } catch (Exception e) { return 0; }
    }
}
