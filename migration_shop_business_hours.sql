-- ===
-- Migration: Thêm cột open_time/close_time vào Shops
-- (giờ mở/đóng cửa hàng ngày, dùng để tự động chặn khách đặt hàng
-- ngoài giờ hoạt động)
-- Chạy 1 lần trên SQL Server
-- ===

IF NOT EXISTS (
    SELECT * FROM sys.columns
    WHERE object_id = OBJECT_ID('Shops') AND name = 'open_time'
)
ALTER TABLE Shops ADD open_time TIME NULL;

IF NOT EXISTS (
    SELECT * FROM sys.columns
    WHERE object_id = OBJECT_ID('Shops') AND name = 'close_time'
)
ALTER TABLE Shops ADD close_time TIME NULL;
