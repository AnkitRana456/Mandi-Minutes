package com.MandiMinutes.MMBackend.RefreshToken;

import com.MandiMinutes.MMBackend.RequestDTO.RefreshTokenRequest;
import com.MandiMinutes.MMBackend.ResponseDTO.AuthResponse;
import lombok.AllArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("api/v1/refreshToken")
@AllArgsConstructor
public class RefreshTokenController {

    private final RefreshTokenService refreshTokenService;

    @PostMapping("/refresh")
    public ResponseEntity<AuthResponse> refreshToken(@RequestBody RefreshTokenRequest refreshToken) {
        return ResponseEntity.ok(refreshTokenService.generateAccessToken(refreshToken.getRefreshToken()));
    }



}
