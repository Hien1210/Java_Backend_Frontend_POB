package org.example.models;

import java.time.LocalDateTime;

public class ShipperProfile {
    private long id;
    private long accountId;
    private String cccd;
    private String licenseNumber;
    private String vehicleType;
    private String vehiclePlate;
    private String vehicleModel;
    private String bankAccount;
    private String bankName;
    private String bankAccountHolder;
    private String idCardFrontUrl;
    private String idCardBackUrl;
    private String licenseFrontUrl;
    private String licenseBackUrl;
    private String verificationStatus;
    private String rejectionReason;
    private Long verifiedBy;
    private LocalDateTime verifiedAt;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public ShipperProfile() {}

    public long getId() { return id; }
    public void setId(long id) { this.id = id; }

    public long getAccountId() { return accountId; }
    public void setAccountId(long accountId) { this.accountId = accountId; }

    public String getCccd() { return cccd; }
    public void setCccd(String cccd) { this.cccd = cccd; }

    public String getLicenseNumber() { return licenseNumber; }
    public void setLicenseNumber(String licenseNumber) { this.licenseNumber = licenseNumber; }

    public String getVehicleType() { return vehicleType; }
    public void setVehicleType(String vehicleType) { this.vehicleType = vehicleType; }

    public String getVehiclePlate() { return vehiclePlate; }
    public void setVehiclePlate(String vehiclePlate) { this.vehiclePlate = vehiclePlate; }

    public String getVehicleModel() { return vehicleModel; }
    public void setVehicleModel(String vehicleModel) { this.vehicleModel = vehicleModel; }

    public String getBankAccount() { return bankAccount; }
    public void setBankAccount(String bankAccount) { this.bankAccount = bankAccount; }

    public String getBankName() { return bankName; }
    public void setBankName(String bankName) { this.bankName = bankName; }

    public String getBankAccountHolder() { return bankAccountHolder; }
    public void setBankAccountHolder(String bankAccountHolder) { this.bankAccountHolder = bankAccountHolder; }

    /** true nếu shipper đã điền đủ Số TK + Tên ngân hàng + Tên chủ TK để rút tiền. */
    public boolean isHasBankInfo() {
        return bankAccount != null && !bankAccount.isBlank()
                && bankName != null && !bankName.isBlank()
                && bankAccountHolder != null && !bankAccountHolder.isBlank();
    }

    public String getIdCardFrontUrl() { return idCardFrontUrl; }
    public void setIdCardFrontUrl(String idCardFrontUrl) { this.idCardFrontUrl = idCardFrontUrl; }

    public String getIdCardBackUrl() { return idCardBackUrl; }
    public void setIdCardBackUrl(String idCardBackUrl) { this.idCardBackUrl = idCardBackUrl; }

    public String getLicenseFrontUrl() { return licenseFrontUrl; }
    public void setLicenseFrontUrl(String licenseFrontUrl) { this.licenseFrontUrl = licenseFrontUrl; }

    public String getLicenseBackUrl() { return licenseBackUrl; }
    public void setLicenseBackUrl(String licenseBackUrl) { this.licenseBackUrl = licenseBackUrl; }

    public String getVerificationStatus() { return verificationStatus; }
    public void setVerificationStatus(String verificationStatus) { this.verificationStatus = verificationStatus; }

    public String getRejectionReason() { return rejectionReason; }
    public void setRejectionReason(String rejectionReason) { this.rejectionReason = rejectionReason; }

    public Long getVerifiedBy() { return verifiedBy; }
    public void setVerifiedBy(Long verifiedBy) { this.verifiedBy = verifiedBy; }

    public LocalDateTime getVerifiedAt() { return verifiedAt; }
    public void setVerifiedAt(LocalDateTime verifiedAt) { this.verifiedAt = verifiedAt; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
}
