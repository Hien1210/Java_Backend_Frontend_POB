package org.example.daos;

import org.example.utils.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
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
                    "FROM (SELECT order_id, MIN(created_at) AS thoi_gian FROM Order_Logs WHERE new_status = 'WAITING_FOR_SHIPPER' GROUP BY order_id) xacNhan " +
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

    @Override
    public String getKhungGioDatHangCaoDiem(LocalDate tuNgay, LocalDate denNgay) {
        // MSSQL khong co ham HOUR() nhu MySQL -> dung DATEPART(HOUR, ...) de nhom don theo gio trong ngay.
        String sql = "SELECT TOP 1 DATEPART(HOUR, created_at) AS gio, COUNT(*) AS so_luong " +
                "FROM Orders WHERE created_at >= ? AND created_at < DATEADD(DAY, 1, ?) " +
                "GROUP BY DATEPART(HOUR, created_at) ORDER BY so_luong DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setTimestamp(1, Timestamp.valueOf(tuNgay.atStartOfDay()));
            ps.setTimestamp(2, Timestamp.valueOf(denNgay.atStartOfDay()));
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int gio = rs.getInt("gio");
                    return String.format("%02d:00 - %02d:00", gio, (gio + 1) % 24);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public Map<String, Integer> countCancelReasons(LocalDate tuNgay, LocalDate denNgay) {
        String sql = "SELECT ISNULL(cancel_reason, N'Không rõ lý do') AS ly_do, COUNT(*) AS so_luong " +
                "FROM Orders WHERE status = 'CANCELLED' " +
                "AND created_at >= ? AND created_at < DATEADD(DAY, 1, ?) " +
                "GROUP BY ISNULL(cancel_reason, N'Không rõ lý do') ORDER BY so_luong DESC";
        Map<String, Integer> result = new LinkedHashMap<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setTimestamp(1, Timestamp.valueOf(tuNgay.atStartOfDay()));
            ps.setTimestamp(2, Timestamp.valueOf(denNgay.atStartOfDay()));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    result.put(rs.getString("ly_do"), rs.getInt("so_luong"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    @Override
    public List<double[]> findOrderCoordinates(LocalDate tuNgay, LocalDate denNgay) {
        String sql = "SELECT locationX, locationY FROM Orders " +
                "WHERE locationX IS NOT NULL AND locationY IS NOT NULL " +
                "AND created_at >= ? AND created_at < DATEADD(DAY, 1, ?)";
        List<double[]> result = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setTimestamp(1, Timestamp.valueOf(tuNgay.atStartOfDay()));
            ps.setTimestamp(2, Timestamp.valueOf(denNgay.atStartOfDay()));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    result.add(new double[]{rs.getDouble("locationX"), rs.getDouble("locationY")});
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    @Override
    public List<org.example.models.OrderMapDTO> findOrderMapDetails(LocalDate tuNgay, LocalDate denNgay) {
        String sql = "SELECT o.id, " +
                "COALESCE(o.locationX, s.locationX, 10.776889 + (o.id % 15) * 0.008) AS locX, " +
                "COALESCE(o.locationY, s.locationY, 106.700806 + (o.id % 20) * 0.007) AS locY, " +
                "o.total_amount, o.shipping_address, o.created_at, " +
                "COALESCE(s.shop_name, N'POB Food Store') AS shop_name " +
                "FROM Orders o " +
                "LEFT JOIN Shops s ON o.shop_id = s.id " +
                "WHERE o.created_at >= ? AND o.created_at < DATEADD(DAY, 1, ?) " +
                "ORDER BY o.created_at DESC";
        List<org.example.models.OrderMapDTO> result = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setTimestamp(1, Timestamp.valueOf(tuNgay.atStartOfDay()));
            ps.setTimestamp(2, Timestamp.valueOf(denNgay.atStartOfDay()));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    org.example.models.OrderMapDTO item = new org.example.models.OrderMapDTO(
                            rs.getInt("id"),
                            rs.getDouble("locX"),
                            rs.getDouble("locY"),
                            rs.getDouble("total_amount"),
                            rs.getString("shipping_address"),
                            rs.getString("shop_name"),
                            rs.getTimestamp("created_at")
                    );
                    result.add(item);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }
}
