package org.example.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.example.daos.NotificationDAO;
import org.example.daos.NotificationDAOImpl;
import org.example.daos.OrderDAO;
import org.example.daos.OrderDAOImpl;
import org.example.daos.ShopDAO;
import org.example.daos.ShopDAOImpl;
import org.example.models.Notification;
import org.example.models.Account;
import org.example.models.Order;
import org.example.models.Shop;

import java.io.IOException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/shipper/nhan-don")
public class ShipperAcceptOrderServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAOImpl();
    private final ShopDAO  shopDAO  = new ShopDAOImpl();
    private final NotificationDAO notificationDAO = new NotificationDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Account account = currentShipper(req, resp);
        if (account == null) return;

        List<Order> available = orderDAO.findAvailableOrders();

        // Gắn thêm tên shop cho từng đơn
        List<Map<String, Object>> orders = new ArrayList<>();
        for (Order o : available) {
            Map<String, Object> row = new LinkedHashMap<>();
            row.put("id",            o.getId());
            row.put("shippingAddress", o.getShippingAddress());
            row.put("receiverName",  o.getReceiverName());
            row.put("receiverPhone", o.getReceiverPhone());
            row.put("totalPrice",    o.getTotalPrice()  != null ? o.getTotalPrice()  : 0.0);
            row.put("deliveryFee",   o.getDeliveryFee() != null ? o.getDeliveryFee() : 0.0);
            row.put("paymentMethod", o.getPaymentMethod());
            row.put("createdAt",     o.getCreatedAt());

            Shop shop = shopDAO.selectShopById(o.getShopId());
            row.put("shopName",    shop != null ? shop.getShopName()    : "—");
            row.put("shopAddress", shop != null ? shop.getShopAddress() : "—");
            row.put("shopPhone",   shop != null ? shop.getShopPhone()   : "—");
            orders.add(row);
        }

        String tenShipper = account.getFullName() != null ? account.getFullName() : account.getUserName();
        req.setAttribute("availableOrders", orders);
        req.setAttribute("tenShipper", tenShipper);
        req.getRequestDispatcher("/shipper/nhanDon.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Account account = currentShipper(req, resp);
        if (account == null) return;

        // Chỉ cho nhận đơn khi đang Online
        if (!account.isOnline()) {
            resp.sendRedirect(req.getContextPath() + "/shipper/nhan-don?error=offline");
            return;
        }

        String idParam = req.getParameter("orderId");
        if (idParam == null) {
            resp.sendRedirect(req.getContextPath() + "/shipper/nhan-don");
            return;
        }

        long orderId;
        try { orderId = Long.parseLong(idParam); }
        catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/shipper/nhan-don");
            return;
        }

        // Đồ ăn không thể giao qua ngày: nếu đơn được tạo khác ngày hôm nay thì từ chối nhận
        // và hủy luôn đơn (dù trước đó có lọt qua danh sách vì lý do gì đó, vd cache/race).
        Order order = orderDAO.findById(orderId);
        if (order != null && order.getCreatedAt() != null
                && !order.getCreatedAt().toLocalDate().isEqual(java.time.LocalDate.now())) {
            orderDAO.updateStatus(orderId, "CANCELLED");
            resp.sendRedirect(req.getContextPath() + "/shipper/nhan-don?error=expired");
            return;
        }

        boolean success = orderDAO.assignShipper(orderId, account.getId());
        if (success) {
            Notification n = new Notification();
            n.setAccountId(account.getId());
            n.setTitle("📦 Nhận đơn thành công");
            n.setMessage("Bạn đã nhận đơn hàng #" + orderId + ". Hãy đến cửa hàng lấy hàng và giao cho khách.");
            notificationDAO.create(n);
            resp.sendRedirect(req.getContextPath() + "/shipper/donhang?success=accepted");
        } else {
            // Đơn đã bị shipper khác nhận trước (race condition)
            resp.sendRedirect(req.getContextPath() + "/shipper/nhan-don?error=taken");
        }
    }

    private Account currentShipper(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null) { resp.sendRedirect(req.getContextPath() + "/dangnhap"); return null; }
        Object obj = session.getAttribute("account");
        if (!(obj instanceof Account)) { resp.sendRedirect(req.getContextPath() + "/dangnhap"); return null; }
        Account a = (Account) obj;
        if (a.getRoleId() != 4) { resp.sendRedirect(req.getContextPath() + "/dangnhap"); return null; }
        return a;
    }
}
