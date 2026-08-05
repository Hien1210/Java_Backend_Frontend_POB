package org.example.daos;

import org.example.models.ShipperWithdrawal;

import java.util.List;

public interface ShipperWithdrawalDAO {
    /** @param status "PENDING" | "APPROVED" | "REJECTED" | null (null = tất cả) */
    List<ShipperWithdrawal> getAllWithdrawals(String status);

    List<ShipperWithdrawal> getWithdrawalsByShipper(long shipperAccountId);

    boolean approveWithdrawal(long withdrawalId, long processedBy);

    boolean rejectWithdrawal(long withdrawalId, long processedBy, String reason);
}
