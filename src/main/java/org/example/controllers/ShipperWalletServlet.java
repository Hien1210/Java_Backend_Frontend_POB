package org.example.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.example.daos.ShipperWalletDAO;
import org.example.daos.ShipperWalletDAOImpl;
import org.example.models.Account;

import java.io.IOException;

@WebServlet("/shipper/vi-tien")
public class ShipperWalletServlet extends HttpServlet {

    private final ShipperWalletDAO walletDAO = new ShipperWalletDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Account account = getShipperAccount(req, resp);
        if (account == null) return;

        double balance = walletDAO.getBalance(account.getId());
        req.setAttribute("balance", balance);
        req.setAttribute("account", account);
        req.getRequestDispatcher("/shipper/viTien.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        Account account = getShipperAccount(req, resp);
        if (account == null) return;

        String amountStr = req.getParameter("amount");
        String bankName = trim(req.getParameter("bankName"));
        String bankAccountNumber = trim(req.getParameter("bankAccountNumber"));
        String bankAccountHolder = trim(req.getParameter("bankAccountHolder"));

        double amount;
        try {
            amount = Double.parseDouble(amountStr);
        } catch (Exception e) {
            amount = 0;
        }

        double balance = walletDAO.getBalance(account.getId());

        if (amount < 50000) {
            req.setAttribute("error", "Số tiền rút tối thiểu là 50.000đ");
            req.setAttribute("balance", balance);
            req.setAttribute("account", account);
            req.getRequestDispatcher("/shipper/viTien.jsp").forward(req, resp);
            return;
        }
        if (amount > balance) {
            req.setAttribute("error", "Số tiền rút vượt quá số dư hiện tại");
            req.setAttribute("balance", balance);
            req.setAttribute("account", account);
            req.getRequestDispatcher("/shipper/viTien.jsp").forward(req, resp);
            return;
        }
        if (bankName.isEmpty() || bankAccountNumber.isEmpty() || bankAccountHolder.isEmpty()) {
            req.setAttribute("error", "Vui lòng điền đầy đủ thông tin ngân hàng");
            req.setAttribute("balance", balance);
            req.setAttribute("account", account);
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
            req.getRequestDispatcher("/shipper/viTien.jsp").forward(req, resp);
        }
    }

    private Account getShipperAccount(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        Account account = session != null ? (Account) session.getAttribute("account") : null;
        if (account == null || !"SHIPPER".equals(account.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/dangnhap");
            return null;
        }
        return account;
    }

    private String trim(String s) {
        return s == null ? "" : s.trim();
    }
}
