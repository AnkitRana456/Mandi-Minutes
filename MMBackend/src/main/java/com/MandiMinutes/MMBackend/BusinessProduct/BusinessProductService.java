package com.MandiMinutes.MMBackend.BusinessProduct;

import com.MandiMinutes.MMBackend.Business.BusinessProfile;
import com.MandiMinutes.MMBackend.Business.BusinessProfileRepository;
import com.MandiMinutes.MMBackend.Product.Product;
import com.MandiMinutes.MMBackend.Product.ProductRepository;
import com.MandiMinutes.MMBackend.RequestDTO.CreateProductRequest;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class BusinessProductService {

    private final ProductRepository productRepository;
    private final BusinessProfileRepository businessProfileRepository;

    public BusinessProductService(ProductRepository productRepository,BusinessProfileRepository businessProfileRepository){
        this.productRepository = productRepository;
        this.businessProfileRepository = businessProfileRepository;
    }

    public Product addProduct(Long userId, CreateProductRequest request) {
        BusinessProfile businessProfile = businessProfileRepository.findByUserId(userId)
                .orElseThrow(() -> new RuntimeException("Business Profile not found for logged in user!"));

        Product product = Product.builder()
                .name(request.getName())
                .description(request.getDescription())
                .price(request.getPrice())
                .totalStock(request.getStockQuantity())
                .reservedStock(request.getReservedStock())
                .category(request.getCategory())
                .imageUrl(request.getImageUrl())
                .shopkeeperId(businessProfile.getId())
                .build();

        return productRepository.save(product);
    }

    public List<Product> getMyProducts(Long userId) {
        BusinessProfile businessProfile = businessProfileRepository.findByUserId(userId).orElseThrow(() -> new RuntimeException("Business Profile not found!"));

        return productRepository.findByShopkeeperId(businessProfile.getId());
    }

    public Product updateStock(Long productId, Integer newStock,Integer reservedStock) {
        Product product = productRepository.findById(productId)
                .orElseThrow(() -> new RuntimeException("Product not found"));
        product.setTotalStock(newStock);
        product.setReservedStock(reservedStock);
        return productRepository.save(product);
    }
}

