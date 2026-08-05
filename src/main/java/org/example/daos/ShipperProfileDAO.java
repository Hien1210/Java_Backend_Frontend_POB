package org.example.daos;

import org.example.models.ShipperProfile;

import java.util.List;

public interface ShipperProfileDAO {
    ShipperProfile findByAccountId(long accountId);
    boolean save(ShipperProfile profile); // insert or update (upsert)
    boolean updateIdCardFrontUrl(long accountId, String idCardFrontUrl);
    boolean updateIdCardBackUrl(long accountId, String idCardBackUrl);
    boolean updateLicenseFrontUrl(long accountId, String licenseFrontUrl);
    boolean updateLicenseBackUrl(long accountId, String licenseBackUrl);

    /** Danh sach ho so dang cho SuperAdmin duyet giay to (verification_status = 'PENDING'). */
    List<ShipperProfile> findByVerificationStatus(String status);

    /** SuperAdmin duyet/tu choi giay to; rejectionReason chi dung khi status = REJECTED. */
    boolean updateVerificationStatus(long accountId, String status, String rejectionReason, long verifiedBy);

    /** Sau khi Shipper bi REJECTED upload lai anh giay to, dua ho so ve PENDING de vao lai hang
     * cho SuperAdmin duyet (chi doi khi dang REJECTED, khong dung khi PENDING/APPROVED). */
    boolean resetToPendingIfRejected(long accountId);
}
