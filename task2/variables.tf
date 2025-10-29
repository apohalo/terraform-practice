variable "ssh_key" {
  description = "Provides custom public SSH key."
  type        = string
}

variable "vpc_id" {
  description = "ID of the existing VPC where the EC2 instance will be deployed."
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID where the EC2 instance will be created."
  type        = string
}

variable "security_group_id" {
  description = "ID of the existing security group (cmtr-7d8d3336-sg)."
  type        = string
}

variable "region" {
  description = "AWS region to deploy resources into."
  type        = string
  default     = "us-east-1"
}
