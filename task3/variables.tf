variable "bucket_name" {
  description = "The name of the S3 bucket to be created."
  type        = string
}

variable "region" {
  description = "AWS region where the S3 bucket will be created."
  type        = string
  default     = "us-east-1"
}

variable "project_tag" {
  description = "Project tag for identifying resources."
  type        = string
  default     = "cmtr-7d8d3336"
}
