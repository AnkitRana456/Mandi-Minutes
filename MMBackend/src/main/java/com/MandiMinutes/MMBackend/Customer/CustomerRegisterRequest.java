package com.MandiMinutes.MMBackend.Customer;


import com.MandiMinutes.MMBackend.RequestDTO.BaseRegisterRequest;
import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class CustomerRegisterRequest extends BaseRegisterRequest {

    private String defaultAddress;
    private String emergencyContactPhone;
}
