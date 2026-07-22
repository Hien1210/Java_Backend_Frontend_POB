package org.example.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.example.daos.ShopDAO;
import org.example.daos.ShopDAOImpl;
import org.example.models.Account;
import org.example.models.Category;
import org.example.models.Shop;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/user/home")
public class UserHomeServlet extends HttpServlet {

    private final ShopDAO shopDAO = new ShopDAOImpl();

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

        List<Category> allCategories = categoryDAO.getAll();
        List<Category> uniqueCategories = new ArrayList<>(allCategories.stream()
                .collect(Collectors.toMap(
                        Category::getCategoryName,
                        c -> c,
                        (a, b) -> a
                ))
                .values());

        req.setAttribute("shops", activeShops);
        req.setAttribute("categories", uniqueCategories);
        req.setAttribute("account", account);
        req.setAttribute("unreadNotifCount", notificationDAO.countUnread(account.getId()));
        req.getRequestDispatcher("/user/trangnguoidung.jsp").forward(req, resp);
    }
}
