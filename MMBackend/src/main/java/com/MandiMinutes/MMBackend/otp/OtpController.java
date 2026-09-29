package com.MandiMinutes.MMBackend.otp;

import jakarta.validation.Valid;
import lombok.AllArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("api/v1/otp")
@AllArgsConstructor
public class OtpController {

    private final OtpService otpService;

    @PostMapping("sendOtp")
    @PreAuthorize("hasRole('RIDER')")
    public ResponseEntity<Map<String,Object>> sendOtp(@Valid @RequestBody OtpHandoverRequest otpHandoverRequest){
        return ResponseEntity.ok(otpService.sendOtp(otpHandoverRequest));
    }


    @PostMapping("verifyOtp")
    @PreAuthorize("hasRole('RIDER')")
    public ResponseEntity<Boolean> verifyOtp(@Valid @RequestBody OtpHandoverRequest otpHandoverRequest){
        return ResponseEntity.ok(otpService.verifyOtp(otpHandoverRequest));
    }
}
