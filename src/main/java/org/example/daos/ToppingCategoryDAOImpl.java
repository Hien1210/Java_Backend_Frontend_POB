package org.example.daos;

import org.example.models.ToppingCategory;
import org.example.utils.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

public class ToppingCategoryDAOImpl implements ToppingCategoryDAO {

    private static final String SELECT_COLUMNS =
            "tc.id, tc.shop_id, tc.name, tc.description, tc.is_deleted, tc.category_id, c.name AS category_name";
    private static final String FROM_JOIN =
            " FROM ToppingCategories tc LEFT JOIN Categories c ON tc.category_id = c.id";

    // ── CREATE ───────────────────────────────────────────────────────────────

    @Override
    public Boolean create(ToppingCategory category) {
        String sql = "INSERT INTO ToppingCategories (shop_id, name, description, is_deleted, category_id) " +
                "VALUES (?, ?, ?, 0, ?)";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setLong(1, category.getShopId());
            ps.setNString(2, category.getName());
            ps.setNString(3, category.getDescription());
            bindCategoryId(ps, 4, category.getCategoryId());
            return ps.executeUpdate() == 1;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // ── READ ALL ─────────────────────────────────────────────────────────────

    @Override
    public List<ToppingCategory> getAll() {
        String sql = "SELECT " + SELECT_COLUMNS + FROM_JOIN + " WHERE tc.is_deleted = 0 ORDER BY tc.id DESC";
        List<ToppingCategory> list = new ArrayList<>();

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ── READ BY ID ───────────────────────────────────────────────────────────

    @Override
    public ToppingCategory findById(long id) {
        String sql = "SELECT " + SELECT_COLUMNS + FROM_JOIN + " WHERE tc.id = ? AND tc.is_deleted = 0";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // ── UPDATE ───────────────────────────────────────────────────────────────

    @Override
    public Boolean update(ToppingCategory category) {
        String sql = "UPDATE ToppingCategories " +
                "SET name = ?, description = ?, category_id = ? " +
                "WHERE id = ? AND shop_id = ? AND is_deleted = 0";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setNString(1, category.getName());
            ps.setNString(2, category.getDescription());
            bindCategoryId(ps, 3, category.getCategoryId());
            ps.setLong(4, category.getId());
            ps.setLong(5, category.getShopId());
            return ps.executeUpdate() == 1;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // ── DELETE (soft) ────────────────────────────────────────────────────────

    @Override
    public Boolean delete(long id) {
        String sql = "UPDATE ToppingCategories SET is_deleted = 1 WHERE id = ?";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setLong(1, id);
            return ps.executeUpdate() == 1;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // ── FIND BY SHOP ─────────────────────────────────────────────────────────

    @Override
    public List<ToppingCategory> findByShopId(long shopId) {
        String sql = "SELECT " + SELECT_COLUMNS + FROM_JOIN +
                " WHERE tc.shop_id = ? AND tc.is_deleted = 0 ORDER BY tc.id ASC";
        List<ToppingCategory> list = new ArrayList<>();

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setLong(1, shopId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ── FIND DELETED BY SHOP ─────────────────────────────────────────────────

    @Override
    public List<ToppingCategory> findDeletedByShopId(long shopId) {
        String sql = "SELECT " + SELECT_COLUMNS + FROM_JOIN +
                " WHERE tc.shop_id = ? AND tc.is_deleted = 1 ORDER BY tc.id DESC";
        List<ToppingCategory> list = new ArrayList<>();
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, shopId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ── RESTORE ──────────────────────────────────────────────────────────────

    @Override
    public Boolean restore(long id, long shopId) {
        String sql = "UPDATE ToppingCategories SET is_deleted = 0 WHERE id = ? AND shop_id = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, id);
            ps.setLong(2, shopId);
            return ps.executeUpdate() == 1;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // ── HELPERS ──────────────────────────────────────────────────────────────

    private void bindCategoryId(PreparedStatement ps, int index, Long categoryId) throws Exception {
        if (categoryId == null) {
            ps.setNull(index, Types.BIGINT);
        } else {
            ps.setLong(index, categoryId);
        }
    }

    private ToppingCategory mapRow(ResultSet rs) throws Exception {
        ToppingCategory tc = new ToppingCategory();
        tc.setId(rs.getLong("id"));
        tc.setShopId(rs.getLong("shop_id"));
        tc.setName(rs.getNString("name"));
        tc.setDescription(rs.getNString("description"));
        tc.setDeleted(rs.getBoolean("is_deleted"));
        long categoryId = rs.getLong("category_id");
        tc.setCategoryId(rs.wasNull() ? null : categoryId);
        tc.setCategoryName(rs.getNString("category_name"));
        return tc;
    }
}
