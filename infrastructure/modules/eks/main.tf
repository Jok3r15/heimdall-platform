resource "aws_eks_cluster" "main" {
  name     = "heimdall-cluster"
  role_arn = aws_iam_role.eks_cluster.arn

  vpc_config {
    subnet_ids = var.private_subnet_ids
  }

  depends_on = [aws_iam_role_policy_attachment.eks_cluster_policy]
}

