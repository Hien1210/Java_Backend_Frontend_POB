package org.example.daos;

import org.example.models.ShopDoiSoat;

import java.time.LocalDate;
import java.util.List;

public interface DoiSoatDoanhThuShopDAO {
    /** @param defaultCommissionPercent ty le hoa hong mac dinh (System_Configs.commission_percent), dung cho cac shop chua co commission_rate rieng. */
    List<ShopDoiSoat> getDoiSoatTheoShop(LocalDate tuNgay, LocalDate denNgay, Long shopId, double defaultCommissionPercent);

    boolean xacNhanThanhToan(long shopId, LocalDate tuNgay, LocalDate denNgay,
                              double tongDoanhThu, double phiSan, double soTienThucNhan, long confirmedBy);
}
