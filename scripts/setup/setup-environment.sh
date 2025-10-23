#!/bin/bash

# Multi-everything DevOps - Environment Setup Script
set -e

echo "🚀 Setting up Multi-everything DevOps environment..."

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Check and install prerequisites
check_prerequisites() {
    log_info "Checking prerequisites..."
    
    local missing_tools=()
    
    # Check for required tools
    for tool in terraform docker kubectl aws python3 node go; do
        if ! command -v $tool &> /dev/null; then
            missing_tools+=("$tool")
        fi
    done
    
    if [ ${#missing_tools[@]} -ne 0 ]; then
        log_warn "Missing tools: ${missing_tools[*]}"
        log_info "Please install missing tools before continuing"
        return 1
    else
        log_info "All prerequisites satisfied"
        return 0
    fi
}

# Setup development environment
setup_dev_environment() {
    log_info "Setting up development environment..."
    
    # Create Python virtual environments
    for service in user-service cron-scheduler; do
        if [ -d "services/$service" ]; then
            log_info "Setting up Python environment for $service"
            cd "services/$service"
            python3 -m venv venv
            source venv/bin/activate
            pip install -r requirements.txt
            cd - > /dev/null
        fi
    done
    
    # Setup Node.js dependencies
    if [ -d "services/analytics-service" ]; then
        log_info "Setting up Node.js environment for analytics-service"
        cd services/analytics-service
        npm install
        cd - > /dev/null
    fi
    
    # Setup Go dependencies
    if [ -d "services/notification-service" ]; then
        log_info "Setting up Go environment for notification-service"
        cd services/notification-service
        go mod download
        cd - > /dev/null
    fi
    
    # Setup PHP dependencies
    if [ -d "services/content-api" ]; then
        log_info "Setting up PHP environment for content-api"
        cd services/content-api
        # Simulate composer install
        log_info "Run 'composer install' manually for PHP dependencies"
        cd - > /dev/null
    fi
}

# Generate configuration files
generate_configs() {
    log_info "Generating configuration files..."
    
    # Create environment file template
    cat > .env.example << EOF
# Multi-everything DevOps Environment Configuration
# Copy this file to .env and update with your values

# Database Configuration
DB_HOST=localhost
DB_PORT=5432
DB_NAME=multieverything
DB_USERNAME=multieverything_admin
DB_PASSWORD=your_secure_password_here

# AWS Configuration
AWS_REGION=eu-central-1
AWS_ACCESS_KEY_ID=your_access_key_here
AWS_SECRET_ACCESS_KEY=your_secret_key_here

# Application Configuration
APP_ENV=development
LOG_LEVEL=DEBUG

# API Keys
OPENAI_API_KEY=your_openai_key_here
EOF

    log_info "Created .env.example file"
}

# Validate setup
validate_setup() {
    log_info "Validating environment setup..."
    
    local errors=0
    
    # Check if all services have their main files
    services=("content-api" "user-service" "analytics-service" "notification-service" "cron-scheduler")
    for service in "${services[@]}"; do
        if [ ! -f "services/$service/Dockerfile" ]; then
            log_error "Missing Dockerfile for $service"
            ((errors++))
        fi
    done
    
    # Check Terraform configurations
    if [ ! -d "terraform/01-network" ]; then
        log_error "Missing Terraform network configuration"
        ((errors++))
    fi
    
    if [ $errors -eq 0 ]; then
        log_info "✅ Environment setup validation passed"
        return 0
    else
        log_error "❌ Environment setup validation failed with $errors errors"
        return 1
    fi
}

# Main setup function
main() {
    log_info "Starting Multi-everything DevOps environment setup..."
    
    check_prerequisites
    setup_dev_environment
    generate_configs
    validate_setup
    
    log_info "🎉 Environment setup completed successfully!"
    log_info "📋 Next steps:"
    log_info "   1. Copy .env.example to .env and configure your settings"
    log_info "   2. Run Terraform to deploy infrastructure"
    log_info "   3. Build and deploy Docker images"
    log_info "   4. Access your dashboards at the provided URLs"
}

# Run main function
main "$@"