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

variable "openai_api_key" {
  description = "OpenAI API key for AI moderation"
  type        = string
  sensitive   = true
  default     = "dummy-key-for-now"  # We'll set this properly later
}