import json
import boto3
import logging
import os

# Setup logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

# AWS clients
sns_client = boto3.client('sns')
sqs_client = boto3.client('sqs')

def lambda_handler(event, context):
    """
    Event Router Lambda Function
    Routes events to appropriate SNS topics and SQS queues based on event type
    """
    
    try:
        logger.info("Starting event routing process")
        
        # Parse incoming event
        records = event.get('Records', [])
        
        if not records:
            # Direct invocation
            process_single_event(event)
        else:
            # SQS batch processing
            for record in records:
                if 'body' in record:
                    event_body = json.loads(record['body'])
                    process_single_event(event_body)
        
        logger.info("Event routing completed successfully")
        
        return {
            'statusCode': 200,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            },
            'body': json.dumps({
                'status': 'success',
                'message': 'Events routed successfully',
                'processed_count': len(records) if records else 1
            })
        }
        
    except Exception as e:
        logger.error(f"Event routing error: {str(e)}")
        return {
            'statusCode': 500,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            },
            'body': json.dumps({
                'error': 'Event routing failed',
                'message': str(e)
            })
        }

def process_single_event(event):
    """
    Process a single event and route to appropriate destinations
    """
    event_type = event.get('event_type', 'unknown')
    source = event.get('source', 'unknown')
    
    logger.info(f"Routing event: {event_type} from {source}")
    
    # Route based on event type
    if event_type == 'user_registered':
        route_to_user_service(event)
        
    elif event_type == 'content_created':
        route_to_content_service(event)
        route_to_analytics_service(event)
        
    elif event_type == 'content_approved':
        route_to_notification_service(event)
        route_to_analytics_service(event)
        
    elif event_type == 'payment_processed':
        route_to_analytics_service(event)
        
    elif event_type == 'system_alert':
        route_to_alert_service(event)
        
    else:
        # Default routing for unknown events
        route_to_dead_letter_queue(event)
        
    logger.info(f"Event {event_type} routed successfully")

def route_to_user_service(event):
    """Route events to user service SNS topic"""
    try:
        topic_arn = os.environ.get('USER_SERVICE_TOPIC_ARN', 'arn:aws:sns:eu-central-1:123456789012:user-service-events')
        sns_client.publish(
            TopicArn=topic_arn,
            Message=json.dumps(event),
            MessageAttributes={
                'event_type': {
                    'DataType': 'String',
                    'StringValue': event.get('event_type', 'unknown')
                },
                'source': {
                    'DataType': 'String',
                    'StringValue': event.get('source', 'unknown')
                }
            }
        )
        logger.info("Event routed to user service")
    except Exception as e:
        logger.error(f"Failed to route to user service: {str(e)}")

def route_to_content_service(event):
    """Route events to content service SNS topic"""
    try:
        topic_arn = os.environ.get('CONTENT_SERVICE_TOPIC_ARN', 'arn:aws:sns:eu-central-1:123456789012:content-service-events')
        sns_client.publish(
            TopicArn=topic_arn,
            Message=json.dumps(event),
            MessageGroupId='content-events'
        )
        logger.info("Event routed to content service")
    except Exception as e:
        logger.error(f"Failed to route to content service: {str(e)}")

def route_to_analytics_service(event):
    """Route events to analytics SQS queue"""
    try:
        queue_url = os.environ.get('ANALYTICS_QUEUE_URL', 'https://sqs.eu-central-1.amazonaws.com/123456789012/analytics-events')
        sqs_client.send_message(
            QueueUrl=queue_url,
            MessageBody=json.dumps(event),
            MessageAttributes={
                'event_type': {
                    'DataType': 'String',
                    'StringValue': event.get('event_type', 'unknown')
                }
            }
        )
        logger.info("Event routed to analytics service")
    except Exception as e:
        logger.error(f"Failed to route to analytics service: {str(e)}")

def route_to_notification_service(event):
    """Route events to notification service"""
    try:
        topic_arn = os.environ.get('NOTIFICATION_TOPIC_ARN', 'arn:aws:sns:eu-central-1:123456789012:notification-events')
        sns_client.publish(
            TopicArn=topic_arn,
            Message=json.dumps(event),
            Subject=f"Notification: {event.get('event_type', 'Event')}"
        )
        logger.info("Event routed to notification service")
    except Exception as e:
        logger.error(f"Failed to route to notification service: {str(e)}")

def route_to_alert_service(event):
    """Route system alerts to alerting system"""
    try:
        topic_arn = os.environ.get('ALERT_TOPIC_ARN', 'arn:aws:sns:eu-central-1:123456789012:system-alerts')
        sns_client.publish(
            TopicArn=topic_arn,
            Message=json.dumps(event),
            Subject=f"ALERT: {event.get('alert_type', 'System Alert')}",
            MessageAttributes={
                'severity': {
                    'DataType': 'String',
                    'StringValue': event.get('severity', 'medium')
                }
            }
        )
        logger.info("Event routed to alert service")
    except Exception as e:
        logger.error(f"Failed to route to alert service: {str(e)}")

def route_to_dead_letter_queue(event):
    """Route unknown events to dead letter queue for investigation"""
    try:
        dlq_url = os.environ.get('DEAD_LETTER_QUEUE_URL', 'https://sqs.eu-central-1.amazonaws.com/123456789012/event-router-dlq')
        sqs_client.send_message(
            QueueUrl=dlq_url,
            MessageBody=json.dumps(event),
            MessageAttributes={
                'reason': {
                    'DataType': 'String',
                    'StringValue': 'unknown_event_type'
                }
            }
        )
        logger.warning(f"Unknown event type routed to DLQ: {event.get('event_type')}")
    except Exception as e:
        logger.error(f"Failed to route to DLQ: {str(e)}")

# Test function for local development
if __name__ == "__main__":
    test_events = [
        {
            'event_type': 'user_registered',
            'source': 'user-service',
            'user_id': 'user_123',
            'timestamp': '2024-01-15T10:30:00Z'
        },
        {
            'event_type': 'content_created',
            'source': 'content-api',
            'content_id': 'content_456',
            'user_id': 'user_123',
            'timestamp': '2024-01-15T10:35:00Z'
        }
    ]
    
    for test_event in test_events:
        result = lambda_handler(test_event, None)
        print(json.dumps(result, indent=2))