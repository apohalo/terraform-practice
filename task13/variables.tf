variable "aws_region" {
  description = "AWS region to deploy resources in."
  type        = string
}

variable "project_name" {
  description = "Base name prefix for all resources."
  type        = string
}

variable "environment" {
  description = "Deployment environment name (e.g., dev, prod)."
  type        = string
}

variable "vpc_id" {
  description = "ID of the existing VPC."
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs used for load balancer and ASGs."
  type        = list(string)
}

variable "ami_id" {
  description = "AMI ID for EC2 instances."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for launch templates."
  type        = string
}

variable "blue_desired_capacity" {
  description = "Number of instances in Blue Auto Scaling Group."
  type        = number
}

variable "green_desired_capacity" {
  description = "Number of instances in Green Auto Scaling Group."
  type        = number
}

# Traffic Weights
variable "blue_weight" {
  description = "Traffic weight for the Blue Target Group (percentage)."
  type        = number
}

variable "green_weight" {
  description = "Traffic weight for the Green Target Group (percentage)."
  type        = number
}
