package com.MandiMinutes.MMBackend.Cart;

import com.MandiMinutes.MMBackend.RequestDTO.CartItemRequest;
import com.MandiMinutes.MMBackend.ResponseDTO.CartResponse;
import com.MandiMinutes.MMBackend.SecurityConfig.annotation.CurrentUser;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("api/v1/cart")
public class CartController {

    private final CartService cartService;

    public CartController(CartService cartService){
        this.cartService=cartService;
    }

    @GetMapping("/getCart")
    public ResponseEntity<CartResponse> getCart(@CurrentUser Long userId) {
        return ResponseEntity.ok(cartService.getCartByUserId(userId));
    }

    @PostMapping("/add")
    public ResponseEntity<CartResponse> addToCart(
            @CurrentUser Long userId,
            @Valid @RequestBody CartItemRequest request) {
        return ResponseEntity.ok(cartService.addToCart(userId, request));
    }

    @PutMapping("/items")
    public ResponseEntity<CartResponse> updateQuantity(
            @CurrentUser Long userId,
            @RequestParam Long productId,
            @RequestParam Integer quantity) {
        return ResponseEntity.ok(cartService.updateItemQuantity(userId, productId, quantity));
    }

    @DeleteMapping("/deleteItems")
    public ResponseEntity<CartResponse> removeItem(
            @CurrentUser  Long userId,
            @RequestParam Long productId) {
        return ResponseEntity.ok(cartService.removeItemFromCart(userId, productId));
    }

    @DeleteMapping("/clear")
    public ResponseEntity<Void> clearCart(@CurrentUser Long userId) {
        cartService.clearCart(userId);
        return ResponseEntity.noContent().build();
    }


}
