package org.example.models;

import java.util.ArrayList;
import java.util.List;

public class ToppingCategory {
    private long id;
    private long shopId;
    private String name;
    private String description;
    private boolean isDeleted;
    private List<Long> categoryIds = new ArrayList<>(); // rong = ap dung cho MOI loai san pham
    private List<String> categoryNames = new ArrayList<>(); // view-only, do o DAO qua JOIN bang trung gian

    public ToppingCategory() {
    }

    public ToppingCategory(long id, long shopId, String name, String description, boolean isDeleted) {
        this.id = id;
        this.shopId = shopId;
        this.name = name;
        this.description = description;
        this.isDeleted = isDeleted;
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public long getShopId() {
        return shopId;
    }

    public void setShopId(long shopId) {
        this.shopId = shopId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public boolean isDeleted() {
        return isDeleted;
    }

    public void setDeleted(boolean deleted) {
        isDeleted = deleted;
    }

    public List<Long> getCategoryIds() {
        return categoryIds;
    }

    public void setCategoryIds(List<Long> categoryIds) {
        this.categoryIds = categoryIds == null ? new ArrayList<>() : categoryIds;
    }

    public List<String> getCategoryNames() {
        return categoryNames;
    }

    public void setCategoryNames(List<String> categoryNames) {
        this.categoryNames = categoryNames == null ? new ArrayList<>() : categoryNames;
    }
}
