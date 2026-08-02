package org.example.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.example.daos.VoucherDAO;
import org.example.daos.VoucherDAOImpl;
import org.example.models.Account;
import org.example.models.Voucher;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

/**
 * Quản lý Voucher / mã giảm giá (Super Admin).
 * URL : /admin/vouchers
 * JSP : /admin/QuanLyVoucher.jsp
 */
@WebServlet("/admin/vouchers")
public class VoucherServlet extends HttpServlet {

    private static final String VIEW = "/admin/QuanLyVoucher.jsp";
    private static final DateTimeFormatter DATETIME_LOCAL = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");

    private final VoucherDAO voucherDAO = new VoucherDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Account account = requireAdmin(req, resp);
        if (account == null) return;

        List<Voucher> vouchers = voucherDAO.findAll();
        req.setAttribute("vouchers", vouchers);
        req.getRequestDispatcher(VIEW).forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        Account account = requireAdmin(req, resp);
        if (account == null) return;

        String action = normalize(req.getParameter("action"));
        switch (action) {
            case "create":
                createVoucher(req, resp);
                break;
            case "update":
                updateVoucher(req, resp);
                break;
            case "toggle":
                toggleVoucher(req, resp);
                break;
            case "delete":
                deleteVoucher(req, resp);
                break;
            default:
                resp.sendRedirect(req.getContextPath() + "/admin/vouchers");
        }
    }

    private void createVoucher(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Voucher v = readForm(req);
        String error = validate(v);
        if (error != null) {
            showError(req, resp, error, v, "create");
            return;
        }
        if (voucherDAO.findByCode(v.getCode()) != null) {
            showError(req, resp, "Mã \"" + v.getCode() + "\" đã tồn tại, vui lòng chọn mã khác!", v, "create");
            return;
        }
        voucherDAO.createAndReturnId(v);
        resp.sendRedirect(req.getContextPath() + "/admin/vouchers?success=create");
    }

    private void updateVoucher(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        long id = parseLong(req.getParameter("id"));
        Voucher existing = id > 0 ? voucherDAO.findById(id) : null;
        if (existing == null) {
            showError(req, resp, "Không tìm thấy voucher!", null, "create");
            return;
        }
        Voucher v = readForm(req);
        v.setId(id);
        v.setUsedCount(existing.getUsedCount());
        String error = validate(v);
        if (error != null) {
            showError(req, resp, error, v, "update");
            return;
        }
        Voucher dup = voucherDAO.findByCode(v.getCode());
        if (dup != null && dup.getId() != id) {
            showError(req, resp, "Mã \"" + v.getCode() + "\" đã được dùng bởi voucher khác!", v, "update");
            return;
        }
        voucherDAO.update(v);
        resp.sendRedirect(req.getContextPath() + "/admin/vouchers?success=update");
    }

    private void toggleVoucher(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        long id = parseLong(req.getParameter("id"));
        Voucher v = id > 0 ? voucherDAO.findById(id) : null;
        if (v != null) {
            voucherDAO.setActive(id, !v.isActive());
        }
        resp.sendRedirect(req.getContextPath() + "/admin/vouchers?success=toggle");
    }

    private void deleteVoucher(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        long id = parseLong(req.getParameter("id"));
        if (id > 0) voucherDAO.delete(id);
        resp.sendRedirect(req.getContextPath() + "/admin/vouchers?success=delete");
    }

    private Voucher readForm(HttpServletRequest req) {
        Voucher v = new Voucher();
        v.setCode(normalize(req.getParameter("code")).toUpperCase());
        v.setVoucherType(normalize(req.getParameter("voucherType")));
        v.setValue(parseDouble(req.getParameter("value"), 0));
        v.setMinOrderValue(parseDouble(req.getParameter("minOrderValue"), 0));
        String maxDiscountRaw = normalize(req.getParameter("maxDiscount"));
        v.setMaxDiscount(maxDiscountRaw.isEmpty() ? null : parseDouble(maxDiscountRaw, 0));
        String usageLimitRaw = normalize(req.getParameter("usageLimit"));
        v.setUsageLimit(usageLimitRaw.isEmpty() ? null : (int) parseDouble(usageLimitRaw, 0));
        v.setStartDate(parseDateTimeOrNull(req.getParameter("startDate")));
        v.setEndDate(parseDateTimeOrNull(req.getParameter("endDate")));
        v.setActive(true);
        return v;
    }

    private String validate(Voucher v) {
        if (v.getCode().isEmpty()) return "Vui lòng nhập mã voucher!";
        if (!v.getCode().matches("[A-Z0-9_-]{3,50}")) {
            return "Mã voucher chỉ gồm chữ in hoa/số/gạch ngang, từ 3-50 ký tự!";
        }
        if (!"PERCENT".equals(v.getVoucherType()) && !"FIXED".equals(v.getVoucherType()) && !"FREESHIP".equals(v.getVoucherType())) {
            return "Loại voucher không hợp lệ!";
        }
        if ("FREESHIP".equals(v.getVoucherType())) {
            v.setValue(0); // FREESHIP khong dung "value", tranh nham lan tren giao dien quan ly
        } else if (v.getValue() <= 0) {
            return "Giá trị giảm phải lớn hơn 0!";
        }
        if ("PERCENT".equals(v.getVoucherType()) && v.getValue() > 100) {
            return "Giảm theo % không được vượt quá 100%!";
        }
        if (v.getMinOrderValue() < 0) return "Giá trị đơn tối thiểu không hợp lệ!";
        if (v.getMaxDiscount() != null && v.getMaxDiscount() < 0) return "Giảm tối đa không được âm!";
        if (v.getUsageLimit() != null && v.getUsageLimit() <= 0) return "Giới hạn lượt dùng phải lớn hơn 0!";
        if (v.getStartDate() != null && v.getEndDate() != null && v.getEndDate().isBefore(v.getStartDate())) {
            return "Ngày kết thúc phải sau ngày bắt đầu!";
        }
        return null;
    }

    private void showError(HttpServletRequest req, HttpServletResponse resp, String error, Voucher formVoucher, String formAction)
            throws ServletException, IOException {
        req.setAttribute("loi", error);
        req.setAttribute("vouchers", voucherDAO.findAll());
        req.setAttribute("voucherForm", formVoucher);
        req.setAttribute("formAction", formAction);
        req.getRequestDispatcher(VIEW).forward(req, resp);
    }

    private Account requireAdmin(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        Account account = session == null ? null : (Account) session.getAttribute("account");
        if (account == null || account.getRoleId() != 1) {
            resp.sendRedirect(req.getContextPath() + "/dangnhap");
            return null;
        }
        return account;
    }

    private String normalize(String s) { return s == null ? "" : s.trim(); }

    private long parseLong(String s) {
        try { return Long.parseLong(s); } catch (Exception e) { return 0; }
    }

    private double parseDouble(String s, double def) {
        try { return s == null || s.trim().isEmpty() ? def : Double.parseDouble(s.trim()); } catch (Exception e) { return def; }
    }

    private LocalDateTime parseDateTimeOrNull(String value) {
        try {
            String v = normalize(value);
            return v.isEmpty() ? null : LocalDateTime.parse(v, DATETIME_LOCAL);
        } catch (Exception e) {
            return null;
        }
    }
}
