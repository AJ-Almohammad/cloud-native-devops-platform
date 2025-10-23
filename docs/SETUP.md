# Cloud Native DevOps Platform

[![Kubernetes](https://img.shields.io/badge/kubernetes-%23326ce5.svg?style=for-the-badge&logo=kubernetes&logoColor=white)](https://kubernetes.io/)
[![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)](https://www.docker.com/)
[![Ansible](https://img.shields.io/badge/ansible-%231A1918.svg?style=for-the-badge&logo=ansible&logoColor=white)](https://www.ansible.com/)
[![Jenkins](https://img.shields.io/badge/jenkins-%232C5263.svg?style=for-the-badge&logo=jenkins&logoColor=white)](https://www.jenkins.io/)

> **A comprehensive cloud-native microservices platform with automated deployment, monitoring, and CI/CD capabilities**

## 📋 Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Deployment Options](#deployment-options)
- [Services](#services)
- [Monitoring & Dashboards](#monitoring--dashboards)
- [CI/CD Pipeline](#cicd-pipeline)
- [Verification & Testing](#verification--testing)
- [Troubleshooting](#troubleshooting)
- [Maintenance](#maintenance)
- [Contributing](#contributing)
- [Support](#support)
- [License](#license)

---

## 🎯 Overview

The Cloud Native DevOps Platform is a production-ready microservices architecture deployed on Kubernetes. It features five independent microservices, automated deployment pipelines, comprehensive monitoring solutions, and infrastructure-as-code practices.

### Key Features

- ✅ **5 Microservices Architecture** - Scalable, containerized services
- ✅ **Kubernetes Orchestration** - Local and cloud-ready deployment
- ✅ **Automated CI/CD** - Jenkins pipelines with GitOps workflows
- ✅ **Configuration Management** - Ansible playbooks for automation
- ✅ **Real-time Monitoring** - Multiple dashboard solutions
- ✅ **Infrastructure as Code** - Declarative configuration management

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Kubernetes Cluster                        │
│  ┌──────────────────────────────────────────────────────┐  │
│  │              Namespace: multi-everything              │  │
│  │                                                        │  │
│  │  ┌──────────────┐  ┌──────────────┐  ┌────────────┐ │  │
│  │  │ Content API  │  │ User Service │  │ Analytics  │ │  │
│  │  └──────────────┘  └──────────────┘  └────────────┘ │  │
│  │                                                        │  │
│  │  ┌──────────────┐  ┌──────────────┐                 │  │
│  │  │Notification  │  │Cron Scheduler│                 │  │
│  │  └──────────────┘  └──────────────┘                 │  │
│  └──────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

### Services Breakdown

| Service | Port | Description | Technology |
|---------|------|-------------|------------|
| **Content API** | 8080 | Content management service | Node.js/Express |
| **User Service** | 8000 | User authentication & management | Python/FastAPI |
| **Analytics Service** | 3000 | Data analytics & reporting | Node.js/Express |
| **Notification Service** | 8080 | Event-driven notifications | Java/Spring Boot |
| **Cron Scheduler** | 8000 | Scheduled job execution | Python |

---

## 📋 Prerequisites

### System Requirements

| Requirement | Minimum | Recommended |
|------------|---------|-------------|
| **OS** | macOS, Linux, Windows WSL2 | macOS/Linux |
| **RAM** | 8GB | 16GB |
| **Storage** | 20GB | 50GB |
| **CPU** | 4 cores | 8 cores |

### Required Software

Ensure the following tools are installed on your system:

```bash
# Docker Desktop (includes Kubernetes)
docker --version  # Should be 4.0+

# Kubernetes CLI
kubectl version --client  # Should be 1.28+

# Helm Package Manager
helm version  # Should be 3.0+

# Ansible Automation
ansible --version  # Should be 2.9+

# Node.js (for dashboards)
node --version  # Should be 16+
```

### Installation Links

- **Docker Desktop**: [https://www.docker.com/products/docker-desktop/](https://www.docker.com/products/docker-desktop/)
- **kubectl**: [https://kubernetes.io/docs/tasks/tools/](https://kubernetes.io/docs/tasks/tools/)
- **Helm**: [https://helm.sh/docs/intro/install/](https://helm.sh/docs/intro/install/)
- **Ansible**: [https://docs.ansible.com/ansible/latest/installation_guide/](https://docs.ansible.com/ansible/latest/installation_guide/)

---

## 🚀 Installation

### Step 1: Clone Repository

```bash
git clone https://github.com/AJ-Almohammad/cloud-native-devops-platform.git
cd cloud-native-devops-platform
```

### Step 2: Enable Kubernetes in Docker Desktop

1. Open **Docker Desktop**
2. Navigate to **Settings → Kubernetes**
3. Check **"Enable Kubernetes"**
4. Click **"Apply & Restart"**

### Step 3: Verify Kubernetes Installation

```bash
# Check cluster information
kubectl cluster-info

# Verify node status
kubectl get nodes

# Expected output:
# NAME             STATUS   ROLES           AGE   VERSION
# docker-desktop   Ready    control-plane   1d    v1.28.x
```

---

## 🎮 Deployment Options

### Option 1: Quick Deploy (Recommended)

Deploy all services with a single command:

```bash
# Create namespace and apply secrets
kubectl apply -f kubernetes/namespace.yaml
kubectl apply -f kubernetes/secrets.yaml

# Deploy all microservices
kubectl apply -f kubernetes/applications/ -n multi-everything

# Monitor deployment
kubectl get pods -n multi-everything -w
```

### Option 2: Ansible Automation

Use Ansible playbooks for controlled deployment:

```bash
cd ansible

# Test local connection
ansible-playbook -i inventory/hosts.local.ini \
  playbooks/test-local-macos.yml

# Deploy Content API
ansible-playbook -i inventory/hosts.local.ini \
  playbooks/deploy-content-api-fixed.yml

# Deploy Test Service
ansible-playbook -i inventory/hosts.local.ini \
  playbooks/deploy-test-service.yml
```

### Option 3: Manual Deployment

Deploy services individually for granular control:

```bash
# Create namespace
kubectl apply -f kubernetes/namespace.yaml

# Apply secrets
kubectl apply -f kubernetes/secrets.yaml

# Deploy individual services
kubectl apply -f kubernetes/applications/content-api.yaml -n multi-everything
kubectl apply -f kubernetes/applications/user-service.yaml -n multi-everything
kubectl apply -f kubernetes/applications/analytics-service.yaml -n multi-everything
kubectl apply -f kubernetes/applications/notification-service.yaml -n multi-everything
kubectl apply -f kubernetes/applications/cron-scheduler.yaml -n multi-everything
```

---

## 🔍 Services

### Verify Deployment Status

```bash
# Check all deployments
kubectl get deployments -n multi-everything

# Check all services
kubectl get services -n multi-everything

# Check pod status and logs
kubectl get pods -n multi-everything
kubectl logs -n multi-everything <pod-name>
```

### Service Health Checks

Test each service endpoint using port-forwarding:

```bash
# Analytics Service
kubectl port-forward -n multi-everything service/analytics-service 3000:3000 &
curl http://localhost:3000/health

# User Service
kubectl port-forward -n multi-everything service/user-service 8000:8000 &
curl http://localhost:8000/health

# Notification Service
kubectl port-forward -n multi-everything service/notification-service 8080:8080 &
curl http://localhost:8080/health

# Cron Scheduler
kubectl port-forward -n multi-everything service/cron-scheduler 8001:8000 &
curl http://localhost:8001/health
```

---

## 📊 Monitoring & Dashboards

### Dashboard 1: Portfolio Dashboard

```bash
# Open directly in browser
open portfolio-dashboard.html

# Or serve via Python
python3 -m http.server 8080
# Access at: http://localhost:8080/portfolio-dashboard.html
```

### Dashboard 2: Local Services Dashboard

```bash
# Start the local dashboard server
node local-server.js

# Access at: http://localhost:8085
```

### Dashboard 3: Monitoring Dashboard with Proxy

```bash
cd monitoring

# Install dependencies (first time only)
npm install express cors http-proxy-middleware

# Start proxy server
node proxy-server.js

# Access at: http://localhost:3000/dashboard-with-proxy.html
```

---

## 🔄 CI/CD Pipeline

### Jenkins Setup

#### Deploy Jenkins to Kubernetes

```bash
# Deploy Jenkins
kubectl apply -f jenkins-deployment.yaml -n multi-everything

# Verify Jenkins is running
kubectl get pods -n multi-everything -l app=jenkins

# Access Jenkins
open http://localhost:30080
```

#### Initial Jenkins Configuration

1. **Retrieve Admin Password**:
   ```bash
   kubectl logs -n multi-everything -l app=jenkins | grep "password"
   ```

2. **Access Jenkins UI**: Navigate to `http://localhost:30080`

3. **Install Plugins**: Select suggested plugins

4. **Create Admin User**: Follow the setup wizard

5. **Configure Pipeline**:
   - **SCM**: Git repository
   - **Script Path**: `ci-cd/jenkins/Jenkinsfile`

### Pipeline Stages

The Jenkins pipeline includes:

1. **Build** - Compile and package services
2. **Test** - Run unit and integration tests
3. **Security Scan** - Vulnerability assessment
4. **Docker Build** - Create container images
5. **Deploy Staging** - Deploy to staging environment
6. **Integration Tests** - End-to-end testing
7. **Deploy Production** - Production deployment

### Manual Deployment Scripts

```bash
# Deploy to staging
bash ci-cd/scripts/deploy-staging.sh

# Deploy to production
bash ci-cd/scripts/deploy-production.sh
```

---

## ✅ Verification & Testing

### Complete System Verification

```bash
# 1. Check namespace
kubectl get namespaces | grep multi-everything

# 2. Check all pods
kubectl get pods -n multi-everything

# 3. Check all services
kubectl get services -n multi-everything

# 4. Check deployments
kubectl get deployments -n multi-everything

# 5. Verify resource usage
kubectl top pods -n multi-everything
```

### Dashboard Verification Checklist

- [ ] Portfolio Dashboard accessible
- [ ] Local Services Dashboard accessible
- [ ] Monitoring Dashboard accessible
- [ ] All service health endpoints responding
- [ ] Jenkins accessible and configured

---

## 🐛 Troubleshooting

### Common Issues

#### Issue 1: Pods Not Starting

```bash
# Describe pod to see events
kubectl describe pod <pod-name> -n multi-everything

# Check pod logs
kubectl logs <pod-name> -n multi-everything

# Restart deployment
kubectl rollout restart deployment/<deployment-name> -n multi-everything
```

#### Issue 2: Service Connection Failures

```bash
# Verify service exists
kubectl get service -n multi-everything

# Check endpoints
kubectl get endpoints -n multi-everything

# Test connectivity
kubectl port-forward service/<service-name> <local-port>:<service-port> -n multi-everything
```

#### Issue 3: Jenkins Access Problems

```bash
# Check Jenkins pod status
kubectl get pods -n multi-everything -l app=jenkins

# View Jenkins logs
kubectl logs -n multi-everything -l app=jenkins

# Restart Jenkins
kubectl rollout restart deployment/jenkins -n multi-everything
```

#### Issue 4: Dashboard CORS Issues

```bash
# Verify proxy server is running
ps aux | grep node

# Restart proxy server
pkill -f "node proxy-server.js"
cd monitoring && node proxy-server.js
```

---

## 🔧 Maintenance

### Regular Maintenance Tasks

```bash
# Update all deployments
kubectl rollout restart deployment -n multi-everything

# Check resource usage
kubectl top pods -n multi-everything
kubectl top nodes

# Scale services
kubectl scale deployment/<service-name> --replicas=3 -n multi-everything

# Update secrets
kubectl apply -f kubernetes/secrets.yaml -n multi-everything
```

### Backup & Recovery

```bash
# Backup Kubernetes resources
kubectl get all -n multi-everything -o yaml > backup.yaml

# Export secrets (encrypted)
kubectl get secrets -n multi-everything -o yaml > secrets-backup.yaml

# Restore from backup
kubectl apply -f backup.yaml
```

---

## 🗂️ Project Structure

```
cloud-native-devops-platform/
├── kubernetes/              # Kubernetes manifests
│   ├── namespace.yaml
│   ├── secrets.yaml
│   └── applications/
├── services/                # Microservice source code
│   ├── content-api/
│   ├── user-service/
│   ├── analytics-service/
│   ├── notification-service/
│   └── cron-scheduler/
├── ansible/                 # Ansible automation
│   ├── inventory/
│   └── playbooks/
├── ci-cd/                   # CI/CD pipelines
│   ├── jenkins/
│   └── scripts/
├── monitoring/              # Dashboards & monitoring
│   ├── dashboard-with-proxy.html
│   └── proxy-server.js
├── terraform/               # Infrastructure as Code
├── tests/                   # Test suites
├── docs/                    # Documentation
└── README.md               # This file
```

---

## 🤝 Contributing

We welcome contributions! Please follow these steps:

1. **Fork** the repository
2. **Create** a feature branch (`git checkout -b feature/AmazingFeature`)
3. **Commit** your changes (`git commit -m 'Add AmazingFeature'`)
4. **Push** to the branch (`git push origin feature/AmazingFeature`)
5. **Open** a Pull Request

### Coding Standards

- Follow language-specific style guides
- Write meaningful commit messages
- Include tests for new features
- Update documentation as needed

---

## 📞 Support

### Getting Help

- **Documentation**: Check the `/docs` directory for detailed guides
- **Issues**: [GitHub Issues](https://github.com/AJ-Almohammad/cloud-native-devops-platform/issues)
- **Email**: ajaber1973@web.de
- **GitHub**: [@AJ-Almohammad](https://github.com/AJ-Almohammad)

### Useful Resources

- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [Docker Documentation](https://docs.docker.com/)
- [Ansible Documentation](https://docs.ansible.com/)
- [Jenkins Documentation](https://www.jenkins.io/doc/)

---

## 🔐 Security

### Security Best Practices

- ⚠️ **Never commit secrets** to version control
- 🔒 **Use Kubernetes Secrets** for sensitive data
- 🔑 **Rotate credentials** regularly
- 🛡️ **Keep dependencies updated**
- 🔍 **Regular security scans** in CI/CD pipeline

### Reporting Security Issues

Please report security vulnerabilities via email to: ajaber1973@web.de

---

## 📝 Changelog

### Version 2.0 (Current)

- ✅ 5 Microservices deployed on Kubernetes
- ✅ Ansible automation for deployment
- ✅ Jenkins CI/CD pipeline integration
- ✅ Multiple monitoring dashboards
- ✅ Comprehensive documentation
- ✅ Infrastructure as Code support

### Version 1.0

- Initial microservices deployment
- Basic Kubernetes setup
- Portfolio dashboard implementation

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👤 Author

**Amer Almohammad**  
*AWS Junior Cloud Engineer*

- GitHub: [@AJ-Almohammad](https://github.com/AJ-Almohammad)
- Email: ajaber1973@web.de
- LinkedIn: [Connect with me](https://linkedin.com/in/amer-almohammad)

---

<div align="center">

**⭐ Star this repository if you find it helpful!**

Made with ❤️ by Amer Almohammad

*Last Updated: October 2024*

</div>