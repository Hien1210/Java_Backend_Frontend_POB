package org.example.daos;

import org.example.models.CartItemTopping;
import java.util.List;

public interface CartItemToppingDAO {
    boolean create(long cartItemId, long toppingId, int quantity);
    List<CartItemTopping> findByCartItemId(long cartItemId);
    boolean deleteByCartItemId(long cartItemId);
}
