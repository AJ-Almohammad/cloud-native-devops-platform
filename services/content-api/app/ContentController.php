<?php

namespace App;

class ContentController
{
    private $db;
    
    public function __construct($database)
    {
        $this->db = $database;
    }
    
    public function getAllContent()
    {
        // Simulate database query
        return [
            ['id' => 1, 'title' => 'Getting Started with DevOps', 'content' => 'Introduction to DevOps practices...'],
            ['id' => 2, 'title' => 'Microservices Architecture', 'content' => 'Building scalable microservices...'],
            ['id' => 3, 'title' => 'Kubernetes Best Practices', 'content' => 'Orchestrating containers effectively...']
        ];
    }
    
    public function getContentById($id)
    {
        $allContent = $this->getAllContent();
        foreach ($allContent as $content) {
            if ($content['id'] == $id) {
                return $content;
            }
        }
        return null;
    }
    
    public function createContent($title, $content)
    {
        // Simulate content creation
        return [
            'id' => rand(100, 999),
            'title' => $title,
            'content' => $content,
            'created_at' => date('Y-m-d H:i:s')
        ];
    }
}