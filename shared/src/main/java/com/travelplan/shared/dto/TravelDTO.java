package com.travelplan.shared.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.validation.constraints.Future;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.Set;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class TravelDTO {

    private String id;

    @NotBlank(message = "Title is required")
    private String title;

    private String description;

    @NotNull(message = "Start date is required")
    @Future(message = "Start date must be in the future")
    @JsonProperty("start_date")
    private LocalDate startDate;

    @NotNull(message = "End date is required")
    @JsonProperty("end_date")
    private LocalDate endDate;

    @NotNull(message = "Duration is required")
    @Positive(message = "Duration must be positive")
    @JsonProperty("duration_days")
    private Integer durationDays;

    @JsonProperty("created_by_user_id")
    private String createdByUserId;

    private String status;

    @Positive(message = "Budget must be positive if provided")
    private BigDecimal budget;

    private String currency;

    @JsonProperty("is_active")
    private Boolean isActive;

    @JsonProperty("destination_ids")
    private Set<String> destinationIds;

    @JsonProperty("created_at")
    private String createdAt;

    @JsonProperty("updated_at")
    private String updatedAt;
}
