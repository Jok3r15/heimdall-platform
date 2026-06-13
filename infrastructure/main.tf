# main.tf - Root module configuration

module "vpc" {
  source   = "./modules/vpc"
  vpc_cidr = "10.0.0.0/16"
}

module "security_groups" {
  source = "./modules/security-groups"
  vpc_id = module.vpc.vpc_id
}

module "eks" {
  source     = "./modules/eks"
  subnet_ids = module.vpc.private_subnet_ids
}

module "eks_nodes" {
  source            = "./modules/eks-nodes"
  cluster_name      = module.eks.cluster_name
  subnet_ids        = module.vpc.private_subnet_ids
  # Ahora le pasamos el ID que viene del módulo de seguridad
  security_group_id = module.security_groups.security_group_id
}

resource "aws_default_security_group" "default" {
  vpc_id = module.vpc.vpc_id
  ingress = []
  egress  = []
}
