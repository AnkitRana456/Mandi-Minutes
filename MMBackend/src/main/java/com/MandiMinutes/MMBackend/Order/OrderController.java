package com.MandiMinutes.MMBackend.Order;

import com.MandiMinutes.MMBackend.RequestDTO.CheckoutRequest;
import com.MandiMinutes.MMBackend.SecurityConfig.annotation.CurrentUser;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("api/v1/orders")
public class OrderController {

    private final OrderService orderService;

    public OrderController(OrderService orderService){
        this.orderService = orderService;
    }


    @PostMapping("/checkout")
    public ResponseEntity<Order> checkout(@CurrentUser Long userId,
                                          @RequestBody CheckoutRequest request) {
        Order order = orderService.checkout(userId, request);
        return ResponseEntity.ok(order);
    }


    @GetMapping("/user")
    public ResponseEntity<List<Order>> getUserOrders(@CurrentUser Long userId) {
        return ResponseEntity.ok(orderService.getUserOrders(userId));
    }



}
