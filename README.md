# 🚀 Cloud Native DevOps Platform

[![Kubernetes](https://img.shields.io/badge/kubernetes-%23326ce5.svg?style=for-the-badge&logo=kubernetes&logoColor=white)](https://kubernetes.io/)
[![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)](https://www.docker.com/)
[![Ansible](https://img.shields.io/badge/ansible-%231A1918.svg?style=for-the-badge&logo=ansible&logoColor=white)](https://www.ansible.com/)
[![Jenkins](https://img.shields.io/badge/jenkins-%232C5263.svg?style=for-the-badge&logo=jenkins&logoColor=white)](https://www.jenkins.io/)
[![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)](https://www.terraform.io/)

> **A comprehensive cloud-native microservices platform with automated deployment, real-time monitoring, and enterprise-grade CI/CD pipelines**

---

## 🌐 Live Demos & Dashboards

### 📊 Local Services Dashboard
**Real-time Microservices Monitoring**  
🔗 **[Open Dashboard](http://localhost:8085)** *(Start server: `node local-server.js`)*

Monitor all 5 microservices with:
- ✅ Real-time health checks
- 📈 Response time tracking
- 🎯 Visual status indicators
- 🔄 Auto-refresh every 30 seconds

### 🎨 Portfolio Dashboard
**Complete Project Overview & Architecture**  
🔗 **[Open Portfolio](http://localhost:8080/portfolio-dashboard.html)** *(Serve: `python3 -m http.server 8080`)*

Features:
- 🏗 Architecture visualization
- 📋 Technology stack showcase
- 🔧 Interactive demonstrations
- 📸 Project screenshots

### 🔧 Advanced Monitoring Dashboard
**Enhanced Monitoring with CORS Proxy**  
🔗 **[Open Monitoring Dashboard](http://localhost:3000/dashboard-with-proxy.html)** *(Start: `node proxy-server.js`)*

Capabilities:
- 🚀 CORS-enabled health checks
- 📊 Advanced metrics display
- 🌐 External access support
- 🔒 Secure communication

---

## 📑 Table of Contents

- [Quick Start](#-quick-start)
- [Architecture Overview](#-architecture-overview)
- [Project Structure](#-project-structure)
- [Documentation](#-documentation)
- [Services](#-services)
- [Technology Stack](#-technology-stack)
- [Deployment](#-deployment)
- [Monitoring](#-monitoring)
- [CI/CD Pipeline](#-cicd-pipeline)
- [Testing](#-testing)
- [Contributing](#-contributing)
- [Support](#-support)

---

## 🚀 Quick Start

### Prerequisites

Ensure you have the following installed:

```bash
# Docker Desktop with Kubernetes enabled
docker --version          # 4.0+
kubectl version --client  # 1.28+

# Node.js for dashboards
node --version           # 16+

# Optional: Ansible for automation
ansible --version        # 2.9+
```

### Installation Steps

#### 1️⃣ Clone Repository

```bash
git clone https://github.com/AJ-Almohammad/cloud-native-devops-platform.git
cd cloud-native-devops-platform
```

#### 2️⃣ Start Dashboard Servers

**Terminal 1 - Local Services Dashboard:**
```bash
node local-server.js
# Access at: http://localhost:8085
```

**Terminal 2 - Proxy Monitoring Dashboard:**
```bash
node proxy-server.js
# Access at: http://localhost:3000/dashboard-with-proxy.html
```

**Terminal 3 - Portfolio Dashboard:**
```bash
python3 -m http.server 8080
# Access at: http://localhost:8080/portfolio-dashboard.html
```

#### 3️⃣ Deploy Microservices to Kubernetes

```bash
# Create namespace and apply secrets
kubectl apply -f kubernetes/namespace.yaml
kubectl apply -f kubernetes/secrets.yaml

# Deploy all microservices
kubectl apply -f kubernetes/applications/ -n multi-everything

# Verify deployment
kubectl get pods -n multi-everything
```

#### 4️⃣ Enable Dashboard Access (Port Forwarding)

Run these commands in **separate terminals** for full dashboard functionality:

```bash
# Terminal 1 - Analytics Service
kubectl port-forward -n multi-everything service/analytics-service 3000:3000

# Terminal 2 - User Service
kubectl port-forward -n multi-everything service/user-service 8000:8000

# Terminal 3 - Notification Service
kubectl port-forward -n multi-everything service/notification-service 8080:8080

# Terminal 4 - Cron Scheduler
kubectl port-forward -n multi-everything service/cron-scheduler 8001:8000
```

#### 5️⃣ Verify Services

```bash
# Check all services are healthy
curl http://localhost:3000/health  # Analytics
curl http://localhost:8000/health  # User Service
curl http://localhost:8080/health  # Notification
curl http://localhost:8001/health  # Cron Scheduler
```

---

## 🏗️ Architecture Overview

### Microservices Ecosystem

```
📦 Cloud Native DevOps Platform
│
├── 📝 Content API          → PHP/Slim Framework    → Port 80
├── 👤 User Service         → Python/FastAPI        → Port 8000
├── 📊 Analytics Service    → Node.js/Express       → Port 3000
├── 🔔 Notification Service → Go/Gin Framework      → Port 8080
└── ⏰ Cron Scheduler        → Python/Celery         → Port 8000
```

### Infrastructure Stack

```
┌─────────────────────────────────────────────────────┐
│            Docker Desktop Kubernetes                 │
├─────────────────────────────────────────────────────┤
│  Namespace: multi-everything                        │
│                                                      │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐         │
│  │ Content  │  │   User   │  │Analytics │         │
│  │   API    │  │ Service  │  │ Service  │         │
│  └──────────┘  └──────────┘  └──────────┘         │
│                                                      │
│  ┌──────────┐  ┌──────────┐                        │
│  │  Notify  │  │   Cron   │                        │
│  │ Service  │  │Scheduler │                        │
│  └──────────┘  └──────────┘                        │
└─────────────────────────────────────────────────────┘
```

---

## 📁 Project Structure

### Root Directory Overview

```
cloud-native-devops-platform/
│
├── 📄 README.md                          ← You are here
├── 📄 local-dashboard.html               ← Main monitoring dashboard
├── 📄 portfolio-dashboard.html           ← Portfolio showcase
├── 📄 local-server.js                    ← Dashboard backend
├── 📄 proxy-server.js                    ← CORS proxy server
│
├── 📂 docs/                              ← Documentation
│   ├── ARCHITECTURE.md                   ← System architecture
│   └── SETUP.md                          ← Setup guide
│
├── 📂 services/                          ← Microservices source code
│   ├── content-api/                      ← PHP content service
│   ├── user-service/                     ← Python user service
│   ├── analytics-service/                ← Node.js analytics
│   ├── notification-service/             ← Go notification service
│   └── cron-scheduler/                   ← Python scheduler
│
├── 📂 kubernetes/                        ← K8s configurations
│   ├── namespace.yaml                    ← Namespace definition
│   ├── secrets.yaml                      ← Secrets configuration
│   ├── applications/                     ← Service deployments
│   ├── monitoring/                       ← Monitoring stack
│   └── local-test/                       ← Local testing configs
│
├── 📂 ansible/                           ← Automation playbooks
│   ├── inventory/                        ← Inventory files
│   │   ├── hosts.ini                     ← Remote hosts
│   │   └── hosts.local.ini               ← Local hosts
│   ├── playbooks/                        ← Ansible playbooks
│   └── roles/                            ← Ansible roles
│
├── 📂 ci-cd/                             ← CI/CD pipelines
│   ├── .github/workflows/                ← GitHub Actions
│   │   └── main-pipeline.yml             ← Main pipeline
│   ├── jenkins/                          ← Jenkins configuration
│   │   └── Jenkinsfile                   ← Pipeline definition
│   └── scripts/                          ← Deployment scripts
│       ├── deploy-staging.sh
│       ├── deploy-production.sh
│       └── cleanup-infrastructure.sh
│
├── 📂 terraform/                         ← Infrastructure as Code
│   ├── 00-backend/                       ← Backend state
│   ├── 01-network/                       ← VPC & networking
│   ├── 02-compute/                       ← EKS cluster
│   ├── 03-data/                          ← RDS database
│   ├── 04-serverless/                    ← Lambda functions
│   ├── 05-monitoring/                    ← CloudWatch
│   ├── 06-security/                      ← Security configs
│   ├── deploy-all.sh                     ← Deploy script
│   └── destroy-all.sh                    ← Cleanup script
│
├── 📂 lambdas/                           ← Serverless functions
│   ├── ai-moderation/                    ← AI content moderation
│   ├── cost-calculator/                  ← Cost calculation
│   ├── event-router/                     ← Event routing
│   └── image-processor/                  ← Image processing
│
├── 📂 monitoring/                        ← Enhanced monitoring
│   ├── dashboard-with-proxy.html         ← Proxy dashboard
│   ├── proxy-server.js                   ← Proxy server
│   └── microservices-demo.mp4            ← Demo video
│
├── 📂 miscellaneous/                     ← Additional configs
│   ├── docker-test-deployment.yaml       ← Docker test config
│   └── jenkins-deployment.yaml           ← Jenkins K8s config
│
├── 📂 scripts/                           ← Utility scripts
│   ├── setup/                            ← Setup scripts
│   ├── deployment/                       ← Deployment automation
│   └── utilities/                        ← Helper scripts
│
└── 📂 tests/                             ← Test suites
    ├── integration/                      ← Integration tests
    ├── load/                             ← Load testing
    └── security/                         ← Security tests
```

---

## 📚 Documentation

### Core Documentation Files

| Document | Description | Location |
|----------|-------------|----------|
| **📖 Setup Guide** | Complete installation and setup instructions | [docs/SETUP.md](./docs/SETUP.md) |
| **🏗️ Architecture** | System architecture and design decisions | [docs/ARCHITECTURE.md](./docs/ARCHITECTURE.md) |
| **📝 README** | This file - project overview and quick start | [README.md](./README.md) |

### Dashboard Files

| Dashboard | Purpose | File Location |
|-----------|---------|---------------|
| **Local Services** | Real-time service monitoring | [local-dashboard.html](./local-dashboard.html) |
| **Portfolio** | Project showcase and documentation | [portfolio-dashboard.html](./portfolio-dashboard.html) |
| **Proxy Monitor** | Advanced monitoring with CORS | [monitoring/dashboard-with-proxy.html](./monitoring/dashboard-with-proxy.html) |

### Configuration Files

| File | Purpose | Location |
|------|---------|----------|
| **Namespace** | Kubernetes namespace definition | [kubernetes/namespace.yaml](./kubernetes/namespace.yaml) |
| **Secrets** | Database credentials and secrets | [kubernetes/secrets.yaml](./kubernetes/secrets.yaml) |
| **Jenkinsfile** | CI/CD pipeline definition | [ci-cd/jenkins/Jenkinsfile](./ci-cd/jenkins/Jenkinsfile) |
| **GitHub Actions** | Automated workflows | [ci-cd/.github/workflows/main-pipeline.yml](./ci-cd/.github/workflows/main-pipeline.yml) |

---

## 🎯 Services

### Service Details

| Service | Technology | Port | Health Check | Source Code |
|---------|------------|------|--------------|-------------|
| **Content API** | PHP/Slim | 80 | `/health` | [services/content-api/](./services/content-api/) |
| **User Service** | Python/FastAPI | 8000 | `/health` | [services/user-service/](./services/user-service/) |
| **Analytics** | Node.js/Express | 3000 | `/health` | [services/analytics-service/](./services/analytics-service/) |
| **Notification** | Go/Gin | 8080 | `/health` | [services/notification-service/](./services/notification-service/) |
| **Cron Scheduler** | Python/Celery | 8000 | `/health` | [services/cron-scheduler/](./services/cron-scheduler/) |

### Kubernetes Deployments

All service deployments are located in: [kubernetes/applications/](./kubernetes/applications/)

- [analytics-service-deployment.yaml](./kubernetes/applications/analytics-service-deployment.yaml)
- [user-service-deployment.yaml](./kubernetes/applications/user-service-deployment.yaml)
- [notification-service-deployment.yaml](./kubernetes/applications/notification-service-deployment.yaml)
- [cron-scheduler-deployment.yaml](./kubernetes/applications/cron-scheduler-deployment.yaml)
- [content-api-deployment.yaml](./kubernetes/applications/content-api-deployment.yaml)

---

## 🔧 Technology Stack

### Infrastructure & Orchestration

| Layer | Technologies | Purpose |
|-------|-------------|---------|
| **Containerization** | Docker, Docker Compose | Application packaging |
| **Orchestration** | Kubernetes (Docker Desktop) | Container management |
| **Infrastructure as Code** | Terraform (Multi-module) | Cloud infrastructure |
| **Configuration Management** | Ansible | Automation & deployment |

### CI/CD & Automation

| Tool | Purpose | Configuration |
|------|---------|---------------|
| **Jenkins** | Continuous Integration/Deployment | [jenkins-deployment.yaml](./miscellaneous/jenkins-deployment.yaml) |
| **GitHub Actions** | Automated workflows | [.github/workflows/](./ci-cd/.github/workflows/) |
| **Ansible** | Configuration automation | [ansible/playbooks/](./ansible/playbooks/) |
| **Bash Scripts** | Deployment automation | [ci-cd/scripts/](./ci-cd/scripts/) |

### Monitoring & Observability

| Component | Technology | Purpose |
|-----------|------------|---------|
| **Enhanced Dashboard** | HTML/CSS/JavaScript | Real-time monitoring |
| **CORS Proxy** | Node.js/Express | Dashboard integration |
| **Health Checks** | HTTP endpoints | Service availability |
| **Metrics** | Custom JavaScript | Performance tracking |

### Backend Services

| Service | Language | Framework | Database |
|---------|----------|-----------|----------|
| **Content API** | PHP 8.1+ | Slim Framework 4.x | PostgreSQL |
| **User Service** | Python 3.10+ | FastAPI 0.100+ | PostgreSQL |
| **Analytics** | Node.js 18+ | Express 4.x | PostgreSQL |
| **Notification** | Go 1.20+ | Gin 1.9+ | PostgreSQL |
| **Cron Scheduler** | Python 3.10+ | Celery 5.3+ | PostgreSQL |

### Serverless Functions

Located in: [lambdas/](./lambdas/)

- **AI Moderation**: [ai-moderation/lambda_function.py](./lambdas/ai-moderation/lambda_function.py)
- **Cost Calculator**: [cost-calculator/lambda_function.py](./lambdas/cost-calculator/lambda_function.py)
- **Event Router**: [event-router/lambda_function.py](./lambdas/event-router/lambda_function.py)
- **Image Processor**: [image-processor/lambda_function.py](./lambdas/image-processor/lambda_function.py)

---

## 🚀 Deployment

### Option 1: Quick Deploy (Recommended)

```bash
# Deploy everything at once
kubectl apply -f kubernetes/namespace.yaml
kubectl apply -f kubernetes/secrets.yaml
kubectl apply -f kubernetes/applications/ -n multi-everything
```

### Option 2: Ansible Automation

```bash
cd ansible

# Test local connection
ansible-playbook -i inventory/hosts.local.ini playbooks/test-local-macos.yml

# Deploy services
ansible-playbook -i inventory/hosts.local.ini playbooks/deploy-content-api-fixed.yml
ansible-playbook -i inventory/hosts.local.ini playbooks/deploy-test-service.yml
```

**Ansible Configuration Files:**
- Inventory: [ansible/inventory/hosts.local.ini](./ansible/inventory/hosts.local.ini)
- Playbooks: [ansible/playbooks/](./ansible/playbooks/)

### Option 3: Terraform (Cloud Infrastructure)

```bash
cd terraform

# Initialize and deploy all modules
./deploy-all.sh

# Verify deployment
./verify-deploy.sh

# Cleanup when done
./destroy-all.sh
```

**Terraform Modules:**
- Backend: [00-backend/](./terraform/00-backend/)
- Network: [01-network/](./terraform/01-network/)
- Compute: [02-compute/](./terraform/02-compute/)
- Database: [03-data/](./terraform/03-data/)
- Serverless: [04-serverless/](./terraform/04-serverless/)
- Monitoring: [05-monitoring/](./terraform/05-monitoring/)
- Security: [06-security/](./terraform/06-security/)

### Option 4: CI/CD Scripts

```bash
cd ci-cd/scripts

# Deploy to staging
./deploy-staging.sh

# Deploy to production
./deploy-production.sh

# Cleanup infrastructure
./cleanup-infrastructure.sh
```

---

## 📊 Monitoring

### Dashboard Overview

#### 1. Local Services Dashboard
**Location**: [local-dashboard.html](./local-dashboard.html)  
**Server**: [local-server.js](./local-server.js)  
**Access**: http://localhost:8085

**Features**:
- ✅ Real-time health monitoring of all 5 services
- 📈 Response time tracking and performance metrics
- 🎯 Service status with visual indicators
- 🔄 Auto-refresh every 30 seconds
- 🛠 Built-in service testing capabilities

#### 2. Portfolio Dashboard
**Location**: [portfolio-dashboard.html](./portfolio-dashboard.html)  
**Access**: http://localhost:8080/portfolio-dashboard.html

**Features**:
- 🏗 Complete architecture visualization
- 📋 Feature breakdown and technology stack
- 🔧 Installation and setup instructions
- 📸 Interactive service demonstrations
- 🎯 Professional project showcase

#### 3. Proxy Monitoring Dashboard
**Location**: [monitoring/dashboard-with-proxy.html](./monitoring/dashboard-with-proxy.html)  
**Server**: [proxy-server.js](./proxy-server.js) or [monitoring/proxy-server.js](./monitoring/proxy-server.js)  
**Access**: http://localhost:3000/dashboard-with-proxy.html

**Features**:
- 🔄 CORS-enabled health checks
- 🚀 Proxy server integration
- 📊 Advanced monitoring capabilities
- 🌐 External access support
- 🔒 Secure service communication

### Kubernetes Monitoring

Additional monitoring configurations available in: [kubernetes/monitoring/](./kubernetes/monitoring/)

- Prometheus: [prometheus-deployment.yaml](./kubernetes/monitoring/prometheus-deployment.yaml)
- Grafana: [grafana-deployment.yaml](./kubernetes/monitoring/grafana-deployment.yaml)
- Loki: [loki-deployment.yaml](./kubernetes/monitoring/loki-deployment.yaml)

---

## 🔄 CI/CD Pipeline

### Jenkins Pipeline

**Configuration**: [miscellaneous/jenkins-deployment.yaml](./miscellaneous/jenkins-deployment.yaml)  
**Pipeline Definition**: [ci-cd/jenkins/Jenkinsfile](./ci-cd/jenkins/Jenkinsfile)  
**Access**: http://localhost:30080

#### Deploy Jenkins to Kubernetes

```bash
# Deploy Jenkins
kubectl apply -f miscellaneous/jenkins-deployment.yaml -n multi-everything

# Check status
kubectl get pods -n multi-everything -l app=jenkins

# Get admin password
kubectl logs -n multi-everything -l app=jenkins | grep "password"
```

### GitHub Actions

**Workflow**: [ci-cd/.github/workflows/main-pipeline.yml](./ci-cd/.github/workflows/main-pipeline.yml)

**Pipeline Stages**:
1. Code checkout
2. Build and test
3. Security scanning
4. Docker image build
5. Deploy to staging
6. Integration tests
7. Deploy to production

### Deployment Scripts

Located in: [ci-cd/scripts/](./ci-cd/scripts/)

- **Staging**: [deploy-staging.sh](./ci-cd/scripts/deploy-staging.sh)
- **Production**: [deploy-production.sh](./ci-cd/scripts/deploy-production.sh)
- **Cleanup**: [cleanup-infrastructure.sh](./ci-cd/scripts/cleanup-infrastructure.sh)

---

## 🧪 Testing

### Test Suites

All tests are located in: [tests/](./tests/)

#### Integration Tests
**Location**: [tests/integration/test-microservices.sh](./tests/integration/test-microservices.sh)

```bash
cd tests/integration
./test-microservices.sh
```

#### Load Testing
**Location**: [tests/load/test-load.sh](./tests/load/test-load.sh)

```bash
cd tests/load
./test-load.sh
```

#### Security Testing
**Location**: [tests/security/test-security.sh](./tests/security/test-security.sh)

```bash
cd tests/security
./test-security.sh
```

---

## 🎯 Key Features

### ✅ Complete DevOps Pipeline
- Infrastructure as Code with Terraform
- Containerized microservices with Docker
- Kubernetes orchestration on Docker Desktop
- CI/CD automation with Jenkins & GitHub Actions
- Enhanced custom monitoring dashboards

### ✅ Production Ready Architecture
- 5 Independent microservices
- Local Kubernetes deployment
- Health monitoring and auto-healing
- Service discovery and load balancing
- Comprehensive logging and observability

### ✅ Enterprise Grade
- Security best practices implementation
- Automated deployment pipelines
- Comprehensive testing suite
- Documentation and runbooks
- Multi-environment support

---

## 🤝 Contributing

We welcome contributions! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 🚨 Important Notes

### ⚠️ Required for Dashboard Functionality

**Port Forwarding**: All microservices require active port-forwarding to be accessible by the dashboards. Without port-forwarding, the dashboards won't be able to connect to the services.

**Local Development**: This platform is optimized for Docker Desktop Kubernetes and local development. For cloud deployment, refer to the Terraform configurations.

**Enhanced Monitoring**: Custom dashboards replace traditional monitoring stacks (Prometheus/Grafana) for simplified setup and better demonstration purposes.

### 🔧 Server Requirements

| Dashboard | Server File | Command | Port |
|-----------|------------|---------|------|
| Local Services | [local-server.js](./local-server.js) | `node local-server.js` | 8085 |
| Proxy Monitor | [proxy-server.js](./proxy-server.js) | `node proxy-server.js` | 3000 |
| Portfolio | Python HTTP Server | `python3 -m http.server 8080` | 8080 |

---

## 📞 Support & Contact

### Documentation & Help

- 📖 **Setup Guide**: [docs/SETUP.md](./docs/SETUP.md)
- 🏗️ **Architecture**: [docs/ARCHITECTURE.md](./docs/ARCHITECTURE.md)
- 🎨 **Dashboards**: Interactive project documentation
- 🐛 **Issues**: [GitHub Issues](https://github.com/AJ-Almohammad/cloud-native-devops-platform/issues)

### Contact Information

**Maintainer**: Amer Almohammad  
**Role**: AWS Junior Cloud Engineer  
**Email**: ajaber1973@web.de  
**GitHub**: [@AJ-Almohammad](https://github.com/AJ-Almohammad)

---

## 📄 License

This project is open source and available under the MIT License.

---

## 🎬 Demo Video

Watch the platform in action: [microservices-demo.mp4](./monitoring/microservices-demo.mp4)

---

<div align="center">

### 🚀 Happy DevOps-ing!

**Your complete cloud-native DevOps platform is ready to run!**

---

[![Stars](https://img.shields.io/github/stars/AJ-Almohammad/cloud-native-devops-platform?style=social)](https://github.com/AJ-Almohammad/cloud-native-devops-platform)
[![Forks](https://img.shields.io/github/forks/AJ-Almohammad/cloud-native-devops-platform?style=social)](https://github.com/AJ-Almohammad/cloud-native-devops-platform)
[![Follow](https://img.shields.io/github/followers/AJ-Almohammad?style=social)](https://github.com/AJ-Almohammad)

**Made with ❤️ by Amer Almohammad**

*Last Updated: October 2024*

</div>