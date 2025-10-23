<?php

return [
    'name' => 'Content API',
    'version' => '1.0.0',
    'env' => getenv('APP_ENV') ?: 'production',
    
    'database' => [
        'host' => getenv('DB_HOST') ?: 'localhost',
        'port' => getenv('DB_PORT') ?: '5432',
        'database' => getenv('DB_DATABASE') ?: 'multieverything',
        'username' => getenv('DB_USERNAME') ?: 'multieverything_admin',
        'password' => getenv('DB_PASSWORD') ?: '',
    ],
    
    'logging' => [
        'level' => getenv('LOG_LEVEL') ?: 'DEBUG',
        'path' => __DIR__ . '/../storage/logs/app.log',
    ],
    
    'cors' => [
        'allowed_origins' => ['https://yourdomain.com'],
        'allowed_methods' => ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
        'allowed_headers' => ['Content-Type', 'Authorization'],
    ]
];