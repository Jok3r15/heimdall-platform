# main.tf for EKS node group module
resource "aws_eks_node_group" "main" {
  cluster_name    = var.cluster_name
  node_group_name = "heimdall-nodes"
  # Referencing the resource created in iam.tf
  node_role_arn   = aws_iam_role.nodes.arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  instance_types = ["t3.medium"]

  # Bloque remote_access eliminado para evitar el error de parámetro vacío.
  # Si en el futuro necesitas SSH, asegúrate de tener una llave creada en AWS 
  # y pásala a través de una variable.

  # Asegura que las dependencias de IAM estén completas antes de crear los nodos
  depends_on = [
    aws_iam_role_policy_attachment.nodes
  ]
}
