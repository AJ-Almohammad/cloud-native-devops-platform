#!/bin/bash
echo "🔒 Running Security Tests..."
CONTENT_API="http://af6c83f31061645268374c598ab6d079-141930383.eu-central-1.elb.amazonaws.com"

echo "1. Testing security headers..."
echo "Health endpoint headers:"
curl -I "${CONTENT_API}/health" 2>/dev/null | grep -E "(X-Content-Type-Options|X-Frame-Options|X-XSS-Protection|Content-Security-Policy)" || echo "No security headers found"

echo ""
echo "2. Testing API endpoint headers:"
curl -I "${CONTENT_API}/api/v1/content" 2>/dev/null | grep -E "(X-Content-Type-Options|X-Frame-Options|X-XSS-Protection|Content-Security-Policy)" || echo "No security headers found"

echo ""
echo "3. Testing for common vulnerabilities..."
# Test for SQL injection (basic)
curl -s "${CONTENT_API}/api/v1/content?query=1' OR '1'='1" | grep -q "error" && echo "✅ SQL injection protection" || echo "⚠️  Potential SQL injection issue"

echo ""
echo "4. Checking service status..."
kubectl get pods -n multi-everything | grep -v Running && echo "❌ Some pods not running" || echo "✅ All pods running"

echo "✅ Security tests completed!"
