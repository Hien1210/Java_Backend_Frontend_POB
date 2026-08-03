package org.example.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.example.daos.SystemConfigDAO;
import org.example.daos.SystemConfigDAOImpl;
import org.example.models.Account;
import org.example.models.SystemConfig;
import org.example.services.AuditLogService;
import org.example.utils.AuditModules;

import java.io.IOException;

/**
 * Trang "Tham số vận hành" (Super Admin) - /admin/tham-so-van-hanh
 */
@WebServlet("/admin/tham-so-van-hanh")
public class ThamSoVanHanhServlet extends HttpServlet {

    private final SystemConfigDAO systemConfigDAO = new SystemConfigDAOImpl();
    private final AuditLogService auditLogService = new AuditLogService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!requireAdmin(req, resp)) return;

        req.setAttribute("config", systemConfigDAO.get());
        req.getRequestDispatcher("/admin/ThamSoVanHanh.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!requireAdmin(req, resp)) return;
        req.setCharacterEncoding("UTF-8");

        SystemConfig config = new SystemConfig();
        config.setCommissionPercent(parseDouble(req.getParameter("commissionPercent")));
        config.setFixedFeePerOrder(parseDouble(req.getParameter("fixedFeePerOrder")));
        config.setShippingFeeFirst2Km(parseDouble(req.getParameter("shippingFeeFirst2Km")));
        config.setShippingFeePerKm(parseDouble(req.getParameter("shippingFeePerKm")));
        config.setMaxDeliveryRadiusKm(parseDouble(req.getParameter("maxDeliveryRadiusKm")));
        config.setShopAcceptOrderMinutes((int) parseDouble(req.getParameter("shopAcceptOrderMinutes")));
        config.setAutoCompleteOrderHours((int) parseDouble(req.getParameter("autoCompleteOrderHours")));
        config.setPayosClientId(trim(req.getParameter("payosClientId")));
        config.setPayosApiKey(trim(req.getParameter("payosApiKey")));
        config.setPayosChecksumKey(trim(req.getParameter("payosChecksumKey")));

        String validateError = validate(config);
        if (validateError != null) {
            resp.sendRedirect(req.getContextPath() + "/admin/tham-so-van-hanh?success=invalid&msg="
                    + java.net.URLEncoder.encode(validateError, "UTF-8"));
            return;
        }

        boolean ok = systemConfigDAO.save(config);
        if (ok) {
            Account admin = (Account) req.getSession().getAttribute("account");
            auditLogService.log(req, admin, "Cập nhật tham số vận hành", AuditModules.SYSTEM,
                    "Super Admin " + admin.getUserName() + " đã cập nhật tham số vận hành hệ thống"
                            + " (hoa hồng=" + config.getCommissionPercent() + "%, phí cố định="
                            + config.getFixedFeePerOrder() + ", phí ship 2km đầu="
                            + config.getShippingFeeFirst2Km() + ", phí ship/km=" + config.getShippingFeePerKm()
                            + ", bán kính tối đa=" + config.getMaxDeliveryRadiusKm() + "km)",
                    null, AuditModules.SYSTEM);
        }
        resp.sendRedirect(req.getContextPath() + "/admin/tham-so-van-hanh?success=" + (ok ? "saved" : "failed"));
    }

    private String validate(SystemConfig config) {
        if (isInvalid(config.getCommissionPercent()) || config.getCommissionPercent() < 0 || config.getCommissionPercent() > 100) {
            return "Tỷ lệ hoa hồng phải từ 0 đến 100%!";
        }
        if (isInvalid(config.getFixedFeePerOrder()) || config.getFixedFeePerOrder() < 0) {
            return "Phí cố định mỗi đơn không được âm!";
        }
        if (isInvalid(config.getShippingFeeFirst2Km()) || config.getShippingFeeFirst2Km() < 0) {
            return "Phí ship 2km đầu không được âm!";
        }
        if (isInvalid(config.getShippingFeePerKm()) || config.getShippingFeePerKm() < 0) {
            return "Phí ship mỗi km không được âm!";
        }
        if (isInvalid(config.getMaxDeliveryRadiusKm()) || config.getMaxDeliveryRadiusKm() <= 0) {
            return "Bán kính giao hàng tối đa phải lớn hơn 0!";
        }
        if (config.getShopAcceptOrderMinutes() <= 0) {
            return "Thời gian Shop xác nhận đơn phải lớn hơn 0 phút!";
        }
        if (config.getAutoCompleteOrderHours() <= 0) {
            return "Thời gian tự hoàn thành đơn phải lớn hơn 0 giờ!";
        }
        return null;
    }

    private boolean isInvalid(double val) {
        return Double.isNaN(val) || Double.isInfinite(val);
    }

    private boolean requireAdmin(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        Account account = session != null ? (Account) session.getAttribute("account") : null;
        if (account == null || account.getRoleId() != 1) {
            resp.sendRedirect(req.getContextPath() + "/dangnhap");
            return false;
        }
        return true;
    }

    private double parseDouble(String val) {
        try { return Double.parseDouble(val); } catch (Exception e) { return 0; }
    }

    private String trim(String val) {
        return val == null ? null : val.trim().isEmpty() ? null : val.trim();
    }
}
