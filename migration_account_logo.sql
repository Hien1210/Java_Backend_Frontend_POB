-- Them cot logo_url cho Accounts: anh logo rieng cua tung SuperAdmin hien thi o sidebar,
-- tach biet hoan toan voi avatar_url (anh ca nhan hien o topbar).
-- Chay 1 lan duy nhat tren DB thuc te.
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('Accounts') AND name = 'logo_url')
    ALTER TABLE Accounts ADD logo_url NVARCHAR(MAX) NULL;
GO
