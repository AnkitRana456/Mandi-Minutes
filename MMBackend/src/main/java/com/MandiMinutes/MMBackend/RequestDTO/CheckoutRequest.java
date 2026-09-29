package com.MandiMinutes.MMBackend.RequestDTO;


import com.MandiMinutes.MMBackend.Order.PaymentMethod;
import lombok.Data;

@Data
public class CheckoutRequest {
    private String deliveryAddress;
    private PaymentMethod paymentMethod; // COD or ONLINE
}
