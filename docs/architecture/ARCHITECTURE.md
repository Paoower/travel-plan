# Architecture Overview - Travel Plan Microservices

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                          CLIENT APPLICATIONS                                  │
│                  (Web Dashboard, Mobile App, Admin UI)                        │
└──────────────────────────────┬──────────────────────────────────────────────┘
                                │ HTTPS/TLS
                                ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                         API GATEWAY (Port 8080)                              │
│                   Spring Cloud Gateway + Eureka Client                       │
│                                                                              │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │  Responsibilities:                                                  │   │
│  │  • Request Routing (load balancing)                                │   │
│  │  • JWT Token Validation                                            │   │
│  │  • Rate Limiting                                                   │   │
│  │  • Request/Response Logging                                        │   │
│  │  • Service Discovery Integration                                   │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
│    ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  │
│    │ /api/auth/*  │  │ /api/users/* │  │/api/travels/*│  │/api/payments/│  │
│    └──────┬───────┘  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘  │
└───────────┼──────────────────┼──────────────────┼──────────────────┼────────┘
            │                  │                  │                  │
            ▼                  ▼                  ▼                  ▼
  ┌──────────────────┐  ┌──────────────────┐  ┌──────────────────┐  ┌──────────────────┐
  │  AUTH SERVICE    │  │  USER SERVICE    │  │ TRAVEL SERVICE   │  │ PAYMENT SERVICE  │
  │  (Port 8001)     │  │  (Port 8002)     │  │  (Port 8003)     │  │  (Port 8004)     │
  │                  │  │                  │  │                  │  │                  │
  │ Responsibilities:│  │ Responsibilities:│  │ Responsibilities:│  │ Responsibilities:│
  │ • Register users │  │ • User CRUD      │  │ • Travel CRUD    │  │ • Process Stripe │
  │ • Login          │  │ • User profiles  │  │ • Destinations   │  │ • Process PayPal │
  │ • JWT tokens     │  │ • Admin users    │  │ • Activities     │  │ • Payment history│
  │ • Auth/Authz     │  │ • Soft delete    │  │ • Itineraries    │  │ • Refunds        │
  │                  │  │                  │  │ • Neo4j recomm.  │  │ • Webhooks       │
  │  Database:       │  │  Database:       │  │                  │  │                  │
  │  PostgreSQL      │  │  PostgreSQL      │  │  Databases:      │  │  Database:       │
  │  (travel_plan_   │  │  (travel_plan_   │  │  PostgreSQL      │  │  PostgreSQL      │
  │   auth)          │  │   users)         │  │  (travel_plan_   │  │  (travel_plan_   │
  │                  │  │                  │  │   travels)       │  │   payments)      │
  │                  │  │                  │  │  +               │  │                  │
  │                  │  │                  │  │  Neo4j           │  │                  │
  │                  │  │                  │  │  (Destination    │  │                  │
  │                  │  │                  │  │   graphs)        │  │                  │
  └──────────────────┘  └──────────────────┘  └──────────────────┘  └──────────────────┘
            ▲                  ▲                  ▲                  ▲
            │                  │                  │                  │
            │   Service Discovery Registration    │                  │
            │        (Netflix Eureka)             │                  │
            └──────────────────┬──────────────────┴──────────────────┘
                                │
                                ▼
                    ┌─────────────────────────┐
                    │  EUREKA SERVER          │
                    │  (Port 8761)            │
                    │                         │
                    │ Service Registry &      │
                    │ Discovery Server        │
                    │                         │
                    │ • Service registration  │
                    │ • Health checks         │
                    │ • Load balancing info   │
                    └─────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                           DATA LAYER                                         │
│                                                                              │
│  ┌──────────────────────┐              ┌──────────────────────┐             │
│  │   PostgreSQL 15      │              │    Neo4j 5.6         │             │
│  │   (Relational DB)    │              │    (Graph DB)        │             │
│  │                      │              │                      │             │
│  │  Databases:          │              │  Purpose:            │             │
│  │  • travel_plan_auth  │              │  • Destination graph │             │
│  │  • travel_plan_users │              │  • Routes & paths    │             │
│  │  • travel_plan_      │              │  • Recommendations   │             │
│  │    travels           │              │  • Category mgmt     │             │
│  │  • travel_plan_      │              │  • Similarity search │             │
│  │    payments          │              │                      │             │
│  │                      │              │  Browser: :7474      │             │
│  │  Port: 5432          │              │  Bolt: :7687         │             │
│  └──────────────────────┘              └──────────────────────┘             │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                    EXTERNAL PAYMENT GATEWAYS                                 │
│                                                                              │
│  ┌──────────────────────────┐      ┌──────────────────────────┐             │
│  │      STRIPE             │      │       PAYPAL             │             │
│  │                          │      │                          │             │
│  │  • Card payments         │      │  • PayPal wallet         │             │
│  │  • Webhooks              │      │  • Webhooks              │             │
│  │  • Refunds               │      │  • Refunds               │             │
│  │  • Payment methods       │      │  • Payment methods       │             │
│  │                          │      │                          │             │
│  │  API Key secured         │      │  Client ID/Secret secured│             │
│  └──────────────────────────┘      └──────────────────────────┘             │
│                                                                              │
│   ◄─────────────────  Payment Service ────────────────────►                 │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                      INFRASTRUCTURE & DEVOPS                                 │
│                                                                              │
│  ┌──────────────────────┐  ┌──────────────────┐  ┌──────────────────────┐  │
│  │  DOCKER COMPOSE      │  │    JENKINS       │  │    SONARQUBE         │  │
│  │  (Local Dev)         │  │    (CI/CD)       │  │    (Code Quality)    │  │
│  │                      │  │                  │  │                      │  │
│  │  • Build services    │  │  • Build jobs    │  │  • Code analysis     │  │
│  │  • Run containers    │  │  • Unit tests    │  │  • Coverage reports  │  │
│  │  • Compose networks  │  │  • Integration   │  │  • Security issues   │  │
│  │                      │  │  • SonarQube scan│  │  • Code smells       │  │
│  │  Phase 1 Focus       │  │  • Deploy        │  │                      │  │
│  └──────────────────────┘  └──────────────────┘  └──────────────────────┘  │
│                                                                              │
│  Phase 2:                    Phase 3 (Bonus):                               │
│  • Ansible Playbooks         • Kubernetes Manifests                         │
│  • ELK Stack (Logging)       • Advanced Monitoring                          │
│  • Distributed Tracing       • Auto-scaling Policies                        │
└─────────────────────────────────────────────────────────────────────────────┘
```

## Data Flow Examples

### 1. User Registration & Login

```
Client                API Gateway         Auth Service         PostgreSQL
  │                        │                    │                   │
  ├─ POST /auth/register──►│                    │                   │
  │                        ├─ Forward Request──►│                   │
  │                        │                    ├─ Hash password    │
  │                        │                    ├─ Create user─────►│
  │                        │                    │◄─ User created ───┤
  │                        │◄─ Response ────────┤                   │
  │◄─ 201 Created ────────┤                    │                   │
  │                        │                    │                   │
  │                        │                    │                   │
  ├─ POST /auth/login ────►│                    │                   │
  │                        ├─ Forward Request──►│                   │
  │                        │                    ├─ Query user ─────►│
  │                        │                    │◄─ User found ─────┤
  │                        │                    ├─ Verify password  │
  │                        │                    ├─ Generate JWT     │
  │                        │◄─ {token, user}───┤                   │
  │◄─ 200 OK + token ─────┤                    │                   │
```

### 2. Create Travel with Destinations

```
Client                API Gateway       Travel Service      PostgreSQL     Neo4j
  │                        │                  │                │            │
  ├─ POST /travels ────────►│                  │                │            │
  │ (with auth token)       │──► Validate JWT  │                │            │
  │                        │                  │                │            │
  │                        ├─ Forward Request►│                │            │
  │                        │                  ├─ Create travel─►│            │
  │                        │                  │◄─ travel_id ───┤            │
  │                        │                  ├─ Create Neo4j──►│            │
  │                        │                  │  relationships  │            │
  │                        │                  │◄─ ack ─────────┤            │
  │                        │◄─ {travel} ─────┤                │            │
  │◄─ 201 Created ────────┤                  │                │            │
```

### 3. Process Payment

```
Client             API Gateway        Payment Service     PostgreSQL    Stripe API
  │                     │                    │                │            │
  ├─ POST /payments────►│                    │                │            │
  │ (travel_id, amount) │──► JWT validate    │                │            │
  │                     │                    │                │            │
  │                     ├─ Forward Request──►│                │            │
  │                     │                    ├─ Validate input│            │
  │                     │                    ├─ Call Stripe──────────────►│
  │                     │                    │                │            │
  │                     │                    │◄─ Charge result ◄──────────┤
  │                     │                    ├─ Store payment─►│            │
  │                     │                    │◄─ payment_id ─┤            │
  │                     │◄─ {payment} ──────┤                │            │
  │◄─ 200 OK ─────────┤                    │                │            │
```

## Security Architecture

```
┌──────────────────────────────────────────────────────────┐
│                  Security Layers                         │
│                                                          │
│  1. NETWORK LAYER (TLS/SSL)                             │
│     ├─ All communications encrypted in transit          │
│     ├─ Certificate management (Let's Encrypt/Vault)     │
│     └─ Internal network isolation (Docker networks)     │
│                                                          │
│  2. API GATEWAY LAYER                                   │
│     ├─ Request filtering & validation                   │
│     ├─ JWT token validation                             │
│     ├─ Rate limiting                                    │
│     └─ CORS policy enforcement                          │
│                                                          │
│  3. SERVICE LAYER                                       │
│     ├─ Spring Security integration                      │
│     ├─ Method-level authorization (@PreAuthorize)       │
│     ├─ Role-based access control (ADMIN/USER/AGENT)    │
│     └─ Service-to-service authentication                │
│                                                          │
│  4. DATA LAYER                                          │
│     ├─ Database user credentials (least privilege)      │
│     ├─ Encrypted password storage (BCrypt)              │
│     ├─ Input validation & sanitization                  │
│     └─ SQL injection prevention (parameterized queries) │
│                                                          │
│  5. SECRET MANAGEMENT                                   │
│     ├─ Environment variables (12-factor app)            │
│     ├─ API keys in .env (never in source)               │
│     ├─ Future: HashiCorp Vault integration              │
│     └─ Rotation policies for sensitive keys             │
└──────────────────────────────────────────────────────────┘
```

---

**Diagram Last Updated**: March 23, 2026
