<?php
require_once __DIR__ . '/../vendor/autoload.php';

use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use Slim\Factory\AppFactory;
use Monolog\Logger;
use Monolog\Handler\StreamHandler;

// Create app
$app = AppFactory::create();

// Add error middleware
$app->addErrorMiddleware(true, true, true);

// Create logger
$log = new Logger('content-api');
$log->pushHandler(new StreamHandler(__DIR__ . '/../storage/logs/app.log', Logger::DEBUG));

// Health check endpoint
$app->get('/health', function (Request $request, Response $response) {
    $response->getBody()->write(json_encode([
        'status' => 'healthy',
        'service' => 'content-api',
        'timestamp' => time()
    ]));
    return $response->withHeader('Content-Type', 'application/json');
});


// Include route files
require_once __DIR__ . '/../routes/web.php';
require_once __DIR__ . '/../routes/api.php';

$app->run();