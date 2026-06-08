# Main entry point for the Heimdall Platform
provider "aws" {
  region = "us-east-1"
}

# Network
module "vpc" {
  source   = "./modules/vpc"
  vpc_cidr = "10.0.0.0/16"
}

# Security
module "security_groups" {
  source = "./modules/security-groups"
  vpc_id = module.vpc.vpc_id
}

# EKS Control Plane
module "eks" {
  source             = "./modules/eks"
  private_subnet_ids = module.vpc.private_subnet_ids
}

# EKS Worker Nodes
module "eks_nodes" {
  source             = "./modules/eks-nodes"
  cluster_name       = module.eks.cluster_name
  private_subnet_ids = module.vpc.private_subnet_ids
}
