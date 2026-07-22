package org.example.daos;

import org.example.models.Complaint;

import java.util.List;

public interface ComplaintDAO {
    boolean create(Complaint complaint);
    List<Complaint> findByAccountId(long accountId);
    List<Complaint> findAll();
    List<Complaint> findByStatus(String status);
    Complaint findById(long id);
    boolean existsByOrderId(long orderId);
    boolean resolve(long id, String status, String adminReply, long resolvedBy);
}
