# main.tf - Root module configuration

# Data to retrieve the AWS Account ID
data "aws_caller_identity" "current" {}

# 1. Base infrastructure modules
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
  security_group_id = module.security_groups.security_group_id
}

# 2. S3 Bucket for secure access testing
resource "aws_s3_bucket" "heimdall_data" {
  bucket = "heimdall-secure-data-${data.aws_caller_identity.current.account_id}"

  tags = {
    Name = "heimdall-secure-data"
  }
}

# 3. IAM Role for Kubernetes ServiceAccount (IRSA)
resource "aws_iam_role" "s3_read_role" {
  name = "heimdall-s3-read-role"

  # Trust policy allowing OIDC provider to assume this role
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Principal = {
          Federated = module.eks.oidc_provider_arn
        }
        Condition = {
          StringEquals = {
            "${replace(module.eks.oidc_provider_url, "https://", "")}:sub" = "system:serviceaccount:default:s3-reader-sa"
          }
        }
      }
    ]
  })
}

# 4. IAM Policy with read and write permissions for the bucket
resource "aws_iam_policy" "s3_read_policy" {
  name = "heimdall-s3-read-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = ["s3:ListBucket", "s3:GetObject", "s3:PutObject"]
        Effect = "Allow"
        Resource = [
          aws_s3_bucket.heimdall_data.arn,
          "${aws_s3_bucket.heimdall_data.arn}/*"
        ]
      }
    ]
  })
}

# 5. Attach the policy to the role
resource "aws_iam_role_policy_attachment" "s3_read_attach" {
  role       = aws_iam_role.s3_read_role.name
  policy_arn = aws_iam_policy.s3_read_policy.arn
}

resource "aws_default_security_group" "default" {
  vpc_id = module.vpc.vpc_id
  ingress = []
  egress  = []
}
