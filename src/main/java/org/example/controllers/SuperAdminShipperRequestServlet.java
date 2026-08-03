package org.example.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.example.daos.AccountDAO;
import org.example.daos.AccountDAOImpl;
import org.example.daos.NotificationDAO;
import org.example.daos.NotificationDAOImpl;
import org.example.daos.ShipperProfileDAO;
import org.example.daos.ShipperProfileDAOImpl;
import org.example.models.Account;
import org.example.models.Notification;
import org.example.models.ShipperProfile;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/super-admin/shipper-requests")
public class SuperAdminShipperRequestServlet extends HttpServlet {

    private final AccountDAO accountDAO = new AccountDAOImpl();
    private final ShipperProfileDAO shipperProfileDAO = new ShipperProfileDAOImpl();
    private final NotificationDAO notificationDAO = new NotificationDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        if (requireSuperAdmin(req, resp) == null) return;

        String action = req.getParameter("action");
        if ("detail".equals(action)) {
            showDetail(req, resp);
            return;
        }

        // Nguon du lieu duy nhat cho hang doi duyet: Shipper_Profiles.verification_status.
        // KHONG con doc Accounts.status (tai khoan Shipper moi dang ky mac dinh la ACTIVE
        // ngay tu dau, khong bao gio la PENDING, nen loc theo Accounts.status truoc day
        // khien hang doi nay luon rong).
        List<ShipperProfile> pendingProfiles = shipperProfileDAO.findByVerificationStatus("PENDING");
        List<Account> pendingShippers = new ArrayList<>();
        for (ShipperProfile p : pendingProfiles) {
            Account a = accountDAO.findById(p.getAccountId());
            if (a != null) pendingShippers.add(a);
        }
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

        // Duyet/tu choi Shipper CHI ghi vao Shipper_Profiles.verification_status.
        // Accounts.status KHONG con bi dung o day nua: tai khoan van giu nguyen ACTIVE
        // ca khi bi tu choi, Shipper van dang nhap duoc (chi khong lam duoc nghiep vu
        // giao hang) - dung theo quyet dinh kien truc da thong nhat.
        String action = normalize(req.getParameter("action"));
        if ("accept".equals(action)) {
            boolean updated = shipperProfileDAO.updateVerificationStatus(shipperId, "APPROVED", null, admin.getId());
            if (!updated) {
                req.setAttribute("loi", "Không thể duyệt shipper. Vui lòng thử lại.");
                showDetail(req, resp);
                return;
            }
            notifyShipper(shipperId, "✅ Hồ sơ đã được duyệt",
                    "Giấy tờ (CCCD/GPLX) của bạn đã được Super Admin duyệt. Bạn có thể bắt đầu nhận đơn.");
            resp.sendRedirect(req.getContextPath() + "/super-admin/shipper-requests?success=accepted");
            return;
        }

        if ("reject".equals(action)) {
            String reason = normalize(req.getParameter("reason"));
            boolean updated = shipperProfileDAO.updateVerificationStatus(shipperId, "REJECTED",
                    reason.isEmpty() ? null : reason, admin.getId());
            if (!updated) {
                req.setAttribute("loi", "Không thể từ chối shipper. Vui lòng thử lại.");
                showDetail(req, resp);
                return;
            }
            notifyShipper(shipperId, "❌ Hồ sơ bị từ chối",
                    reason.isEmpty()
                            ? "Giấy tờ (CCCD/GPLX) của bạn chưa hợp lệ. Vui lòng cập nhật lại giấy tờ trong trang Hồ sơ tài xế."
                            : "Giấy tờ (CCCD/GPLX) của bạn bị từ chối: " + reason + ". Vui lòng cập nhật lại giấy tờ trong trang Hồ sơ tài xế.");
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

    private void notifyShipper(long shipperId, String title, String message) {
        Notification n = new Notification();
        n.setAccountId(shipperId);
        n.setTitle(title);
        n.setMessage(message);
        notificationDAO.create(n);
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
