-- Bang tham so van hanh toan he thong (Sieu Admin cau hinh) - trang "Tham so van hanh"
-- Chi co dung 1 dong duy nhat (id = 1). Chay 1 lan duy nhat tren DB thuc te.
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'System_Configs')
BEGIN
    CREATE TABLE System_Configs (
        id INT PRIMARY KEY DEFAULT 1,
        commission_percent DECIMAL(5,2) NOT NULL DEFAULT 10,
        fixed_fee_per_order DECIMAL(10,2) NOT NULL DEFAULT 0,
        shipping_fee_first_2km DECIMAL(10,2) NOT NULL DEFAULT 15000,
        shipping_fee_per_km DECIMAL(10,2) NOT NULL DEFAULT 5000,
        max_delivery_radius_km DECIMAL(5,2) NOT NULL DEFAULT 10,
        shop_accept_order_minutes INT NOT NULL DEFAULT 15,
        auto_complete_order_hours INT NOT NULL DEFAULT 48,
        updated_at DATETIME2 NULL,
        CONSTRAINT CK_System_Configs_SingleRow CHECK (id = 1)
    );

    INSERT INTO System_Configs (id, commission_percent, fixed_fee_per_order, shipping_fee_first_2km,
        shipping_fee_per_km, max_delivery_radius_km, shop_accept_order_minutes, auto_complete_order_hours, updated_at)
    VALUES (1, 10, 0, 15000, 5000, 10, 15, 48, GETDATE());
END
GO
