package com.MandiMinutes.MMBackend.Payment;


import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Component;

import org.springframework.transaction.event.TransactionPhase;
import org.springframework.transaction.event.TransactionalEventListener;

@Component
public class PaymentEventListener {

    private final PaymentOrderRepository repository;
    private boolean simulateFailure = false; // Flag for controlled testing

    public PaymentEventListener(PaymentOrderRepository repository) {
        this.repository = repository;
    }

    // Process event asynchronously after primary transaction commits
    @Async
    @TransactionalEventListener(phase = TransactionPhase.AFTER_COMMIT)
    public void handlePaymentCreated(PaymentOrderCreatedEvent event) {
        PaymentOrder order = repository.findById(event.orderId()).orElseThrow();

        if (simulateFailure) {
            order.setStatus(PaymentStatus.FAILED);
        } else {
            order.setStatus(PaymentStatus.SUCCESS);
        }

        repository.save(order);
    }

    // Toggle method for JUnit testing
    public void setSimulateFailure(boolean simulateFailure) {
        this.simulateFailure = simulateFailure;
    }
}
