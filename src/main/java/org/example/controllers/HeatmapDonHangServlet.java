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

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Locale;

/**
 * Heatmap khu vực đặt hàng cho Super Admin.
 * URL : /admin/heatmap-don-hang
 * JSP : /admin/HeatmapDonHang.jsp
 */
@WebServlet("/admin/heatmap-don-hang")
public class HeatmapDonHangServlet extends HttpServlet {

    private static final DateTimeFormatter ISO_DATE = DateTimeFormatter.ISO_LOCAL_DATE;
    private final BaoCaoVanHanhDAO baoCaoDAO = new BaoCaoVanHanhDAOImpl();

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

        List<double[]> points = baoCaoDAO.findOrderCoordinates(tuNgay, denNgay);

        StringBuilder json = new StringBuilder("[");
        for (int i = 0; i < points.size(); i++) {
            double[] p = points.get(i);
            if (i > 0) json.append(",");
            json.append("[").append(String.format(Locale.US, "%.10f", p[0]))
                    .append(",").append(String.format(Locale.US, "%.10f", p[1])).append("]");
        }
        json.append("]");

        req.setAttribute("tuNgay", tuNgay.format(ISO_DATE));
        req.setAttribute("denNgay", denNgay.format(ISO_DATE));
        req.setAttribute("soDiem", points.size());
        req.setAttribute("heatmapPointsJson", json.toString());

        req.getRequestDispatcher("/admin/HeatmapDonHang.jsp").forward(req, resp);
    }

    private LocalDate parseDate(String value, LocalDate fallback) {
        if (value == null || value.trim().isEmpty()) return fallback;
        try {
            return LocalDate.parse(value.trim(), ISO_DATE);
        } catch (Exception e) {
            return fallback;
        }
    }
}
