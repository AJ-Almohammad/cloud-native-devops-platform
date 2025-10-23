#!/bin/bash

# Multi-Everything DevOps - Staging Deployment Script
set -e

echo "🚀 Starting Staging Deployment..."

# Configuration
REGISTRY="ghcr.io"
IMAGE_PREFIX="multi-everything-devops"
KUBE_NAMESPACE="multi-everything"
TIMESTAMP=$(date +%Y%m%d%H%M%S)

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check prerequisites
check_prerequisites() {
    log_info "Checking prerequisites..."
    
    if ! command -v docker &> /dev/null; then
        log_error "Docker is not installed"
        exit 1
    fi
    
    if ! command -v kubectl &> /dev/null; then
        log_error "kubectl is not installed"
        exit 1
    fi
    
    if ! kubectl cluster-info &> /dev/null; then
        log_error "Cannot connect to Kubernetes cluster"
        exit 1
    fi
    
    log_info "All prerequisites satisfied"
}

# Build and push Docker images
build_and_push_images() {
    log_info "Building and pushing Docker images..."
    
    services=("content-api" "user-service" "analytics-service" "notification-service" "cron-scheduler")
    
    for service in "${services[@]}"; do
        log_info "Building $service..."
        
        # Build image
        docker build -t $REGISTRY/$IMAGE_PREFIX/$service:latest ./services/$service
        docker build -t $REGISTRY/$IMAGE_PREFIX/$service:$TIMESTAMP ./services/$service
        
        # Push images
        docker push $REGISTRY/$IMAGE_PREFIX/$service:latest
        docker push $REGISTRY/$IMAGE_PREFIX/$service:$TIMESTAMP
        
        log_info "$service images pushed successfully"
    done
}

# Deploy to Kubernetes
deploy_kubernetes() {
    log_info "Deploying to Kubernetes..."
    
    # Apply base configurations
    kubectl apply -f kubernetes/namespace.yaml
    kubectl apply -f kubernetes/secrets.yaml
    
    # Wait for namespace to be ready
    kubectl wait --for=condition=Ready namespace/$KUBE_NAMESPACE --timeout=30s
    
    # Deploy applications
    kubectl apply -f kubernetes/applications/
    
    # Deploy monitoring stack
    kubectl apply -f kubernetes/monitoring/
    
    log_info "Kubernetes manifests applied"
}

# Wait for deployments
wait_for_deployments() {
    log_info "Waiting for deployments to be ready..."
    
    deployments=("content-api" "user-service" "analytics-service" "notification-service" "cron-scheduler")
    
    for deployment in "${deployments[@]}"; do
        log_info "Waiting for $deployment..."
        kubectl rollout status deployment/$deployment -n $KUBE_NAMESPACE --timeout=300s
        log_info "$deployment is ready"
    done
}

# Run smoke tests
run_smoke_tests() {
    log_info "Running smoke tests..."
    
    # Get service URLs
    CONTENT_API_URL=$(kubectl get svc content-api-service -n $KUBE_NAMESPACE -o jsonpath='{.spec.clusterIP}')
    USER_SERVICE_URL=$(kubectl get svc user-service -n $KUBE_NAMESPACE -o jsonpath='{.spec.clusterIP}')
    ANALYTICS_SERVICE_URL=$(kubectl get svc analytics-service -n $KUBE_NAMESPACE -o jsonpath='{.spec.clusterIP}')
    
    # Test health endpoints
    services=(
        "$CONTENT_API_URL:80/health"
        "$USER_SERVICE_URL:8000/health" 
        "$ANALYTICS_SERVICE_URL:3000/health"
    )
    
    for service in "${services[@]}"; do
        log_info "Testing $service"
        if kubectl run smoke-test --image=curlimages/curl -n $KUBE_NAMESPACE --rm -i --restart=Never -- curl -f "http://$service"; then
            log_info "✓ $service is healthy"
        else
            log_error "✗ $service health check failed"
            exit 1
        fi
    done
}

# Main deployment flow
main() {
    log_info "Starting staging deployment at $(date)"
    
    check_prerequisites
    build_and_push_images
    deploy_kubernetes
    wait_for_deployments
    run_smoke_tests
    
    log_info "🎉 Staging deployment completed successfully at $(date)"
}

# Run main function
main "$@"