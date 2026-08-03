-- ===
-- Migration: Bảng Combos (combo sản phẩm của shop) + Combo_Items
-- Chạy 1 lần trên SQL Server
-- ===

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Combos')
BEGIN
    CREATE TABLE Combos (
        id          BIGINT        PRIMARY KEY IDENTITY(1,1),
        shop_id     BIGINT        NOT NULL,
        name        NVARCHAR(200) NOT NULL,
        description NVARCHAR(500) NULL,
        combo_price DECIMAL(12,2) NOT NULL,
        is_active   BIT           NOT NULL DEFAULT 1,
        created_at  DATETIME2     DEFAULT GETDATE(),
        updated_at  DATETIME2     DEFAULT GETDATE(),
        CONSTRAINT FK_Combos_Shop FOREIGN KEY (shop_id) REFERENCES Shops(id)
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Combo_Items')
BEGIN
    CREATE TABLE Combo_Items (
        id              BIGINT PRIMARY KEY IDENTITY(1,1),
        combo_id        BIGINT NOT NULL,
        product_id      BIGINT NOT NULL,
        product_size_id BIGINT NOT NULL,
        quantity        INT    NOT NULL DEFAULT 1,
        CONSTRAINT FK_ComboItems_Combo FOREIGN KEY (combo_id) REFERENCES Combos(id),
        CONSTRAINT FK_ComboItems_Product FOREIGN KEY (product_id) REFERENCES Products(id),
        CONSTRAINT FK_ComboItems_ProductSize FOREIGN KEY (product_size_id) REFERENCES Product_Sizes(id)
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IDX_Combos_Shop' AND object_id = OBJECT_ID('Combos'))
    CREATE INDEX IDX_Combos_Shop ON Combos(shop_id);
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IDX_ComboItems_Combo' AND object_id = OBJECT_ID('Combo_Items'))
    CREATE INDEX IDX_ComboItems_Combo ON Combo_Items(combo_id);
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IDX_ComboItems_Product' AND object_id = OBJECT_ID('Combo_Items'))
    CREATE INDEX IDX_ComboItems_Product ON Combo_Items(product_id);
GO
