package com.travelplan.shared.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class PaymentDTO {

    private String id;

    @NotNull(message = "Travel ID is required")
    @JsonProperty("travel_id")
    private String travelId;

    @NotNull(message = "User ID is required")
    @JsonProperty("user_id")
    private String userId;

    @NotNull(message = "Amount is required")
    @Positive(message = "Amount must be positive")
    private BigDecimal amount;

    private String currency;

    @NotBlank(message = "Payment method is required")
    @JsonProperty("payment_method")
    private String paymentMethod; // STRIPE, PAYPAL

    private String status; // PENDING, COMPLETED, FAILED, REFUNDED

    @JsonProperty("transaction_id")
    private String transactionId;

    @JsonProperty("payment_details")
    private String paymentDetails; // JSON serialized payment details

    @JsonProperty("created_at")
    private String createdAt;

    @JsonProperty("updated_at")
    private String updatedAt;
}
