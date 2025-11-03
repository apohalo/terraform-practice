variable "aws_region" {
  description = "AWS region to create resources in."
  type        = string
}


variable "vpc_id" {
  description = "VPC id where to create/locate resources."
  type        = string
}


variable "public_subnet_ids" {
  description = "List of public subnet ids to attach the ALB and instances."
  type        = list(string)
}


variable "sg_lb" {
  description = "Security group id for the ALB (allows HTTP)."
  type        = string
}


variable "sg_http" {
  description = "Security group id to attach to instances allowing HTTP."
  type        = string
}


variable "sg_ssh" {
  description = "Security group id to attach to instances allowing SSH."
  type        = string
}


variable "ami_id" {
  description = "AMI id for EC2 instances used in launch templates."
  type        = string
}


variable "instance_type" {
  description = "EC2 instance type for ASG instances."
  type        = string
  default     = "t3.micro"
}


variable "blue_desired_capacity" {
  description = "Desired capacity for the Blue ASG."
  type        = number
  default     = 2
}


variable "green_desired_capacity" {
  description = "Desired capacity for the Green ASG."
  type        = number
  default     = 2
}


variable "blue_weight" {
  description = "The traffic weight for the Blue Target Group. Specifies the percentage of traffic routed to the Blue environment."
  type        = number
  default     = 100
}


variable "green_weight" {
  description = "The traffic weight for the Green Target Group. Specifies the percentage of traffic routed to the Green environment."
  type        = number
  default     = 0
}


variable "tags" {
  description = "Map of tags to apply to all created resources."
  type        = map(string)
  default     = {}
}