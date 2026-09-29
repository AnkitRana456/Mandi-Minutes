package com.MandiMinutes.MMBackend.RefreshToken;

import com.MandiMinutes.MMBackend.User.User;
import jakarta.persistence.*;
import lombok.*;

import java.time.Instant;

@Entity
@Table(name = "refresh_tokens")
@Getter
@Setter
@AllArgsConstructor
@Builder
@NoArgsConstructor
public class RefreshToken {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Column(name = "refresh_token",nullable = false)
    private String refreshToken;

    @Column(name = "expiry_date")
    private Instant expiryDate;

    @OneToOne
    private User user;
}
