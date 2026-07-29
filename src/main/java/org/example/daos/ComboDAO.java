package org.example.daos;

import org.example.models.Combo;
import org.example.models.ComboItem;

import java.util.List;

public interface ComboDAO {
    List<Combo> findByShopId(long shopId);
    Combo findById(long id);
    long create(Combo combo);
    boolean update(Combo combo);
    boolean delete(long id);
    boolean addItem(ComboItem item);
    boolean deleteItems(long comboId);
    List<ComboItem> findItemsByComboId(long comboId);

    /**
     * Tìm các sản phẩm nên mua kèm khi user thêm productId vào giỏ.
     * Trả về các Combo_Items (khác productId) trong các combo active có chứa productId.
     */
    List<ComboItem> findSuggestionsByProductId(long productId, long shopId);
}
