#!/usr/bin/env python3
"""
Cleanup task for Multi-Everything DevOps Platform
Runs every Sunday at 4 AM via cron
"""

import os
import logging
import glob
from datetime import datetime, timedelta

# Setup logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger('cleanup-task')

def cleanup_old_files():
    """Clean up temporary and old files"""
    try:
        logger.info("Starting cleanup task...")
        
        # Define cleanup patterns
        cleanup_patterns = [
            "/tmp/*.tmp",
            "/tmp/*.log",
            "/var/tmp/*.tmp"
        ]
        
        deleted_files = 0
        
        for pattern in cleanup_patterns:
            for filepath in glob.glob(pattern):
                try:
                    # Check if file is older than 7 days
                    file_time = datetime.fromtimestamp(os.path.getctime(filepath))
                    if datetime.now() - file_time > timedelta(days=7):
                        os.remove(filepath)
                        deleted_files += 1
                        logger.info(f"Deleted: {filepath}")
                except Exception as e:
                    logger.warning(f"Could not delete {filepath}: {e}")
        
        logger.info(f"Cleanup completed. Deleted {deleted_files} files.")
        return True
        
    except Exception as e:
        logger.error(f"Cleanup task failed: {e}")
        return False

if __name__ == "__main__":
    cleanup_old_files()