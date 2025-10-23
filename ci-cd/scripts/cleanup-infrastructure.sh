#!/bin/bash

# Multi-Everything DevOps - Infrastructure Cleanup Script
set -e

echo "🧹 Starting Infrastructure Cleanup..."

# Configuration
KUBE_NAMESPACE="multi-everything"
TERRAFORM_DIRS=(
    "terraform/01-network"
    "terraform/02-compute" 
    "terraform/03-data"
    "terraform/04-serverless"
    "terraform/05-monitoring"
    "terraform/06-security"
)

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

# Safety confirmation
confirm_cleanup() {
    log_warn "⚠️  WARNING: This will DESTROY all infrastructure and data!"
    log_warn "This action cannot be undone!"
    echo
    log_warn "The following will be deleted:"
    log_warn "  - Kubernetes cluster and all services"
    log_warn "  - RDS database and all data"
    log_warn "  - Lambda functions"
    log_warn "  - VPC and network resources"
    log_warn "  - Monitoring resources"
    echo
    
    read -p "❓ Are you ABSOLUTELY sure? Type 'DESTROY-PRODUCTION' to confirm: " confirmation
    if [ "$confirmation" != "DESTROY-PRODUCTION" ]; then
        log_info "Cleanup cancelled"
        exit 0
    fi
}

# Clean Kubernetes resources
cleanup_kubernetes() {
    log_info "Cleaning up Kubernetes resources..."
    
    if kubectl get namespace $KUBE_NAMESPACE &> /dev/null; then
        # Delete all resources in namespace
        kubectl delete all --all -n $KUBE_NAMESPACE
        
        # Delete persistent volumes
        kubectl delete pvc --all -n $KUBE_NAMESPACE 2>/dev/null || true
        
        # Delete secrets and configmaps
        kubectl delete secret --all -n $KUBE_NAMESPACE
        kubectl delete configmap --all -n $KUBE_NAMESPACE
        
        # Delete namespace
        kubectl delete namespace $KUBE_NAMESPACE
        
        log_info "Kubernetes resources cleaned up"
    else
        log_info "Kubernetes namespace $KUBE_NAMESPACE not found"
    fi
}

# Clean Terraform resources
cleanup_terraform() {
    log_info "Cleaning up Terraform resources..."
    
    for dir in "${TERRAFORM_DIRS[@]}"; do
        if [ -d "$dir" ]; then
            log_info "Destroying resources in $dir..."
            cd "$dir"
            
            # Initialize if needed
            if [ ! -d ".terraform" ]; then
                terraform init -backend=false
            fi
            
            # Destroy resources (auto-approve for script)
            terraform destroy -auto-approve || log_warn "Terraform destroy failed for $dir"
            
            cd - > /dev/null
        else
            log_warn "Terraform directory $dir not found"
        fi
    done
    
    log_info "Terraform resources cleaned up"
}

# Clean Docker resources
cleanup_docker() {
    log_info "Cleaning up Docker resources..."
    
    # Remove all containers
    docker rm -f $(docker ps -aq) 2>/dev/null || true
    
    # Remove all images
    docker rmi -f $(docker images -aq) 2>/dev/null || true
    
    # Remove volumes and networks
    docker volume prune -f
    docker network prune -f
    
    log_info "Docker resources cleaned up"
}

# Clean temporary files
cleanup_temporary_files() {
    log_info "Cleaning up temporary files..."
    
    # Remove Terraform state files
    find . -name "*.tfstate*" -type f -delete
    find . -name ".terraform" -type d -exec rm -rf {} + 2>/dev/null || true
    find . -name "terraform.tfstate.backup" -type f -delete
    
    # Remove log files
    find . -name "*.log" -type f -delete
    
    log_info "Temporary files cleaned up"
}

# Generate cleanup report
generate_report() {
    log_info "Generating cleanup report..."
    
    REPORT_FILE="cleanup-report-$(date +%Y%m%d-%H%M%S).txt"
    
    cat > $REPORT_FILE << EOF
Multi-Everything DevOps - Cleanup Report
Generated: $(date)

Cleanup Actions Performed:
- Kubernetes namespace and resources deleted
- Terraform infrastructure destroyed
- Docker containers and images removed
- Temporary files cleaned

Remaining Manual Checks:
- Verify AWS console for any remaining resources
- Check CloudWatch log groups
- Verify S3 buckets are empty
- Confirm IAM roles and policies

Note: Some resources may take time to fully delete from AWS.
EOF

    log_info "Cleanup report saved to $REPORT_FILE"
}

# Main cleanup flow
main() {
    log_info "Starting infrastructure cleanup at $(date)"
    
    confirm_cleanup
    cleanup_kubernetes
    cleanup_terraform
    cleanup_docker
    cleanup_temporary_files
    generate_report
    
    log_info "🎉 Infrastructure cleanup completed at $(date)"
    log_info "✅ All resources have been destroyed"
}

# Run main function
main "$@"