-- ===
-- Migration: Tách ảnh CCCD/GPLX thành mặt trước + mặt sau (thay cho 1 ảnh duy nhất/loại giấy tờ)
-- Bắt buộc Shipper phải nộp đủ 4 ảnh (CCCD trước/sau, GPLX trước/sau) để SuperAdmin đối chiếu.
-- LƯU Ý: migration này XÓA 2 cột ảnh đơn cũ (id_card_image_url, license_image_url) —
-- dữ liệu ảnh cũ (nếu có) trong 2 cột này sẽ mất, Shipper cần upload lại theo đúng 2 mặt.
-- Chạy 1 lần trên SQL Server
-- ===

IF NOT EXISTS (
    SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Shipper_Profiles') AND name = 'id_card_front_url'
)
ALTER TABLE Shipper_Profiles ADD id_card_front_url NVARCHAR(500) NULL; -- Ảnh CCCD/CMND mặt trước (URL Cloudinary)
GO

IF NOT EXISTS (
    SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Shipper_Profiles') AND name = 'id_card_back_url'
)
ALTER TABLE Shipper_Profiles ADD id_card_back_url NVARCHAR(500) NULL; -- Ảnh CCCD/CMND mặt sau
GO

IF NOT EXISTS (
    SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Shipper_Profiles') AND name = 'license_front_url'
)
ALTER TABLE Shipper_Profiles ADD license_front_url NVARCHAR(500) NULL; -- Ảnh GPLX mặt trước
GO

IF NOT EXISTS (
    SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Shipper_Profiles') AND name = 'license_back_url'
)
ALTER TABLE Shipper_Profiles ADD license_back_url NVARCHAR(500) NULL; -- Ảnh GPLX mặt sau
GO

IF EXISTS (
    SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Shipper_Profiles') AND name = 'id_card_image_url'
)
ALTER TABLE Shipper_Profiles DROP COLUMN id_card_image_url;
GO

IF EXISTS (
    SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Shipper_Profiles') AND name = 'license_image_url'
)
ALTER TABLE Shipper_Profiles DROP COLUMN license_image_url;
GO
