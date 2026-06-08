# Export the cluster name so it can be referenced by the eks_nodes module
output "cluster_name" {
  description = "The name of the EKS cluster"
  value       = aws_eks_cluster.main.name
}
