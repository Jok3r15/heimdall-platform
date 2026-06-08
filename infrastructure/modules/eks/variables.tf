# Define the subnet IDs to be used by the EKS cluster
variable "subnet_ids" {
  description = "List of private subnet IDs for the EKS cluster control plane"
  type        = list(string)
}
