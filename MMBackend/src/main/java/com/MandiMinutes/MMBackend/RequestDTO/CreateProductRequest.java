package com.MandiMinutes.MMBackend.RequestDTO;

import lombok.Data;

import java.math.BigDecimal;

@Data
public class CreateProductRequest {
    private String name;
    private String description;
    private BigDecimal price;
    private Integer stockQuantity;
    private Integer reservedStock;
    private String category;
    private String imageUrl;
}
