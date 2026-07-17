package org.example.daos;

import java.util.List;
import java.util.Map;

public interface ProductImageDAO {
    /** Ảnh đại diện (is_primary = 1) của 1 sản phẩm, null nếu chưa có. */
    String findPrimaryUrlByProductId(long productId);

    /** Ảnh đại diện của nhiều sản phẩm cùng lúc, key = productId. */
    Map<Long, String> findPrimaryUrlsByProductIds(List<Long> productIds);

    /** Đặt/ghi đè ảnh đại diện của 1 sản phẩm (xóa ảnh đại diện cũ nếu có rồi thêm ảnh mới). */
    boolean upsertPrimary(long productId, String imageUrl);
}
