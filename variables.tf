variable "region" {
  description = "AWS region where IAM resources will be created."
  type        = string
}

variable "project_tag" {
  description = "Project tag for identifying resources."
  type        = string
}

variable "bucket_name" {
  description = "The name of the existing S3 bucket for which IAM access will be granted."
  type        = string
}
