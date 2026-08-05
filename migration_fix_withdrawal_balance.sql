-- Fix: Hoàn lại số dư bị trừ nhầm cho các yêu cầu rút tiền đang PENDING
-- (logic cũ trừ tiền ngay khi tạo yêu cầu, logic mới chỉ trừ khi admin duyệt)
-- Chạy 1 lần trước khi restart Tomcat với code mới.

UPDATE sw
SET sw.balance = sw.balance + pending.total,
    sw.updated_at = GETDATE()
FROM Shop_Wallets sw
JOIN (
    SELECT shop_id, SUM(amount) AS total
    FROM Shop_Withdrawals
    WHERE status = 'PENDING'
    GROUP BY shop_id
) pending ON pending.shop_id = sw.shop_id;
