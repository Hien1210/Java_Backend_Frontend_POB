package org.example.daos;

import org.example.models.Feedback;
import org.example.utils.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FeedbackDAOImpl implements FeedbackDAO {

    @Override
    public boolean save(Feedback f) {
        String sql = "INSERT INTO Feedbacks (order_id, reviewer_type, reviewer_id, target_type, target_id, rating, comment, is_anonymous) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, f.getOrderId());
            ps.setString(2, f.getReviewerType());
            ps.setLong(3, f.getReviewerId());
            ps.setString(4, f.getTargetType());
            ps.setLong(5, f.getTargetId());
            ps.setInt(6, f.getRating());
            ps.setString(7, f.getComment());
            ps.setBoolean(8, f.isAnonymous());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean existsByOrderAndType(long orderId, String reviewerType, String targetType) {
        String sql = "SELECT COUNT(*) FROM Feedbacks WHERE order_id=? AND reviewer_type=? AND target_type=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, orderId);
            ps.setString(2, reviewerType);
            ps.setString(3, targetType);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1) > 0;
            }
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    @Override
    public boolean canFeedback(long orderId, String reviewerType, long reviewerId, String targetType, long targetId) {
        String sql;
        if ("USER".equals(reviewerType) && "SHOP".equals(targetType)) {
            sql = "SELECT COUNT(*) FROM Orders WHERE id=? AND user_id=? AND shop_id=? AND status='DONE'";
        } else if ("USER".equals(reviewerType) && "SHIPPER".equals(targetType)) {
            sql = "SELECT COUNT(*) FROM Orders WHERE id=? AND user_id=? AND shipper_id=? AND status='DONE'";
        } else if ("SHIPPER".equals(reviewerType) && "SHOP".equals(targetType)) {
            sql = "SELECT COUNT(*) FROM Orders WHERE id=? AND shipper_id=? AND shop_id=? AND status='DONE'";
        } else {
            return false;
        }
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, orderId);
            ps.setLong(2, reviewerId);
            ps.setLong(3, targetId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1) > 0;
            }
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    @Override
    public List<Feedback> findByTarget(String targetType, long targetId, String reviewerType) {
        List<Feedback> list = new ArrayList<>();
        String sql = "SELECT f.id, f.order_id, f.reviewer_type, f.reviewer_id, " +
                     "       CASE WHEN f.is_anonymous=1 THEN N'Ẩn danh' ELSE a.full_name END AS reviewer_name, " +
                     "       f.target_type, f.target_id, f.rating, f.comment, f.is_anonymous, f.created_at " +
                     "FROM Feedbacks f " +
                     "LEFT JOIN Accounts a ON f.reviewer_id = a.id " +
                     "WHERE f.target_type=? AND f.target_id=? AND f.reviewer_type=? " +
                     "ORDER BY f.created_at DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, targetType);
            ps.setLong(2, targetId);
            ps.setString(3, reviewerType);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    @Override
    public double avgRating(String targetType, long targetId) {
        String sql = "SELECT AVG(CAST(rating AS FLOAT)) FROM Feedbacks WHERE target_type=? AND target_id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, targetType);
            ps.setLong(2, targetId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next() && rs.getObject(1) != null) return rs.getDouble(1);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return 0.0;
    }

    @Override
    public int countByTarget(String targetType, long targetId) {
        String sql = "SELECT COUNT(*) FROM Feedbacks WHERE target_type=? AND target_id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, targetType);
            ps.setLong(2, targetId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    @Override
    public int incrementBomCount(long accountId) {
        String sql = "UPDATE Accounts SET bom_count = bom_count + 1 WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, accountId);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
        return getBomCount(accountId);
    }

    @Override
    public int getBomCount(long accountId) {
        String sql = "SELECT bom_count FROM Accounts WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, accountId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    private Feedback map(ResultSet rs) throws SQLException {
        Feedback f = new Feedback();
        f.setId(rs.getLong("id"));
        f.setOrderId(rs.getLong("order_id"));
        f.setReviewerType(rs.getString("reviewer_type"));
        f.setReviewerId(rs.getLong("reviewer_id"));
        f.setReviewerName(rs.getString("reviewer_name"));
        f.setTargetType(rs.getString("target_type"));
        f.setTargetId(rs.getLong("target_id"));
        f.setRating(rs.getInt("rating"));
        f.setComment(rs.getString("comment"));
        f.setAnonymous(rs.getBoolean("is_anonymous"));
        Timestamp ts = rs.getTimestamp("created_at");
        if (ts != null) f.setCreatedAt(ts.toLocalDateTime());
        return f;
    }
}
