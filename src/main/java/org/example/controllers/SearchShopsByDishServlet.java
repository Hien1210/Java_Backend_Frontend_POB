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
import org.example.models.Shop;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/user/search-shops-by-dish")
public class SearchShopsByDishServlet extends HttpServlet {

    private final ShopDAO shopDAO = new ShopDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json;charset=UTF-8");

        HttpSession session = req.getSession(false);
        Account account = session == null ? null : (Account) session.getAttribute("account");
        if (account == null || account.getRoleId() != 3) {
            resp.setStatus(HttpServletResponse.SC_FORBIDDEN);
            resp.getWriter().write("[]");
            return;
        }

        String q = req.getParameter("q");
        PrintWriter out = resp.getWriter();
        if (q == null || q.trim().length() < 2) {
            out.write("[]");
            return;
        }

        List<Shop> matched = shopDAO.searchShopsByProductName(q.trim());
        List<Long> shopIds = matched.stream()
                .filter(s -> {
                    String st = s.getStatus() == null ? "" : s.getStatus().trim().toLowerCase();
                    return st.equals("accept") || st.equals("accepted")
                            || st.equals("approved") || st.equals("active");
                })
                .map(Shop::getId)
                .collect(Collectors.toList());

        out.write(shopIds.stream().map(String::valueOf).collect(Collectors.joining(",", "[", "]")));
    }
}
