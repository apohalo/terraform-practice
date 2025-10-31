variable "region" {
  description = "AWS region to deploy into"
  type        = string
}

variable "ssh_key_name" {
  description = "Name of the existing EC2 key pair to assign to instances"
  type        = string
}

variable "instance_profile_name" {
  description = "Existing IAM instance profile name to attach to instances"
  type        = string
}

variable "ami_id" {
  description = "AMI ID to use for instances"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where resources will be deployed"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs (for ALB and/or public networking)"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs (for ASG instances)"
  type        = list(string)
}

variable "ec2_sg_id" {
  description = "Security Group ID that allows SSH (cmtr-7d8d3336-ec2_sg)"
  type        = string
}

variable "http_sg_id" {
  description = "Security Group ID that allows HTTP to instances (cmtr-7d8d3336-http_sg)"
  type        = string
}

variable "lb_sg_id" {
  description = "Security Group ID that allows HTTP to the Load Balancer (cmtr-7d8d3336-sglb)"
  type        = string
}

variable "s3_bucket_name" {
  description = "S3 bucket name (Cloud Object Storage) where instance will upload generated file"
  type        = string
}

variable "project_tag" {
  description = "Project tag value"
  type        = string
  default     = "cmtr-7d8d3336"
}
