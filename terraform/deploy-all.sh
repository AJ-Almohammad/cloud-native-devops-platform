#!/bin/bash

set -e  # Exit on any error

echo "🚀 Starting infrastructure deployment in order..."
echo "=================================================="

echo "1️⃣  Deploying 01-network..."
cd 01-network && terraform apply -auto-approve
cd ..

echo "2️⃣  Deploying 02-compute..."
cd 02-compute && terraform apply -auto-approve
cd ..

echo "3️⃣  Deploying 03-data..."
cd 03-data && terraform apply -auto-approve
cd ..

echo "4️⃣  Deploying 04-serverless..."
cd 04-serverless && terraform apply -auto-approve
cd ..

echo "5️⃣  Deploying 05-monitoring..."
cd 05-monitoring && terraform apply -auto-approve
cd ..

echo "6️⃣  Deploying 06-security..."
cd 06-security && terraform apply -auto-approve
cd ..

echo "=================================================="
echo "✅ All infrastructure deployed successfully!"
echo "🌐 Your multi-everything-devops stack is ready!"