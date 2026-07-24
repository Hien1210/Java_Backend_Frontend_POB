-- Bang nhat ky he thong (Audit Log) - chi Super Admin xem
-- Ghi lai moi hanh dong quan trong: duyet/tu choi Shop, khoa/mo tai khoan,
-- xoa/khoi phuc san pham, duyet/tu choi binh luan, duyet rut tien, doi soat
-- doanh thu, thay doi tham so he thong...
-- Chay 1 lan duy nhat tren DB thuc te.
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'AuditLogs')
BEGIN
    CREATE TABLE AuditLogs (
        id          BIGINT        PRIMARY KEY IDENTITY(1,1),
        account_id  BIGINT        NULL,
        role_id     BIGINT        NULL,
        action      NVARCHAR(200) NOT NULL,
        module      NVARCHAR(100) NOT NULL,
        description NVARCHAR(MAX) NOT NULL,
        target_id   BIGINT        NULL,
        target_type NVARCHAR(100) NULL,
        ip_address  VARCHAR(50)   NULL,
        user_agent  NVARCHAR(500) NULL,
        created_at  DATETIME2     NOT NULL DEFAULT GETDATE(),
        CONSTRAINT FK_AuditLogs_Account FOREIGN KEY (account_id) REFERENCES Accounts(id)
    );

    CREATE INDEX IDX_AuditLogs_Account   ON AuditLogs(account_id);
    CREATE INDEX IDX_AuditLogs_Module    ON AuditLogs(module);
    CREATE INDEX IDX_AuditLogs_CreatedAt ON AuditLogs(created_at DESC);
END
GO
