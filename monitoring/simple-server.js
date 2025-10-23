const express = require('express');
const path = require('path');
const app = express();
const PORT = 3005;

app.get('/dashboard-with-proxy.html', (req, res) => {
    res.sendFile(path.join(__dirname, 'dashboard-with-proxy.html'));
});

app.get('/', (req, res) => {
    res.redirect('/dashboard-with-proxy.html');
});

app.listen(PORT, () => {
    console.log("🚀 Enhanced Monitoring Dashboard Server");
    console.log("📊 Access: http://localhost:3005/dashboard-with-proxy.html");
    console.log("🏠 Home: http://localhost:3005/");
});
