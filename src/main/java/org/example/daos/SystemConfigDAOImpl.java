package org.example.daos;

import org.example.models.SystemConfig;
import org.example.utils.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;

public class SystemConfigDAOImpl implements SystemConfigDAO {

    @Override
    public SystemConfig get() {
        String sql = "SELECT * FROM System_Configs WHERE id = 1";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return map(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return defaults();
    }

    @Override
    public boolean save(SystemConfig config) {
        String sql = "UPDATE System_Configs SET " +
                "commission_percent = ?, fixed_fee_per_order = ?, " +
                "shipping_fee_first_2km = ?, shipping_fee_per_km = ?, max_delivery_radius_km = ?, " +
                "shop_accept_order_minutes = ?, auto_complete_order_hours = ?, updated_at = GETDATE() " +
                "WHERE id = 1";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDouble(1, config.getCommissionPercent());
            ps.setDouble(2, config.getFixedFeePerOrder());
            ps.setDouble(3, config.getShippingFeeFirst2Km());
            ps.setDouble(4, config.getShippingFeePerKm());
            ps.setDouble(5, config.getMaxDeliveryRadiusKm());
            ps.setInt(6, config.getShopAcceptOrderMinutes());
            ps.setInt(7, config.getAutoCompleteOrderHours());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    private SystemConfig map(ResultSet rs) throws Exception {
        SystemConfig c = new SystemConfig();
        c.setId(rs.getInt("id"));
        c.setCommissionPercent(rs.getDouble("commission_percent"));
        c.setFixedFeePerOrder(rs.getDouble("fixed_fee_per_order"));
        c.setShippingFeeFirst2Km(rs.getDouble("shipping_fee_first_2km"));
        c.setShippingFeePerKm(rs.getDouble("shipping_fee_per_km"));
        c.setMaxDeliveryRadiusKm(rs.getDouble("max_delivery_radius_km"));
        c.setShopAcceptOrderMinutes(rs.getInt("shop_accept_order_minutes"));
        c.setAutoCompleteOrderHours(rs.getInt("auto_complete_order_hours"));
        Timestamp ts = rs.getTimestamp("updated_at");
        if (ts != null) c.setUpdatedAt(ts.toLocalDateTime());
        return c;
    }

    private SystemConfig defaults() {
        SystemConfig c = new SystemConfig();
        c.setCommissionPercent(10);
        c.setFixedFeePerOrder(0);
        c.setShippingFeeFirst2Km(15000);
        c.setShippingFeePerKm(5000);
        c.setMaxDeliveryRadiusKm(10);
        c.setShopAcceptOrderMinutes(15);
        c.setAutoCompleteOrderHours(48);
        return c;
    }
}
