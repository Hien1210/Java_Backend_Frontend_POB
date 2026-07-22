-- Migration: bảng lưu trạng thái đối soát/thanh toán doanh thu cho Shop theo từng kỳ (khoảng ngày) mà Super Admin đã xác nhận chi trả.
-- Mỗi dòng ứng với 1 lần Admin bấm "Xác nhận thanh toán" cho 1 Shop trong 1 khoảng [period_start, period_end] cụ thể.

CREATE TABLE Shop_Settlements (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    shop_id BIGINT NOT NULL,
    period_start DATE NOT NULL,
    period_end DATE NOT NULL,
    gross_revenue DECIMAL(14,2) NOT NULL,
    platform_fee DECIMAL(14,2) NOT NULL,
    net_payout DECIMAL(14,2) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'PENDING' CHECK (status IN ('PENDING', 'PAID')),
    confirmed_by BIGINT NULL,
    confirmed_at DATETIME2 NULL,
    created_at DATETIME2 NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME2 NOT NULL DEFAULT GETDATE(),
    CONSTRAINT UQ_ShopSettlement_Period UNIQUE (shop_id, period_start, period_end),
    CONSTRAINT FK_ShopSettlement_Shop FOREIGN KEY (shop_id) REFERENCES Shops(id),
    CONSTRAINT FK_ShopSettlement_Account FOREIGN KEY (confirmed_by) REFERENCES Accounts(id)
);

CREATE INDEX IDX_ShopSettlement_Shop ON Shop_Settlements(shop_id);
