package org.example.daos;

import org.example.models.FlashSale;
import org.example.utils.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FlashSaleDAOImpl implements FlashSaleDAO {

    private static final String SELECT_COLS =
            "fs.id, fs.shop_id, fs.product_size_id, fs.sale_price, fs.start_time, fs.end_time, fs.is_active, fs.created_at, " +
            "p.product_name, ps.size_name, ps.price AS original_price";
    private static final String JOIN =
            "FROM Flash_Sales fs " +
            "JOIN Product_Sizes ps ON ps.id = fs.product_size_id " +
            "JOIN Products p ON p.id = ps.product_id";

    @Override
    public List<FlashSale> findByShopId(long shopId) {
        String sql = "SELECT " + SELECT_COLS + " " + JOIN + " WHERE fs.shop_id = ? ORDER BY fs.created_at DESC";
        List<FlashSale> result = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, shopId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) result.add(map(rs));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return result;
    }

    @Override
    public List<FlashSale> findActiveByShopId(long shopId) {
        String sql = "SELECT " + SELECT_COLS + " " + JOIN +
                     " WHERE fs.shop_id = ? AND fs.is_active = 1 ORDER BY fs.created_at DESC";
        List<FlashSale> result = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, shopId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    FlashSale fs = map(rs);
                    if (fs.isCurrentlyActive()) {
                        result.add(fs);
                    }
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return result;
    }

    @Override
    public FlashSale findById(long id) {
        String sql = "SELECT " + SELECT_COLS + " " + JOIN + " WHERE fs.id = ?";
        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return map(rs);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    @Override
    public long create(FlashSale fs) {
        String sql = "INSERT INTO Flash_Sales (shop_id, product_size_id, sale_price, start_time, end_time, is_active) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setLong(1, fs.getShopId());
            ps.setLong(2, fs.getProductSizeId());
            ps.setDouble(3, fs.getSalePrice());
            ps.setTimestamp(4, Timestamp.valueOf(fs.getStartTime()));
            ps.setTimestamp(5, Timestamp.valueOf(fs.getEndTime()));
            ps.setBoolean(6, fs.isActive());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) return keys.getLong(1);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    @Override
    public boolean delete(long id) {
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement("DELETE FROM Flash_Sales WHERE id = ?")) {
            ps.setLong(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    @Override
    public Double getActiveSalePrice(long productSizeId) {
        String sql = "SELECT " + SELECT_COLS + " " + JOIN +
                     " WHERE fs.product_size_id = ? AND fs.is_active = 1 ORDER BY fs.sale_price ASC";
        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, productSizeId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    FlashSale fs = map(rs);
                    if (fs.isCurrentlyActive()) {
                        return fs.getSalePrice();
                    }
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    private FlashSale map(ResultSet rs) throws SQLException {
        FlashSale fs = new FlashSale();
        fs.setId(rs.getLong("id"));
        fs.setShopId(rs.getLong("shop_id"));
        fs.setProductSizeId(rs.getLong("product_size_id"));
        fs.setSalePrice(rs.getDouble("sale_price"));
        Timestamp st = rs.getTimestamp("start_time");
        if (st != null) fs.setStartTime(st.toLocalDateTime());
        Timestamp et = rs.getTimestamp("end_time");
        if (et != null) fs.setEndTime(et.toLocalDateTime());
        fs.setActive(rs.getBoolean("is_active"));
        Timestamp cat = rs.getTimestamp("created_at");
        if (cat != null) fs.setCreatedAt(cat.toLocalDateTime());
        fs.setProductName(rs.getString("product_name"));
        fs.setSizeName(rs.getString("size_name"));
        fs.setOriginalPrice(rs.getDouble("original_price"));
        return fs;
    }
}
