package org.example.models;

import java.time.LocalDateTime;

public class RefundRequest {
    private long id;
    private long orderId;
    private long accountId;
    private double amount;
    private String bankName;
    private String bankAccountNumber;
    private String bankAccountHolder;
    private String note;
    private String status; // PENDING, COMPLETED, REJECTED
    private String rejectReason;
    private LocalDateTime requestedAt;
    private LocalDateTime processedAt;
    private Long processedBy;

    // Join fields
    private String accountName;
    private String accountEmail;
    private String processedByName;

    public long getId() { return id; }
    public void setId(long id) { this.id = id; }
    public long getOrderId() { return orderId; }
    public void setOrderId(long orderId) { this.orderId = orderId; }
    public long getAccountId() { return accountId; }
    public void setAccountId(long accountId) { this.accountId = accountId; }
    public double getAmount() { return amount; }
    public void setAmount(double amount) { this.amount = amount; }
    public String getBankName() { return bankName; }
    public void setBankName(String bankName) { this.bankName = bankName; }
    public String getBankAccountNumber() { return bankAccountNumber; }
    public void setBankAccountNumber(String n) { this.bankAccountNumber = n; }
    public String getBankAccountHolder() { return bankAccountHolder; }
    public void setBankAccountHolder(String h) { this.bankAccountHolder = h; }
    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getRejectReason() { return rejectReason; }
    public void setRejectReason(String r) { this.rejectReason = r; }
    public LocalDateTime getRequestedAt() { return requestedAt; }
    public void setRequestedAt(LocalDateTime t) { this.requestedAt = t; }
    public LocalDateTime getProcessedAt() { return processedAt; }
    public void setProcessedAt(LocalDateTime t) { this.processedAt = t; }
    public Long getProcessedBy() { return processedBy; }
    public void setProcessedBy(Long processedBy) { this.processedBy = processedBy; }
    public String getAccountName() { return accountName; }
    public void setAccountName(String n) { this.accountName = n; }
    public String getAccountEmail() { return accountEmail; }
    public void setAccountEmail(String e) { this.accountEmail = e; }
    public String getProcessedByName() { return processedByName; }
    public void setProcessedByName(String n) { this.processedByName = n; }
}
