variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-central-1"
}

variable "project_name" {
  description = "Project name for resource tagging"
  type        = string
  default     = "multi-everything-devops"
}

variable "environment" {
  description = "Environment (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "alert_email" {
  description = "Email address for receiving alerts"
  type        = string
  default     = "alerts@example.com"
}

variable "rds_cpu_threshold" {
  description = "CPU threshold percentage for RDS alarms"
  type        = number
  default     = 80
}