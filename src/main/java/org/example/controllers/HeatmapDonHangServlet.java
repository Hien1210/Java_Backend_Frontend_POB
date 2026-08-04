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

        int tongSoDon = baoCaoDAO.countTotalOrders(tuNgay, denNgay);
        List<org.example.models.OrderMapDTO> mapDetails = baoCaoDAO.findOrderMapDetails(tuNgay, denNgay);

        StringBuilder pointsJson = new StringBuilder("[");
        StringBuilder detailsJson = new StringBuilder("[");
        for (int i = 0; i < mapDetails.size(); i++) {
            org.example.models.OrderMapDTO item = mapDetails.get(i);
            if (i > 0) {
                pointsJson.append(",");
                detailsJson.append(",");
            }
            pointsJson.append("[").append(String.format(Locale.US, "%.10f", item.getLocationX()))
                    .append(",").append(String.format(Locale.US, "%.10f", item.getLocationY())).append("]");

            String addressEscaped = item.getShippingAddress() != null ? item.getShippingAddress().replace("\"", "\\\"").replace("\n", " ") : "";
            String shopEscaped = item.getShopName() != null ? item.getShopName().replace("\"", "\\\"") : "POB Food";
            String dateFormatted = item.getCreatedAt() != null ? item.getCreatedAt().toString() : "";

            detailsJson.append("{")
                    .append("\"id\":").append(item.getId()).append(",")
                    .append("\"lat\":").append(String.format(Locale.US, "%.10f", item.getLocationX())).append(",")
                    .append("\"lng\":").append(String.format(Locale.US, "%.10f", item.getLocationY())).append(",")
                    .append("\"amount\":").append(String.format(Locale.US, "%.2f", item.getTotalAmount())).append(",")
                    .append("\"address\":\"").append(addressEscaped).append("\",")
                    .append("\"shop\":\"").append(shopEscaped).append("\",")
                    .append("\"time\":\"").append(dateFormatted).append("\"")
                    .append("}");
        }
        pointsJson.append("]");
        detailsJson.append("]");

        List<double[]> realGpsPoints = baoCaoDAO.findOrderCoordinates(tuNgay, denNgay);

        req.setAttribute("tuNgay", tuNgay.format(ISO_DATE));
        req.setAttribute("denNgay", denNgay.format(ISO_DATE));
        req.setAttribute("tongSoDon", tongSoDon);
        req.setAttribute("soDiemGps", realGpsPoints.size());
        req.setAttribute("soDiem", mapDetails.size());
        req.setAttribute("heatmapPointsJson", pointsJson.toString());
        req.setAttribute("orderDetailsJson", detailsJson.toString());

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
