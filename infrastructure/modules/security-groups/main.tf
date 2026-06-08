resource "aws_security_group" "heimdall_sg" {
  name        = "heimdall-core-sg"
  description = "Core security group for Heimdall Platform"
  vpc_id      = var.vpc_id

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "heimdall-core-sg" }
}
