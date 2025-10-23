resource "aws_eks_cluster" "main" {
  name     = "multi-everything-devops-cluster"
  role_arn = aws_iam_role.eks_cluster.arn
  version  = "1.29"

  vpc_config {
    subnet_ids = data.terraform_remote_state.network.outputs.private_subnet_ids
    endpoint_private_access = true
    endpoint_public_access  = true
  }

  tags = {
    Name        = "multi-everything-devops-cluster"
    Environment = "dev"
    Project     = "multi-everything-devops"
  }
}