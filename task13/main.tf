provider "aws" {
  region = var.aws_region
}

####################################
# Data sources
####################################
data "aws_vpc" "selected" {
  id = var.vpc_id
}

data "aws_subnet" "public" {
  for_each = toset(var.public_subnet_ids)
  id       = each.value
}

####################################
# Security Group for ALB
####################################
resource "aws_security_group" "alb_sg" {
  name        = local.alb_sg_name
  description = "Allow HTTP access to ALB"
  vpc_id      = data.aws_vpc.selected.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.common_tags
}

####################################
# Launch Templates
####################################
resource "aws_launch_template" "blue_lt" {
  name_prefix   = local.blue_lt_name
  image_id      = var.ami_id
  instance_type = var.instance_type
  user_data     = base64encode(file("${path.module}/user_data_blue.sh"))

  tag_specifications {
    resource_type = "instance"
    tags = merge(local.common_tags, {
      Name = "${local.blue_lt_name}-instance"
    })
  }

  tags = local.common_tags
}

resource "aws_launch_template" "green_lt" {
  name_prefix   = local.green_lt_name
  image_id      = var.ami_id
  instance_type = var.instance_type
  user_data     = base64encode(file("${path.module}/user_data_green.sh"))

  tag_specifications {
    resource_type = "instance"
    tags = merge(local.common_tags, {
      Name = "${local.green_lt_name}-instance"
    })
  }

  tags = local.common_tags
}

####################################
# Load Balancer + Target Groups
####################################
resource "aws_lb" "app_lb" {
  name               = local.alb_name
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = var.public_subnet_ids

  tags = local.common_tags
}

resource "aws_lb_target_group" "blue_tg" {
  name     = local.blue_tg_name
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.selected.id

  health_check {
    path = "/"
  }

  tags = local.common_tags
}

resource "aws_lb_target_group" "green_tg" {
  name     = local.green_tg_name
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.selected.id

  health_check {
    path = "/"
  }

  tags = local.common_tags
}

####################################
# Listener with Weighted Forwarding
####################################
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "forward"

    forward {
      target_group {
        arn    = aws_lb_target_group.blue_tg.arn
        weight = var.blue_weight
      }

      target_group {
        arn    = aws_lb_target_group.green_tg.arn
        weight = var.green_weight
      }

      stickiness {
        enabled  = false
        duration = 0
      }
    }
  }
}

####################################
# Auto Scaling Groups
####################################
resource "aws_autoscaling_group" "blue_asg" {
  name                = local.blue_asg_name
  vpc_zone_identifier = var.public_subnet_ids
  desired_capacity    = var.blue_desired_capacity
  max_size            = var.blue_desired_capacity
  min_size            = var.blue_desired_capacity

  launch_template {
    id      = aws_launch_template.blue_lt.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.blue_tg.arn]

  lifecycle {
    create_before_destroy = true
  }

  dynamic "tag" {
    for_each = merge(local.common_tags, { Name = local.blue_asg_name })
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}

resource "aws_autoscaling_group" "green_asg" {
  name                = local.green_asg_name
  vpc_zone_identifier = var.public_subnet_ids
  desired_capacity    = var.green_desired_capacity
  max_size            = var.green_desired_capacity
  min_size            = var.green_desired_capacity

  launch_template {
    id      = aws_launch_template.green_lt.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.green_tg.arn]

  lifecycle {
    create_before_destroy = true
  }

  dynamic "tag" {
    for_each = merge(local.common_tags, { Name = local.green_asg_name })
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}
