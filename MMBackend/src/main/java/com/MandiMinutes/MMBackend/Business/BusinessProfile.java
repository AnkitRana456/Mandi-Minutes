package com.MandiMinutes.MMBackend.Business;

import com.MandiMinutes.MMBackend.User.User;
import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "businesses")
@Setter
@Getter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class BusinessProfile {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", referencedColumnName = "id", nullable = false, unique = true)
    private User user;

    @Column(name = "business_name", nullable = false)
    private String businessName;

    @Column(name = "gstin_number")
    private String gstinNumber;

    @Column(name = "assigned_store_id")
    private Long assignedStoreId; // Link to DarkStore/Mandi Location Entity

    @Column(name = "is_verified", nullable = false)
    private Boolean isVerified = false;
}
