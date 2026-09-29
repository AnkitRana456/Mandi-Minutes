package com.MandiMinutes.MMBackend.BusinessProduct;

import com.MandiMinutes.MMBackend.Business.BusinessProfile;
import com.MandiMinutes.MMBackend.Business.BusinessProfileRepository;
import com.MandiMinutes.MMBackend.Order.*;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class BusinessOrderService {

    private final BusinessProfileRepository businessProfileRepository;
    private final OrderItemRepository orderItemRepository;
    private final OrderRepository orderRepository;

    public BusinessOrderService(BusinessProfileRepository businessProfileRepository,OrderItemRepository orderItemRepository,OrderRepository orderRepository){
        this.businessProfileRepository = businessProfileRepository;
        this.orderRepository  = orderRepository;
        this.orderItemRepository = orderItemRepository;
    }

    public List<OrderItem> getShopkeeperOrders(Long userId) {
        BusinessProfile businessProfile = businessProfileRepository.findByUserId(userId)
                .orElseThrow(() -> new RuntimeException("Business Profile not found!"));

        return orderItemRepository.findByShopkeeperId(businessProfile.getId());
    }

    // 2. Update Order Status (PENDING -> CONFIRMED -> OUT_FOR_DELIVERY -> DELIVERED)
    public Order updateOrderStatus(Long orderId, OrderStatus newStatus) {
        Order order = orderRepository.findById(orderId)
                .orElseThrow(() -> new RuntimeException("Order not found!"));

        order.setStatus(newStatus);
        return orderRepository.save(order);
    }
}

