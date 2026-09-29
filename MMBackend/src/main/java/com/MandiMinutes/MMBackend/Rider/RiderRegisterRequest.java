package com.MandiMinutes.MMBackend.Rider;


import com.MandiMinutes.MMBackend.RequestDTO.BaseRegisterRequest;
import jakarta.validation.constraints.NotBlank;
import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class RiderRegisterRequest extends BaseRegisterRequest {

    @NotBlank(message = "Vehicle number is required")
    private String vehicleNumber;

    @NotBlank(message = "License number is required")
    private String licenseNumber;

    private Long assignedStoreId;
}