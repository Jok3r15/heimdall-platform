resource "aws_security_group" "heimdall_sg" {
  name        = "heimdall-core-sg"
  description = "Core security group for Heimdall Platform"
  vpc_id      = var.vpc_id

  # Rule for inbound HTTPS traffic from the internet
  ingress {
    description = "Allow inbound traffic on port 443"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Rule for internal EKS cluster communication (Control Plane <-> Worker Nodes)
  # 'self = true' allows any resource with this SG to communicate with other resources having the same SG.
  ingress {
    description = "Allow internal EKS communication between nodes and control plane"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  # Rule for outbound traffic
  # checkov:skip=CKV_AWS_382: Allow outbound traffic for EKS node operations
  egress {
    description = "Allow all outbound traffic to internet"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "heimdall-core-sg"
  }
}
