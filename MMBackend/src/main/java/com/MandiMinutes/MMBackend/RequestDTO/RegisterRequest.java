package com.MandiMinutes.MMBackend.RequestDTO;

import com.MandiMinutes.MMBackend.User.Role;
import lombok.Data;

@Data
public class RegisterRequest {
    private String email;
    private String password;
    private String username;
    private String businessName;
    private Role role;
}

