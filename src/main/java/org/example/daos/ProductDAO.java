package org.example.daos;

import org.example.models.Product;

import java.util.List;

public interface ProductDAO {
    Boolean create(Product product);
    List<Product> getAll();
    Product findById(long id);
    Boolean update(Product product);
    Boolean delete(long id);

    // ✅ THIẾU: Lấy sản phẩm theo shop
    List<Product> findByShopId(long shopId);

    // ✅ THIẾU: Lấy sản phẩm theo shop và id
    Product findById(long id, long shopId);

    // ✅ THIẾU: Xóa sản phẩm theo shop
    boolean delete(long id, long shopId);
    long createAndReturnId(Product product);

    List<Product> findByCategoryId(long categoryId);
    List<Product> searchByName(String keyword);
    List<Product> searchByNameAndShop(String keyword, long shopId);
    int countByShopId(long shopId);
    int countByCategoryId(long categoryId);

    List<Product> findDeletedByShopId(long shopId);
    boolean restore(long id, long shopId);

    // Kiểm duyệt nội dung: sản phẩm đang chờ duyệt (status = PENDING_REVIEW)
    List<Product> findPendingReview();
    boolean updateStatus(long id, String status);
    /** Cap nhat status CHI KHI status hien tai dung nhu expectedCurrentStatus (atomic CAS), tranh
     * duyet/tu choi trung khi 2 tab admin thao tac gan nhu dong thoi (xem ContentModerationServlet). */
    boolean updateStatusIfCurrent(long id, String expectedCurrentStatus, String newStatus);

    // Tru ton kho khi don hoan thanh (DONE). Bo qua neu stock_quantity dang NULL (khong gioi han).
    // Tu dong chuyen status sang OUT_OF_STOCK neu ton kho ve 0.
    boolean decreaseStock(long productId, int quantity);
}
