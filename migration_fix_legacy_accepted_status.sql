-- =============================================================
-- migration_fix_legacy_accepted_status.sql
-- Cac don hang con dang status = 'ACCEPTED' la du lieu cu tu truoc khi
-- luong status duoc refactor (xem comment trong ShopBillServlet.java:115).
-- Code hien tai khong con noi nao set 'ACCEPTED' nua, va UI Quanlybill.jsp
-- khong co nhanh xu ly cho status nay nen shop khong co nut hanh dong nao
-- (khong the bam "Da chuan bi xong" hay "Huy"). Chuyen ve 'CONFIRMED' (cung
-- y nghia: shop da nhan don, dang chuan bi mon) de don quay lai dung luong.
-- Idempotent - chay lai nhieu lan khong sao (WHERE status = 'ACCEPTED' se
-- khong con match sau lan chay dau).
-- =============================================================
USE POB;
GO

UPDATE [Orders]
SET status = 'CONFIRMED'
WHERE status = 'ACCEPTED';

PRINT 'Migration complete: legacy ACCEPTED orders moved to CONFIRMED.';
GO
