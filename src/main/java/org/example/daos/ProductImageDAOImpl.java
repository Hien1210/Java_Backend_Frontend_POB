package org.example.daos;

import org.example.utils.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ProductImageDAOImpl implements ProductImageDAO {

    @Override
    public String findPrimaryUrlByProductId(long productId) {
        String sql = "SELECT image_url FROM Product_Images WHERE product_id = ? AND is_primary = 1";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("image_url");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public Map<Long, String> findPrimaryUrlsByProductIds(List<Long> productIds) {
        Map<Long, String> result = new HashMap<>();
        if (productIds == null || productIds.isEmpty()) {
            return result;
        }

        String placeholders = String.join(",", java.util.Collections.nCopies(productIds.size(), "?"));
        String sql = "SELECT product_id, image_url FROM Product_Images " +
                "WHERE is_primary = 1 AND product_id IN (" + placeholders + ")";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            int index = 1;
            for (Long id : productIds) {
                ps.setLong(index++, id);
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    result.put(rs.getLong("product_id"), rs.getString("image_url"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    @Override
    public boolean upsertPrimary(long productId, String imageUrl) {
        String deleteSql = "DELETE FROM Product_Images WHERE product_id = ? AND is_primary = 1";
        String insertSql = "INSERT INTO Product_Images (product_id, image_url, is_primary, sort_order) VALUES (?, ?, 1, 0)";

        try (Connection conn = DBUtil.getConnection()) {
            conn.setAutoCommit(false);
            try {
                try (PreparedStatement ps = conn.prepareStatement(deleteSql)) {
                    ps.setLong(1, productId);
                    ps.executeUpdate();
                }
                try (PreparedStatement ps = conn.prepareStatement(insertSql)) {
                    ps.setLong(1, productId);
                    ps.setString(2, imageUrl);
                    ps.executeUpdate();
                }
                conn.commit();
                return true;
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
