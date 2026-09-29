package com.MandiMinutes.MMBackend.User;

import com.MandiMinutes.MMBackend.RefreshToken.RefreshToken;
import com.MandiMinutes.MMBackend.RefreshToken.RefreshTokenService;
import com.MandiMinutes.MMBackend.RequestDTO.LoginRequest;
import com.MandiMinutes.MMBackend.RequestDTO.RegisterRequest;
import com.MandiMinutes.MMBackend.ResponseDTO.AuthResponse;
import com.MandiMinutes.MMBackend.SecurityConfig.JwtService;
import com.MandiMinutes.MMBackend.exception.ResourceNotFoundException;
import lombok.AllArgsConstructor;
import org.jspecify.annotations.Nullable;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
@AllArgsConstructor
public class UserService {

    private final UserRepository userRepository;

    private final PasswordEncoder passwordEncoder;

    private final JwtService jwtService;

    private final AuthenticationManager authenticationManager;

    private final RefreshTokenService refreshTokenService;

    private final Logger LOGGER = LoggerFactory.getLogger(UserService.class);

    public @Nullable AuthResponse registerUser(RegisterRequest registerRequest) {
        User user = userRepository.findByEmail(registerRequest.getEmail());
        if(user!=null){
            return AuthResponse.builder().generated(false).message("User Already Existes").build();
        }
        if(registerRequest.getEmail().isBlank() || registerRequest.getEmail()==null || registerRequest.getPassword().isBlank() || registerRequest.getPassword()==null){
            return AuthResponse.builder().generated(false).message("Email And Password cannnot be null").build();
        }
        User newUser = User.builder()
                .userName(registerRequest.getUsername())
                .email(registerRequest.getEmail())
                .password(passwordEncoder.encode(registerRequest.getPassword()))
                .role(registerRequest.getRole())
                .build();

        userRepository.save(newUser);
        UserDetails userDetails = org.springframework.security.core.userdetails.User.builder()
                .username(newUser.getEmail())
                .password(newUser.getPassword())
                .roles(newUser.getRole().name())
                .build();
        String jwtToken = jwtService.generateToken(userDetails);
        RefreshToken refreshToken = refreshTokenService.createRefreshToken(newUser);

        return AuthResponse.builder().role(registerRequest.getRole()).token(jwtToken).userName(newUser.getUserName()).email(newUser.getEmail()).userId(newUser.getId()).refreshToken(refreshToken.getRefreshToken()).generated(true).build();

    }

    public @Nullable AuthResponse loginUser(LoginRequest loginRequest)throws  Exception {
        User user = userRepository.findByEmail(loginRequest.getEmail());
        if(user==null)throw  new ResourceNotFoundException("No user found with email: " + loginRequest.getEmail());


        if (loginRequest.getRole() != null && !user.getRole().equals(loginRequest.getRole())) {
            throw new IllegalArgumentException("Unauthorized role access for this account type!");
        }


        try {
            authenticationManager.authenticate(
                    new UsernamePasswordAuthenticationToken(loginRequest.getEmail(), loginRequest.getPassword())
            );
        } catch (BadCredentialsException e) {
            throw new IllegalArgumentException("Invalid email or password!");
        }


        UserDetails userDetails = org.springframework.security.core.userdetails.User.builder()
                .username(user.getEmail())
                .password(user.getPassword())
                .authorities(user.getRole().name())
                .build();


        String jwtToken = jwtService.generateToken(userDetails);
        RefreshToken refreshToken = refreshTokenService.createRefreshToken(user);

        LOGGER.info("User successfully logged in: {}", user.getEmail());


        return AuthResponse.builder()
                .userId(user.getId())
                .userName(user.getUserName())
                .email(user.getEmail())
                .role(user.getRole())
                .token(jwtToken)
                .refreshToken(refreshToken.getRefreshToken())
                .message("Login successful")
                .build();
    }
}
