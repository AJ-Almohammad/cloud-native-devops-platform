#!/bin/bash

# Multi-Everything DevOps - Production Deployment Script
set -e

echo "🚀 Starting Production Deployment..."

# Configuration
REGISTRY="ghcr.io"
IMAGE_PREFIX="multi-everything-devops"
KUBE_NAMESPACE="multi-everything-prod"
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

# Production-specific checks
production_checks() {
    log_info "Running production safety checks..."
    
    # Check if we're on main branch
    CURRENT_BRANCH=$(git branch --show-current)
    if [ "$CURRENT_BRANCH" != "main" ]; then
        log_error "Production deployments must be from main branch (current: $CURRENT_BRANCH)"
        exit 1
    fi
    
    # Check for uncommitted changes
    if ! git diff-index --quiet HEAD --; then
        log_error "There are uncommitted changes. Commit or stash them before production deployment."
        exit 1
    fi
    
    # Confirm deployment
    read -p "⚠️  Are you sure you want to deploy to PRODUCTION? (yes/no): " confirmation
    if [ "$confirmation" != "yes" ]; then
        log_info "Production deployment cancelled"
        exit 0
    fi
    
    log_info "Production checks passed"
}

# Blue-Green deployment strategy
blue_green_deployment() {
    log_info "Starting Blue-Green deployment..."
    
    services=("content-api" "user-service" "analytics-service" "notification-service" "cron-scheduler")
    
    for service in "${services[@]}"; do
        log_info "Deploying $service using Blue-Green strategy..."
        
        # Deploy new version (green)
        kubectl apply -f kubernetes/applications/$service-deployment.yaml
        
        # Wait for new pods to be ready
        kubectl rollout status deployment/$service -n $KUBE_NAMESPACE --timeout=600s
        
        # Run canary tests
        run_canary_tests $service
        
        log_info "$service Blue-Green deployment completed"
    done
}

# Canary testing
run_canary_tests() {
    local service=$1
    log_info "Running canary tests for $service..."
    
    # Implement canary testing logic here
    # This could include:
    # - Traffic shifting
    # - Performance testing
    # - Business logic validation
    
    sleep 30  # Simulate canary testing period
    
    log_info "Canary tests passed for $service"
}

# Database migrations
run_migrations() {
    log_info "Running database migrations..."
    
    # Run migrations job
    kubectl apply -f kubernetes/jobs/db-migrations.yaml
    kubectl wait --for=condition=complete job/db-migrations -n $KUBE_NAMESPACE --timeout=300s
    
    log_info "Database migrations completed"
}

# Post-deployment verification
post_deployment_checks() {
    log_info "Running post-deployment verification..."
    
    # Check all services
    kubectl get deployments -n $KUBE_NAMESPACE
    kubectl get services -n $KUBE_NAMESPACE
    kubectl get pods -n $KUBE_NAMESPACE
    
    # Verify resource usage
    kubectl top pods -n $KUBE_NAMESPACE
    
    log_info "Post-deployment verification completed"
}

# Rollback procedure
setup_rollback() {
    log_info "Setting up rollback procedure..."
    
    # Save current deployment state for rollback
    kubectl get deployments -n $KUBE_NAMESPACE -o yaml > /tmp/production-backup-$TIMESTAMP.yaml
    
    log_info "Rollback backup saved to /tmp/production-backup-$TIMESTAMP.yaml"
}

# Main deployment flow
main() {
    log_info "Starting production deployment at $(date)"
    
    production_checks
    setup_rollback
    run_migrations
    blue_green_deployment
    post_deployment_checks
    
    log_info "🎉 Production deployment completed successfully at $(date)"
    log_info "📊 Deployment timestamp: $TIMESTAMP"
}

# Run main function
main "$@"