resource "aws_cloudwatch_metric_alarm" "rds_cpu" {
  alarm_name          = "multi-everything-rds-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = "300"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "This metric monitors RDS CPU utilization"
  alarm_actions       = []  # We'll add SNS topic later

  dimensions = {
    DBInstanceIdentifier = "multi-everything-devops-db"
  }

  tags = {
    Name        = "multi-everything-rds-cpu-alarm"
    Environment = var.environment
    Project     = var.project_name
  }
}

/*
#resource "aws_cloudwatch_log_group" "lambda" {
#  name              = "/aws/lambda/multi-everything-ai-moderation"
#  retention_in_days = 30
#
#  tags = {
#    Name        = "multi-everything-lambda-logs"
#    Environment = var.environment
#    Project     = var.project_name
#  }
#}
*/