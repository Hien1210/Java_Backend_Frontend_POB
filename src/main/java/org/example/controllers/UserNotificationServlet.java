package org.example.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.example.daos.NotificationDAO;
import org.example.daos.NotificationDAOImpl;
import org.example.models.Account;
import org.example.models.Notification;

import java.io.IOException;
import java.util.List;

/**
 * Hop thu thong bao cho khach hang (roleId = 3).
 * GET  /user/thong-bao -> danh sach + so chua doc
 * POST /user/thong-bao -> danh dau da doc (1 hoac tat ca)
 */
@WebServlet("/user/thong-bao")
public class UserNotificationServlet extends HttpServlet {

    private final NotificationDAO notificationDAO = new NotificationDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Account account = getAccount(req, resp);
        if (account == null) return;

        List<Notification> notifications = notificationDAO.findByAccountId(account.getId());
        int unreadCount = notificationDAO.countUnread(account.getId());

        req.setAttribute("notifications", notifications);
        req.setAttribute("unreadCount", unreadCount);
        req.getRequestDispatcher("/user/thongBao.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Account account = getAccount(req, resp);
        if (account == null) return;

        String action = req.getParameter("action");
        if ("markAll".equals(action)) {
            notificationDAO.markAllAsRead(account.getId());
        } else {
            String idParam = req.getParameter("id");
            if (idParam != null) {
                try {
                    long id = Long.parseLong(idParam);
                    notificationDAO.markAsRead(id, account.getId());
                } catch (NumberFormatException ignored) {
                }
            }
        }
        resp.sendRedirect(req.getContextPath() + "/user/thong-bao");
    }

    private Account getAccount(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null) {
            resp.sendRedirect(req.getContextPath() + "/dangnhap");
            return null;
        }
        Account account = (Account) session.getAttribute("account");
        if (account == null || account.getRoleId() != 3) {
            resp.sendRedirect(req.getContextPath() + "/dangnhap");
            return null;
        }
        return account;
    }
}
