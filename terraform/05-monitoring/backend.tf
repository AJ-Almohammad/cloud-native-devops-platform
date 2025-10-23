terraform {
  backend "s3" {
    bucket         = "multi-everything-devops-terraform-state-171158265889"
    key            = "monitoring/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "multi-everything-devops-terraform-locks"
    encrypt        = true
  }
}