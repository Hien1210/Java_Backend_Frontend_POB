-- Tao bang Complaints cho tinh nang khach hang khieu nai don hang
-- Chay 1 lan duy nhat tren DB thuc te
IF NOT EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_NAME = 'Complaints'
)
BEGIN
    CREATE TABLE Complaints (
        id         BIGINT        PRIMARY KEY IDENTITY(1,1),
        order_id   BIGINT        NOT NULL,
        account_id BIGINT        NOT NULL,          -- khach gui khieu nai (Orders.user_id)
        subject    NVARCHAR(255) NOT NULL,
        content    NVARCHAR(MAX) NOT NULL,
        status     VARCHAR(20)   NOT NULL DEFAULT 'PENDING'
                       CHECK (status IN ('PENDING', 'PROCESSING', 'RESOLVED', 'REJECTED')),
        admin_reply NVARCHAR(MAX) NULL,
        resolved_by BIGINT NULL,                    -- Accounts.id cua admin xu ly
        created_at DATETIME2     DEFAULT GETDATE(),
        updated_at DATETIME2     DEFAULT GETDATE(),
        CONSTRAINT FK_Complaint_Order   FOREIGN KEY (order_id)   REFERENCES Orders(id)   ON DELETE CASCADE,
        CONSTRAINT FK_Complaint_Account FOREIGN KEY (account_id) REFERENCES Accounts(id)
    );

    CREATE INDEX IDX_Complaint_Order   ON Complaints(order_id);
    CREATE INDEX IDX_Complaint_Account ON Complaints(account_id);
    CREATE INDEX IDX_Complaint_Status  ON Complaints(status);
END
GO
