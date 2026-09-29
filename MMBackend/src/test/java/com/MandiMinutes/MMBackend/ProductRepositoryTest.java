package com.MandiMinutes.MMBackend;


import com.MandiMinutes.MMBackend.Product.Product;
import com.MandiMinutes.MMBackend.Product.ProductRepository;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.data.jpa.test.autoconfigure.DataJpaTest;
import org.springframework.boot.jdbc.test.autoconfigure.AutoConfigureTestDatabase;


import java.math.BigDecimal;

import static org.junit.jupiter.api.Assertions.*;

@DataJpaTest
@AutoConfigureTestDatabase(replace = AutoConfigureTestDatabase.Replace.NONE)
class ProductRepositoryTest {

    @Autowired
    private ProductRepository productRepository;

    @Test
    @DisplayName("Atomic reserve stock should succeed when available stock >= requested quantity")
    void reserveStockAtomic_Success() {
        Product product = new Product("Fresh Butter", new BigDecimal("50.00"), "100 g", 5);
        Product saved = productRepository.save(product);

        int updatedRows = productRepository.reserveStockAtomic(saved.getId(), 3);

        assertEquals(1, updatedRows);

        Product reFetched = productRepository.findById(saved.getId()).orElseThrow();
        assertEquals(3, reFetched.getReservedStock());
        assertEquals(2, reFetched.getAvailableStock());
    }

    @Test
    @DisplayName("Atomic reserve stock should fail (return 0) when requested quantity > available stock")
    void reserveStockAtomic_OutOfStock_Fails() {
        Product product = new Product("Fresh Butter", new BigDecimal("50.00"), "100 g", 5);
        Product saved = productRepository.save(product);

        // Requesting 6 when total is 5
        int updatedRows = productRepository.reserveStockAtomic(saved.getId(), 6);

        assertEquals(0, updatedRows); // No rows updated

        Product reFetched = productRepository.findById(saved.getId()).orElseThrow();
        assertEquals(0, reFetched.getReservedStock());
        assertEquals(5, reFetched.getAvailableStock());
    }
}
