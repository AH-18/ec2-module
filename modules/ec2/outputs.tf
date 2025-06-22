output "instance_private_ip" {
  description = "The private IP address assigned to the EC2 instance."
  value       = aws_instance.this.private_ip
}

output "instance_public_ip" {
  description = "The public IP address assigned to the EC2 instance."
  value       = aws_instance.this.public_ip
}

output "instance_security_group_id" {
  description = "The ID of the security group associated with the EC2 instance."
  value       = aws_security_group.this.id
}
output "instance_id" {
  description = "the ID of the instance"
  value       = aws_instance.this.id
}