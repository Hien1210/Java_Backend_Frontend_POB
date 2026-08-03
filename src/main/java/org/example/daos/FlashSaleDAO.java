package org.example.daos;

import org.example.models.FlashSale;

import java.time.LocalDateTime;
import java.util.List;

public interface FlashSaleDAO {
    List<FlashSale> findByShopId(long shopId);
    List<FlashSale> findActiveByShopId(long shopId);
    FlashSale findById(long id);
    long create(FlashSale flashSale);
    boolean delete(long id);
    Double getActiveSalePrice(long productSizeId);
}
