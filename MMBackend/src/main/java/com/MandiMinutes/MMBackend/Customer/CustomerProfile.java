package com.MandiMinutes.MMBackend.Customer;

import com.MandiMinutes.MMBackend.User.User;
import jakarta.persistence.*;
import lombok.*;

@Builder
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Entity
@Table(name = "customer_profiles")
public class CustomerProfile {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", referencedColumnName = "id", nullable = false, unique = true)
    private User user;

    @Column(name = "default_address")
    private String defaultAddress;

    // Direct registration ke ilawa Proxy/Ghost Delivery ke fallback details
    @Column(name = "emergency_contact_phone")
    private String emergencyContactPhone;

}
