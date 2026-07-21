package org.example.models;

public class DailyOrderStat {
    private String ngay;
    private int donThanhCong;
    private int donHuy;
    private double doanhThu;

    public DailyOrderStat() {
    }

    public DailyOrderStat(String ngay, int donThanhCong, int donHuy, double doanhThu) {
        this.ngay = ngay;
        this.donThanhCong = donThanhCong;
        this.donHuy = donHuy;
        this.doanhThu = doanhThu;
    }

    public String getNgay() {
        return ngay;
    }

    public void setNgay(String ngay) {
        this.ngay = ngay;
    }

    public int getDonThanhCong() {
        return donThanhCong;
    }

    public void setDonThanhCong(int donThanhCong) {
        this.donThanhCong = donThanhCong;
    }

    public int getDonHuy() {
        return donHuy;
    }

    public void setDonHuy(int donHuy) {
        this.donHuy = donHuy;
    }

    public double getDoanhThu() {
        return doanhThu;
    }

    public void setDoanhThu(double doanhThu) {
        this.doanhThu = doanhThu;
    }
}
