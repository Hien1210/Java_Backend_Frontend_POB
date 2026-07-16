package org.example.listener;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import org.example.daos.OrderDAO;
import org.example.daos.OrderDAOImpl;

import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

/**
 * Tu dong huy don hang con o trang thai PENDING qua 10 phut ma shop chua xu ly.
 * Chay 1 thread nen (ScheduledExecutorService), quet moi phut, khong can them thu vien ngoai.
 */
@WebListener
public class OrderAutoCancelListener implements ServletContextListener {

    private static final int AUTO_CANCEL_AFTER_MINUTES = 10;
    private static final int SCAN_INTERVAL_SECONDS = 60;

    private final OrderDAO orderDAO = new OrderDAOImpl();
    private ScheduledExecutorService scheduler;

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        scheduler = Executors.newSingleThreadScheduledExecutor(r -> {
            Thread t = new Thread(r, "order-auto-cancel");
            t.setDaemon(true);
            return t;
        });
        scheduler.scheduleAtFixedRate(() -> {
            try {
                int cancelled = orderDAO.cancelStalePendingOrders(AUTO_CANCEL_AFTER_MINUTES);
                if (cancelled > 0) {
                    System.out.println("[OrderAutoCancelListener] Da tu dong huy " + cancelled + " don hang PENDING qua " + AUTO_CANCEL_AFTER_MINUTES + " phut.");
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }, SCAN_INTERVAL_SECONDS, SCAN_INTERVAL_SECONDS, TimeUnit.SECONDS);
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        if (scheduler != null) {
            scheduler.shutdownNow();
        }
    }
}
