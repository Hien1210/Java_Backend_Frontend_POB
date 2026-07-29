package org.example.daos;

import org.example.models.RefundRequest;
import java.util.List;

public interface RefundRequestDAO {
    boolean create(RefundRequest request);
    RefundRequest findByOrderId(long orderId);
    RefundRequest findById(long id);
    List<RefundRequest> findByAccountId(long accountId);
    List<RefundRequest> findAll(String status, int limit, int offset);
    int countAll(String status);
    boolean complete(long id, long adminId);
    boolean reject(long id, long adminId, String reason);
}
