resource "aws_security_group" "rds" {
  name        = "multi-everything-devops-rds-sg"
  description = "Security group for RDS database"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id

  ingress {
    description = "PostgreSQL from EKS cluster"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    # We'll restrict this later to specific security groups
    cidr_blocks = ["10.0.0.0/16"]  # Allow from entire VPC for now
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "multi-everything-devops-rds-sg"
    Environment = var.environment
    Project     = var.project_name
  }
}