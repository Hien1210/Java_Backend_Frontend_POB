package org.example.daos;

public interface ShipperWalletDAO {
    double getBalance(long shipperAccountId);
    boolean creditEarning(long shipperAccountId, double amount);
    boolean requestWithdrawal(long shipperAccountId, double amount,
                              String bankName, String bankAccountNumber, String bankAccountHolder);
}
