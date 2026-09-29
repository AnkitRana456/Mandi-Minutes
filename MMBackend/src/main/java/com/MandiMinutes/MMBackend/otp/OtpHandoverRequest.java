package com.MandiMinutes.MMBackend.otp;

import lombok.*;

@Data
@Builder
@AllArgsConstructor
@Getter
@Setter
@NoArgsConstructor
public class OtpHandoverRequest {
    private String phoneNumber;
    private String otp;
    private String referenceId;
}
