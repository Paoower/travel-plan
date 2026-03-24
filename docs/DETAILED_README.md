# 🌍 Travel-Plan - Enterprise Travel Management System

![Status](https://img.shields.io/badge/status-Phase%201%20Complete-brightgreen)
![Java](https://img.shields.io/badge/Java-17-blue)
![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.2.0-brightgreen)
![Docker](https://img.shields.io/badge/Docker-Compose-blue)

## 📖 Project Overview

Travel-Plan is a comprehensive, enterprise-grade travel management system built with a modern microservices architecture. It enables administrators and users to manage travel bookings, destinations, accommodations, activities, and payments in a scalable, secure environment.

### 🎯 Key Objectives

1. **Scalable Infrastructure** - Containerized microservices with load balancing
2. **Admin Dashboard** - Comprehensive management interface for all entities
3. **Multi-Payment Support** - Stripe, PayPal, and Bank Transfer integration
4. **Relationship Mapping** - Neo4j for complex travel-destination relationships
5. **Security** - JWT authentication, role-based access control, SSL/TLS ready
6. **Quality Assurance** - CI/CD pipeline, unit tests, SonarQube analysis

---

## 🏗️ Architecture

### Microservices
```
┌─────────────────────────────────────────────────────────┐
│                    API Gateway (8080)                    │
│              Spring Cloud Gateway / Routing              │
└─────────────┬─────────────────────────────────────────┘
              │
     ┌────────┼─────────┬──────────────┬────────────┐
     │        │         │              │            │
  [Auth]   [User]   [Travel]      [Payment]    [Eureka]
  (8001)   (8002)    (8003)        (8004)       (SD)
```

### Technology Stack

| Component | Technology | Purpose |
|-----------|-----------|---------|
| **Framework** | Spring Boot 3.2.0 | REST APIs |
| **Cloud** | Spring Cloud 2023.0.0 | Microservices coordination |
| **API Gateway** | Spring Cloud Gateway | Request routing & load balancing |
| **Service Discovery** | Eureka Server | Dynamic service registration |
| **Authentication** | Spring Security + JWT | Secure access control |
| **Database** | PostgreSQL 15 + Neo4j 5.6 | Relational + Graph data |
| **Containerization** | Docker + Docker Compose | Infrastructure as Code |
| **Build Tool** | Maven 3.9 | Dependency & build management |
| **Testing** | JUnit 5 + Mockito | Unit & integration tests |
| **Code Quality** | SonarQube | Static analysis |
| **CI/CD** | Jenkins | Automated pipeline |

---

## 🚀 Quick Start

### Prerequisites
- Docker & Docker Compose installed
- Java 17+ (for local development)
- Maven 3.8.6+ (for building)
- Git

### Clone & Setup
```bash
cd /home/romain/Z01/projets/travel-plan

# Option 1: Using the startup script
bash start.sh

# Option 2: Manual Docker Compose
docker-compose down -v  # Clean up old containers
sleep 3
docker-compose up -d    # Start all services

# Monitor startup
docker-compose logs -f
```

### Access Services
Once running (wait 30-60 seconds for services to fully start):

```bash
# Health checks
curl http://localhost:8001/actuator/health  # Auth
curl http://localhost:8002/actuator/health  # User
curl http://localhost:8003/actuator/health  # Travel
curl http://localhost:8004/actuator/health  # Payment
curl http://localhost:8080/actuator/health  # API Gateway

# Databases
psql -h localhost -U postgres -d postgres   # PostgreSQL
# Neo4j: http://localhost:7474
```

---

## 📚 API Documentation

### Authentication Flow
```
1. POST /api/auth/register          → Create user account
2. POST /api/auth/login             → Get JWT token
3. Use token: Authorization: Bearer <token>
4. POST /api/auth/refresh-token     → Refresh expired token
```

### Core Endpoints (Phase 2)

#### Users
```
GET    /api/users                 - List all users
GET    /api/users/{id}           - Get user details
POST   /api/users                - Create new user
PUT    /api/users/{id}           - Update user
DELETE /api/users/{id}           - Delete user
```

#### Travels
```
GET    /api/travels              - List all travels
GET    /api/travels/{id}        - Get travel details
POST   /api/travels             - Create travel plan
PUT    /api/travels/{id}        - Update travel
DELETE /api/travels/{id}        - Delete travel
GET    /api/travels/{id}/destinations  - Get destinations
```

#### Payments
```
POST   /api/payments             - Process payment
GET    /api/payments/{id}       - Get payment status
POST   /api/payments/{id}/refund - Refund payment
GET    /api/payment-methods     - List payment methods
```

---

## 🗄️ Database Schema

### PostgreSQL Tables
- **users** - User accounts with roles
- **travels** - Travel bookings and itineraries
- **destinations** - Travel destinations
- **travel_destinations** - Many-to-many mapping
- **activities** - Activities at destinations
- **accommodations** - Hotel/hostel bookings
- **transportation** - Flights, trains, buses, etc.
- **payment_methods** - Stored payment info (Stripe, PayPal, Bank)
- **payments** - Payment transactions
- **travel_participants** - Users joining travels
- **audit_logs** - Change tracking for compliance

### Neo4j Graphs
- Destination relationships
- Travel route optimization
- User recommendation engine (future)

---

## 🔒 Security Features

### Implemented
✅ JWT Token-based Authentication
✅ Role-Based Access Control (Admin, User, Travel Agent)
✅ Password hashing with BCrypt
✅ Request validation
✅ SQL Injection prevention (Parameterized queries)

### Ready for Phase 2
🔒 SSL/TLS encryption
🔒 Rate limiting
🔒 CORS configuration
🔒 Secret management (HashiCorp Vault ready)
🔒 API key rotation
🔒 Audit logging

---

## 🧪 Testing

### Unit Tests
```bash
# Run all tests
mvn test

# Run specific module tests
mvn test -pl services/auth-service

# With coverage
mvn clean test jacoco:report
```

### Integration Tests
```bash
# Tests with Docker containers running
mvn verify
```

---

## 📊 Monitoring & Logging

### Health Checks
All services expose Actuator endpoints:
```
/actuator/health             - Basic health status
/actuator/health/db          - Database connectivity
/actuator/health/diskSpace   - Storage status
```

### Logging
- **Local Development**: Console logs with color coding
- **Production**: Structured JSON logging to ELK stack

---

## 🔄 CI/CD Pipeline

### Jenkins Integration (Phase 2)
1. **Build Stage** - Maven compile & package
2. **Test Stage** - Run unit & integration tests
3. **Quality Gate** - SonarQube analysis
4. **Docker Stage** - Build & push images
5. **Deploy Stage** - Deploy to environment

### GitHub Actions (Alternative)
- Pre-commit hooks for code quality
- PR validation before merge
- Automated release notes

---

## 📈 Performance Considerations

### Optimization Strategies
- Database indexing on frequently queried fields
- Connection pooling with HikariCP
- Caching layer ready (Redis)
- Pagination for large result sets
- Async processing for heavy operations

### Scalability
- Horizontal scaling via Docker Compose
- Load balancing through API Gateway
- Service replication capabilities
- Database read replicas ready

---

## 🐛 Troubleshooting

### Common Issues

**Services won't start:**
```bash
# Check if ports are in use
lsof -i :8080
lsof -i :5432

# View service logs
docker-compose logs service-name

# Restart specific service
docker-compose restart service-name
```

**Database connection fails:**
```bash
# Verify PostgreSQL is accessible
docker-compose exec postgres psql -U postgres -c "SELECT 1"

# Check connection string in application.yml
cat services/auth-service/src/main/resources/application.yml
```

**Out of memory:**
```bash
# Increase Docker memory limits
# Edit docker-compose.yml deploy.resources.limits.memory
```

---

## 📚 Project Structure

```
travel-plan/
├── api-gateway/
│   ├── src/main/java
│   ├── src/main/resources
│   ├── pom.xml
│   └── Dockerfile
│
├── services/
│   ├── auth-service/
│   ├── user-service/
│   ├── travel-service/
│   └── payment-service/
│
├── shared/
│   ├── src/main/java
│   │   ├── com/travelplan/dto/
│   │   ├── com/travelplan/entity/
│   │   ├── com/travelplan/constant/
│   │   └── com/travelplan/exception/
│   └── pom.xml
│
├── db/
│   ├── 01-postgresql-schema.sql
│   └── 02-neo4j-schema.cypher
│
├── docker-compose.yml
├── pom.xml (Parent POM)
├── README.md
├── PHASE1_COMPLETE.md
└── start.sh
```

---

## 🎓 Development Guidelines

### Code Style
- Follow Google Java Style Guide
- Use meaningful variable names
- Add JavaDoc for public methods
- Maximum line length: 100 characters

### Branching Strategy
```
main              - Production ready
├── develop       - Integration branch
│   ├── feature/auth-jwt
│   ├── feature/user-crud
│   ├── bugfix/login-issue
│   └── hotfix/payment-service
```

### Pull Request Process
1. Create feature branch from `develop`
2. Make changes with atomic commits
3. Write unit tests (minimum 80% coverage)
4. Submit PR with description
5. Pass code review & CI pipeline
6. Merge to `develop`, then `main`

---

## 📞 Support & Contribution

### Getting Help
- Check documentation in `/docs`
- Review existing issues
- Ask in team Slack channel
- Escalate to tech lead if needed

### Contributing
1. Fork the repository
2. Create feature branch
3. Make changes & add tests
4. Submit pull request
5. Wait for approval & merge

---

## 📋 Roadmap

### Phase 1 ✅ (Complete)
- Infrastructure setup
- Microservices scaffolding
- Docker containerization
- Database schema design

### Phase 2 🏗️ (In Progress)
- API endpoint implementation
- Authentication & authorization
- CRUD operations
- Unit tests

### Phase 3 🔮 (Planned)
- Frontend dashboard
- Advanced features
- Performance optimization
- Production deployment

### Phase 4+ 📚 (Future)
- Mobile app
- Analytics dashboard
- Machine learning recommendations
- Global expansion

---

## 📄 License

This project is proprietary and confidential.

---

## 👥 Team

**Project Owner:** [Your Name]
**Tech Lead:** [Tech Lead Name]
**DevOps:** [DevOps Engineer]
**Backend Team:** [Team Members]

---

## 🎉 Acknowledgments

Built with ❤️ using Spring Boot and modern cloud technologies.

---

**Version:** 1.0.0-Phase1
**Last Updated:** March 23, 2026
**Status:** 🟢 Active Development
