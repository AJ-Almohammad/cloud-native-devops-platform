#!/bin/bash
echo "🚀 Running Load Tests..."
CONTENT_API="http://af6c83f31061645268374c598ab6d079-141930383.eu-central-1.elb.amazonaws.com"

echo "1. Testing API response time..."
time curl -s -o /dev/null -w "%{http_code}" "${CONTENT_API}/api/v1/content"

echo ""
echo "2. Testing with Apache Bench (if available)..."
if command -v ab &> /dev/null; then
    ab -n 50 -c 5 "${CONTENT_API}/api/v1/content" | grep -E "(Time taken|Requests per second|Transfer rate)"
else
    echo "Apache Bench not installed, skipping load test"
fi

echo ""
echo "3. Testing concurrent requests..."
for i in {1..5}; do
    curl -s "${CONTENT_API}/health" | grep -q "healthy" && echo "Request $i: ✅" || echo "Request $i: ❌" &
done
wait

echo "✅ Load tests completed!"
