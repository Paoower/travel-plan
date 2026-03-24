# 🚀 Phase 2 - Getting Started Guide

Welcome to Phase 2! This guide will help you get started with implementing the core functionality.

---

## 📌 Phase 2 Overview

**Duration**: 2-3 weeks
**Objective**: Implement all core endpoints and integrate services
**Deliverables**: 
- All CRUD endpoints working
- Unit tests for all endpoints
- Inter-service communication
- Payment integration

---

## 🎯 Your First Day

### Step 1: Setup (15 minutes)

```bash
# Navigate to project
cd /home/romain/Z01/projets/travel-plan

# Verify everything works
bash QUICKSTART_CHECKLIST.sh

# Start the project
bash start.sh

# Load helpful commands
source commands.sh

# Check all services are healthy
tp-health
```

Expected output:
```
Auth Service (8001): UP
User Service (8002): UP
Travel Service (8003): UP
Payment Service (8004): UP
API Gateway (8080): UP
PostgreSQL (5432): UP
Neo4j (7687): UP
```

### Step 2: Read Documentation (30 minutes)

1. **Quick Overview**:
   ```bash
   cat QUICK_REFERENCE.md
   ```

2. **Full Guide**:
   ```bash
   cat DETAILED_README.md
   ```

3. **Contribution Guide**:
   ```bash
   cat CONTRIBUTING.md
   ```

### Step 3: Explore the Code (30 minutes)

```bash
# View project structure
tree -L 2 -I 'target'

# Check Auth Service structure
find services/auth-service/src -name "*.java" -type f

# View shared DTOs
find shared/src/main/java -name "*.java" -type f
```

### Step 4: Run Your First Test (15 minutes)

```bash
# Run all tests
mvn clean test

# Or with helper command
tp-test

# View coverage
mvn clean test jacoco:report
# Open target/site/jacoco/index.html in browser
```

---

## 📝 Development Workflow

### Before You Start Coding

1. **Create a feature branch**:
   ```bash
   git checkout -b feature/auth-login-endpoint
   ```

2. **Load commands** (in every terminal):
   ```bash
   source commands.sh
   ```

3. **Verify services are running**:
   ```bash
   tp-health
   ```

### While Coding

1. **Keep services running**:
   ```bash
   # In terminal 1
   docker-compose logs -f
   ```

2. **Run tests frequently**:
   ```bash
   # In terminal 2
   mvn clean test
   ```

3. **Check health after changes**:
   ```bash
   # In terminal 3
   tp-health
   ```

### Before You Commit

1. **Run full test suite**:
   ```bash
   mvn clean verify
   ```

2. **Check code coverage**:
   ```bash
   mvn jacoco:report
   ```
   - Aim for 80%+ coverage

3. **Run SonarQube check** (optional):
   ```bash
   mvn sonar:sonar
   ```

4. **Verify linting** (follow CONTRIBUTING.md):
   ```bash
   # Ensure code follows guidelines
   # Check CONTRIBUTING.md#coding-standards
   ```

---

## 🔨 Implementation Guide

### Phase 2 Task Breakdown

#### Week 1: Authentication Service

**Task 1.1: Implement Login Endpoint**
- File: `services/auth-service/src/main/java/com/travelplan/auth/controller/AuthController.java`
- Endpoint: `POST /api/auth/login`
- Request: `{ email, password }`
- Response: `{ token, refreshToken, user }`
- Tests: See `*Test.java` files

**Task 1.2: Implement Register Endpoint**
- File: Same as above
- Endpoint: `POST /api/auth/register`
- Request: `{ firstName, lastName, email, password }`
- Response: `{ user, token }`

**Task 1.3: Implement Refresh Token**
- Endpoint: `POST /api/auth/refresh-token`
- Request: `{ refreshToken }`
- Response: `{ token, refreshToken }`

#### Week 1-2: User Service

**Task 2.1: Implement User CRUD**
- List: `GET /api/users?page=0&size=10`
- Get: `GET /api/users/{id}`
- Create: `POST /api/users`
- Update: `PUT /api/users/{id}`
- Delete: `DELETE /api/users/{id}`

#### Week 2: Travel Service

**Task 3.1: Implement Travel CRUD**
- Similar structure to User Service
- Include destination management
- Integrate Neo4j for relationships

#### Week 2-3: Payment Service

**Task 4.1: Integrate Stripe**
- Implement payment processing
- Handle webhooks
- Track payment status

**Task 4.2: Integrate PayPal**
- Alternative payment method
- Same structure as Stripe

---

## 🧪 Testing Requirements

### Unit Tests

**Location**: `services/*/src/test/java/`

**Structure**:
```java
@Test
void testLoginWithValidCredentials() {
    // Arrange: Setup test data
    LoginRequest request = new LoginRequest("user@example.com", "password");
    User user = new User("John", "Doe", "user@example.com", "password");
    
    // Act: Call the method being tested
    LoginResponse response = authService.login(request);
    
    // Assert: Verify the results
    assertNotNull(response);
    assertNotNull(response.getToken());
    assertEquals("user@example.com", response.getUser().getEmail());
}

@Test
void testLoginWithInvalidCredentials() {
    // Arrange
    LoginRequest request = new LoginRequest("user@example.com", "wrong");
    
    // Act & Assert
    assertThrows(InvalidCredentialsException.class, 
        () -> authService.login(request));
}
```

**Coverage Goal**: 80%+ per service

**Run tests**:
```bash
# All tests
mvn clean test

# Specific module
mvn test -pl services/auth-service

# With coverage
mvn clean test jacoco:report
```

### Integration Tests

**Location**: `services/*/src/test/java/*IT.java`

Test complete flows with databases running:
```bash
mvn clean verify
```

---

## 📚 Key Files to Modify

### Auth Service
```
services/auth-service/
├── src/main/java/com/travelplan/auth/
│   ├── controller/AuthController.java        ← Implement endpoints
│   ├── service/AuthService.java              ← Business logic
│   ├── entity/User.java                      ← User entity
│   ├── dto/LoginRequest.java                 ← Request DTO
│   └── exception/InvalidCredentialsException ← Custom exception
└── src/test/java/com/travelplan/auth/
    ├── controller/AuthControllerTest.java    ← Controller tests
    └── service/AuthServiceTest.java          ← Service tests
```

### User Service
```
services/user-service/
├── src/main/java/com/travelplan/user/
│   ├── controller/UserController.java        ← Implement CRUD
│   ├── service/UserService.java              ← Business logic
│   ├── entity/User.java                      ← User entity
│   ├── repository/UserRepository.java        ← Data access
│   └── dto/UserDto.java                      ← Request/Response
└── src/test/java/com/travelplan/user/
    └── controller/UserControllerTest.java    ← CRUD tests
```

---

## 🔌 API Contract Examples

### Auth Endpoints

**Login**:
```
POST /api/auth/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123"
}

Response (200 OK):
{
  "token": "eyJhbGc...",
  "refreshToken": "eyJhbGc...",
  "user": {
    "id": "uuid",
    "firstName": "John",
    "lastName": "Doe",
    "email": "user@example.com",
    "role": "USER"
  }
}
```

**Register**:
```
POST /api/auth/register
Content-Type: application/json

{
  "firstName": "John",
  "lastName": "Doe",
  "email": "user@example.com",
  "password": "password123"
}

Response (201 Created):
{
  "id": "uuid",
  "firstName": "John",
  "lastName": "Doe",
  "email": "user@example.com",
  "role": "USER"
}
```

### User CRUD Endpoints

**List Users**:
```
GET /api/users?page=0&size=10
Authorization: Bearer {token}

Response (200 OK):
{
  "content": [
    {
      "id": "uuid",
      "firstName": "John",
      "lastName": "Doe",
      "email": "user@example.com",
      "role": "USER",
      "createdAt": "2026-03-23T12:00:00Z"
    }
  ],
  "totalElements": 100,
  "totalPages": 10,
  "currentPage": 0
}
```

**Create User** (Admin only):
```
POST /api/users
Authorization: Bearer {token}
Content-Type: application/json

{
  "firstName": "Jane",
  "lastName": "Smith",
  "email": "jane@example.com",
  "password": "password123",
  "role": "USER"
}

Response (201 Created):
{
  "id": "uuid",
  "firstName": "Jane",
  "lastName": "Smith",
  "email": "jane@example.com",
  "role": "USER"
}
```

---

## 🚨 Common Pitfalls to Avoid

### ❌ Don't:
- Hardcode values → Use configuration/environment variables
- Skip tests → Every endpoint must be tested
- Ignore error cases → Handle exceptions properly
- Copy code → Use abstraction/inheritance
- Commit without testing → Always run `mvn test` first

### ✅ Do:
- Use dependency injection (Spring)
- Write meaningful test names
- Document complex logic
- Follow naming conventions
- Review code before pushing
- Keep methods small and focused

---

## 🐛 Debugging Tips

### View Logs
```bash
# All services
tp-logs

# Specific service
docker-compose logs -f auth-service

# Follow logs in real-time
docker-compose logs -f service-name --tail=100
```

### Database Access
```bash
# PostgreSQL
docker-compose exec postgres psql -U postgres

# Neo4j
docker-compose exec neo4j bin/cypher-shell

# Or use Neo4j browser: http://localhost:7474
```

### Test Individual Service
```bash
# Auth service tests
mvn test -pl services/auth-service

# With output
mvn test -pl services/auth-service -X
```

### Check Service is Reachable
```bash
# From local machine
curl http://localhost:8001/actuator/health

# From inside Docker network
docker-compose exec api-gateway curl http://auth-service:8001/actuator/health
```

---

## 📋 Phase 2 Checklist

### Week 1:
- [ ] Auth Service Login endpoint implemented
- [ ] Auth Service Register endpoint implemented
- [ ] Unit tests for Auth endpoints (80%+ coverage)
- [ ] Integration tests passing
- [ ] Code reviewed and approved

### Week 2:
- [ ] User Service CRUD endpoints implemented
- [ ] Travel Service CRUD endpoints implemented
- [ ] Inter-service communication working
- [ ] Unit tests for all endpoints
- [ ] SonarQube analysis passing

### Week 3:
- [ ] Payment Service endpoints implemented
- [ ] Stripe integration working
- [ ] PayPal integration working
- [ ] Load testing completed
- [ ] Documentation updated

### Week 4-5:
- [ ] All endpoints fully functional
- [ ] 80%+ code coverage
- [ ] SonarQube clean
- [ ] CI/CD pipeline green
- [ ] Ready for staging deployment

---

## 🎓 Learning Resources

- [Spring Boot Docs](https://spring.io/projects/spring-boot)
- [REST Best Practices](https://restfulapi.net/)
- [JUnit 5 Guide](https://junit.org/junit5/docs/current/user-guide/)
- [Mockito Tutorial](https://www.baeldung.com/mockito-series)
- [Docker Compose Docs](https://docs.docker.com/compose/)

---

## 🆘 Getting Help

1. **Check Documentation**: `DOCUMENTATION_INDEX.md`
2. **Review Code Comments**: Look at existing code
3. **Test Locally**: Use `tp-health` and `tp-logs`
4. **Ask Team Lead**: Escalate if stuck
5. **Review PRs**: Learn from others' code

---

## ✨ Success Criteria

You'll know Phase 2 is successful when:

✅ All endpoints are implemented
✅ All tests pass (80%+ coverage)
✅ CI/CD pipeline is green
✅ SonarQube shows no critical issues
✅ Services communicate correctly
✅ Payments process successfully
✅ Documentation is complete
✅ Code is reviewed and approved

---

## 🚀 Let's Go!

You're ready to start Phase 2! 

**First steps**:
1. Run `bash start.sh`
2. Run `source commands.sh`
3. Run `tp-health`
4. Pick a task from Phase 2 Roadmap
5. Create a feature branch
6. Start coding!

---

**Good luck, and happy coding!** 🎉

Questions? Check CONTRIBUTING.md or ask your team lead.
