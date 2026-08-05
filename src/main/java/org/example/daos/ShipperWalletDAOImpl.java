package org.example.daos;

import org.example.utils.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class ShipperWalletDAOImpl implements ShipperWalletDAO {

    @Override
    public double getBalance(long shipperAccountId) {
        String sql = "SELECT balance FROM Shipper_Wallets WHERE shipper_account_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, shipperAccountId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getDouble("balance");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public boolean creditEarning(long shipperAccountId, double amount) {
        String upsert =
            "IF EXISTS (SELECT 1 FROM Shipper_Wallets WHERE shipper_account_id = ?) " +
            "    UPDATE Shipper_Wallets SET balance = balance + ?, updated_at = GETDATE() WHERE shipper_account_id = ? " +
            "ELSE " +
            "    INSERT INTO Shipper_Wallets (shipper_account_id, balance) VALUES (?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(upsert)) {
            ps.setLong(1, shipperAccountId);
            ps.setDouble(2, amount);
            ps.setLong(3, shipperAccountId);
            ps.setLong(4, shipperAccountId);
            ps.setDouble(5, amount);
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean requestWithdrawal(long shipperAccountId, double amount,
                                     String bankName, String bankAccountNumber, String bankAccountHolder) {
        String checkSql = "SELECT balance FROM Shipper_Wallets WHERE shipper_account_id = ?";
        String insertSql = "INSERT INTO Shipper_Withdrawals " +
                           "(shipper_account_id, amount, bank_name, bank_account_number, bank_account_holder, status) " +
                           "VALUES (?, ?, ?, ?, ?, 'PENDING')";

        try (Connection conn = DBUtil.getConnection()) {
            conn.setAutoCommit(false);
            try {
                double balance;
                try (PreparedStatement ps = conn.prepareStatement(checkSql)) {
                    ps.setLong(1, shipperAccountId);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (!rs.next()) { conn.rollback(); return false; }
                        balance = rs.getDouble("balance");
                    }
                }
                if (balance < amount) { conn.rollback(); return false; }

                // Chỉ tạo yêu cầu PENDING, KHÔNG trừ tiền — tiền chỉ bị trừ khi admin duyệt.
                try (PreparedStatement ps = conn.prepareStatement(insertSql)) {
                    ps.setLong(1, shipperAccountId);
                    ps.setDouble(2, amount);
                    ps.setString(3, bankName);
                    ps.setString(4, bankAccountNumber);
                    ps.setString(5, bankAccountHolder);
                    ps.executeUpdate();
                }

                conn.commit();
                return true;
            } catch (Exception e) {
                conn.rollback();
                throw e;
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
