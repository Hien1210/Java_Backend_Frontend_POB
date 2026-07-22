-- Gan 1 Loai Topping voi 1 Loai San Pham cu the (vd: "Topping tra sua" chi ap dung cho loai
-- san pham "Tra sua"), tranh tinh trang lan topping khong lien quan (vd nuoc mam cho tra sua).
-- Cho phep NULL = ap dung cho MOI loai san pham (tuong thich nguoc voi du lieu cu da co).
-- Chay 1 lan duy nhat tren DB thuc te.
IF NOT EXISTS (
    SELECT 1 FROM sys.columns
    WHERE object_id = OBJECT_ID('ToppingCategories') AND name = 'category_id'
)
BEGIN
    ALTER TABLE ToppingCategories ADD category_id BIGINT NULL;
    ALTER TABLE ToppingCategories ADD CONSTRAINT FK_ToppingCategory_Category
        FOREIGN KEY (category_id) REFERENCES Categories(id);
    CREATE INDEX IDX_ToppingCategory_Category ON ToppingCategories(category_id);
END
GO
