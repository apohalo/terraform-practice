locals {
  name_prefix = "cmtr-7d8d3336"


  alb_name       = "${local.name_prefix}-lb"
  blue_tg_name   = "${local.name_prefix}-blue-tg"
  green_tg_name  = "${local.name_prefix}-green-tg"
  blue_lt_name   = "${local.name_prefix}-blue-template"
  green_lt_name  = "${local.name_prefix}-green-template"
  blue_asg_name  = "${local.name_prefix}-blue-asg"
  green_asg_name = "${local.name_prefix}-green-asg"


  common_tags = merge({
    Name = local.name_prefix,
    Env  = "blue-green-lab"
  }, var.tags)
}