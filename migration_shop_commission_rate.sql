-- ===
-- Migration: Thêm cột commission_rate vào Shops (hoa hồng riêng theo từng Shop, ghi đè lên
-- tỷ lệ mặc định toàn hệ thống trong System_Configs.commission_percent nếu Super Admin có cấu hình)
-- Chạy 1 lần trên SQL Server
-- ===

IF NOT EXISTS (
    SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Shops') AND name = 'commission_rate'
)
ALTER TABLE Shops ADD commission_rate DECIMAL(5,2) NULL;
