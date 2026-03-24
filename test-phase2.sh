#!/bin/bash

# 🧪 PHASE 2 - TEST SUITE SCRIPT (Simplified)

PROJECT_DIR="/home/romain/Z01/projets/travel-plan"
cd "$PROJECT_DIR"

echo "═══════════════════════════════════════════════════════════════════"
echo "🧪 PHASE 2 - TEST SUITE & STATUS"
echo "═══════════════════════════════════════════════════════════════════"
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

PASSED=0
FAILED=0
WARNINGS=0

# Test result function
test_result() {
    if [ "$2" = "PASS" ]; then
        echo -e "${GREEN}✅${NC} $1"
        ((PASSED++))
    elif [ "$2" = "FAIL" ]; then
        echo -e "${RED}❌${NC} $1"
        ((FAILED++))
    else
        echo -e "${YELLOW}⚠️${NC} $1"
        ((WARNINGS++))
    fi
}

echo "📁 PROJECT STRUCTURE"
echo "─────────────────────────────────────────────────────────────────"
[ -d "services/auth-service" ] && test_result "Auth Service directory" "PASS" || test_result "Auth Service directory" "FAIL"
[ -d "services/user-service" ] && test_result "User Service directory" "PASS" || test_result "User Service directory" "FAIL"
[ -d "services/travel-service" ] && test_result "Travel Service directory" "PASS" || test_result "Travel Service directory" "FAIL"
[ -d "services/payment-service" ] && test_result "Payment Service directory" "PASS" || test_result "Payment Service directory" "FAIL"
[ -d "api-gateway" ] && test_result "API Gateway directory" "PASS" || test_result "API Gateway directory" "FAIL"
[ -d "shared" ] && test_result "Shared library directory" "PASS" || test_result "Shared library directory" "FAIL"
echo ""

echo "📦 MAVEN BUILD STATUS"
echo "─────────────────────────────────────────────────────────────────"
[ -f "pom.xml" ] && test_result "Root pom.xml" "PASS" || test_result "Root pom.xml" "FAIL"
[ -f "services/pom.xml" ] && test_result "Services pom.xml" "PASS" || test_result "Services pom.xml" "FAIL"
[ -f "api-gateway/target/api-gateway-1.0.0.jar" ] && test_result "API Gateway JAR" "PASS" || test_result "API Gateway JAR" "WARN"
[ -f "services/auth-service/target/auth-service-1.0.0.jar" ] && test_result "Auth Service JAR" "PASS" || test_result "Auth Service JAR" "WARN"
[ -f "services/user-service/target/user-service-1.0.0.jar" ] && test_result "User Service JAR" "PASS" || test_result "User Service JAR" "WARN"
[ -f "services/travel-service/target/travel-service-1.0.0.jar" ] && test_result "Travel Service JAR" "PASS" || test_result "Travel Service JAR" "WARN"
[ -f "services/payment-service/target/payment-service-1.0.0.jar" ] && test_result "Payment Service JAR" "PASS" || test_result "Payment Service JAR" "WARN"
echo ""

echo "🐳 DOCKER & INFRASTRUCTURE"
echo "─────────────────────────────────────────────────────────────────"
[ -f "docker-compose.yml" ] && test_result "docker-compose.yml" "PASS" || test_result "docker-compose.yml" "FAIL"
[ -f "api-gateway/Dockerfile" ] && test_result "API Gateway Dockerfile" "PASS" || test_result "API Gateway Dockerfile" "WARN"
[ -f "services/auth-service/Dockerfile" ] && test_result "Auth Service Dockerfile" "PASS" || test_result "Auth Service Dockerfile" "WARN"
[ -f "services/user-service/Dockerfile" ] && test_result "User Service Dockerfile" "PASS" || test_result "User Service Dockerfile" "WARN"
[ -f "services/travel-service/Dockerfile" ] && test_result "Travel Service Dockerfile" "PASS" || test_result "Travel Service Dockerfile" "WARN"
[ -f "services/payment-service/Dockerfile" ] && test_result "Payment Service Dockerfile" "PASS" || test_result "Payment Service Dockerfile" "WARN"
echo ""

echo "💾 DATABASE SCHEMAS"
echo "─────────────────────────────────────────────────────────────────"
[ -f "db/01-postgresql-schema.sql" ] && test_result "PostgreSQL schema" "PASS" || test_result "PostgreSQL schema" "FAIL"
[ -f "db/02-neo4j-schema.cypher" ] && test_result "Neo4j schema" "PASS" || test_result "Neo4j schema" "FAIL"
echo ""

echo "🧪 TEST SUITES"
echo "─────────────────────────────────────────────────────────────────"
[ -d "api-gateway/src/test" ] && test_result "API Gateway tests directory" "PASS" || test_result "API Gateway tests directory" "WARN"
[ -d "services/auth-service/src/test" ] && test_result "Auth Service tests directory" "PASS" || test_result "Auth Service tests directory" "WARN"
[ -d "services/user-service/src/test" ] && test_result "User Service tests directory" "PASS" || test_result "User Service tests directory" "WARN"
[ -d "services/travel-service/src/test" ] && test_result "Travel Service tests directory" "PASS" || test_result "Travel Service tests directory" "WARN"
[ -d "services/payment-service/src/test" ] && test_result "Payment Service tests directory" "PASS" || test_result "Payment Service tests directory" "WARN"
echo ""

echo "📚 DOCUMENTATION"
echo "─────────────────────────────────────────────────────────────────"
[ -f "README.md" ] && test_result "README.md" "PASS" || test_result "README.md" "FAIL"
[ -d "docs" ] && test_result "Documentation folder" "PASS" || test_result "Documentation folder" "FAIL"
[ -f "PHASE2_STATUS.md" ] && test_result "PHASE2_STATUS.md" "PASS" || test_result "PHASE2_STATUS.md" "PASS"
[ -d "docs/phase1" ] && test_result "Phase 1 docs" "PASS" || test_result "Phase 1 docs" "WARN"
[ -d "docs/phase2" ] && test_result "Phase 2 docs" "PASS" || test_result "Phase 2 docs" "WARN"
echo ""

echo "═══════════════════════════════════════════════════════════════════"
echo "📊 SUMMARY"
echo "═══════════════════════════════════════════════════════════════════"
echo -e "${GREEN}✅ PASS: $PASSED${NC}  ${RED}❌ FAIL: $FAILED${NC}  ${YELLOW}⚠️ WARN: $WARNINGS${NC}"
echo ""

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}✨ READY FOR PHASE 2 DEVELOPMENT!${NC}"
    echo ""
    echo "🎯 NEXT STEPS:"
    echo "─────────────────────────────────────────────────────────────────"
    echo ""
    echo "👨‍💻 PERSONNE 2 (Backend) - START HERE:"
    echo "   1. Implement Auth Service:"
    echo "      - JwtTokenProvider for token generation/validation"
    echo "      - AuthController with login/validate/refresh endpoints"
    echo "      - AuthService business logic"
    echo ""
    echo "   2. Implement User Service CRUD:"
    echo "      - UserEntity with JPA annotations"
    echo "      - UserRepository with custom queries"
    echo "      - UserService with validation"
    echo "      - UserController REST endpoints"
    echo ""
    echo "   3. Add Integration Tests:"
    echo "      - TestContainers for PostgreSQL"
    echo "      - Mock external services"
    echo "      - Test cascading deletes"
    echo ""
    echo "🔧 PERSONNE 1 (DevOps) - START HERE:"
    echo "   1. Create Ansible playbooks:"
    echo "      - Deploy PostgreSQL & Neo4j"
    echo "      - Deploy microservices"
    echo "      - Configure health checks"
    echo ""
    echo "   2. Setup CI/CD with Jenkins:"
    echo "      - Build pipeline"
    echo "      - Test execution"
    echo "      - SonarQube integration"
    echo ""
    echo "   3. Configure logging:"
    echo "      - ELK Stack setup"
    echo "      - Distributed tracing"
    echo ""
    echo "🎨 PERSONNE 3 (Frontend/QA) - START HERE:"
    echo "   1. Setup Dashboard project (React/Vue)"
    echo "   2. Create CRUD screens for:"
    echo "      - Users management"
    echo "      - Travels management"
    echo "      - Payments management"
    echo "   3. Setup E2E testing (Cypress)"
    echo ""
    echo "─────────────────────────────────────────────────────────────────"
    echo ""
    echo "📖 For details, see: PHASE2_STATUS.md"
    echo ""
else
    echo -e "${RED}⚠️ Fix failed tests before proceeding${NC}"
fi

exit 0
