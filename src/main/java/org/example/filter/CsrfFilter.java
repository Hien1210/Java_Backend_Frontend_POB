package org.example.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.example.utils.CsrfUtil;

import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;

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
                // Token khong khop thuong la do session cu da het han/mat (server redeploy,
                // phien qua 30 phut, hoac form duoc mo o tab/cache cu) chu khong han la
                // tan cong. Thay vi hien trang loi 403 kho hieu, dua nguoi dung quay lai
                // trang vua gui (da co token moi cap o tren) de ho thu lai.
                resp.sendRedirect(resolveSafeRedirect(req));
                return;
            }
        }

        chain.doFilter(request, response);
    }

    /**
     * Chi redirect ve Referer neu cung origin voi server hien tai - Referer la header
     * do client gui nen co the bi gia mao, khong duoc dung truc tiep de tranh open redirect.
     */
    private String resolveSafeRedirect(HttpServletRequest req) {
        String fallback = req.getContextPath() + "/";
        String referer = req.getHeader("Referer");
        if (referer == null || referer.isBlank()) {
            return fallback;
        }
        try {
            URI refererUri = new URI(referer);
            boolean sameOrigin = req.getScheme().equalsIgnoreCase(refererUri.getScheme())
                    && req.getServerName().equalsIgnoreCase(refererUri.getHost())
                    && req.getServerPort() == resolvePort(refererUri);
            return sameOrigin ? referer : fallback;
        } catch (URISyntaxException e) {
            return fallback;
        }
    }

    private int resolvePort(URI uri) {
        if (uri.getPort() != -1) {
            return uri.getPort();
        }
        return "https".equalsIgnoreCase(uri.getScheme()) ? 443 : 80;
    }

    @Override
    public void destroy() {
        Filter.super.destroy();
    }
}
