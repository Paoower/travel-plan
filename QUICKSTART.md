# 🎓 GUIDE DÉMARRAGE RAPIDE - PHASE 2

## 🚀 En 5 Minutes

### 1️⃣ Vérifier l'état du projet
```bash
cd /home/romain/Z01/projets/travel-plan
bash test-phase2.sh
```

### 2️⃣ Démarrer l'infrastructure
```bash
docker-compose up -d postgres neo4j
# Attendre 10 secondes...
docker-compose ps
```

### 3️⃣ Compiler tous les services
```bash
mvn clean package -DskipTests -q
```

### 4️⃣ Lire la documentation
```bash
# Voir le plan complet
cat PHASE2_DASHBOARD.md

# Voir le status détaillé
cat PHASE2_STATUS.md
```

---

## 📚 Documentation Organisée

### Phase 1 (Complétée)
```
docs/phase1/
├── PHASE1_COMPLETE.md        ← Qu'est-ce qui a été fait
├── PHASE1_SUMMARY.md         ← Résumé exécutif
├── COMPLETION_REPORT.md      ← Rapport détaillé
└── FINAL_STATUS.txt          ← Statut final
```

### Phase 2 (EN COURS)
```
docs/phase2/
├── PHASE2_GETTING_STARTED.md ← Guide démarrage
└── BACKEND_WORKSTREAM.md     ← Détails backend

+ PHASE2_DASHBOARD.md         ← Tableau de bord complet
+ PHASE2_STATUS.md            ← Plan d'action
```

### Architecture & Design
```
docs/architecture/
├── ARCHITECTURE.md           ← Architecture microservices
└── FILE_MANIFEST.md          ← Structure du projet
```

### Guides & Références
```
docs/guides/
├── API_ENDPOINTS.md          ← Endpoints disponibles
├── GETTING_STARTED.md        ← Comment commencer
├── QUICK_REFERENCE.md        ← Référence rapide
└── CONTRIBUTING.md           ← Contribution guide
```

---

## 👨‍💻 PERSONNE 2 (Backend) - COMMANDES ESSENTIELLES

### Démarrer la dev Auth Service
```bash
# Terminal 1: Services en arrière-plan
cd /home/romain/Z01/projets/travel-plan
docker-compose up -d postgres

# Terminal 2: Auth Service avec hot-reload
cd services/auth-service
mvn spring-boot:run -Dspring-boot.run.arguments="--spring.profiles.active=dev"
```

### Tester Auth Service
```bash
# Login
curl -X POST http://localhost:8001/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@travel.com","password":"password123"}'

# Valider token
curl -X POST http://localhost:8001/auth/validate \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

### Compiling & Testing
```bash
# Build
mvn clean package -DskipTests

# Tests unitaires
mvn test

# Tests d'intégration
mvn verify

# Couverture de code
mvn test jacoco:report
# Voir le rapport: target/site/jacoco/index.html
```

### Fichiers à créer pour Auth Service
```
services/auth-service/src/main/java/com/travelplan/authservice/
├── security/
│   ├── JwtTokenProvider.java           ← Génère & valide JWT
│   ├── JwtAuthenticationFilter.java    ← Intercepte les requêtes
│   └── JwtAuthenticationEntryPoint.java← Gère les erreurs auth
├── service/
│   ├── AuthService.java                ← Logique auth
│   └── CustomUserDetailsService.java   ← Charge les utilisateurs
├── controller/
│   └── AuthController.java             ← Endpoints REST
├── entity/
│   └── User.java                       ← Entité JPA
├── repository/
│   └── UserRepository.java             ← Accès DB
├── dto/
│   └── AuthResponseDTO.java            ← Réponse login
└── test/
    ├── JwtTokenProviderTest.java
    ├── AuthServiceTest.java
    └── AuthControllerTest.java
```

### Dépendances pom.xml à ajouter
```xml
<!-- JWT -->
<dependency>
    <groupId>io.jsonwebtoken</groupId>
    <artifactId>jjwt-api</artifactId>
    <version>0.12.3</version>
</dependency>
<dependency>
    <groupId>io.jsonwebtoken</groupId>
    <artifactId>jjwt-impl</artifactId>
    <version>0.12.3</version>
    <scope>runtime</scope>
</dependency>
<dependency>
    <groupId>io.jsonwebtoken</groupId>
    <artifactId>jjwt-jackson</artifactId>
    <version>0.12.3</version>
    <scope>runtime</scope>
</dependency>

<!-- Spring Security -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-security</artifactId>
</dependency>

<!-- Testing -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-test</artifactId>
    <scope>test</scope>
</dependency>
```

---

## 🔧 PERSONNE 1 (DevOps) - COMMANDES ESSENTIELLES

### Vérifier Docker
```bash
docker --version
docker-compose --version
docker ps
docker images | grep travel
```

### Déployer avec Docker Compose
```bash
# Services individuels
docker-compose up -d postgres
docker-compose up -d neo4j
docker-compose up -d eureka-server

# Tous les services
docker-compose up -d

# Logs en temps réel
docker-compose logs -f auth-service
docker-compose logs -f user-service
```

### Créer structure Ansible
```bash
cd /home/romain/Z01/projets/travel-plan
mkdir -p ansible/{roles,playbooks,inventory}

# Rôles
mkdir -p ansible/roles/{docker,postgresql,neo4j,microservices,logging}/{tasks,handlers,templates,files}

# Inventaire
mkdir -p ansible/inventory
```

### Playbook de base à créer
```bash
# File: ansible/playbooks/deploy-infrastructure.yml
cat > ansible/playbooks/deploy-infrastructure.yml << 'EOF'
---
- name: Deploy Travel Plan Infrastructure
  hosts: all
  become: yes
  
  tasks:
    - name: Install Docker
      include_role:
        name: docker
    
    - name: Deploy PostgreSQL
      include_role:
        name: postgresql
    
    - name: Deploy Neo4j
      include_role:
        name: neo4j
    
    - name: Deploy Microservices
      include_role:
        name: microservices
    
    - name: Configure Logging (ELK)
      include_role:
        name: logging
EOF
```

### Jenkins Pipeline Groovy
```groovy
// Fichier: Jenkinsfile
pipeline {
    agent any
    
    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/your-repo/travel-plan.git'
            }
        }
        
        stage('Build') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }
        
        stage('Test') {
            steps {
                sh 'mvn test'
            }
        }
        
        stage('SonarQube Analysis') {
            steps {
                sh 'mvn sonar:sonar'
            }
        }
        
        stage('Docker Build') {
            steps {
                sh 'docker-compose build'
            }
        }
        
        stage('Deploy') {
            steps {
                sh 'docker-compose up -d'
            }
        }
    }
    
    post {
        always {
            junit 'target/surefire-reports/**/*.xml'
            publishHTML([
                reportDir: 'target/site/jacoco',
                reportFiles: 'index.html',
                reportName: 'JaCoCo Coverage Report'
            ])
        }
    }
}
```

---

## 🎨 PERSONNE 3 (Frontend/QA) - COMMANDES ESSENTIELLES

### Créer le projet Dashboard
```bash
# Option 1: React
npx create-react-app travel-admin-dashboard
cd travel-admin-dashboard
npm install axios react-router-dom

# Option 2: Vue
npm create vite@latest travel-admin-dashboard -- --template vue
cd travel-admin-dashboard
npm install
```

### Structure du Dashboard
```
travel-admin-dashboard/
├── public/
├── src/
│   ├── components/
│   │   ├── Auth/
│   │   │   ├── LoginPage.jsx
│   │   │   └── ProtectedRoute.jsx
│   │   ├── Users/
│   │   │   ├── UserList.jsx
│   │   │   ├── UserForm.jsx
│   │   │   └── UserDetail.jsx
│   │   ├── Travels/
│   │   │   ├── TravelList.jsx
│   │   │   ├── TravelForm.jsx
│   │   │   └── TravelDetail.jsx
│   │   ├── Payments/
│   │   │   ├── PaymentList.jsx
│   │   │   ├── PaymentForm.jsx
│   │   │   └── PaymentDetail.jsx
│   │   └── Layout/
│   │       ├── Navbar.jsx
│   │       ├── Sidebar.jsx
│   │       └── Layout.jsx
│   ├── services/
│   │   ├── api.js
│   │   ├── authService.js
│   │   ├── userService.js
│   │   ├── travelService.js
│   │   └── paymentService.js
│   ├── utils/
│   │   ├── tokenManager.js
│   │   └── validators.js
│   ├── App.jsx
│   └── main.jsx
├── cypress/
│   └── e2e/
│       ├── auth.cy.js
│       ├── users-crud.cy.js
│       ├── travels-crud.cy.js
│       └── payments-crud.cy.js
├── package.json
└── vite.config.js
```

### Cypress E2E Tests Setup
```bash
# Installer Cypress
npm install cypress --save-dev

# Ouvrir Cypress Test Runner
npx cypress open

# Écrire des tests
# cypress/e2e/auth.cy.js
describe('Auth Flow', () => {
    it('Should login successfully', () => {
        cy.visit('http://localhost:3000')
        cy.get('[data-testid=email-input]').type('admin@travel.com')
        cy.get('[data-testid=password-input]').type('password123')
        cy.get('[data-testid=login-button]').click()
        cy.url().should('include', '/dashboard')
    })
})
```

### Tester les endpoints API
```bash
# Auth Service
curl -X POST http://localhost:8001/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@travel.com","password":"pass123"}'

# User Service
curl -X GET http://localhost:8002/api/v1/users \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"

# Travel Service
curl -X GET http://localhost:8003/api/v1/travels \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"

# Payment Service
curl -X GET http://localhost:8004/api/v1/payments \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

---

## 🧪 TESTER RAPIDEMENT

### Test unitaire simple
```bash
# Auth Service
mvn -pl services/auth-service test

# User Service
mvn -pl services/user-service test

# Tous les services
mvn test
```

### Test d'intégration
```bash
# Avec TestContainers (PostgreSQL)
mvn verify

# Code coverage
mvn clean test jacoco:report
open target/site/jacoco/index.html
```

### Load Testing
```bash
# Installer Apache JMeter ou utiliser Artillery
npm install -g artillery

# Créer test: load-test.yml
echo "
config:
  target: 'http://localhost:8001'
  phases:
    - duration: 60
      arrivalRate: 10

scenarios:
  - name: 'Login Flow'
    flow:
      - post:
          url: '/auth/login'
          json:
            email: 'admin@travel.com'
            password: 'pass123'
" > load-test.yml

# Lancer le test
artillery run load-test.yml
```

---

## 🔍 DEBUGGING

### Logs
```bash
# Logs Docker
docker-compose logs auth-service
docker-compose logs -f user-service

# Logs fichier
tail -f /var/log/travel-plan/auth-service.log
```

### IDE Debugging
```java
// Dans AuthController.java
@PostMapping("/login")
public ResponseEntity<?> login(@RequestBody AuthRequestDTO request) {
    System.out.println("DEBUG: Login attempt for: " + request.getEmail());
    // Set breakpoint ici dans IDE
    return authService.authenticate(request);
}
```

### Port Forwarding
```bash
# Accéder aux services
# Auth:     http://localhost:8001
# User:     http://localhost:8002
# Travel:   http://localhost:8003
# Payment:  http://localhost:8004
# Gateway:  http://localhost:8080
# Neo4j:    http://localhost:7474
# Postgres: localhost:5432
```

---

## ✅ CHECKLIST PREMIÈRE SEMAINE

### Jour 1 (Lundi)
- [ ] P2: Créer JwtTokenProvider avec tests
- [ ] P1: Créer structure Ansible de base
- [ ] P3: Setup Dashboard projet

### Jour 2 (Mardi)
- [ ] P2: Implémenter AuthController + AuthService
- [ ] P2: Créer UserEntity et UserRepository
- [ ] P1: Créer playbooks Ansible

### Jour 3 (Mercredi)
- [ ] P2: User Service CRUD endpoints
- [ ] P2: Integration tests avec TestContainers
- [ ] P3: Dashboard Login page

### Jour 4 (Jeudi)
- [ ] P2: Tests complets Auth + User services
- [ ] P1: Setup Jenkins basique
- [ ] P3: Users CRUD screens

### Jour 5 (Vendredi)
- [ ] Code review session
- [ ] Fix les problèmes trouvés
- [ ] Préparation pour semaine 2

---

## 🚨 AIDE RAPIDE

**Problème**: Docker service ne démarre pas
```bash
docker-compose up -d SERVICE_NAME
docker-compose logs SERVICE_NAME
# Vérifier les erreurs et les dependances
```

**Problème**: Tests échouent
```bash
mvn clean test -X  # Mode debug
mvn test -Dtest=NomDuTest  # Test spécifique
```

**Problème**: Port déjà utilisé
```bash
lsof -i :8001  # Voir qui utilise le port
kill -9 PID    # Tuer le processus
```

---

## 📞 RESSOURCES

- **Maven**: https://maven.apache.org/
- **Spring Boot**: https://spring.io/projects/spring-boot
- **JWT**: https://jwt.io/
- **TestContainers**: https://www.testcontainers.org/
- **Docker**: https://docs.docker.com/
- **Ansible**: https://docs.ansible.com/

---

**Created**: 24 Mars 2026  
**Ready**: ✅ YES  
**Next Step**: Commencer l'implémentation Auth Service

