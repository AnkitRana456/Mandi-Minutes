package com.MandiMinutes.MMBackend.Business;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface BusinessProfileRepository extends JpaRepository<BusinessProfile,Long> {
    java.util.Optional<BusinessProfile> findByUserId(Long userId);
}

