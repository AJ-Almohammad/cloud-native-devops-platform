#!/usr/bin/env python3
"""
Log rotation task for Multi-Everything DevOps Platform
Runs daily at 5 AM via cron
"""

import os
import logging
import gzip
import shutil
from datetime import datetime, timedelta

# Setup logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger('log-rotation')

def rotate_logs():
    """Rotate and compress old log files"""
    try:
        logger.info("Starting log rotation task...")
        
        # Define log files to rotate
        log_files = [
            "/var/log/cron.log",
            "/var/log/application.log"
        ]
        
        rotated_count = 0
        
        for log_file in log_files:
            if os.path.exists(log_file) and os.path.getsize(log_file) > 0:
                # Create rotated filename with timestamp
                timestamp = datetime.now().strftime("%Y%m%d")
                rotated_file = f"{log_file}.{timestamp}.gz"
                
                # Compress and rotate the log file
                with open(log_file, 'rb') as f_in:
                    with gzip.open(rotated_file, 'wb') as f_out:
                        shutil.copyfileobj(f_in, f_out)
                
                # Clear the original log file
                open(log_file, 'w').close()
                
                rotated_count += 1
                logger.info(f"Rotated: {log_file} -> {rotated_file}")
        
        # Cleanup old rotated logs (older than 30 days)
        cleanup_old_rotated_logs()
        
        logger.info(f"Log rotation completed. Rotated {rotated_count} files.")
        return True
        
    except Exception as e:
        logger.error(f"Log rotation task failed: {e}")
        return False

def cleanup_old_rotated_logs():
    """Remove rotated logs older than 30 days"""
    try:
        log_dir = "/var/log"
        cutoff_date = datetime.now() - timedelta(days=30)
        
        for filename in os.listdir(log_dir):
            if filename.endswith('.gz') and '.log.' in filename:
                filepath = os.path.join(log_dir, filename)
                file_time = datetime.fromtimestamp(os.path.getctime(filepath))
                
                if file_time < cutoff_date:
                    os.remove(filepath)
                    logger.info(f"Removed old log: {filename}")
                    
    except Exception as e:
        logger.warning(f"Could not cleanup old logs: {e}")

if __name__ == "__main__":
    rotate_logs()