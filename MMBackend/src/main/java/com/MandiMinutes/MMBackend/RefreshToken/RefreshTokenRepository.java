package com.MandiMinutes.MMBackend.RefreshToken;

import com.MandiMinutes.MMBackend.User.User;
import lombok.NonNull;
import org.springframework.data.jpa.repository.JpaRepository;


import java.util.Optional;

public interface RefreshTokenRepository  extends JpaRepository<RefreshToken,Long> {
    Optional<RefreshToken> findByUser(@NonNull User user);

    RefreshToken findByRefreshToken(String refreshToken);
}
