output "security_group_id" {
  description = "The ID of the Heimdall core security group"
  value       = aws_security_group.heimdall_sg.id
}
