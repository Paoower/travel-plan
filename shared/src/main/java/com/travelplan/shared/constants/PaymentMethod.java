package com.travelplan.shared.constants;

public final class PaymentMethod {

    public static final String STRIPE = "STRIPE";
    public static final String PAYPAL = "PAYPAL";

    private PaymentMethod() {
        throw new AssertionError("Cannot instantiate PaymentMethod");
    }
}
