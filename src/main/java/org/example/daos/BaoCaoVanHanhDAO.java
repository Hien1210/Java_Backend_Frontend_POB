package org.example.daos;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

public interface BaoCaoVanHanhDAO {
    int countTotalOrders(LocalDate tuNgay, LocalDate denNgay);

    Map<String, Integer> countOrdersByStatus(LocalDate tuNgay, LocalDate denNgay);

    Double getAvgThoiGianGiaoHangPhut(LocalDate tuNgay, LocalDate denNgay);

    String getKhungGioDatHangCaoDiem(LocalDate tuNgay, LocalDate denNgay);

    Map<String, Integer> countCancelReasons(LocalDate tuNgay, LocalDate denNgay);

    /** Toa do [lat, lng] cua cac don hang co gan vi tri, dung ve heatmap. */
    List<double[]> findOrderCoordinates(LocalDate tuNgay, LocalDate denNgay);

    /** Lay chi tiet cac don hang co vi tri de hien thi tren Dashboard Map & Top Khu Vuc */
    List<org.example.models.OrderMapDTO> findOrderMapDetails(LocalDate tuNgay, LocalDate denNgay);
}
