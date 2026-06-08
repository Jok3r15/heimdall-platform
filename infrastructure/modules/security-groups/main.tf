# Security group for the platform's core services
resource "aws_security_group" "heimdall_sg" {
  name        = "heimdall-core-sg"
  description = "Core security group for Heimdall Platform"
  vpc_id      = var.vpc_id

  # Allow internal traffic between members of this security group
  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  # Egress: allow all outbound traffic to internet
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "heimdall-core-sg" }
}
