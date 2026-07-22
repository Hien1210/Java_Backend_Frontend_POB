package org.example.daos;

import org.example.models.ShopDoiSoat;
import org.example.utils.DBUtil;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class DoiSoatDoanhThuShopDAOImpl implements DoiSoatDoanhThuShopDAO {

    @Override
    public List<ShopDoiSoat> getDoiSoatTheoShop(LocalDate tuNgay, LocalDate denNgay, Long shopId) {
        StringBuilder sql = new StringBuilder(
                "SELECT s.id AS shop_id, s.shop_name, " +
                "       COUNT(o.id) AS so_don, ISNULL(SUM(o.total_price), 0) AS tong_doanh_thu, " +
                "       ss.status AS settlement_status " +
                "FROM Shops s " +
                "LEFT JOIN Orders o ON o.shop_id = s.id AND o.status = 'DONE' " +
                "       AND o.created_at >= ? AND o.created_at < DATEADD(DAY, 1, ?) " +
                "LEFT JOIN Shop_Settlements ss ON ss.shop_id = s.id AND ss.period_start = ? AND ss.period_end = ? " +
                "WHERE s.is_deleted = 0 ");
        if (shopId != null) {
            sql.append("AND s.id = ? ");
        }
        sql.append("GROUP BY s.id, s.shop_name, ss.status ORDER BY tong_doanh_thu DESC");

        List<ShopDoiSoat> result = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int idx = 1;
            ps.setTimestamp(idx++, Timestamp.valueOf(tuNgay.atStartOfDay()));
            ps.setTimestamp(idx++, Timestamp.valueOf(denNgay.atStartOfDay()));
            ps.setDate(idx++, Date.valueOf(tuNgay));
            ps.setDate(idx++, Date.valueOf(denNgay));
            if (shopId != null) {
                ps.setLong(idx++, shopId);
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    boolean daThanhToan = "PAID".equals(rs.getString("settlement_status"));
                    ShopDoiSoat item = new ShopDoiSoat(
                            rs.getLong("shop_id"),
                            rs.getString("shop_name"),
                            rs.getInt("so_don"),
                            rs.getDouble("tong_doanh_thu"),
                            daThanhToan
                    );
                    result.add(item);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    @Override
    public boolean xacNhanThanhToan(long shopId, LocalDate tuNgay, LocalDate denNgay,
                                     double tongDoanhThu, double phiSan, double soTienThucNhan, long confirmedBy) {
        String sql =
                "MERGE INTO Shop_Settlements AS target " +
                "USING (SELECT ? AS shop_id, ? AS period_start, ? AS period_end) AS src " +
                "   ON target.shop_id = src.shop_id AND target.period_start = src.period_start AND target.period_end = src.period_end " +
                "WHEN MATCHED THEN UPDATE SET " +
                "   status = 'PAID', gross_revenue = ?, platform_fee = ?, net_payout = ?, " +
                "   confirmed_by = ?, confirmed_at = GETDATE(), updated_at = GETDATE() " +
                "WHEN NOT MATCHED THEN INSERT " +
                "   (shop_id, period_start, period_end, gross_revenue, platform_fee, net_payout, status, confirmed_by, confirmed_at) " +
                "   VALUES (src.shop_id, src.period_start, src.period_end, ?, ?, ?, 'PAID', ?, GETDATE());";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            int idx = 1;
            ps.setLong(idx++, shopId);
            ps.setDate(idx++, Date.valueOf(tuNgay));
            ps.setDate(idx++, Date.valueOf(denNgay));
            // UPDATE branch
            ps.setDouble(idx++, tongDoanhThu);
            ps.setDouble(idx++, phiSan);
            ps.setDouble(idx++, soTienThucNhan);
            ps.setLong(idx++, confirmedBy);
            // INSERT branch
            ps.setDouble(idx++, tongDoanhThu);
            ps.setDouble(idx++, phiSan);
            ps.setDouble(idx++, soTienThucNhan);
            ps.setLong(idx++, confirmedBy);

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
