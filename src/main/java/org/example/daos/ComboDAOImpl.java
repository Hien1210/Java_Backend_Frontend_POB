package org.example.daos;

import org.example.models.Combo;
import org.example.models.ComboItem;
import org.example.utils.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ComboDAOImpl implements ComboDAO {

    @Override
    public List<Combo> findByShopId(long shopId) {
        String sql = "SELECT id, shop_id, name, description, combo_price, is_active, created_at " +
                     "FROM Combos WHERE shop_id = ? ORDER BY created_at DESC";
        List<Combo> result = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, shopId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) result.add(map(rs));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return result;
    }

    @Override
    public Combo findById(long id) {
        String sql = "SELECT id, shop_id, name, description, combo_price, is_active, created_at FROM Combos WHERE id = ?";
        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Combo c = map(rs);
                    c.setItems(findItemsByComboId(id));
                    return c;
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    @Override
    public long create(Combo combo) {
        String sql = "INSERT INTO Combos (shop_id, name, description, combo_price, is_active) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setLong(1, combo.getShopId());
            ps.setString(2, combo.getName());
            ps.setString(3, combo.getDescription());
            ps.setDouble(4, combo.getComboPrice());
            ps.setBoolean(5, combo.isActive());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) return keys.getLong(1);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    @Override
    public boolean update(Combo combo) {
        String sql = "UPDATE Combos SET name=?, description=?, combo_price=?, is_active=?, updated_at=GETDATE() WHERE id=? AND shop_id=?";
        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, combo.getName());
            ps.setString(2, combo.getDescription());
            ps.setDouble(3, combo.getComboPrice());
            ps.setBoolean(4, combo.isActive());
            ps.setLong(5, combo.getId());
            ps.setLong(6, combo.getShopId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    @Override
    public boolean delete(long id) {
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement("DELETE FROM Combos WHERE id = ?")) {
            ps.setLong(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    @Override
    public boolean addItem(ComboItem item) {
        String sql = "INSERT INTO Combo_Items (combo_id, product_id, product_size_id, quantity) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, item.getComboId());
            ps.setLong(2, item.getProductId());
            ps.setLong(3, item.getProductSizeId());
            ps.setInt(4, item.getQuantity());
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    @Override
    public boolean deleteItems(long comboId) {
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement("DELETE FROM Combo_Items WHERE combo_id = ?")) {
            ps.setLong(1, comboId);
            ps.executeUpdate();
            return true;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    @Override
    public List<ComboItem> findItemsByComboId(long comboId) {
        String sql = "SELECT ci.id, ci.combo_id, ci.product_id, ci.product_size_id, ci.quantity, " +
                     "p.product_name, ps.size_name, ps.price AS size_price " +
                     "FROM Combo_Items ci " +
                     "JOIN Products p ON p.id = ci.product_id " +
                     "JOIN Product_Sizes ps ON ps.id = ci.product_size_id " +
                     "WHERE ci.combo_id = ?";
        List<ComboItem> result = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, comboId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ComboItem item = new ComboItem();
                    item.setId(rs.getLong("id"));
                    item.setComboId(rs.getLong("combo_id"));
                    item.setProductId(rs.getLong("product_id"));
                    item.setProductSizeId(rs.getLong("product_size_id"));
                    item.setQuantity(rs.getInt("quantity"));
                    item.setProductName(rs.getString("product_name"));
                    item.setSizeName(rs.getString("size_name"));
                    item.setSizePrice(rs.getDouble("size_price"));
                    result.add(item);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return result;
    }

    @Override
    public List<ComboItem> findSuggestionsByProductId(long productId, long shopId) {
        String sql =
            "SELECT DISTINCT ci2.id, ci2.combo_id, ci2.product_id, ci2.product_size_id, ci2.quantity, " +
            "  p.product_name, ps.size_name, ps.price AS size_price, " +
            "  (SELECT TOP 1 image_url FROM Product_Images WHERE product_id = ci2.product_id ORDER BY id) AS product_image_url " +
            "FROM Combo_Items ci1 " +
            "JOIN Combos c ON c.id = ci1.combo_id " +
            "JOIN Combo_Items ci2 ON ci2.combo_id = ci1.combo_id AND ci2.product_id <> ci1.product_id " +
            "JOIN Products p ON p.id = ci2.product_id AND p.is_deleted = 0 AND p.status = 'ACTIVE' " +
            "JOIN Product_Sizes ps ON ps.id = ci2.product_size_id " +
            "WHERE ci1.product_id = ? AND c.shop_id = ? AND c.is_active = 1 " +
            "ORDER BY ci2.product_id";
        List<ComboItem> result = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, productId);
            ps.setLong(2, shopId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ComboItem item = new ComboItem();
                    item.setId(rs.getLong("id"));
                    item.setComboId(rs.getLong("combo_id"));
                    item.setProductId(rs.getLong("product_id"));
                    item.setProductSizeId(rs.getLong("product_size_id"));
                    item.setQuantity(rs.getInt("quantity"));
                    item.setProductName(rs.getString("product_name"));
                    item.setSizeName(rs.getString("size_name"));
                    item.setSizePrice(rs.getDouble("size_price"));
                    item.setProductImageUrl(rs.getString("product_image_url"));
                    result.add(item);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return result;
    }

    private Combo map(ResultSet rs) throws SQLException {
        Combo c = new Combo();
        c.setId(rs.getLong("id"));
        c.setShopId(rs.getLong("shop_id"));
        c.setName(rs.getString("name"));
        c.setDescription(rs.getString("description"));
        c.setComboPrice(rs.getDouble("combo_price"));
        c.setActive(rs.getBoolean("is_active"));
        Timestamp ts = rs.getTimestamp("created_at");
        if (ts != null) c.setCreatedAt(ts.toLocalDateTime());
        return c;
    }
}
