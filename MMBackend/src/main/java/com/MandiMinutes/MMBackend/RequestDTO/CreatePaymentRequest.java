package com.MandiMinutes.MMBackend.RequestDTO;


import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import java.math.BigDecimal;

public record CreatePaymentRequest(
        @NotNull String orderTxnId,
        @NotNull String idempotencyKey,
        @NotNull @Positive BigDecimal amount,
        @NotNull String currency
) {}

