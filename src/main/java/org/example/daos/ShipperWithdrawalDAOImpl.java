package org.example.daos;

import org.example.models.ShipperWithdrawal;
import org.example.utils.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class ShipperWithdrawalDAOImpl implements ShipperWithdrawalDAO {

    @Override
    public List<ShipperWithdrawal> getAllWithdrawals(String status) {
        StringBuilder sql = new StringBuilder(
                "SELECT w.id, w.shipper_account_id, a.full_name AS shipper_name, a.phone AS shipper_phone, " +
                "       w.amount, w.bank_name, w.bank_account_number, w.bank_account_holder, " +
                "       w.status, w.reject_reason, w.requested_at, w.processed_at " +
                "FROM Shipper_Withdrawals w " +
                "JOIN Accounts a ON a.id = w.shipper_account_id ");
        if (status != null && !status.isBlank()) {
            sql.append("WHERE w.status = ? ");
        }
        sql.append("ORDER BY w.requested_at DESC");

        List<ShipperWithdrawal> result = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            if (status != null && !status.isBlank()) {
                ps.setString(1, status);
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ShipperWithdrawal w = new ShipperWithdrawal();
                    w.setId(rs.getLong("id"));
                    w.setShipperAccountId(rs.getLong("shipper_account_id"));
                    w.setShipperName(rs.getString("shipper_name"));
                    w.setShipperPhone(rs.getString("shipper_phone"));
                    w.setAmount(rs.getDouble("amount"));
                    w.setBankName(rs.getString("bank_name"));
                    w.setBankAccountNumber(rs.getString("bank_account_number"));
                    w.setBankAccountHolder(rs.getString("bank_account_holder"));
                    w.setStatus(rs.getString("status"));
                    w.setRejectReason(rs.getString("reject_reason"));
                    Timestamp requestedAt = rs.getTimestamp("requested_at");
                    if (requestedAt != null) w.setRequestedAt(requestedAt.toLocalDateTime());
                    Timestamp processedAt = rs.getTimestamp("processed_at");
                    if (processedAt != null) w.setProcessedAt(processedAt.toLocalDateTime());
                    result.add(w);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    @Override
    public boolean approveWithdrawal(long withdrawalId, long processedBy) {
        String sql = "UPDATE Shipper_Withdrawals " +
                "SET status = 'APPROVED', processed_by = ?, processed_at = GETDATE() " +
                "WHERE id = ? AND status = 'PENDING'";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, processedBy);
            ps.setLong(2, withdrawalId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean rejectWithdrawal(long withdrawalId, long processedBy, String reason) {
        String selectSql = "SELECT shipper_account_id, amount FROM Shipper_Withdrawals " +
                "WHERE id = ? AND status = 'PENDING'";
        String updateWithdrawalSql = "UPDATE Shipper_Withdrawals " +
                "SET status = 'REJECTED', reject_reason = ?, processed_by = ?, processed_at = GETDATE() " +
                "WHERE id = ? AND status = 'PENDING'";
        String refundWalletSql = "UPDATE Shipper_Wallets SET balance = balance + ?, updated_at = GETDATE() " +
                "WHERE shipper_account_id = ?";

        try (Connection conn = DBUtil.getConnection()) {
            conn.setAutoCommit(false);
            try {
                long shipperAccountId;
                double amount;
                try (PreparedStatement ps = conn.prepareStatement(selectSql)) {
                    ps.setLong(1, withdrawalId);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (!rs.next()) {
                            conn.rollback();
                            return false; // yêu cầu không tồn tại hoặc đã được xử lý trước đó
                        }
                        shipperAccountId = rs.getLong("shipper_account_id");
                        amount = rs.getDouble("amount");
                    }
                }

                try (PreparedStatement ps = conn.prepareStatement(updateWithdrawalSql)) {
                    ps.setString(1, reason);
                    ps.setLong(2, processedBy);
                    ps.setLong(3, withdrawalId);
                    if (ps.executeUpdate() == 0) {
                        conn.rollback();
                        return false;
                    }
                }

                try (PreparedStatement ps = conn.prepareStatement(refundWalletSql)) {
                    ps.setDouble(1, amount);
                    ps.setLong(2, shipperAccountId);
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
