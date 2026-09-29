package com.MandiMinutes.MMBackend.ResponseDTO;


import java.math.BigDecimal;
import java.util.List;

public record CartResponse(
        Long cartId,
        Long userId,
        List<CartItemResponse> items,
        Integer totalItemsCount,
        BigDecimal totalCartValue
) {}
