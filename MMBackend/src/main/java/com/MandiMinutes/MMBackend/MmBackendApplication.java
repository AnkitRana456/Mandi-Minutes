package com.MandiMinutes.MMBackend;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableAsync;

@EnableAsync
@SpringBootApplication
public class MmBackendApplication {

	public static void main(String[] args) {
		SpringApplication.run(MmBackendApplication.class, args);
	}

}
