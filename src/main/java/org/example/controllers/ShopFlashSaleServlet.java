package org.example.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.example.daos.*;
import org.example.models.*;
import java.util.List;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeParseException;
import java.util.List;

@WebServlet("/shop/flash-sale")
public class ShopFlashSaleServlet extends HttpServlet {

    private final FlashSaleDAO flashSaleDAO = new FlashSaleDAOImpl();
    private final ProductDAO productDAO = new ProductDAOImpl();
    private final ProductSizeDAO productSizeDAO = new ProductSizeDAOImpl();
    private final ShopDAO shopDAO = new ShopDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Shop shop = getShop(req, resp);
        if (shop == null) return;

        List<FlashSale> flashSales = flashSaleDAO.findByShopId(shop.getId());
        req.setAttribute("flashSales", flashSales);

        List<Product> products = productDAO.findByShopId(shop.getId());
        req.setAttribute("products", products);

        java.util.Map<Long, String> productNameById = new java.util.LinkedHashMap<>();
        java.util.List<ProductSize> allSizes = new java.util.ArrayList<>();
        for (Product p : products) {
            productNameById.put(p.getId(), p.getProductName());
            for (ProductSize s : productSizeDAO.findByProductId(p.getId())) {
                s.setProductId(p.getId());
                allSizes.add(s);
            }
        }
        req.setAttribute("allSizes", allSizes);
        req.setAttribute("productNameById", productNameById);

        req.setAttribute("shop", shop);
        req.getRequestDispatcher("/shop/QuanlyFlashSale.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        Shop shop = getShop(req, resp);
        if (shop == null) return;

        String action = req.getParameter("action");

        if ("delete".equals(action)) {
            long fsId = parseLong(req.getParameter("flashSaleId"));
            FlashSale existing = flashSaleDAO.findById(fsId);
            if (existing != null && existing.getShopId() == shop.getId()) {
                flashSaleDAO.delete(fsId);
            }
            resp.sendRedirect(req.getContextPath() + "/shop/flash-sale?deleted=1");
            return;
        }

        long productSizeId = parseLong(req.getParameter("productSizeId"));
        double salePrice = parseDouble(req.getParameter("salePrice"));
        LocalDateTime startTime = parseDateTime(req.getParameter("startTime"));
        LocalDateTime endTime = parseDateTime(req.getParameter("endTime"));

        if (productSizeId <= 0 || salePrice <= 0 || startTime == null || endTime == null || !endTime.isAfter(startTime)) {
            resp.sendRedirect(req.getContextPath() + "/shop/flash-sale?error=invalid");
            return;
        }

        ProductSize size = productSizeDAO.findById(productSizeId);
        if (size == null) {
            resp.sendRedirect(req.getContextPath() + "/shop/flash-sale?error=notfound");
            return;
        }

        FlashSale fs = new FlashSale();
        fs.setShopId(shop.getId());
        fs.setProductSizeId(productSizeId);
        fs.setSalePrice(salePrice);
        fs.setStartTime(startTime);
        fs.setEndTime(endTime);
        fs.setActive(true);
        flashSaleDAO.create(fs);

        resp.sendRedirect(req.getContextPath() + "/shop/flash-sale?saved=1");
    }

    private Shop getShop(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        Account account = session != null ? (Account) session.getAttribute("account") : null;
        if (account == null || account.getRoleId() != 2) {
            resp.sendRedirect(req.getContextPath() + "/dangnhap");
            return null;
        }
        Shop shop = shopDAO.selectShopByOwnerId(account.getId());
        if (shop == null) {
            resp.sendRedirect(req.getContextPath() + "/dangnhap");
            return null;
        }
        return shop;
    }

    private String trim(String s) { return s == null ? "" : s.trim(); }
    private long parseLong(String s) { try { return Long.parseLong(trim(s)); } catch (Exception e) { return 0; } }
    private double parseDouble(String s) { try { return Double.parseDouble(trim(s)); } catch (Exception e) { return 0; } }
    private LocalDateTime parseDateTime(String s) {
        try { return s == null ? null : LocalDateTime.parse(trim(s)); } catch (DateTimeParseException e) { return null; }
    }
}
