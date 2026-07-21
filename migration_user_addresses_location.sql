-- =============================================
-- Migration: Thêm cột locationX/locationY vào User_Addresses
-- (tọa độ GPS của địa chỉ giao hàng, dùng cho tính năng
-- theo dõi shipper realtime và chọn vị trí trên bản đồ)
-- Chạy 1 lần trên SQL Server
-- =============================================

IF NOT EXISTS (
    SELECT * FROM sys.columns
    WHERE object_id = OBJECT_ID('User_Addresses') AND name = 'locationX'
)
ALTER TABLE User_Addresses ADD locationX FLOAT NULL;

IF NOT EXISTS (
    SELECT * FROM sys.columns
    WHERE object_id = OBJECT_ID('User_Addresses') AND name = 'locationY'
)
ALTER TABLE User_Addresses ADD locationY FLOAT NULL;
