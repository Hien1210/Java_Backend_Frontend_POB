package org.example.models;

public class ShopRevenueStat {
    private String shopName;
    private int tongDon;
    private double doanhThu;

    public ShopRevenueStat() {
    }

    public ShopRevenueStat(String shopName, int tongDon, double doanhThu) {
        this.shopName = shopName;
        this.tongDon = tongDon;
        this.doanhThu = doanhThu;
    }

    public String getShopName() {
        return shopName;
    }

    public void setShopName(String shopName) {
        this.shopName = shopName;
    }

    public int getTongDon() {
        return tongDon;
    }

    public void setTongDon(int tongDon) {
        this.tongDon = tongDon;
    }

    public double getDoanhThu() {
        return doanhThu;
    }

    public void setDoanhThu(double doanhThu) {
        this.doanhThu = doanhThu;
    }
}
