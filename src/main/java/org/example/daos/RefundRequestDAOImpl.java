package org.example.daos;

import org.example.models.RefundRequest;
import org.example.utils.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RefundRequestDAOImpl implements RefundRequestDAO {

    private Connection conn() throws SQLException { return DBUtil.getConnection(); }

    @Override
    public boolean create(RefundRequest r) {
        String sql = "INSERT INTO Refund_Requests (order_id, account_id, amount, bank_name, bank_account_number, bank_account_holder, note) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection c = conn(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, r.getOrderId());
            ps.setLong(2, r.getAccountId());
            ps.setDouble(3, r.getAmount());
            ps.setString(4, r.getBankName());
            ps.setString(5, r.getBankAccountNumber());
            ps.setString(6, r.getBankAccountHolder());
            ps.setString(7, r.getNote());
            return ps.executeUpdate() == 1;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    @Override
    public RefundRequest findByOrderId(long orderId) {
        String sql = "SELECT r.*, a.full_name AS account_name, a.email AS account_email, " +
                     "adm.full_name AS processed_by_name FROM Refund_Requests r " +
                     "JOIN Accounts a ON a.id = r.account_id " +
                     "LEFT JOIN Accounts adm ON adm.id = r.processed_by " +
                     "WHERE r.order_id = ?";
        try (Connection c = conn(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return map(rs);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    @Override
    public RefundRequest findById(long id) {
        String sql = "SELECT r.*, a.full_name AS account_name, a.email AS account_email, " +
                     "adm.full_name AS processed_by_name FROM Refund_Requests r " +
                     "JOIN Accounts a ON a.id = r.account_id " +
                     "LEFT JOIN Accounts adm ON adm.id = r.processed_by " +
                     "WHERE r.id = ?";
        try (Connection c = conn(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return map(rs);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    @Override
    public List<RefundRequest> findByAccountId(long accountId) {
        String sql = "SELECT r.*, a.full_name AS account_name, a.email AS account_email, " +
                     "adm.full_name AS processed_by_name FROM Refund_Requests r " +
                     "JOIN Accounts a ON a.id = r.account_id " +
                     "LEFT JOIN Accounts adm ON adm.id = r.processed_by " +
                     "WHERE r.account_id = ? ORDER BY r.requested_at DESC";
        List<RefundRequest> list = new ArrayList<>();
        try (Connection c = conn(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, accountId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    @Override
    public List<RefundRequest> findAll(String status, int limit, int offset) {
        String where = (status == null || status.isEmpty()) ? "" : " AND r.status = ?";
        String sql = "SELECT r.*, a.full_name AS account_name, a.email AS account_email, " +
                     "adm.full_name AS processed_by_name FROM Refund_Requests r " +
                     "JOIN Accounts a ON a.id = r.account_id " +
                     "LEFT JOIN Accounts adm ON adm.id = r.processed_by " +
                     "WHERE 1=1" + where +
                     " ORDER BY CASE r.status WHEN 'PENDING' THEN 0 ELSE 1 END, r.requested_at DESC " +
                     "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        List<RefundRequest> list = new ArrayList<>();
        try (Connection c = conn(); PreparedStatement ps = c.prepareStatement(sql)) {
            int idx = 1;
            if (!where.isEmpty()) ps.setString(idx++, status);
            ps.setInt(idx++, offset);
            ps.setInt(idx, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    @Override
    public int countAll(String status) {
        String where = (status == null || status.isEmpty()) ? "" : " WHERE status = ?";
        String sql = "SELECT COUNT(*) FROM Refund_Requests" + where;
        try (Connection c = conn(); PreparedStatement ps = c.prepareStatement(sql)) {
            if (!where.isEmpty()) ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    @Override
    public boolean complete(long id, long adminId) {
        String sql = "UPDATE Refund_Requests SET status = 'COMPLETED', processed_by = ?, processed_at = GETDATE() " +
                     "WHERE id = ? AND status = 'PENDING'";
        try (Connection c = conn(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, adminId);
            ps.setLong(2, id);
            return ps.executeUpdate() == 1;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    @Override
    public boolean reject(long id, long adminId, String reason) {
        String sql = "UPDATE Refund_Requests SET status = 'REJECTED', processed_by = ?, processed_at = GETDATE(), reject_reason = ? " +
                     "WHERE id = ? AND status = 'PENDING'";
        try (Connection c = conn(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, adminId);
            ps.setString(2, reason);
            ps.setLong(3, id);
            return ps.executeUpdate() == 1;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    private RefundRequest map(ResultSet rs) throws SQLException {
        RefundRequest r = new RefundRequest();
        r.setId(rs.getLong("id"));
        r.setOrderId(rs.getLong("order_id"));
        r.setAccountId(rs.getLong("account_id"));
        r.setAmount(rs.getDouble("amount"));
        r.setBankName(rs.getString("bank_name"));
        r.setBankAccountNumber(rs.getString("bank_account_number"));
        r.setBankAccountHolder(rs.getString("bank_account_holder"));
        r.setNote(rs.getString("note"));
        r.setStatus(rs.getString("status"));
        r.setRejectReason(rs.getString("reject_reason"));
        Timestamp req = rs.getTimestamp("requested_at");
        if (req != null) r.setRequestedAt(req.toLocalDateTime());
        Timestamp proc = rs.getTimestamp("processed_at");
        if (proc != null) r.setProcessedAt(proc.toLocalDateTime());
        long pb = rs.getLong("processed_by");
        if (!rs.wasNull()) r.setProcessedBy(pb);
        try { r.setAccountName(rs.getString("account_name")); } catch (Exception ignored) {}
        try { r.setAccountEmail(rs.getString("account_email")); } catch (Exception ignored) {}
        try { r.setProcessedByName(rs.getString("processed_by_name")); } catch (Exception ignored) {}
        return r;
    }
}
