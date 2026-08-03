-- =============================================================
-- migration_orders_status_constraint.sql
-- Drop CHECK constraint cũ trên Orders.status (auto-named bởi SQL Server,
-- ví dụ CK_Orders_status_79FD...) và tạo lại constraint mới cho phép
-- TẤT CẢ status values mà application sử dụng.
-- Idempotent — chạy lại nhiều lần không sao.
-- =============================================================
USE POB;
GO

-- Bước 1: Tìm và drop TẤT CẢ CHECK constraints trên cột [status] của bảng [Orders]
-- (SQL Server có thể tự sinh tên constraint với suffix random, vd CK_Orders_status_79FD...)
DECLARE @constraintName NVARCHAR(256);
DECLARE @sql NVARCHAR(MAX);

DECLARE cur CURSOR LOCAL FAST_FORWARD FOR
    SELECT cc.name
    FROM sys.check_constraints cc
    INNER JOIN sys.columns c
        ON cc.parent_object_id = c.object_id
        AND cc.parent_column_id = c.column_id
    WHERE cc.parent_object_id = OBJECT_ID('Orders')
      AND c.name = 'status';

OPEN cur;
FETCH NEXT FROM cur INTO @constraintName;

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @sql = 'ALTER TABLE [Orders] DROP CONSTRAINT [' + @constraintName + ']';
    PRINT 'Dropping constraint: ' + @constraintName;
    EXEC sp_executesql @sql;
    FETCH NEXT FROM cur INTO @constraintName;
END

CLOSE cur;
DEALLOCATE cur;
GO

-- Bước 2: Tạo constraint mới cho phép tất cả status values mà app sử dụng
IF NOT EXISTS (
    SELECT 1 FROM sys.check_constraints
    WHERE name = 'CK_Orders_Status' AND parent_object_id = OBJECT_ID('Orders')
)
ALTER TABLE [Orders] ADD CONSTRAINT CK_Orders_Status
    CHECK ([status] IN (
        'PENDING',
        'CONFIRMED',
        'READY_FOR_PICKUP',
        'WAITING_FOR_SHIPPER',
        'ACCEPTED',
        'SHIPPING',
        'DONE',
        'CANCELLED'
    ));
GO

PRINT 'Migration complete: Orders.status CHECK constraint updated successfully.';
GO
