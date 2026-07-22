package org.example.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.example.daos.CartDAO;
import org.example.daos.CartDAOImpl;
import org.example.daos.CartItemDAO;
import org.example.daos.CartItemDAOImpl;
import org.example.models.Account;
import org.example.models.Cart;
import org.example.models.CartItem;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/cart-items")
public class CartItemServlet extends HttpServlet {
    private static final String LIST_VIEW = "/user/cartItemDanhSach.jsp";
    private static final String FORM_VIEW = "/user/cartItemThemSua.jsp";

    private final CartItemDAO dao = new CartItemDAOImpl();
    private final CartDAO cartDAO = new CartDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        Account account = requireLogin(req, resp);
        if (account == null) return;
        String action = normalize(req.getParameter("action"));

        switch (action) {
            case "new":
                req.getRequestDispatcher(FORM_VIEW).forward(req, resp);
                break;
            case "edit":
                showEditForm(req, resp, account);
                break;
            case "delete":
                deleteItem(req, resp, account);
                break;
            default:
                listItems(req, resp, account);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        Account account = requireLogin(req, resp);
        if (account == null) return;
        String action = normalize(req.getParameter("action"));

        if ("update".equals(action)) {
            updateItem(req, resp, account);
        } else {
            createItem(req, resp, account);
        }
    }

    /** Chi liet ke chi tiet cua gio hang thuoc CHINH tai khoan dang dang nhap. */
    private void listItems(HttpServletRequest req, HttpServletResponse resp, Account account) throws ServletException, IOException {
        List<CartItem> items = new ArrayList<>();
        Cart ownCart = cartDAO.findByUserId(account.getId());
        if (ownCart != null) {
            items = dao.findByCartId(ownCart.getId());
        }
        req.setAttribute("cartItemList", items);
        req.getRequestDispatcher(LIST_VIEW).forward(req, resp);
    }

    private void showEditForm(HttpServletRequest req, HttpServletResponse resp, Account account) throws ServletException, IOException {
        Long id = parseId(req);
        CartItem item = id == null ? null : dao.findById(id);
        if (item == null || !ownsCartItem(item, account)) {
            resp.sendRedirect(req.getContextPath() + "/cart-items?error=not_found");
            return;
        }

        req.setAttribute("cartItem", item);
        req.getRequestDispatcher(FORM_VIEW).forward(req, resp);
    }

    private void createItem(HttpServletRequest req, HttpServletResponse resp, Account account) throws ServletException, IOException {
        CartItem item = readItem(req);
        // cartId nguoi dung nhap tuy y qua form -> bat buoc phai la gio hang cua CHINH ho.
        Cart cart = cartDAO.findById(item.getCartId());
        if (cart == null || cart.getUserId() != account.getId()) {
            fail(req, resp, "Gio hang khong hop le", item);
            return;
        }

        String error = validateItem(item);
        if (error != null) {
            fail(req, resp, error, item);
            return;
        }

        if (!dao.create(item)) {
            fail(req, resp, "Loi tao chi tiet gio hang", item);
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/cart-items?success=created");
    }

    private void updateItem(HttpServletRequest req, HttpServletResponse resp, Account account) throws ServletException, IOException {
        Long id = parseId(req);
        CartItem existing = id == null ? null : dao.findById(id);
        if (existing == null || !ownsCartItem(existing, account)) {
            resp.sendRedirect(req.getContextPath() + "/cart-items?error=not_found");
            return;
        }

        CartItem item = readItem(req);
        item.setId(id);
        // Khong cho doi cartId sang gio hang khac qua form - giu nguyen cartId that cua ban ghi.
        item.setCartId(existing.getCartId());
        String error = validateItem(item);
        if (error != null) {
            fail(req, resp, error, item);
            return;
        }

        if (!dao.update(item)) {
            fail(req, resp, "Loi cap nhat chi tiet gio hang", item);
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/cart-items?success=updated");
    }

    private void deleteItem(HttpServletRequest req, HttpServletResponse resp, Account account) throws IOException {
        Long id = parseId(req);
        CartItem item = id == null ? null : dao.findById(id);
        if (item == null || !ownsCartItem(item, account)) {
            resp.sendRedirect(req.getContextPath() + "/cart-items?error=not_found");
            return;
        }

        boolean deleted = dao.delete(id);
        resp.sendRedirect(req.getContextPath() + "/cart-items?" + (deleted ? "success=deleted" : "error=not_found"));
    }

    private boolean ownsCartItem(CartItem item, Account account) {
        Cart cart = cartDAO.findById(item.getCartId());
        return cart != null && cart.getUserId() == account.getId();
    }

    private CartItem readItem(HttpServletRequest req) {
        CartItem item = new CartItem();
        item.setCartId(parseLong(req.getParameter("cartId")));
        item.setProductId(parseLong(req.getParameter("productId")));
        item.setProductSizeId(parseLong(req.getParameter("productSizeId")));
        item.setQuantity(parseInt(req.getParameter("quantity")));
        return item;
    }

    private String validateItem(CartItem item) {
        if (item.getCartId() <= 0) return "Cart ID khong hop le";
        if (item.getProductId() <= 0) return "Product ID khong hop le";
        if (item.getProductSizeId() <= 0) return "Product Size ID khong hop le";
        if (item.getQuantity() <= 0) return "So luong phai lon hon 0";
        return null;
    }

    private void fail(HttpServletRequest req, HttpServletResponse resp, String error, CartItem item)
            throws ServletException, IOException {
        req.setAttribute("error", error);
        req.setAttribute("cartItem", item);
        req.getRequestDispatcher(FORM_VIEW).forward(req, resp);
    }

    private Long parseId(HttpServletRequest req) {
        try {
            String value = normalize(req.getParameter("id"));
            return value.isEmpty() ? null : Long.parseLong(value);
        } catch (Exception e) {
            return null;
        }
    }

    private long parseLong(String value) {
        try {
            String normalized = normalize(value);
            return normalized.isEmpty() ? 0 : Long.parseLong(normalized);
        } catch (Exception e) {
            return 0;
        }
    }

    private int parseInt(String value) {
        try {
            String normalized = normalize(value);
            return normalized.isEmpty() ? 0 : Integer.parseInt(normalized);
        } catch (Exception e) {
            return 0;
        }
    }

    private String normalize(String value) {
        return value == null ? "" : value.trim();
    }

    /** Chi khach dang dang nhap (roleId=3) moi duoc xem/thao tac chi tiet gio hang cua CHINH minh. */
    private Account requireLogin(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        Account account = session != null ? (Account) session.getAttribute("account") : null;
        if (account == null || account.getRoleId() != 3) {
            resp.sendRedirect(req.getContextPath() + "/dangnhap");
            return null;
        }
        return account;
    }
}
