package com.MandiMinutes.MMBackend.ResponseDTO;


import java.math.BigDecimal;

public record CartItemResponse(
        Long cartItemId,
        Long productId,
        String productName,
        String unit,
        BigDecimal unitPrice,
        Integer quantity,
        BigDecimal subTotal,
        Boolean isAvailable
) {}
