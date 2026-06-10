# main.tf - Root module configuration

module "vpc" {
  source   = "./modules/vpc"
  vpc_cidr = "10.0.0.0/16"
}

# Add this block to fix the "destroy" issue
module "security_groups" {
  source = "./modules/security-groups"
  vpc_id = module.vpc.vpc_id
}

module "eks" {
  source     = "./modules/eks"
  subnet_ids = module.vpc.private_subnet_ids
}

module "eks_nodes" {
  source       = "./modules/eks-nodes"
  cluster_name = module.eks.cluster_name
  subnet_ids   = module.vpc.private_subnet_ids
}

# Neutralize the default security group to comply with CKV2_AWS_12
resource "aws_default_security_group" "default" {
  vpc_id = module.vpc.vpc_id

  # Clear all ingress and egress rules to lock it down
  ingress = []
  egress  = []
}
