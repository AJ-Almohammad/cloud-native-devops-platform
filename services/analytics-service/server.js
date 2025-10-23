const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');
const compression = require('compression');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(helmet());
app.use(cors());
app.use(morgan('combined'));
app.use(compression());
app.use(express.json());

// In-memory analytics storage (replace with database later)
let analyticsData = {
    pageViews: 0,
    apiCalls: 0,
    users: new Set(),
    events: []
};

// Health check endpoint
app.get('/health', (req, res) => {
    res.json({
        status: 'healthy',
        service: 'analytics-service',
        timestamp: new Date().toISOString(),
        uptime: process.uptime()
    });
});

// Track page view
app.post('/analytics/pageview', (req, res) => {
    const { userId, page, userAgent } = req.body;
    
    analyticsData.pageViews++;
    if (userId) analyticsData.users.add(userId);
    
    analyticsData.events.push({
        type: 'pageview',
        userId,
        page,
        userAgent,
        timestamp: new Date().toISOString()
    });

    res.json({ success: true, totalPageViews: analyticsData.pageViews });
});

// Track API call
app.post('/analytics/apicall', (req, res) => {
    const { endpoint, method, duration, statusCode } = req.body;
    
    analyticsData.apiCalls++;

    analyticsData.events.push({
        type: 'apicall',
        endpoint,
        method,
        duration,
        statusCode,
        timestamp: new Date().toISOString()
    });

    res.json({ success: true, totalApiCalls: analyticsData.apiCalls });
});

// Get analytics summary
app.get('/analytics/summary', (req, res) => {
    const summary = {
        totalPageViews: analyticsData.pageViews,
        totalApiCalls: analyticsData.apiCalls,
        uniqueUsers: analyticsData.users.size,
        eventsCount: analyticsData.events.length,
        lastUpdated: new Date().toISOString()
    };
    
    res.json(summary);
});

// Get recent events
app.get('/analytics/events', (req, res) => {
    const limit = parseInt(req.query.limit) || 50;
    const recentEvents = analyticsData.events.slice(-limit);
    res.json(recentEvents);
});

app.listen(PORT, '0.0.0.0', () => {
    console.log(`Analytics service running on port ${PORT}`);
});