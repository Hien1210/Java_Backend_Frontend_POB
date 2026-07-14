package org.example.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.daos.AppealDAO;
import org.example.daos.AppealDAOImpl;

import java.io.IOException;

@WebServlet("/appeal")
public class AppealServlet extends HttpServlet {

    private final AppealDAO dao = new AppealDAOImpl();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        String accountIdStr = req.getParameter("accountId");
        String message = req.getParameter("message");


        if (accountIdStr == null || message == null || message.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/dangnhap?appealError=empty");
            return;
        }

        long accountId;
        try {
            accountId = Long.parseLong(accountIdStr);
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/dangnhap?appealError=invalid");
            return;
        }

        // Kiểm tra đã có kháng nghị đang chờ chưa
        if (dao.hasPendingAppeal(accountId)) {
            resp.sendRedirect(req.getContextPath() + "/dangnhap?appealError=duplicate");
            return;
        }

        boolean ok = dao.submit(accountId, message.trim());
        if (ok) {
            resp.sendRedirect(req.getContextPath() + "/dangnhap?appealSent=1");
        } else {
            resp.sendRedirect(req.getContextPath() + "/dangnhap?appealError=fail");
        }
    }
}
