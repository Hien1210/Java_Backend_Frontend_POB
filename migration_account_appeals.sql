-- Bảng kháng nghị tài khoản bị đình chỉ
IF NOT EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Account_Appeals'
)
BEGIN
    CREATE TABLE Account_Appeals (
        id          BIGINT IDENTITY(1,1) PRIMARY KEY,
        account_id  BIGINT NOT NULL,
        message     NVARCHAR(1000) NOT NULL,
        status      NVARCHAR(20) NOT NULL DEFAULT 'PENDING', -- PENDING | APPROVED | REJECTED
        admin_note  NVARCHAR(500) NULL,
        created_at  DATETIME DEFAULT GETDATE(),
        reviewed_at DATETIME NULL,
        FOREIGN KEY (account_id) REFERENCES Accounts(id)
    );
END
