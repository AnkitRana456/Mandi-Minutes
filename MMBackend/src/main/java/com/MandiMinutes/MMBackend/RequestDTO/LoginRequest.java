package com.MandiMinutes.MMBackend.RequestDTO;

import com.MandiMinutes.MMBackend.User.Role;
import lombok.Data;

@Data
public class LoginRequest {
    private String email;
    private String password;
    private Role role;


}