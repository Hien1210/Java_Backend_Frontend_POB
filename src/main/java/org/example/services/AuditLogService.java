package org.example.services;

import jakarta.servlet.http.HttpServletRequest;
import org.example.daos.AuditLogDAO;
import org.example.daos.AuditLogDAOImpl;
import org.example.models.Account;
import org.example.utils.RateLimitUtil;

/**
 * Facade mong bao ngoai AuditLogDAO: cac servlet nghiep vu chi can goi 1 ham
 * log(...) o day, khong can tu lay ipAddress/userAgent/accountId/roleId
 * hay biet gi ve cach du lieu duoc luu xuong DB.
 *
 * Day la noi duy nhat nen sua khi sau nay can mo rong (ghi them file log,
 * gui Kafka, gui ElasticSearch,...) - AuditLogDAO va cac servlet da tich hop
 * khong can dong lai.
 */
public class AuditLogService {

    private final AuditLogDAO auditLogDAO = new AuditLogDAOImpl();

    /**
     * Ghi 1 dong nhat ky he thong gan voi 1 request cu the (truong hop pho bien nhat:
     * Super Admin/Shop Owner thao tac qua 1 servlet).
     *
     * @param req         request hien tai, dung de tu dong lay ipAddress + userAgent
     * @param actor       tai khoan thuc hien hanh dong; truyen null neu la hanh dong tu dong cua he thong
     * @param action      ten hanh dong, vd "Duyet Shop"
     * @param module      ten module, vd "Shop", "Account", "Comment"
     * @param description mo ta chi tiet, vd "Admin Hien123 da duyet shop Pizza ABC"
     * @param targetId    id cua doi tuong bi tac dong (shop id, account id,...), co the null
     * @param targetType  loai doi tuong bi tac dong, vd "Shop", "Account", co the null
     */
    public void log(HttpServletRequest req, Account actor, String action, String module,
                     String description, Long targetId, String targetType) {
        Long accountId = actor != null ? actor.getId() : null;
        Long roleId = actor != null ? actor.getRoleId() : null;
        String ipAddress = req != null ? RateLimitUtil.getClientIp(req) : null;
        String userAgent = req != null ? req.getHeader("User-Agent") : null;

        auditLogDAO.log(accountId, roleId, action, module, description, targetId, targetType, ipAddress, userAgent);
    }

    /**
     * Ghi log khi khong co HttpServletRequest (vd job chay ngam, tac vu he thong tu dong)
     * nen khong the/khong can lay ipAddress, userAgent.
     */
    public void log(Account actor, String action, String module, String description,
                     Long targetId, String targetType) {
        log(null, actor, action, module, description, targetId, targetType);
    }
}
