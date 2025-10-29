variable "aws_region" {
  description = "The AWS region where resources will be created"
  type        = string
}

variable "project_id" {
  description = "The project identifier for tagging resources"
  type        = string
}

variable "state_bucket" {
  description = "The name of the S3 bucket storing the remote Terraform state"
  type        = string
}

variable "state_key" {
  description = "The key (path) to the Terraform state file in the S3 bucket"
  type        = string
}
