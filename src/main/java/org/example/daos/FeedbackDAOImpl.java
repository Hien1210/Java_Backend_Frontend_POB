package org.example.daos;

import org.example.models.BannedWord;
import org.example.models.Feedback;
import org.example.utils.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FeedbackDAOImpl implements FeedbackDAO {

    @Override
    public boolean save(Feedback f) {
        // Bình luận dính từ cấm -> tự động gắn PENDING_REVIEW thay vì hiển thị công khai ngay.
        String status = checkBadWords(f.getComment()) ? "PENDING_REVIEW" : "VISIBLE";

        String sql = "INSERT INTO Feedbacks (order_id, reviewer_type, reviewer_id, target_type, target_id, rating, comment, is_anonymous, status) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
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
            ps.setString(9, status);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean checkBadWords(String comment) {
        if (comment == null || comment.isBlank()) return false;

        String lowerComment = comment.toLowerCase();
        for (String badWord : fetchBannedWords()) {
            if (badWord != null && !badWord.isBlank() && lowerComment.contains(badWord.toLowerCase())) {
                return true;
            }
        }
        return false;
    }

    @Override
    public List<Feedback> findPendingReview() {
        List<Feedback> list = new ArrayList<>();
        List<String> bannedWords = fetchBannedWords();
        String sql = "SELECT f.id, f.order_id, f.reviewer_type, f.reviewer_id, " +
                     "       CASE WHEN f.is_anonymous=1 THEN N'Ẩn danh' ELSE ra.full_name END AS reviewer_name, " +
                     "       f.target_type, f.target_id, f.rating, f.comment, f.is_anonymous, f.created_at, f.status, " +
                     "       CASE WHEN f.target_type='SHOP' THEN s.shop_name ELSE ta.full_name END AS target_name " +
                     "FROM Feedbacks f " +
                     "LEFT JOIN Accounts ra ON f.reviewer_id = ra.id " +
                     "LEFT JOIN Shops s ON f.target_type='SHOP' AND f.target_id = s.id " +
                     "LEFT JOIN Accounts ta ON f.target_type='SHIPPER' AND f.target_id = ta.id " +
                     "WHERE f.status = 'PENDING_REVIEW' " +
                     "ORDER BY f.created_at DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Feedback f = map(rs);
                f.setTargetName(rs.getString("target_name"));
                f.setHighlightedComment(highlightBadWords(f.getComment(), bannedWords));
                list.add(f);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    private List<String> fetchBannedWords() {
        List<String> words = new ArrayList<>();
        String sql = "SELECT word FROM BannedWords";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) words.add(rs.getString("word"));
        } catch (Exception e) { e.printStackTrace(); }
        return words;
    }

    /**
     * Escape HTML cua comment roi boc <mark class="bad-word"> quanh tung vi tri khop voi
     * bannedWords (khong phan biet hoa/thuong). Tim toan bo vi tri tren chuoi da escape (chua boc
     * the) truoc, gop cac vung chong lan, roi moi dung 1 lan duy nhat -> tranh boc long nhau khi
     * 1 tu cam vo tinh trung ky tu voi the <mark> vua chen (vd tu "mark").
     */
    private String highlightBadWords(String comment, List<String> bannedWords) {
        String escaped = escapeHtml(comment);
        if (bannedWords.isEmpty() || escaped.isEmpty()) return escaped;

        String lower = escaped.toLowerCase();
        List<int[]> spans = new ArrayList<>();
        for (String word : bannedWords) {
            if (word == null || word.isBlank()) continue;
            String needle = escapeHtml(word).toLowerCase();
            if (needle.isBlank()) continue;
            int idx = 0;
            while ((idx = lower.indexOf(needle, idx)) != -1) {
                spans.add(new int[]{idx, idx + needle.length()});
                idx += needle.length();
            }
        }
        if (spans.isEmpty()) return escaped;

        spans.sort((a, b) -> a[0] - b[0]);
        List<int[]> merged = new ArrayList<>();
        int[] cur = spans.get(0);
        for (int i = 1; i < spans.size(); i++) {
            int[] s = spans.get(i);
            if (s[0] <= cur[1]) cur[1] = Math.max(cur[1], s[1]);
            else { merged.add(cur); cur = s; }
        }
        merged.add(cur);

        StringBuilder sb = new StringBuilder();
        int last = 0;
        for (int[] m : merged) {
            sb.append(escaped, last, m[0]);
            sb.append("<mark class=\"bad-word\">").append(escaped, m[0], m[1]).append("</mark>");
            last = m[1];
        }
        sb.append(escaped.substring(last));
        return sb.toString();
    }

    private String escapeHtml(String s) {
        if (s == null) return "";
        return s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")
                .replace("\"", "&quot;").replace("'", "&#39;");
    }

    @Override
    public List<BannedWord> findAllBannedWords() {
        List<BannedWord> list = new ArrayList<>();
        String sql = "SELECT id, word, created_at FROM BannedWords ORDER BY created_at DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                BannedWord bw = new BannedWord();
                bw.setId(rs.getLong("id"));
                bw.setWord(rs.getString("word"));
                Timestamp ts = rs.getTimestamp("created_at");
                if (ts != null) bw.setCreatedAt(ts.toLocalDateTime());
                list.add(bw);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    @Override
    public boolean addBannedWord(String word) {
        String sql = "INSERT INTO BannedWords (word) VALUES (?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, word);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean deleteBannedWord(long id) {
        String sql = "DELETE FROM BannedWords WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean updateStatus(long feedbackId, String status) {
        String sql = "UPDATE Feedbacks SET status = ? WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setLong(2, feedbackId);
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

    @Override
    public int countLowRatingFeedback(int threshold) {
        String sql = "SELECT COUNT(*) FROM Feedbacks WHERE rating <= ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, threshold);
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
        try { f.setStatus(rs.getString("status")); } catch (SQLException ignored) { /* cột status có thể không có trong 1 số query cũ */ }
        return f;
    }
}
