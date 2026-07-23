package org.example.models;

import java.time.LocalDateTime;

public class ShipperWithdrawal {
    private long id;
    private long shipperAccountId;
    private String shipperName;
    private String shipperPhone;
    private double amount;
    private String bankName;
    private String bankAccountNumber;
    private String bankAccountHolder;
    private String status; // PENDING, APPROVED, REJECTED
    private String rejectReason;
    private LocalDateTime requestedAt;
    private LocalDateTime processedAt;

    public ShipperWithdrawal() {}

    public long getId() { return id; }
    public void setId(long id) { this.id = id; }

    public long getShipperAccountId() { return shipperAccountId; }
    public void setShipperAccountId(long shipperAccountId) { this.shipperAccountId = shipperAccountId; }

    public String getShipperName() { return shipperName; }
    public void setShipperName(String shipperName) { this.shipperName = shipperName; }

    public String getShipperPhone() { return shipperPhone; }
    public void setShipperPhone(String shipperPhone) { this.shipperPhone = shipperPhone; }

    public double getAmount() { return amount; }
    public void setAmount(double amount) { this.amount = amount; }

    public String getBankName() { return bankName; }
    public void setBankName(String bankName) { this.bankName = bankName; }

    public String getBankAccountNumber() { return bankAccountNumber; }
    public void setBankAccountNumber(String bankAccountNumber) { this.bankAccountNumber = bankAccountNumber; }

    public String getBankAccountHolder() { return bankAccountHolder; }
    public void setBankAccountHolder(String bankAccountHolder) { this.bankAccountHolder = bankAccountHolder; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getRejectReason() { return rejectReason; }
    public void setRejectReason(String rejectReason) { this.rejectReason = rejectReason; }

    public LocalDateTime getRequestedAt() { return requestedAt; }
    public void setRequestedAt(LocalDateTime requestedAt) { this.requestedAt = requestedAt; }

    public LocalDateTime getProcessedAt() { return processedAt; }
    public void setProcessedAt(LocalDateTime processedAt) { this.processedAt = processedAt; }
}
