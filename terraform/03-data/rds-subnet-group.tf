resource "aws_db_subnet_group" "main" {
  name       = "multi-everything-devops-db-subnet-group"
  subnet_ids = data.terraform_remote_state.network.outputs.private_subnet_ids

  tags = {
    Name        = "multi-everything-devops-db-subnet-group"
    Environment = var.environment
    Project     = var.project_name
  }
}