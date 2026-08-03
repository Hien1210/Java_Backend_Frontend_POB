-- ===
-- Migration: Thêm cột is_out_of_stock vào Product_Sizes
-- (cho phép Shop bật/tắt nhanh trạng thái "Hết hàng tạm thời" theo từng size,
-- không cần xóa sản phẩm/size)
-- Chạy 1 lần trên SQL Server
-- ===

IF NOT EXISTS (
    SELECT * FROM sys.columns
    WHERE object_id = OBJECT_ID('Product_Sizes') AND name = 'is_out_of_stock'
)
ALTER TABLE Product_Sizes ADD is_out_of_stock BIT NOT NULL DEFAULT 0;
