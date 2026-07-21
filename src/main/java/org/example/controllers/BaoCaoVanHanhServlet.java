package org.example.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.daos.BaoCaoVanHanhDAO;
import org.example.daos.BaoCaoVanHanhDAOImpl;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Map;

@WebServlet("/admin/bao-cao-van-hanh")
public class BaoCaoVanHanhServlet extends HttpServlet {

    private static final DateTimeFormatter ISO_DATE = DateTimeFormatter.ISO_LOCAL_DATE;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        LocalDate today = LocalDate.now();
        LocalDate tuNgay = parseDate(req.getParameter("tuNgay"), today.minusDays(29));
        LocalDate denNgay = parseDate(req.getParameter("denNgay"), today);
        if (denNgay.isBefore(tuNgay)) {
            LocalDate tmp = tuNgay;
            tuNgay = denNgay;
            denNgay = tmp;
        }

        BaoCaoVanHanhDAO baoCaoDAO = new BaoCaoVanHanhDAOImpl();

        int tongDonHang = baoCaoDAO.countTotalOrders(tuNgay, denNgay);
        Map<String, Integer> donTheoTrangThai = baoCaoDAO.countOrdersByStatus(tuNgay, denNgay);
        Double thoiGianGiaoTrungBinh = baoCaoDAO.getAvgThoiGianGiaoHangPhut(tuNgay, denNgay);
        String khungGioCaoDiem = baoCaoDAO.getKhungGioDatHangCaoDiem(tuNgay, denNgay);
        Map<String, Integer> lyDoHuyDon = baoCaoDAO.countCancelReasons(tuNgay, denNgay);

        int donThanhCong = donTheoTrangThai.getOrDefault("DONE", 0);
        int donDaHuy = donTheoTrangThai.getOrDefault("CANCELLED", 0);
        int donDangGiao = donTheoTrangThai.getOrDefault("PENDING", 0)
                + donTheoTrangThai.getOrDefault("CONFIRMED", 0)
                + donTheoTrangThai.getOrDefault("READY_FOR_PICKUP", 0)
                + donTheoTrangThai.getOrDefault("SHIPPING", 0);

        double tyLeHoanThanh = tongDonHang == 0 ? 0 : (donThanhCong * 100.0 / tongDonHang);

        req.setAttribute("tuNgay", tuNgay.format(ISO_DATE));
        req.setAttribute("denNgay", denNgay.format(ISO_DATE));
        req.setAttribute("tongDonHang", tongDonHang);
        req.setAttribute("tyLeHoanThanh", tyLeHoanThanh);
        req.setAttribute("thoiGianGiaoTrungBinh", thoiGianGiaoTrungBinh);
        req.setAttribute("donThanhCong", donThanhCong);
        req.setAttribute("donDaHuy", donDaHuy);
        req.setAttribute("donDangGiao", donDangGiao);
        req.setAttribute("khungGioCaoDiem", khungGioCaoDiem);
        req.setAttribute("lyDoHuyDon", lyDoHuyDon);

        req.getRequestDispatcher("/admin/BaoCaoVanHanh.jsp").forward(req, resp);
    }

    private LocalDate parseDate(String raw, LocalDate fallback) {
        if (raw == null || raw.isBlank()) {
            return fallback;
        }
        try {
            return LocalDate.parse(raw, ISO_DATE);
        } catch (Exception e) {
            return fallback;
        }
    }
}
