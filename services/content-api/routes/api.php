<?php
// Multi-everything DevOps - API Routes
// REST API endpoints for content management

use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;

// API health check
$app->get('/api/health', function (Request $request, Response $response) {
    $response->getBody()->write(json_encode([
        'status' => 'healthy',
        'service' => 'content-api',
        'timestamp' => date('c'),
        'version' => '1.0.0',
        'environment' => $_ENV['APP_ENV'] ?? 'development'
    ]));
    return $response->withHeader('Content-Type', 'application/json');
});

// Get all content (API version)
$app->get('/api/v1/content', function (Request $request, Response $response) {
    $queryParams = $request->getQueryParams();
    $page = $queryParams['page'] ?? 1;
    $limit = $queryParams['limit'] ?? 10;
    
    $response->getBody()->write(json_encode([
        'data' => [
            ['id' => 1, 'title' => 'API Design Best Practices', 'type' => 'article', 'created_at' => '2024-01-15T10:00:00Z'],
            ['id' => 2, 'title' => 'RESTful Microservices', 'type' => 'guide', 'created_at' => '2024-01-15T11:00:00Z'],
            ['id' => 3, 'title' => 'GraphQL vs REST', 'type' => 'comparison', 'created_at' => '2024-01-15T12:00:00Z']
        ],
        'pagination' => [
            'page' => (int)$page,
            'limit' => (int)$limit,
            'total' => 3,
            'pages' => 1
        ]
    ]));
    return $response->withHeader('Content-Type', 'application/json');
});

// Get content by ID
$app->get('/api/v1/content/{id}', function (Request $request, Response $response, $args) {
    $contentId = $args['id'];
    $response->getBody()->write(json_encode([
        'data' => [
            'id' => $contentId,
            'title' => "Advanced DevOps Patterns - $contentId",
            'content' => "This is the full content for API item $contentId...",
            'author' => 'DevOps Team',
            'published_at' => '2024-01-15T10:00:00Z',
            'tags' => ['devops', 'microservices', 'kubernetes'],
            'status' => 'published'
        ]
    ]));
    return $response->withHeader('Content-Type', 'application/json');
});

// Create new content
$app->post('/api/v1/content', function (Request $request, Response $response) {
    $data = $request->getParsedBody();
    
    // Simulate content creation
    $newContent = [
        'id' => rand(1000, 9999),
        'title' => $data['title'] ?? 'Untitled',
        'content' => $data['content'] ?? '',
        'author' => $data['author'] ?? 'anonymous',
        'created_at' => date('c'),
        'status' => 'draft'
    ];
    
    $response->getBody()->write(json_encode([
        'message' => 'Content created successfully',
        'data' => $newContent
    ]));
    return $response->withHeader('Content-Type', 'application/json')->withStatus(201);
});

// Update content
$app->put('/api/v1/content/{id}', function (Request $request, Response $response, $args) {
    $contentId = $args['id'];
    $data = $request->getParsedBody();
    
    $response->getBody()->write(json_encode([
        'message' => 'Content updated successfully',
        'content_id' => $contentId,
        'updates' => $data,
        'updated_at' => date('c')
    ]));
    return $response->withHeader('Content-Type', 'application/json');
});

// Delete content
$app->delete('/api/v1/content/{id}', function (Request $request, Response $response, $args) {
    $contentId = $args['id'];
    
    $response->getBody()->write(json_encode([
        'message' => 'Content deleted successfully',
        'content_id' => $contentId,
        'deleted_at' => date('c')
    ]));
    return $response->withHeader('Content-Type', 'application/json');
});

// Search content
$app->get('/api/v1/content/search/{query}', function (Request $request, Response $response, $args) {
    $searchQuery = $args['query'];
    
    $response->getBody()->write(json_encode([
        'query' => $searchQuery,
        'results' => [
            ['id' => 1, 'title' => "DevOps $searchQuery Guide", 'relevance' => 0.95],
            ['id' => 2, 'title' => "Advanced $searchQuery Patterns", 'relevance' => 0.87],
            ['id' => 3, 'title' => "$searchQuery Best Practices", 'relevance' => 0.76]
        ],
        'total_results' => 3
    ]));
    return $response->withHeader('Content-Type', 'application/json');
});