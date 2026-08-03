package org.example.daos;

import org.example.models.Order;

import java.util.List;

public interface OrderDAO {
    Boolean create(Order order);
    long createAndReturnId(Order order);
    List<Order> getAll();
    List<Order> findByUserId(long userId);
    List<Order> findByShopId(long shopId);
    List<Order> findByShipperId(long shipperId);
    Order findById(long id);
    Boolean update(Order order);
    Boolean delete(long id);
    Boolean updatePaymentStatus(long id, long shopId, String paymentStatus);
    Boolean setPayosOrderCode(long id, long payosOrderCode);
    List<Order> findByPayosOrderCode(long payosOrderCode);
    Boolean updatePaymentStatusByPayosOrderCode(long payosOrderCode, String paymentStatus);
    List<Order> findAvailableOrders();
    Boolean assignShipper(long orderId, long shipperId);
    Boolean updateStatus(long orderId, String newStatus);
    /** Cap nhat status CHI KHI status hien tai dung nhu expectedCurrentStatus (atomic CAS), tra ve
     * false neu status da bi doi boi tien trinh khac giua luc doc va luc ghi (vd job tu dong huy
     * don PENDING qua han chay xen giua). Tranh ghi de am tham len mot thay doi trang thai khac. */
    Boolean updateStatusIfCurrent(long orderId, String expectedCurrentStatus, String newStatus);
    /** Cap nhat status CHI KHI status hien tai KHAC excludedCurrentStatus (atomic, khong yeu cau biet
     * chinh xac status truoc do la gi - chi can dam bao chua o trang thai da hoan tat). */
    Boolean updateStatusUnless(long orderId, String newStatus, String excludedCurrentStatus);
    Boolean cancelOrder(long orderId, String reason);
    /** Nhu cancelOrder, nhung chi huy khi status hien tai dung nhu expectedCurrentStatus (atomic CAS),
     * tranh huy nham don da chuyen trang thai khac giua luc doc va luc ghi. */
    Boolean cancelOrderIfStatus(long orderId, String reason, String expectedCurrentStatus);
    int cancelStalePendingOrders(int minutesThreshold);
    Boolean setVoucherInfo(long orderId, String voucherCode, double discountAmount);
    Boolean setScheduledAt(long orderId, java.time.LocalDateTime scheduledAt);
}
