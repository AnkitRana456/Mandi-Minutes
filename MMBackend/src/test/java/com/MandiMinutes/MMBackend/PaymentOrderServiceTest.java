package com.MandiMinutes.MMBackend;


import com.MandiMinutes.MMBackend.Payment.PaymentEventListener;
import com.MandiMinutes.MMBackend.Payment.PaymentOrderRepository;
import com.MandiMinutes.MMBackend.Payment.PaymentOrderService;
import com.MandiMinutes.MMBackend.RequestDTO.CreatePaymentRequest;
import com.MandiMinutes.MMBackend.ResponseDTO.PaymentResponse;
import com.MandiMinutes.MMBackend.exception.ConcurrentTransactionException;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.math.BigDecimal;
import java.util.concurrent.*;
import java.util.concurrent.atomic.AtomicInteger;

import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
class PaymentOrderServiceTest {

    @Autowired
    private PaymentOrderService paymentOrderService;

    @Autowired
    private PaymentOrderRepository paymentOrderRepository;

    @Autowired
    private PaymentEventListener paymentEventListener;

    @BeforeEach
    void setUp() {
        paymentOrderRepository.deleteAll();
        paymentEventListener.setSimulateFailure(false);
    }

    @Test
    @DisplayName("Should successfully queue payment processing event")
    void testSuccessfulPaymentFlow() throws InterruptedException {
        CreatePaymentRequest request = new CreatePaymentRequest(
                "TXN-1001",
                "IDEM-1001",
                new BigDecimal("250.00"),
                "USD"
        );

        PaymentResponse response = paymentOrderService.processPaymentOrder(request);

        assertEquals("TXN-1001", response.orderTxnId());
        assertEquals("PROCESSING", response.status());

        // Allow async in-memory listener execution time
        Thread.sleep(500);

        var order = paymentOrderRepository.findByIdempotencyKey("IDEM-1001").orElseThrow();
        assertEquals("SUCCESS", order.getStatus().name());
    }

    @Test
    @DisplayName("Should prevent duplicate executions when concurrent requests arrive milliseconds apart")
    void testConcurrentMillisecondRequests() throws InterruptedException {
        int numberOfThreads = 2;
        ExecutorService executorService = Executors.newFixedThreadPool(numberOfThreads);
        CountDownLatch startLatch = new CountDownLatch(1); // Synchronize thread start
        CountDownLatch finishLatch = new CountDownLatch(numberOfThreads);

        AtomicInteger successCount = new AtomicInteger(0);
        AtomicInteger concurrencyExceptionCount = new AtomicInteger(0);

        // Exactly identical request submitted from 2 concurrent threads
        CreatePaymentRequest request = new CreatePaymentRequest(
                "TXN-CONCURRENT-1",
                "IDEM-CONCURRENT-1",
                new BigDecimal("100.00"),
                "USD"
        );

        for (int i = 0; i < numberOfThreads; i++) {
            executorService.submit(() -> {
                try {
                    startLatch.await(); // Hold threads until signal
                    paymentOrderService.processPaymentOrder(request);
                    successCount.incrementAndGet();
                } catch (ConcurrentTransactionException e) {
                    concurrencyExceptionCount.incrementAndGet();
                } catch (Exception ignored) {
                } finally {
                    finishLatch.countDown();
                }
            });
        }

        // Release both threads simultaneously to simulate millisecond-level collision
        startLatch.countDown();
        finishLatch.await(5, TimeUnit.SECONDS);
        executorService.shutdown();

        // Exactly one should acquire lock; second should encounter concurrency exception or lock rejection
        assertEquals(1, successCount.get(), "Only one request should succeed initial lock acquisition");
        assertEquals(1, concurrencyExceptionCount.get(), "Concurrent request must throw ConcurrentTransactionException");
    }
}
