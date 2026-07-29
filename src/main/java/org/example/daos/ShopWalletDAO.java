package org.example.daos;

import org.example.models.ShopWallet;
import org.example.models.ShopWalletTransaction;
import org.example.models.ShopWithdrawal;

import java.util.List;

public interface ShopWalletDAO {
    ShopWallet getWallet(long shopId);
    double getBalance(long shopId);

    /** Credit shop earning after order delivered. Deducts commission automatically. */
    boolean creditEarning(long shopId, long orderId, double totalPrice, double deliveryFee, double commissionRate);

    /** Record refund deduction when order is refunded. */
    boolean deductRefund(long shopId, long orderId, double amount, String reason);

    List<ShopWalletTransaction> getTransactions(long shopId, int limit, int offset);
    int countTransactions(long shopId);

    boolean requestWithdrawal(long shopId, double amount, String bankName,
                              String bankAccountNumber, String bankAccountHolder);

    List<ShopWithdrawal> getWithdrawals(long shopId);
    List<ShopWithdrawal> getAllPendingWithdrawals();
    List<ShopWithdrawal> getAllWithdrawals(String status, int limit, int offset);
    int countWithdrawals(String status);

    /** Admin approve: deduct balance, mark APPROVED. */
    boolean approveWithdrawal(long withdrawalId, long adminId);

    /** Admin reject: restore balance (if it was held), mark REJECTED. */
    boolean rejectWithdrawal(long withdrawalId, long adminId, String reason);
}
