package org.example.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.example.daos.ShipperWithdrawalDAO;
import org.example.daos.ShipperWithdrawalDAOImpl;
import org.example.models.Account;
import org.example.models.ShipperWithdrawal;

import java.io.IOException;
import java.util.List;

/**
 * KHUNG (SCAFFOLD) cho trang "Duyệt rút tiền Shipper".
 * Trang JSP hiện đang dùng mock-data tĩnh; servlet/DAO này đã sẵn sàng
 * để nối dữ liệu thật khi cần (theo đúng mẫu đã làm ở DoiSoatDoanhThuShopServlet).
 * Yêu cầu trước khi dùng thật: chạy migration_shipper_withdrawals.sql trên DB.
 */
@WebServlet("/admin/duyet-rut-tien-shipper")
public class DuyetRutTienShipperServlet extends HttpServlet {

    private final ShipperWithdrawalDAO withdrawalDAO = new ShipperWithdrawalDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!isSuperAdmin(req)) {
            resp.sendRedirect(req.getContextPath() + "/dangnhap");
            return;
        }

        String statusFilter = req.getParameter("status"); // PENDING | APPROVED | REJECTED | null
        List<ShipperWithdrawal> danhSach = withdrawalDAO.getAllWithdrawals(
                (statusFilter == null || statusFilter.isBlank() || "all".equalsIgnoreCase(statusFilter)) ? null : statusFilter
        );

        double tongTienYeuCau = 0, choXuLy = 0, daThanhToan = 0;
        for (ShipperWithdrawal w : danhSach) {
            tongTienYeuCau += w.getAmount();
            if ("PENDING".equals(w.getStatus())) choXuLy += w.getAmount();
            if ("APPROVED".equals(w.getStatus())) daThanhToan += w.getAmount();
        }

        req.setAttribute("danhSachRutTien", danhSach);
        req.setAttribute("tongTienYeuCau", tongTienYeuCau);
        req.setAttribute("choXuLy", choXuLy);
        req.setAttribute("daThanhToan", daThanhToan);
        req.setAttribute("statusFilter", statusFilter == null ? "all" : statusFilter);

        req.getRequestDispatcher("/admin/DuyetRutTienShipper.jsp").forward(req, resp);
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
            long withdrawalId = Long.parseLong(req.getParameter("id"));
            String action = req.getParameter("action"); // "approve" | "reject"

            HttpSession session = req.getSession(false);
            Account account = (Account) session.getAttribute("account");

            boolean thanhCong;
            if ("approve".equalsIgnoreCase(action)) {
                thanhCong = withdrawalDAO.approveWithdrawal(withdrawalId, account.getId());
            } else if ("reject".equalsIgnoreCase(action)) {
                String reason = req.getParameter("reason");
                thanhCong = withdrawalDAO.rejectWithdrawal(withdrawalId, account.getId(),
                        (reason == null || reason.isBlank()) ? "Không rõ lý do" : reason);
            } else {
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                resp.getWriter().write("{\"success\":false,\"message\":\"Hành động không hợp lệ.\"}");
                return;
            }

            if (thanhCong) {
                resp.getWriter().write("{\"success\":true}");
            } else {
                resp.setStatus(HttpServletResponse.SC_CONFLICT);
                resp.getWriter().write("{\"success\":false,\"message\":\"Yêu cầu không tồn tại hoặc đã được xử lý trước đó.\"}");
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
}
