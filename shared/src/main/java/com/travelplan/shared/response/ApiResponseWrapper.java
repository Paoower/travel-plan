package com.travelplan.shared.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDateTime;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class ApiResponseWrapper<T> {

    private boolean success;
    private String message;
    private T data;

    @JsonProperty("error_code")
    private String errorCode;

    private LocalDateTime timestamp;

    public static <T> ApiResponseWrapper<T> success(T data, String message) {
        return ApiResponseWrapper.<T>builder()
                .success(true)
                .data(data)
                .message(message)
                .timestamp(LocalDateTime.now())
                .build();
    }

    public static <T> ApiResponseWrapper<T> success(T data) {
        return success(data, "Operation successful");
    }

    public static <T> ApiResponseWrapper<T> error(String message, String errorCode) {
        return ApiResponseWrapper.<T>builder()
                .success(false)
                .message(message)
                .errorCode(errorCode)
                .timestamp(LocalDateTime.now())
                .build();
    }
}
