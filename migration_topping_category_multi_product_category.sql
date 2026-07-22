-- Nang cap "Loai Topping ap dung cho Loai San Pham" tu 1-1 (cot category_id) sang NHIEU-NHIEU
-- (1 loai topping co the ap dung cho nhieu loai san pham cung luc, vd "Topping tra sua" +
-- "Topping ca phe"). Thay the cho migration_topping_category_product_category.sql truoc do.
-- Chay 1 lan duy nhat tren DB thuc te.

-- 1. Bang trung gian nhieu-nhieu
IF NOT EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_NAME = 'ToppingCategory_ProductCategories'
)
BEGIN
    CREATE TABLE ToppingCategory_ProductCategories (
        topping_category_id BIGINT NOT NULL,
        category_id          BIGINT NOT NULL,
        PRIMARY KEY (topping_category_id, category_id),
        CONSTRAINT FK_TCPC_ToppingCategory FOREIGN KEY (topping_category_id) REFERENCES ToppingCategories(id) ON DELETE CASCADE,
        CONSTRAINT FK_TCPC_Category        FOREIGN KEY (category_id)         REFERENCES Categories(id)
    );
END
GO

-- 2. Chuyen du lieu cu (neu ToppingCategories.category_id da ton tai va co gia tri) sang bang moi
IF EXISTS (
    SELECT 1 FROM sys.columns
    WHERE object_id = OBJECT_ID('ToppingCategories') AND name = 'category_id'
)
BEGIN
    INSERT INTO ToppingCategory_ProductCategories (topping_category_id, category_id)
    SELECT id, category_id FROM ToppingCategories
    WHERE category_id IS NOT NULL
      AND NOT EXISTS (
          SELECT 1 FROM ToppingCategory_ProductCategories tcpc
          WHERE tcpc.topping_category_id = ToppingCategories.id AND tcpc.category_id = ToppingCategories.category_id
      );

    -- 3. Bo cot cu (khong con dung, da thay bang bang trung gian)
    DECLARE @fkName NVARCHAR(200);
    SELECT @fkName = name FROM sys.foreign_keys
    WHERE parent_object_id = OBJECT_ID('ToppingCategories')
      AND referenced_object_id = OBJECT_ID('Categories');
    IF @fkName IS NOT NULL
        EXEC('ALTER TABLE ToppingCategories DROP CONSTRAINT ' + @fkName);

    IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IDX_ToppingCategory_Category' AND object_id = OBJECT_ID('ToppingCategories'))
        DROP INDEX IDX_ToppingCategory_Category ON ToppingCategories;

    ALTER TABLE ToppingCategories DROP COLUMN category_id;
END
GO
