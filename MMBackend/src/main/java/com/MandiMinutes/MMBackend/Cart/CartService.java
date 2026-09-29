package com.MandiMinutes.MMBackend.Cart;

import com.MandiMinutes.MMBackend.Product.Product;
import com.MandiMinutes.MMBackend.Product.ProductRepository;
import com.MandiMinutes.MMBackend.RequestDTO.CartItemRequest;
import com.MandiMinutes.MMBackend.ResponseDTO.CartItemResponse;
import com.MandiMinutes.MMBackend.ResponseDTO.CartResponse;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
public class CartService {

    private final CartRepository cartRepository;
    private final ProductRepository productRepository;

    public CartService(CartRepository cartRepository,ProductRepository productRepository){
        this.cartRepository = cartRepository;
        this.productRepository=productRepository;
    }

    //WRITE JUNIT FOR TESTING TRANSACTIONAL BEHAVIOUR
    @Transactional
    public CartResponse getCartByUserId(Long userId) {
        Cart cart = getOrCreateCart(userId);
        return mapToCartResponse(cart);
    }

    @Transactional
    public CartResponse addToCart(Long userId, CartItemRequest request) {
        Cart cart = getOrCreateCart(userId);
        Product product = productRepository.findById(request.productId())
                .orElseThrow(() -> new IllegalArgumentException("Product not found with ID: " + request.productId()));

        if (product.getAvailableStock() < request.quantity()) {
            throw new IllegalStateException("Requested quantity exceeds available stock (" + product.getAvailableStock() + ")");
        }

        Optional<CartItem> existingItemOpt = cart.getCartItemList().stream()
                .filter(item -> item.getProduct().getId().equals(product.getId()))
                .findFirst();

        if (existingItemOpt.isPresent()) {
            CartItem existingItem = existingItemOpt.get();
            int newQuantity = existingItem.getQuantity() + request.quantity();
            if (product.getAvailableStock() < newQuantity) {
                throw new IllegalStateException("Total quantity (" + newQuantity + ") exceeds available stock");
            }
            existingItem.setQuantity(newQuantity);
        } else {
            CartItem newItem = new CartItem(cart, product, request.quantity());
            cart.addItem(newItem);
        }

        Cart savedCart = cartRepository.save(cart);
        return mapToCartResponse(savedCart);
    }


    @Transactional
    public CartResponse updateItemQuantity(Long userId, Long productId, Integer quantity) {
        Cart cart = getOrCreateCart(userId);

        CartItem item = cart.getCartItemList().stream()
                .filter(i -> i.getProduct().getId().equals(productId))
                .findFirst()
                .orElseThrow(() -> new IllegalArgumentException("Product not present in cart"));

        if (quantity <= 0) {
            cart.removeItem(item);
        } else {
            if (item.getProduct().getAvailableStock() < quantity) {
                throw new IllegalStateException("Requested quantity exceeds available stock (" + item.getProduct().getAvailableStock() + ")");
            }
            item.setQuantity(quantity);
        }

        Cart savedCart = cartRepository.save(cart);
        return mapToCartResponse(savedCart);
    }


    @Transactional
    public CartResponse removeItemFromCart(Long userId, Long productId) {
        Cart cart = getOrCreateCart(userId);

        cart.getCartItemList().stream()
                .filter(i -> i.getProduct().getId().equals(productId))
                .findFirst()
                .ifPresent(cart::removeItem);

        Cart savedCart = cartRepository.save(cart);
        return mapToCartResponse(savedCart);
    }

    @Transactional
    public void clearCart(Long userId) {
        Cart cart = getOrCreateCart(userId);
        cart.clearCart();
        cartRepository.save(cart);
    }

    private Cart getOrCreateCart(Long userId) {
        return cartRepository.findByUserId(userId).orElseGet(() -> cartRepository.save(new Cart(userId)));
    }

    private CartResponse mapToCartResponse(Cart cart) {
        List<CartItemResponse> itemResponses = new ArrayList<>();
        BigDecimal totalCartValue = BigDecimal.ZERO;
        int totalItemCount = 0;

        for (CartItem item : cart.getCartItemList()) {
            Product product = item.getProduct();
            BigDecimal subTotal = product.getPrice().multiply(BigDecimal.valueOf(item.getQuantity()));
            boolean isAvailable = product.getAvailableStock() >= item.getQuantity();

            itemResponses.add(new CartItemResponse(
                    item.getId(),
                    product.getId(),
                    product.getName(),
                    product.getUnit(),
                    product.getPrice(),
                    item.getQuantity(),
                    subTotal,
                    isAvailable
            ));

            totalCartValue = totalCartValue.add(subTotal);
            totalItemCount += item.getQuantity();
        }

        return new CartResponse(
                cart.getId(),
                cart.getUserId(),
                itemResponses,
                totalItemCount,
                totalCartValue
        );
    }


}
