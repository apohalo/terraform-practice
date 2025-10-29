variable "prefix" {
  description = <<EOT
Resource name prefix (short identifier for the task).
Example: cmtr-7d8d3336
EOT
  type        = string
}

variable "region" {
  description = "AWS region to deploy resources into"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnets" {
  description = <<EOT
List of public subnets to create. Each item must contain az, cidr and suffix.
Example: [{ az = "us-east-1a", cidr = "10.10.1.0/24", suffix = "01-subnet-public-a" }, ...]
EOT
  type = list(object({
    az     = string
    cidr   = string
    suffix = string
  }))
}

variable "tags" {
  description = "Map of tags to add to resources"
  type        = map(string)
  default     = {}
}
