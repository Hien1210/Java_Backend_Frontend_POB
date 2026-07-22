package org.example.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.example.daos.DoiSoatDoanhThuShopDAO;
import org.example.daos.DoiSoatDoanhThuShopDAOImpl;
import org.example.daos.ShopDAO;
import org.example.daos.ShopDAOImpl;
import org.example.models.Account;
import org.example.models.ShopDoiSoat;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

@WebServlet("/admin/doi-soat-doanh-thu-shop")
public class DoiSoatDoanhThuShopServlet extends HttpServlet {

    private static final DateTimeFormatter ISO_DATE = DateTimeFormatter.ISO_LOCAL_DATE;
    private final DoiSoatDoanhThuShopDAO doiSoatDAO = new DoiSoatDoanhThuShopDAOImpl();
    private final ShopDAO shopDAO = new ShopDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!isSuperAdmin(req)) {
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

        String shopIdParam = req.getParameter("shopId");
        Long shopId = (shopIdParam == null || shopIdParam.isBlank() || "all".equalsIgnoreCase(shopIdParam))
                ? null : Long.valueOf(shopIdParam);

        List<ShopDoiSoat> danhSachDoiSoat = doiSoatDAO.getDoiSoatTheoShop(tuNgay, denNgay, shopId);

        double tongDoanhThu = 0, tongPhiSan = 0, tongNetPayout = 0;
        int soShopChoThanhToan = 0;
        for (ShopDoiSoat item : danhSachDoiSoat) {
            tongDoanhThu += item.getTongDoanhThu();
            tongPhiSan += item.getPhiSan();
            tongNetPayout += item.getSoTienThucNhan();
            if (!item.isDaThanhToan() && item.getSoDonThanhCong() > 0) {
                soShopChoThanhToan++;
            }
        }

        req.setAttribute("danhSachDoiSoat", danhSachDoiSoat);
        req.setAttribute("tongDoanhThu", tongDoanhThu);
        req.setAttribute("tongPhiSan", tongPhiSan);
        req.setAttribute("tongNetPayout", tongNetPayout);
        req.setAttribute("soShopChoThanhToan", soShopChoThanhToan);
        req.setAttribute("tuNgay", tuNgay.format(ISO_DATE));
        req.setAttribute("denNgay", denNgay.format(ISO_DATE));
        req.setAttribute("shopIdFilter", shopId == null ? "all" : String.valueOf(shopId));
        req.setAttribute("danhSachShop", shopDAO.selectAllShops());

        req.getRequestDispatcher("/admin/DoiSoatDoanhThuShop.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json; charset=UTF-8");

        if (!isSuperAdmin(req)) {
            resp.setStatus(HttpServletResponse.SC_FORBIDDEN);
            resp.getWriter().write("{\"success\":false,\"message\":\"Bạn không có quyền thực hiện thao tác này.\"}");
            return;
        }

        try {
            long shopId = Long.parseLong(req.getParameter("shopId"));
            LocalDate tuNgay = LocalDate.parse(req.getParameter("tuNgay"), ISO_DATE);
            LocalDate denNgay = LocalDate.parse(req.getParameter("denNgay"), ISO_DATE);

            // Tính lại doanh thu ngay tại server (không tin số liệu client gửi lên) để đảm bảo số tiền xác nhận thanh toán là chính xác.
            List<ShopDoiSoat> ketQua = doiSoatDAO.getDoiSoatTheoShop(tuNgay, denNgay, shopId);
            if (ketQua.isEmpty()) {
                resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
                resp.getWriter().write("{\"success\":false,\"message\":\"Không tìm thấy dữ liệu đối soát cho Shop này.\"}");
                return;
            }

            ShopDoiSoat doiSoat = ketQua.get(0);
            if (doiSoat.getSoDonThanhCong() <= 0) {
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                resp.getWriter().write("{\"success\":false,\"message\":\"Shop không có đơn hàng thành công trong khoảng thời gian này.\"}");
                return;
            }

            HttpSession session = req.getSession(false);
            Account account = (Account) session.getAttribute("account");

            boolean thanhCong = doiSoatDAO.xacNhanThanhToan(
                    shopId, tuNgay, denNgay,
                    doiSoat.getTongDoanhThu(), doiSoat.getPhiSan(), doiSoat.getSoTienThucNhan(),
                    account.getId()
            );

            if (thanhCong) {
                resp.getWriter().write(String.format(
                        "{\"success\":true,\"soTienThucNhan\":%.2f}", doiSoat.getSoTienThucNhan()
                ));
            } else {
                resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                resp.getWriter().write("{\"success\":false,\"message\":\"Không thể cập nhật trạng thái thanh toán.\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"success\":false,\"message\":\"Dữ liệu không hợp lệ.\"}");
        }
    }

    private boolean isSuperAdmin(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        if (session == null) return false;
        Object accountObj = session.getAttribute("account");
        if (!(accountObj instanceof Account)) return false;
        Account account = (Account) accountObj;
        return account.getRoleId() == 1;
    }

    private LocalDate parseDate(String value, LocalDate fallback) {
        if (value == null || value.isBlank()) return fallback;
        try {
            return LocalDate.parse(value, ISO_DATE);
        } catch (Exception e) {
            return fallback;
        }
    }
}
