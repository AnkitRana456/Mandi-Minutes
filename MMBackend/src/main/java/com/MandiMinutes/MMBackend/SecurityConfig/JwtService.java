package com.MandiMinutes.MMBackend.SecurityConfig;


import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;

import javax.crypto.SecretKey;
import java.util.Date;

@Component
public class JwtService {

    @Value("${jwt.secret}")
    private String secretKey;

    public String generateToken(UserDetails userDetails){
        return buildToken(userDetails,1000L * 60 * 60);
    }

    public String generateRefreshToken(UserDetails userDetails) {
        return buildToken(userDetails, 1000L * 60 * 60 * 24 * 30);
    }

    private String buildToken(UserDetails userDetails,long expirationTime){
        return Jwts.builder()
                .subject(userDetails.getUsername())
                .issuedAt(new Date())
                .expiration(new Date(System.currentTimeMillis() + expirationTime))
                .signWith(getSignInKey())
                .compact();

    }

    private SecretKey getSignInKey(){
        byte[] secretBytes = Decoders.BASE64.decode(secretKey);
        return Keys.hmacShaKeyFor(secretBytes);
    }

    public String extractUsername(String token){
        return Jwts.parser()
                .verifyWith(getSignInKey())
                .build()
                .parseSignedClaims(token)
                .getPayload()
                .getSubject();
    }

    public Boolean isTokenValid(String token,UserDetails userDetails){
        return extractUsername(token).equalsIgnoreCase(userDetails.getUsername()) && !isTokenExpired(token);
    }

    private boolean isTokenExpired(String token) {
        Date expiry = Jwts.parser()
                .verifyWith(getSignInKey())
                .build()
                .parseSignedClaims(token)
                .getPayload()
                .getExpiration();
        return expiry.toInstant().isBefore(new Date().toInstant());

    }
}

