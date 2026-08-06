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
import org.example.daos.OrderLogDAO;
import org.example.daos.OrderLogDAOImpl;
import org.example.daos.ShipperWalletDAO;
import org.example.daos.ShipperWalletDAOImpl;
import org.example.daos.ShopDAO;
import org.example.daos.ShopDAOImpl;
import org.example.daos.ShopWalletDAO;
import org.example.daos.ShopWalletDAOImpl;
import org.example.models.Notification;
import org.example.models.Account;
import org.example.models.BillView;
import org.example.models.Order;
import org.example.models.OrderLog;
import org.example.models.Shop;
import org.example.models.ShipperOrderView;
import org.example.utils.BillUtil;

import java.io.IOException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/shipper/donhang")
public class ShipperOrderServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAOImpl();
    private final ShopDAO shopDAO = new ShopDAOImpl();
    private final NotificationDAO notificationDAO = new NotificationDAOImpl();
    private final OrderLogDAO orderLogDAO = new OrderLogDAOImpl();
    private final ShipperWalletDAO walletDAO = new ShipperWalletDAOImpl();
    private final ShopWalletDAO shopWalletDAO = new ShopWalletDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Account account = currentShipper(req);
        if (account == null) {
            resp.sendRedirect(req.getContextPath() + "/dangnhap");
            return;
        }

        String action = req.getParameter("action");
        if ("detail".equals(action)) {
            handleDetail(req, resp, account);
            return;
        }

        List<Order> orders = orderDAO.findByShipperId(account.getId());
        List<ShipperOrderView> danhSachDonHang = new ArrayList<>();
        for (Order order : orders) {
            ShipperOrderView view = new ShipperOrderView();
            view.setId(order.getId());
            view.setStatus(order.getStaTus());
            view.setShippingAddress(order.getShippingAddress());
            view.setReceiverName(order.getReceiverName());
            view.setReceiverPhone(order.getReceiverPhone());
            view.setPaymentMethod(order.getPaymentMethod());
            view.setTotalPrice(order.getTotalPrice());
            view.setCreatedAt(order.getCreatedAt());

            Shop shop = shopDAO.selectShopById(order.getShopId());
            if (shop != null) {
                view.setShopName(shop.getShopName());
                view.setShopAddress(shop.getShopAddress());
                view.setShopPhone(shop.getShopPhone());
            }

            danhSachDonHang.add(view);
        }

        // Tính thống kê thực từ danh sách đơn
        LocalDate today = LocalDate.now();
        long donChoLayHang = 0, donDangGiao = 0, donHoanThanhHomNay = 0;
        double thuNhapHomNay = 0.0;
        for (ShipperOrderView v : danhSachDonHang) {
            String st = v.getStatus();
            if ("PENDING".equals(st) || "CONFIRMED".equals(st) || "READY_FOR_PICKUP".equals(st)) donChoLayHang++;
            else if ("SHIPPING".equals(st)) donDangGiao++;
            else if ("DONE".equals(st) && v.getCreatedAt() != null && v.getCreatedAt().toLocalDate().equals(today)) {
                donHoanThanhHomNay++;
                if (orders.stream().anyMatch(o -> o.getId() == v.getId() && o.getDeliveryFee() != null)) {
                    for (Order o : orders) {
                        if (o.getId() == v.getId() && o.getDeliveryFee() != null) {
                            thuNhapHomNay += o.getDeliveryFee();
                        }
                    }
                }
            }
        }

        req.setAttribute("danhSachDonHang", danhSachDonHang);
        req.setAttribute("donChoLayHang", donChoLayHang);
        req.setAttribute("donDangGiao", donDangGiao);
        req.setAttribute("donHoanThanhHomNay", donHoanThanhHomNay);
        req.setAttribute("thuNhapHomNay", thuNhapHomNay);
        req.setAttribute("tenShipper", account.getFullName() != null ? account.getFullName() : account.getUserName());
        req.getRequestDispatcher("/shipper/trangchucuashipper.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Account account = currentShipper(req);
        if (account == null) {
            resp.sendRedirect(req.getContextPath() + "/dangnhap");
            return;
        }

        String orderIdParam = req.getParameter("orderId");
        String action = req.getParameter("action");

        if (orderIdParam != null && action != null) {
            long orderId;
            try {
                orderId = Long.parseLong(orderIdParam);
            } catch (NumberFormatException e) {
                orderId = 0;
            }

            Order order = orderId > 0 ? orderDAO.findById(orderId) : null;
            if (order != null && order.getShipperId() == account.getId()) {
                if ("updateStatusToShipping".equals(action) && "READY_FOR_PICKUP".equals(order.getStaTus())) {
                    // Dung CAS atomic (khong phai updateStatus thuong) de tranh 2 request gan dong
                    // thoi (double-click/mang lag) cung lot qua check va cung gui thong bao trung.
                    boolean updated = orderDAO.updateStatusIfCurrent(orderId, "READY_FOR_PICKUP", "SHIPPING");
                    if (updated) {
                        Notification n = new Notification();
                        n.setAccountId(account.getId());
                        n.setTitle("🛵 Bắt đầu giao đơn #" + orderId);
                        n.setMessage("Bạn đã lấy hàng và đang trên đường giao đến khách: " + order.getShippingAddress());
                        notificationDAO.create(n);
                        notifyCustomer(order, "🛵 Đơn hàng #" + orderId + " đang được giao",
                                "Shipper đã lấy hàng và đang trên đường giao đến bạn.");
                    }
                } else if ("updateStatusToDone".equals(action) && "SHIPPING".equals(order.getStaTus())) {
                    // Dung CAS atomic: neu 2 request "giao xong" gan dong thoi cung den day, chi 1
                    // request thang cuoc (updated == true) moi duoc tru kho/cong diem/cong vi -
                    // tranh cong tien/tru kho 2 lan cho cung 1 don.
                    boolean updated = orderDAO.updateStatusIfCurrent(orderId, "SHIPPING", "DONE");
                    if (updated) {
                        // Tiền mặt: khách trả khi nhận hàng → tự động đánh dấu đã thanh toán
                        String pm = order.getPaymentMethod();
                        if (pm != null && (pm.toLowerCase().contains("tiền mặt") || "COD".equalsIgnoreCase(pm) || "CASH".equalsIgnoreCase(pm))) {
                            orderDAO.updatePaymentStatus(orderId, order.getShopId(), "PAID");
                        }
                        org.example.utils.InventoryUtil.decreaseStockForOrder(orderId);
                        org.example.utils.LoyaltyUtil.awardPointsForOrder(orderId);
                        // Credit shipper wallet
                        if (order.getDeliveryFee() != null && order.getDeliveryFee() > 0) {
                            walletDAO.creditEarning(account.getId(), order.getDeliveryFee());
                        }
                        // Credit shop wallet (earnings after commission)
                        Shop shopForWallet = shopDAO.selectShopById(order.getShopId());
                        if (shopForWallet != null && order.getTotalPrice() != null) {
                            double commRate = shopForWallet.getCommissionRate() != null ? shopForWallet.getCommissionRate() : 10.0;
                            double delivFee = order.getDeliveryFee() != null ? order.getDeliveryFee() : 0;
                            shopWalletDAO.creditEarning(shopForWallet.getId(), orderId, order.getTotalPrice(), delivFee, commRate);
                        }
                        OrderLog log = new OrderLog();
                        log.setOrderId(orderId);
                        log.setChangedBy(account.getId());
                        log.setOldStatus("SHIPPING");
                        log.setNewStatus("DONE");
                        log.setNote("Shipper giao hang thanh cong");
                        orderLogDAO.create(log);
                        Notification n = new Notification();
                        n.setAccountId(account.getId());
                        n.setTitle("✅ Giao hàng thành công đơn #" + orderId);
                        n.setMessage("Đơn hàng đã được giao thành công đến " + order.getReceiverName() + ". Phí giao hàng: " +
                                (order.getDeliveryFee() != null ? String.format("%,.0f", order.getDeliveryFee()) + "đ" : "0đ"));
                        notificationDAO.create(n);
                        notifyCustomer(order, "🎉 Đơn hàng #" + orderId + " đã giao thành công",
                                "Đơn hàng của bạn đã được giao thành công. Cảm ơn bạn đã đặt hàng, đừng quên đánh giá nhé!");
                    }
                } else if ("cancelOrder".equals(action)
                        && ("READY_FOR_PICKUP".equals(order.getStaTus()) || "SHIPPING".equals(order.getStaTus()))) {
                    String reason = req.getParameter("reason");
                    reason = reason == null ? "" : reason.trim();
                    if (!reason.isEmpty()) {
                        String oldStatus = order.getStaTus();
                        // Dung cancelOrder(reason) thay vi updateStatus thuong: luu dung
                        // cancel_reason (truoc day bi mat, chi con trong Order_Logs.note) va co
                        // guard atomic "status <> CANCELLED" chong double-submit + tu dong hoan
                        // lai luot dung voucher (neu don co ap dung).
                        boolean cancelled = orderDAO.cancelOrder(orderId, reason);
                        if (cancelled) {
                            OrderLog log = new OrderLog();
                            log.setOrderId(orderId);
                            log.setChangedBy(account.getId());
                            log.setOldStatus(oldStatus);
                            log.setNewStatus("CANCELLED");
                            log.setNote("Shipper huy don. Ly do: " + reason);
                            orderLogDAO.create(log);
                            Notification n = new Notification();
                            n.setAccountId(account.getId());
                            n.setTitle("❌ Đã huỷ đơn #" + orderId);
                            n.setMessage("Ban da huy don giao den " + order.getReceiverName() + ". Ly do: " + reason);
                            notificationDAO.create(n);
                            notifyCustomer(order, "❌ Đơn hàng #" + orderId + " đã bị hủy",
                                    "Shipper đã hủy đơn giao của bạn. Lý do: " + reason);
                        }
                    }
                }
            }
        }

        resp.sendRedirect(req.getContextPath() + "/shipper/donhang");
    }

    private void handleDetail(HttpServletRequest req, HttpServletResponse resp, Account account)
            throws ServletException, IOException {
        String idParam = req.getParameter("id");
        long orderId = 0;
        try { orderId = Long.parseLong(idParam); } catch (Exception ignored) {}

        Order order = orderId > 0 ? orderDAO.findById(orderId) : null;
        if (order == null || order.getShipperId() != account.getId()) {
            resp.sendRedirect(req.getContextPath() + "/shipper/donhang");
            return;
        }

        BillView bill = BillUtil.build(order);
        Shop shop = shopDAO.selectShopById(order.getShopId());
        req.setAttribute("bill", bill);
        req.setAttribute("order", order);
        req.setAttribute("shop", shop);
        req.getRequestDispatcher("/shipper/chitietdonhang.jsp").forward(req, resp);
    }

    private void notifyCustomer(Order order, String title, String message) {
        Notification n = new Notification();
        n.setAccountId(order.getUserId());
        n.setTitle(title);
        n.setMessage(message);
        notificationDAO.create(n);
    }

    private Account currentShipper(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        if (session == null) {
            return null;
        }
        Object obj = session.getAttribute("account");
        if (!(obj instanceof Account)) {
            return null;
        }
        Account account = (Account) obj;
        return account.getRoleId() == 4 ? account : null;
    }
}
