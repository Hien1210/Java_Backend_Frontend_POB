-- Chạy 1 lần trên database POB đã có sẵn (không xóa dữ liệu cũ).
-- CHECK constraint cũ trên Products.status chỉ cho phép 'ACTIVE'/'OUT_OF_STOCK'/'HIDDEN',
-- chưa có 'PENDING_REVIEW' -> insert/update Product với status=PENDING_REVIEW bị lỗi
-- "The INSERT statement conflicted with the CHECK constraint".
-- Thêm 'PENDING_REVIEW' vào danh sách giá trị hợp lệ (giữ nguyên 3 giá trị cũ để không phá dữ liệu).
USE POB;
GO

IF EXISTS (
    SELECT 1 FROM sys.check_constraints
    WHERE name = 'CK__Products__status__43A1090D' AND parent_object_id = OBJECT_ID('Products')
)
BEGIN
    ALTER TABLE Products DROP CONSTRAINT CK__Products__status__43A1090D;
END
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.check_constraints
    WHERE name = 'CK_Products_Status' AND parent_object_id = OBJECT_ID('Products')
)
BEGIN
    ALTER TABLE Products ADD CONSTRAINT CK_Products_Status
        CHECK ([status] = 'ACTIVE' OR [status] = 'OUT_OF_STOCK' OR [status] = 'HIDDEN' OR [status] = 'PENDING_REVIEW');
END
GO
