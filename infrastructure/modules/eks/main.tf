# main.tf for EKS cluster module
resource "aws_eks_cluster" "main" {
  name     = "heimdall-cluster"
  # Referencing the resource created in iam.tf
  role_arn = aws_iam_role.eks_cluster.arn 

  vpc_config {
    subnet_ids = var.subnet_ids
  }
}
