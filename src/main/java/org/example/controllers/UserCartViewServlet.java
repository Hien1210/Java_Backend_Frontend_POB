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
import java.util.*;

@WebServlet("/user/cart")
public class UserCartViewServlet extends HttpServlet {

    private final CartDAO cartDAO = new CartDAOImpl();
    private final CartItemDAO cartItemDAO = new CartItemDAOImpl();
    private final CartItemToppingDAO cartItemToppingDAO = new CartItemToppingDAOImpl();
    private final ProductDAO productDAO = new ProductDAOImpl();
    private final ProductSizeDAO productSizeDAO = new ProductSizeDAOImpl();
    private final ToppingDAO toppingDAO = new ToppingDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        Account account = getAccount(req, resp);
        if (account == null) return;

        loadCart(req, account);
        req.getRequestDispatcher("/user/gioHang.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        Account account = getAccount(req, resp);
        if (account == null) return;

        String action = req.getParameter("action");
        long itemId = parseLong(req.getParameter("itemId"));

        if ("remove".equals(action)) {
            cartItemDAO.delete(itemId);

        } else if ("qty".equals(action)) {
            int qty = parseInt(req.getParameter("qty"), 1);
            CartItem item = cartItemDAO.findById(itemId);
            if (item != null) {
                item.setQuantity(qty);
                cartItemDAO.update(item);
            }

        } else if ("edit".equals(action)) {
            long sizeId = parseLong(req.getParameter("sizeId"));
            int qty = parseInt(req.getParameter("quantity"), 1);
            String[] toppingIds  = req.getParameterValues("toppingId");
            String[] toppingQtys = req.getParameterValues("toppingQty");

            CartItem item = cartItemDAO.findById(itemId);
            if (item != null && sizeId > 0) {
                item.setProductSizeId(sizeId);
                item.setQuantity(qty);
                cartItemDAO.update(item);

                // Xóa topping cũ, thêm topping mới
                cartItemToppingDAO.deleteByCartItemId(itemId);
                if (toppingIds != null) {
                    for (int i = 0; i < toppingIds.length; i++) {
                        long tId = parseLong(toppingIds[i]);
                        int tQty = (toppingQtys != null && i < toppingQtys.length)
                                ? parseInt(toppingQtys[i], 1) : 1;
                        if (tId > 0 && tQty > 0) {
                            cartItemToppingDAO.create(itemId, tId, tQty);
                        }
                    }
                }
            }
        }

        resp.sendRedirect(req.getContextPath() + "/user/cart");
    }

    private void loadCart(HttpServletRequest req, Account account) {
        Cart cart = cartDAO.findByUserId(account.getId());
        if (cart == null) {
            req.setAttribute("cartLines", new ArrayList<>());
            req.setAttribute("subtotal", 0.0);
            return;
        }
        req.setAttribute("cart", cart);

        // Map shopId → toppings (dùng cho modal sửa)
        Map<Long, List<Topping>> shopToppingsMap = new LinkedHashMap<>();

        List<CartLine> lines = new ArrayList<>();
        double subtotal = 0;

        for (CartItem item : cartItemDAO.findByCartId(cart.getId())) {
            Product product = productDAO.findById(item.getProductId());
            if (product == null) continue;
            ProductSize size = productSizeDAO.findById(item.getProductSizeId());
            if (size == null) continue;

            // Sizes của sản phẩm
            List<ProductSize> productSizes = productSizeDAO.findByProductId(product.getId());

            // Toppings của shop
            long shopId = product.getShopId();
            if (!shopToppingsMap.containsKey(shopId)) {
                shopToppingsMap.put(shopId, toppingDAO.findByShopId(shopId));
            }

            // Toppings hiện tại của cart item (id → qty)
            Map<Long, Integer> currentToppingQty = new LinkedHashMap<>();
            List<CartToppingLine> toppingLines = new ArrayList<>();
            double toppingTotal = 0;
            for (CartItemTopping cit : cartItemToppingDAO.findByCartItemId(item.getId())) {
                Topping t = toppingDAO.findById(cit.getToppingId());
                if (t == null) continue;
                currentToppingQty.put(cit.getToppingId(), cit.getQuantity());
                double lineTotal = t.getPrice() * cit.getQuantity();
                toppingTotal += lineTotal;
                toppingLines.add(new CartToppingLine(t.getToppingName(), cit.getQuantity(), t.getPrice()));
            }

            double lineTotal = size.getPrice() * item.getQuantity() + toppingTotal;
            subtotal += lineTotal;
            lines.add(new CartLine(item.getId(), product, size, productSizes, item.getQuantity(),
                    toppingLines, currentToppingQty, lineTotal));
        }

        req.setAttribute("cartLines", lines);
        req.setAttribute("subtotal", subtotal);
        req.setAttribute("shopToppingsMap", shopToppingsMap);
    }

    private Account getAccount(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        Account account = session == null ? null : (Account) session.getAttribute("account");
        if (account == null || account.getRoleId() != 3) {
            resp.sendRedirect(req.getContextPath() + "/dangnhap");
            return null;
        }
        return account;
    }

    private long parseLong(String s) {
        try { return Long.parseLong(s); } catch (Exception e) { return 0; }
    }

    private int parseInt(String s, int def) {
        try { int v = Integer.parseInt(s); return v > 0 ? v : def; } catch (Exception e) { return def; }
    }

    public static final class CartLine {
        private final long itemId;
        private final Product product;
        private final ProductSize size;
        private final List<ProductSize> productSizes;
        private final int quantity;
        private final List<CartToppingLine> toppings;
        private final Map<Long, Integer> currentToppingQty;
        private final double lineTotal;

        public CartLine(long itemId, Product product, ProductSize size, List<ProductSize> productSizes,
                        int quantity, List<CartToppingLine> toppings,
                        Map<Long, Integer> currentToppingQty, double lineTotal) {
            this.itemId = itemId;
            this.product = product;
            this.size = size;
            this.productSizes = productSizes;
            this.quantity = quantity;
            this.toppings = toppings;
            this.currentToppingQty = currentToppingQty;
            this.lineTotal = lineTotal;
        }

        public long getItemId() { return itemId; }
        public Product getProduct() { return product; }
        public ProductSize getSize() { return size; }
        public List<ProductSize> getProductSizes() { return productSizes; }
        public int getQuantity() { return quantity; }
        public List<CartToppingLine> getToppings() { return toppings; }
        public Map<Long, Integer> getCurrentToppingQty() { return currentToppingQty; }
        public double getLineTotal() { return lineTotal; }
    }

    public static final class CartToppingLine {
        private final String name;
        private final int quantity;
        private final double price;

        public CartToppingLine(String name, int quantity, double price) {
            this.name = name;
            this.quantity = quantity;
            this.price = price;
        }

        public String getName() { return name; }
        public int getQuantity() { return quantity; }
        public double getPrice() { return price; }
    }
}
