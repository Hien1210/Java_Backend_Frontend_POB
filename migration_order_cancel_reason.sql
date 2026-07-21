-- Chạy 1 lần trên database POB đã có sẵn (không xóa dữ liệu cũ).
-- Bổ sung cột cancel_reason vào Orders để lưu lý do hủy đơn, phục vụ biểu đồ
-- "Thống kê lý do hủy đơn" (GROUP BY) trong trang Báo cáo vận hành (Super Admin).
USE POB;
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.columns
    WHERE object_id = OBJECT_ID('Orders') AND name = 'cancel_reason'
)
BEGIN
    ALTER TABLE Orders ADD cancel_reason NVARCHAR(255) NULL;
END
GO
