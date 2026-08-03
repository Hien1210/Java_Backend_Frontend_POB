-- ===
-- Migration: Bảng Vouchers (mã giảm giá) + cột voucher_code/discount_amount trên Orders
-- Chạy 1 lần trên SQL Server
-- ===

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Vouchers')
BEGIN
    CREATE TABLE Vouchers (
        id              BIGINT        PRIMARY KEY IDENTITY(1,1),
        code            VARCHAR(50)   NOT NULL,
        voucher_type    VARCHAR(20)   NOT NULL CHECK (voucher_type IN ('PERCENT','FIXED','FREESHIP')),
        value           DECIMAL(12,2) NOT NULL DEFAULT 0,
        min_order_value DECIMAL(12,2) NOT NULL DEFAULT 0,
        max_discount    DECIMAL(12,2) NULL,
        usage_limit     INT           NULL,
        used_count      INT           NOT NULL DEFAULT 0,
        start_date      DATETIME2     NULL,
        end_date        DATETIME2     NULL,
        is_active       BIT           NOT NULL DEFAULT 1,
        created_at      DATETIME2     DEFAULT GETDATE(),
        CONSTRAINT UQ_Voucher_Code UNIQUE (code)
    );
END

IF NOT EXISTS (
    SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Orders') AND name = 'voucher_code'
)
ALTER TABLE Orders ADD voucher_code VARCHAR(50) NULL;

IF NOT EXISTS (
    SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Orders') AND name = 'discount_amount'
)
ALTER TABLE Orders ADD discount_amount DECIMAL(12,2) NOT NULL DEFAULT 0;
