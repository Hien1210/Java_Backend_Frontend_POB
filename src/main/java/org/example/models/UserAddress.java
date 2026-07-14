package org.example.models;

import java.time.LocalDateTime;

public class UserAddress {
    private long id;
    private long userId;           // maps to DB column: user_id
    private String label;
    private String address;        // maps to DB column: address
    private String receiverName;
    private String receiverPhone;
    private boolean isDefault;
    private boolean isDeleted;
    private LocalDateTime createdAt;

    public UserAddress() {}

    public long getId() { return id; }
    public void setId(long id) { this.id = id; }

    public long getUserId() { return userId; }
    public void setUserId(long userId) { this.userId = userId; }

    // alias để không phải sửa Servlet cũ
    public long getAccountId() { return userId; }
    public void setAccountId(long accountId) { this.userId = accountId; }

    public String getLabel() { return label; }
    public void setLabel(String label) { this.label = label; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    // alias cho code cũ dùng fullAddress
    public String getFullAddress() { return address; }
    public void setFullAddress(String fullAddress) { this.address = fullAddress; }

    public String getReceiverName() { return receiverName; }
    public void setReceiverName(String receiverName) { this.receiverName = receiverName; }

    public String getReceiverPhone() { return receiverPhone; }
    public void setReceiverPhone(String receiverPhone) { this.receiverPhone = receiverPhone; }

    public boolean isDefault() { return isDefault; }
    public void setDefault(boolean aDefault) { isDefault = aDefault; }
    public boolean getIsDefault() { return isDefault; }

    public boolean isDeleted() { return isDeleted; }
    public void setDeleted(boolean deleted) { isDeleted = deleted; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
