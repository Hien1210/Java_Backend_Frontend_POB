package org.example.daos;

import org.example.models.Voucher;

import java.util.List;

public interface VoucherDAO {
    long createAndReturnId(Voucher voucher);

    boolean update(Voucher voucher);

    boolean setActive(long id, boolean active);

    boolean delete(long id);

    Voucher findById(long id);

    /** Tim theo ma (khong phan biet hoa/thuong), khong loc active/het han (de UI hien loi ro rang). */
    Voucher findByCode(String code);

    List<Voucher> findAll();

    /** Danh sach voucher dang con hieu luc va du dieu kien ap dung cho 1 subtotal, dung cho goi y Best Voucher. */
    List<Voucher> findApplicable(double subtotal);

    /** Tang used_count them 1, tra ve false neu da het luot (dieu kien ngay trong SQL, tranh race condition). */
    boolean incrementUsedCount(long id);

    /** Hoan lai 1 luot da giu cho (incrementUsedCount) khi checkout that bai sau do va khong tao duoc don. */
    boolean decrementUsedCount(long id);
}
