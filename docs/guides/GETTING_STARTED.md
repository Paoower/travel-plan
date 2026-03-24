# Getting Started Guide - Travel Plan Development

## Table of Contents
1. [Prerequisites](#prerequisites)
2. [Local Development Setup](#local-development-setup)
3. [Building the Project](#building-the-project)
4. [Running Services](#running-services)
5. [Testing](#testing)
6. [Troubleshooting](#troubleshooting)
7. [Development Workflow](#development-workflow)

---

## Prerequisites

### Required Software
- **Java 17+** - [Download](https://www.oracle.com/java/technologies/downloads/#java17)
  ```bash
  java -version  # Should show Java 17+
  ```

- **Maven 3.8+** - [Download](https://maven.apache.org/download.cgi)
  ```bash
  mvn -version  # Should show Maven 3.8+
  ```

- **Docker & Docker Compose** - [Download](https://www.docker.com/products/docker-desktop)
  ```bash
  docker --version
  docker-compose --version
  ```

- **Git** - [Download](https://git-scm.com/downloads)
  ```bash
  git --version
  ```

### Optional Tools
- **Postman/Insomnia** - API testing
- **IDE** - IntelliJ IDEA, VSCode, or Eclipse
- **SonarQube CLI** - Code quality analysis

---

## Local Development Setup

### Step 1: Clone and Setup

```bash
# Navigate to project directory
cd /home/romain/Z01/projets/travel-plan

# Create .env file from template
cp .env.example .env

# Edit .env with your secrets (optional for local dev)
# For local development, defaults are usually fine
```

### Step 2: Create Required Databases

```bash
# Ensure PostgreSQL and Neo4j are not running on local ports
# (they'll run in Docker containers)

# Verify ports are available
netstat -tuln | grep -E '5432|7687|8080|8001|8002|8003|8004|8761'
```

### Step 3: Start Infrastructure (Docker)

```bash
# Start all Docker containers (PostgreSQL, Neo4j, Eureka)
docker-compose up -d

# Verify services are running
docker-compose ps

# Expected output:
# NAME                        STATUS
# travel-plan-postgres        Up (healthy)
# travel-plan-neo4j           Up (healthy)
# travel-plan-eureka          Up (healthy)

# View logs for any service
docker-compose logs -f postgres
docker-compose logs -f neo4j
docker-compose logs -f eureka-server

# Stop containers when done
docker-compose down
```

### Step 4: Verify Database Connectivity

```bash
# Test PostgreSQL
docker exec -it travel-plan-postgres psql -U postgres -c "SELECT version();"

# Test Neo4j (via browser)
# Open: http://localhost:7474
# Username: neo4j
# Password: password

# Test Eureka (via browser)
# Open: http://localhost:8761
# Should see "No instances available"
```

---

## Building the Project

### Full Build (All Modules)

```bash
# Clean install (skip tests for faster build)
mvn clean install -DskipTests

# With tests
mvn clean install

# Build specific module
mvn -pl shared clean install
mvn -pl services/auth-service clean install
mvn -pl api-gateway clean install
```

### Build with Code Coverage

```bash
# Generate JaCoCo coverage report
mvn clean test jacoco:report

# View report
open target/site/jacoco/index.html  # macOS
# or
xdg-open target/site/jacoco/index.html  # Linux
```

### Build with SonarQube

```bash
# Requires SonarQube server running on localhost:9000
mvn clean verify sonar:sonar \
  -Dsonar.projectKey=travel-plan \
  -Dsonar.sources=. \
  -Dsonar.host.url=http://localhost:9000 \
  -Dsonar.login=admin \
  -Dsonar.password=admin
```

---

## Running Services

### Option 1: Run via Docker Compose (Recommended for Phase 1)

```bash
# Start all services in containers
docker-compose up

# Services will be available at:
# - API Gateway: http://localhost:8080
# - Auth Service: http://localhost:8001
# - User Service: http://localhost:8002
# - Travel Service: http://localhost:8003
# - Payment Service: http://localhost:8004
# - Eureka: http://localhost:8761
```

### Option 2: Run Services Individually (For Development)

**Prerequisites**: Docker containers still running for databases

```bash
# Terminal 1: Start Auth Service
cd services/auth-service
mvn spring-boot:run

# Terminal 2: Start User Service
cd services/user-service
mvn spring-boot:run

# Terminal 3: Start Travel Service
cd services/travel-service
mvn spring-boot:run

# Terminal 4: Start Payment Service
cd services/payment-service
mvn spring-boot:run

# Terminal 5: Start API Gateway
cd api-gateway
mvn spring-boot:run

# All services will register with Eureka automatically
```

### Option 3: Run from JAR Files

```bash
# Build JAR files
mvn clean package -DskipTests

# Run each service
java -jar services/auth-service/target/auth-service-*.jar
java -jar services/user-service/target/user-service-*.jar
java -jar services/travel-service/target/travel-service-*.jar
java -jar services/payment-service/target/payment-service-*.jar
java -jar api-gateway/target/api-gateway-*.jar
```

---

## Testing

### Unit Tests

```bash
# Run all unit tests
mvn test

# Run tests for specific module
mvn -pl services/auth-service test

# Run specific test class
mvn test -Dtest=AuthServiceApplicationTests

# Run with detailed output
mvn test -X

# Skip tests during build
mvn clean install -DskipTests
```

### Integration Tests with TestContainers

```bash
# Run tests with Docker containers (slower, but real DB testing)
mvn verify

# Tests use TestContainers to spin up ephemeral containers
```

### Manual Testing with Postman

1. **Import API Collection**:
   - File → Import → Select `API_ENDPOINTS.md` or create new collection

2. **Set Variables**:
   ```json
   {
     "base_url": "http://localhost:8080",
     "token": ""
   }
   ```

3. **Test Flow**:
   - POST `/api/auth/register` - Create user
   - POST `/api/auth/login` - Get token
   - Set token in `Authorization` header
   - Test CRUD operations on `/api/users`, `/api/travels`, etc.

### Load Testing (Phase 3)

```bash
# Install Apache JMeter or use wrk
apt-get install wrk

# Simple load test
wrk -t4 -c100 -d30s \
  -H "Authorization: Bearer <token>" \
  http://localhost:8080/api/users
```

---

## Troubleshooting

### Common Issues

#### 1. Port Already in Use
```bash
# Find process using port
lsof -i :8080  # macOS/Linux
netstat -ano | findstr :8080  # Windows

# Kill process
kill -9 <PID>  # Unix
taskkill /PID <PID> /F  # Windows

# Or change port in application.yml
server:
  port: 9090
```

#### 2. Docker Connection Issues
```bash
# Ensure Docker daemon is running
docker ps

# Restart Docker service
sudo systemctl restart docker  # Linux
# For macOS/Windows: Restart Docker Desktop

# Rebuild containers
docker-compose down -v  # Remove volumes
docker-compose up --build
```

#### 3. Database Connection Failed
```bash
# Check database container status
docker-compose ps

# View container logs
docker-compose logs postgres
docker-compose logs neo4j

# Connect to postgres directly
docker exec -it travel-plan-postgres psql -U postgres

# Connect to neo4j
# Browser: http://localhost:7474
```

#### 4. Maven Build Failures
```bash
# Clear Maven cache
rm -rf ~/.m2/repository

# Rebuild with verbose output
mvn clean install -X

# Update dependencies
mvn dependency:resolve-plugins -U
```

#### 5. Eureka Not Registering Services
```bash
# Check Eureka logs
docker-compose logs eureka-server

# Verify service discovery URL in application.yml
eureka:
  client:
    service-url:
      defaultZone: http://eureka-server:8761/eureka/

# Wait 30 seconds - services take time to register
sleep 30 && curl http://localhost:8761/eureka/apps
```

---

## Development Workflow

### Creating a New Feature

1. **Create Feature Branch**
```bash
git checkout -b feature/user-CRUD-operations
```

2. **Develop & Test**
```bash
# Make changes
# Run tests
mvn test

# View coverage
mvn jacoco:report
open target/site/jacoco/index.html
```

3. **Code Quality Check**
```bash
# Run SonarQube analysis
mvn clean verify sonar:sonar -Dsonar.host.url=http://localhost:9000
```

4. **Commit & Push**
```bash
git add .
git commit -m "feat: implement user CRUD operations"
git push origin feature/user-CRUD-operations
```

5. **Create Pull Request**
```bash
# On GitHub/GitLab
# - Provide clear description
# - Link related issues
# - Request code review
```

6. **Code Review & Merge**
```bash
# After approval, merge to main
git checkout main
git merge feature/user-CRUD-operations
git push origin main
```

### IDE Configuration

#### IntelliJ IDEA

1. Open Project → Select `/home/romain/Z01/projets/travel-plan`
2. File → Project Structure → SDKs → Add JDK 17
3. Run → Edit Configurations → Add Spring Boot configurations
4. Enable Annotation Processors: Settings → Compiler → Annotation Processors → Enable

#### VSCode

```json
// .vscode/settings.json
{
  "java.configuration.updateBuildConfiguration": "automatic",
  "java.compile.nullAnalysis.mode": "automatic",
  "[java]": {
    "editor.formatOnSave": true,
    "editor.defaultFormatter": "redhat.java"
  }
}
```

### Common Maven Commands

```bash
# Clean
mvn clean

# Install without tests
mvn install -DskipTests

# Package
mvn package

# Test
mvn test

# Build single module
mvn -pl services/auth-service install

# Skip modules
mvn install --pl !services/payment-service

# Update dependencies
mvn dependency:update-snapshots

# Generate dependency tree
mvn dependency:tree
```

---

## Next Steps

- Read [ARCHITECTURE.md](ARCHITECTURE.md) for system design
- Read [API_ENDPOINTS.md](API_ENDPOINTS.md) for API documentation
- Check database schemas in `db/` directory
- Review individual service READMEs for detailed information

---

**Last Updated**: March 23, 2026
**Phase**: 1 - Foundations ✅
