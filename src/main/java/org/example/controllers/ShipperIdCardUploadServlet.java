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

import java.io.IOException;

/**
 * Nhan URL anh giay to tuy than (CCCD/CMND) da upload len Cloudinary tu client
 * (dung chung 1 cloud/preset voi avatar, xem hoSoShipper.jsp/hosotaixe.jsp) va luu vao Shipper_Profiles.
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

        String imageUrl = req.getParameter("imageUrl");
        if (imageUrl == null || imageUrl.isBlank() || !imageUrl.startsWith("https://res.cloudinary.com/")) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        boolean ok = profileDAO.updateIdCardImageUrl(account.getId(), imageUrl);
        resp.setStatus(ok ? HttpServletResponse.SC_OK : HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
    }
}
