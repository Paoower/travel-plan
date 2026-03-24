# API Endpoints Quick Reference

## Gateway Entry Point
Base URL: `http://localhost:8080`

## Authentication Service
Base URL: `http://localhost:8001/api/auth`

### Register User
```
POST /api/auth/register
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "SecurePassword123!",
  "firstName": "John",
  "lastName": "Doe",
  "phone": "+1234567890"
}

Response:
{
  "success": true,
  "message": "User registered successfully",
  "data": {
    "id": "uuid",
    "email": "user@example.com",
    "firstName": "John",
    "lastName": "Doe",
    "role": "USER",
    "isActive": true,
    "createdAt": "2026-03-23T10:30:00"
  },
  "timestamp": "2026-03-23T10:30:00"
}
```

### Login
```
POST /api/auth/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "SecurePassword123!"
}

Response:
{
  "success": true,
  "message": "Login successful",
  "data": {
    "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "tokenType": "Bearer",
    "expiresIn": 86400000,
    "user": {
      "id": "uuid",
      "email": "user@example.com",
      "firstName": "John",
      "lastName": "Doe",
      "role": "USER"
    }
  },
  "timestamp": "2026-03-23T10:30:00"
}
```

---

## User Service
Base URL: `http://localhost:8002/api/users`

### List All Users (Admin Only)
```
GET /api/users?page=0&size=10&sort=createdAt,desc
Authorization: Bearer <token>

Response:
{
  "success": true,
  "data": [
    {
      "id": "uuid",
      "email": "user@example.com",
      "firstName": "John",
      "lastName": "Doe",
      "role": "USER",
      "isActive": true
    }
  ],
  "timestamp": "2026-03-23T10:30:00"
}
```

### Get User by ID
```
GET /api/users/{userId}
Authorization: Bearer <token>

Response:
{
  "success": true,
  "data": {
    "id": "uuid",
    "email": "user@example.com",
    "firstName": "John",
    "lastName": "Doe",
    "phone": "+1234567890",
    "role": "USER",
    "isActive": true,
    "createdAt": "2026-03-23T10:30:00",
    "updatedAt": "2026-03-23T10:30:00"
  },
  "timestamp": "2026-03-23T10:30:00"
}
```

### Update User
```
PUT /api/users/{userId}
Authorization: Bearer <token>
Content-Type: application/json

{
  "firstName": "Jane",
  "lastName": "Smith",
  "phone": "+9876543210"
}

Response:
{
  "success": true,
  "message": "User updated successfully",
  "data": { ... },
  "timestamp": "2026-03-23T10:30:00"
}
```

### Delete User (Soft Delete)
```
DELETE /api/users/{userId}
Authorization: Bearer <token>

Response:
{
  "success": true,
  "message": "User deleted successfully",
  "timestamp": "2026-03-23T10:30:00"
}
```

---

## Travel Service
Base URL: `http://localhost:8003/api/travels`

### List Travels
```
GET /api/travels?page=0&size=10
Authorization: Bearer <token>

Response:
{
  "success": true,
  "data": [
    {
      "id": "uuid",
      "title": "Paris Trip 2026",
      "description": "Summer vacation to Paris",
      "startDate": "2026-06-01",
      "endDate": "2026-06-10",
      "durationDays": 10,
      "status": "PUBLISHED",
      "budget": 5000.00,
      "currency": "USD",
      "isActive": true,
      "createdAt": "2026-03-23T10:30:00"
    }
  ],
  "timestamp": "2026-03-23T10:30:00"
}
```

### Create Travel
```
POST /api/travels
Authorization: Bearer <token>
Content-Type: application/json

{
  "title": "Paris Trip 2026",
  "description": "Summer vacation to Paris",
  "startDate": "2026-06-01",
  "endDate": "2026-06-10",
  "durationDays": 10,
  "budget": 5000.00,
  "currency": "USD",
  "destinationIds": ["dest-uuid-1", "dest-uuid-2"]
}

Response:
{
  "success": true,
  "message": "Travel created successfully",
  "data": {
    "id": "uuid",
    "title": "Paris Trip 2026",
    ...
  },
  "timestamp": "2026-03-23T10:30:00"
}
```

### Update Travel
```
PUT /api/travels/{travelId}
Authorization: Bearer <token>
Content-Type: application/json

{
  "title": "Updated Title",
  "status": "ONGOING"
}

Response:
{
  "success": true,
  "message": "Travel updated successfully",
  "data": { ... },
  "timestamp": "2026-03-23T10:30:00"
}
```

### Delete Travel
```
DELETE /api/travels/{travelId}
Authorization: Bearer <token>

Response:
{
  "success": true,
  "message": "Travel deleted successfully",
  "timestamp": "2026-03-23T10:30:00"
}
```

### Get Travel Destinations
```
GET /api/travels/{travelId}/destinations
Authorization: Bearer <token>

Response:
{
  "success": true,
  "data": [
    {
      "id": "uuid",
      "name": "Paris",
      "country": "France",
      "latitude": 48.8566,
      "longitude": 2.3522,
      "orderInItinerary": 1,
      "daysAtDestination": 5
    }
  ],
  "timestamp": "2026-03-23T10:30:00"
}
```

---

## Payment Service
Base URL: `http://localhost:8004/api/payments`

### Process Payment
```
POST /api/payments/process
Authorization: Bearer <token>
Content-Type: application/json

{
  "travelId": "uuid",
  "amount": 5000.00,
  "currency": "USD",
  "paymentMethod": "STRIPE",
  "paymentDetails": {
    "cardToken": "tok_visa",
    "cardLastFour": "4242"
  }
}

Response:
{
  "success": true,
  "message": "Payment processed successfully",
  "data": {
    "id": "uuid",
    "travelId": "uuid",
    "amount": 5000.00,
    "status": "COMPLETED",
    "transactionId": "ch_1234567890",
    "paymentMethod": "STRIPE",
    "createdAt": "2026-03-23T10:30:00"
  },
  "timestamp": "2026-03-23T10:30:00"
}
```

### Get Payment Details
```
GET /api/payments/{paymentId}
Authorization: Bearer <token>

Response:
{
  "success": true,
  "data": { ... },
  "timestamp": "2026-03-23T10:30:00"
}
```

### Refund Payment
```
POST /api/payments/{paymentId}/refund
Authorization: Bearer <token>
Content-Type: application/json

{
  "reason": "Customer requested refund"
}

Response:
{
  "success": true,
  "message": "Refund processed successfully",
  "data": {
    "id": "uuid",
    "status": "REFUNDED",
    "refundAmount": 5000.00,
    "refundedAt": "2026-03-23T10:30:00"
  },
  "timestamp": "2026-03-23T10:30:00"
}
```

---

## Common Response Status Codes

- **200 OK**: Request succeeded
- **201 Created**: Resource created successfully
- **204 No Content**: Request succeeded, no content to return
- **400 Bad Request**: Invalid request format or validation error
- **401 Unauthorized**: Missing or invalid authentication token
- **403 Forbidden**: User lacks permission for the resource
- **404 Not Found**: Resource not found
- **409 Conflict**: Resource already exists (duplicate)
- **500 Internal Server Error**: Server error occurred

---

## Authentication Header Format

All protected endpoints require the Authorization header:

```
Authorization: Bearer <JWT_TOKEN>
```

Example using curl:
```bash
curl -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..." \
     http://localhost:8080/api/users
```

---

## Testing with Postman/Insomnia

1. Get token from login endpoint
2. Copy the `accessToken` value
3. Create a collection variable: `{{token}}`
4. In Authorization tab, select "Bearer Token"
5. Use `{{token}}` in the Token field
6. All requests will now include the token automatically

---

Last Updated: March 23, 2026
