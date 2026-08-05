package org.example.models;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class Voucher {
    private long id;
    private String code;
    private String voucherType; // PERCENT | FIXED | FREESHIP
    private double value;
    private double minOrderValue;
    private Double maxDiscount; // chi ap dung cho PERCENT, null = khong gioi han
    private Integer usageLimit; // null = khong gioi han so lan dung
    private int usedCount;
    private LocalDateTime startDate; // null = khong gioi han ngay bat dau
    private LocalDateTime endDate;   // null = khong gioi han ngay ket thuc
    private boolean active;
    private LocalDateTime createdAt;

    public Voucher() {
    }

    /**
     * Kiem tra voucher co dung duoc ngay bay gio cho 1 don hang gia tri subtotal hay khong
     * (chua tinh so lan da dung, tach rieng vi can so sanh voi usageLimit o tang DAO/transaction
     * de tranh race condition dua vao gia tri usedCount cu).
     */
    public String validateBasic(double subtotal) {
        if (!active) return "Mã giảm giá không còn hiệu lực";
        LocalDateTime now = LocalDateTime.now();
        if (startDate != null && now.isBefore(startDate)) return "Mã giảm giá chưa tới ngày áp dụng";
        if (endDate != null && now.isAfter(endDate)) return "Mã giảm giá đã hết hạn";
        if (usageLimit != null && usedCount >= usageLimit) return "Mã giảm giá đã hết lượt sử dụng";
        if (subtotal < minOrderValue) {
            return "Đơn hàng cần tối thiểu " + (long) minOrderValue + "đ để dùng mã này";
        }
        return null; // hop le
    }

    /** Tinh so tien duoc giam tren 1 don hang (subtotal = tien hang, chua gom phi giao hang). */
    public double computeDiscount(double subtotal, double deliveryFee) {
        switch (voucherType) {
            case "PERCENT": {
                double discount = subtotal * value / 100.0;
                if (maxDiscount != null && discount > maxDiscount) discount = maxDiscount;
                return Math.min(discount, subtotal);
            }
            case "FIXED":
                return Math.min(value, subtotal);
            case "FREESHIP":
                return deliveryFee;
            default:
                return 0;
        }
    }

    public long getId() { return id; }
    public void setId(long id) { this.id = id; }

    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }

    public String getVoucherType() { return voucherType; }
    public void setVoucherType(String voucherType) { this.voucherType = voucherType; }

    public double getValue() { return value; }
    public void setValue(double value) { this.value = value; }

    public double getMinOrderValue() { return minOrderValue; }
    public void setMinOrderValue(double minOrderValue) { this.minOrderValue = minOrderValue; }

    public Double getMaxDiscount() { return maxDiscount; }
    public void setMaxDiscount(Double maxDiscount) { this.maxDiscount = maxDiscount; }

    public Integer getUsageLimit() { return usageLimit; }
    public void setUsageLimit(Integer usageLimit) { this.usageLimit = usageLimit; }

    public int getUsedCount() { return usedCount; }
    public void setUsedCount(int usedCount) { this.usedCount = usedCount; }

    public LocalDateTime getStartDate() { return startDate; }
    public void setStartDate(LocalDateTime startDate) { this.startDate = startDate; }
    public String getStartDateDisplay() {
        return startDate == null ? "" : startDate.format(DateTimeFormatter.ofPattern("HH:mm dd/MM/yyyy"));
    }

    public LocalDateTime getEndDate() { return endDate; }
    public void setEndDate(LocalDateTime endDate) { this.endDate = endDate; }
    public String getEndDateDisplay() {
        return endDate == null ? "" : endDate.format(DateTimeFormatter.ofPattern("HH:mm dd/MM/yyyy"));
    }

    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
