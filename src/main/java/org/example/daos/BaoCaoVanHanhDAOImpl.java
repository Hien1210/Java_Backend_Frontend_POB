package org.example.daos;

import org.example.utils.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.Map;

public class BaoCaoVanHanhDAOImpl implements BaoCaoVanHanhDAO {

    @Override
    public int countTotalOrders(LocalDate tuNgay, LocalDate denNgay) {
        String sql = "SELECT COUNT(*) FROM Orders WHERE created_at >= ? AND created_at < DATEADD(DAY, 1, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setTimestamp(1, Timestamp.valueOf(tuNgay.atStartOfDay()));
            ps.setTimestamp(2, Timestamp.valueOf(denNgay.atStartOfDay()));
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public Map<String, Integer> countOrdersByStatus(LocalDate tuNgay, LocalDate denNgay) {
        String sql = "SELECT status, COUNT(*) AS so_luong FROM Orders " +
                "WHERE created_at >= ? AND created_at < DATEADD(DAY, 1, ?) " +
                "GROUP BY status";
        Map<String, Integer> result = new HashMap<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setTimestamp(1, Timestamp.valueOf(tuNgay.atStartOfDay()));
            ps.setTimestamp(2, Timestamp.valueOf(denNgay.atStartOfDay()));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    result.put(rs.getString("status"), rs.getInt("so_luong"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    @Override
    public Double getAvgThoiGianGiaoHangPhut(LocalDate tuNgay, LocalDate denNgay) {
        // Thoi gian giao hang = khoang cach tu luc Shop xac nhan don (CONFIRMED)
        // den luc Shipper giao xong (DONE), lay theo Order_Logs (bang audit trail trang thai)
        String sql = "SELECT AVG(CAST(DATEDIFF(MINUTE, xacNhan.thoi_gian, hoanThanh.thoi_gian) AS FLOAT)) AS trung_binh_phut " +
                "FROM (SELECT order_id, MIN(created_at) AS thoi_gian FROM Order_Logs WHERE new_status = 'CONFIRMED' GROUP BY order_id) xacNhan " +
                "JOIN (SELECT order_id, MIN(created_at) AS thoi_gian FROM Order_Logs WHERE new_status = 'DONE' GROUP BY order_id) hoanThanh " +
                "   ON xacNhan.order_id = hoanThanh.order_id " +
                "JOIN Orders o ON o.id = xacNhan.order_id " +
                "WHERE o.created_at >= ? AND o.created_at < DATEADD(DAY, 1, ?) " +
                "   AND hoanThanh.thoi_gian > xacNhan.thoi_gian";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setTimestamp(1, Timestamp.valueOf(tuNgay.atStartOfDay()));
            ps.setTimestamp(2, Timestamp.valueOf(denNgay.atStartOfDay()));
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    double value = rs.getDouble(1);
                    return rs.wasNull() ? null : value;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
