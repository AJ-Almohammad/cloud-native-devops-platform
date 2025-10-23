import json
import boto3
import os
import logging

# Setup logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    """
    AI Content Moderation Lambda Function
    Analyzes content for inappropriate material using AI services
    """
    
    try:
        logger.info("Starting AI moderation process")
        
        # Parse incoming event
        body = json.loads(event['body']) if 'body' in event else event
        content = body.get('content', '')
        content_type = body.get('content_type', 'text')
        
        logger.info(f"Moderating {content_type}: {content[:100]}...")
        
        # Simulate AI moderation (in production, use AWS Comprehend or similar)
        moderation_result = simulate_ai_moderation(content, content_type)
        
        # Log moderation action
        logger.info(f"Moderation result: {moderation_result['status']}")
        
        return {
            'statusCode': 200,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            },
            'body': json.dumps({
                'moderated': True,
                'status': moderation_result['status'],
                'confidence': moderation_result['confidence'],
                'flags': moderation_result['flags'],
                'message': moderation_result['message']
            })
        }
        
    except Exception as e:
        logger.error(f"Moderation error: {str(e)}")
        return {
            'statusCode': 500,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            },
            'body': json.dumps({
                'error': 'Moderation failed',
                'message': str(e)
            })
        }

def simulate_ai_moderation(content, content_type):
    """
    Simulate AI moderation (replace with actual AI service in production)
    """
    
    # Simple keyword-based moderation for demo
    inappropriate_keywords = ['spam', 'scam', 'inappropriate', 'offensive']
    
    flags = []
    confidence = 0.95
    
    # Check for inappropriate content
    content_lower = content.lower()
    for keyword in inappropriate_keywords:
        if keyword in content_lower:
            flags.append(f"contains_{keyword}")
    
    # Determine status
    if flags:
        status = 'REJECTED'
        message = 'Content contains inappropriate material'
    else:
        status = 'APPROVED'
        message = 'Content approved'
    
    return {
        'status': status,
        'confidence': confidence,
        'flags': flags,
        'message': message
    }

# Test function for local development
if __name__ == "__main__":
    test_event = {
        'body': json.dumps({
            'content': 'This is a sample post for moderation',
            'content_type': 'text'
        })
    }
    
    result = lambda_handler(test_event, None)
    print(json.dumps(result, indent=2))