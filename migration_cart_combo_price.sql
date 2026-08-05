-- ===
-- Migration: Thêm combo_id + combo_unit_price cho Cart_Items.
-- Trước đây "Thêm Combo" chỉ chèn từng CartItem con của combo với giá size bình thường
-- (ProductSize.price) - hoàn toàn bỏ qua Combos.combo_price hiển thị trên menu, khiến khách
-- bị tính tiền theo giá lẻ từng món thay vì giá combo đã giảm. Thêm 2 cột để "khóa" giá đơn vị
-- quy đổi từ combo_price ngay lúc thêm vào giỏ, tái dùng cơ chế ProductSize.salePrice sẵn có
-- (giống Flash Sale) để checkout/giỏ hàng tự động dùng giá này mà không cần sửa logic tính tiền.
-- Chạy 1 lần trên SQL Server
-- ===

IF NOT EXISTS (
    SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Cart_Items') AND name = 'combo_id'
)
ALTER TABLE Cart_Items ADD combo_id BIGINT NULL;

IF NOT EXISTS (
    SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Cart_Items') AND name = 'combo_unit_price'
)
ALTER TABLE Cart_Items ADD combo_unit_price DECIMAL(12,2) NULL; -- Giá/đơn vị quy đổi từ Combos.combo_price, null = không thuộc combo

IF NOT EXISTS (
    SELECT * FROM sys.foreign_keys WHERE name = 'FK_CartItem_Combo'
)
ALTER TABLE Cart_Items ADD CONSTRAINT FK_CartItem_Combo FOREIGN KEY (combo_id) REFERENCES Combos(id) ON DELETE SET NULL;
