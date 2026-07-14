-- =============================================
-- Migration: Tạo bảng User_Profiles
-- Chạy 1 lần trên SQL Server
-- =============================================

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='User_Profiles' AND xtype='U')
CREATE TABLE User_Profiles (
    id                  BIGINT IDENTITY(1,1) PRIMARY KEY,
    account_id          BIGINT NOT NULL UNIQUE,   -- FK → Accounts.id
    date_of_birth       DATE,
    gender              NVARCHAR(10) CHECK (gender IN ('MALE','FEMALE','OTHER')),
    default_address_id  BIGINT,                   -- FK → User_Addresses.id (nullable)
    created_at          DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at          DATETIME NOT NULL DEFAULT GETDATE(),

    CONSTRAINT FK_UserProfiles_Account  FOREIGN KEY (account_id)         REFERENCES Accounts(id),
    CONSTRAINT FK_UserProfiles_Address  FOREIGN KEY (default_address_id) REFERENCES User_Addresses(id)
);
