-- Chạy 1 lần trên database POB đã có sẵn (không xóa dữ liệu cũ).
-- Phục vụ tính năng "Kiểm duyệt bình luận" (Super Admin):
--   1) Thêm cột status vào Feedbacks để đánh dấu bình luận VISIBLE / PENDING_REVIEW / REMOVED.
--   2) Tạo bảng BannedWords chứa danh sách từ ngữ nhạy cảm để FeedbackDAO.checkBadWords() quét.
USE POB;
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.columns
    WHERE object_id = OBJECT_ID('Feedbacks') AND name = 'status'
)
BEGIN
    ALTER TABLE Feedbacks ADD status NVARCHAR(20) NOT NULL CONSTRAINT DF_Feedbacks_status DEFAULT 'VISIBLE';
END
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.tables WHERE name = 'BannedWords'
)
BEGIN
    CREATE TABLE BannedWords (
        id INT IDENTITY(1,1) PRIMARY KEY,
        word NVARCHAR(100) NOT NULL,
        created_at DATETIME NOT NULL DEFAULT GETDATE()
    );

    INSERT INTO BannedWords (word) VALUES
        (N'lừa đảo'),
        (N'ngu'),
        (N'chửi'),
        (N'địt'),
        (N'đéo');
END
GO
