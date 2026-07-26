package org.example.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.example.daos.AccountDAO;
import org.example.daos.AccountDAOImpl;
import org.example.daos.VoucherDAO;
import org.example.daos.VoucherDAOImpl;
import org.example.daos.NotificationDAOImpl;
import org.example.models.Account;
import org.example.models.Voucher;

import java.io.IOException;

/**
 * Trang điểm thưởng (Loyalty Points) của khách hàng — xem điểm hiện có, đổi điểm lấy voucher.
 * URL : /user/diem-thuong
 * JSP : /user/diemThuong.jsp
 */
@WebServlet("/user/diem-thuong")
public class UserLoyaltyServlet extends HttpServlet {

    private static final int POINTS_PER_VOUCHER = 100;
    private static final double VOUCHER_VALUE = 20000;

    private final AccountDAO accountDAO = new AccountDAOImpl();
    private final VoucherDAO voucherDAO = new VoucherDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Account account = requireLogin(req, resp);
        if (account == null) return;

        req.setAttribute("diem", accountDAO.getLoyaltyPoints(account.getId()));
        req.setAttribute("pointsPerVoucher", POINTS_PER_VOUCHER);
        req.setAttribute("voucherValue", VOUCHER_VALUE);
        req.setAttribute("unreadNotifCount", new NotificationDAOImpl().countUnread(account.getId()));
        req.getRequestDispatcher("/user/diemThuong.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Account account = requireLogin(req, resp);
        if (account == null) return;

        if ("redeem".equals(req.getParameter("action"))) {
            int currentPoints = accountDAO.getLoyaltyPoints(account.getId());
            if (currentPoints < POINTS_PER_VOUCHER) {
                req.setAttribute("loi", "Bạn cần ít nhất " + POINTS_PER_VOUCHER + " điểm để đổi voucher (hiện có " + currentPoints + " điểm).");
            } else if (!accountDAO.addLoyaltyPoints(account.getId(), -POINTS_PER_VOUCHER)) {
                req.setAttribute("loi", "Không đủ điểm để đổi (có thể bạn vừa dùng điểm ở nơi khác), vui lòng thử lại.");
            } else {
                Voucher v = new Voucher();
                // Dung nanoTime (do phan giai cao hon currentTimeMillis) de giam toi da nguy co
                // trung ma UNIQUE khi 1 tai khoan doi diem nhieu lan lien tiep trong thoi gian ngan.
                v.setCode("DOIDIEM" + account.getId() + "-" + (System.nanoTime() % 1000000));
                v.setVoucherType("FIXED");
                v.setValue(VOUCHER_VALUE);
                v.setMinOrderValue(0);
                v.setUsageLimit(1);
                v.setActive(true);
                long newVoucherId = voucherDAO.createAndReturnId(v);
                if (newVoucherId <= 0) {
                    // Tao voucher that bai (vd trung ma UNIQUE hy huu) -> HOAN LAI diem da tru,
                    // khong de khach mat diem oan ma khong nhan duoc voucher.
                    accountDAO.addLoyaltyPoints(account.getId(), POINTS_PER_VOUCHER);
                    req.setAttribute("loi", "Đổi điểm thất bại, vui lòng thử lại (điểm của bạn đã được hoàn lại).");
                } else {
                    req.setAttribute("thanhCong", "🎉 Đổi điểm thành công! Mã voucher của bạn: " + v.getCode()
                            + " (giảm " + (long) VOUCHER_VALUE + "đ, dùng 1 lần, nhập ở bước thanh toán).");
                }
            }
        }

        req.setAttribute("diem", accountDAO.getLoyaltyPoints(account.getId()));
        req.setAttribute("pointsPerVoucher", POINTS_PER_VOUCHER);
        req.setAttribute("voucherValue", VOUCHER_VALUE);
        req.setAttribute("unreadNotifCount", new NotificationDAOImpl().countUnread(account.getId()));
        req.getRequestDispatcher("/user/diemThuong.jsp").forward(req, resp);
    }

    private Account requireLogin(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        Account account = session == null ? null : (Account) session.getAttribute("account");
        if (account == null || account.getRoleId() != 3) {
            resp.sendRedirect(req.getContextPath() + "/dangnhap");
            return null;
        }
        return account;
    }
}
