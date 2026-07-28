package org.example.daos;

import org.example.models.ShopWallet;
import org.example.models.ShopWalletTransaction;
import org.example.models.ShopWithdrawal;
import org.example.utils.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ShopWalletDAOImpl implements ShopWalletDAO {

    private Connection conn() throws SQLException {
        return DBUtil.getConnection();
    }

    @Override
    public ShopWallet getWallet(long shopId) {
        String sql = "SELECT * FROM Shop_Wallets WHERE shop_id = ?";
        try (Connection c = conn(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, shopId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapWallet(rs);
            }
        } catch (Exception e) { e.printStackTrace(); }
        ShopWallet empty = new ShopWallet();
        empty.setShopId(shopId);
        return empty;
    }

    @Override
    public double getBalance(long shopId) {
        String sql = "SELECT balance FROM Shop_Wallets WHERE shop_id = ?";
        try (Connection c = conn(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, shopId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getDouble("balance");
            }
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    @Override
    public boolean creditEarning(long shopId, long orderId, double totalPrice, double deliveryFee, double commissionRate) {
        // Net earning = (totalPrice - deliveryFee) * (1 - commissionRate/100)
        double net = (totalPrice - deliveryFee) * (1.0 - commissionRate / 100.0);
        if (net <= 0) return false;
        String desc = String.format("Thu nhập từ đơn #%d (sau hoa hồng %.1f%%): +%,.0fđ", orderId, commissionRate, net);

        String upsert =
            "IF EXISTS (SELECT 1 FROM Shop_Wallets WHERE shop_id = ?) " +
            "    UPDATE Shop_Wallets SET balance = balance + ?, total_earned = total_earned + ?, updated_at = GETDATE() WHERE shop_id = ? " +
            "ELSE " +
            "    INSERT INTO Shop_Wallets (shop_id, balance, total_earned, total_withdrawn) VALUES (?, ?, ?, 0)";

        try (Connection c = conn()) {
            c.setAutoCommit(false);
            try {
                try (PreparedStatement ps = c.prepareStatement(upsert)) {
                    ps.setLong(1, shopId);
                    ps.setDouble(2, net);
                    ps.setDouble(3, net);
                    ps.setLong(4, shopId);
                    ps.setLong(5, shopId);
                    ps.setDouble(6, net);
                    ps.setDouble(7, net);
                    ps.executeUpdate();
                }
                insertTransaction(c, shopId, "EARNING", net, orderId, desc);
                c.commit();
                return true;
            } catch (Exception e) {
                c.rollback();
                e.printStackTrace();
                return false;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean deductRefund(long shopId, long orderId, double amount, String reason) {
        String desc = String.format("Hoàn tiền đơn #%d: -%,.0fđ. %s", orderId, amount, reason == null ? "" : reason);
        try (Connection c = conn()) {
            c.setAutoCommit(false);
            try {
                // Only deduct if shop has enough balance; if not, set to 0 (shop owes platform)
                String deduct = "UPDATE Shop_Wallets SET balance = CASE WHEN balance >= ? THEN balance - ? ELSE 0 END, " +
                                "updated_at = GETDATE() WHERE shop_id = ?";
                try (PreparedStatement ps = c.prepareStatement(deduct)) {
                    ps.setDouble(1, amount);
                    ps.setDouble(2, amount);
                    ps.setLong(3, shopId);
                    ps.executeUpdate();
                }
                insertTransaction(c, shopId, "REFUND", -amount, orderId, desc);
                c.commit();
                return true;
            } catch (Exception e) {
                c.rollback();
                e.printStackTrace();
                return false;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public List<ShopWalletTransaction> getTransactions(long shopId, int limit, int offset) {
        String sql = "SELECT * FROM Shop_Wallet_Transactions WHERE shop_id = ? ORDER BY created_at DESC " +
                     "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        List<ShopWalletTransaction> list = new ArrayList<>();
        try (Connection c = conn(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, shopId);
            ps.setInt(2, offset);
            ps.setInt(3, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapTx(rs));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    @Override
    public int countTransactions(long shopId) {
        String sql = "SELECT COUNT(*) FROM Shop_Wallet_Transactions WHERE shop_id = ?";
        try (Connection c = conn(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, shopId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    @Override
    public boolean requestWithdrawal(long shopId, double amount, String bankName,
                                     String bankAccountNumber, String bankAccountHolder) {
        // Check balance atomically
        String checkSql = "SELECT balance FROM Shop_Wallets WHERE shop_id = ?";
        String insertSql = "INSERT INTO Shop_Withdrawals (shop_id, amount, bank_name, bank_account_number, bank_account_holder, status) " +
                           "VALUES (?, ?, ?, ?, ?, 'PENDING')";
        // Hold balance by deducting immediately (pending state)
        String holdSql = "UPDATE Shop_Wallets SET balance = balance - ?, updated_at = GETDATE() WHERE shop_id = ? AND balance >= ?";

        try (Connection c = conn()) {
            c.setAutoCommit(false);
            try {
                double balance = 0;
                try (PreparedStatement ps = c.prepareStatement(checkSql)) {
                    ps.setLong(1, shopId);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) balance = rs.getDouble("balance");
                    }
                }
                if (balance < amount) {
                    c.rollback();
                    return false;
                }
                // Hold funds
                try (PreparedStatement ps = c.prepareStatement(holdSql)) {
                    ps.setDouble(1, amount);
                    ps.setLong(2, shopId);
                    ps.setDouble(3, amount);
                    int rows = ps.executeUpdate();
                    if (rows == 0) { c.rollback(); return false; }
                }
                // Create withdrawal record
                try (PreparedStatement ps = c.prepareStatement(insertSql)) {
                    ps.setLong(1, shopId);
                    ps.setDouble(2, amount);
                    ps.setString(3, bankName);
                    ps.setString(4, bankAccountNumber);
                    ps.setString(5, bankAccountHolder);
                    ps.executeUpdate();
                }
                // Record transaction
                String desc = String.format("Yêu cầu rút tiền: -%,.0fđ → %s %s", amount, bankName, bankAccountNumber);
                insertTransaction(c, shopId, "WITHDRAWAL", -amount, null, desc);

                c.commit();
                return true;
            } catch (Exception e) {
                c.rollback();
                e.printStackTrace();
                return false;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public List<ShopWithdrawal> getWithdrawals(long shopId) {
        String sql = "SELECT w.*, a.full_name AS processed_by_name FROM Shop_Withdrawals w " +
                     "LEFT JOIN Accounts a ON a.id = w.processed_by " +
                     "WHERE w.shop_id = ? ORDER BY w.requested_at DESC";
        List<ShopWithdrawal> list = new ArrayList<>();
        try (Connection c = conn(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, shopId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapWithdrawal(rs));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    @Override
    public List<ShopWithdrawal> getAllPendingWithdrawals() {
        return getAllWithdrawals("PENDING", 100, 0);
    }

    @Override
    public List<ShopWithdrawal> getAllWithdrawals(String status, int limit, int offset) {
        String where = (status == null || status.isEmpty()) ? "" : " AND w.status = ?";
        String sql = "SELECT w.*, s.name AS shop_name, a.full_name AS processed_by_name " +
                     "FROM Shop_Withdrawals w " +
                     "JOIN Shops s ON s.id = w.shop_id " +
                     "LEFT JOIN Accounts a ON a.id = w.processed_by " +
                     "WHERE 1=1" + where +
                     " ORDER BY CASE w.status WHEN 'PENDING' THEN 0 ELSE 1 END, w.requested_at DESC " +
                     "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        List<ShopWithdrawal> list = new ArrayList<>();
        try (Connection c = conn(); PreparedStatement ps = c.prepareStatement(sql)) {
            int idx = 1;
            if (!where.isEmpty()) ps.setString(idx++, status);
            ps.setInt(idx++, offset);
            ps.setInt(idx, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ShopWithdrawal w = mapWithdrawal(rs);
                    try { w.setShopName(rs.getString("shop_name")); } catch (Exception ignored) {}
                    list.add(w);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    @Override
    public int countWithdrawals(String status) {
        String where = (status == null || status.isEmpty()) ? "" : " WHERE status = ?";
        String sql = "SELECT COUNT(*) FROM Shop_Withdrawals" + where;
        try (Connection c = conn(); PreparedStatement ps = c.prepareStatement(sql)) {
            if (!where.isEmpty()) ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    @Override
    public boolean approveWithdrawal(long withdrawalId, long adminId) {
        // Balance was already deducted on request; just mark approved and update total_withdrawn
        String getSql = "SELECT shop_id, amount, status FROM Shop_Withdrawals WHERE id = ?";
        String approveSql = "UPDATE Shop_Withdrawals SET status = 'APPROVED', processed_at = GETDATE(), processed_by = ? WHERE id = ? AND status = 'PENDING'";
        String updateTotalSql = "UPDATE Shop_Wallets SET total_withdrawn = total_withdrawn + ?, updated_at = GETDATE() WHERE shop_id = ?";

        try (Connection c = conn()) {
            c.setAutoCommit(false);
            try {
                long shopId = 0; double amount = 0;
                try (PreparedStatement ps = c.prepareStatement(getSql)) {
                    ps.setLong(1, withdrawalId);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (!rs.next() || !"PENDING".equals(rs.getString("status"))) {
                            c.rollback(); return false;
                        }
                        shopId = rs.getLong("shop_id");
                        amount = rs.getDouble("amount");
                    }
                }
                try (PreparedStatement ps = c.prepareStatement(approveSql)) {
                    ps.setLong(1, adminId);
                    ps.setLong(2, withdrawalId);
                    if (ps.executeUpdate() == 0) { c.rollback(); return false; }
                }
                try (PreparedStatement ps = c.prepareStatement(updateTotalSql)) {
                    ps.setDouble(1, amount);
                    ps.setLong(2, shopId);
                    ps.executeUpdate();
                }
                c.commit();
                return true;
            } catch (Exception e) {
                c.rollback(); e.printStackTrace(); return false;
            }
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    @Override
    public boolean rejectWithdrawal(long withdrawalId, long adminId, String reason) {
        // Refund held balance back to wallet
        String getSql = "SELECT shop_id, amount, status FROM Shop_Withdrawals WHERE id = ?";
        String rejectSql = "UPDATE Shop_Withdrawals SET status = 'REJECTED', reject_reason = ?, processed_at = GETDATE(), processed_by = ? WHERE id = ? AND status = 'PENDING'";
        String refundSql = "UPDATE Shop_Wallets SET balance = balance + ?, updated_at = GETDATE() WHERE shop_id = ?";

        try (Connection c = conn()) {
            c.setAutoCommit(false);
            try {
                long shopId = 0; double amount = 0;
                try (PreparedStatement ps = c.prepareStatement(getSql)) {
                    ps.setLong(1, withdrawalId);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (!rs.next() || !"PENDING".equals(rs.getString("status"))) {
                            c.rollback(); return false;
                        }
                        shopId = rs.getLong("shop_id");
                        amount = rs.getDouble("amount");
                    }
                }
                try (PreparedStatement ps = c.prepareStatement(rejectSql)) {
                    ps.setString(1, reason);
                    ps.setLong(2, adminId);
                    ps.setLong(3, withdrawalId);
                    if (ps.executeUpdate() == 0) { c.rollback(); return false; }
                }
                // Refund balance
                try (PreparedStatement ps = c.prepareStatement(refundSql)) {
                    ps.setDouble(1, amount);
                    ps.setLong(2, shopId);
                    ps.executeUpdate();
                }
                // Record refund transaction
                String desc = String.format("Hoàn tiền rút bị từ chối: +%,.0fđ", amount);
                insertTransaction(c, shopId, "EARNING", amount, null, desc);
                c.commit();
                return true;
            } catch (Exception e) {
                c.rollback(); e.printStackTrace(); return false;
            }
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    // ---- helpers ----

    private void insertTransaction(Connection c, long shopId, String type, double amount, Long orderId, String desc) throws SQLException {
        String sql = "INSERT INTO Shop_Wallet_Transactions (shop_id, type, amount, order_id, description) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, shopId);
            ps.setString(2, type);
            ps.setDouble(3, amount);
            if (orderId != null) ps.setLong(4, orderId); else ps.setNull(4, Types.BIGINT);
            ps.setString(5, desc);
            ps.executeUpdate();
        }
    }

    private ShopWallet mapWallet(ResultSet rs) throws SQLException {
        ShopWallet w = new ShopWallet();
        w.setId(rs.getLong("id"));
        w.setShopId(rs.getLong("shop_id"));
        w.setBalance(rs.getDouble("balance"));
        w.setTotalEarned(rs.getDouble("total_earned"));
        w.setTotalWithdrawn(rs.getDouble("total_withdrawn"));
        Timestamp ts = rs.getTimestamp("updated_at");
        if (ts != null) w.setUpdatedAt(ts.toLocalDateTime());
        return w;
    }

    private ShopWalletTransaction mapTx(ResultSet rs) throws SQLException {
        ShopWalletTransaction t = new ShopWalletTransaction();
        t.setId(rs.getLong("id"));
        t.setShopId(rs.getLong("shop_id"));
        t.setType(rs.getString("type"));
        t.setAmount(rs.getDouble("amount"));
        long oid = rs.getLong("order_id");
        if (!rs.wasNull()) t.setOrderId(oid);
        t.setDescription(rs.getString("description"));
        Timestamp ts = rs.getTimestamp("created_at");
        if (ts != null) t.setCreatedAt(ts.toLocalDateTime());
        return t;
    }

    private ShopWithdrawal mapWithdrawal(ResultSet rs) throws SQLException {
        ShopWithdrawal w = new ShopWithdrawal();
        w.setId(rs.getLong("id"));
        w.setShopId(rs.getLong("shop_id"));
        w.setAmount(rs.getDouble("amount"));
        w.setBankName(rs.getString("bank_name"));
        w.setBankAccountNumber(rs.getString("bank_account_number"));
        w.setBankAccountHolder(rs.getString("bank_account_holder"));
        w.setStatus(rs.getString("status"));
        w.setRejectReason(rs.getString("reject_reason"));
        Timestamp req = rs.getTimestamp("requested_at");
        if (req != null) w.setRequestedAt(req.toLocalDateTime());
        Timestamp proc = rs.getTimestamp("processed_at");
        if (proc != null) w.setProcessedAt(proc.toLocalDateTime());
        long pb = rs.getLong("processed_by");
        if (!rs.wasNull()) w.setProcessedBy(pb);
        try { w.setProcessedByName(rs.getString("processed_by_name")); } catch (Exception ignored) {}
        return w;
    }
}
