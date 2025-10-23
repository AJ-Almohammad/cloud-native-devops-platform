import json
import boto3
import logging
import os
import urllib.parse
from PIL import Image
import io

# Setup logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

# AWS clients
s3_client = boto3.client('s3')
rekognition_client = boto3.client('rekognition')

def lambda_handler(event, context):
    """
    Image Processor Lambda Function
    Processes images uploaded to S3 - resizing, optimization, and moderation
    """
    
    try:
        logger.info("Starting image processing")
        
        # Parse S3 event
        for record in event['Records']:
            # Get bucket and key from S3 event
            bucket = record['s3']['bucket']['name']
            key = urllib.parse.unquote_plus(record['s3']['object']['key'], encoding='utf-8')
            
            logger.info(f"Processing image: s3://{bucket}/{key}")
            
            # Validate file type
            if not is_image_file(key):
                logger.warning(f"File {key} is not an image, skipping processing")
                continue
            
            # Process the image
            process_image(bucket, key)
            
        logger.info("Image processing completed successfully")
        
        return {
            'statusCode': 200,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            },
            'body': json.dumps({
                'status': 'success',
                'message': 'Images processed successfully',
                'processed_count': len(event['Records'])
            })
        }
        
    except Exception as e:
        logger.error(f"Image processing error: {str(e)}")
        return {
            'statusCode': 500,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            },
            'body': json.dumps({
                'error': 'Image processing failed',
                'message': str(e)
            })
        }

def is_image_file(filename):
    """Check if file is an image based on extension"""
    image_extensions = {'.jpg', '.jpeg', '.png', '.gif', '.bmp', '.webp'}
    file_ext = os.path.splitext(filename)[1].lower()
    return file_ext in image_extensions

def process_image(bucket, key):
    """
    Process individual image: resize, optimize, and moderate
    """
    try:
        # Download image from S3
        response = s3_client.get_object(Bucket=bucket, Key=key)
        image_data = response['Body'].read()
        
        # Open image with PIL
        image = Image.open(io.BytesIO(image_data))
        
        # Get original dimensions
        original_width, original_height = image.size
        logger.info(f"Original image size: {original_width}x{original_height}")
        
        # Perform content moderation
        moderation_result = moderate_image(bucket, key)
        
        if moderation_result.get('is_appropriate', True):
            # Generate different sizes
            sizes = {
                'thumbnail': (150, 150),
                'small': (400, 400),
                'medium': (800, 800),
                'large': (1200, 1200)
            }
            
            processed_images = {}
            
            for size_name, dimensions in sizes.items():
                processed_image = resize_image(image, dimensions)
                processed_key = generate_processed_key(key, size_name)
                
                # Upload processed image to S3
                upload_to_s3(processed_image, bucket, processed_key)
                
                processed_images[size_name] = {
                    'key': processed_key,
                    'dimensions': dimensions,
                    'size_kb': len(processed_image) / 1024
                }
            
            # Update metadata
            update_image_metadata(bucket, key, {
                'processed': True,
                'original_dimensions': f"{original_width}x{original_height}",
                'processed_versions': list(sizes.keys()),
                'moderation_status': 'approved',
                'moderation_confidence': moderation_result.get('confidence', 1.0)
            })
            
            logger.info(f"Image processed successfully: {len(processed_images)} versions created")
            
        else:
            # Image failed moderation
            handle_inappropriate_image(bucket, key, moderation_result)
            
    except Exception as e:
        logger.error(f"Failed to process image {key}: {str(e)}")
        raise

def resize_image(image, dimensions):
    """Resize image to specified dimensions while maintaining aspect ratio"""
    try:
        # Calculate new dimensions maintaining aspect ratio
        original_width, original_height = image.size
        target_width, target_height = dimensions
        
        # Calculate scaling factor
        width_ratio = target_width / original_width
        height_ratio = target_height / original_height
        scaling_factor = min(width_ratio, height_ratio)
        
        new_width = int(original_width * scaling_factor)
        new_height = int(original_height * scaling_factor)
        
        # Resize image
        resized_image = image.resize((new_width, new_height), Image.Resampling.LANCZOS)
        
        # Convert to bytes
        output_buffer = io.BytesIO()
        resized_image.save(output_buffer, format='JPEG', quality=85, optimize=True)
        
        return output_buffer.getvalue()
        
    except Exception as e:
        logger.error(f"Image resize failed: {str(e)}")
        raise

def moderate_image(bucket, key):
    """
    Moderate image content using AWS Rekognition
    """
    try:
        # Use Rekognition for content moderation
        response = rekognition_client.detect_moderation_labels(
            Image={'S3Object': {'Bucket': bucket, 'Name': key}},
            MinConfidence=70.0
        )
        
        moderation_labels = response.get('ModerationLabels', [])
        
        if moderation_labels:
            logger.warning(f"Image moderation found issues: {moderation_labels}")
            return {
                'is_appropriate': False,
                'moderation_labels': [label['Name'] for label in moderation_labels],
                'confidence': max([label['Confidence'] for label in moderation_labels]) if moderation_labels else 0
            }
        else:
            return {
                'is_appropriate': True,
                'moderation_labels': [],
                'confidence': 95.0  # Default confidence for approved images
            }
            
    except Exception as e:
        logger.warning(f"Rekognition moderation failed: {str(e)}")
        # Fallback: assume image is appropriate if moderation fails
        return {'is_appropriate': True, 'confidence': 50.0}

def generate_processed_key(original_key, size_name):
    """Generate S3 key for processed image"""
    directory, filename = os.path.split(original_key)
    name, ext = os.path.splitext(filename)
    return f"{directory}/processed/{size_name}/{name}{ext}"

def upload_to_s3(image_data, bucket, key):
    """Upload processed image to S3"""
    s3_client.put_object(
        Bucket=bucket,
        Key=key,
        Body=image_data,
        ContentType='image/jpeg',
        CacheControl='max-age=31536000'  # 1 year cache
    )

def update_image_metadata(bucket, key, metadata):
    """Update image metadata in S3"""
    try:
        s3_client.copy_object(
            Bucket=bucket,
            Key=key,
            CopySource={'Bucket': bucket, 'Key': key},
            Metadata=metadata,
            MetadataDirective='REPLACE'
        )
    except Exception as e:
        logger.warning(f"Failed to update metadata: {str(e)}")

def handle_inappropriate_image(bucket, key, moderation_result):
    """Handle images that fail content moderation"""
    logger.warning(f"Image failed moderation: {key}")
    
    # Move to quarantine bucket/folder
    quarantine_bucket = os.environ.get('QUARANTINE_BUCKET', bucket)
    quarantine_key = f"quarantine/{os.path.basename(key)}"
    
    try:
        s3_client.copy_object(
            Bucket=quarantine_bucket,
            Key=quarantine_key,
            CopySource={'Bucket': bucket, 'Key': key}
        )
        
        # Delete original from main bucket
        s3_client.delete_object(Bucket=bucket, Key=key)
        
        logger.info(f"Inappropriate image moved to quarantine: {quarantine_key}")
        
    except Exception as e:
        logger.error(f"Failed to quarantine image: {str(e)}")

# Test function for local development
if __name__ == "__main__":
    # Simulate S3 event
    test_event = {
        'Records': [
            {
                's3': {
                    'bucket': {'name': 'test-bucket'},
                    'object': {'key': 'uploads/image.jpg'}
                }
            }
        ]
    }
    
    result = lambda_handler(test_event, None)
    print(json.dumps(result, indent=2))