package com.MandiMinutes.MMBackend.Product;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ProductRepository extends JpaRepository<Product,Long> {

    //Increase reserved stock for product added in the active cart by any user and prevent double selling
    @Modifying(clearAutomatically = true)
    @Query("""
        UPDATE Product p 
        SET p.reservedStock = p.reservedStock + :qty 
        WHERE p.id = :productId AND (p.totalStock - p.reservedStock) >= :qty
    """)
    int reserveStockAtomic(@Param("productId") Long productId, @Param("qty") Integer qty);

    List<Product> findByShopkeeperId(Long id);

    List<Product> findByCategoryIgnoreCase(String category);

    List<Product> findByNameContainingIgnoreCase(String name);
}
