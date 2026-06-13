# EKS Cluster resource with security hardening
resource "aws_eks_cluster" "main" {
  name     = "heimdall-cluster"
  role_arn = aws_iam_role.eks_cluster.arn

  # VPC configuration:
  # Habilitamos el acceso público para poder gestionar el clúster con kubectl desde tu local.
  # Mantenemos el acceso privado para que los nodos y servicios internos se comuniquen de forma segura.
  vpc_config {
    subnet_ids              = var.subnet_ids
    endpoint_public_access  = true  # <-- CAMBIADO A TRUE
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
