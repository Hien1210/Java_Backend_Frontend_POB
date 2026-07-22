package org.example.daos;

import org.example.models.Complaint;
import org.example.utils.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class ComplaintDAOImpl implements ComplaintDAO {

    @Override
    public boolean create(Complaint complaint) {
        String sql = "INSERT INTO Complaints (order_id, account_id, subject, content, status) VALUES (?, ?, ?, ?, 'PENDING')";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setLong(1, complaint.getOrderId());
            ps.setLong(2, complaint.getAccountId());
            ps.setNString(3, complaint.getSubject());
            ps.setNString(4, complaint.getContent());
            int rows = ps.executeUpdate();
            if (rows > 0) {
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) complaint.setId(keys.getLong(1));
                }
                return true;
            }
            return false;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public List<Complaint> findByAccountId(long accountId) {
        List<Complaint> list = new ArrayList<>();
        String sql = "SELECT * FROM Complaints WHERE account_id = ? ORDER BY created_at DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, accountId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public List<Complaint> findAll() {
        List<Complaint> list = new ArrayList<>();
        String sql = "SELECT c.*, a.full_name AS account_name FROM Complaints c " +
                "LEFT JOIN Accounts a ON c.account_id = a.id ORDER BY c.created_at DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Complaint c = map(rs);
                c.setAccountName(rs.getString("account_name"));
                list.add(c);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public List<Complaint> findByStatus(String status) {
        List<Complaint> list = new ArrayList<>();
        String sql = "SELECT c.*, a.full_name AS account_name FROM Complaints c " +
                "LEFT JOIN Accounts a ON c.account_id = a.id WHERE c.status = ? ORDER BY c.created_at DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Complaint c = map(rs);
                    c.setAccountName(rs.getString("account_name"));
                    list.add(c);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public Complaint findById(long id) {
        String sql = "SELECT c.*, a.full_name AS account_name FROM Complaints c " +
                "LEFT JOIN Accounts a ON c.account_id = a.id WHERE c.id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Complaint c = map(rs);
                    c.setAccountName(rs.getString("account_name"));
                    return c;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public boolean existsByOrderId(long orderId) {
        String sql = "SELECT COUNT(*) FROM Complaints WHERE order_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean resolve(long id, String status, String adminReply, long resolvedBy) {
        String sql = "UPDATE Complaints SET status = ?, admin_reply = ?, resolved_by = ?, updated_at = GETDATE() WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setNString(2, adminReply);
            ps.setLong(3, resolvedBy);
            ps.setLong(4, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    private Complaint map(ResultSet rs) throws SQLException {
        Complaint c = new Complaint();
        c.setId(rs.getLong("id"));
        c.setOrderId(rs.getLong("order_id"));
        c.setAccountId(rs.getLong("account_id"));
        c.setSubject(rs.getString("subject"));
        c.setContent(rs.getString("content"));
        c.setStatus(rs.getString("status"));
        c.setAdminReply(rs.getString("admin_reply"));
        long resolvedBy = rs.getLong("resolved_by");
        c.setResolvedBy(rs.wasNull() ? null : resolvedBy);
        Timestamp created = rs.getTimestamp("created_at");
        if (created != null) c.setCreatedAt(created.toLocalDateTime());
        Timestamp updated = rs.getTimestamp("updated_at");
        if (updated != null) c.setUpdatedAt(updated.toLocalDateTime());
        return c;
    }
}
