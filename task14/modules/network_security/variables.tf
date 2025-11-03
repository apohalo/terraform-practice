variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "allowed_ip_range" {
  description = "Allowed IPs for ingress"
  type        = list(string)
}
