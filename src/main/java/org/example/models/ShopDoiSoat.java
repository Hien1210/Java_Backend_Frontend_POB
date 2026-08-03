package org.example.models;

public class ShopDoiSoat {
    private long shopId;
    private String shopName;
    private int soDonThanhCong;
    private double tongDoanhThu;
    private double phiSan;
    private double soTienThucNhan;
    private boolean daThanhToan;
    private double commissionRatePercent;

    public ShopDoiSoat() {
    }

    /**
     * @param commissionRatePercent ty le hoa hong tinh theo % (vd 10.0 = 10%) — lay tu
     *                              Shop.commissionRate rieng cua shop neu Super Admin co cau hinh,
     *                              hoac SystemConfig.commissionPercent (mac dinh toan he thong)
     *                              neu shop chua co override rieng. Xem CRUD_DA_LAM.md muc 80.
     */
    public ShopDoiSoat(long shopId, String shopName, int soDonThanhCong, double tongDoanhThu,
                        boolean daThanhToan, double commissionRatePercent) {
        this.shopId = shopId;
        this.shopName = shopName;
        this.soDonThanhCong = soDonThanhCong;
        this.tongDoanhThu = tongDoanhThu;
        this.phiSan = Math.round(tongDoanhThu * commissionRatePercent / 100.0);
        this.soTienThucNhan = tongDoanhThu - this.phiSan;
        this.daThanhToan = daThanhToan;
        this.commissionRatePercent = commissionRatePercent;
    }

    public double getCommissionRatePercent() {
        return commissionRatePercent;
    }

    public void setCommissionRatePercent(double commissionRatePercent) {
        this.commissionRatePercent = commissionRatePercent;
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
