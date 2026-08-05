package org.example.listener;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import org.example.daos.OrderDAO;
import org.example.daos.OrderDAOImpl;
import org.example.daos.SystemConfigDAO;
import org.example.daos.SystemConfigDAOImpl;

import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

/**
 * Tu dong huy don hang con o trang thai PENDING qua X phut ma shop chua xu ly (X lay tu
 * SystemConfig.shopAcceptOrderMinutes, xem ThamSoVanHanhServlet - doc lai moi lan quet de Admin
 * doi tham so co hieu luc ngay tu lan quet ke tiep, khong can restart server).
 * Chay 1 thread nen (ScheduledExecutorService), quet moi phut, khong can them thu vien ngoai.
 */
@WebListener
public class OrderAutoCancelListener implements ServletContextListener {

    private static final int DEFAULT_AUTO_CANCEL_AFTER_MINUTES = 10;
    private static final int SCAN_INTERVAL_SECONDS = 60;

    private final OrderDAO orderDAO = new OrderDAOImpl();
    private final SystemConfigDAO systemConfigDAO = new SystemConfigDAOImpl();
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
                int minutes = DEFAULT_AUTO_CANCEL_AFTER_MINUTES;
                var config = systemConfigDAO.get();
                if (config != null && config.getShopAcceptOrderMinutes() > 0) {
                    minutes = config.getShopAcceptOrderMinutes();
                }
                int cancelled = orderDAO.cancelStalePendingOrders(minutes);
                if (cancelled > 0) {
                    System.out.println("[OrderAutoCancelListener] Da tu dong huy " + cancelled + " don hang PENDING qua " + minutes + " phut.");
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
