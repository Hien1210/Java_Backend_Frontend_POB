package org.example.daos;

import org.example.models.ToppingCategory;
import org.example.utils.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class ToppingCategoryDAOImpl implements ToppingCategoryDAO {

    private static final String SELECT_COLUMNS = "id, shop_id, name, description, is_deleted";

    // ── CREATE ───────────────────────────────────────────────────────────────

    @Override
    public Boolean create(ToppingCategory category) {
        String sql = "INSERT INTO ToppingCategories (shop_id, name, description, is_deleted) " +
                "VALUES (?, ?, ?, 0)";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setLong(1, category.getShopId());
            ps.setNString(2, category.getName());
            ps.setNString(3, category.getDescription());
            boolean ok = ps.executeUpdate() == 1;
            if (ok) {
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) {
                        category.setId(keys.getLong(1));
                        saveCategoryLinks(con, category.getId(), category.getCategoryIds());
                    }
                }
            }
            return ok;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // ── READ ALL ─────────────────────────────────────────────────────────────

    @Override
    public List<ToppingCategory> getAll() {
        String sql = "SELECT " + SELECT_COLUMNS + " FROM ToppingCategories WHERE is_deleted = 0 ORDER BY id DESC";
        List<ToppingCategory> list = new ArrayList<>();

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapRow(con, rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ── READ BY ID ───────────────────────────────────────────────────────────

    @Override
    public ToppingCategory findById(long id) {
        String sql = "SELECT " + SELECT_COLUMNS + " FROM ToppingCategories WHERE id = ? AND is_deleted = 0";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(con, rs);
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
                "SET name = ?, description = ? " +
                "WHERE id = ? AND shop_id = ? AND is_deleted = 0";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setNString(1, category.getName());
            ps.setNString(2, category.getDescription());
            ps.setLong(3, category.getId());
            ps.setLong(4, category.getShopId());
            boolean ok = ps.executeUpdate() == 1;
            if (ok) {
                saveCategoryLinks(con, category.getId(), category.getCategoryIds());
            }
            return ok;

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
        String sql = "SELECT " + SELECT_COLUMNS + " FROM ToppingCategories " +
                "WHERE shop_id = ? AND is_deleted = 0 ORDER BY id ASC";
        List<ToppingCategory> list = new ArrayList<>();

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setLong(1, shopId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(con, rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ── FIND DELETED BY SHOP ─────────────────────────────────────────────────

    @Override
    public List<ToppingCategory> findDeletedByShopId(long shopId) {
        String sql = "SELECT " + SELECT_COLUMNS + " FROM ToppingCategories WHERE shop_id = ? AND is_deleted = 1 ORDER BY id DESC";
        List<ToppingCategory> list = new ArrayList<>();
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, shopId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(con, rs));
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

    /** Xoa het lien ket cu roi ghi lai dung danh sach loai san pham hien tai (rong = ap dung cho MOI loai). */
    private void saveCategoryLinks(Connection con, long toppingCategoryId, List<Long> categoryIds) throws Exception {
        try (PreparedStatement del = con.prepareStatement(
                "DELETE FROM ToppingCategory_ProductCategories WHERE topping_category_id = ?")) {
            del.setLong(1, toppingCategoryId);
            del.executeUpdate();
        }
        if (categoryIds == null || categoryIds.isEmpty()) return;
        try (PreparedStatement ins = con.prepareStatement(
                "INSERT INTO ToppingCategory_ProductCategories (topping_category_id, category_id) VALUES (?, ?)")) {
            for (Long categoryId : categoryIds) {
                ins.setLong(1, toppingCategoryId);
                ins.setLong(2, categoryId);
                ins.addBatch();
            }
            ins.executeBatch();
        }
    }

    private void loadCategoryLinks(Connection con, ToppingCategory tc) throws Exception {
        String sql = "SELECT tcpc.category_id, c.name AS category_name " +
                "FROM ToppingCategory_ProductCategories tcpc " +
                "JOIN Categories c ON tcpc.category_id = c.id " +
                "WHERE tcpc.topping_category_id = ? ORDER BY c.name ASC";
        List<Long> ids = new ArrayList<>();
        List<String> names = new ArrayList<>();
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, tc.getId());
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ids.add(rs.getLong("category_id"));
                    names.add(rs.getNString("category_name"));
                }
            }
        }
        tc.setCategoryIds(ids);
        tc.setCategoryNames(names);
    }

    private ToppingCategory mapRow(Connection con, ResultSet rs) throws Exception {
        ToppingCategory tc = new ToppingCategory();
        tc.setId(rs.getLong("id"));
        tc.setShopId(rs.getLong("shop_id"));
        tc.setName(rs.getNString("name"));
        tc.setDescription(rs.getNString("description"));
        tc.setDeleted(rs.getBoolean("is_deleted"));
        loadCategoryLinks(con, tc);
        return tc;
    }
}
