resource "aws_security_group" "heimdall_sg" {
  name        = "heimdall-core-sg"
  description = "Core security group for Heimdall Platform"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow inbound traffic on port 443" 
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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
