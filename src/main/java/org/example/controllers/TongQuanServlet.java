package org.example.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.daos.*;
import org.example.models.Account;
import org.example.models.DailyOrderStat;
import org.example.models.Shop;
import org.example.models.ShopRevenueStat;

import java.io.IOException;
import java.util.List;

@WebServlet("/tong-quan")
public class TongQuanServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        AccountDAO accountDAO = new AccountDAOImpl();
        ShopDAO shopDAO = new ShopDAOImpl();
        FeedbackDAO feedbackDAO = new FeedbackDAOImpl();

        // * ĐÃ THAY BẰNG HÀM GỌI DB
        int tongTaiKhoan = accountDAO.getTotalAccounts();
        int shopChoDuyet = shopDAO.countPendingShops();
        int shipperHoatDong = accountDAO.countActiveShippers();
        List<Account> top5Shop = accountDAO.findTop5PendingShopAccounts();
        double tongDoanhThuSan = shopDAO.getTotalRevenue();
        List<ShopRevenueStat> top5ShopDoanhThu = shopDAO.findTop5ShopsByRevenue();
        List<DailyOrderStat> thongKeTheoNgay = shopDAO.findDailyOrderStats(7);

        // Canh bao vi pham = shop bi khoa + tai khoan bi dinh chi/khoa + danh gia thap (<=2 sao)
        int canhBaoViPham = shopDAO.countBlockedShops()
                + accountDAO.countSuspendedAccounts()
                + feedbackDAO.countLowRatingFeedback(2);

        req.setAttribute("tongTaiKhoan", tongTaiKhoan);
        req.setAttribute("shopChoDuyet", shopChoDuyet);
        req.setAttribute("shipperHoatDong", shipperHoatDong);
        req.setAttribute("top5Shop", top5Shop);
        req.setAttribute("tongDoanhThuSan", tongDoanhThuSan);
        req.setAttribute("top5ShopDoanhThu", top5ShopDoanhThu);
        req.setAttribute("canhBaoViPham", canhBaoViPham);
        req.setAttribute("thongKeTheoNgay", thongKeTheoNgay);

        req.getRequestDispatcher("/admin/TongQuanHeThong.jsp").forward(req, resp);

    }
}
