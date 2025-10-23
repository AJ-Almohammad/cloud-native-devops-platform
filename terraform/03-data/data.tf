# Get network layer outputs from remote state
data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "multi-everything-devops-terraform-state-171158265889"
    key    = "network/terraform.tfstate"
    region = "eu-central-1"
  }
}