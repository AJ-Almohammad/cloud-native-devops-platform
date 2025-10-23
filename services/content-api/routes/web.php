<?php
// Multi-everything DevOps - Web Routes

use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;

// Home page - KEEP THIS FIRST
$app->get('/', function (Request $request, Response $response) {
    $response->getBody()->write(json_encode([
        'message' => 'Welcome to Multi-everything DevOps Content API',
        'version' => '1.0.0',
        'status' => 'operational',
        'timestamp' => date('c')
    ]));
    return $response->withHeader('Content-Type', 'application/json');
});

// SPECIFIC ROUTES MUST COME BEFORE GENERIC ONES

// Content listing page - MOVED ABOVE generic content route
$app->get('/content/list', function (Request $request, Response $response) {
    $response->getBody()->write(json_encode([
        'page' => 'Content List',
        'content' => [
            ['id' => 1, 'title' => 'DevOps Best Practices', 'type' => 'article'],
            ['id' => 2, 'title' => 'Microservices Architecture', 'type' => 'guide'],
            ['id' => 3, 'title' => 'Kubernetes Deployment', 'type' => 'tutorial']
        ]
    ]));
    return $response->withHeader('Content-Type', 'application/json');
});

// About page - MOVED ABOVE generic content route
$app->get('/about', function (Request $request, Response $response) {
    $response->getBody()->write(json_encode([
        'page' => 'About',
        'project' => 'Multi-everything DevOps Platform',
        'description' => 'Enterprise-grade content publishing and analytics platform',
        'architecture' => 'Microservices, Kubernetes, AWS, Terraform',
        'version' => '1.0.0'
    ]));
    return $response->withHeader('Content-Type', 'application/json');
});

// GENERIC ROUTES COME LAST

// Get content by ID - MOVED TO BOTTOM
$app->get('/content/{id}', function (Request $request, Response $response, $args) {
    $id = $args['id'];
    $data = ['id' => $id, 'title' => "Article $id", 'content' => "Content for article $id"];
    $response->getBody()->write(json_encode($data));
    return $response->withHeader('Content-Type', 'application/json');
});