package org.example.daos;

import java.time.LocalDate;
import java.util.Map;

public interface BaoCaoVanHanhDAO {
    int countTotalOrders(LocalDate tuNgay, LocalDate denNgay);

    Map<String, Integer> countOrdersByStatus(LocalDate tuNgay, LocalDate denNgay);

    Double getAvgThoiGianGiaoHangPhut(LocalDate tuNgay, LocalDate denNgay);
}
