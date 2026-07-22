package org.example.daos;

import org.example.models.ShopDoiSoat;

import java.time.LocalDate;
import java.util.List;

public interface DoiSoatDoanhThuShopDAO {
    List<ShopDoiSoat> getDoiSoatTheoShop(LocalDate tuNgay, LocalDate denNgay, Long shopId);

    boolean xacNhanThanhToan(long shopId, LocalDate tuNgay, LocalDate denNgay,
                              double tongDoanhThu, double phiSan, double soTienThucNhan, long confirmedBy);
}
