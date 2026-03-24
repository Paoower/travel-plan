# Personne 2 (Backend) - Workstream Guide

## 🎯 Your Role: Backend Developer / Microservices Architect

As **Personne 2**, you are responsible for:
- Database design ✅ (PHASE 1 COMPLETE)
- Microservices architecture ✅ (PHASE 1 COMPLETE)
- API contracts & implementation
- Business logic & CRUD operations
- Service-to-service communication
- Testing & quality assurance

---

## 📋 Phase 1 Deliverables - COMPLETED ✅

### Database Design ✅
**Files**: `db/01-postgresql-schema.sql`, `db/02-neo4j-schema.cypher`

**Delivered**:
- ✅ PostgreSQL schema with 6 main tables
- ✅ Proper relationships and foreign keys
- ✅ Cascading rules (ON DELETE CASCADE)
- ✅ Indexes for performance
- ✅ UUID primary keys
- ✅ Timestamp tracking (created_at, updated_at, deleted_at)
- ✅ Soft delete support
- ✅ Neo4j graph schema for recommendations

### Microservices Scaffold ✅
**Structure**: `services/`

**Delivered**:
- ✅ 4 independent microservices
- ✅ Proper package structure
- ✅ Spring Boot configuration
- ✅ Database connections configured
- ✅ Service discovery integration
- ✅ Application properties for all environments

### Shared Library ✅
**Location**: `shared/`

**Delivered**:
- ✅ UserDTO, TravelDTO, PaymentDTO
- ✅ AuthRequestDTO, AuthResponseDTO
- ✅ ApiResponseWrapper for standardized responses
- ✅ Custom exceptions
- ✅ Application constants
- ✅ Ready for Maven dependency injection

---

## 📂 Your Module Structure

```
services/
├── auth-service/
│   ├── src/main/java/com/travelplan/authservice/
│   │   ├── AuthServiceApplication.java          (Entry point)
│   │   ├── entity/
│   │   │   └── User.java                        (JPA entity - PHASE 1 ✅)
│   │   ├── repository/
│   │   │   └── UserRepository.java              (PHASE 1 ✅)
│   │   ├── service/                             (PHASE 2)
│   │   │   ├── AuthService.java
│   │   │   ├── UserService.java
│   │   │   └── JwtTokenProvider.java
│   │   ├── controller/                          (PHASE 2)
│   │   │   └── AuthController.java
│   │   ├── config/                              (PHASE 2)
│   │   │   ├── SecurityConfig.java
│   │   │   └── JwtAuthFilter.java
│   │   └── dto/                                 (Use from shared/)
│   ├── src/test/java/
│   │   ├── AuthServiceApplicationTests.java     (PHASE 1 ✅)
│   │   ├── service/
│   │   │   └── AuthServiceTests.java            (PHASE 2)
│   │   └── controller/
│   │       └── AuthControllerTests.java         (PHASE 2)
│   ├── Dockerfile                               (PHASE 1 ✅)
│   ├── pom.xml                                  (PHASE 1 ✅)
│   └── src/main/resources/
│       └── application.yml                      (PHASE 1 ✅)
│
├── user-service/                                (Similar structure)
├── travel-service/                              (Similar structure + Neo4j)
└── payment-service/                             (Similar structure + Stripe/PayPal)
```

---

## 🔄 Phase 2: Implementation Tasks (Weeks 2-3)

### Task 1: Authentication Service (Auth Service) - Priority 1

**Goal**: Enable user registration and login

#### Subtasks:
1. **User Registration**
   ```
   POST /api/auth/register
   - Validate email format
   - Hash password (BCrypt)
   - Create user in PostgreSQL
   - Return user DTO with success message
   ```

2. **User Login**
   ```
   POST /api/auth/login
   - Find user by email
   - Validate password
   - Generate JWT token
   - Return token + user info
   ```

3. **JWT Token Provider**
   - Generate tokens (with expiration)
   - Validate tokens
   - Extract claims from token
   - Handle token refresh

4. **Security Configuration**
   - Spring Security setup
   - Configure authentication filter
   - Setup JWT filter
   - CORS configuration

#### Key Classes to Implement:
```java
// services/auth-service/src/main/java/com/travelplan/authservice/service/
AuthService.java              // Main auth logic
UserService.java              // User management
JwtTokenProvider.java         // JWT operations
PasswordEncoder.java          // Password hashing (use Spring Security)

// services/auth-service/src/main/java/com/travelplan/authservice/controller/
AuthController.java           // REST endpoints

// services/auth-service/src/main/java/com/travelplan/authservice/config/
SecurityConfig.java           // Spring Security config
JwtAuthFilter.java            // JWT validation filter
```

#### Test Files:
```java
// services/auth-service/src/test/java/com/travelplan/authservice/
service/AuthServiceTest.java
service/JwtTokenProviderTest.java
controller/AuthControllerTest.java
integration/AuthServiceIntegrationTest.java
```

---

### Task 2: User Service CRUD Operations - Priority 2

**Goal**: Full CRUD operations for users (Admin only)

#### Endpoints:
```
GET    /api/users                   # List users (paginated, admin only)
GET    /api/users/{id}              # Get user by ID
POST   /api/users                   # Create user
PUT    /api/users/{id}              # Update user
DELETE /api/users/{id}              # Soft delete user
```

#### Key Classes to Implement:
```java
// Repository
UserRepository.java           // Custom queries

// Service Layer
UserService.java              // CRUD logic, validation

// Controller
UserController.java           # REST endpoints

// DTO
UserPaginationResponse.java   # Pagination wrapper

// Config
UserServiceConfig.java        # Service-level config
```

#### Features:
- [x] Pagination & sorting
- [x] Role-based access (ADMIN only)
- [x] Input validation
- [x] Soft delete (don't actually remove, mark as deleted)
- [x] Proper HTTP status codes
- [x] Error handling

---

### Task 3: Travel Service - Priority 2

**Goal**: CRUD operations for travels + destination management

#### Endpoints:
```
GET    /api/travels                  # List travels (paginated)
POST   /api/travels                  # Create travel
GET    /api/travels/{id}             # Get travel details
PUT    /api/travels/{id}             # Update travel
DELETE /api/travels/{id}             # Delete travel

GET    /api/travels/{id}/destinations     # Get travel destinations
POST   /api/travels/{id}/activities       # Add activity
GET    /api/travels/{id}/activities       # List activities
```

#### Key Classes to Implement:
```java
// Entities
Travel.java                   # Travel entity
Destination.java              # Destination entity
Activity.java                 # Activity entity
TravelDestination.java        # Many-to-many junction

// Repositories
TravelRepository.java
DestinationRepository.java
ActivityRepository.java

// Services
TravelService.java
DestinationService.java
ActivityService.java

// Controllers
TravelController.java
DestinationController.java

// Neo4j
DestinationGraphService.java  # Neo4j queries for recommendations
```

#### Features:
- [x] CRUD for travels
- [x] CRUD for activities
- [x] Destination management
- [x] Travel itinerary ordering
- [x] Neo4j integration for recommendations
- [x] Cascading deletes (travel → destinations → activities)
- [x] Pagination

---

### Task 4: Payment Service - Priority 3

**Goal**: Payment processing with Stripe & PayPal

#### Endpoints:
```
POST   /api/payments/process        # Process payment
GET    /api/payments/{id}           # Get payment details
POST   /api/payments/{id}/refund    # Process refund
POST   /api/payments/webhook/stripe # Stripe webhook
POST   /api/payments/webhook/paypal # PayPal webhook
```

#### Key Classes to Implement:
```java
// Entities
Payment.java
PaymentMethod.java

// Repositories
PaymentRepository.java

// Services
PaymentService.java
StripePaymentService.java
PayPalPaymentService.java
WebhookService.java

// Controllers
PaymentController.java

// Config
StripeConfig.java
PayPalConfig.java
```

#### Features:
- [x] Stripe integration
- [x] PayPal integration
- [x] Webhook handling
- [x] Payment history
- [x] Refund management
- [x] Transaction tracking
- [x] Error handling & retries

---

## 📊 Testing Strategy

### Unit Tests (Service Layer)
```bash
# Test each service method independently
# Mock repositories and external services
mvn test -Dtest=AuthServiceTest
mvn test -Dtest=UserServiceTest
```

### Integration Tests (Database)
```bash
# Use TestContainers for real database testing
mvn test -Dtest=AuthServiceIntegrationTest
# Tests will spin up ephemeral PostgreSQL container
```

### Controller Tests
```bash
# Test REST endpoints with MockMvc
mvn test -Dtest=AuthControllerTest
```

### E2E Tests (Phase 3)
```bash
# Full API flow testing
# Use Postman/Insomnia collections
# Or Cypress/Playwright for UI testing
```

### Test Coverage Target
```
- Minimum 80% code coverage
- All public methods tested
- Happy path + error scenarios
- Edge cases covered
```

---

## 🔐 Security Checklist

For each endpoint, ensure:
- [x] Authentication required (JWT token)
- [x] Authorization checked (role-based)
- [x] Input validation
- [x] SQL injection prevention (use JPA)
- [x] Error messages don't leak info
- [x] Passwords properly hashed
- [x] HTTPS ready (configuration)
- [x] Rate limiting (API Gateway)
- [x] CORS properly configured

---

## 📝 Code Standards

### Java Naming Conventions
```java
// Classes: PascalCase
public class UserService { }

// Methods: camelCase
public User findUserById(String id) { }

// Constants: UPPER_SNAKE_CASE
public static final String DEFAULT_ROLE = "USER";

// Variables: camelCase
String userName = "John";
```

### Package Structure
```
com.travelplan.authservice
├── entity       (JPA entities)
├── repository   (Data access)
├── service      (Business logic)
├── controller   (REST endpoints)
├── config       (Spring configuration)
├── exception    (Custom exceptions)
├── dto          (Use from shared/)
└── util         (Helper utilities)
```

### Annotation Best Practices
```java
// Always validate DTOs
@PostMapping("/register")
public ResponseEntity<ApiResponseWrapper<UserDTO>> register(
    @Valid @RequestBody AuthRequestDTO request) {
    // ...
}

// Use @PreAuthorize for security
@PreAuthorize("hasRole('ADMIN')")
@GetMapping("/users")
public ResponseEntity<...> getAllUsers() {
    // ...
}

// Proper Lombok usage
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UserDTO {
    // ...
}
```

---

## 🔗 Service-to-Service Communication

### Eureka Service Discovery
```java
// Services auto-register with Eureka
// Use RestTemplate with load balancing

@Configuration
public class RestTemplateConfig {
    @Bean
    @LoadBalanced
    public RestTemplate restTemplate() {
        return new RestTemplate();
    }
}

// Use service name instead of URL
restTemplate.getForObject(
    "http://user-service/api/users/{id}",
    UserDTO.class,
    userId
);
```

### Inter-service Communication Best Practices
1. Use Spring Cloud's discovery
2. Implement circuit breakers (Hystrix/Resilience4j)
3. Handle failures gracefully
4. Log all inter-service calls
5. Use consistent error responses

---

## 📚 Database Access Patterns

### JPA Repository Pattern
```java
@Repository
public interface UserRepository extends JpaRepository<User, String> {
    Optional<User> findByEmail(String email);
    
    @Query("SELECT u FROM User u WHERE u.isActive = true")
    List<User> findActiveUsers();
    
    // Pagination
    Page<User> findAll(Pageable pageable);
}

// Usage in Service
@Service
public class UserService {
    @Autowired
    private UserRepository userRepository;
    
    public Page<UserDTO> getAllUsers(int page, int size) {
        Pageable pageable = PageRequest.of(page, size);
        return userRepository.findAll(pageable)
            .map(UserMapper::toDTO);
    }
}
```

### Neo4j Queries (Travel Service)
```java
@Service
public class DestinationGraphService {
    // Query destination recommendations
    // Build travel itineraries
    // Find similar destinations
}
```

---

## 🚀 Development Workflow

### Daily Workflow
1. **Pull latest code**
   ```bash
   git pull origin main
   ```

2. **Create feature branch**
   ```bash
   git checkout -b feature/auth-implementation
   ```

3. **Develop & test locally**
   ```bash
   mvn clean install
   # Run services
   mvn spring-boot:run
   # Test endpoints
   ```

4. **Run tests**
   ```bash
   mvn test
   mvn jacoco:report
   ```

5. **Code quality**
   ```bash
   mvn sonar:sonar
   ```

6. **Commit & push**
   ```bash
   git add .
   git commit -m "feat: implement user authentication"
   git push origin feature/auth-implementation
   ```

7. **Create Pull Request**
   - Add description
   - Link issues
   - Request review

---

## 🎯 Phase 2 Timeline Estimate

| Task | Duration | Priority |
|------|----------|----------|
| Auth Service (register/login) | 2-3 days | P1 |
| JWT Token Provider | 1 day | P1 |
| User Service CRUD | 2 days | P2 |
| Travel Service CRUD | 2-3 days | P2 |
| Payment Service (basic) | 1.5 days | P3 |
| Unit Tests (all services) | 2 days | P1 |
| Integration Tests | 1.5 days | P1 |
| Code Review & Fixes | 1 day | P1 |
| **Total** | **~13-14 days** | - |

---

## 📖 Useful References

### Spring Boot
- [Spring Boot Guides](https://spring.io/guides)
- [Spring Data JPA](https://spring.io/projects/spring-data-jpa)
- [Spring Security](https://spring.io/projects/spring-security)
- [Spring Cloud Gateway](https://spring.io/projects/spring-cloud-gateway)

### JWT
- [JJWT Library](https://github.com/jwtk/jjwt)
- [JWT Best Practices](https://tools.ietf.org/html/rfc7519)

### Testing
- [JUnit 5](https://junit.org/junit5/)
- [Mockito](https://site.mockito.org/)
- [TestContainers](https://www.testcontainers.org/)

### Neo4j
- [Neo4j Java Driver](https://neo4j.com/docs/java-manual/current/)
- [Cypher Query Language](https://neo4j.com/docs/cypher-manual/current/)

### Databases
- [PostgreSQL Docs](https://www.postgresql.org/docs/)
- [Neo4j Documentation](https://neo4j.com/docs/)

---

## ❓ FAQ

### Q: How do I test the API locally?
**A**: Use curl, Postman, or Insomnia. See `API_ENDPOINTS.md` for examples.

### Q: How do I connect to the PostgreSQL database?
**A**: 
```bash
docker exec -it travel-plan-postgres psql -U postgres
\l                    # List databases
\c travel_plan_auth   # Connect to database
\dt                   # List tables
```

### Q: How do I debug a service?
**A**: 
1. Add breakpoints in IDE
2. Run in debug mode:
   ```bash
   mvn spring-boot:run -Dspring-boot.run.jvmArguments="-Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=y,address=5005"
   ```
3. Or use IDE's debug runner

### Q: How do I handle database migrations?
**A**: Currently using `ddl-auto: validate`. For future:
- Consider Flyway or Liquibase
- Store migrations in `db/migrations/`
- Version each migration

### Q: How do I test with real Stripe/PayPal APIs?
**A**: 
1. Use their sandbox/test keys
2. Store in `.env` file (never in code)
3. Use TestContainers for isolation
4. Mock in unit tests, use real API in integration tests

---

## 📞 Team Communication

### Daily Standup Points
- What did you accomplish yesterday?
- What are you working on today?
- Any blockers?

### Code Review Checklist
- [ ] Functionality works as intended
- [ ] Tests pass and cover edge cases
- [ ] Code follows naming conventions
- [ ] No security issues
- [ ] Documentation is clear
- [ ] Performance is acceptable

---

## ✅ Pre-Phase 2 Checklist

Before starting Phase 2 implementation:
- [ ] Read and understand ARCHITECTURE.md
- [ ] Review database schema
- [ ] Understand Spring Boot basics
- [ ] Set up IDE with project
- [ ] Run `mvn clean install` successfully
- [ ] Start Docker environment
- [ ] Verify all services start without errors
- [ ] Test API Gateway responds

---

**Role**: Backend Developer / Microservices Architect
**Phase 1 Status**: ✅ COMPLETE
**Next Phase**: Phase 2 - Implementation (Starting immediately)
**Last Updated**: March 23, 2026

---

Questions? Check GETTING_STARTED.md or reach out to team leads.
