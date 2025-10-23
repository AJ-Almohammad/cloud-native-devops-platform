import json
import boto3
import logging
from datetime import datetime, timedelta

# Setup logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    """
    Cost Calculator Lambda Function
    Calculates and analyzes AWS costs for FinOps reporting
    """
    
    try:
        logger.info("Starting cost calculation process")
        
        # Parse incoming parameters
        body = json.loads(event['body']) if 'body' in event else event
        time_range = body.get('time_range', 'last_30_days')
        services = body.get('services', [])
        
        # Calculate date range
        end_date = datetime.utcnow().date()
        if time_range == 'last_7_days':
            start_date = end_date - timedelta(days=7)
        elif time_range == 'last_30_days':
            start_date = end_date - timedelta(days=30)
        else:  # last_90_days
            start_date = end_date - timedelta(days=90)
        
        logger.info(f"Calculating costs from {start_date} to {end_date}")
        
        # Get cost data (simulated - in production use AWS Cost Explorer API)
        cost_data = simulate_cost_calculation(start_date, end_date, services)
        
        # Generate optimization recommendations
        recommendations = generate_optimization_recommendations(cost_data)
        
        return {
            'statusCode': 200,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            },
            'body': json.dumps({
                'time_period': {
                    'start': start_date.isoformat(),
                    'end': end_date.isoformat()
                },
                'total_cost': cost_data['total_cost'],
                'service_breakdown': cost_data['service_breakdown'],
                'cost_trend': cost_data['cost_trend'],
                'optimization_recommendations': recommendations,
                'estimated_savings': cost_data['estimated_savings']
            })
        }
        
    except Exception as e:
        logger.error(f"Cost calculation error: {str(e)}")
        return {
            'statusCode': 500,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            },
            'body': json.dumps({
                'error': 'Cost calculation failed',
                'message': str(e)
            })
        }

def simulate_cost_calculation(start_date, end_date, services):
    """
    Simulate cost calculation (replace with AWS Cost Explorer in production)
    """
    
    # Mock cost data for demonstration
    service_costs = {
        'ec2': 245.67,
        'rds': 123.45,
        'lambda': 45.23,
        's3': 23.12,
        'cloudwatch': 12.34,
        'eks': 89.10,
        'data-transfer': 34.56
    }
    
    # Filter by requested services
    if services:
        service_breakdown = {svc: cost for svc, cost in service_costs.items() if svc in services}
    else:
        service_breakdown = service_costs
    
    total_cost = sum(service_breakdown.values())
    
    # Mock cost trend (last 3 months)
    cost_trend = [
        {'month': '2024-07', 'cost': total_cost * 0.8},
        {'month': '2024-08', 'cost': total_cost * 0.9},
        {'month': '2024-09', 'cost': total_cost}
    ]
    
    # Calculate potential savings (15% optimization)
    estimated_savings = total_cost * 0.15
    
    return {
        'total_cost': round(total_cost, 2),
        'service_breakdown': service_breakdown,
        'cost_trend': cost_trend,
        'estimated_savings': round(estimated_savings, 2)
    }

def generate_optimization_recommendations(cost_data):
    """
    Generate cost optimization recommendations
    """
    recommendations = []
    
    # EC2 optimization
    if cost_data['service_breakdown'].get('ec2', 0) > 100:
        recommendations.append({
            'service': 'ec2',
            'recommendation': 'Consider switching to Spot Instances for non-critical workloads',
            'potential_savings': cost_data['service_breakdown']['ec2'] * 0.3,
            'effort': 'medium'
        })
    
    # RDS optimization
    if cost_data['service_breakdown'].get('rds', 0) > 50:
        recommendations.append({
            'service': 'rds',
            'recommendation': 'Right-size RDS instances based on utilization metrics',
            'potential_savings': cost_data['service_breakdown']['rds'] * 0.2,
            'effort': 'high'
        })
    
    # S3 optimization
    if cost_data['service_breakdown'].get('s3', 0) > 20:
        recommendations.append({
            'service': 's3',
            'recommendation': 'Implement S3 Lifecycle policies to move infrequent access data to Glacier',
            'potential_savings': cost_data['service_breakdown']['s3'] * 0.4,
            'effort': 'low'
        })
    
    return recommendations

# Test function for local development
if __name__ == "__main__":
    test_event = {
        'body': json.dumps({
            'time_range': 'last_30_days',
            'services': ['ec2', 'rds', 'lambda']
        })
    }
    
    result = lambda_handler(test_event, None)
    print(json.dumps(result, indent=2))