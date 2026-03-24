# Travel Plan - Microservices Architecture

> 📚 **Full documentation available in `/docs` folder** | [Getting Started](docs/PHASE1_COMPLETE.md) | [Quick Reference](docs/QUICK_REFERENCE.md) | [Contributing](docs/CONTRIBUTING.md)

## Overview

Travel Plan est un système de gestion de voyages construit sur une **architecture microservices** utilisant **Spring Boot** et déployé via **Docker** et **Kubernetes**.

## Stack Technologique

### Backend
- **Framework**: Spring Boot 3.2.0
- **Language**: Java 17
- **Build Tool**: Maven
- **Security**: Spring Security + JWT (JJWT)
- **Database**: PostgreSQL (Transactionnel) + Neo4j (Graphe)
- **Service Discovery**: Netflix Eureka
- **API Gateway**: Spring Cloud Gateway

### DevOps
- **Containerization**: Docker
- **Orchestration**: Docker Compose (Phase 1), Kubernetes (Phase 3 - Bonus)
- **CI/CD**: Jenkins
- **Code Quality**: SonarQube
- **Code Coverage**: JaCoCo
- **Logging**: ELK Stack (ElasticSearch, Logstash, Kibana)

### Testing
- **Unit Tests**: JUnit 5 + Mockito
- **Integration Tests**: TestContainers (PostgreSQL, Neo4j)
- **E2E Tests**: Cypress/Postman

## Project Structure

```
travel-plan/
├── shared/                          # Shared library (DTOs, exceptions, constants)
│   ├── src/main/java/
│   │   └── com/travelplan/shared/
│   │       ├── dto/                # Data Transfer Objects
│   │       ├── response/           # Response wrappers
│   │       ├── exception/          # Custom exceptions
│   │       └── constants/          # Application constants
│   └── pom.xml
│
├── services/                        # Microservices container
│   ├── auth-service/               # Authentication & Authorization
│   │   ├── src/main/java/com/travelplan/authservice/
│   │   │   ├── entity/            # JPA entities
│   │   │   ├── repository/        # Data access layer
│   │   │   ├── service/           # Business logic
│   │   │   ├── controller/        # REST endpoints
│   │   │   └── config/            # Spring configuration
│   │   ├── src/test/java/         # Unit tests
│   │   └── pom.xml
│   │
│   ├── user-service/               # User Management
│   │   └── [Same structure as auth-service]
│   │
│   ├── travel-service/             # Travel Management (PostgreSQL + Neo4j)
│   │   └── [Same structure as auth-service]
│   │
│   ├── payment-service/            # Payment Gateway (Stripe & PayPal)
│   │   └── [Same structure as auth-service]
│   │
│   └── pom.xml
│
├── api-gateway/                    # API Gateway for routing
│   ├── src/main/java/com/travelplan/apigateway/
│   │   ├── filter/                # Custom filters
│   │   ├── config/                # Gateway configuration
│   │   └── ApiGatewayApplication.java
│   ├── src/test/java/
│   └── pom.xml
│
├── db/
│   ├── 01-postgresql-schema.sql    # PostgreSQL DDL
│   └── 02-neo4j-schema.cypher      # Neo4j schema definitions
│
├── docker/                         # Docker configuration
│   ├── docker-compose.yml          # Local development
│   └── [Dockerfile per service]
│
├── k8s/                            # Kubernetes manifests (Bonus)
│   ├── deployments/
│   ├── services/
│   ├── configmaps/
│   └── secrets/
│
├── ansible/                        # Ansible playbooks
│   ├── playbooks/
│   ├── roles/
│   └── inventory/
│
├── pom.xml                         # Parent POM for Maven
└── README.md
```

## Microservices Overview

### 1. Auth Service (Port 8001)
**Responsibility**: Authentification, autorisation, gestion JWT

**Features**:
- User registration
- User login (JWT token generation)
- Token validation
- Password hashing (BCrypt)
- Role-based access control (RBAC)

**Database**: PostgreSQL
**Endpoints**:
- `POST /api/auth/register` - Register new user
- `POST /api/auth/login` - Login user
- `POST /api/auth/validate` - Validate JWT token
- `POST /api/auth/refresh` - Refresh JWT token

---

### 2. User Service (Port 8002)
**Responsibility**: CRUD opérations sur les utilisateurs

**Features**:
- Get all users (Admin only)
- Get user by ID
- Create user
- Update user
- Delete user (soft delete)
- User listing with pagination

**Database**: PostgreSQL
**Endpoints**:
- `GET /api/users` - List all users (paginated)
- `GET /api/users/{id}` - Get user details
- `POST /api/users` - Create user
- `PUT /api/users/{id}` - Update user
- `DELETE /api/users/{id}` - Soft delete user

---

### 3. Travel Service (Port 8003)
**Responsibility**: Gestion des voyages, destinations, activités

**Features**:
- CRUD operations on travels
- Manage destinations (PostgreSQL + Neo4j)
- Manage activities
- Travel itineraries
- Destination recommendations (Neo4j queries)

**Databases**: 
- PostgreSQL: Structured data (travels, activities)
- Neo4j: Graph data (destination relationships, recommendations)

**Endpoints**:
- `GET /api/travels` - List travels
- `POST /api/travels` - Create travel
- `PUT /api/travels/{id}` - Update travel
- `DELETE /api/travels/{id}` - Delete travel
- `GET /api/travels/{id}/destinations` - Get travel destinations
- `POST /api/travels/{id}/activities` - Add activity

---

### 4. Payment Service (Port 8004)
**Responsibility**: Traitement des paiements Stripe & PayPal

**Features**:
- Create payment
- Process Stripe payments
- Process PayPal payments
- Webhook handling
- Payment history
- Refund management

**Database**: PostgreSQL
**Endpoints**:
- `POST /api/payments/process` - Process payment
- `GET /api/payments/{id}` - Get payment details
- `POST /api/payments/{id}/refund` - Refund payment
- `POST /api/payments/webhook/stripe` - Stripe webhook
- `POST /api/payments/webhook/paypal` - PayPal webhook

---

### 5. API Gateway (Port 8080)
**Responsibility**: Request routing, load balancing, cross-cutting concerns

**Features**:
- Route requests to appropriate microservices
- JWT token validation
- Rate limiting
- Request/Response logging
- Service discovery integration

**Routes**:
- `/api/auth/**` → auth-service
- `/api/users/**` → user-service
- `/api/travels/**` → travel-service
- `/api/payments/**` → payment-service

## Running the Application

### Prerequisites
- Java 17+
- Maven 3.8+
- Docker & Docker Compose
- PostgreSQL 14+
- Neo4j 4.4+

### Local Development

1. **Build the project**:
```bash
cd /home/romain/Z01/projets/travel-plan
mvn clean install -DskipTests
```

2. **Start databases**:
```bash
docker-compose -f docker/docker-compose.yml up -d
```

3. **Initialize databases**:
```bash
# PostgreSQL
docker exec -i travel-plan-postgres psql -U postgres < db/01-postgresql-schema.sql

# Neo4j
docker exec -i travel-plan-neo4j cypher-shell -u neo4j -p password < db/02-neo4j-schema.cypher
```

4. **Start services**:
```bash
# Terminal 1: Eureka Server (if separate)
java -jar eureka-server/target/*.jar

# Terminal 2: Auth Service
java -jar services/auth-service/target/*.jar

# Terminal 3: User Service
java -jar services/user-service/target/*.jar

# Terminal 4: Travel Service
java -jar services/travel-service/target/*.jar

# Terminal 5: Payment Service
java -jar services/payment-service/target/*.jar

# Terminal 6: API Gateway
java -jar api-gateway/target/*.jar
```

5. **Access the application**:
- API Gateway: `http://localhost:8080`
- Auth Service: `http://localhost:8001`
- User Service: `http://localhost:8002`
- Travel Service: `http://localhost:8003`
- Payment Service: `http://localhost:8004`

### Testing

**Run unit tests**:
```bash
mvn test
```

**Run with coverage**:
```bash
mvn clean test jacoco:report
# View report at: target/site/jacoco/index.html
```

**Run SonarQube analysis**:
```bash
mvn clean verify sonar:sonar \
  -Dsonar.projectKey=travel-plan \
  -Dsonar.sources=. \
  -Dsonar.host.url=http://localhost:9000 \
  -Dsonar.login=your-token
```

## Environment Variables

Create a `.env` file in the root directory:

```env
# Database
DB_USERNAME=postgres
DB_PASSWORD=your-secure-password
DATABASE_URL=jdbc:postgresql://postgres:5432/travel_plan

# JWT
JWT_SECRET=your-secret-key-at-least-32-characters-long

# Neo4j
NEO4J_USERNAME=neo4j
NEO4J_PASSWORD=your-neo4j-password
NEO4J_URI=bolt://neo4j:7687

# Stripe
STRIPE_API_KEY=sk_test_your_stripe_key

# PayPal
PAYPAL_CLIENT_ID=your-paypal-client-id
PAYPAL_CLIENT_SECRET=your-paypal-client-secret
PAYPAL_MODE=sandbox

# Service Discovery
EUREKA_URL=http://eureka-server:8761/eureka/
```

## Security

- **SSL/TLS**: All communications encrypted in transit
- **JWT**: Token-based authentication
- **RBAC**: Role-based access control (ADMIN, USER, TRAVEL_AGENT)
- **Password Hashing**: BCrypt (10 rounds)
- **Secret Management**: Environment variables for sensitive data
- **Principle of Least Privilege**: Services only access necessary resources

## CI/CD Pipeline

1. **Code Review**: Pull requests reviewed before merge
2. **Build**: Maven compilation
3. **Unit Tests**: JUnit 5 tests
4. **Code Quality**: SonarQube analysis
5. **Integration Tests**: Docker containers for isolated testing
6. **Security Scan**: Dependency vulnerability checks
7. **Deploy**: Jenkins automated deployment

## Database Schema

### PostgreSQL (Transactional)
- Users
- Travels
- Travel_Destinations (M-to-M)
- Activities
- Payments
- Destinations

### Neo4j (Graph)
- Destination nodes with relationships
- Travel-Destination connections
- Category-based recommendations
- Route connections between destinations

See `db/01-postgresql-schema.sql` and `db/02-neo4j-schema.cypher` for details.

## API Documentation

### Authentication Flow
1. User registers → `POST /api/auth/register`
2. User logs in → `POST /api/auth/login` (returns JWT token)
3. Include token in Authorization header: `Authorization: Bearer <token>`
4. Gateway validates token before routing to services

### Response Format
All API responses follow this format:
```json
{
  "success": true,
  "message": "Operation successful",
  "data": {},
  "errorCode": null,
  "timestamp": "2026-03-23T10:30:00"
}
```

## Contributing

1. Create feature branch: `git checkout -b feature/feature-name`
2. Commit changes: `git commit -am 'Add feature'`
3. Push to branch: `git push origin feature/feature-name`
4. Create Pull Request with description
5. Wait for code review and CI/CD to pass
6. Merge after approval

## Workflow (Phase-based)

### Phase 1: Foundations (Current)
- **Personne 1 (DevOps)**: Docker setup, API Gateway skeleton, Jenkins setup
- **Personne 2 (Backend)**: Database schemas, microservices scaffold, API contracts
- **Personne 3 (Frontend/QA)**: Dashboard setup, component structure, test environment

### Phase 2: Integration (Weeks 2-3)
- **Personne 1**: Ansible playbooks, distributed logging, CI/CD pipeline
- **Personne 2**: Auth implementation, CRUD operations, database cascading
- **Personne 3**: Dashboard UI, API integration, E2E tests

### Phase 3: Polish & Bonus (Weeks 4-5)
- **Personne 1**: Kubernetes setup, monitoring, advanced scaling
- **Personne 2**: Database optimizations, edge cases
- **Personne 3**: Documentation, load testing, UI polish

## License

Private Project - All rights reserved.

---

**Last Updated**: March 23, 2026
**Project Status**: Phase 1 - Foundation Setup ✅
