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

# We'll get these from the network layer outputs
variable "private_subnet_ids" {
  description = "List of private subnet IDs for EKS"
  type        = list(string)
  default     = []
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for load balancers"
  type        = list(string)
  default     = []
}

variable "vpc_id" {
  description = "VPC ID for security groups"
  type        = string
  default     = ""
}