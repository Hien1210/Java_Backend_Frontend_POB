package org.example.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.example.daos.OrderDAO;
import org.example.daos.OrderDAOImpl;
import org.example.daos.ShopDAO;
import org.example.daos.ShopDAOImpl;
import org.example.models.Account;
import org.example.models.Order;
import org.example.models.Shop;

import java.io.IOException;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;

@WebServlet("/shipper/dashboard")
public class ShipperDashboardServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAOImpl();
    private final ShopDAO  shopDAO  = new ShopDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Account account = currentShipper(req);
        if (account == null) {
            resp.sendRedirect(req.getContextPath() + "/dangnhap");
            return;
        }

        List<Order> allOrders = orderDAO.findByShipperId(account.getId());
        List<Order> doneOrders = new ArrayList<>();
        for (Order o : allOrders) {
            if ("DONE".equals(o.getStaTus())) doneOrders.add(o);
        }

        LocalDate today     = LocalDate.now();
        LocalDate weekStart = today.with(DayOfWeek.MONDAY);
        LocalDate monthStart = today.withDayOfMonth(1);

        long   donHomNay = 0, donTuanNay = 0, donThangNay = 0, tongDon = doneOrders.size();
        double thuHomNay = 0, thuTuanNay = 0, thuThangNay = 0;

        // Doanh thu 7 ngày gần đây — key: "dd/MM", value: tổng phí ship
        Map<String, Double> revenue7Days = new LinkedHashMap<>();
        DateTimeFormatter fmt = DateTimeFormatter.ofPattern("dd/MM");
        for (int i = 6; i >= 0; i--) {
            revenue7Days.put(today.minusDays(i).format(fmt), 0.0);
        }

        for (Order o : doneOrders) {
            if (o.getCreatedAt() == null) continue;
            LocalDate date = o.getCreatedAt().toLocalDate();
            double fee = o.getDeliveryFee() != null ? o.getDeliveryFee() : 0;

            if (date.equals(today))          { donHomNay++;  thuHomNay  += fee; }
            if (!date.isBefore(weekStart))   { donTuanNay++;  thuTuanNay  += fee; }
            if (!date.isBefore(monthStart))  { donThangNay++; thuThangNay += fee; }

            String dayKey = date.format(fmt);
            if (revenue7Days.containsKey(dayKey)) {
                revenue7Days.put(dayKey, revenue7Days.get(dayKey) + fee);
            }
        }

        // 10 đơn gần nhất đã hoàn thành
        List<Map<String, Object>> recentDone = new ArrayList<>();
        List<Order> sorted = new ArrayList<>(doneOrders);
        sorted.sort((a, b) -> b.getId() > a.getId() ? 1 : -1);
        for (int i = 0; i < Math.min(10, sorted.size()); i++) {
            Order o = sorted.get(i);
            Map<String, Object> row = new LinkedHashMap<>();
            row.put("id",          o.getId());
            row.put("createdAt",   o.getCreatedAt());
            row.put("receiverName", o.getReceiverName());
            row.put("totalPrice",  o.getTotalPrice());
            row.put("deliveryFee", o.getDeliveryFee() != null ? o.getDeliveryFee() : 0.0);
            row.put("paymentMethod", o.getPaymentMethod());

            Shop shop = shopDAO.selectShopById(o.getShopId());
            row.put("shopName", shop != null ? shop.getShopName() : "—");
            recentDone.add(row);
        }

        // Đơn đang hoạt động (chưa DONE)
        long dangChoLayHang = 0, dangGiao = 0;
        for (Order o : allOrders) {
            if ("READY_FOR_PICKUP".equals(o.getStaTus())) dangChoLayHang++;
            else if ("SHIPPING".equals(o.getStaTus()))    dangGiao++;
        }

        // Truyền sang JSP
        String tenShipper = account.getFullName() != null ? account.getFullName() : account.getUserName();
        req.setAttribute("tenShipper",   tenShipper);
        req.setAttribute("donHomNay",    donHomNay);
        req.setAttribute("donTuanNay",   donTuanNay);
        req.setAttribute("donThangNay",  donThangNay);
        req.setAttribute("tongDon",      tongDon);
        req.setAttribute("thuHomNay",    thuHomNay);
        req.setAttribute("thuTuanNay",   thuTuanNay);
        req.setAttribute("thuThangNay",  thuThangNay);
        req.setAttribute("dangChoLayHang", dangChoLayHang);
        req.setAttribute("dangGiao",     dangGiao);
        req.setAttribute("recentDone",   recentDone);

        // Chart labels & data dưới dạng JSON string
        StringBuilder labels = new StringBuilder("[");
        StringBuilder data   = new StringBuilder("[");
        boolean first = true;
        for (Map.Entry<String, Double> e : revenue7Days.entrySet()) {
            if (!first) { labels.append(","); data.append(","); }
            labels.append("\"").append(e.getKey()).append("\"");
            data.append(Math.round(e.getValue()));
            first = false;
        }
        labels.append("]");
        data.append("]");
        req.setAttribute("chartLabels", labels.toString());
        req.setAttribute("chartData",   data.toString());

        req.getRequestDispatcher("/shipper/dashboard.jsp").forward(req, resp);
    }

    private Account currentShipper(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        if (session == null) return null;
        Object obj = session.getAttribute("account");
        if (!(obj instanceof Account)) return null;
        Account a = (Account) obj;
        return a.getRoleId() == 4 ? a : null;
    }
}
