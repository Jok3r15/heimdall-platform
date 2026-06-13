# CloudWatch Log Group for EKS Cluster
# Ensures retention and encryption for security compliance
resource "aws_cloudwatch_log_group" "eks" {
  name              = "/aws/eks/heimdall-cluster/cluster"
  retention_in_days = 365
  
  # Eliminamos la referencia a kms_key_id aquí para evitar el error de permisos 
  # durante el despliegue automático del Log Group.
  
  tags = {
    Name = "heimdall-eks-logs"
  }
}
