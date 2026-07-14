package org.example.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.example.daos.AccountDAO;
import org.example.daos.AccountDAOImpl;
import org.example.daos.ShipperProfileDAO;
import org.example.daos.ShipperProfileDAOImpl;
import org.example.models.Account;
import org.example.models.ShipperProfile;

import java.io.IOException;
import java.util.List;

@WebServlet("/super-admin/shipper-requests")
public class SuperAdminShipperRequestServlet extends HttpServlet {

    private final AccountDAO accountDAO = new AccountDAOImpl();
    private final ShipperProfileDAO shipperProfileDAO = new ShipperProfileDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        if (requireSuperAdmin(req, resp) == null) return;

        String action = req.getParameter("action");
        if ("detail".equals(action)) {
            showDetail(req, resp);
            return;
        }

        List<Account> pendingShippers = accountDAO.findPendingShipperAccounts();
        req.setAttribute("pendingShippers", pendingShippers);
        req.getRequestDispatcher("/admin/yeuCauShipper.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        Account admin = requireSuperAdmin(req, resp);
        if (admin == null) return;

        Long shipperId = parseId(req.getParameter("id"));
        if (shipperId == null) {
            resp.sendRedirect(req.getContextPath() + "/super-admin/shipper-requests?error=invalid_id");
            return;
        }

        String action = normalize(req.getParameter("action"));
        if ("accept".equals(action)) {
            boolean updated = accountDAO.updateAccountStatus(shipperId, "ACTIVE");
            if (!updated) {
                req.setAttribute("loi", "Không thể duyệt shipper. Vui lòng thử lại.");
                showDetail(req, resp);
                return;
            }
            resp.sendRedirect(req.getContextPath() + "/super-admin/shipper-requests?success=accepted");
            return;
        }

        if ("reject".equals(action)) {
            boolean updated = accountDAO.updateAccountStatus(shipperId, "BLOCKED");
            if (!updated) {
                req.setAttribute("loi", "Không thể từ chối shipper. Vui lòng thử lại.");
                showDetail(req, resp);
                return;
            }
            resp.sendRedirect(req.getContextPath() + "/super-admin/shipper-requests?success=rejected");
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/super-admin/shipper-requests");
    }

    private void showDetail(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Long shipperId = parseId(req.getParameter("id"));
        if (shipperId == null) {
            resp.sendRedirect(req.getContextPath() + "/super-admin/shipper-requests?error=invalid_id");
            return;
        }

        Account shipper = accountDAO.findById(shipperId);
        ShipperProfile profile = shipperProfileDAO.findByAccountId(shipperId);

        if (shipper == null) {
            req.setAttribute("loi", "Không tìm thấy tài khoản shipper.");
        } else {
            req.setAttribute("shipper", shipper);
            req.setAttribute("profile", profile);
        }

        req.getRequestDispatcher("/admin/chiTietYeuCauShipper.jsp").forward(req, resp);
    }

    private Account requireSuperAdmin(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        Account account = session == null ? null : (Account) session.getAttribute("account");
        if (account == null || account.getRoleId() != 1) {
            resp.sendRedirect(req.getContextPath() + "/dangnhap");
            return null;
        }
        return account;
    }

    private Long parseId(String value) {
        try {
            String s = normalize(value);
            return s.isEmpty() ? null : Long.parseLong(s);
        } catch (Exception e) {
            return null;
        }
    }

    private String normalize(String value) {
        return value == null ? "" : value.trim();
    }
}
