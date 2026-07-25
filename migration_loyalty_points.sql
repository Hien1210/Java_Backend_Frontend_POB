-- ===
-- Migration: Thêm cột loyalty_points vào Accounts (tích điểm theo giá trị đơn hàng thành công)
-- Chạy 1 lần trên SQL Server
-- ===

IF NOT EXISTS (
    SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Accounts') AND name = 'loyalty_points'
)
ALTER TABLE Accounts ADD loyalty_points INT NOT NULL DEFAULT 0;
