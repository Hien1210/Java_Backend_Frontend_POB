package org.example.daos;

import org.example.models.UserAddress;
import org.example.utils.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserAddressDAOImpl implements UserAddressDAO {

    @Override
    public List<UserAddress> findByAccountId(long accountId) {
        List<UserAddress> list = new ArrayList<>();
        String sql = "SELECT id, user_id, label, address, receiver_name, receiver_phone, is_default, is_deleted, created_at " +
                     "FROM User_Addresses WHERE user_id = ? AND is_deleted = 0 ORDER BY is_default DESC, id ASC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, accountId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public UserAddress findById(long id) {
        String sql = "SELECT id, user_id, label, address, receiver_name, receiver_phone, is_default, is_deleted, created_at " +
                     "FROM User_Addresses WHERE id = ? AND is_deleted = 0";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return map(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public boolean create(UserAddress a) {
        String sql = "INSERT INTO User_Addresses (user_id, label, address, receiver_name, receiver_phone, is_default) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, a.getUserId());
            ps.setNString(2, a.getLabel());
            ps.setNString(3, a.getAddress());
            ps.setNString(4, a.getReceiverName());
            ps.setString(5, a.getReceiverPhone());
            ps.setBoolean(6, a.isDefault());
            return ps.executeUpdate() == 1;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean update(UserAddress a) {
        String sql = "UPDATE User_Addresses SET label = ?, address = ?, receiver_name = ?, receiver_phone = ? " +
                     "WHERE id = ? AND user_id = ? AND is_deleted = 0";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setNString(1, a.getLabel());
            ps.setNString(2, a.getAddress());
            ps.setNString(3, a.getReceiverName());
            ps.setString(4, a.getReceiverPhone());
            ps.setLong(5, a.getId());
            ps.setLong(6, a.getUserId());
            return ps.executeUpdate() == 1;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean delete(long id) {
        // Soft delete: set is_deleted = 1
        String sql = "UPDATE User_Addresses SET is_deleted = 1 WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, id);
            return ps.executeUpdate() == 1;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean setDefault(long addressId, long accountId) {
        String sql1 = "UPDATE User_Addresses SET is_default = 0 WHERE user_id = ?";
        String sql2 = "UPDATE User_Addresses SET is_default = 1 WHERE id = ? AND user_id = ?";
        try (Connection conn = DBUtil.getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement ps1 = conn.prepareStatement(sql1)) {
                ps1.setLong(1, accountId);
                ps1.executeUpdate();
            }
            if (addressId > 0) {
                try (PreparedStatement ps2 = conn.prepareStatement(sql2)) {
                    ps2.setLong(1, addressId);
                    ps2.setLong(2, accountId);
                    ps2.executeUpdate();
                }
            }
            conn.commit();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    private UserAddress map(ResultSet rs) throws SQLException {
        UserAddress a = new UserAddress();
        a.setId(rs.getLong("id"));
        a.setUserId(rs.getLong("user_id"));
        a.setLabel(rs.getString("label"));
        a.setAddress(rs.getString("address"));
        a.setReceiverName(rs.getString("receiver_name"));
        a.setReceiverPhone(rs.getString("receiver_phone"));
        a.setDefault(rs.getBoolean("is_default"));
        a.setDeleted(rs.getBoolean("is_deleted"));
        Timestamp ca = rs.getTimestamp("created_at");
        if (ca != null) a.setCreatedAt(ca.toLocalDateTime());
        return a;
    }
}
