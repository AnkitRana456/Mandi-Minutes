package com.MandiMinutes.MMBackend.Business;

import com.MandiMinutes.MMBackend.RefreshToken.RefreshToken;
import com.MandiMinutes.MMBackend.RefreshToken.RefreshTokenService;
import com.MandiMinutes.MMBackend.ResponseDTO.AuthResponse;
import com.MandiMinutes.MMBackend.SecurityConfig.JwtService;
import com.MandiMinutes.MMBackend.User.Role;
import com.MandiMinutes.MMBackend.User.User;
import com.MandiMinutes.MMBackend.User.UserRepository;
import com.MandiMinutes.MMBackend.exception.ResourceAlreadyExistsException;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.jspecify.annotations.Nullable;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Slf4j
@AllArgsConstructor
public class BusinessService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final BusinessProfileRepository businessProfileRepository;
    private final JwtService jwtService;
    private final RefreshTokenService refreshTokenService;

    @Transactional
    public @Nullable AuthResponse registerBusiness(BusinessRegisterRequest registerRequest) {
        if (userRepository.existsByEmail(registerRequest.getEmail())) {
            throw new ResourceAlreadyExistsException("Email '" + registerRequest.getEmail() + "' is already registered!");
        }


        User user = User.builder()
                .userName(registerRequest.getUserName())
                .email(registerRequest.getEmail())
                .phoneNumber(registerRequest.getPhoneNumber())
                .password(passwordEncoder.encode(registerRequest.getPassword()))
                .role(Role.BUSINESS)
                .isActive(true)
                .build();

        User savedUser = userRepository.save(user);


        BusinessProfile profile = BusinessProfile.builder()
                .user(savedUser)
                .businessName(registerRequest.getBusinessName())
                .gstinNumber(registerRequest.getGstinNumber())
                .assignedStoreId(registerRequest.getAssignedStoreId())
                .isVerified(false)
                .build();

        businessProfileRepository.save(profile);
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
                .message("Business/Vendor registered successfully! Pending store verification.")
                .build();
    }
}


