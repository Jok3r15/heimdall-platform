# Export the cluster name so it can be referenced by the eks_nodes module
output "cluster_name" {
  description = "The name of the EKS cluster"
  value       = aws_eks_cluster.main.name
}

# Export the OIDC Provider ARN so the root module can create IAM roles for Service Accounts
output "oidc_provider_arn" {
  description = "The ARN of the OIDC Provider"
  value       = aws_iam_openid_connect_provider.eks_oidc.arn
}

# Export the OIDC Provider URL so the root module can construct the trust policy
output "oidc_provider_url" {
  description = "The URL of the OIDC Provider"
  value       = aws_iam_openid_connect_provider.eks_oidc.url
}
