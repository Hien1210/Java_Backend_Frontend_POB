package org.example.daos;

import org.example.models.Faq;
import org.example.utils.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class FaqDAOImpl implements FaqDAO {

    private static final String SELECT_JOIN =
            "SELECT f.*, ca.username AS created_by_name, ua.username AS updated_by_name " +
            "FROM FAQs f " +
            "LEFT JOIN Accounts ca ON ca.id = f.created_by " +
            "LEFT JOIN Accounts ua ON ua.id = f.updated_by ";

    @Override
    public List<Faq> findAll() {
        List<Faq> list = new ArrayList<>();
        String sql = SELECT_JOIN + "WHERE f.is_deleted = 0 ORDER BY f.category ASC, f.display_order ASC";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(sql);
             ResultSet rs = pst.executeQuery()) {
            while (rs.next()) list.add(map(rs));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public List<Faq> findAllActiveForPublic() {
        List<Faq> list = new ArrayList<>();
        String sql = SELECT_JOIN + "WHERE f.is_deleted = 0 AND f.is_active = 1 " +
                "ORDER BY f.category ASC, f.display_order ASC";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(sql);
             ResultSet rs = pst.executeQuery()) {
            while (rs.next()) list.add(map(rs));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public Faq findById(long id) {
        String sql = SELECT_JOIN + "WHERE f.id = ? AND f.is_deleted = 0";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {
            pst.setLong(1, id);
            try (ResultSet rs = pst.executeQuery()) {
                if (rs.next()) return map(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public List<Faq> findByCategory(String category) {
        List<Faq> list = new ArrayList<>();
        String sql = SELECT_JOIN + "WHERE f.is_deleted = 0 AND f.category = ? " +
                "ORDER BY f.display_order ASC";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {
            pst.setString(1, category);
            try (ResultSet rs = pst.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public List<String> findDistinctCategories() {
        List<String> categories = new ArrayList<>();
        String sql = "SELECT DISTINCT category FROM FAQs " +
                "WHERE is_deleted = 0 AND category IS NOT NULL ORDER BY category ASC";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(sql);
             ResultSet rs = pst.executeQuery()) {
            while (rs.next()) categories.add(rs.getString(1));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return categories;
    }

    @Override
    public long create(Faq faq) {
        String sql = "INSERT INTO FAQs (question, answer, category, display_order, is_active, created_by) " +
                "VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            pst.setString(1, faq.getQuestion());
            pst.setString(2, faq.getAnswer());
            pst.setString(3, faq.getCategory());
            pst.setInt(4, faq.getDisplayOrder());
            pst.setBoolean(5, faq.isActive());
            pst.setLong(6, faq.getCreatedBy());

            int rows = pst.executeUpdate();
            if (rows == 0) return 0;

            try (ResultSet keys = pst.getGeneratedKeys()) {
                if (keys.next()) return keys.getLong(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public boolean update(Faq faq) {
        String sql = "UPDATE FAQs SET question = ?, answer = ?, category = ?, " +
                "display_order = ?, is_active = ?, updated_by = ? " +
                "WHERE id = ? AND is_deleted = 0";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {
            pst.setString(1, faq.getQuestion());
            pst.setString(2, faq.getAnswer());
            pst.setString(3, faq.getCategory());
            pst.setInt(4, faq.getDisplayOrder());
            pst.setBoolean(5, faq.isActive());
            pst.setLong(6, faq.getUpdatedBy() != null ? faq.getUpdatedBy() : faq.getCreatedBy());
            pst.setLong(7, faq.getId());
            return pst.executeUpdate() == 1;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean softDelete(long id, long updatedBy) {
        String sql = "UPDATE FAQs SET is_deleted = 1, updated_by = ? WHERE id = ? AND is_deleted = 0";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {
            pst.setLong(1, updatedBy);
            pst.setLong(2, id);
            return pst.executeUpdate() == 1;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean toggleActive(long id, boolean active, long updatedBy) {
        String sql = "UPDATE FAQs SET is_active = ?, updated_by = ? WHERE id = ? AND is_deleted = 0";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {
            pst.setBoolean(1, active);
            pst.setLong(2, updatedBy);
            pst.setLong(3, id);
            return pst.executeUpdate() == 1;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean updateDisplayOrder(long id, int displayOrder, long updatedBy) {
        String sql = "UPDATE FAQs SET display_order = ?, updated_by = ? WHERE id = ? AND is_deleted = 0";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {
            pst.setInt(1, displayOrder);
            pst.setLong(2, updatedBy);
            pst.setLong(3, id);
            return pst.executeUpdate() == 1;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public int countAll() {
        String sql = "SELECT COUNT(*) FROM FAQs WHERE is_deleted = 0";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(sql);
             ResultSet rs = pst.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    private Faq map(ResultSet rs) throws SQLException {
        Faq faq = new Faq();
        faq.setId(rs.getLong("id"));
        faq.setQuestion(rs.getString("question"));
        faq.setAnswer(rs.getString("answer"));
        faq.setCategory(rs.getString("category"));
        faq.setDisplayOrder(rs.getInt("display_order"));
        faq.setActive(rs.getBoolean("is_active"));
        faq.setDeleted(rs.getBoolean("is_deleted"));
        faq.setCreatedBy(rs.getLong("created_by"));

        long updatedBy = rs.getLong("updated_by");
        faq.setUpdatedBy(rs.wasNull() ? null : updatedBy);

        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) faq.setCreatedAt(createdAt.toLocalDateTime());

        Timestamp updatedAt = rs.getTimestamp("updated_at");
        if (updatedAt != null) faq.setUpdatedAt(updatedAt.toLocalDateTime());

        faq.setCreatedByName(rs.getString("created_by_name"));
        faq.setUpdatedByName(rs.getString("updated_by_name"));
        return faq;
    }
}
