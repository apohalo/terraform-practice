variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  description = "List of subnet IDs"
  type        = list(string)
}

variable "ssh_sg_id" {
  description = "SSH security group ID"
  type        = string
}

variable "public_http_sg_id" {
  description = "Public HTTP security group ID"
  type        = string
}

variable "private_http_sg_id" {
  description = "Private HTTP security group ID"
  type        = string
}
variable "project_name" {
  description = "Name prefix for project resources"
  type        = string
}

