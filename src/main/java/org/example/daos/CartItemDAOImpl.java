package org.example.daos;

import org.example.models.CartItem;
import org.example.utils.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class CartItemDAOImpl implements CartItemDAO {
    @Override
    public Boolean create(CartItem item) {
        String sql = "INSERT INTO Cart_Items (cart_id, product_id, product_size_id, quantity) VALUES (?, ?, ?, ?)";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, item.getCartId());
            ps.setLong(2, item.getProductId());
            ps.setLong(3, item.getProductSizeId());
            ps.setInt(4, item.getQuantity());
            return ps.executeUpdate() == 1;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public long createAndReturnId(CartItem item) {
        String sql = "INSERT INTO Cart_Items (cart_id, product_id, product_size_id, quantity) VALUES (?, ?, ?, ?)";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setLong(1, item.getCartId());
            ps.setLong(2, item.getProductId());
            ps.setLong(3, item.getProductSizeId());
            ps.setInt(4, item.getQuantity());
            if (ps.executeUpdate() == 0) return 0;
            try (ResultSet rs = ps.getGeneratedKeys()) {
                return rs.next() ? rs.getLong(1) : 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    @Override
    public List<CartItem> getAll() {
        String sql = "SELECT id, cart_id, product_id, product_size_id, quantity, combo_id, combo_unit_price FROM Cart_Items ORDER BY id DESC";
        List<CartItem> items = new ArrayList<>();

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                items.add(mapCartItem(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return items;
    }

    @Override
    public CartItem findById(long id) {
        String sql = "SELECT id, cart_id, product_id, product_size_id, quantity, combo_id, combo_unit_price FROM Cart_Items WHERE id = ?";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapCartItem(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    @Override
    public Boolean update(CartItem item) {
        String sql = "UPDATE Cart_Items SET cart_id = ?, product_id = ?, product_size_id = ?, quantity = ? WHERE id = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, item.getCartId());
            ps.setLong(2, item.getProductId());
            ps.setLong(3, item.getProductSizeId());
            ps.setInt(4, item.getQuantity());
            ps.setLong(5, item.getId());
            return ps.executeUpdate() == 1;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public Boolean delete(long id) {
        String sql = "DELETE FROM Cart_Items WHERE id = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, id);
            return ps.executeUpdate() == 1;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public List<CartItem> findByCartId(long cartId) {
        String sql = "SELECT id, cart_id, product_id, product_size_id, quantity, combo_id, combo_unit_price FROM Cart_Items WHERE cart_id = ? ORDER BY id ASC";
        List<CartItem> items = new ArrayList<>();

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, cartId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    items.add(mapCartItem(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return items;
    }

    @Override
    public CartItem findByCartIdProductSize(long cartId, long productId, long productSizeId) {
        // Chi gop vao mon LE binh thuong (combo_id IS NULL) - tranh gop nham vao 1 item dang gia
        // combo (combo_unit_price da "khoa"), lam sai lech gia cua don vi vua them vao.
        String sql = "SELECT id, cart_id, product_id, product_size_id, quantity, combo_id, combo_unit_price " +
                "FROM Cart_Items WHERE cart_id = ? AND product_id = ? AND product_size_id = ? AND combo_id IS NULL";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, cartId);
            ps.setLong(2, productId);
            ps.setLong(3, productSizeId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapCartItem(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public CartItem findByCartIdProductSizeCombo(long cartId, long productId, long productSizeId, long comboId) {
        String sql = "SELECT id, cart_id, product_id, product_size_id, quantity, combo_id, combo_unit_price " +
                "FROM Cart_Items WHERE cart_id = ? AND product_id = ? AND product_size_id = ? AND combo_id = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, cartId);
            ps.setLong(2, productId);
            ps.setLong(3, productSizeId);
            ps.setLong(4, comboId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapCartItem(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public long createComboItem(long cartId, long productId, long productSizeId, int quantity, long comboId, double comboUnitPrice) {
        String sql = "INSERT INTO Cart_Items (cart_id, product_id, product_size_id, quantity, combo_id, combo_unit_price) " +
                "VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setLong(1, cartId);
            ps.setLong(2, productId);
            ps.setLong(3, productSizeId);
            ps.setInt(4, quantity);
            ps.setLong(5, comboId);
            ps.setDouble(6, comboUnitPrice);
            if (ps.executeUpdate() == 0) return 0;
            try (ResultSet rs = ps.getGeneratedKeys()) {
                return rs.next() ? rs.getLong(1) : 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    @Override
    public Boolean incrementQuantity(long cartItemId, int delta) {
        String sql = "UPDATE Cart_Items SET quantity = quantity + ? WHERE id = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, delta);
            ps.setLong(2, cartItemId);
            return ps.executeUpdate() == 1;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    private CartItem mapCartItem(ResultSet rs) throws Exception {
        CartItem item = new CartItem();
        item.setId(rs.getLong("id"));
        item.setCartId(rs.getLong("cart_id"));
        item.setProductId(rs.getLong("product_id"));
        item.setProductSizeId(rs.getLong("product_size_id"));
        item.setQuantity(rs.getInt("quantity"));
        long comboId = rs.getLong("combo_id");
        if (!rs.wasNull()) item.setComboId(comboId);
        double comboUnitPrice = rs.getDouble("combo_unit_price");
        if (!rs.wasNull()) item.setComboUnitPrice(comboUnitPrice);
        return item;
    }
}
