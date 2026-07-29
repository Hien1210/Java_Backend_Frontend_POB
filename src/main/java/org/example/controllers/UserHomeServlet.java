package org.example.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.example.daos.NotificationDAO;
import org.example.daos.NotificationDAOImpl;
import org.example.daos.ProductDAO;
import org.example.daos.ProductDAOImpl;
import org.example.daos.ShopDAO;
import org.example.daos.ShopDAOImpl;
import org.example.models.Account;
import org.example.models.Product;
import org.example.models.Shop;
import org.json.JSONArray;
import org.json.JSONObject;

import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/user/home")
public class UserHomeServlet extends HttpServlet {

    private final ShopDAO shopDAO = new ShopDAOImpl();
    private final NotificationDAO notificationDAO = new NotificationDAOImpl();
    private final ProductDAO productDAO = new ProductDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession(false);
        Account account = session == null ? null : (Account) session.getAttribute("account");
        if (account == null || account.getRoleId() != 3) {
            resp.sendRedirect(req.getContextPath() + "/dangnhap");
            return;
        }

        List<Shop> allShops = shopDAO.selectAllShops();
        List<Shop> activeShops = allShops.stream()
                .filter(s -> {
                    String st = s.getStatus() == null ? "" : s.getStatus().trim().toLowerCase();
                    return st.equals("accept") || st.equals("accepted")
                            || st.equals("approved") || st.equals("active");
                })
                .collect(Collectors.toList());

        // Chi muc tim kiem: shopId -> danh sach ten mon (de o tim kiem tren trang chu khop
        // duoc theo ten mon, khong chi ten/mo ta/dia chi quan) — xem CRUD_DA_LAM.md.
        JSONObject shopProductsIndex = new JSONObject();
        for (Shop shop : activeShops) {
            List<Product> products = productDAO.findByShopId(shop.getId());
            JSONArray names = new JSONArray();
            for (Product p : products) {
                if ("HIDDEN".equalsIgnoreCase(p.getStaTus())) continue;
                if (p.getProductName() != null) names.put(p.getProductName());
            }
            if (names.length() > 0) {
                shopProductsIndex.put(String.valueOf(shop.getId()), names);
            }
        }

        req.setAttribute("shops", activeShops);
        req.setAttribute("account", account);
        req.setAttribute("unreadNotifCount", notificationDAO.countUnread(account.getId()));
        req.setAttribute("shopProductsJson", shopProductsIndex.toString());
        req.getRequestDispatcher("/user/trangnguoidung.jsp").forward(req, resp);
    }
}
