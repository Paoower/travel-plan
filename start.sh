#!/bin/bash

echo "🚀 Démarrage du projet Travel-Plan..."
cd /home/romain/Z01/projets/travel-plan

echo "1️⃣  Arrêt des services existants..."
docker-compose down -v 2>/dev/null || true

echo "2️⃣  Attendre 3 secondes..."
sleep 3

echo "3️⃣  Démarrage des services..."
docker-compose up -d

echo "4️⃣  Attendre que les services démarrent..."
sleep 30

echo "5️⃣  État des services:"
docker-compose ps

echo ""
echo "6️⃣  Test de connectivité:"
echo ""

echo "🔷 PostgreSQL (5432):"
docker-compose exec -T postgres pg_isready -U postgres 2>/dev/null && echo "✅ OK" || echo "⏳ En démarrage"

echo ""
echo "🔷 Neo4j (7687):"
nc -zv -w2 localhost 7687 2>/dev/null && echo "✅ OK" || echo "⏳ En démarrage"

echo ""
echo "🔷 Auth Service (8001):"
curl -s http://localhost:8001/actuator/health 2>/dev/null | head -3 || echo "⏳ En démarrage"

echo ""
echo "================================"
echo "✨ Projet lancé ! Accédez à:"
echo "================================"
echo "🌐 API Gateway:     http://localhost:8080"
echo "🔐 Auth Service:    http://localhost:8001"
echo "👥 User Service:    http://localhost:8002"
echo "✈️ Travel Service:   http://localhost:8003"
echo "💳 Payment Service: http://localhost:8004"
echo "🗄️  PostgreSQL:      localhost:5432"
echo "📊 Neo4j:          http://localhost:7474"
echo "================================"
