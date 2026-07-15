package org.example.websocket;

import jakarta.websocket.CloseReason;
import jakarta.websocket.EndpointConfig;
import jakarta.websocket.OnClose;
import jakarta.websocket.OnError;
import jakarta.websocket.OnMessage;
import jakarta.websocket.OnOpen;
import jakarta.websocket.Session;
import jakarta.websocket.server.ServerEndpoint;
import org.example.daos.OrderDAO;
import org.example.daos.OrderDAOImpl;
import org.example.models.Order;
import org.json.JSONObject;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.CopyOnWriteArraySet;

@ServerEndpoint(value = "/ws/tracking", configurator = HttpSessionConfigurator.class)
public class TrackingEndpoint {

    private static final OrderDAO orderDAO = new OrderDAOImpl();

    private static final Map<Long, Set<Session>> customerWatchers = new ConcurrentHashMap<>();
    private static final Map<Long, double[]> lastKnownLocation = new ConcurrentHashMap<>();

    @OnOpen
    public void onOpen(Session session, EndpointConfig config) {
        Map<String, List<String>> params = session.getRequestParameterMap();
        String role = firstParam(params, "role");
        long orderId = parseLong(firstParam(params, "orderId"));

        Object accountIdObj = config.getUserProperties().get("currentAccountId");
        long currentAccountId = (accountIdObj instanceof Long) ? (Long) accountIdObj : -1L;

        Order order = orderId > 0 ? orderDAO.findById(orderId) : null;
        boolean authorized = order != null && currentAccountId != -1L && (
                ("shipper".equals(role) && order.getShipperId() == currentAccountId) ||
                ("customer".equals(role) && order.getUserId() == currentAccountId)
        );

        if (!authorized) {
            closeQuietly(session, "unauthorized");
            return;
        }

        session.getUserProperties().put("orderId", orderId);
        session.getUserProperties().put("role", role);

        if ("customer".equals(role)) {
            customerWatchers.computeIfAbsent(orderId, k -> new CopyOnWriteArraySet<>()).add(session);
            double[] last = lastKnownLocation.get(orderId);
            if (last != null) {
                sendQuietly(session, locationJson(last[0], last[1]));
            }
        }
    }

    @OnMessage
    public void onMessage(String message, Session session) {
        if (!"shipper".equals(session.getUserProperties().get("role"))) {
            return;
        }
        Long orderId = (Long) session.getUserProperties().get("orderId");
        if (orderId == null) {
            return;
        }

        JSONObject json = new JSONObject(message);
        double lat = json.getDouble("lat");
        double lng = json.getDouble("lng");
        lastKnownLocation.put(orderId, new double[]{lat, lng});

        Set<Session> watchers = customerWatchers.get(orderId);
        if (watchers == null) {
            return;
        }
        String payload = locationJson(lat, lng);
        for (Session watcher : watchers) {
            sendQuietly(watcher, payload);
        }
    }

    @OnClose
    public void onClose(Session session) {
        Long orderId = (Long) session.getUserProperties().get("orderId");
        if (orderId == null) {
            return;
        }
        Set<Session> watchers = customerWatchers.get(orderId);
        if (watchers != null) {
            watchers.remove(session);
            if (watchers.isEmpty()) {
                customerWatchers.remove(orderId);
            }
        }
    }

    @OnError
    public void onError(Session session, Throwable throwable) {
        // Không cần xử lý gì thêm — container sẽ tự đóng session lỗi.
    }

    private static String locationJson(double lat, double lng) {
        return new JSONObject().put("lat", lat).put("lng", lng).toString();
    }

    private static String firstParam(Map<String, List<String>> params, String name) {
        List<String> values = params.get(name);
        return (values != null && !values.isEmpty()) ? values.get(0) : null;
    }

    private static long parseLong(String s) {
        try {
            return Long.parseLong(s);
        } catch (Exception e) {
            return -1L;
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
