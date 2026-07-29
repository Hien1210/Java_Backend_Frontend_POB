package org.example.models;

import java.time.LocalDateTime;

public class ShopWallet {
    private long id;
    private long shopId;
    private double balance;
    private double totalEarned;
    private double totalWithdrawn;
    private LocalDateTime updatedAt;

    public long getId() { return id; }
    public void setId(long id) { this.id = id; }
    public long getShopId() { return shopId; }
    public void setShopId(long shopId) { this.shopId = shopId; }
    public double getBalance() { return balance; }
    public void setBalance(double balance) { this.balance = balance; }
    public double getTotalEarned() { return totalEarned; }
    public void setTotalEarned(double totalEarned) { this.totalEarned = totalEarned; }
    public double getTotalWithdrawn() { return totalWithdrawn; }
    public void setTotalWithdrawn(double totalWithdrawn) { this.totalWithdrawn = totalWithdrawn; }
    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
}
