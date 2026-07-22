package org.example.daos;

import org.example.models.ShipperWithdrawal;

import java.util.List;

public interface ShipperWithdrawalDAO {
    /**
     * @param status "PENDING" | "APPROVED" | "REJECTED" | null (null = tất cả)
     */
    List<ShipperWithdrawal> getAllWithdrawals(String status);

    boolean approveWithdrawal(long withdrawalId, long processedBy);

    /**
     * Từ chối yêu cầu rút tiền và hoàn lại số tiền vào ví Shipper trong cùng 1 transaction.
     */
    boolean rejectWithdrawal(long withdrawalId, long processedBy, String reason);
}
