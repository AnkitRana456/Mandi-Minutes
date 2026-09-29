package com.MandiMinutes.MMBackend.otp;

import jakarta.persistence.Column;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.HashMap;
import java.util.Map;

@Service
public class WhatsappOtpService {

    private final RestTemplate restTemplate;


    private final String NODE_WHATSAPP_SERVICE_URL = "http://localhost:3000/send-otp";

    public WhatsappOtpService() {
        this.restTemplate = new RestTemplate();
    }


    public void sendOtpViaWhatsApp(String phoneNumber, String message) {
        try{
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);

            Map<String, String> body = new HashMap<>();
            body.put("phone", phoneNumber);
            body.put("message", message);

            HttpEntity<Map<String, String>> requestEntity = new HttpEntity<>(body, headers);

            restTemplate.postForEntity(NODE_WHATSAPP_SERVICE_URL, requestEntity, String.class);

            System.out.println(" WhatsApp trigger sent to Node Service for: " + phoneNumber);
        }
        catch (Exception e) {
            System.err.println(" Failed to send WhatsApp message via Node Service: " + e.getMessage());

        }
    }
}
