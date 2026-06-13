# EKS Cluster resource with security hardening
resource "aws_eks_cluster" "main" {
  name     = "heimdall-cluster"
  role_arn = aws_iam_role.eks_cluster.arn

  # VPC configuration
  vpc_config {
    subnet_ids              = var.subnet_ids
    endpoint_public_access  = true 
    endpoint_private_access = true
  }

  # Encryption configuration: enabling secrets encryption at rest
  encryption_config {
    provider {
      key_arn = aws_kms_key.eks_secrets.arn
    }
    resources = ["secrets"]
  }

  # Enable cluster logs for auditing and security monitoring
  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
}

# KMS Key for EKS secrets encryption
resource "aws_kms_key" "eks_secrets" {
  description             = "EKS Secret Encryption Key"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  tags = {
    Name = "heimdall-eks-kms-key"
  }
}

# Data para obtener el certificado del clúster (necesario para el OIDC provider)
data "tls_certificate" "eks" {
  url = aws_eks_cluster.main.identity[0].oidc[0].issuer
}

# OIDC Provider para habilitar IRSA (IAM Roles for Service Accounts)
resource "aws_iam_openid_connect_provider" "eks_oidc" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.main.identity[0].oidc[0].issuer
}
