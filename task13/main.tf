# Launch Template - Blue
resource "aws_launch_template" "blue_lt" {
  name_prefix   = local.blue_lt_name
  image_id      = var.ami_id
  instance_type = var.instance_type

  tag_specifications {
    resource_type = "instance"
    tags          = merge(local.common_tags, { Name = local.blue_lt_name })
  }
}

# Launch Template - Green
resource "aws_launch_template" "green_lt" {
  name_prefix   = local.green_lt_name
  image_id      = var.ami_id
  instance_type = var.instance_type

  tag_specifications {
    resource_type = "instance"
    tags          = merge(local.common_tags, { Name = local.green_lt_name })
  }
}

# Application Load Balancer
resource "aws_lb" "main_alb" {
  name               = local.alb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = []
  subnets            = var.public_subnet_ids

  tags = merge(local.common_tags, { Name = local.alb_name })
}

# Target Groups
resource "aws_lb_target_group" "blue_tg" {
  name     = local.blue_tg_name
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  tags     = merge(local.common_tags, { Name = local.blue_tg_name })
}

resource "aws_lb_target_group" "green_tg" {
  name     = local.green_tg_name
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  tags     = merge(local.common_tags, { Name = local.green_tg_name })
}

# ALB Listener
resource "aws_lb_listener" "blue_listener" {
  load_balancer_arn = aws_lb.main_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.blue_tg.arn
  }
}

# Blue Auto Scaling Group
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

  tag {
    key                 = "Name"
    value               = local.blue_asg_name
    propagate_at_launch = true
  }

  dynamic "tag" {
    for_each = local.common_tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}

# Green Auto Scaling Group
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

  tag {
    key                 = "Name"
    value               = local.green_asg_name
    propagate_at_launch = true
  }

  dynamic "tag" {
    for_each = local.common_tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}
