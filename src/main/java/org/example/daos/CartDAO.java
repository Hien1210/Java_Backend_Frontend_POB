package org.example.daos;

import org.example.models.Cart;

import java.util.List;

public interface CartDAO {
    Boolean create(Cart cart);
    long createAndReturnId(Cart cart);
    List<Cart> getAll();
    Cart findById(long id);
    Cart findByUserId(long userId);
    Boolean update(Cart cart);
    Boolean delete(long id);
}
