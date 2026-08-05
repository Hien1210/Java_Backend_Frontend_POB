package org.example.daos;

import org.example.models.Account;

import java.util.List;

public interface AccountDAO {

    Boolean dangkyNguoiDung(String username, String password, String email, String fullname, String phone);
    Boolean tonTaiEmail (String email);
    Boolean tonTaiUsername(String username);
    Boolean tonTaiEmailKhacId(String email, long id);
    Boolean tonTaiUsernameKhacId(String username, long id);
    Boolean capNhatMatKhauTheoEmail(String email, String password);
    Account DangNhap(String username, String password);
    List<Account> getAll();
    Account findById(long id);
    Boolean create(Account account);
    long createAndReturnId(Account account);
    Boolean update(Account account);
    Boolean delete(long id);
    Boolean softDelete(long id, String reason);
    int getTotalAccounts();
    int countActiveShippers();
    List<Account> searchByUsernameOrEmail(String keyword);
    List<Account> getAll(String sortField, String sortOrder);
    List<Account> searchByUsernameOrEmail(String keyword, String sortField, String sortOrder);

    int countPendingShopAccounts();
    List<Account> findTop5PendingShopAccounts();
    List<Account> findPendingShopAccounts();
    List<Account> findPendingShipperAccounts();
    List<Account> findOnlineShippers();
    boolean updateAccountStatus(long accountId, String status);
    boolean updateShipperOnlineStatus(long accountId, boolean isOnline);
    boolean updateAvatar(long id, String avatarUrl);

    boolean updateLogo(long id, String logoUrl);
    int countSuspendedAccounts();

    /** Kiem tra nhanh (khong load ca Account) tai khoan da bi xoa mem hoac khoa (status = BLOCKED)
     * chua - dung de phat hien tai khoan bi khoa GIUA phien dang nhap (xem AppFilter). */
    boolean isBlockedOrDeleted(long accountId);

    int getLoyaltyPoints(long accountId);
    /** Cong (delta duong) hoac tru (delta am) diem, khong cho diem am (chan ngay trong SQL). Tra ve false neu khong du diem de tru. */
    boolean addLoyaltyPoints(long accountId, int delta);
}
