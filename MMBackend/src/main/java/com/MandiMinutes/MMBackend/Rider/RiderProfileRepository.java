package com.MandiMinutes.MMBackend.Rider;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface RiderProfileRepository  extends JpaRepository<RiderProfile,Long> {
}
