-- =============================================
-- Migration: Feedbacks + bom_count cho User
-- =============================================

-- 1. Tạo bảng Feedbacks
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Feedbacks' AND xtype='U')
CREATE TABLE Feedbacks (
    id            BIGINT IDENTITY(1,1) PRIMARY KEY,
    order_id      BIGINT        NOT NULL,
    reviewer_type NVARCHAR(10)  NOT NULL CHECK (reviewer_type IN ('USER','SHIPPER')),
    reviewer_id   BIGINT        NOT NULL,   -- account_id của người đánh giá
    target_type   NVARCHAR(10)  NOT NULL CHECK (target_type IN ('SHOP','SHIPPER')),
    target_id     BIGINT        NOT NULL,   -- shop_id hoặc account_id shipper
    rating        INT           NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment       NVARCHAR(1000),
    is_anonymous  BIT           NOT NULL DEFAULT 0,
    created_at    DATETIME      NOT NULL DEFAULT GETDATE(),

    -- Mỗi order chỉ được feedback 1 lần với reviewer_type + target_type cụ thể
    CONSTRAINT UQ_Feedback_Once UNIQUE (order_id, reviewer_type, target_type)
);

-- 2. Thêm cột bom_count vào Accounts (đếm số lần user bom hàng)
IF NOT EXISTS (
    SELECT * FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'Accounts' AND COLUMN_NAME = 'bom_count'
)
    ALTER TABLE Accounts ADD bom_count INT NOT NULL DEFAULT 0;
