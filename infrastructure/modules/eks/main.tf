# main.tf for EKS cluster module

resource "aws_eks_cluster" "main" {
  name     = "heimdall-cluster"
  role_arn = aws_iam_role.eks_cluster.arn

  vpc_config {
    subnet_ids = var.subnet_ids
  }

  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
}

resource "aws_cloudwatch_log_group" "eks_logs" {
  name              = "/aws/eks/heimdall-cluster/cluster"
  retention_in_days = 365 # Fixes CKV_AWS_338
  
  # Si Checkov sigue pidiendo KMS, puedes añadir esta línea:
  # kms_key_id = <tu_arn_de_kms_opcional>
}
