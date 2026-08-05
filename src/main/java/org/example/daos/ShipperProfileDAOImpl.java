package org.example.daos;

import org.example.models.ShipperProfile;
import org.example.utils.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ShipperProfileDAOImpl implements ShipperProfileDAO {

    private static final String COLUMNS =
            "id, account_id, cccd, license_number, vehicle_type, vehicle_plate, " +
            "vehicle_model, bank_account, bank_name, id_card_front_url, id_card_back_url, " +
            "license_front_url, license_back_url, " +
            "verification_status, rejection_reason, verified_by, verified_at, created_at, updated_at ";

    @Override
    public ShipperProfile findByAccountId(long accountId) {
        String sql = "SELECT " + COLUMNS + "FROM Shipper_Profiles WHERE account_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, accountId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return map(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public boolean save(ShipperProfile p) {
        String sql = "MERGE Shipper_Profiles AS target " +
                     "USING (SELECT ? AS account_id) AS source ON target.account_id = source.account_id " +
                     "WHEN MATCHED THEN UPDATE SET " +
                     "  cccd = ?, license_number = ?, vehicle_type = ?, vehicle_plate = ?, " +
                     "  vehicle_model = ?, bank_account = ?, bank_name = ?, " +
                     "  id_card_front_url = COALESCE(?, target.id_card_front_url), " +
                     "  id_card_back_url = COALESCE(?, target.id_card_back_url), " +
                     "  license_front_url = COALESCE(?, target.license_front_url), updated_at = GETDATE() " +
                     "WHEN NOT MATCHED THEN INSERT " +
                     "  (account_id, cccd, license_number, vehicle_type, vehicle_plate, vehicle_model, bank_account, bank_name, " +
                     "   id_card_front_url, id_card_back_url, license_front_url) " +
                     "  VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, p.getAccountId());
            // UPDATE branch
            ps.setString(2, p.getCccd());
            ps.setString(3, p.getLicenseNumber());
            ps.setNString(4, p.getVehicleType());
            ps.setString(5, p.getVehiclePlate());
            ps.setNString(6, p.getVehicleModel());
            ps.setString(7, p.getBankAccount());
            ps.setNString(8, p.getBankName());
            ps.setString(9, p.getIdCardFrontUrl());
            ps.setString(10, p.getIdCardBackUrl());
            ps.setString(11, p.getLicenseFrontUrl());
            // INSERT branch
            ps.setLong(12, p.getAccountId());
            ps.setString(13, p.getCccd());
            ps.setString(14, p.getLicenseNumber());
            ps.setNString(15, p.getVehicleType());
            ps.setString(16, p.getVehiclePlate());
            ps.setNString(17, p.getVehicleModel());
            ps.setString(18, p.getBankAccount());
            ps.setNString(19, p.getBankName());
            ps.setString(20, p.getIdCardFrontUrl());
            ps.setString(21, p.getIdCardBackUrl());
            ps.setString(22, p.getLicenseFrontUrl());
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean updateIdCardFrontUrl(long accountId, String idCardFrontUrl) {
        return upsertDocUrl(accountId, "id_card_front_url", idCardFrontUrl);
    }

    @Override
    public boolean updateIdCardBackUrl(long accountId, String idCardBackUrl) {
        return upsertDocUrl(accountId, "id_card_back_url", idCardBackUrl);
    }

    @Override
    public boolean updateLicenseFrontUrl(long accountId, String licenseFrontUrl) {
        return upsertDocUrl(accountId, "license_front_url", licenseFrontUrl);
    }

    @Override
    public boolean updateLicenseBackUrl(long accountId, String licenseBackUrl) {
        return upsertDocUrl(accountId, "license_back_url", licenseBackUrl);
    }

    /** 4 cot anh giay to (front/back x CCCD/GPLX) deu upsert giong het nhau, chi khac ten cot. */
    private boolean upsertDocUrl(long accountId, String column, String url) {
        String sql = "MERGE Shipper_Profiles AS target " +
                     "USING (SELECT ? AS account_id) AS source ON target.account_id = source.account_id " +
                     "WHEN MATCHED THEN UPDATE SET " + column + " = ?, updated_at = GETDATE() " +
                     "WHEN NOT MATCHED THEN INSERT (account_id, " + column + ") VALUES (?, ?);";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, accountId);
            ps.setString(2, url);
            ps.setLong(3, accountId);
            ps.setString(4, url);
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean resetToPendingIfRejected(long accountId) {
        String sql = "UPDATE Shipper_Profiles SET verification_status = 'PENDING', rejection_reason = NULL, " +
                     "updated_at = GETDATE() WHERE account_id = ? AND verification_status = 'REJECTED'";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, accountId);
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public List<ShipperProfile> findByVerificationStatus(String status) {
        List<ShipperProfile> list = new ArrayList<>();
        String sql = "SELECT " + COLUMNS + "FROM Shipper_Profiles WHERE verification_status = ? ORDER BY created_at DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public boolean updateVerificationStatus(long accountId, String status, String rejectionReason, long verifiedBy) {
        // Guard atomic: chi cho duyet/tu choi khi ho so dang o PENDING, tranh double-click/multi-tab
        // doi trang thai tuy y (APPROVED -> REJECTED -> APPROVED) va ghi de verified_by/verified_at.
        String sql = "UPDATE Shipper_Profiles SET verification_status = ?, rejection_reason = ?, " +
                     "verified_by = ?, verified_at = GETDATE(), updated_at = GETDATE() " +
                     "WHERE account_id = ? AND verification_status = 'PENDING'";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setString(2, rejectionReason);
            ps.setLong(3, verifiedBy);
            ps.setLong(4, accountId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    private ShipperProfile map(ResultSet rs) throws SQLException {
        ShipperProfile p = new ShipperProfile();
        p.setId(rs.getLong("id"));
        p.setAccountId(rs.getLong("account_id"));
        p.setCccd(rs.getString("cccd"));
        p.setLicenseNumber(rs.getString("license_number"));
        p.setVehicleType(rs.getString("vehicle_type"));
        p.setVehiclePlate(rs.getString("vehicle_plate"));
        p.setVehicleModel(rs.getString("vehicle_model"));
        p.setBankAccount(rs.getString("bank_account"));
        p.setBankName(rs.getString("bank_name"));
        p.setIdCardFrontUrl(rs.getString("id_card_front_url"));
        p.setIdCardBackUrl(rs.getString("id_card_back_url"));
        p.setLicenseFrontUrl(rs.getString("license_front_url"));
        p.setLicenseBackUrl(rs.getString("license_back_url"));
        p.setVerificationStatus(rs.getString("verification_status"));
        p.setRejectionReason(rs.getString("rejection_reason"));
        long verifiedBy = rs.getLong("verified_by");
        if (!rs.wasNull()) p.setVerifiedBy(verifiedBy);
        Timestamp va = rs.getTimestamp("verified_at");
        if (va != null) p.setVerifiedAt(va.toLocalDateTime());
        Timestamp ca = rs.getTimestamp("created_at");
        if (ca != null) p.setCreatedAt(ca.toLocalDateTime());
        Timestamp ua = rs.getTimestamp("updated_at");
        if (ua != null) p.setUpdatedAt(ua.toLocalDateTime());
        return p;
    }
}
