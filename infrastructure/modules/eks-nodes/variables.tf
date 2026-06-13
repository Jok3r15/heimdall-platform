# Define the required variables for node group configuration
variable "subnet_ids" {
  description = "List of private subnet IDs for the worker nodes"
  type        = list(string)
}

variable "cluster_name" {
  description = "The name of the EKS cluster to join"
  type        = string
}

variable "security_group_id" {
  description = "The security group ID for the EKS node group"
  type        = string
}
