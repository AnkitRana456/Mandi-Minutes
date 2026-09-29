package com.MandiMinutes.MMBackend.Customer;

import com.MandiMinutes.MMBackend.RefreshToken.RefreshToken;
import com.MandiMinutes.MMBackend.RefreshToken.RefreshTokenService;
import com.MandiMinutes.MMBackend.ResponseDTO.AuthResponse;
import com.MandiMinutes.MMBackend.SecurityConfig.JwtService;
import com.MandiMinutes.MMBackend.User.Role;
import com.MandiMinutes.MMBackend.User.User;
import com.MandiMinutes.MMBackend.User.UserRepository;
import com.MandiMinutes.MMBackend.exception.ResourceAlreadyExistsException;
import jakarta.transaction.Transactional;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.jspecify.annotations.Nullable;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
@Slf4j
@AllArgsConstructor
public class CustomerService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final CustomerProfileRepository customerProfileRepository;
    private final JwtService jwtService;
    private final RefreshTokenService refreshTokenService;

        @Transactional
        public @Nullable AuthResponse registerCustomer(CustomerRegisterRequest request) {

            if (userRepository.existsByEmail(request.getEmail())) {
                throw new ResourceAlreadyExistsException("Email '" + request.getEmail() + "' is already registered!");
            }



            User user = User.builder()
                    .userName(request.getUserName())
                    .email(request.getEmail())
                    .phoneNumber(request.getPhoneNumber())
                    .password(passwordEncoder.encode(request.getPassword()))
                    .role(Role.CUSTOMER)
                    .isActive(true)
                    .build();

            User savedUser = userRepository.save(user);


            CustomerProfile profile = CustomerProfile.builder()
                    .user(savedUser)
                    .defaultAddress(request.getDefaultAddress())
                    .emergencyContactPhone(request.getEmergencyContactPhone())
                    .build();

            customerProfileRepository.save(profile);
            UserDetails userDetails = org.springframework.security.core.userdetails.User.builder()
                    .username(savedUser.getEmail())
                    .password(savedUser.getPassword())
                    .roles(savedUser.getRole().name())
                    .build();
            String jwtToken = jwtService.generateToken(userDetails);
            RefreshToken refreshToken = refreshTokenService.createRefreshToken(savedUser);


            return AuthResponse.builder()
                    .userId(savedUser.getId())
                    .userName(savedUser.getUserName())
                    .email(savedUser.getEmail())
                    .role(savedUser.getRole())
                    .token(jwtToken)
                    .refreshToken(refreshToken.getRefreshToken())
                    .message("Customer registered successfully!")
                    .build();
        }

}
