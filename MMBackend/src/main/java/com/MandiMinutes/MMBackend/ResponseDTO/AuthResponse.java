package com.MandiMinutes.MMBackend.ResponseDTO;


import com.MandiMinutes.MMBackend.User.Role;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class AuthResponse {
    private String token;
    private String refreshToken;
    private boolean generated;
    private String message;
    private String userName;
    private Long userId;
    private String email;
    private Role role;

}