package org.example.daos;

import org.example.models.Faq;

import java.util.List;

public interface FaqDAO {

    /**
     * Danh sach FAQ cho trang quan tri Super Admin (khong loc is_active,
     * chi loai is_deleted=1). Sap theo category roi display_order.
     */
    List<Faq> findAll();

    /**
     * Danh sach FAQ hien thi cong khai cho User/Shop/Shipper:
     * is_deleted=0 AND is_active=1, sap theo category roi display_order.
     */
    List<Faq> findAllActiveForPublic();

    /**
     * Lay 1 FAQ theo id, dung de mo form sua o trang quan tri.
     * Tra ve null neu khong ton tai hoac da bi xoa mem.
     */
    Faq findById(long id);

    /**
     * Loc FAQ theo category (khong loc is_active) — dung cho combobox
     * loc nhom tren trang quan tri.
     */
    List<Faq> findByCategory(String category);

    /**
     * Danh sach cac category dang co trong bang, dung do combobox filter.
     */
    List<String> findDistinctCategories();

    /**
     * Tao FAQ moi, tra ve id vua tao (0 neu that bai) de servlet dung ghi Audit Log.
     */
    long create(Faq faq);

    /**
     * Cap nhat question/answer/category/display_order/is_active cua 1 FAQ da co.
     * Khong dung de doi is_deleted (xem softDelete).
     */
    boolean update(Faq faq);

    /**
     * Xoa mem 1 FAQ (is_deleted = 1). Khong xoa cung vi khong co ly do
     * nghiep vu can xoa han noi dung FAQ (khac voi Accounts can xoa vinh vien
     * theo yeu cau phap ly).
     */
    boolean softDelete(long id, long updatedBy);

    /**
     * Bat/tat hien thi cong khai (is_active), khong lien quan is_deleted.
     */
    boolean toggleActive(long id, boolean active, long updatedBy);

    /**
     * Cap nhat rieng display_order cho 1 FAQ (dung khi keo-tha sap xep lai thu tu).
     */
    boolean updateDisplayOrder(long id, int displayOrder, long updatedBy);

    /**
     * Dem tong so FAQ chua bi xoa mem, dung cho badge sidebar (giong
     * countPendingShops() cua ShopDAO).
     */
    int countAll();
}
