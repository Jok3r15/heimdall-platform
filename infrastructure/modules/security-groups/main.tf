resource "aws_security_group" "heimdall_sg" {
  name        = "heimdall-core-sg"
  description = "Core security group for Heimdall Platform"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow all traffic within the security group (self-reference)" # <--- AGREGADO
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  egress {
    # checkov:skip=CKV_AWS_382: Allow outbound traffic for EKS node operations
    description = "Allow all outbound traffic to internet"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "heimdall-core-sg" }
}
