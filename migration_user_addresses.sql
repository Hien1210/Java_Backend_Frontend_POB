-- =============================================
-- Migration: Tạo bảng User_Addresses
-- Chạy 1 lần trên SQL Server
-- =============================================

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='User_Addresses' AND xtype='U')
CREATE TABLE User_Addresses (
    id             BIGINT IDENTITY(1,1) PRIMARY KEY,
    account_id     BIGINT        NOT NULL,
    label          NVARCHAR(50)  NOT NULL DEFAULT N'Nhà',   -- 'Nhà', 'Công ty', 'Trường học', 'Khác'
    full_address   NVARCHAR(500) NOT NULL,
    receiver_name  NVARCHAR(100) NOT NULL,
    receiver_phone VARCHAR(15)   NOT NULL,
    is_default     BIT           NOT NULL DEFAULT 0,
    created_at     DATETIME      NOT NULL DEFAULT GETDATE(),

    CONSTRAINT FK_UserAddresses_Account FOREIGN KEY (account_id) REFERENCES Accounts(id)
);
