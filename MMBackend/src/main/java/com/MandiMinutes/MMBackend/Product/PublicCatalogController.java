package com.MandiMinutes.MMBackend.Product;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.ArrayList;

@RestController
@RequestMapping("/api/v1/public")
public class PublicCatalogController {

    private final ProductRepository productRepository;

    public PublicCatalogController(ProductRepository productRepository) {
        this.productRepository = productRepository;
    }

    // 1. GET /api/v1/public/categories
    @GetMapping("/categories")
    public ResponseEntity<List<Map<String, String>>> getCategories() {
        List<Map<String, String>> categories = new ArrayList<>();
        categories.add(Map.of("id", "1", "name", "Vegetables", "icon", "🍅"));
        categories.add(Map.of("id", "2", "name", "Fruits", "icon", "🍎"));
        categories.add(Map.of("id", "3", "name", "Dairy", "icon", "🥛"));
        categories.add(Map.of("id", "4", "name", "Bakery", "icon", "🍞"));
        categories.add(Map.of("id", "5", "name", "Snacks", "icon", "🍪"));
        return ResponseEntity.ok(categories);
    }

    // 2. GET /api/v1/public/promotions
    @GetMapping("/promotions")
    public ResponseEntity<List<Map<String, String>>> getPromotions() {
        List<Map<String, String>> promotions = new ArrayList<>();
        promotions.add(Map.of(
            "id", "1", 
            "title", "Farm Fresh", 
            "subtitle", "Straight from local mandis to your doorstep in minutes!", 
            "icon", "agriculture"
        ));
        promotions.add(Map.of(
            "id", "2", 
            "title", "Super Savings", 
            "subtitle", "Get up to 50% off on daily essentials.", 
            "icon", "percent"
        ));
        return ResponseEntity.ok(promotions);
    }

    // 3. GET /api/v1/public/products/featured?section=daily_essentials
    @GetMapping("/products/featured")
    public ResponseEntity<List<Product>> getFeaturedProducts(@RequestParam(required = false, defaultValue = "daily_essentials") String section) {
        // Just return all products, or limit it to 10 for dummy purposes
        List<Product> allProducts = productRepository.findAll();
        if (allProducts.size() > 10) {
            return ResponseEntity.ok(allProducts.subList(0, 10));
        }
        return ResponseEntity.ok(allProducts);
    }

    // 4. GET /api/v1/public/products/search?q={query}
    @GetMapping("/products/search")
    public ResponseEntity<List<Product>> searchProducts(@RequestParam("q") String query) {
        List<Product> results = productRepository.findByNameContainingIgnoreCase(query);
        return ResponseEntity.ok(results);
    }
}
