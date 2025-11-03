locals {
  alb_name    = format("%s-alb", var.project_name)
  alb_sg_name = format("%s-alb-sg", var.project_name)

  blue_lt_name  = format("%s-blue-template", var.project_name)
  green_lt_name = format("%s-green-template", var.project_name)

  blue_asg_name  = format("%s-blue-asg", var.project_name)
  green_asg_name = format("%s-green-asg", var.project_name)

  blue_tg_name  = format("%s-blue-tg", var.project_name)
  green_tg_name = format("%s-green-tg", var.project_name)

  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}
