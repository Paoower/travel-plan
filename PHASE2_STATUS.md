# 🚀 Phase 2 - Statut et Plan d'Action

**Date**: 24 Mars 2026  
**Phase**: 2 - Intégration (Semaine 2-3)

## 📊 Résumé de l'État

### ✅ Phase 1 Complétée
- ✅ Infrastructure Docker fonctionnelle (PostgreSQL, Neo4j)
- ✅ Services microservices scaffoldés
- ✅ API Gateway configurée
- ✅ Contrats API définis (DTOs, AuthRequest/Response)
- ✅ Structure du projet Maven

### 🔄 Phase 2 - EN COURS

**Responsabilités:**
- **Personne 1 (DevOps)**: Ansible, CI/CD, Logging distribuée
- **Personne 2 (Backend - TEZZY)**: Auth/Authorization, CRUD Users/Travels/Payments
- **Personne 3 (Frontend/QA)**: Dashboard, E2E Tests

---

## 🎯 Tâches Phase 2

### 1️⃣ PERSONNE 2 (Backend) - PRIORITÉ IMMÉDIATE

#### 1.1 Auth Service - Authentication & Authorization
- [ ] **JwtTokenProvider** - Générer/Valider JWT tokens
- [ ] **AuthController** - Endpoints POST `/auth/login` et `/auth/validate`
- [ ] **AuthService** - Logique d'authentification
- [ ] **AuthEntity** - Entité utilisateur pour l'authentification
- [ ] **RoleBasedAccessControl** - Middleware pour autorisation
- [ ] **Tests unitaires** - JUnit 5 + Mockito

**Endpoints à implémenter:**
```
POST   /auth/login       - Authentifier un utilisateur
POST   /auth/validate    - Valider un JWT token
POST   /auth/refresh     - Rafraîchir le token
DELETE /auth/logout      - Déconnecter l'utilisateur
```

#### 1.2 User Service - Gestion des utilisateurs
- [ ] **UserEntity** - Entité JPA avec constraints
- [ ] **UserRepository** - Requêtes JPQL personnalisées
- [ ] **UserService** - Logique métier (CRUD + validations)
- [ ] **UserController** - REST endpoints (CRUD)
- [ ] **Cascading Delete** - Suppression des données liées
- [ ] **Tests unitaires** + **Tests d'intégration**

**Endpoints CRUD:**
```
GET    /api/v1/users           - Lister tous les utilisateurs
GET    /api/v1/users/{id}      - Obtenir un utilisateur
POST   /api/v1/users           - Créer un utilisateur (Admin only)
PUT    /api/v1/users/{id}      - Modifier un utilisateur
DELETE /api/v1/users/{id}      - Supprimer un utilisateur
```

#### 1.3 Travel Service - Gestion des voyages
- [ ] **TravelEntity** - Entité PostgreSQL avec destinations/activités
- [ ] **TravelNeo4jEntity** - Nœud Neo4j pour les relations
- [ ] **TravelRepository** (PostgreSQL + Neo4j)
- [ ] **TravelService** - Logique métier complexe
- [ ] **TravelController** - REST endpoints (CRUD)
- [ ] **Tests unitaires** + **Tests d'intégration TestContainers**

**Endpoints CRUD:**
```
GET    /api/v1/travels           - Lister tous les voyages
GET    /api/v1/travels/{id}      - Obtenir les détails d'un voyage
POST   /api/v1/travels           - Créer un voyage (Admin only)
PUT    /api/v1/travels/{id}      - Modifier un voyage
DELETE /api/v1/travels/{id}      - Supprimer un voyage
GET    /api/v1/travels/{id}/activities - Activités du voyage
```

#### 1.4 Payment Service - Gestion des paiements
- [ ] **PaymentEntity** - Entité pour Stripe et PayPal
- [ ] **PaymentRepository** - Requêtes spécialisées
- [ ] **StripeIntegration** - Client Stripe
- [ ] **PayPalIntegration** - Client PayPal
- [ ] **PaymentService** - Logique métier
- [ ] **PaymentController** - REST endpoints (CRUD)
- [ ] **Tests unitaires** + Mocks pour Stripe/PayPal

**Endpoints CRUD:**
```
GET    /api/v1/payments           - Lister tous les paiements
GET    /api/v1/payments/{id}      - Obtenir un paiement
POST   /api/v1/payments           - Créer un paiement
PUT    /api/v1/payments/{id}      - Modifier un paiement
DELETE /api/v1/payments/{id}      - Supprimer un paiement
POST   /api/v1/payments/{id}/webhook - Webhook Stripe/PayPal
```

#### 1.5 Intégration de Base de Données
- [ ] **Vérifier les schémas** PostgreSQL et Neo4j
- [ ] **Implémenter les migrations** (Flyway ou Liquibase)
- [ ] **Tester les cascading deletes**
- [ ] **Optimizer les indexes**

---

### 2️⃣ PERSONNE 1 (DevOps) - TÂCHES PARALLÈLES

#### 2.1 Ansible Playbooks
- [ ] Créer playbook pour déployer les containers
- [ ] Playbook pour configurer la base de données
- [ ] Playbook pour démarrer les services
- [ ] Tests d'idempotence

#### 2.2 CI/CD Pipeline (Jenkins)
- [ ] Configurer Jenkins pour les PR
- [ ] Pipeline: Build → Test → SonarQube → Docker Build
- [ ] Artifacts et rapports de test
- [ ] Notifications Slack/Email

#### 2.3 Logging Distribuée
- [ ] Stack ELK (Elasticsearch, Logstash, Kibana)
- [ ] Configuration Docker pour les logs
- [ ] Traçage des requêtes inter-services

---

### 3️⃣ PERSONNE 3 (Frontend/QA) - TÂCHES PARALLÈLES

#### 3.1 Dashboard Admin
- [ ] Écrans CRUD pour Users
- [ ] Écrans CRUD pour Travels
- [ ] Écrans CRUD pour Payments
- [ ] Responsive design (Mobile, Tablet, Desktop)
- [ ] Tests E2E Cypress

#### 3.2 Tests E2E
- [ ] Scénarios de connexion/déconnexion
- [ ] Scénarios CRUD complets
- [ ] Tests de charge
- [ ] Tests de sécurité

---

## 🔨 Commandes pour Démarrer Phase 2

### Démarrer les bases de données uniquement
```bash
cd /home/romain/Z01/projets/travel-plan
docker-compose up -d postgres neo4j
```

### Démarrer toute l'infrastructure
```bash
docker-compose up -d
```

### Vérifier l'état des services
```bash
docker-compose ps
docker-compose logs auth-service
```

### Exécuter les tests
```bash
mvn clean test -DskipIntegrationTests=false
```

### Arrêter les services
```bash
docker-compose down
```

---

## 📋 Critères d'Acceptation Phase 2

### Pour chaque service:
- ✅ Endpoints CRUD fonctionnels
- ✅ Tests unitaires (>80% couverture)
- ✅ Tests d'intégration avec TestContainers
- ✅ Gestion d'erreurs correcte
- ✅ Validation des données
- ✅ Authentification/Autorisation
- ✅ Logging et traçage

### Infrastructure:
- ✅ Docker Compose fonctionnel
- ✅ Healthchecks actifs
- ✅ Ansible playbooks idempotents
- ✅ CI/CD pipeline en place
- ✅ Logs centralisés

---

## 🚨 Dépendances Critiques

1. **Personne 2 doit terminer Auth Service en PRIORITÉ** → Bloque tout le reste
2. **Personne 2 doit finaliser les schémas DB** → Bloque User/Travel/Payment
3. **Personne 1 doit déployer Jenkins** → Nécessaire pour PR validations
4. **Personne 3 commence le Dashboard** → Dépend de l'Auth

---

## 📅 Timeline Proposée

**Semaine 2:**
- J1-J2: Auth Service + DB schemas
- J3-J4: User Service + Tests
- J5: Review & Optimisations

**Semaine 3:**
- J1-J2: Travel Service
- J3-J4: Payment Service
- J5: Intégration complète et Tests E2E

**Semaine 4-5:**
- Polish, edge cases, documentation
- Kubernetes (Bonus Personne 1)
- Optimisations (Bonus Personne 2)

---

## 📞 Contacts et Questions

Pour des questions, consulter:
- Architecture: `docs/architecture/ARCHITECTURE.md`
- API Endpoints: `docs/guides/API_ENDPOINTS.md`
- Guides: `docs/guides/GETTING_STARTED.md`
