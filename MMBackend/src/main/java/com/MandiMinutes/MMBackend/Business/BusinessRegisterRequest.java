package com.MandiMinutes.MMBackend.Business;

import com.MandiMinutes.MMBackend.RequestDTO.BaseRegisterRequest;
import jakarta.validation.constraints.NotBlank;
import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class BusinessRegisterRequest extends BaseRegisterRequest {

    @NotBlank(message = "Business name is required")
    private String businessName;

    private String gstinNumber;

    private Long assignedStoreId;
}
