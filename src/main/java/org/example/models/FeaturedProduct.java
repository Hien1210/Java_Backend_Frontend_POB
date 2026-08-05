package org.example.models;

public class FeaturedProduct {
    private final long productId;
    private final String productName;
    private final String description;
    private final double price;
    private final String imageUrl;
    private final String shopName;
    private final double shopRating;
    private final int soldCount;

    public FeaturedProduct(long productId, String productName, String description, double price,
                            String imageUrl, String shopName, double shopRating, int soldCount) {
        this.productId = productId;
        this.productName = productName;
        this.description = description;
        this.price = price;
        this.imageUrl = imageUrl;
        this.shopName = shopName;
        this.shopRating = shopRating;
        this.soldCount = soldCount;
    }

    public long getProductId() { return productId; }
    public String getProductName() { return productName; }
    public String getDescription() { return description; }
    public double getPrice() { return price; }
    public String getImageUrl() { return imageUrl; }
    public String getShopName() { return shopName; }
    public double getShopRating() { return shopRating; }
    public int getSoldCount() { return soldCount; }
}
