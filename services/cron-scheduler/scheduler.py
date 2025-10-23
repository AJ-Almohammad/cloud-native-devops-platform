import schedule
import time
import requests
import logging
from datetime import datetime
from fastapi import FastAPI
import uvicorn
import threading

# Setup logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('/var/log/cron.log'),
        logging.StreamHandler()
    ]
)
logger = logging.getLogger('cron-scheduler')

app = FastAPI(title="Cron Scheduler Service")

# Health check endpoint
@app.get("/health")
async def health_check():
    return {
        "status": "healthy",
        "service": "cron-scheduler",
        "timestamp": datetime.utcnow().isoformat(),
        "active_jobs": len(schedule.get_jobs())
    }

# Scheduled task: Cleanup old data
def cleanup_old_data():
    logger.info("Running cleanup_old_data task")
    try:
        # Simulate cleanup process
        # In production, this would clean old logs, temp files, etc.
        logger.info("Cleanup completed successfully")
    except Exception as e:
        logger.error(f"Cleanup task failed: {e}")

# Scheduled task: Generate daily reports
def generate_daily_reports():
    logger.info("Running generate_daily_reports task")
    try:
        # Simulate report generation
        # In production, this would call analytics APIs
        logger.info("Daily reports generated successfully")
    except Exception as e:
        logger.error(f"Report generation failed: {e}")

# Scheduled task: Health check other services
def health_check_services():
    logger.info("Running health_check_services task")
    services = [
        "http://content-api:80/health",
        "http://user-service:8000/health",
        "http://analytics-service:3000/health",
        "http://notification-service:8080/health"
    ]
    
    for service_url in services:
        try:
            response = requests.get(service_url, timeout=5)
            if response.status_code == 200:
                logger.info(f"Service {service_url} is healthy")
            else:
                logger.warning(f"Service {service_url} returned status {response.status_code}")
        except Exception as e:
            logger.error(f"Service {service_url} health check failed: {e}")

# Setup scheduled tasks
def setup_schedules():
    # Run every day at 2 AM
    schedule.every().day.at("02:00").do(cleanup_old_data)
    
    # Run every day at 6 AM
    schedule.every().day.at("06:00").do(generate_daily_reports)
    
    # Run every 5 minutes
    schedule.every(5).minutes.do(health_check_services)
    
    logger.info("Scheduled tasks configured")

# Run scheduler in separate thread
def run_scheduler():
    setup_schedules()
    while True:
        schedule.run_pending()
        time.sleep(1)

if __name__ == "__main__":
    # Start scheduler in background thread
    scheduler_thread = threading.Thread(target=run_scheduler, daemon=True)
    scheduler_thread.start()
    
    # Start FastAPI server
    logger.info("Starting cron scheduler service...")
    uvicorn.run(app, host="0.0.0.0", port=8000, log_level="info")