package org.example.utils;

/**
 * Hang so ten module dung cho AuditLogService.log(..., module, ...) va AuditLog.targetType.
 * Muc dich: tranh cac servlet tu go tay String ("Shop", "shop", "Shop "...) gay sai lech
 * khi filter/search trong AuditLogServlet (so khop chinh xac al.module = ?).
 *
 * Khong dung enum: gia tri van la String de khong doi kieu tham so o AuditLogService/AuditLogDAO.
 */
public final class AuditModules {

    public static final String SHOP = "Shop";
    public static final String ACCOUNT = "Account";
    public static final String COMMENT = "Comment";
    public static final String COMPLAINT = "Complaint";
    public static final String SETTLEMENT = "Settlement";
    public static final String SYSTEM = "System";

    private AuditModules() {
    }
}
