package org.example.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.example.daos.ShipperProfileDAO;
import org.example.daos.ShipperProfileDAOImpl;
import org.example.models.Account;
import org.example.utils.UploadValidationUtil;

import java.io.IOException;

/**
 * Nhan URL anh CCCD/CMND (mat truoc/mat sau) da upload len Cloudinary tu client
 * (dung chung 1 cloud/preset voi avatar, xem hosotaixe.jsp) va luu vao Shipper_Profiles.
 * Tham so "side" bat buoc, chi nhan "front" hoac "back".
 */
@WebServlet("/shipper/upload-id-card")
public class ShipperIdCardUploadServlet extends HttpServlet {

    private final ShipperProfileDAO profileDAO = new ShipperProfileDAOImpl();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("account") == null) {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }
        Account account = (Account) session.getAttribute("account");
        if (account.getRoleId() != 4) {
            resp.setStatus(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String side = req.getParameter("side");
        boolean isFront;
        if ("front".equals(side)) {
            isFront = true;
        } else if ("back".equals(side)) {
            isFront = false;
        } else {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        if ("delete".equals(req.getParameter("action"))) {
            // Xoa anh da lo upload nham, khong bat buoc Online vi day chi la sua loi, khong phai nop giay to.
            boolean ok = isFront
                    ? profileDAO.updateIdCardFrontUrl(account.getId(), null)
                    : profileDAO.updateIdCardBackUrl(account.getId(), null);
            resp.setStatus(ok ? HttpServletResponse.SC_OK : HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            return;
        }

        if (!account.isOnline()) {
            // Bat buoc Shipper phai Online moi duoc upload giay to, de Super Admin biet
            // thoi diem upload la luc tai khoan dang thuc su hoat dong tren he thong.
            resp.setStatus(HttpServletResponse.SC_CONFLICT);
            resp.getWriter().write("OFFLINE");
            return;
        }

        String imageUrl = req.getParameter("imageUrl");
        if (!UploadValidationUtil.isValidCloudinaryImageUrl(imageUrl)) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        boolean ok = isFront
                ? profileDAO.updateIdCardFrontUrl(account.getId(), imageUrl)
                : profileDAO.updateIdCardBackUrl(account.getId(), imageUrl);
        if (ok) {
            // Neu ho so dang bi tu choi (REJECTED), Shipper vua nop lai anh moi -> dua ve PENDING
            // de xuat hien lai trong hang cho SuperAdmin duyet, tranh bi khoa vinh vien.
            profileDAO.resetToPendingIfRejected(account.getId());
        }
        resp.setStatus(ok ? HttpServletResponse.SC_OK : HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
    }
}
