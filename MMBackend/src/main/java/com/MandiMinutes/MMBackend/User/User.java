package com.MandiMinutes.MMBackend.User;

import com.MandiMinutes.MMBackend.Business.BusinessProfile;
import com.MandiMinutes.MMBackend.Customer.CustomerProfile;
import com.MandiMinutes.MMBackend.Rider.RiderProfile;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "users")
@Setter
@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Column(name = "user_name", nullable = false)
    private String userName;

    @Column(name = "email", nullable = false, unique = true)
    private String email;
    @Column(name = "password", nullable = false)
    private String password;
    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private Role role;
    @Builder.Default
    @Column(name = "is_active", nullable = false)
    private Boolean isActive = true;
    @Column(name = "created_at")
    private LocalDateTime createdAt;
    @Column(name = "phone_number",nullable = false)
    private String phoneNumber;
    @PrePersist
    protected void onCreate() {
        this.createdAt = LocalDateTime.now();
    }
    @OneToOne(mappedBy = "user", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private CustomerProfile customerProfile;

    @OneToOne(mappedBy = "user", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private BusinessProfile businessProfile;

    @OneToOne(mappedBy = "user", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private RiderProfile riderProfile;


}
