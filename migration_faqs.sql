-- Bang FAQ/Huong dan (Super Admin quan tri, hien thi cong khai cho User/Shop/Shipper)
-- Chay 1 lan duy nhat tren DB thuc te.
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'FAQs')
BEGIN
    CREATE TABLE FAQs (
        id             BIGINT        PRIMARY KEY IDENTITY(1,1),
        question       NVARCHAR(500) NOT NULL,
        answer         NVARCHAR(MAX) NOT NULL,
        category       NVARCHAR(100) NULL,
        display_order  INT           NOT NULL DEFAULT 0,
        is_active      BIT           NOT NULL DEFAULT 1,
        is_deleted     BIT           NOT NULL DEFAULT 0,
        created_by     BIGINT        NOT NULL,
        updated_by     BIGINT        NULL,
        created_at     DATETIME2     NOT NULL DEFAULT GETDATE(),
        updated_at     DATETIME2     NOT NULL DEFAULT GETDATE(),

        CONSTRAINT FK_FAQs_CreatedBy FOREIGN KEY (created_by) REFERENCES Accounts(id),
        CONSTRAINT FK_FAQs_UpdatedBy FOREIGN KEY (updated_by) REFERENCES Accounts(id) ON DELETE SET NULL
    );

    -- Truy van cong khai chinh: WHERE is_deleted=0 AND is_active=1 ORDER BY category, display_order
    CREATE INDEX IDX_FAQs_Public ON FAQs(is_deleted, is_active, category, display_order);

    -- Loc theo nhom rieng (trang quan tri, filter theo category)
    CREATE INDEX IDX_FAQs_Category ON FAQs(category);
END
GO

-- Tu dong cap nhat updated_at, dung pattern giong TR_Accounts_UpdatedAt / TR_UserProfiles_UpdatedAt
IF NOT EXISTS (SELECT 1 FROM sys.triggers WHERE name = 'TR_FAQs_UpdatedAt')
BEGIN
    EXEC('
    CREATE TRIGGER TR_FAQs_UpdatedAt ON FAQs AFTER UPDATE AS
    BEGIN
        SET NOCOUNT ON;
        IF NOT EXISTS (SELECT 1 FROM inserted i JOIN deleted d ON i.id = d.id WHERE i.updated_at = d.updated_at) RETURN;
        UPDATE FAQs SET updated_at = GETDATE() WHERE id IN (SELECT id FROM inserted);
    END
    ')
END
GO
