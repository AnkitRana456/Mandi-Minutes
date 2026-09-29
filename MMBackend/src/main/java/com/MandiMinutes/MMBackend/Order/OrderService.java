package com.MandiMinutes.MMBackend.Order;

import com.MandiMinutes.MMBackend.Cart.Cart;
import com.MandiMinutes.MMBackend.Cart.CartItem;
import com.MandiMinutes.MMBackend.Cart.CartRepository;
import com.MandiMinutes.MMBackend.RequestDTO.CheckoutRequest;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Service
public class OrderService {

    private final OrderRepository orderRepository;
    private final CartRepository cartRepository;

    public OrderService(OrderRepository orderRepository,CartRepository cartRepository){
        this.orderRepository = orderRepository;
        this.cartRepository = cartRepository;
    }


    @Transactional
    public Order checkout(Long userId, CheckoutRequest request) {

        Cart cart = cartRepository.findByUserId(userId).orElseThrow(() -> new RuntimeException("Cart not found"));

        if (cart.getCartItemList().isEmpty()) {
            throw new RuntimeException("Cannot place order with empty cart!");
        }


        BigDecimal total = BigDecimal.ZERO;

        Order order = Order.builder()
                .userId(userId)
                .status(OrderStatus.PENDING)
                .paymentMethod(request.getPaymentMethod())
                //Initially set the payment status to PENDING for COD as well as ONLINE
                .paymentStatus(PaymentStatus.PENDING)
                .deliveryAddress(request.getDeliveryAddress())
                .createdAt(LocalDateTime.now())
                .orderItemList(new java.util.ArrayList<>())
                .build();


        for (CartItem cartItem : cart.getCartItemList()) {
            BigDecimal itemTotal = cartItem.getProduct().getPrice().multiply(BigDecimal.valueOf(cartItem.getQuantity()));
            total = itemTotal.add(total);

            OrderItem orderItem = OrderItem.builder()
                    .productId(cartItem.getProduct().getId())
                    .productName(cartItem.getProduct().getName())
                    .price(cartItem.getProduct().getPrice())
                    .quantity(cartItem.getQuantity())
                    .shopkeeperId(cartItem.getProduct().getShopkeeperId() != null ? cartItem.getProduct().getShopkeeperId() : null)
                    .build();

            order.addOrderItem(orderItem);
        }

        order.setTotalAmount(total);


        Order savedOrder = orderRepository.save(order);


        cart.clearCart();
        cartRepository.saveAndFlush(cart);

        return savedOrder;
    }


    public List<Order> getUserOrders(Long userId) {
        return orderRepository.findByUserIdOrderByCreatedAtDesc(userId);
    }
}
