resource "aws_kms_key" "rds" {
  description             = "KMS key for RDS encryption"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  tags = {
    Name        = "multi-everything-rds-kms-key"
    Environment = var.environment
    Project     = var.project_name
  }
}

resource "aws_kms_alias" "rds" {
  name          = "alias/multi-everything-rds-key"
  target_key_id = aws_kms_key.rds.key_id
}

resource "aws_kms_key" "lambda" {
  description             = "KMS key for Lambda environment variables"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  tags = {
    Name        = "multi-everything-lambda-kms-key"
    Environment = var.environment
    Project     = var.project_name
  }
}