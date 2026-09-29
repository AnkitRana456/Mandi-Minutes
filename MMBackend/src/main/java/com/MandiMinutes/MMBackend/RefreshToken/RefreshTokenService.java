package com.MandiMinutes.MMBackend.RefreshToken;

import com.MandiMinutes.MMBackend.ResponseDTO.AuthResponse;
import com.MandiMinutes.MMBackend.SecurityConfig.JwtService;
import lombok.AllArgsConstructor;
import lombok.NonNull;
import com.MandiMinutes.MMBackend.User.User;
import org.jspecify.annotations.Nullable;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.time.temporal.ChronoUnit;

@Service
@AllArgsConstructor
public class RefreshTokenService {

    private final JwtService jwtService;
    private final RefreshTokenRepository refreshTokenRepository;

    public RefreshToken createRefreshToken(@NonNull User user){
        UserDetails userDetails = org.springframework.security.core.userdetails.User.builder()
                .username(user.getEmail())
                .password(user.getPassword())
                .roles("USER")
                .build();
        String refreshToken = jwtService.generateRefreshToken(userDetails);
        RefreshToken newRefreshToken = RefreshToken.builder()
                .refreshToken(refreshToken)
                .user(user)
                .expiryDate(Instant.now().plus(30, ChronoUnit.DAYS))
                .build();
        refreshTokenRepository.findByUser(user).ifPresent(refreshTokenRepository::delete);
        refreshTokenRepository.save(newRefreshToken);
        return newRefreshToken;
    }

    public @Nullable AuthResponse generateAccessToken(String refreshToken) {
        RefreshToken existingToken = refreshTokenRepository.findByRefreshToken(refreshToken);
        if (existingToken == null) {
            return AuthResponse.builder().message("No Refresh Token exists").generated(false).build();

        }

        if (existingToken.getExpiryDate().isBefore(Instant.now())) {
            return AuthResponse.builder().message("Refresh Token has Expired").generated(false).build();
        }
        User user = existingToken.getUser();
        UserDetails userDetails = org.springframework.security.core.userdetails.User.builder()
                .username(user.getEmail())
                .password(user.getPassword())
                .roles("USER")
                .build();

        if (!jwtService.isTokenValid(refreshToken, userDetails)) {
            return AuthResponse.builder().message("Invalid Token Provided").generated(false).build();
        }
        String accessToken = jwtService.generateToken(userDetails);
        return AuthResponse.builder().token(accessToken).refreshToken(refreshToken).generated(true).build();

    }
}

