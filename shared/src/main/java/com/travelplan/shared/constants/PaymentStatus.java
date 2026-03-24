package com.travelplan.shared.constants;

public final class PaymentStatus {

    public static final String PENDING = "PENDING";
    public static final String COMPLETED = "COMPLETED";
    public static final String FAILED = "FAILED";
    public static final String REFUNDED = "REFUNDED";

    private PaymentStatus() {
        throw new AssertionError("Cannot instantiate PaymentStatus");
    }
}
