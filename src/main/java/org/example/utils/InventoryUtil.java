package org.example.utils;

import org.example.daos.OrderDetailDAO;
import org.example.daos.OrderDetailDAOImpl;
import org.example.daos.ProductDAO;
import org.example.daos.ProductDAOImpl;
import org.example.models.OrderDetail;

import java.util.List;

/**
 * Tru ton kho (Products.stock_quantity) khi 1 don hang hoan thanh (status = DONE).
 * Goi 1 lan duy nhat tai thoi diem don chuyen sang DONE, khong goi lai nhieu lan cho cung 1 don.
 */
public final class InventoryUtil {

    private static final OrderDetailDAO orderDetailDAO = new OrderDetailDAOImpl();
    private static final ProductDAO productDAO = new ProductDAOImpl();

    private InventoryUtil() {
    }

    public static void decreaseStockForOrder(long orderId) {
        List<OrderDetail> details = orderDetailDAO.findByOrderId(orderId);
        for (OrderDetail detail : details) {
            productDAO.decreaseStock(detail.getProductId(), detail.getQuantity());
        }
    }
}
