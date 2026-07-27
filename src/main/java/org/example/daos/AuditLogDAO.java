package org.example.daos;

import org.example.models.AuditLog;

import java.time.LocalDate;
import java.util.List;

public interface AuditLogDAO {

    /**
     * Ghi 1 dong nhat ky he thong. Khong throw exception ra ngoai — servlet goi
     * xong nghiep vu chinh khong nen bi fail chi vi ghi audit log loi.
     */
    void log(Long accountId, Long roleId, String action, String module, String description,
              Long targetId, String targetType, String ipAddress, String userAgent);

    /**
     * Tim kiem + phan trang, luon sap moi nhat truoc (created_at DESC).
     * Cac tham so filter truyen null/rong = khong loc theo dieu kien do.
     */
    List<AuditLog> search(Long accountId, String module, String action,
                           LocalDate fromDate, LocalDate toDate,
                           int page, int pageSize);

    /**
     * Dem tong so dong khop voi cung bo dieu kien filter o tren, dung de tinh so trang.
     */
    int count(Long accountId, String module, String action,
              LocalDate fromDate, LocalDate toDate);

    /**
     * Danh sach module dang co trong bang, dung de do combobox filter tren JSP.
     */
    List<String> findDistinctModules();
}
