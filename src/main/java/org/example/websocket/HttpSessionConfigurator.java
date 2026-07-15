package org.example.websocket;

import jakarta.servlet.http.HttpSession;
import jakarta.websocket.HandshakeResponse;
import jakarta.websocket.server.HandshakeRequest;
import jakarta.websocket.server.ServerEndpointConfig;
import org.example.models.Account;

public class HttpSessionConfigurator extends ServerEndpointConfig.Configurator {

    @Override
    public void modifyHandshake(ServerEndpointConfig sec, HandshakeRequest request, HandshakeResponse response) {
        Object httpSessionObj = request.getHttpSession();
        if (httpSessionObj instanceof HttpSession) {
            HttpSession httpSession = (HttpSession) httpSessionObj;
            Object accountObj = httpSession.getAttribute("account");
            if (accountObj instanceof Account) {
                sec.getUserProperties().put("currentAccountId", ((Account) accountObj).getId());
            }
        }
    }
}
