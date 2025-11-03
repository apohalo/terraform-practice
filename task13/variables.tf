variable "region" {
  type        = string
  description = "AWS region"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID for ASG and Load Balancer"
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "List of public subnet IDs"
}

variable "instance_type" {
  type        = string
  description = "Instance type"
}

variable "ami_id" {
  type        = string
  description = "AMI ID for EC2 instances"
}

variable "environment" {
  type        = string
  description = "Deployment environment (e.g. dev, prod)"
}

variable "blue_desired_capacity" {
  type        = number
  description = "Desired capacity for blue ASG"
}

variable "green_desired_capacity" {
  type        = number
  description = "Desired capacity for green ASG"
}

variable "project_name" {
  type        = string
  description = "Project name prefix"
}
