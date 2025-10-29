variable "region" {
  description = "AWS region for resource deployment"
  type        = string
}

variable "project_tag" {
  description = "Project tag used for naming resources"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
}

variable "public_subnet_azs" {
  description = "List of availability zones for public subnets"
  type        = list(string)
}

variable "az_suffixes" {
  description = "List of AZ suffixes used in naming subnets (a, b, c)"
  type        = list(string)
}
