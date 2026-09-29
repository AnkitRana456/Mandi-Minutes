package com.MandiMinutes.MMBackend.ResponseDTO;

public record PaymentResponse(
        String orderTxnId,
        String status,
        String message
) {}
