package com.MandiMinutes.MMBackend.BusinessProduct;

import com.MandiMinutes.MMBackend.Order.Order;
import com.MandiMinutes.MMBackend.Order.OrderItem;
import com.MandiMinutes.MMBackend.Order.OrderStatus;
import com.MandiMinutes.MMBackend.Product.Product;
import com.MandiMinutes.MMBackend.RequestDTO.CreateProductRequest;
import com.MandiMinutes.MMBackend.SecurityConfig.annotation.CurrentUser;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("api/v1/business")
public class BusinessDashboardController {

    private final BusinessProductService businessProductService;
    private final BusinessOrderService businessOrderService;

    public BusinessDashboardController(BusinessProductService businessProductService,BusinessOrderService businessOrderService){
        this.businessProductService = businessProductService;
        this.businessOrderService = businessOrderService;
    }


    @PostMapping("/products/add")
    public ResponseEntity<Product> addProduct(@CurrentUser Long userId,
                                              @RequestBody CreateProductRequest request) {
        return ResponseEntity.ok(businessProductService.addProduct(userId, request));
    }

    @GetMapping("/products")
    public ResponseEntity<List<Product>> getMyProducts(@CurrentUser Long userId) {
        return ResponseEntity.ok(businessProductService.getMyProducts(userId));
    }

    @PatchMapping("/products/stock")
    public ResponseEntity<Product> updateStock(@RequestParam Long productId,
                                               @RequestParam Integer stock,@RequestParam Integer reservedStock) {
        return ResponseEntity.ok(businessProductService.updateStock(productId, stock,reservedStock));
    }

    // --- ORDER DASHBOARD ---

    @GetMapping("/orders")
    public ResponseEntity<List<OrderItem>> getShopkeeperOrders(@CurrentUser Long userId) {
        return ResponseEntity.ok(businessOrderService.getShopkeeperOrders(userId));
    }

    @PutMapping("/orders/zstatus")
    public ResponseEntity<Order> updateOrderStatus(@RequestParam Long orderId,
                                                   @RequestParam OrderStatus status) {
        return ResponseEntity.ok(businessOrderService.updateOrderStatus(orderId, status));
    }


}
