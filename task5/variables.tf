variable "region" {
  description = "AWS region where resources are located."
  type        = string
  default     = "us-east-1"
}

variable "project_tag" {
  description = "Project identifier tag to apply to resources."
  type        = string
  default     = "cmtr-7d8d3336"
}

variable "vpc_id" {
  description = "ID of the existing VPC (cmtr-7d8d3336-vpc)."
  type        = string
}

variable "public_subnet_id" {
  description = "ID of the public subnet (cmtr-7d8d3336-public-subnet)."
  type        = string
}

variable "private_subnet_id" {
  description = "ID of the private subnet (cmtr-7d8d3336-private-subnet)."
  type        = string
}

variable "public_instance_id" {
  description = "ID of the public EC2 instance (cmtr-7d8d3336-public-instance)."
  type        = string
}

variable "private_instance_id" {
  description = "ID of the private EC2 instance (cmtr-7d8d3336-private-instance)."
  type        = string
}

variable "allowed_ip_range" {
  description = "List of IPv4 CIDR ranges allowed to access the public instance (SSH/HTTP/ICMP)."
  type        = list(string)
}
