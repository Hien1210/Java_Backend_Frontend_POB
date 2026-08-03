package org.example.utils;

import jakarta.servlet.http.HttpSession;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.SecureRandom;
import java.util.Base64;

public class CsrfUtil {

    private static final String SESSION_ATTR = "csrfToken";
    private static final SecureRandom RANDOM = new SecureRandom();

    private CsrfUtil() {
    }

    public static String generateToken() {
        byte[] bytes = new byte[32];
        RANDOM.nextBytes(bytes);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
    }

    public static String ensureToken(HttpSession session) {
        String token = (String) session.getAttribute(SESSION_ATTR);
        if (token == null) {
            token = generateToken();
            session.setAttribute(SESSION_ATTR, token);
        }
        return token;
    }

    public static boolean isValid(HttpSession session, String submittedToken) {
        if (session == null || submittedToken == null) {
            return false;
        }
        String sessionToken = (String) session.getAttribute(SESSION_ATTR);
        if (sessionToken == null) {
            return false;
        }
        return MessageDigest.isEqual(
                sessionToken.getBytes(StandardCharsets.UTF_8),
                submittedToken.getBytes(StandardCharsets.UTF_8)
        );
    }
}
