package com.MandiMinutes.MMBackend.SecurityConfig;

import com.MandiMinutes.MMBackend.User.User;
import com.MandiMinutes.MMBackend.User.UserRepository;
import lombok.AllArgsConstructor;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Component;

@Component
@AllArgsConstructor
public class CustomUserDetailsService implements UserDetailsService {

    private final UserRepository userRepository;

    @Override
    public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {
        User user = userRepository.findByEmail(email);
        if(user==null)throw new UsernameNotFoundException("User with thie email is not registered");

        return org.springframework.security.core.userdetails.User.builder()
                .username(user.getEmail())
                .roles(user.getRole().name())
                .password(user.getPassword())
                .build();


    }
}
