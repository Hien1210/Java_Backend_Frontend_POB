-- Tạo bảng Shipper_Profiles lưu thông tin phương tiện của tài xế
-- Chạy 1 lần duy nhất trên DB thực tế
IF NOT EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_NAME = 'Shipper_Profiles'
)
BEGIN
    CREATE TABLE Shipper_Profiles (
        id             BIGINT        PRIMARY KEY IDENTITY(1,1),
        account_id     BIGINT        NOT NULL UNIQUE,
        cccd           VARCHAR(20)   NULL,   -- Số CCCD/CMND
        license_number VARCHAR(20)   NULL,   -- Số bằng lái xe
        vehicle_type   NVARCHAR(50)  NULL,   -- 'Xe máy', 'Ô tô', 'Xe đạp điện'
        vehicle_plate  VARCHAR(20)   NULL,   -- Biển số xe
        vehicle_model  NVARCHAR(100) NULL,   -- Nhãn hiệu / model xe
        bank_account   VARCHAR(30)   NULL,   -- Số tài khoản ngân hàng
        bank_name      NVARCHAR(100) NULL,   -- Tên ngân hàng
        created_at     DATETIME2     DEFAULT GETDATE(),
        updated_at     DATETIME2     DEFAULT GETDATE(),
        CONSTRAINT FK_ShipperProfile_Account FOREIGN KEY (account_id) REFERENCES Accounts(id)
    );

    CREATE TRIGGER TR_ShipperProfiles_UpdatedAt ON Shipper_Profiles AFTER UPDATE AS
    BEGIN
        SET NOCOUNT ON;
        UPDATE Shipper_Profiles SET updated_at = GETDATE()
        WHERE id IN (SELECT id FROM inserted);
    END;
END
ELSE
BEGIN
    -- Thêm cột còn thiếu nếu bảng đã tồn tại nhưng chưa có các cột mới
    IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Shipper_Profiles' AND COLUMN_NAME = 'cccd')
        ALTER TABLE Shipper_Profiles ADD cccd VARCHAR(20) NULL;

    IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Shipper_Profiles' AND COLUMN_NAME = 'license_number')
        ALTER TABLE Shipper_Profiles ADD license_number VARCHAR(20) NULL;

    IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Shipper_Profiles' AND COLUMN_NAME = 'bank_account')
        ALTER TABLE Shipper_Profiles ADD bank_account VARCHAR(30) NULL;

    IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Shipper_Profiles' AND COLUMN_NAME = 'bank_name')
        ALTER TABLE Shipper_Profiles ADD bank_name NVARCHAR(100) NULL;
END
GO
