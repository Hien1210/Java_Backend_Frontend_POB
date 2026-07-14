package org.example.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.example.daos.UserAddressDAO;
import org.example.daos.UserAddressDAOImpl;
import org.example.models.Account;
import org.example.models.UserAddress;

import java.io.IOException;

/**
 * Quản lý địa chỉ giao hàng của User
 * GET  /user/dia-chi              → danh sách
 * POST /user/dia-chi?action=create → thêm mới
 * POST /user/dia-chi?action=update → cập nhật
 * POST /user/dia-chi?action=delete → xóa
 * POST /user/dia-chi?action=setDefault → đặt làm mặc định
 */
@WebServlet("/user/dia-chi")
public class UserAddressServlet extends HttpServlet {

    private final UserAddressDAO addressDAO = new UserAddressDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Account account = getUser(req, resp);
        if (account == null) return;

        req.setAttribute("addresses", addressDAO.findByAccountId(account.getId()));
        req.getRequestDispatcher("/user/diaChi.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        Account account = getUser(req, resp);
        if (account == null) return;

        String action = req.getParameter("action");

        switch (action == null ? "" : action) {
            case "create": {
                String label         = req.getParameter("label");
                String fullAddress   = req.getParameter("fullAddress");
                String receiverName  = req.getParameter("receiverName");
                String receiverPhone = req.getParameter("receiverPhone");
                boolean isDefault    = "true".equals(req.getParameter("isDefault"));

                if (isEmpty(fullAddress) || isEmpty(receiverName) || isEmpty(receiverPhone)) {
                    resp.sendRedirect(req.getContextPath() + "/user/dia-chi?error=missing");
                    return;
                }

                UserAddress a = new UserAddress();
                a.setAccountId(account.getId());
                a.setLabel(label != null ? label : "Nhà");
                a.setFullAddress(fullAddress);
                a.setReceiverName(receiverName);
                a.setReceiverPhone(receiverPhone);
                a.setDefault(isDefault);

                // Nếu đặt làm mặc định → bỏ mặc định cũ trước
                if (isDefault) addressDAO.setDefault(0, account.getId()); // reset all
                addressDAO.create(a);

                // Nếu đây là địa chỉ đầu tiên → tự động set default
                if (addressDAO.findByAccountId(account.getId()).size() == 1) {
                    UserAddress first = addressDAO.findByAccountId(account.getId()).get(0);
                    addressDAO.setDefault(first.getId(), account.getId());
                }

                resp.sendRedirect(req.getContextPath() + "/user/dia-chi?success=created");
                break;
            }
            case "update": {
                long id              = Long.parseLong(req.getParameter("id"));
                String label         = req.getParameter("label");
                String fullAddress   = req.getParameter("fullAddress");
                String receiverName  = req.getParameter("receiverName");
                String receiverPhone = req.getParameter("receiverPhone");

                if (isEmpty(fullAddress) || isEmpty(receiverName) || isEmpty(receiverPhone)) {
                    resp.sendRedirect(req.getContextPath() + "/user/dia-chi?error=missing");
                    return;
                }

                UserAddress a = new UserAddress();
                a.setId(id);
                a.setAccountId(account.getId());
                a.setLabel(label != null ? label : "Nhà");
                a.setFullAddress(fullAddress);
                a.setReceiverName(receiverName);
                a.setReceiverPhone(receiverPhone);

                addressDAO.update(a);
                resp.sendRedirect(req.getContextPath() + "/user/dia-chi?success=updated");
                break;
            }
            case "delete": {
                long id = Long.parseLong(req.getParameter("id"));
                // Kiểm tra địa chỉ thuộc đúng user
                UserAddress a = addressDAO.findById(id);
                if (a != null && a.getAccountId() == account.getId()) {
                    addressDAO.delete(id);
                }
                resp.sendRedirect(req.getContextPath() + "/user/dia-chi?success=deleted");
                break;
            }
            case "setDefault": {
                long id = Long.parseLong(req.getParameter("id"));
                addressDAO.setDefault(id, account.getId());
                resp.sendRedirect(req.getContextPath() + "/user/dia-chi?success=default");
                break;
            }
            default:
                resp.sendRedirect(req.getContextPath() + "/user/dia-chi");
        }
    }

    private Account getUser(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null) { resp.sendRedirect(req.getContextPath() + "/dangnhap"); return null; }
        Account account = (Account) session.getAttribute("account");
        if (account == null || account.getRoleId() != 3) {
            resp.sendRedirect(req.getContextPath() + "/dangnhap");
            return null;
        }
        return account;
    }

    private boolean isEmpty(String s) {
        return s == null || s.trim().isEmpty();
    }
}
