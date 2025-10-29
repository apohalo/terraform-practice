# ========================
# Security Group Outputs
# ========================

output "ssh_security_group_id" {
  description = "ID of the SSH Security Group allowing SSH and ICMP from allowed IP ranges."
  value       = aws_security_group.ssh_sg.id
}

output "public_http_security_group_id" {
  description = "ID of the Public HTTP Security Group allowing HTTP(80) and ICMP from allowed IP ranges."
  value       = aws_security_group.public_http_sg.id
}

output "private_http_security_group_id" {
  description = "ID of the Private HTTP Security Group allowing HTTP(8080) and ICMP from the Public HTTP SG."
  value       = aws_security_group.private_http_sg.id
}

# ========================
# Network Interface Attachments
# ========================

output "public_instance_eni_id" {
  description = "Primary network interface ID of the public instance."
  value       = local.public_eni_id
}

output "private_instance_eni_id" {
  description = "Primary network interface ID of the private instance."
  value       = local.private_eni_id
}

output "public_instance_attached_sg_ids" {
  description = "List of security groups attached to the public instance network interface."
  value = [
    aws_security_group.ssh_sg.id,
    aws_security_group.public_http_sg.id
  ]
}

output "private_instance_attached_sg_ids" {
  description = "List of security groups attached to the private instance network interface."
  value = [
    aws_security_group.ssh_sg.id,
    aws_security_group.private_http_sg.id
  ]
}
