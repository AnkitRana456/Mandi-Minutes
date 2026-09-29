package com.MandiMinutes.MMBackend.Payment;



import com.MandiMinutes.MMBackend.ResponseDTO.PaymentResponse;
import com.MandiMinutes.MMBackend.RequestDTO.CreatePaymentRequest;
import com.MandiMinutes.MMBackend.exception.ConcurrentTransactionException;
import org.springframework.dao.PessimisticLockingFailureException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

@Service
public class PaymentOrderService {

    private final PaymentOrderRepository paymentRepository;
    private final ExternalServiceAdapter externalServiceAdapter;

    public PaymentOrderService(PaymentOrderRepository paymentRepository,
                               ExternalServiceAdapter externalServiceAdapter) {
        this.paymentRepository = paymentRepository;
        this.externalServiceAdapter = externalServiceAdapter;
    }

    @Transactional(isolation = Isolation.READ_COMMITTED)
    public PaymentResponse processPaymentOrder(CreatePaymentRequest request) {
        Optional<PaymentOrder> existing = paymentRepository.findByIdempotencyKey(request.idempotencyKey());
        if (existing.isPresent()) {
            PaymentOrder order = existing.get();
            return new PaymentResponse(order.getOrderTxnId(), order.getStatus().name(), "Idempotent response returned.");
        }

        PaymentOrder paymentOrder;

        try {
            Optional<PaymentOrder> lockedOrder = paymentRepository.findWithLockByOrderTxnId(request.orderTxnId());

            if (lockedOrder.isPresent()) {
                paymentOrder = lockedOrder.get();
                if (paymentOrder.getStatus() == PaymentStatus.SUCCESS) {
                    return new PaymentResponse(paymentOrder.getOrderTxnId(), PaymentStatus.SUCCESS.name(), "Order already processed.");
                }
                if (paymentOrder.getStatus() == PaymentStatus.PROCESSING) {
                    throw new ConcurrentTransactionException("A transaction request for this order is currently being processed.");
                }
            } else {
                paymentOrder = new PaymentOrder(
                        request.orderTxnId(),
                        request.idempotencyKey(),
                        request.amount(),
                        request.currency()
                );
            }

            paymentOrder.setStatus(PaymentStatus.PROCESSING);
            PaymentOrder savedOrder = paymentRepository.saveAndFlush(paymentOrder);

            // Publish to internal event listener
            externalServiceAdapter.publishOrderCreatedEvent(savedOrder);

            return new PaymentResponse(savedOrder.getOrderTxnId(), PaymentStatus.PROCESSING.name(), "Payment order accepted and queued for processing.");

        } catch (PessimisticLockingFailureException e) {
            throw new ConcurrentTransactionException("Order locked by another transaction.");
        }
    }
}
