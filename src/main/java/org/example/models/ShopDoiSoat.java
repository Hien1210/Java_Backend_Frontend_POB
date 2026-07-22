package org.example.models;

public class ShopDoiSoat {
    private long shopId;
    private String shopName;
    private int soDonThanhCong;
    private double tongDoanhThu;
    private double phiSan;
    private double soTienThucNhan;
    private boolean daThanhToan;

    public ShopDoiSoat() {
    }

    public ShopDoiSoat(long shopId, String shopName, int soDonThanhCong, double tongDoanhThu, boolean daThanhToan) {
        this.shopId = shopId;
        this.shopName = shopName;
        this.soDonThanhCong = soDonThanhCong;
        this.tongDoanhThu = tongDoanhThu;
        this.phiSan = Math.round(tongDoanhThu * 0.1);
        this.soTienThucNhan = tongDoanhThu - this.phiSan;
        this.daThanhToan = daThanhToan;
    }

    public long getShopId() {
        return shopId;
    }

    public void setShopId(long shopId) {
        this.shopId = shopId;
    }

    public String getShopName() {
        return shopName;
    }

    public void setShopName(String shopName) {
        this.shopName = shopName;
    }

    public int getSoDonThanhCong() {
        return soDonThanhCong;
    }

    public void setSoDonThanhCong(int soDonThanhCong) {
        this.soDonThanhCong = soDonThanhCong;
    }

    public double getTongDoanhThu() {
        return tongDoanhThu;
    }

    public void setTongDoanhThu(double tongDoanhThu) {
        this.tongDoanhThu = tongDoanhThu;
    }

    public double getPhiSan() {
        return phiSan;
    }

    public void setPhiSan(double phiSan) {
        this.phiSan = phiSan;
    }

    public double getSoTienThucNhan() {
        return soTienThucNhan;
    }

    public void setSoTienThucNhan(double soTienThucNhan) {
        this.soTienThucNhan = soTienThucNhan;
    }

    public boolean isDaThanhToan() {
        return daThanhToan;
    }

    public void setDaThanhToan(boolean daThanhToan) {
        this.daThanhToan = daThanhToan;
    }
}
