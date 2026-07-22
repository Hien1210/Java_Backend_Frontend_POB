-- Tạo bảng Shipper_Wallets (số dư ví tài xế) và Shipper_Withdrawals (yêu cầu rút tiền)
-- Chạy 1 lần duy nhất trên DB thực tế
IF NOT EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Shipper_Wallets'
)
BEGIN
    CREATE TABLE Shipper_Wallets (
        id                 BIGINT        PRIMARY KEY IDENTITY(1,1),
        shipper_account_id BIGINT        NOT NULL UNIQUE,
        balance            DECIMAL(14,2) NOT NULL DEFAULT 0,
        updated_at         DATETIME2     NOT NULL DEFAULT GETDATE(),
        CONSTRAINT FK_ShipperWallet_Account FOREIGN KEY (shipper_account_id) REFERENCES Accounts(id)
    );
END
GO

IF NOT EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Shipper_Withdrawals'
)
BEGIN
    CREATE TABLE Shipper_Withdrawals (
        id                   BIGINT        PRIMARY KEY IDENTITY(1,1),
        shipper_account_id   BIGINT        NOT NULL,
        amount               DECIMAL(14,2) NOT NULL,
        bank_name            NVARCHAR(100) NOT NULL,
        bank_account_number  VARCHAR(30)   NOT NULL,
        bank_account_holder  NVARCHAR(100) NOT NULL,
        status               VARCHAR(20)   NOT NULL DEFAULT 'PENDING' CHECK (status IN ('PENDING', 'APPROVED', 'REJECTED')),
        reject_reason        NVARCHAR(255) NULL,
        requested_at         DATETIME2     NOT NULL DEFAULT GETDATE(),
        processed_at         DATETIME2     NULL,
        processed_by         BIGINT        NULL,
        CONSTRAINT FK_ShipperWithdrawal_Account FOREIGN KEY (shipper_account_id) REFERENCES Accounts(id),
        CONSTRAINT FK_ShipperWithdrawal_ProcessedBy FOREIGN KEY (processed_by) REFERENCES Accounts(id)
    );

    CREATE INDEX IDX_ShipperWithdrawal_Status ON Shipper_Withdrawals(status);
    CREATE INDEX IDX_ShipperWithdrawal_Shipper ON Shipper_Withdrawals(shipper_account_id);
END
GO
