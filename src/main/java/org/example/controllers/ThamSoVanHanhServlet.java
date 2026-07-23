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

import java.io.IOException;

/**
 * Trang "Tham số vận hành" (Super Admin) - /admin/tham-so-van-hanh
 */
@WebServlet("/admin/tham-so-van-hanh")
public class ThamSoVanHanhServlet extends HttpServlet {

    private final SystemConfigDAO systemConfigDAO = new SystemConfigDAOImpl();

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

        boolean ok = systemConfigDAO.save(config);
        resp.sendRedirect(req.getContextPath() + "/admin/tham-so-van-hanh?success=" + (ok ? "saved" : "failed"));
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
}
