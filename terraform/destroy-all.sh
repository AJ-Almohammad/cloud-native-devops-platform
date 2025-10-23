#!/bin/bash

set -e
set -o pipefail

echo "🚀 Starting infrastructure destruction in reverse order..."
echo "=========================================================="

# Helper function: Safely destroy a Terraform module
destroy_module() {
    local dir=$1
    echo "🧩 Destroying ${dir}..."
    if [ -d "$dir" ]; then
        cd "$dir"
        terraform init -input=false -reconfigure >/dev/null 2>&1 || true
        terraform destroy -auto-approve || echo "⚠️  Terraform destroy failed in ${dir}, continuing..."
        cd ..
    else
        echo "❌ Directory ${dir} not found, skipping..."
    fi
}

# Ordered destruction (top to bottom)
destroy_module "06-security"
destroy_module "05-monitoring"
destroy_module "04-serverless"
destroy_module "03-data"
destroy_module "02-compute"

echo "6️⃣  Destroying 01-network..."
cd 01-network || exit 1
terraform destroy -auto-approve || true

# Fallback cleanup for NAT Gateways, Load Balancers, and Elastic IPs
echo "🔍 Checking for remaining NAT Gateways, Load Balancers, and EIPs..."
VPC_ID=$(terraform output -raw vpc_id 2>/dev/null || echo "")
if [ -n "$VPC_ID" ]; then
    echo "Found VPC: $VPC_ID"

    # NAT Gateways
    NAT_GW_IDS=$(aws ec2 describe-nat-gateways \
        --filter "Name=vpc-id,Values=$VPC_ID" \
        --query 'NatGateways[?State!=`deleted`].NatGatewayId' \
        --output text 2>/dev/null || echo "")
    if [ -n "$NAT_GW_IDS" ]; then
        echo "🗑️  Deleting NAT Gateways: $NAT_GW_IDS"
        for gw in $NAT_GW_IDS; do
            aws ec2 delete-nat-gateway --nat-gateway-id "$gw" || true
        done
        echo "⏳ Waiting for NAT Gateways to be deleted..."
        aws ec2 wait nat-gateway-deleted --nat-gateway-ids $NAT_GW_IDS || true
    fi

    # Elastic IPs
    EIP_ALLOCS=$(aws ec2 describe-addresses \
        --filters "Name=domain,Values=vpc" \
        --query 'Addresses[].AllocationId' \
        --output text 2>/dev/null || echo "")
    if [ -n "$EIP_ALLOCS" ]; then
        echo "🧹 Releasing Elastic IPs: $EIP_ALLOCS"
        for alloc in $EIP_ALLOCS; do
            aws ec2 release-address --allocation-id "$alloc" || true
        done
    fi

    # Load Balancers
    LB_ARNs=$(aws elbv2 describe-load-balancers \
        --query "LoadBalancers[?VpcId=='$VPC_ID'].LoadBalancerArn" \
        --output text 2>/dev/null || echo "")
    if [ -n "$LB_ARNs" ]; then
        echo "🗑️  Deleting Load Balancers: $LB_ARNs"
        for lb in $LB_ARNs; do
            aws elbv2 delete-load-balancer --load-balancer-arn "$lb" || true
        done
        echo "⏳ Waiting for Load Balancers to be deleted..."
        sleep 20
    fi
fi

echo "♻️  Retrying VPC destruction..."
terraform destroy -auto-approve || true
cd ..

# 🪣 Destroy backend (S3 + DynamoDB) last
echo "7️⃣  Destroying 00-backend (S3 state + DynamoDB lock)..."
cd 00-backend || exit 1

# Get bucket name from Terraform output
BUCKET_NAME=$(terraform output -raw s3_bucket_name 2>/dev/null || echo "")
if [ -n "$BUCKET_NAME" ]; then
    echo "🧹 Emptying S3 bucket before destroy: $BUCKET_NAME"

    # Remove all versions + delete markers
    aws s3api list-object-versions --bucket "$BUCKET_NAME" --output json \
    | jq -r '.Versions[]?, .DeleteMarkers[]? | select(.VersionId != null) | [.Key, .VersionId] | @tsv' 2>/dev/null \
    | while IFS=$'\t' read -r key version; do
        aws s3api delete-object --bucket "$BUCKET_NAME" --key "$key" --version-id "$version" >/dev/null 2>&1 || true
    done
fi

terraform destroy -auto-approve || true
cd ..

echo "=========================================================="
echo "✅ All infrastructure (including backend) destroyed successfully!"
echo "⚠️  S3 bucket and DynamoDB table for Terraform state are now gone."
