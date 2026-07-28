package org.example.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.example.utils.CsrfUtil;

import java.io.IOException;

/**
 * Chan CSRF cho moi request POST theo Synchronizer Token Pattern.
 * Token duoc sinh 1 lan cho ca session (ke ca session an danh truoc dang nhap)
 * va duoc doi chieu voi gia tri gui kem trong form/AJAX o moi request POST.
 * Ngoai le duy nhat: /payos/webhook - day la endpoint server-to-server (PayOS
 * goi thang, khong co session trinh duyet), da tu xac thuc rieng bang chu ky HMAC.
 */
@WebFilter(urlPatterns = "/*")
public class CsrfFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        Filter.super.init(filterConfig);
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        String uri = req.getRequestURI();
        if (uri.equals(req.getContextPath() + "/payos/webhook")) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = req.getSession(true);
        CsrfUtil.ensureToken(session);

        if ("POST".equalsIgnoreCase(req.getMethod())) {
            String submitted = req.getParameter("csrfToken");
            if (submitted == null) {
                submitted = req.getHeader("X-CSRF-Token");
            }
            if (!CsrfUtil.isValid(session, submitted)) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN, "CSRF token khong hop le hoac bi thieu.");
                return;
            }
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        Filter.super.destroy();
    }
}
