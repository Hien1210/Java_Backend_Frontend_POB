package org.example.models;

import java.time.LocalDateTime;

/**
 * Tham số vận hành toàn hệ thống - luôn chỉ có đúng 1 dòng (id = 1) trong bảng System_Configs.
 */
public class SystemConfig {
    private int id;
    private double commissionPercent;
    private double fixedFeePerOrder;
    private double shippingFeeFirst2Km;
    private double shippingFeePerKm;
    private double maxDeliveryRadiusKm;
    private int shopAcceptOrderMinutes;
    private int autoCompleteOrderHours;
    private LocalDateTime updatedAt;
    private String payosClientId;
    private String payosApiKey;
    private String payosChecksumKey;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public double getCommissionPercent() { return commissionPercent; }
    public void setCommissionPercent(double commissionPercent) { this.commissionPercent = commissionPercent; }

    public double getFixedFeePerOrder() { return fixedFeePerOrder; }
    public void setFixedFeePerOrder(double fixedFeePerOrder) { this.fixedFeePerOrder = fixedFeePerOrder; }

    public double getShippingFeeFirst2Km() { return shippingFeeFirst2Km; }
    public void setShippingFeeFirst2Km(double shippingFeeFirst2Km) { this.shippingFeeFirst2Km = shippingFeeFirst2Km; }

    public double getShippingFeePerKm() { return shippingFeePerKm; }
    public void setShippingFeePerKm(double shippingFeePerKm) { this.shippingFeePerKm = shippingFeePerKm; }

    public double getMaxDeliveryRadiusKm() { return maxDeliveryRadiusKm; }
    public void setMaxDeliveryRadiusKm(double maxDeliveryRadiusKm) { this.maxDeliveryRadiusKm = maxDeliveryRadiusKm; }

    public int getShopAcceptOrderMinutes() { return shopAcceptOrderMinutes; }
    public void setShopAcceptOrderMinutes(int shopAcceptOrderMinutes) { this.shopAcceptOrderMinutes = shopAcceptOrderMinutes; }

    public int getAutoCompleteOrderHours() { return autoCompleteOrderHours; }
    public void setAutoCompleteOrderHours(int autoCompleteOrderHours) { this.autoCompleteOrderHours = autoCompleteOrderHours; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }

    public String getPayosClientId() { return payosClientId; }
    public void setPayosClientId(String payosClientId) { this.payosClientId = payosClientId; }

    public String getPayosApiKey() { return payosApiKey; }
    public void setPayosApiKey(String payosApiKey) { this.payosApiKey = payosApiKey; }

    public String getPayosChecksumKey() { return payosChecksumKey; }
    public void setPayosChecksumKey(String payosChecksumKey) { this.payosChecksumKey = payosChecksumKey; }
}
