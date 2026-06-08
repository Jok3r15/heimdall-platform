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
}
