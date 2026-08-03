-- Them cot reviewed_at cho bang Feedbacks, dung de ghi nhan thoi diem Super Admin
-- phe duyet/xoa bo 1 binh luan dang PENDING_REVIEW -> phuc vu tab "Lich su xu ly"
-- o trang Kiem duyet binh luan. Chay 1 lan duy nhat tren DB thuc te.
IF NOT EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'Feedbacks' AND COLUMN_NAME = 'reviewed_at'
)
BEGIN
    ALTER TABLE Feedbacks ADD reviewed_at DATETIME2 NULL;
END
GO
