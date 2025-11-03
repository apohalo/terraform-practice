locals {
  # Dynamic naming convention
  blue_asg_name  = format("%s-%s-blue-asg", var.project_name, var.environment)
  green_asg_name = format("%s-%s-green-asg", var.project_name, var.environment)

  blue_lt_name  = format("%s-%s-blue-lt", var.project_name, var.environment)
  green_lt_name = format("%s-%s-green-lt", var.project_name, var.environment)

  blue_tg_name  = format("%s-%s-blue-tg", var.project_name, var.environment)
  green_tg_name = format("%s-%s-green-tg", var.project_name, var.environment)

  alb_name = format("%s-%s-alb", var.project_name, var.environment)

  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}
