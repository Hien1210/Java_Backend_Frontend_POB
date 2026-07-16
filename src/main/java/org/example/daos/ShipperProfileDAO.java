package org.example.daos;

import org.example.models.ShipperProfile;

public interface ShipperProfileDAO {
    ShipperProfile findByAccountId(long accountId);
    boolean save(ShipperProfile profile); // insert or update (upsert)
    boolean updateIdCardImageUrl(long accountId, String idCardImageUrl);
}
