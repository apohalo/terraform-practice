variable "region" {
  description = "AWS region to deploy resources"
  type        = string
}

variable "allowed_ip_range" {
  description = "List of IP ranges allowed for SSH and HTTP"
  type        = list(string)
}

variable "project_name" {
  description = "Project name prefix for resources"
  type        = string
  default     = "cmtr-7d8d3336"
}
