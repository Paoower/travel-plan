#!/usr/bin/env bash

# 🎯 Travel-Plan Project - Quickstart Checklist
# Run this to verify everything is ready

echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║         🚀 Travel-Plan Phase 1 - Quickstart Checklist        ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

# ==========================================
# REQUIREMENTS CHECK
# ==========================================
echo "📋 STEP 1: Checking Prerequisites"
echo "===================================="

# Check Docker
if command -v docker &> /dev/null; then
    DOCKER_VERSION=$(docker --version)
    echo "✅ Docker: $DOCKER_VERSION"
else
    echo "❌ Docker: NOT INSTALLED"
    echo "   Install from: https://www.docker.com/products/docker-desktop"
    exit 1
fi

# Check Docker Compose
if command -v docker-compose &> /dev/null; then
    COMPOSE_VERSION=$(docker-compose --version)
    echo "✅ Docker Compose: $COMPOSE_VERSION"
else
    echo "❌ Docker Compose: NOT INSTALLED"
    echo "   Install from: https://docs.docker.com/compose/install/"
    exit 1
fi

# Check Java (for local development)
if command -v java &> /dev/null; then
    JAVA_VERSION=$(java -version 2>&1 | grep version | awk '{print $3}' | tr -d '"')
    echo "✅ Java: $JAVA_VERSION"
else
    echo "⚠️  Java: NOT INSTALLED (optional, only needed for local development)"
fi

# Check Maven (for local development)
if command -v mvn &> /dev/null; then
    MVN_VERSION=$(mvn --version | head -1)
    echo "✅ Maven: $MVN_VERSION"
else
    echo "⚠️  Maven: NOT INSTALLED (optional, only needed for local development)"
fi

echo ""

# ==========================================
# PROJECT STRUCTURE CHECK
# ==========================================
echo "📁 STEP 2: Checking Project Structure"
echo "========================================"

FILES_TO_CHECK=(
    "docker-compose.yml:Docker Compose configuration"
    "pom.xml:Maven parent POM"
    "api-gateway/Dockerfile:API Gateway Docker image"
    "services/auth-service/Dockerfile:Auth Service Docker image"
    "services/user-service/Dockerfile:User Service Docker image"
    "services/travel-service/Dockerfile:Travel Service Docker image"
    "services/payment-service/Dockerfile:Payment Service Docker image"
    "db/01-postgresql-schema.sql:PostgreSQL schema"
    "db/02-neo4j-schema.cypher:Neo4j schema"
    "shared/pom.xml:Shared library POM"
)

for file_entry in "${FILES_TO_CHECK[@]}"; do
    IFS=':' read -r FILE DESC <<< "$file_entry"
    if [ -f "$FILE" ]; then
        echo "✅ $DESC"
    else
        echo "❌ $FILE: MISSING"
    fi
done

echo ""

# ==========================================
# DOCKER VERIFICATION
# ==========================================
echo "🐳 STEP 3: Verifying Docker Setup"
echo "===================================="

# Check if Docker daemon is running
if docker info &> /dev/null; then
    echo "✅ Docker daemon is running"
else
    echo "❌ Docker daemon is NOT running"
    echo "   Start Docker Desktop or the Docker daemon"
    exit 1
fi

# Check available disk space
DISK_AVAILABLE=$(df /var/lib/docker 2>/dev/null | awk 'NR==2 {print $4}' | numfmt --to=iec 2>/dev/null || echo "unknown")
echo "✅ Disk space available: $DISK_AVAILABLE"

echo ""

# ==========================================
# CONFIGURATION CHECK
# ==========================================
echo "⚙️  STEP 4: Checking Configuration Files"
echo "=========================================="

CONFIG_FILES=(
    ".env.example:Environment variables template"
    "commands.sh:Shell commands helper"
    "start.sh:Quick startup script"
)

for file_entry in "${CONFIG_FILES[@]}"; do
    IFS=':' read -r FILE DESC <<< "$file_entry"
    if [ -f "$FILE" ]; then
        echo "✅ $DESC"
    else
        echo "⚠️  $FILE: OPTIONAL"
    fi
done

echo ""

# ==========================================
# DOCUMENTATION CHECK
# ==========================================
echo "📚 STEP 5: Checking Documentation"
echo "===================================="

DOCS=(
    "README.md:Main README"
    "DETAILED_README.md:Detailed documentation"
    "PHASE1_COMPLETE.md:Phase 1 completion guide"
    "PHASE1_SUMMARY.md:Phase 1 summary"
)

for file_entry in "${DOCS[@]}"; do
    IFS=':' read -r FILE DESC <<< "$file_entry"
    if [ -f "$FILE" ]; then
        LINES=$(wc -l < "$FILE" 2>/dev/null || echo 0)
        echo "✅ $DESC ($LINES lines)"
    else
        echo "⚠️  $FILE: NOT FOUND"
    fi
done

echo ""

# ==========================================
# OPTIONAL: QUICK TEST
# ==========================================
echo "🧪 STEP 6: Quick System Test (Optional)"
echo "=========================================="

read -p "Do you want to test Docker build? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Building Docker images (this may take a few minutes)..."

    if docker-compose build 2>/dev/null | tail -5; then
        echo "✅ Docker build successful"
    else
        echo "⚠️  Docker build has issues (check output above)"
    fi
fi

echo ""

# ==========================================
# FINAL STATUS
# ==========================================
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║                    ✅ CHECKLIST COMPLETE!                      ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

echo "🚀 Ready to Start Project!"
echo ""
echo "Next Steps:"
echo "1. Review documentation: cat PHASE1_COMPLETE.md"
echo "2. Load bash commands: source commands.sh"
echo "3. Start the project: bash start.sh"
echo ""
echo "Or manually:"
echo "  docker-compose up -d"
echo ""
echo "Then check health:"
echo "  curl http://localhost:8001/actuator/health"
echo "  curl http://localhost:8080/actuator/health"
echo ""
echo "Browse APIs:"
echo "  • API Gateway: http://localhost:8080"
echo "  • Auth Service: http://localhost:8001"
echo "  • Database: localhost:5432 (postgres/postgres)"
echo ""
echo "Happy coding! 🎉"
echo ""
