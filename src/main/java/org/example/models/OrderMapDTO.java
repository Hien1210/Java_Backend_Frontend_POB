package org.example.models;

import java.sql.Timestamp;

public class OrderMapDTO {
    private int id;
    private double locationX;
    private double locationY;
    private double totalAmount;
    private String shippingAddress;
    private String shopName;
    private Timestamp createdAt;

    public OrderMapDTO() {}

    public OrderMapDTO(int id, double locationX, double locationY, double totalAmount, String shippingAddress, String shopName, Timestamp createdAt) {
        this.id = id;
        this.locationX = locationX;
        this.locationY = locationY;
        this.totalAmount = totalAmount;
        this.shippingAddress = shippingAddress;
        this.shopName = shopName;
        this.createdAt = createdAt;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public double getLocationX() { return locationX; }
    public void setLocationX(double locationX) { this.locationX = locationX; }

    public double getLocationY() { return locationY; }
    public void setLocationY(double locationY) { this.locationY = locationY; }

    public double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }

    public String getShippingAddress() { return shippingAddress; }
    public void setShippingAddress(String shippingAddress) { this.shippingAddress = shippingAddress; }

    public String getShopName() { return shopName; }
    public void setShopName(String shopName) { this.shopName = shopName; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
