-- ===
-- Migration: Thêm thông tin ngân hàng riêng của từng Shop, dùng để dựng URL ảnh QR VietQR
-- động khi Bấm Bill chọn phương thức "QR" (khác hẳn PayOS — không cần API key, chỉ cần
-- 3 thông tin công khai: mã ngân hàng + số tài khoản + tên chủ tài khoản).
-- Chạy 1 lần trên SQL Server
-- ===

IF NOT EXISTS (
    SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Shops') AND name = 'bank_code'
)
ALTER TABLE Shops ADD bank_code NVARCHAR(20) NULL; -- Mã BIN ngân hàng theo chuẩn VietQR/NAPAS, vd '970436' = Vietcombank

IF NOT EXISTS (
    SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Shops') AND name = 'bank_account_number'
)
ALTER TABLE Shops ADD bank_account_number VARCHAR(50) NULL;

IF NOT EXISTS (
    SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Shops') AND name = 'bank_account_name'
)
ALTER TABLE Shops ADD bank_account_name NVARCHAR(255) NULL;
