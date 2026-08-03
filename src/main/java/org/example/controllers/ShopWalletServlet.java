package org.example.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.example.daos.*;
import org.example.models.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/shop/vi-tien")
public class ShopWalletServlet extends HttpServlet {

    private final ShopWalletDAO walletDAO = new ShopWalletDAOImpl();
    private final ShopDAO shopDAO = new ShopDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Shop shop = getShop(req, resp);
        if (shop == null) return;

        int page = parsePage(req.getParameter("page"));
        int pageSize = 15;
        int offset = (page - 1) * pageSize;

        ShopWallet wallet = walletDAO.getWallet(shop.getId());
        List<ShopWalletTransaction> transactions = walletDAO.getTransactions(shop.getId(), pageSize, offset);
        int totalTx = walletDAO.countTransactions(shop.getId());
        List<ShopWithdrawal> withdrawals = walletDAO.getWithdrawals(shop.getId());

        req.setAttribute("wallet", wallet);
        req.setAttribute("transactions", transactions);
        req.setAttribute("withdrawals", withdrawals);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", (int) Math.ceil((double) totalTx / pageSize));
        req.setAttribute("shop", shop);
        req.getRequestDispatcher("/shop/viTien.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        Shop shop = getShop(req, resp);
        if (shop == null) return;

        double amount;
        try {
            amount = Double.parseDouble(req.getParameter("amount"));
            // Double.parseDouble("NaN"/"Infinity") khong nem exception nhung tra ve gia tri dac biet
            // ma MOI phep so sanh (<, >) voi no deu tra ve false -> neu khong chan rieng, cac buoc
            // kiem tra "duoi muc toi thieu" va "vuot so du" o duoi se bi bo qua ngam, cho phep gui
            // yeu cau rut tien voi so tien khong hop le.
            if (Double.isNaN(amount) || Double.isInfinite(amount)) {
                amount = 0;
            }
        } catch (Exception e) { amount = 0; }

        String bankName = trim(req.getParameter("bankName"));
        String bankAccountNumber = trim(req.getParameter("bankAccountNumber"));
        String bankAccountHolder = trim(req.getParameter("bankAccountHolder"));

        double balance = walletDAO.getBalance(shop.getId());

        if (amount < 100000) {
            req.setAttribute("error", "Số tiền rút tối thiểu là 100.000đ");
            doGet(req, resp);
            return;
        }
        if (amount > balance) {
            req.setAttribute("error", "Số tiền rút vượt quá số dư khả dụng (" + String.format("%,.0f", balance) + "đ)");
            doGet(req, resp);
            return;
        }
        if (bankName.isEmpty() || bankAccountNumber.isEmpty() || bankAccountHolder.isEmpty()) {
            req.setAttribute("error", "Vui lòng điền đầy đủ thông tin ngân hàng");
            doGet(req, resp);
            return;
        }

        boolean ok = walletDAO.requestWithdrawal(shop.getId(), amount, bankName, bankAccountNumber, bankAccountHolder);
        if (ok) {
            resp.sendRedirect(req.getContextPath() + "/shop/vi-tien?success=1");
        } else {
            req.setAttribute("error", "Yêu cầu rút tiền thất bại. Vui lòng thử lại.");
            doGet(req, resp);
        }
    }

    private Shop getShop(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        Account account = session != null ? (Account) session.getAttribute("account") : null;
        if (account == null || account.getRoleId() != 2) {
            resp.sendRedirect(req.getContextPath() + "/dangnhap");
            return null;
        }
        Shop shop = shopDAO.selectShopByOwnerId(account.getId());
        if (shop == null) {
            resp.sendRedirect(req.getContextPath() + "/dangnhap");
            return null;
        }
        return shop;
    }

    private String trim(String s) { return s == null ? "" : s.trim(); }
    private int parsePage(String s) {
        try { int p = Integer.parseInt(s); return p < 1 ? 1 : p; }
        catch (Exception e) { return 1; }
    }
}
