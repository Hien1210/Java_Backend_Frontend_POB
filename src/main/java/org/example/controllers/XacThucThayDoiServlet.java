package org.example.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.example.daos.AccountDAO;
import org.example.daos.AccountDAOImpl;
import org.example.daos.ShipperProfileDAO;
import org.example.daos.ShipperProfileDAOImpl;
import org.example.daos.ShopDAO;
import org.example.daos.ShopDAOImpl;
import org.example.models.Account;
import org.example.models.ShipperProfile;
import org.example.models.Shop;
import org.example.utils.SensitiveInfoOtpUtil;

import javax.mail.MessagingException;
import java.io.IOException;
import java.util.Map;

/**
 * Xac thuc OTP dung chung khi tai khoan DANG DANG NHAP doi thong tin nhay cam (email, thong tin
 * ngan hang nhan tien...). Cac servlet ho so (ShopHoSoServlet, ShipperHoSoServlet,
 * AdminProfileServlet, ShipperProfileServlet, ShopProfileServlet) khi phat hien truong nhay cam
 * bi doi se KHONG ghi DB ngay ma goi SensitiveInfoOtpUtil.generateAndSend() roi redirect ve day
 * kem "purpose" de nguoi dung nhap OTP xac nhan truoc khi thuc su luu.
 */
@WebServlet("/xac-thuc-thay-doi")
public class XacThucThayDoiServlet extends HttpServlet {

    private static final String VIEW = "/xacThucThayDoi.jsp";

    private final AccountDAO accountDAO = new AccountDAOImpl();
    private final ShopDAO shopDAO = new ShopDAOImpl();
    private final ShipperProfileDAO shipperProfileDAO = new ShipperProfileDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        String purpose = req.getParameter("purpose");
        if (session == null || purpose == null || SensitiveInfoOtpUtil.getPendingData(session, purpose) == null) {
            resp.sendRedirect(req.getContextPath() + originUrl(purpose));
            return;
        }

        req.setAttribute("purpose", purpose);
        req.setAttribute("maskedEmail", maskEmail(SensitiveInfoOtpUtil.getPendingEmail(session, purpose)));
        Long expiredAt = SensitiveInfoOtpUtil.getExpiry(session, purpose);
        req.setAttribute("otpExpiredAt", expiredAt != null ? expiredAt : 0L);
        req.getRequestDispatcher(VIEW).forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession(false);
        String purpose = req.getParameter("purpose");
        if (session == null || purpose == null) {
            resp.sendRedirect(req.getContextPath() + originUrl(purpose));
            return;
        }

        Map<String, String> pending = SensitiveInfoOtpUtil.getPendingData(session, purpose);
        if (pending == null) {
            resp.sendRedirect(req.getContextPath() + originUrl(purpose));
            return;
        }

        if ("resend".equals(req.getParameter("action"))) {
            String email = SensitiveInfoOtpUtil.getPendingEmail(session, purpose);
            try {
                SensitiveInfoOtpUtil.generateAndSend(session, purpose, email, pending);
            } catch (MessagingException e) {
                e.printStackTrace();
            }
            resp.sendRedirect(req.getContextPath() + "/xac-thuc-thay-doi?purpose=" + purpose + "&resent=1");
            return;
        }

        String otp = safe(req.getParameter("otp1")) + safe(req.getParameter("otp2")) + safe(req.getParameter("otp3"))
                + safe(req.getParameter("otp4")) + safe(req.getParameter("otp5")) + safe(req.getParameter("otp6"));

        SensitiveInfoOtpUtil.VerifyResult result = SensitiveInfoOtpUtil.verify(session, purpose, otp);
        switch (result) {
            case OK:
                SensitiveInfoOtpUtil.clear(session, purpose);
                applyPendingChange(req, session, purpose, pending);
                resp.sendRedirect(req.getContextPath() + originUrl(purpose) + "?success=1");
                return;
            case EXPIRED:
                resp.sendRedirect(req.getContextPath() + originUrl(purpose) + "?error=otp_expired");
                return;
            case LOCKED:
                resp.sendRedirect(req.getContextPath() + originUrl(purpose) + "?error=otp_locked");
                return;
            case NOT_FOUND:
                resp.sendRedirect(req.getContextPath() + originUrl(purpose));
                return;
            default:
                req.setAttribute("purpose", purpose);
                req.setAttribute("maskedEmail", maskEmail(SensitiveInfoOtpUtil.getPendingEmail(session, purpose)));
                Long expWrong = SensitiveInfoOtpUtil.getExpiry(session, purpose);
                req.setAttribute("otpExpiredAt", expWrong != null ? expWrong : 0L);
                req.setAttribute("loi", "Mã OTP không chính xác!");
                req.getRequestDispatcher(VIEW).forward(req, resp);
        }
    }

    private void applyPendingChange(HttpServletRequest req, HttpSession session, String purpose, Map<String, String> data) {
        switch (purpose) {
            case "shop_hoso":
            case "shipper_hoso":
            case "admin_profile":
            case "shipper_profile_info":
            case "user_hoso": {
                Account account = (Account) session.getAttribute("account");
                if (account == null) return;
                Account fresh = accountDAO.findById(account.getId());
                if (fresh == null) return;
                fresh.setFullName(data.get("fullName"));
                fresh.setPhone(data.get("phone"));
                fresh.setEmail(data.get("email"));
                if (data.get("avatarUrl") != null && !data.get("avatarUrl").isEmpty()) {
                    fresh.setAvatarUrl(data.get("avatarUrl"));
                }
                accountDAO.update(fresh);
                session.setAttribute("account", fresh);
                return;
            }
            case "shop_bank": {
                Account account = (Account) session.getAttribute("account");
                if (account == null) return;
                Shop shop = shopDAO.selectShopByOwnerId(account.getId());
                if (shop == null) return;
                shop.setShopName(data.get("shopName"));
                shop.setShopDescription(data.get("shopDescription"));
                shop.setShopAddress(data.get("shopAddress"));
                shop.setShopPhone(data.get("shopPhone"));
                shop.setShopLogo(data.get("shopLogo"));
                shop.setClientKey(data.get("clientKey"));
                shop.setApiKey(data.get("apiKey"));
                shop.setCheckSumKey(data.get("checkSumKey"));
                shop.setLocationX(parseDoubleOrNull(data.get("shopLocationX")));
                shop.setLocationY(parseDoubleOrNull(data.get("shopLocationY")));
                shop.setOpenTime(parseTimeOrNull(data.get("openTime")));
                shop.setCloseTime(parseTimeOrNull(data.get("closeTime")));
                shopDAO.updateShop(shop);
                shopDAO.updateBankInfo(shop.getId(), data.get("bankCode"), data.get("bankAccountNumber"), data.get("bankAccountName"));
                req.getSession().setAttribute("currentShop", shop);
                return;
            }
            case "shipper_vehicle_bank": {
                Account account = (Account) session.getAttribute("account");
                if (account == null) return;
                ShipperProfile profile = new ShipperProfile();
                profile.setAccountId(account.getId());
                profile.setCccd(emptyToNull(data.get("cccd")));
                profile.setLicenseNumber(emptyToNull(data.get("licenseNumber")));
                profile.setVehicleType(data.get("vehicleType"));
                profile.setVehiclePlate(data.get("vehiclePlate"));
                profile.setVehicleModel(emptyToNull(data.get("vehicleModel")));
                profile.setBankAccount(emptyToNull(data.get("bankAccount")));
                profile.setBankName(emptyToNull(data.get("bankName")));
                shipperProfileDAO.save(profile);
                return;
            }
            default:
        }
    }

    private String originUrl(String purpose) {
        if (purpose == null) return "/";
        switch (purpose) {
            case "shop_hoso": return "/shop/ho-so";
            case "shipper_hoso": return "/shipper/ho-so";
            case "admin_profile": return "/admin/profile";
            case "user_hoso": return "/user/thong-tin-ca-nhan";
            case "shipper_profile_info":
            case "shipper_vehicle_bank": return "/shipper/profile";
            case "shop_bank": return "/shop/profile";
            default: return "/";
        }
    }

    private String maskEmail(String email) {
        if (email == null || email.isEmpty()) return "";
        int at = email.indexOf('@');
        if (at > 3) return email.substring(0, 3) + "***" + email.substring(at);
        if (at > 0) return email.substring(0, 1) + "***" + email.substring(at);
        return email;
    }

    private String safe(String v) {
        return v == null ? "" : v;
    }

    private String emptyToNull(String v) {
        return (v == null || v.isEmpty()) ? null : v;
    }

    private Double parseDoubleOrNull(String v) {
        try {
            return (v == null || v.isEmpty()) ? null : Double.parseDouble(v);
        } catch (Exception e) {
            return null;
        }
    }

    private java.time.LocalTime parseTimeOrNull(String v) {
        try {
            return (v == null || v.isEmpty()) ? null
                    : java.time.LocalTime.parse(v, java.time.format.DateTimeFormatter.ofPattern("HH:mm"));
        } catch (Exception e) {
            return null;
        }
    }
}
