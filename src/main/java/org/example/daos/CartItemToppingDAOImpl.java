package org.example.daos;

import org.example.models.CartItemTopping;
import org.example.utils.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class CartItemToppingDAOImpl implements CartItemToppingDAO {

    @Override
    public List<CartItemTopping> findByCartItemId(long cartItemId) {
        String sql = "SELECT id, cart_item_id, topping_id, quantity FROM Cart_Item_Toppings WHERE cart_item_id = ?";
        List<CartItemTopping> list = new ArrayList<>();
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, cartItemId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CartItemTopping t = new CartItemTopping();
                    t.setId(rs.getLong("id"));
                    t.setCartItemId(rs.getLong("cart_item_id"));
                    t.setToppingId(rs.getLong("topping_id"));
                    t.setQuantity(rs.getInt("quantity"));
                    list.add(t);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public boolean deleteByCartItemId(long cartItemId) {
        String sql = "DELETE FROM Cart_Item_Toppings WHERE cart_item_id = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, cartItemId);
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean create(long cartItemId, long toppingId, int quantity) {
        String sql = "INSERT INTO Cart_Item_Toppings (cart_item_id, topping_id, quantity) VALUES (?, ?, ?)";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, cartItemId);
            ps.setLong(2, toppingId);
            ps.setInt(3, quantity);
            return ps.executeUpdate() == 1;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
