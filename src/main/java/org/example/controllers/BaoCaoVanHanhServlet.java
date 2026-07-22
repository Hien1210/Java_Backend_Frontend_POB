package org.example.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.example.daos.BaoCaoVanHanhDAO;
import org.example.daos.BaoCaoVanHanhDAOImpl;
import org.example.models.Account;
import org.example.utils.ExcelExportUtil;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@WebServlet("/admin/bao-cao-van-hanh")
public class BaoCaoVanHanhServlet extends HttpServlet {

    private static final DateTimeFormatter ISO_DATE = DateTimeFormatter.ISO_LOCAL_DATE;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        Account account = session != null ? (Account) session.getAttribute("account") : null;
        if (account == null || account.getRoleId() != 1) {
            resp.sendRedirect(req.getContextPath() + "/dangnhap");
            return;
        }

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

        if ("exportExcel".equals(req.getParameter("action"))) {
            exportThongKeExcel(resp, tuNgay, denNgay, tongDonHang, tyLeHoanThanh, thoiGianGiaoTrungBinh,
                    donThanhCong, donDaHuy, donDangGiao, khungGioCaoDiem, lyDoHuyDon);
            return;
        }

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

    private void exportThongKeExcel(HttpServletResponse resp, LocalDate tuNgay, LocalDate denNgay,
                                     int tongDonHang, double tyLeHoanThanh, Double thoiGianGiaoTrungBinh,
                                     int donThanhCong, int donDaHuy, int donDangGiao,
                                     String khungGioCaoDiem, Map<String, Integer> lyDoHuyDon) throws IOException {
        String[] headers = {"Chi tieu", "Gia tri"};
        List<Object[]> rows = new ArrayList<>();
        rows.add(new Object[]{"Tong don hang", tongDonHang});
        rows.add(new Object[]{"Ty le hoan thanh (%)", Math.round(tyLeHoanThanh * 100.0) / 100.0});
        rows.add(new Object[]{"Thoi gian giao trung binh (phut)",
                thoiGianGiaoTrungBinh == null ? "N/A" : Math.round(thoiGianGiaoTrungBinh * 100.0) / 100.0});
        rows.add(new Object[]{"Don thanh cong (DONE)", donThanhCong});
        rows.add(new Object[]{"Don da huy (CANCELLED)", donDaHuy});
        rows.add(new Object[]{"Don dang xu ly/giao", donDangGiao});
        rows.add(new Object[]{"Khung gio dat hang cao diem", khungGioCaoDiem == null ? "N/A" : khungGioCaoDiem});
        rows.add(new Object[]{"", ""});
        rows.add(new Object[]{"Ly do huy don", "So luong"});
        for (Map.Entry<String, Integer> entry : lyDoHuyDon.entrySet()) {
            rows.add(new Object[]{entry.getKey(), entry.getValue()});
        }

        String title = "Bao cao van hanh " + tuNgay.format(ISO_DATE) + " - " + denNgay.format(ISO_DATE);
        byte[] excel = ExcelExportUtil.export("ThongKe", title, headers, rows);
        resp.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        resp.setHeader("Content-Disposition", "attachment; filename=\"thong-ke-van-hanh.xlsx\"");
        resp.setContentLength(excel.length);
        resp.getOutputStream().write(excel);
        resp.getOutputStream().flush();
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
