package org.example.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.example.daos.ShipperProfileDAO;
import org.example.daos.ShipperProfileDAOImpl;
import org.example.daos.ShipperWalletDAO;
import org.example.daos.ShipperWalletDAOImpl;
import org.example.daos.ShipperWithdrawalDAO;
import org.example.daos.ShipperWithdrawalDAOImpl;
import org.example.models.Account;
import org.example.models.ShipperProfile;

import java.io.IOException;

@WebServlet("/shipper/vi-tien")
public class ShipperWalletServlet extends HttpServlet {

    private final ShipperWalletDAO walletDAO = new ShipperWalletDAOImpl();
    private final ShipperWithdrawalDAO withdrawalDAO = new ShipperWithdrawalDAOImpl();
    private final ShipperProfileDAO profileDAO = new ShipperProfileDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Account account = getShipperAccount(req, resp);
        if (account == null) return;

        double balance = walletDAO.getBalance(account.getId());
        req.setAttribute("balance", balance);
        req.setAttribute("account", account);
        req.setAttribute("profile", profileDAO.findByAccountId(account.getId()));
        req.setAttribute("withdrawals", withdrawalDAO.getWithdrawalsByShipper(account.getId()));
        req.getRequestDispatcher("/shipper/viTien.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        Account account = getShipperAccount(req, resp);
        if (account == null) return;

        String amountStr = req.getParameter("amount");

        double amount;
        try {
            amount = Double.parseDouble(amountStr);
            // Double.parseDouble("NaN"/"Infinity") khong nem exception nhung tra ve gia tri dac biet
            // ma MOI phep so sanh (<, >) voi no deu tra ve false -> neu khong chan rieng, cac buoc
            // kiem tra "duoi muc toi thieu" va "vuot so du" o duoi se bi bo qua ngam, cho phep gui
            // yeu cau rut tien voi so tien khong hop le.
            if (Double.isNaN(amount) || Double.isInfinite(amount)) {
                amount = 0;
            }
        } catch (Exception e) {
            amount = 0;
        }

        // Thong tin ngan hang nhan tien rut LUON lay tu ShipperProfile da luu (bankAccount/bankName)
        // + ten chu tai khoan lay theo Account.fullName, KHONG nhan truc tiep tu form rut tien nua -
        // tranh Shipper tu y doi so tai khoan nhan ngay tai form rut ma khong qua xac thuc OTP
        // (xem ShipperProfileServlet, purpose "shipper_vehicle_bank").
        ShipperProfile profile = profileDAO.findByAccountId(account.getId());
        if (profile == null || !profile.isHasBankInfo()) {
            req.setAttribute("error", "Vui lòng cập nhật thông tin ngân hàng ở trang Hồ sơ tài xế trước khi rút tiền");
            req.setAttribute("balance", walletDAO.getBalance(account.getId()));
            req.setAttribute("account", account);
            req.setAttribute("profile", profile);
            req.setAttribute("withdrawals", withdrawalDAO.getWithdrawalsByShipper(account.getId()));
            req.getRequestDispatcher("/shipper/viTien.jsp").forward(req, resp);
            return;
        }
        String bankName = profile.getBankName();
        String bankAccountNumber = profile.getBankAccount();
        String bankAccountHolder = account.getFullName();

        double balance = walletDAO.getBalance(account.getId());

        if (amount < 50000) {
            req.setAttribute("error", "Số tiền rút tối thiểu là 50.000đ");
            req.setAttribute("balance", balance);
            req.setAttribute("account", account);
            req.setAttribute("profile", profile);
            req.setAttribute("withdrawals", withdrawalDAO.getWithdrawalsByShipper(account.getId()));
            req.getRequestDispatcher("/shipper/viTien.jsp").forward(req, resp);
            return;
        }
        if (amount > balance) {
            req.setAttribute("error", "Số tiền rút vượt quá số dư hiện tại");
            req.setAttribute("balance", balance);
            req.setAttribute("account", account);
            req.setAttribute("profile", profile);
            req.setAttribute("withdrawals", withdrawalDAO.getWithdrawalsByShipper(account.getId()));
            req.getRequestDispatcher("/shipper/viTien.jsp").forward(req, resp);
            return;
        }

        boolean ok = walletDAO.requestWithdrawal(account.getId(), amount, bankName, bankAccountNumber, bankAccountHolder);
        if (ok) {
            resp.sendRedirect(req.getContextPath() + "/shipper/vi-tien?success=1");
        } else {
            req.setAttribute("error", "Yêu cầu rút tiền thất bại, vui lòng thử lại");
            req.setAttribute("balance", walletDAO.getBalance(account.getId()));
            req.setAttribute("account", account);
            req.setAttribute("profile", profile);
            req.setAttribute("withdrawals", withdrawalDAO.getWithdrawalsByShipper(account.getId()));
            req.getRequestDispatcher("/shipper/viTien.jsp").forward(req, resp);
        }
    }

    private Account getShipperAccount(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        Account account = session != null ? (Account) session.getAttribute("account") : null;
        if (account == null || account.getRoleId() != 4) {
            resp.sendRedirect(req.getContextPath() + "/dangnhap");
            return null;
        }
        return account;
    }
}
