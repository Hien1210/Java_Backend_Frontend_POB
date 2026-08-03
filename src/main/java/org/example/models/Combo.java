package org.example.models;

import java.time.LocalDateTime;
import java.util.List;

public class Combo {
    private long id;
    private long shopId;
    private String name;
    private String description;
    private double comboPrice;
    private boolean active;
    private LocalDateTime createdAt;
    private List<ComboItem> items;

    public long getId() { return id; }
    public void setId(long id) { this.id = id; }
    public long getShopId() { return shopId; }
    public void setShopId(long shopId) { this.shopId = shopId; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public double getComboPrice() { return comboPrice; }
    public void setComboPrice(double comboPrice) { this.comboPrice = comboPrice; }
    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    public List<ComboItem> getItems() { return items; }
    public void setItems(List<ComboItem> items) { this.items = items; }
}
