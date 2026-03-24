package com.travelplan.shared.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

/**
 * JWT Authentication response containing the token and user info
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class JwtTokenResponse {
    private String accessToken;
    private String tokenType;
    private long expiresIn;
    private String username;
    private String email;
    private List<String> roles;
}
