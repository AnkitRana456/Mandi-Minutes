package com.MandiMinutes.MMBackend.User;

import com.MandiMinutes.MMBackend.Business.BusinessRegisterRequest;
import com.MandiMinutes.MMBackend.Business.BusinessService;
import com.MandiMinutes.MMBackend.Customer.CustomerRegisterRequest;
import com.MandiMinutes.MMBackend.Customer.CustomerService;
import com.MandiMinutes.MMBackend.RequestDTO.LoginRequest;
import com.MandiMinutes.MMBackend.ResponseDTO.AuthResponse;
import com.MandiMinutes.MMBackend.Rider.RiderRegisterRequest;
import com.MandiMinutes.MMBackend.Rider.RiderService;
import lombok.AllArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("api/v1/user")
@AllArgsConstructor
public class UserController {

    private final UserService userService;
    private final RiderService riderService;
    private final CustomerService customerService;
    private final BusinessService businessService;



    @PostMapping("/register/rider")
    public ResponseEntity<AuthResponse> registerRider(@RequestBody RiderRegisterRequest registerRequest)throws  Exception{
        return ResponseEntity.ok(riderService.registerRider(registerRequest));
    }

    @PostMapping("/register/customer")
    public ResponseEntity<AuthResponse> registerCustomer(@RequestBody CustomerRegisterRequest registerRequest)throws  Exception{
        return ResponseEntity.ok(customerService.registerCustomer(registerRequest));
    }

    @PostMapping("/register/business")
    public ResponseEntity<AuthResponse> registerBusiness(@RequestBody BusinessRegisterRequest registerRequest)throws  Exception{
        return ResponseEntity.ok(businessService.registerBusiness(registerRequest));
    }



    @PostMapping("/login")
    public ResponseEntity<AuthResponse> loginUser(@RequestBody LoginRequest loginRequest)throws  Exception{
        return ResponseEntity.ok(userService.loginUser(loginRequest));
    }

    @GetMapping("/hello")
    @PreAuthorize("hasRole('USER')")
    public String userHello() {
        return "Hello User";
    }


}
