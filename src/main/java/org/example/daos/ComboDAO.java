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
}
