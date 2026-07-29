package org.example.models;

public class ComboItem {
    private long id;
    private long comboId;
    private long productId;
    private long productSizeId;
    private int quantity;
    private String productName;
    private String sizeName;
    private double sizePrice;

    public long getId() { return id; }
    public void setId(long id) { this.id = id; }
    public long getComboId() { return comboId; }
    public void setComboId(long comboId) { this.comboId = comboId; }
    public long getProductId() { return productId; }
    public void setProductId(long productId) { this.productId = productId; }
    public long getProductSizeId() { return productSizeId; }
    public void setProductSizeId(long productSizeId) { this.productSizeId = productSizeId; }
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }
    public String getSizeName() { return sizeName; }
    public void setSizeName(String sizeName) { this.sizeName = sizeName; }
    public double getSizePrice() { return sizePrice; }
    public void setSizePrice(double sizePrice) { this.sizePrice = sizePrice; }
}
