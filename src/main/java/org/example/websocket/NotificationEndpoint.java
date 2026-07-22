package org.example.websocket;

import jakarta.websocket.CloseReason;
import jakarta.websocket.EndpointConfig;
import jakarta.websocket.OnClose;
import jakarta.websocket.OnError;
import jakarta.websocket.OnOpen;
import jakarta.websocket.Session;
import jakarta.websocket.server.ServerEndpoint;
import org.example.models.Notification;
import org.json.JSONObject;

import java.io.IOException;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.CopyOnWriteArraySet;

/**
 * Day thong bao (Notifications) realtime toi dung tai khoan dang mo trang (khach hang/shipper).
 * Khong nhan tin nhan tu client — client chi lang nghe. Viec tao thong bao trong DB van la
 * NotificationDAOImpl.create(), sau khi insert thanh cong se goi NotificationEndpoint.push(...)
 * de day qua WebSocket cho cac session dang mo cua dung tai khoan do (neu co).
 */
@ServerEndpoint(value = "/ws/notifications", configurator = HttpSessionConfigurator.class)
public class NotificationEndpoint {

    private static final Map<Long, Set<Session>> sessionsByAccount = new ConcurrentHashMap<>();

    @OnOpen
    public void onOpen(Session session, EndpointConfig config) {
        Object accountIdObj = config.getUserProperties().get("currentAccountId");
        if (!(accountIdObj instanceof Long)) {
            closeQuietly(session, "unauthorized");
            return;
        }
        long accountId = (Long) accountIdObj;
        session.getUserProperties().put("accountId", accountId);
        sessionsByAccount.computeIfAbsent(accountId, k -> new CopyOnWriteArraySet<>()).add(session);
    }

    @OnClose
    public void onClose(Session session) {
        Object accountIdObj = session.getUserProperties().get("accountId");
        if (!(accountIdObj instanceof Long)) {
            return;
        }
        long accountId = (Long) accountIdObj;
        Set<Session> sessions = sessionsByAccount.get(accountId);
        if (sessions != null) {
            sessions.remove(session);
            sessionsByAccount.computeIfPresent(accountId, (k, v) -> v.isEmpty() ? null : v);
        }
    }

    @OnError
    public void onError(Session session, Throwable throwable) {
        // Khong can xu ly gi them - container se tu dong session loi.
    }

    /** Goi sau khi 1 Notification da INSERT thanh cong vao DB, de day realtime toi dung tai khoan. */
    public static void push(Notification notification, int unreadCount) {
        Set<Session> sessions = sessionsByAccount.get(notification.getAccountId());
        if (sessions == null || sessions.isEmpty()) {
            return;
        }
        String payload = new JSONObject()
                .put("id", notification.getId())
                .put("title", notification.getTitle())
                .put("message", notification.getMessage())
                .put("unreadCount", unreadCount)
                .toString();
        for (Session session : sessions) {
            sendQuietly(session, payload);
        }
    }

    private static void closeQuietly(Session session, String reason) {
        try {
            session.close(new CloseReason(CloseReason.CloseCodes.CANNOT_ACCEPT, reason));
        } catch (IOException ignored) {
        }
    }

    private static void sendQuietly(Session session, String payload) {
        try {
            session.getBasicRemote().sendText(payload);
        } catch (IOException ignored) {
        }
    }
}
