package org.example.websocket;

import jakarta.servlet.http.HttpSession;
import jakarta.websocket.HandshakeResponse;
import jakarta.websocket.server.HandshakeRequest;
import jakarta.websocket.server.ServerEndpointConfig;
import org.example.models.Account;

import java.util.List;
import java.util.Map;

public class HttpSessionConfigurator extends ServerEndpointConfig.Configurator {

    @Override
    public void modifyHandshake(ServerEndpointConfig sec, HandshakeRequest request, HandshakeResponse response) {
        // Chong CSWSH (Cross-Site WebSocket Hijacking): neu co header Origin va host cua no
        // khac voi host dang phuc vu request nay, coi nhu handshake tu nguon khong tin cay va
        // KHONG set currentAccountId -> TrackingEndpoint.onOpen se coi la unauthorized (-1L) va
        // dong ket noi. Neu khong co header Origin (client khong phai trinh duyet, hoac mot so
        // truong hop same-origin khong gui Origin) thi van cho qua nhu truoc.
        if (!isSameOriginOrAbsent(request)) {
            return;
        }

        Object httpSessionObj = request.getHttpSession();
        if (httpSessionObj instanceof HttpSession) {
            HttpSession httpSession = (HttpSession) httpSessionObj;
            Object accountObj = httpSession.getAttribute("account");
            if (accountObj instanceof Account) {
                sec.getUserProperties().put("currentAccountId", ((Account) accountObj).getId());
            }
        }
    }

    private boolean isSameOriginOrAbsent(HandshakeRequest request) {
        Map<String, List<String>> headers = request.getHeaders();
        String origin = firstHeader(headers, "Origin");
        if (origin == null || origin.isEmpty()) {
            return true;
        }
        String host = firstHeader(headers, "Host");
        if (host == null || host.isEmpty()) {
            return true;
        }
        String originHost = extractHost(origin);
        return originHost != null && originHost.equalsIgnoreCase(host);
    }

    private String firstHeader(Map<String, List<String>> headers, String name) {
        if (headers == null) {
            return null;
        }
        for (Map.Entry<String, List<String>> entry : headers.entrySet()) {
            if (entry.getKey() != null && entry.getKey().equalsIgnoreCase(name)) {
                List<String> values = entry.getValue();
                return (values != null && !values.isEmpty()) ? values.get(0) : null;
            }
        }
        return null;
    }

    private String extractHost(String originHeaderValue) {
        try {
            String withoutScheme = originHeaderValue.replaceFirst("^[a-zA-Z][a-zA-Z0-9+.-]*://", "");
            int slashIdx = withoutScheme.indexOf('/');
            return slashIdx >= 0 ? withoutScheme.substring(0, slashIdx) : withoutScheme;
        } catch (Exception e) {
            return null;
        }
    }
}
