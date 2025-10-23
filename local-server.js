const express = require('express');
const axios = require('axios');
const path = require('path');

const app = express();
const PORT = 8085;

// Serve static files
app.use(express.static('.'));

// Health check endpoint that checks all services server-side
app.get('/api/health-check', async (req, res) => {
  const services = [
    { name: 'Content API', url: 'http://localhost:8082/health', port: 8082, namespace: 'microservices' },
    { name: 'User Service', url: 'http://localhost:8002/health', port: 8002, namespace: 'multi-everything' },
    { name: 'Analytics Service', url: 'http://localhost:3000/health', port: 3000, namespace: 'multi-everything' },
    { name: 'Notification Service', url: 'http://localhost:8081/health', port: 8081, namespace: 'multi-everything' },
    { name: 'Cron Scheduler', url: 'http://localhost:8003/health', port: 8003, namespace: 'multi-everything' }
  ];

  const results = [];
  let healthyCount = 0;
  let totalResponseTime = 0;
  let responseCount = 0;

  for (const service of services) {
    try {
      const startTime = Date.now();
      const response = await axios.get(service.url, { timeout: 3000 });
      const responseTime = Date.now() - startTime;
      
      results.push({
        name: service.name,
        healthy: true,
        responseTime: responseTime,
        data: response.data,
        port: service.port,
        namespace: service.namespace
      });
      healthyCount++;
      totalResponseTime += responseTime;
      responseCount++;
    } catch (error) {
      results.push({
        name: service.name,
        healthy: false,
        responseTime: null,
        error: error.message,
        port: service.port,
        namespace: service.namespace
      });
    }
  }

  const avgResponseTime = responseCount > 0 ? Math.round(totalResponseTime / responseCount) : 0;

  res.json({
    services: results,
    summary: {
      total: services.length,
      healthy: healthyCount,
      unhealthy: services.length - healthyCount,
      avgResponseTime: avgResponseTime,
      uptime: Math.round((healthyCount / services.length) * 100)
    },
    timestamp: new Date().toISOString()
  });
});

// Serve the dashboard - UPDATED TO USE local-dashboard.html
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'local-dashboard.html'));
});

app.listen(PORT, () => {
  console.log(`🚀 Local Dashboard server running on http://localhost:${PORT}`);
  console.log(`📊 Open: http://localhost:${PORT}`);
});
