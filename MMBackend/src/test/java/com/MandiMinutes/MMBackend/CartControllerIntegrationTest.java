package com.MandiMinutes.MMBackend;




import com.MandiMinutes.MMBackend.Product.Product;
import com.MandiMinutes.MMBackend.Product.ProductRepository;
import com.MandiMinutes.MMBackend.RequestDTO.CartItemRequest;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.webmvc.test.autoconfigure.AutoConfigureMockMvc;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;

import java.math.BigDecimal;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest
@AutoConfigureMockMvc
@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
public class CartControllerIntegrationTest {

    @Autowired
    private MockMvc mockMvc;


    private final ObjectMapper objectMapper=new ObjectMapper();

    @Autowired
    private ProductRepository productRepository;

    private static String token;
    private static Long testProductId;

    @BeforeEach
    void setUp() throws Exception {

        if (testProductId == null) {
            Product product = new Product("Test Apple", new BigDecimal("100.00"), "1 kg", 50);
            Product savedProduct = productRepository.save(product);
            testProductId = savedProduct.getId();
        }


        if (token == null) {
            String loginRequestBody = """
                {
                  "email": "rahul.customer@gmail.com",
                  "password": "Password123",
                  "role": "CUSTOMER"
                }
                """;

            MvcResult result = mockMvc.perform(post("/api/v1/user/login")
                            .contentType(MediaType.APPLICATION_JSON)
                            .content(loginRequestBody))
                    .andExpect(status().isOk())
                    .andReturn();

            String responseString = result.getResponse().getContentAsString();
            JsonNode jsonNode = objectMapper.readTree(responseString);

            if (jsonNode.has("token")) {
                token = jsonNode.get("token").asText();
            } else if (jsonNode.has("jwtToken")) {
                token = jsonNode.get("jwtToken").asText();
            } else if (jsonNode.has("accessToken")) {
                token = jsonNode.get("accessToken").asText();
            } else {
                token = jsonNode.asText();
            }
        }
    }

    @Test
    @Order(1)
    @DisplayName("1. Add Item to Cart - Success")
    void addToCart_Success() throws Exception {

        CartItemRequest request = new CartItemRequest(testProductId, 2);

        mockMvc.perform(post("/api/v1/cart/add")
                        .header("Authorization", "Bearer " + token)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.items").isArray());
    }

    @Test
    @Order(2)
    @DisplayName("2. Get Cart for Logged-in User - Success")
    void getCart_Success() throws Exception {
        mockMvc.perform(get("/api/v1/cart/getCart")
                        .header("Authorization", "Bearer " + token))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.items").exists());
    }

    @Test
    @Order(3)
    @DisplayName("3. Update Cart Item Quantity - Success")
    void updateQuantity_Success() throws Exception {
        mockMvc.perform(put("/api/v1/cart/items")
                        .header("Authorization", "Bearer " + token)
                        .param("productId", String.valueOf(testProductId))
                        .param("quantity", "5"))
                .andExpect(status().isOk());
    }

    @Test
    @Order(4)
    @DisplayName("4. Remove Single Item from Cart - Success")
    void removeItem_Success() throws Exception {
        mockMvc.perform(delete("/api/v1/cart/deleteItems")
                        .header("Authorization", "Bearer " + token)
                        .param("productId", String.valueOf(testProductId)))
                .andExpect(status().isOk());
    }

    @Test
    @Order(5)
    @DisplayName("5. Clear Whole Cart - Success")
    void clearCart_Success() throws Exception {
        mockMvc.perform(delete("/api/v1/cart/clear")
                        .header("Authorization", "Bearer " + token))
                .andExpect(status().isNoContent());
    }

    @Test
    @Order(6)
    @DisplayName("6. Access Cart without Bearer Token - 401/403 Unauthorized")
    void accessCart_WithoutToken_Fails() throws Exception {
        mockMvc.perform(get("/api/v1/cart/getCart"))
                .andExpect(status().is4xxClientError());
    }
}