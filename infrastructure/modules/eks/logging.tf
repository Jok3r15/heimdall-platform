# CloudWatch Log Group for EKS Cluster
# Ensures retention and encryption for security compliance
resource "aws_cloudwatch_log_group" "eks" {
  name              = "/aws/eks/heimdall-cluster/cluster"
  retention_in_days = 365
  kms_key_id        = aws_kms_key.eks_secrets.arn

  tags = {
    Name = "heimdall-eks-logs"
  }
}
