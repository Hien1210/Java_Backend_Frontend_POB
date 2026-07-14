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

@WebServlet("/user/shop")
public class UserShopMenuServlet extends HttpServlet {

    private final ShopDAO shopDAO = new ShopDAOImpl();
    private final ProductDAO productDAO = new ProductDAOImpl();
    private final ProductSizeDAO productSizeDAO = new ProductSizeDAOImpl();
    private final ToppingDAO toppingDAO = new ToppingDAOImpl();
    private final CategoryDAO categoryDAO = new CategoryDAOImpl();
    private final CartDAO cartDAO = new CartDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession(false);
        Account account = session == null ? null : (Account) session.getAttribute("account");
        if (account == null || account.getRoleId() != 3) {
            resp.sendRedirect(req.getContextPath() + "/dangnhap");
            return;
        }

        long shopId = 0;
        try { shopId = Long.parseLong(req.getParameter("id")); } catch (Exception ignored) {}

        Shop shop = shopId > 0 ? shopDAO.selectShopById(shopId) : null;
        if (shop == null) {
            resp.sendRedirect(req.getContextPath() + "/user/home");
            return;
        }

        List<Product> products = productDAO.findByShopId(shopId);
        for (Product p : products) {
            List<ProductSize> sizes = productSizeDAO.findByProductId(p.getId());
            p.setSizes(sizes);
        }

        List<Category> categories = categoryDAO.findByShopId(shopId);
        List<Topping> toppings = toppingDAO.findByShopId(shopId);

        Cart cart = cartDAO.findByUserId(account.getId());

        req.setAttribute("shop", shop);
        req.setAttribute("products", products);
        req.setAttribute("categories", categories);
        req.setAttribute("toppings", toppings);
        req.setAttribute("cart", cart);
        req.setAttribute("account", account);
        req.getRequestDispatcher("/user/menuShop.jsp").forward(req, resp);
    }
}
