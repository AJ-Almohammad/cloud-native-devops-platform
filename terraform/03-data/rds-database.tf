resource "aws_db_instance" "main" {
  identifier          = "multi-everything-devops-db"
  engine              = "postgres"
  engine_version      = "15.7"
  instance_class      = "db.t3.micro"  # Smallest/cheapest for dev
  allocated_storage   = 20
  storage_type        = "gp2"

  db_name  = "multieverything"
  username = var.db_username
  password = var.db_password

  # We'll get these from network layer
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds.id]

  backup_retention_period = 7
  skip_final_snapshot     = true  # For dev environment

  tags = {
    Name        = "multi-everything-devops-db"
    Environment = "dev"
    Project     = "multi-everything-devops"
  }
}