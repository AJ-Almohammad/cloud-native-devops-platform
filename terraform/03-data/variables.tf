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

variable "db_username" {
  description = "Database master username"
  type        = string
  default     = "multieverything_admin"
}

variable "db_password" {
  description = "Database master password"
  type        = string
  sensitive   = true
  default     = "temp_password_123"  # We'll change this later
}

# We'll get these from network layer
variable "private_subnet_ids" {
  description = "List of private subnet IDs for RDS"
  type        = list(string)
  default     = []
}

variable "vpc_id" {
  description = "VPC ID for security groups"
  type        = string
  default     = ""
}