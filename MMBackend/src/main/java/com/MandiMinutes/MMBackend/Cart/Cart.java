package com.MandiMinutes.MMBackend.Cart;

import jakarta.persistence.*;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@NoArgsConstructor
@Entity
@Table(name = "carts")
public class Cart {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "user_id",nullable = false)
    private Long userId;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @OneToMany(mappedBy = "cart",cascade = CascadeType.ALL,orphanRemoval = true,fetch = FetchType.LAZY)
    private List<CartItem> cartItemList = new ArrayList<>();

    public List<CartItem> getCartItemList() {
        return cartItemList;
    }

    public Cart(Long userId) {
        this.userId = userId;
    }

    public void setCartItemList(List<CartItem> cartItemList) {
        this.cartItemList = cartItemList;
    }

    public Long getId() {
        return id;
    }

    public void addItem(CartItem cartItem){
        this.cartItemList.add(cartItem);
        cartItem.setCart(this);
    }



    public void setId(Long id) {
        this.id = id;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }


    public void removeItem(CartItem item) {
        this.cartItemList.remove(item);
        item.setCart(null);
    }

    public void clearCart() {
        for (CartItem item : this.cartItemList) {
            item.setCart(null);
        }
        this.cartItemList.clear();
    }
}
