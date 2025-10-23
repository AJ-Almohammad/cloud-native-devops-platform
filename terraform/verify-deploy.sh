#!/bin/bash
echo "🔍 Verifying Deployment..."
echo "========================="

echo "1. EKS Cluster:"
aws eks describe-cluster --name multi-everything-devops-cluster --region eu-central-1 --query 'cluster.status' --output text

echo "2. RDS Database:"
aws rds describe-db-instances --db-instance-identifier multi-everything-devops-db --region eu-central-1 --query 'DBInstances[0].DBInstanceStatus' --output text

echo "3. Lambda Function:"
aws lambda get-function --function-name multi-everything-ai-moderation --region eu-central-1 --query 'Configuration.State' --output text

echo "4. VPC:"
aws ec2 describe-vpcs --filters "Name=tag:Name,Values=multi-everything-devops-vpc" --region eu-central-1 --query 'Vpcs[0].VpcId' --output text

echo "5. KMS Key:"
aws kms describe-key --key-id alias/multi-everything-rds-key --region eu-central-1 --query 'KeyMetadata.KeyState' --output text

echo "6. CloudWatch Alarms:"
aws cloudwatch describe-alarms --alarm-name-prefix "multi-everything" --region eu-central-1 --query 'length(MetricAlarms)' --output text

echo "✅ Deployment Verification Complete!"
