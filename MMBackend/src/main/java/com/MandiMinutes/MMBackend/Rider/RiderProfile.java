package com.MandiMinutes.MMBackend.Rider;

import com.MandiMinutes.MMBackend.User.User;
import jakarta.persistence.*;
import lombok.*;

@Entity
@Builder
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@Table(name = "riders")
public class RiderProfile {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", referencedColumnName = "id", nullable = false, unique = true)
    private User user;

    @Column(name = "vehicle_number", nullable = false)
    private String vehicleNumber;

    @Column(name = "license_number", nullable = false)
    private String licenseNumber;

    @Column(name = "assigned_store_id")
    private Long assignedStoreId;

    @Builder.Default
    @Column(name = "is_online", nullable = false)
    private Boolean isOnline = false;

    @Builder.Default
    @Column(name = "is_approved", nullable = false)
    private Boolean isApproved = false;
}
