const express = require('express');
const cors = require('cors');
const { createProxyMiddleware } = require('http-proxy-middleware');

const app = express();
const PORT = process.env.PORT || 3000;

// Enable CORS for all routes
app.use(cors());
app.use(express.static('.'));

// Proxy configuration
const services = {
  '/proxy/content-api': {
    target: 'http://af6c83f31061645268374c598ab6d079-1048723379.eu-central-1.elb.amazonaws.com',
    changeOrigin: true,
    pathRewrite: { '^/proxy/content-api': '' }
  },
  '/proxy/user-service': {
    target: 'http://a12960fda9af6494cbefeafd954e2511-912309155.eu-central-1.elb.amazonaws.com:8000',
    changeOrigin: true,
    pathRewrite: { '^/proxy/user-service': '' }
  },
  '/proxy/analytics-service': {
    target: 'http://a7e7815633fd1415f999ea3a1c6e03d6-863675303.eu-central-1.elb.amazonaws.com:3000',
    changeOrigin: true,
    pathRewrite: { '^/proxy/analytics-service': '' }
  },
  '/proxy/notification-service': {
    target: 'http://ad2ea68e04b38424ca71e506b5a8d75d-1949419912.eu-central-1.elb.amazonaws.com:8080',
    changeOrigin: true,
    pathRewrite: { '^/proxy/notification-service': '' }
  },
  '/proxy/cron-scheduler': {
    target: 'http://abfb2f3259abf41f6ac06decc050c77f-1289904563.eu-central-1.elb.amazonaws.com:8000',
    changeOrigin: true,
    pathRewrite: { '^/proxy/cron-scheduler': '' }
  }
};

// Set up proxies
Object.entries(services).forEach(([path, config]) => {
  app.use(path, createProxyMiddleware(config));
});

// Health check endpoint
app.get('/health', (req, res) => {
  res.json({ status: 'healthy', service: 'dashboard-proxy' });
});

// Start server
app.listen(PORT, () => {
  console.log(`🚀 Dashboard Proxy Server running on port ${PORT}`);
  console.log(`📊 Dashboard available at: http://localhost:${PORT}/dashboard-with-proxy.html`);
});