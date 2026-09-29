package com.MandiMinutes.MMBackend.Payment;


import com.MandiMinutes.MMBackend.RequestDTO.CreatePaymentRequest;
import com.MandiMinutes.MMBackend.ResponseDTO.PaymentResponse;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/v1/payments")
public class PaymentOrderController {

    private final PaymentOrderService paymentOrderService;

    public PaymentOrderController(PaymentOrderService paymentOrderService) {
        this.paymentOrderService = paymentOrderService;
    }

    @PostMapping("/order")
    public ResponseEntity<PaymentResponse> createPaymentOrder(@Valid @RequestBody CreatePaymentRequest request) {
        PaymentResponse response = paymentOrderService.processPaymentOrder(request);
        return ResponseEntity.ok(response);
    }


}
