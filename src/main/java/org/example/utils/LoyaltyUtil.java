package org.example.utils;

import org.example.daos.AccountDAO;
import org.example.daos.AccountDAOImpl;
import org.example.daos.OrderDAO;
import org.example.daos.OrderDAOImpl;
import org.example.models.Order;

/**
 * Tich diem thuong (Loyalty Points) khi 1 don hang hoan thanh (status = DONE).
 * Ty le: 10.000d = 1 diem (lam tron xuong). Goi 1 lan duy nhat tai thoi diem don chuyen sang DONE,
 * dung chung pattern voi InventoryUtil (tru ton kho).
 */
public final class LoyaltyUtil {

    private static final int VND_PER_POINT = 10000;
    private static final OrderDAO orderDAO = new OrderDAOImpl();
    private static final AccountDAO accountDAO = new AccountDAOImpl();

    private LoyaltyUtil() {
    }

    public static void awardPointsForOrder(long orderId) {
        Order order = orderDAO.findById(orderId);
        if (order == null || order.getUserId() <= 0 || order.getTotalPrice() == null) return;

        int points = (int) (order.getTotalPrice() / VND_PER_POINT);
        if (points <= 0) return;

        accountDAO.addLoyaltyPoints(order.getUserId(), points);
    }
}
