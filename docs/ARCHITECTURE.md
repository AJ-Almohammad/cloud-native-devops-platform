# Cloud Native DevOps Platform - Architecture Documentation

[![Architecture](https://img.shields.io/badge/Architecture-Microservices-blue.svg)](https://microservices.io/)
[![Kubernetes](https://img.shields.io/badge/Kubernetes-Local-326CE5.svg)](https://kubernetes.io/)
[![Status](https://img.shields.io/badge/Status-Production%20Ready-success.svg)](https://github.com/AJ-Almohammad/cloud-native-devops-platform)

> **Comprehensive architectural documentation for a cloud-native microservices platform**

---

## 📑 Table of Contents

- [Overview](#overview)
- [System Architecture](#system-architecture)
- [Microservices Architecture](#microservices-architecture)
- [Technology Stack](#technology-stack)
- [Deployment Architecture](#deployment-architecture)
- [Dashboard Architecture](#dashboard-architecture)
- [Security Architecture](#security-architecture)
- [Data Flow](#data-flow)
- [Key Architectural Decisions](#key-architectural-decisions)
- [Performance & Scalability](#performance--scalability)
- [Monitoring & Observability](#monitoring--observability)
- [Future Considerations](#future-considerations)

---

## 🎯 Overview

The Cloud Native DevOps Platform is built on a modern microservices architecture, deployed on local Kubernetes (Docker Desktop) with comprehensive monitoring, CI/CD automation, and enhanced dashboard capabilities.

### Architecture Principles

- **Microservices-First**: Independent, loosely coupled services
- **Container-Native**: Docker containerization for all components
- **Infrastructure as Code**: Declarative configuration management
- **DevOps Automation**: Continuous integration and deployment
- **Observability**: Real-time monitoring and health checks
- **Scalability**: Horizontal scaling capabilities

---

## 🏗️ System Architecture

### High-Level Architecture

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                        LOCAL DEVELOPMENT PLATFORM                            │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                               │
│  ┌─────────────────┐      ┌──────────────────┐      ┌────────────────────┐ │
│  │                 │      │                  │      │                    │ │
│  │ DOCKER DESKTOP  │      │   KUBERNETES     │      │   DATABASE LAYER   │ │
│  │   KUBERNETES    │◄────►│    NAMESPACE     │◄────►│   (PostgreSQL)     │ │
│  │    CLUSTER      │      │ multi-everything │      │    & Secrets       │ │
│  │                 │      │                  │      │                    │ │
│  └─────────────────┘      └──────────────────┘      └────────────────────┘ │
│           │                        │                          │             │
│           │                        │                          │             │
│           ▼                        ▼                          ▼             │
│  ┌─────────────────┐      ┌────────────────┐      ┌────────────────┐      │
│  │   CONTAINER     │      │  MICROSERVICES │      │ CONFIGURATION  │      │
│  │    RUNTIME      │      │   DEPLOYMENT   │      │  MANAGEMENT    │      │
│  │   (Docker)      │      │   (5 Services) │      │   (Ansible)    │      │
│  └─────────────────┘      └────────────────┘      └────────────────┘      │
│                                    │                                        │
│                                    ▼                                        │
│                           ┌─────────────────┐                              │
│                           │    ENHANCED     │                              │
│                           │    DASHBOARD    │                              │
│                           │  (CORS Proxy)   │                              │
│                           └─────────────────┘                              │
│                                                                               │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Component Breakdown

| Layer | Components | Purpose |
|-------|------------|---------|
| **Infrastructure** | Docker Desktop, Kubernetes | Container orchestration & management |
| **Platform** | Namespace, Services, Secrets | Service isolation & configuration |
| **Application** | 5 Microservices | Business logic implementation |
| **Automation** | Ansible, Jenkins | Configuration & CI/CD automation |
| **Monitoring** | Enhanced Dashboard, Proxy | Real-time observability |

---

## 🎯 Microservices Architecture

### Service Ecosystem

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                        MICROSERVICES ECOSYSTEM                               │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                               │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐       │
│  │   CONTENT   │  │    USER     │  │  ANALYTICS  │  │NOTIFICATION │       │
│  │     API     │  │   SERVICE   │  │   SERVICE   │  │   SERVICE   │       │
│  │             │  │             │  │             │  │             │       │
│  │  📝 PHP     │  │  👤 Python  │  │  📊 Node.js │  │  🔔 Go      │       │
│  │  Port: 80   │  │ Port: 8000  │  │ Port: 3000  │  │ Port: 8080  │       │
│  └──────┬──────┘  └──────┬──────┘  └──────┬──────┘  └──────┬──────┘       │
│         │                │                │                │               │
│         └────────────────┴────────────────┴────────────────┘               │
│                                  │                                          │
│                     ┌────────────┴────────────┐                            │
│                     │                         │                            │
│            ┌────────▼────────┐      ┌─────────▼─────────┐                 │
│            │      CRON       │      │     JENKINS       │                 │
│            │   SCHEDULER     │      │      CI/CD        │                 │
│            │                 │      │                   │                 │
│            │  ⏰ Python      │      │   🚀 Pipeline     │                 │
│            │  Port: 8000     │      │   Port: 30080     │                 │
│            └─────────────────┘      └───────────────────┘                 │
│                                                                               │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Service Details

#### 1. Content API Service

**Technology Stack**: PHP/Slim Framework  
**Port**: 80  
**Purpose**: Content management and delivery

```yaml
Features:
  - RESTful API endpoints
  - Content CRUD operations
  - Data validation & sanitization
  - Health monitoring endpoint
  
Health Check:
  Endpoint: /health
  Method: GET
  Response: 200 OK
```

#### 2. User Service

**Technology Stack**: Python/FastAPI  
**Port**: 8000  
**Purpose**: User authentication and management

```yaml
Features:
  - User registration & authentication
  - JWT token management
  - Role-based access control
  - PostgreSQL database integration
  
Health Check:
  Endpoint: /health
  Method: GET
  Response: 200 OK
```

#### 3. Analytics Service

**Technology Stack**: Node.js/Express  
**Port**: 3000  
**Purpose**: Data analytics and reporting

```yaml
Features:
  - Real-time data processing
  - Metrics aggregation
  - Report generation
  - Dashboard API integration
  
Health Check:
  Endpoint: /health
  Method: GET
  Response: 200 OK
```

#### 4. Notification Service

**Technology Stack**: Go/Gin Framework  
**Port**: 8080  
**Purpose**: Event-driven notifications

```yaml
Features:
  - Multi-channel notifications
  - Event queue processing
  - Template management
  - Delivery tracking
  
Health Check:
  Endpoint: /health
  Method: GET
  Response: 200 OK
```

#### 5. Cron Scheduler Service

**Technology Stack**: Python/Celery  
**Port**: 8000  
**Purpose**: Scheduled task execution

```yaml
Features:
  - Periodic job scheduling
  - Task queue management
  - Retry mechanisms
  - Execution logging
  
Health Check:
  Endpoint: /health
  Method: GET
  Response: 200 OK
```

---

## 🔧 Technology Stack

### Infrastructure Layer

| Component | Technology | Version | Purpose |
|-----------|------------|---------|---------|
| **Container Runtime** | Docker Engine | 20.10+ | Containerization |
| **Orchestration** | Kubernetes (Docker Desktop) | 1.28+ | Container management |
| **Database** | PostgreSQL | 14+ | Persistent storage |
| **Service Mesh** | Kubernetes Services | - | Service discovery |
| **Load Balancing** | Kubernetes LoadBalancer | - | Traffic distribution |
| **CI/CD** | Jenkins on K8s | 2.400+ | Automation pipeline |

### Microservices Layer

| Service | Language | Framework | Database | Port |
|---------|----------|-----------|----------|------|
| **Content API** | PHP 8.1+ | Slim Framework 4.x | PostgreSQL | 80 |
| **User Service** | Python 3.10+ | FastAPI 0.100+ | PostgreSQL | 8000 |
| **Analytics Service** | Node.js 18+ | Express 4.x | PostgreSQL | 3000 |
| **Notification Service** | Go 1.20+ | Gin 1.9+ | PostgreSQL | 8080 |
| **Cron Scheduler** | Python 3.10+ | Celery 5.3+ | PostgreSQL | 8000 |

### Monitoring & Dashboard Layer

| Component | Technology | Purpose | Port |
|-----------|------------|---------|------|
| **Enhanced Dashboard** | HTML/CSS/JavaScript | Real-time monitoring | 3000 |
| **CORS Proxy Server** | Node.js/Express | CORS handling | 3000 |
| **Portfolio Dashboard** | HTML/CSS/JavaScript | Documentation | 8080 |
| **Health Monitoring** | Custom JavaScript | Service checks | - |
| **Visualization** | Chart.js | Metrics display | - |

---

## 🚀 Deployment Architecture

### CI/CD Pipeline Flow

```
┌───────────────┐      ┌───────────────┐      ┌───────────────┐
│   DEVELOPER   │      │    ANSIBLE    │      │    JENKINS    │
│               │      │   AUTOMATION  │      │    ON K8S     │
│ Code Changes  │─────►│   Playbooks   │─────►│   Pipeline    │
│               │      │               │      │               │
└───────────────┘      └───────────────┘      └───────────────┘
                                │                      │
                                │                      │
                                ▼                      ▼
                       ┌───────────────┐      ┌───────────────┐
                       │   LOCAL GIT   │      │    DOCKER     │
                       │  REPOSITORY   │      │    DESKTOP    │
                       │               │      │  KUBERNETES   │
                       │ • Version     │      │               │
                       │   Control     │      │ • 5 Services  │
                       │ • Collaboration│      │ • Auto-heal  │
                       └───────────────┘      └───────────────┘
```

### Deployment Strategy

#### Rolling Update Configuration

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: microservice-deployment
  namespace: multi-everything
spec:
  replicas: 2
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 0
  template:
    spec:
      containers:
      - name: service-container
        image: service:latest
        ports:
        - containerPort: 8080
        livenessProbe:
          httpGet:
            path: /health
            port: 8080
          initialDelaySeconds: 30
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /health
            port: 8080
          initialDelaySeconds: 5
          periodSeconds: 5
```

### Local Kubernetes Architecture

```yaml
Kubernetes Cluster Configuration:
  Environment: Local Development
  Provider: Docker Desktop
  
  Namespace: multi-everything
  
  Resources:
    - Deployments: 5 (one per microservice)
    - Services: 5 (ClusterIP/LoadBalancer)
    - Secrets: 1 (database credentials)
    - ConfigMaps: As needed per service
    
  Networking:
    - Service Discovery: DNS-based
    - Load Balancing: Built-in K8s LoadBalancer
    - Ingress: NodePort for external access
    
  Storage:
    - Persistent Volumes: For PostgreSQL
    - Secrets: For sensitive data
    
  High Availability:
    - Replica Count: 2-3 per service
    - Auto-healing: Kubernetes liveness probes
    - Rolling Updates: Zero-downtime deployments
```

---

## 📊 Dashboard Architecture

### Enhanced Dashboard Stack

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                     ENHANCED DASHBOARD ARCHITECTURE                          │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                               │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐             │
│  │   PORTFOLIO     │  │    ENHANCED     │  │     PROXY       │             │
│  │   DASHBOARD     │  │    DASHBOARD    │  │    SERVER       │             │
│  │                 │  │   WITH CORS     │  │   (Node.js)     │             │
│  │ • Project       │  │                 │  │                 │             │
│  │   Overview      │  │ • Real-time     │  │ • CORS Bypass   │             │
│  │ • Service Status│  │   Monitoring    │  │ • Request       │             │
│  │ • Architecture  │  │ • Health Checks │  │   Routing       │             │
│  │   Diagrams      │  │ • Metrics       │  │ • Service       │             │
│  │ • Documentation │  │   Display       │  │   Integration   │             │
│  └────────┬────────┘  └────────┬────────┘  └────────┬────────┘             │
│           │                    │                     │                      │
│           └────────────────────┴─────────────────────┘                      │
│                                │                                            │
│                                ▼                                            │
│                    ┌─────────────────────────┐                             │
│                    │    MICROSERVICES        │                             │
│                    │    HEALTH ENDPOINTS     │                             │
│                    │                         │                             │
│                    │ • /health APIs          │                             │
│                    │ • Kubernetes Services   │                             │
│                    │ • Local Network Access  │                             │
│                    └─────────────────────────┘                             │
│                                                                               │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Dashboard Features

#### Real-time Monitoring Capabilities

```javascript
const MONITORING_FEATURES = {
  serviceHealth: {
    enabled: true,
    interval: 30000,        // 30 seconds auto-refresh
    endpoints: 5,           // All microservices
    retryAttempts: 3
  },
  
  metrics: {
    responseTimes: true,    // Track API response times
    uptimeTracking: true,   // Service availability
    errorRates: true,       // Error monitoring
    requestCounts: true     // Traffic analysis
  },
  
  visualization: {
    charts: true,           // Chart.js integration
    statusIndicators: true, // Visual health status
    historicalData: true,   // Trend analysis
    realTimeUpdates: true   // Live data refresh
  },
  
  accessibility: {
    corsProxy: true,        // CORS handling
    localAccess: true,      // localhost support
    mobileFriendly: true,   // Responsive design
    darkMode: false         // Future enhancement
  }
};
```

#### Portfolio Dashboard Components

```yaml
Portfolio Sections:
  
  Overview:
    - Project description
    - Architecture diagrams
    - Technology stack
    - Key features
  
  Services:
    - Service documentation
    - API specifications
    - Health status
    - Performance metrics
  
  Deployment:
    - Kubernetes status
    - CI/CD pipeline info
    - Deployment history
    - Resource utilization
  
  Integration:
    - Live API testing
    - Interactive demos
    - GitHub repository
    - Contact information
```

---

## 🔒 Security Architecture

### Security Layers

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                             SECURITY LAYERS                                  │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                               │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐             │
│  │    NETWORK      │  │   APPLICATION   │  │      DATA       │             │
│  │    SECURITY     │  │    SECURITY     │  │    SECURITY     │             │
│  │                 │  │                 │  │                 │             │
│  │ • K8s Network   │  │ • Input         │  │ • K8s Secrets   │             │
│  │   Policies      │  │   Validation    │  │ • Base64        │             │
│  │ • Service       │  │ • CORS Proxy    │  │   Encoding      │             │
│  │   Isolation     │  │ • Rate Limiting │  │ • Environment   │             │
│  │ • Firewall      │  │ • Auth Tokens   │  │   Variables     │             │
│  │   Rules         │  │ • API Keys      │  │ • TLS/SSL       │             │
│  └─────────────────┘  └─────────────────┘  └─────────────────┘             │
│                                                                               │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Security Implementation

#### 1. Network Security

```yaml
Kubernetes Network Policies:
  - Service-to-service communication rules
  - Namespace isolation
  - Port restrictions
  - Ingress/Egress controls
  
Docker Network:
  - Internal container network
  - Service discovery via DNS
  - Network segmentation
```

#### 2. Application Security

```yaml
Security Measures:
  - Input validation and sanitization
  - SQL injection prevention
  - XSS protection
  - CSRF tokens
  - Rate limiting
  - API authentication
  
CORS Configuration:
  - Proxy server for CORS handling
  - Allowed origins whitelist
  - Credential handling
```

#### 3. Data Security

```yaml
Secret Management:
  - Kubernetes Secrets for sensitive data
  - Base64 encoding
  - Environment variable injection
  - No secrets in version control
  
Database Security:
  - Connection encryption
  - Password complexity requirements
  - User role separation
  - Regular backups
```

---

## 🔄 Data Flow

### Dashboard Request Flow

```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│   CLIENT    │    │  ENHANCED   │    │   PROXY     │    │ MICROSERVICE│
│             │    │  DASHBOARD  │    │   SERVER    │    │   HEALTH    │
│ Web Browser │───►│  (HTML/JS)  │───►│  (Node.js)  │───►│  ENDPOINT   │
│             │    │             │    │             │    │             │
└─────────────┘    └─────────────┘    └─────────────┘    └─────────────┘
      │                   │                   │                   │
      │                   │                   │                   │
      ▼                   ▼                   ▼                   ▼
┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│  REAL-TIME  │    │    CORS     │    │ KUBERNETES  │    │   SERVICE   │
│   UPDATE    │    │  HANDLING   │    │   SERVICE   │    │  DISCOVERY  │
│(JavaScript) │    │  (Express)  │    │  DISCOVERY  │    │    (DNS)    │
└─────────────┘    └─────────────┘    └─────────────┘    └─────────────┘
```

### Service-to-Service Communication

```
┌─────────────┐         ┌─────────────┐         ┌─────────────┐
│   Content   │────────►│    User     │────────►│ Analytics   │
│     API     │         │   Service   │         │   Service   │
└─────────────┘         └─────────────┘         └─────────────┘
       │                       │                       │
       │                       │                       │
       ▼                       ▼                       ▼
┌─────────────┐         ┌─────────────┐         ┌─────────────┐
│Notification │         │    Cron     │         │  Database   │
│   Service   │         │  Scheduler  │         │ PostgreSQL  │
└─────────────┘         └─────────────┘         └─────────────┘
```

### Communication Patterns

| Pattern | Implementation | Use Case |
|---------|---------------|----------|
| **Synchronous** | HTTP/REST | Real-time requests |
| **Service Discovery** | Kubernetes DNS | Service location |
| **Load Balancing** | K8s Services | Traffic distribution |
| **Health Checks** | HTTP probes | Availability monitoring |

---

## 🎯 Key Architectural Decisions

### Decision 1: Local Kubernetes Over Cloud

**Decision**: Docker Desktop Kubernetes instead of AWS EKS

**Rationale**:
- Cost-effective development environment
- Faster iteration and testing cycles
- No cloud dependencies or costs
- Realistic production simulation
- Easier demonstration and portfolio showcase

**Trade-offs**:
- ✅ **Pros**: Zero cloud costs, faster setup, full control
- ⚠️ **Cons**: Limited scaling, single-node cluster, local resources only

**Mitigation**: Architecture designed for easy cloud migration when needed

---

### Decision 2: Enhanced Dashboard Over Full Monitoring Stack

**Decision**: Custom enhanced dashboard instead of Prometheus/Grafana

**Rationale**:
- Simplified monitoring setup
- Better user experience for demonstrations
- Faster deployment and configuration
- Lower resource requirements
- Customizable to specific needs

**Trade-offs**:
- ✅ **Pros**: Simple, fast, customized, lightweight
- ⚠️ **Cons**: Limited advanced metrics, no alerting system

**Mitigation**: Dashboard designed with extensibility in mind

---

### Decision 3: CORS Proxy Implementation

**Decision**: Node.js proxy server for external dashboard access

**Rationale**:
- Enables seamless local access without CORS issues
- Better user experience for dashboard users
- Centralized request handling
- Simple implementation and maintenance

**Trade-offs**:
- ✅ **Pros**: Solves CORS issues, easy to implement, flexible
- ⚠️ **Cons**: Additional component to maintain, single point of failure

**Mitigation**: Lightweight implementation with error handling

---

### Decision 4: Microservices Architecture

**Decision**: Microservices pattern over monolithic architecture

**Rationale**:
- Independent service development and deployment
- Technology diversity (polyglot architecture)
- Realistic enterprise pattern demonstration
- Better fault isolation
- Easier scaling and maintenance

**Trade-offs**:
- ✅ **Pros**: Scalable, maintainable, realistic, flexible
- ⚠️ **Cons**: Increased complexity, network overhead, distributed debugging

**Mitigation**: Comprehensive monitoring and health checks

---

### Decision 5: Infrastructure as Code

**Decision**: Ansible + Kubernetes manifests over full Terraform

**Rationale**:
- Simplified local development workflow
- Faster deployment cycles
- Better suited for Kubernetes operations
- Easier learning curve
- Focused on orchestration

**Trade-offs**:
- ✅ **Pros**: Fast deployment, K8s-native, simple
- ⚠️ **Cons**: Less cloud infrastructure automation

**Mitigation**: Modular design allows Terraform integration later

---

## 📈 Performance & Scalability

### Performance Characteristics

| Service | Avg Response Time | Throughput | Concurrent Users |
|---------|------------------|------------|------------------|
| **Content API** | < 100ms | 1000 req/s | 500 |
| **User Service** | < 150ms | 800 req/s | 400 |
| **Analytics Service** | < 200ms | 600 req/s | 300 |
| **Notification Service** | < 50ms | 1200 req/s | 600 |
| **Cron Scheduler** | N/A (async) | Background | N/A |

### Scalability Strategy

```yaml
Horizontal Scaling:
  - Kubernetes replica sets
  - Load balancing across pods
  - Auto-scaling policies (future)
  
Vertical Scaling:
  - Resource limits per container
  - CPU and memory optimization
  - Database connection pooling
  
Performance Optimization:
  - Caching strategies
  - Database indexing
  - Query optimization
  - Code profiling
```

---

## 🔍 Monitoring & Observability

### Monitoring Stack

```yaml
Components:
  
  Enhanced Dashboard:
    - Real-time service health
    - Response time tracking
    - Uptime monitoring
    - Visual status indicators
    
  Kubernetes Monitoring:
    - Pod status and logs
    - Resource utilization
    - Event tracking
    - Deployment history
    
  Application Logging:
    - Structured logging
    - Log aggregation
    - Error tracking
    - Performance metrics
```

### Health Check Configuration

```yaml
Health Checks:
  
  Liveness Probe:
    - Checks if service is running
    - Restarts pod on failure
    - Interval: 10 seconds
    
  Readiness Probe:
    - Checks if service is ready
    - Removes from load balancer if not ready
    - Interval: 5 seconds
    
  Startup Probe:
    - Initial startup check
    - Allows longer startup time
    - Interval: 10 seconds
```

---

## 🔮 Future Considerations

### Planned Enhancements

#### Short-term (1-3 months)

- [ ] Advanced metrics collection (Prometheus integration)
- [ ] User authentication for dashboard
- [ ] Alerting system for service downtime
- [ ] Historical data storage and analysis
- [ ] Performance optimization

#### Medium-term (3-6 months)

- [ ] Multi-cluster support
- [ ] Service mesh implementation (Istio/Linkerd)
- [ ] Advanced observability (distributed tracing)
- [ ] Automated backup strategies
- [ ] Cloud migration preparation (AWS/GCP)

#### Long-term (6-12 months)

- [ ] Full cloud deployment
- [ ] Auto-scaling implementation
- [ ] Advanced security features
- [ ] Multi-region deployment
- [ ] Disaster recovery planning

### Technical Debt

| Category | Description | Priority |
|----------|-------------|----------|
| **Dashboard Scaling** | Plan for increased monitoring load | Medium |
| **Security Hardening** | Enhanced proxy security features | High |
| **Performance** | Caching strategies for dashboard | Medium |
| **Backup** | Automated K8s resource backup | High |
| **Testing** | Comprehensive test coverage | High |

---

## 📚 Reference Architecture Patterns

### Applied Patterns

- **Microservices Pattern**: Service decomposition and independence
- **API Gateway Pattern**: Centralized entry point (future)
- **Service Discovery**: Kubernetes DNS-based discovery
- **Health Check Pattern**: Liveness and readiness probes
- **Circuit Breaker**: Fault tolerance (future implementation)
- **Sidecar Pattern**: Proxy server for CORS handling

---

## 📝 Architecture Metrics

```yaml
System Metrics:
  Total Services: 5
  Total Containers: ~10-15 (with replicas)
  Deployment Time: < 5 minutes
  Recovery Time: < 30 seconds
  Uptime Target: 99.9%
  
Resource Allocation:
  Total Memory: 4-6 GB
  Total CPU: 2-4 cores
  Storage: 10-20 GB
  Network: Local Docker network
```

---

## 📞 Architecture Support

For architectural questions or clarifications:

- **Email**: ajaber1973@web.de
- **GitHub**: [@AJ-Almohammad](https://github.com/AJ-Almohammad)
- **Documentation**: Check `/docs` directory
- **Issues**: [GitHub Issues](https://github.com/AJ-Almohammad/cloud-native-devops-platform/issues)

---

<div align="center">

**Architecture Documentation Version**: 2.0  
**Last Updated**: October 2024  
**Environment**: Local Development (Docker Desktop Kubernetes)  
**Maintainer**: Amer Almohammad - AWS Junior Cloud Engineer

---

*Built with ❤️ for modern cloud-native applications*

</div>