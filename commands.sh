#!/bin/bash

# Travel-Plan Useful Commands
# Run: source commands.sh

echo "🚀 Travel-Plan Commands Loaded!"
echo ""
echo "Available Commands:"
echo "===================="
echo ""

# ====== DOCKER COMPOSE COMMANDS ======
alias tp-start='docker-compose up -d'
alias tp-stop='docker-compose down'
alias tp-restart='docker-compose restart'
alias tp-logs='docker-compose logs -f'
alias tp-ps='docker-compose ps'
alias tp-clean='docker-compose down -v && rm -rf /tmp/travel-plan-*'
alias tp-rebuild='docker-compose build --no-cache && docker-compose up -d'

# ====== SERVICE COMMANDS ======
alias tp-auth-logs='docker-compose logs -f auth-service'
alias tp-user-logs='docker-compose logs -f user-service'
alias tp-travel-logs='docker-compose logs -f travel-service'
alias tp-payment-logs='docker-compose logs -f payment-service'
alias tp-gateway-logs='docker-compose logs -f api-gateway'

# ====== DATABASE COMMANDS ======
alias tp-psql='docker-compose exec postgres psql -U postgres'
alias tp-pg-backup='docker-compose exec postgres pg_dump -U postgres postgres > backup-$(date +%Y%m%d-%H%M%S).sql'
alias tp-neo4j='docker-compose exec neo4j bin/cypher-shell'

# ====== TESTING COMMANDS ======
alias tp-test='mvn clean test'
alias tp-integration-test='mvn clean verify'
alias tp-coverage='mvn clean test jacoco:report && echo "Report: target/site/jacoco/index.html"'

# ====== BUILD COMMANDS ======
alias tp-build='mvn clean package -DskipTests'
alias tp-build-test='mvn clean package'
alias tp-install='mvn clean install -DskipTests'

# ====== HEALTH CHECKS ======
function tp-health() {
    echo "🏥 Travel-Plan Health Check"
    echo "============================"
    echo ""

    echo "Auth Service (8001):"
    curl -s http://localhost:8001/actuator/health | jq '.status'

    echo ""
    echo "User Service (8002):"
    curl -s http://localhost:8002/actuator/health | jq '.status'

    echo ""
    echo "Travel Service (8003):"
    curl -s http://localhost:8003/actuator/health | jq '.status'

    echo ""
    echo "Payment Service (8004):"
    curl -s http://localhost:8004/actuator/health | jq '.status'

    echo ""
    echo "API Gateway (8080):"
    curl -s http://localhost:8080/actuator/health | jq '.status'

    echo ""
    echo "PostgreSQL (5432):"
    docker-compose exec -T postgres pg_isready -U postgres 2>/dev/null && echo "UP" || echo "DOWN"

    echo ""
    echo "Neo4j (7687):"
    nc -zv -w2 localhost 7687 2>/dev/null && echo "UP" || echo "DOWN"
}

# ====== SERVICE MANAGEMENT ======
function tp-restart-service() {
    if [ -z "$1" ]; then
        echo "Usage: tp-restart-service <service-name>"
        echo "Available services: auth-service, user-service, travel-service, payment-service, api-gateway"
        return
    fi
    docker-compose restart $1 && echo "✅ Restarted $1"
}

function tp-logs-service() {
    if [ -z "$1" ]; then
        echo "Usage: tp-logs-service <service-name>"
        return
    fi
    docker-compose logs -f $1
}

# ====== DATABASE OPERATIONS ======
function tp-db-init() {
    echo "Initializing databases..."
    docker-compose exec -T postgres psql -U postgres < db/01-postgresql-schema.sql
    echo "✅ PostgreSQL schema initialized"
}

function tp-db-reset() {
    echo "⚠️  Resetting all databases (data will be lost)..."
    read -p "Are you sure? (yes/no): " confirm
    if [ "$confirm" = "yes" ]; then
        docker-compose down -v
        sleep 3
        docker-compose up -d postgres neo4j
        sleep 10
        tp-db-init
        echo "✅ Databases reset"
    else
        echo "Operation cancelled"
    fi
}

# ====== API TESTING ======
function tp-test-api() {
    echo "🧪 Testing API Endpoints"
    echo "=========================="

    echo ""
    echo "1️⃣  API Gateway Health:"
    curl -s http://localhost:8080/actuator/health | jq '.'

    echo ""
    echo "2️⃣  Auth Service Health:"
    curl -s http://localhost:8001/actuator/health | jq '.'
}

# ====== CLEANUP ======
function tp-cleanup() {
    echo "🧹 Cleaning up..."
    echo "Removing dangling Docker images..."
    docker image prune -f
    echo "Removing stopped containers..."
    docker container prune -f
    echo "✅ Cleanup complete"
}

# ====== INFO ======
function tp-info() {
    echo ""
    echo "╔═══════════════════════════════════════════════════════╗"
    echo "║           Travel-Plan Project Information            ║"
    echo "╚═══════════════════════════════════════════════════════╝"
    echo ""
    echo "📍 Project Location: /home/romain/Z01/projets/travel-plan"
    echo ""
    echo "🌐 Services:"
    echo "   • API Gateway:     http://localhost:8080"
    echo "   • Auth Service:    http://localhost:8001"
    echo "   • User Service:    http://localhost:8002"
    echo "   • Travel Service:  http://localhost:8003"
    echo "   • Payment Service: http://localhost:8004"
    echo ""
    echo "🗄️  Databases:"
    echo "   • PostgreSQL:      localhost:5432 (postgres/postgres)"
    echo "   • Neo4j Browser:   http://localhost:7474 (neo4j/password)"
    echo ""
    echo "📚 Commands:"
    echo "   tp-start           - Start all services"
    echo "   tp-stop            - Stop all services"
    echo "   tp-logs            - View logs (all services)"
    echo "   tp-health          - Check health of all services"
    echo "   tp-restart SERVICE - Restart specific service"
    echo "   tp-test            - Run unit tests"
    echo "   tp-build           - Build project (skip tests)"
    echo "   tp-clean           - Full cleanup"
    echo ""
}

# Print help on first load
tp-info
