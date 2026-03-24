package com.travelplan.shared.constants;

public final class RoleConstants {

    public static final String ADMIN = "ADMIN";
    public static final String USER = "USER";
    public static final String TRAVEL_AGENT = "TRAVEL_AGENT";

    private RoleConstants() {
        throw new AssertionError("Cannot instantiate RoleConstants");
    }
}
