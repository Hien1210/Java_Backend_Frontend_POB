-- ===
-- Migration: Thêm ảnh GPLX + trạng thái duyệt giấy tờ (CCCD/GPLX) cho Shipper
-- (cột id_card_image_url đã có sẵn từ trước nhưng chưa có nơi nào ghi/đọc trạng thái duyệt;
-- migration này bổ sung ảnh GPLX + cờ verification_status để SuperAdmin đối chiếu & duyệt
-- cho Shipper trước khi hoạt động chính thức)
-- Chạy 1 lần trên SQL Server
-- ===

IF NOT EXISTS (
    SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Shipper_Profiles') AND name = 'license_image_url'
)
ALTER TABLE Shipper_Profiles ADD license_image_url NVARCHAR(500) NULL; -- Ảnh chụp GPLX (URL Cloudinary)
GO

IF NOT EXISTS (
    SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Shipper_Profiles') AND name = 'verification_status'
)
ALTER TABLE Shipper_Profiles ADD verification_status NVARCHAR(20) NOT NULL DEFAULT 'PENDING';
GO

IF NOT EXISTS (
    SELECT * FROM sys.check_constraints WHERE name = 'CK_ShipperProfile_VerificationStatus'
)
ALTER TABLE Shipper_Profiles ADD CONSTRAINT CK_ShipperProfile_VerificationStatus
    CHECK (verification_status IN ('PENDING', 'APPROVED', 'REJECTED'));
GO

IF NOT EXISTS (
    SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Shipper_Profiles') AND name = 'rejection_reason'
)
ALTER TABLE Shipper_Profiles ADD rejection_reason NVARCHAR(500) NULL; -- Lý do khi SuperAdmin từ chối giấy tờ
GO

IF NOT EXISTS (
    SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Shipper_Profiles') AND name = 'verified_by'
)
ALTER TABLE Shipper_Profiles ADD verified_by BIGINT NULL; -- account_id SuperAdmin đã duyệt/từ chối
GO

IF NOT EXISTS (
    SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Shipper_Profiles') AND name = 'verified_at'
)
ALTER TABLE Shipper_Profiles ADD verified_at DATETIME2 NULL;
GO

IF NOT EXISTS (
    SELECT * FROM sys.foreign_keys WHERE name = 'FK_ShipperProfile_VerifiedBy'
)
ALTER TABLE Shipper_Profiles ADD CONSTRAINT FK_ShipperProfile_VerifiedBy
    FOREIGN KEY (verified_by) REFERENCES Accounts(id);
GO
