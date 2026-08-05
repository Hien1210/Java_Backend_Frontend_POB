-- ===
-- Migration: Thêm cột bank_account_holder (tên chủ tài khoản) cho Shipper_Profiles.
-- Trước đây form "Hồ sơ tài xế" chỉ có bank_account (số TK) + bank_name (tên ngân hàng),
-- không có tên chủ tài khoản riêng - khi hiển thị ở Ví tiền phải suy ra tạm từ
-- Accounts.full_name, gây hiểu lầm vì Shipper chưa từng tự nhập/xác nhận tên này.
-- Chạy 1 lần trên SQL Server
-- ===

IF NOT EXISTS (
    SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Shipper_Profiles') AND name = 'bank_account_holder'
)
ALTER TABLE Shipper_Profiles ADD bank_account_holder NVARCHAR(100) NULL; -- Tên chủ tài khoản ngân hàng (nhập tay, không tự suy ra từ full_name)
