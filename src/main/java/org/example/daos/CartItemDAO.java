package org.example.daos;

import org.example.models.CartItem;

import java.util.List;

public interface CartItemDAO {
    Boolean create(CartItem item);
    long createAndReturnId(CartItem item);
    List<CartItem> getAll();
    CartItem findById(long id);
    Boolean update(CartItem item);
    Boolean delete(long id);
    List<CartItem> findByCartId(long cartId);
    CartItem findByCartIdProductSize(long cartId, long productId, long productSizeId);
    /** Chỉ khớp CartItem đang thuộc ĐÚNG combo này (dùng khi gộp số lượng lúc thêm lại 1 combo đã có trong giỏ). */
    CartItem findByCartIdProductSizeCombo(long cartId, long productId, long productSizeId, long comboId);
    Boolean incrementQuantity(long cartItemId, int delta);
    /** Tạo 1 CartItem là 1 phần của combo (comboId + đơn giá quy đổi từ combo_price đã "khóa" sẵn). */
    long createComboItem(long cartId, long productId, long productSizeId, int quantity, long comboId, double comboUnitPrice);
}
