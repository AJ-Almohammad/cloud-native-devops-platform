const http = require('http');
const httpProxy = require('http-proxy');

const proxy = httpProxy.createProxyServer({});
const server = http.createServer((req, res) => {
  // Set CORS headers
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

  if (req.url === '/') {
    // Serve the dashboard HTML
    require('fs').readFile('local-dashboard.html', (err, data) => {
      if (err) {
        res.writeHead(500);
        res.end('Error loading dashboard');
      } else {
        res.writeHead(200, {'Content-Type': 'text/html'});
        res.end(data);
      }
    });
  } else if (req.url.startsWith('/proxy/')) {
    // Proxy API requests
    const service = req.url.replace('/proxy/', '');
    let target = '';
    
    switch(service) {
      case 'content-api/health':
        target = 'http://localhost:8082/health';
        break;
      case 'user-service/health':
        target = 'http://localhost:8002/health';
        break;
      case 'analytics-service/health':
        target = 'http://localhost:3000/health';
        break;
      case 'notification-service/health':
        target = 'http://localhost:8081/health';
        break;
      case 'cron-scheduler/health':
        target = 'http://localhost:8003/health';
        break;
      default:
        res.writeHead(404);
        res.end('Service not found');
        return;
    }
    
    proxy.web(req, res, { target }, (err) => {
      res.writeHead(500);
      res.end('Proxy error: ' + err.message);
    });
  } else {
    res.writeHead(404);
    res.end('Not found');
  }
});

server.listen(8085, () => {
  console.log('🚀 Dashboard proxy server running on http://localhost:8085');
  console.log('📊 Open: http://localhost:8085');
});
