#!/bin/bash
# Integration Tests for Multi-Everything Microservices

echo "🧪 Running Microservice Integration Tests..."

# Test 1: Content API
echo "Testing Content API endpoints..."
CONTENT_API="http://af6c83f31061645268374c598ab6d079-141930383.eu-central-1.elb.amazonaws.com"

# Health check
curl -s -f "${CONTENT_API}/health" | grep -q "healthy"
if [ $? -eq 0 ]; then
    echo "✅ Content API Health: PASS"
else
    echo "❌ Content API Health: FAIL"
    exit 1
fi

# Test 2: Get content
curl -s -f "${CONTENT_API}/api/v1/content" | grep -q "id"
if [ $? -eq 0 ]; then
    echo "✅ Content API Data: PASS"
else
    echo "❌ Content API Data: FAIL"
    exit 1
fi

echo "🎉 ALL INTEGRATION TESTS PASSED!"
