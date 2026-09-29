package com.MandiMinutes.MMBackend.Payment;




import org.springframework.context.ApplicationEventPublisher;
import org.springframework.stereotype.Component;

@Component
public class ExternalServiceAdapter {

    private final ApplicationEventPublisher eventPublisher;

    public ExternalServiceAdapter(ApplicationEventPublisher eventPublisher) {
        this.eventPublisher = eventPublisher;
    }

    public void publishOrderCreatedEvent(PaymentOrder order) {
        // Publishes event to Spring's internal ApplicationContext queue
        eventPublisher.publishEvent(new PaymentOrderCreatedEvent(
                order.getId(),
                order.getOrderTxnId(),
                order.getAmount(),
                order.getCurrency()
        ));
    }
}
