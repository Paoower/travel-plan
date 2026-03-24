package com.travelplan.shared.constants;

public final class TravelStatus {

    public static final String DRAFT = "DRAFT";
    public static final String PUBLISHED = "PUBLISHED";
    public static final String ONGOING = "ONGOING";
    public static final String COMPLETED = "COMPLETED";
    public static final String CANCELLED = "CANCELLED";

    private TravelStatus() {
        throw new AssertionError("Cannot instantiate TravelStatus");
    }
}
