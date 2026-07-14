-- Thêm cột lý do đình chỉ tài khoản (dùng cho soft delete)
IF NOT EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'Accounts' AND COLUMN_NAME = 'suspend_reason'
)
BEGIN
    ALTER TABLE Accounts ADD suspend_reason NVARCHAR(500) NULL;
END
