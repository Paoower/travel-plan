-- PostgreSQL Schema for Travel Management System
-- Handles: Users, Travels, Payments, Destinations

-- ============================================
-- USERS TABLE
-- ============================================
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    role VARCHAR(50) NOT NULL DEFAULT 'USER' CHECK (role IN ('ADMIN', 'USER', 'TRAVEL_AGENT')),
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_role ON users(role);
CREATE INDEX idx_users_is_active ON users(is_active);

-- ============================================
-- DESTINATIONS TABLE (for Neo4j reference)
-- ============================================
CREATE TABLE destinations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL UNIQUE,
    country VARCHAR(100) NOT NULL,
    description TEXT,
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_destinations_country ON destinations(country);

-- ============================================
-- TRAVELS TABLE (parent entity)
-- ============================================
CREATE TABLE travels (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title VARCHAR(255) NOT NULL,
    description TEXT,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    duration_days INT NOT NULL,
    created_by_user_id UUID NOT NULL REFERENCES users(id) ON DELETE SET NULL,
    status VARCHAR(50) NOT NULL DEFAULT 'DRAFT'
        CHECK (status IN ('DRAFT', 'PUBLISHED', 'ONGOING', 'COMPLETED', 'CANCELLED')),
    budget DECIMAL(10, 2),
    currency VARCHAR(3) DEFAULT 'USD',
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

CREATE INDEX idx_travels_created_by ON travels(created_by_user_id);
CREATE INDEX idx_travels_status ON travels(status);
CREATE INDEX idx_travels_start_date ON travels(start_date);

-- ============================================
-- TRAVEL_DESTINATIONS (Junction table - Many-to-Many)
-- ============================================
CREATE TABLE travel_destinations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    travel_id UUID NOT NULL REFERENCES travels(id) ON DELETE CASCADE,
    destination_id UUID NOT NULL REFERENCES destinations(id) ON DELETE CASCADE,
    order_in_itinerary INT NOT NULL,
    days_at_destination INT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(travel_id, destination_id)
);

CREATE INDEX idx_travel_destinations_travel_id ON travel_destinations(travel_id);
CREATE INDEX idx_travel_destinations_destination_id ON travel_destinations(destination_id);

-- ============================================
-- ACTIVITIES TABLE
-- ============================================
CREATE TABLE activities (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    travel_id UUID NOT NULL REFERENCES travels(id) ON DELETE CASCADE,
    destination_id UUID NOT NULL REFERENCES destinations(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    activity_date DATE NOT NULL,
    duration_hours DECIMAL(5, 2),
    cost DECIMAL(10, 2),
    currency VARCHAR(3) DEFAULT 'USD',
    max_participants INT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_activities_travel_id ON activities(travel_id);
CREATE INDEX idx_activities_destination_id ON activities(destination_id);
CREATE INDEX idx_activities_date ON activities(activity_date);

-- ============================================
-- ACCOMMODATIONS TABLE
-- ============================================
CREATE TABLE accommodations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    travel_id UUID NOT NULL REFERENCES travels(id) ON DELETE CASCADE,
    destination_id UUID NOT NULL REFERENCES destinations(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    accommodation_type VARCHAR(50) NOT NULL
        CHECK (accommodation_type IN ('HOTEL', 'HOSTEL', 'AIRBNB', 'RESORT', 'VILLA', 'APARTMENT')),
    address TEXT NOT NULL,
    check_in_date DATE NOT NULL,
    check_out_date DATE NOT NULL,
    number_of_nights INT NOT NULL,
    price_per_night DECIMAL(10, 2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'USD',
    total_cost DECIMAL(10, 2),
    number_of_rooms INT DEFAULT 1,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_accommodations_travel_id ON accommodations(travel_id);
CREATE INDEX idx_accommodations_destination_id ON accommodations(destination_id);
CREATE INDEX idx_accommodations_check_in ON accommodations(check_in_date);

-- ============================================
-- TRANSPORTATION TABLE
-- ============================================
CREATE TABLE transportation (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    travel_id UUID NOT NULL REFERENCES travels(id) ON DELETE CASCADE,
    from_destination_id UUID REFERENCES destinations(id) ON DELETE SET NULL,
    to_destination_id UUID REFERENCES destinations(id) ON DELETE SET NULL,
    transport_type VARCHAR(50) NOT NULL
        CHECK (transport_type IN ('FLIGHT', 'TRAIN', 'CAR', 'BUS', 'CRUISE', 'BIKE')),
    departure_date DATE NOT NULL,
    departure_time TIME,
    arrival_date DATE NOT NULL,
    arrival_time TIME,
    provider_name VARCHAR(255),
    booking_reference VARCHAR(255),
    cost DECIMAL(10, 2),
    currency VARCHAR(3) DEFAULT 'USD',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_transportation_travel_id ON transportation(travel_id);
CREATE INDEX idx_transportation_from_dest ON transportation(from_destination_id);
CREATE INDEX idx_transportation_to_dest ON transportation(to_destination_id);
CREATE INDEX idx_transportation_departure ON transportation(departure_date);

-- ============================================
-- PAYMENT METHODS TABLE
-- ============================================
CREATE TABLE payment_methods (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    payment_type VARCHAR(50) NOT NULL
        CHECK (payment_type IN ('STRIPE', 'PAYPAL', 'BANK_TRANSFER', 'CREDIT_CARD')),
    is_primary BOOLEAN NOT NULL DEFAULT false,
    is_active BOOLEAN NOT NULL DEFAULT true,
    -- Stripe specific
    stripe_customer_id VARCHAR(255),
    stripe_payment_method_id VARCHAR(255),
    stripe_card_last_four VARCHAR(4),
    stripe_card_brand VARCHAR(50),
    -- PayPal specific
    paypal_email VARCHAR(255),
    paypal_payer_id VARCHAR(255),
    -- Bank transfer specific
    bank_account_holder VARCHAR(255),
    bank_iban VARCHAR(34),
    bank_bic VARCHAR(11),
    -- Generic
    billing_address TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

CREATE INDEX idx_payment_methods_user_id ON payment_methods(user_id);
CREATE INDEX idx_payment_methods_is_primary ON payment_methods(is_primary);
CREATE INDEX idx_payment_methods_payment_type ON payment_methods(payment_type);

-- ============================================
-- PAYMENTS TABLE
-- ============================================
CREATE TABLE payments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    travel_id UUID NOT NULL REFERENCES travels(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE SET NULL,
    payment_method_id UUID NOT NULL REFERENCES payment_methods(id) ON DELETE RESTRICT,
    amount DECIMAL(10, 2) NOT NULL,
    currency VARCHAR(3) NOT NULL DEFAULT 'USD',
    status VARCHAR(50) NOT NULL DEFAULT 'PENDING'
        CHECK (status IN ('PENDING', 'PROCESSING', 'COMPLETED', 'FAILED', 'REFUNDED')),
    payment_type VARCHAR(50) NOT NULL
        CHECK (payment_type IN ('STRIPE', 'PAYPAL', 'BANK_TRANSFER')),
    -- Transaction references
    transaction_id VARCHAR(255) UNIQUE,
    stripe_payment_intent_id VARCHAR(255),
    paypal_transaction_id VARCHAR(255),
    -- Metadata
    description TEXT,
    metadata JSONB,
    attempted_at TIMESTAMP,
    completed_at TIMESTAMP,
    failed_reason TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_payments_travel_id ON payments(travel_id);
CREATE INDEX idx_payments_user_id ON payments(user_id);
CREATE INDEX idx_payments_status ON payments(status);
CREATE INDEX idx_payments_payment_type ON payments(payment_type);
CREATE INDEX idx_payments_created_at ON payments(created_at);

-- ============================================
-- TRAVEL_PARTICIPANTS (Who is going on the travel)
-- ============================================
CREATE TABLE travel_participants (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    travel_id UUID NOT NULL REFERENCES travels(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    role VARCHAR(50) NOT NULL DEFAULT 'PARTICIPANT'
        CHECK (role IN ('ORGANIZER', 'PARTICIPANT', 'OBSERVER')),
    joined_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(travel_id, user_id)
);

CREATE INDEX idx_travel_participants_travel_id ON travel_participants(travel_id);
CREATE INDEX idx_travel_participants_user_id ON travel_participants(user_id);

-- ============================================
-- AUDIT LOG TABLE
-- ============================================
CREATE TABLE audit_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE SET NULL,
    entity_type VARCHAR(100) NOT NULL,
    entity_id UUID NOT NULL,
    action VARCHAR(50) NOT NULL CHECK (action IN ('CREATE', 'UPDATE', 'DELETE')),
    old_values JSONB,
    new_values JSONB,
    ip_address VARCHAR(45),
    user_agent TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_audit_logs_user_id ON audit_logs(user_id);
CREATE INDEX idx_audit_logs_entity ON audit_logs(entity_type, entity_id);
CREATE INDEX idx_audit_logs_created_at ON audit_logs(created_at);

-- ============================================
-- TRIGGERS for updated_at
-- ============================================
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_travels_updated_at BEFORE UPDATE ON travels
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_destinations_updated_at BEFORE UPDATE ON destinations
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_activities_updated_at BEFORE UPDATE ON activities
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_accommodations_updated_at BEFORE UPDATE ON accommodations
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_transportation_updated_at BEFORE UPDATE ON transportation
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_payment_methods_updated_at BEFORE UPDATE ON payment_methods
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_payments_updated_at BEFORE UPDATE ON payments
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
