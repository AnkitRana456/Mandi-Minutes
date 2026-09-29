package com.MandiMinutes.MMBackend.otp;


import jakarta.validation.Valid;
import lombok.AllArgsConstructor;
import org.jspecify.annotations.Nullable;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Component;

import java.util.HashMap;
import java.util.Map;
import java.util.Random;
import java.util.concurrent.ConcurrentHashMap;

@Component
@AllArgsConstructor
public class OtpService {

    private final WhatsappOtpService whatsappOtpService;

    private final Map<String, String> handoverOtpCache = new ConcurrentHashMap<>();

//    @Async
    public @Nullable Map<String, Object> sendOtp(@Valid OtpHandoverRequest otpHandoverRequest) {
        String otp = String.format("%04d", new Random().nextInt(10000));
        String referenceId = otpHandoverRequest.getReferenceId();
        if (referenceId == null) {
            throw new IllegalArgumentException("referenceId is missing in the JSON body!");
        }
        if (otpHandoverRequest.getPhoneNumber() == null) {
            throw new IllegalArgumentException("phoneNumber is missing in the JSON body!");
        }
        handoverOtpCache.put(referenceId, otp);
        String message = "🛍️ *MandiMinutes Delivery Verification*\n\n" +
                "Your Handover OTP is: *" + otp + "*\n" +
                "Reference ID: " + referenceId + "\n\n" +
                "Please share this OTP with the rider upon receiving your order.";

        whatsappOtpService.sendOtpViaWhatsApp(otpHandoverRequest.getPhoneNumber(), message);

        // 5. Response Return
        Map<String, Object> response = new HashMap<>();
        response.put("status", "SUCCESS");
        response.put("message", "OTP sent successfully to customer WhatsApp");
        response.put("referenceId", referenceId);

        return response;
    }

    public @Nullable Boolean verifyOtp(OtpHandoverRequest otpHandoverRequest) {
        String referenceId = otpHandoverRequest.getReferenceId();
        String cachedOtp = handoverOtpCache.get(referenceId);
        
        if (cachedOtp != null && cachedOtp.equalsIgnoreCase(otpHandoverRequest.getOtp())) {
            handoverOtpCache.remove(referenceId); // Good practice to invalidate OTP after use
            return true;
        }
        return false;
    }
}
