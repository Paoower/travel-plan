# Travel Plan - Quick Reference Card

## 🚀 Quick Start (30 seconds)

```bash
# 1. Build
mvn clean install -DskipTests

# 2. Start infrastructure
docker-compose up -d

# 3. Verify (should show healthy)
docker-compose ps

# 4. Run services
docker-compose up
```

**Access**:
- API Gateway: http://localhost:8080
- Eureka Dashboard: http://localhost:8761

---

## 📍 Project Locations

| Component | Path |
|-----------|------|
| Parent POM | `/pom.xml` |
| Shared Library | `/shared/` |
| Auth Service | `/services/auth-service/` |
| User Service | `/services/user-service/` |
| Travel Service | `/services/travel-service/` |
| Payment Service | `/services/payment-service/` |
| API Gateway | `/api-gateway/` |
| PostgreSQL Schema | `/db/01-postgresql-schema.sql` |
| Neo4j Schema | `/db/02-neo4j-schema.cypher` |

---

## 🔌 Service Ports

| Service | Port | Health | Dashboard |
|---------|------|--------|-----------|
| API Gateway | 8080 | /actuator/health | - |
| Auth Service | 8001 | /actuator/health | - |
| User Service | 8002 | /actuator/health | - |
| Travel Service | 8003 | /actuator/health | - |
| Payment Service | 8004 | /actuator/health | - |
| Eureka | 8761 | / | http://localhost:8761 |
| PostgreSQL | 5432 | - | - |
| Neo4j | 7687 | - | http://localhost:7474 |

---

## 📚 Documentation

| Document | Purpose |
|----------|---------|
| `README.md` | Main overview |
| `ARCHITECTURE.md` | System design & diagrams |
| `API_ENDPOINTS.md` | REST API reference |
| `GETTING_STARTED.md` | Setup guide |
| `PHASE1_SUMMARY.md` | What's been completed |
| `BACKEND_WORKSTREAM.md` | Personne 2 tasks |

---

## 🏗️ Architecture (Simple View)

```
Clients
   ↓
API Gateway (8080)
   ↓
┌──────────────────────────────────┐
│ Auth Service (8001)              │
│ User Service (8002)              │
│ Travel Service (8003)            │
│ Payment Service (8004)           │
└──────────────────────────────────┘
   ↓
┌──────────────────────────────────┐
│ PostgreSQL (5432)                │
│ Neo4j (7687)                     │
└──────────────────────────────────┘
```

---

## 🔑 Key DTOs (Shared Library)

- `UserDTO` - User information
- `TravelDTO` - Travel details
- `PaymentDTO` - Payment info
- `AuthRequestDTO` - Login/Register request
- `AuthResponseDTO` - Login response with token
- `ApiResponseWrapper<T>` - Standard API response

---

## 📊 Database Quick View

### PostgreSQL Tables
- `users` - User accounts
- `travels` - Travel records
- `travel_destinations` - Travel-Destination M:M
- `activities` - Travel activities
- `destinations` - Travel locations
- `payments` - Payment records

### Neo4j Nodes
- `Destination` - Geographic locations
- `Travel` - Travel plans
- `Category` - Classification
- `ActivityType` - Activity types

### Relationships
- `VISITED_BY` - Travel visits destination
- `CONNECTED_TO` - Route between destinations
- `CATEGORIZED_AS` - Destination category
- `SIMILAR_TO` - Recommendation links

---

## 🧪 Testing Commands

```bash
# Run all tests
mvn test

# Run specific test
mvn test -Dtest=AuthServiceTest

# Generate coverage report
mvn test jacoco:report

# View coverage
open target/site/jacoco/index.html

# Code quality analysis (requires SonarQube)
mvn sonar:sonar
```

---

## 🛠️ Build Commands

```bash
# Clean build
mvn clean install

# Skip tests (faster)
mvn clean install -DskipTests

# Build single module
mvn -pl services/auth-service install

# Package as JAR
mvn package

# View dependencies
mvn dependency:tree
```

---

## 🔍 Docker Commands

```bash
# Start all services
docker-compose up -d

# View logs
docker-compose logs -f service-name

# Stop services
docker-compose down

# Stop and remove volumes
docker-compose down -v

# Restart service
docker-compose restart service-name

# See status
docker-compose ps
```

---

## 💾 Database Access

```bash
# PostgreSQL
docker exec -it travel-plan-postgres psql -U postgres

# Neo4j Browser
# Open: http://localhost:7474

# Common queries
# PostgreSQL: SELECT * FROM users;
# Neo4j: MATCH (d:Destination) RETURN d;
```

---

## 🔓 Default Credentials

### PostgreSQL
- Username: `postgres`
- Password: `postgres`
- Port: `5432`

### Neo4j
- Username: `neo4j`
- Password: `password`
- Port: `7687` (Bolt), `7474` (Browser)

**⚠️ Change in production!**

---

## 📝 Environment Variables

```bash
# Copy template
cp .env.example .env

# Key variables
DB_USERNAME=postgres
DB_PASSWORD=postgres
JWT_SECRET=your-secret-key-32-chars-minimum
NEO4J_USERNAME=neo4j
NEO4J_PASSWORD=password
STRIPE_API_KEY=sk_test_...
PAYPAL_CLIENT_ID=...
PAYPAL_CLIENT_SECRET=...
```

---

## 🚦 Health Checks

```bash
# Check API Gateway
curl http://localhost:8080/actuator/health

# Check Auth Service
curl http://localhost:8001/actuator/health

# Check Eureka
curl http://localhost:8761/eureka/apps

# Full health check
for port in 8080 8001 8002 8003 8004; do
  echo "Port $port:"
  curl -s http://localhost:$port/actuator/health | jq .
done
```

---

## 📦 Maven Modules

```
travel-plan-parent
├── shared
├── services
│   ├── auth-service
│   ├── user-service
│   ├── travel-service
│   └── payment-service
└── api-gateway
```

---

## 🔐 Default Roles

- `ADMIN` - Full access
- `USER` - Personal travel management
- `TRAVEL_AGENT` - Professional travel organization

---

## ✨ Current Phase Status

| Phase | Status | Owner |
|-------|--------|-------|
| Phase 1: Foundations | ✅ COMPLETE | All |
| Phase 2: Integration | ⏳ READY TO START | Personne 2 Lead |
| Phase 3: Polish & Bonus | ⏳ PLANNED | All |

---

## 🎯 Next Actions

1. Run `mvn clean install -DskipTests`
2. Run `docker-compose up -d`
3. Verify all containers are healthy
4. Read `BACKEND_WORKSTREAM.md` (Personne 2)
5. Start Phase 2 implementation

---

## 🆘 Troubleshooting

| Issue | Solution |
|-------|----------|
| Build fails | Run `mvn clean install -DskipTests` |
| Port already in use | Change port in `application.yml` |
| Eureka not showing services | Wait 30 seconds, services auto-register |
| Can't connect to DB | Check `docker-compose ps`, restart container |
| Tests failing | Verify Docker containers are running |

---

## 📞 Quick Links

- [Spring Boot Docs](https://spring.io/projects/spring-boot)
- [JWT Reference](https://jwt.io/)
- [PostgreSQL Docs](https://www.postgresql.org/docs/)
- [Neo4j Docs](https://neo4j.com/docs/)
- [Docker Docs](https://docs.docker.com/)

---

**Project**: Travel-Plan Microservices
**Version**: 1.0.0 (Phase 1)
**Java**: 17+
**Maven**: 3.8+
**Docker**: Latest
**Last Updated**: March 23, 2026

---

## Key Facts ✅

✅ Monorepo structure ready
✅ 4 microservices scaffolded  
✅ Database schemas designed
✅ Docker Compose configured
✅ DTOs and exceptions created
✅ Testing framework setup
✅ Documentation complete
✅ **Ready for Phase 2 development**

---

*For detailed information, see full documentation files.*
