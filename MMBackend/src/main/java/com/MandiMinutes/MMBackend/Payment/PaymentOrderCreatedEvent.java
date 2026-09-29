package com.MandiMinutes.MMBackend.Payment;



import java.math.BigDecimal;

public record PaymentOrderCreatedEvent(
        Long orderId,
        String orderTxnId,
        BigDecimal amount,
        String currency
) {}