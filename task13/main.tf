provider "aws" {
  region = var.aws_region
}

# Create an Application Load Balancer
resource "aws_lb" "alb" {
  name               = local.alb_name
  internal           = false
  load_balancer_type = "application"
  subnets            = var.public_subnet_ids
  security_groups    = [var.sg_lb]

  tags = local.common_tags
}

# Target Groups (HTTP on port 80)
resource "aws_lb_target_group" "blue_tg" {
  name     = local.blue_tg_name
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = local.common_tags
}

resource "aws_lb_target_group" "green_tg" {
  name     = local.green_tg_name
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = local.common_tags
}

# Listener with weighted forward
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
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
    }
  }
}

# Launch Templates — user_data generates a simple HTML page
resource "aws_launch_template" "blue_lt" {
  name_prefix   = local.blue_lt_name
  image_id      = var.ami_id
  instance_type = var.instance_type

  vpc_security_group_ids = [var.sg_http, var.sg_ssh]

  tag_specifications {
    resource_type = "instance"
    tags          = local.common_tags
  }

  user_data = base64encode(<<-EOF
    #!/bin/bash
    apt-get update -y || yum update -y
    if command -v apt-get >/dev/null 2>&1; then
      apt-get install -y nginx
      systemctl enable nginx
      systemctl start nginx
    else
      yum install -y httpd
      systemctl enable httpd
      systemctl start httpd
    fi

    echo "<html><h1>Blue Environment</h1></html>" > /var/www/html/index.html
  EOF
  )
}

resource "aws_launch_template" "green_lt" {
  name_prefix   = local.green_lt_name
  image_id      = var.ami_id
  instance_type = var.instance_type

  vpc_security_group_ids = [var.sg_http, var.sg_ssh]

  tag_specifications {
    resource_type = "instance"
    tags          = local.common_tags
  }

  user_data = base64encode(<<-EOF
    #!/bin/bash
    apt-get update -y || yum update -y
    if command -v apt-get >/dev/null 2>&1; then
      apt-get install -y nginx
      systemctl enable nginx
      systemctl start nginx
    else
      yum install -y httpd
      systemctl enable httpd
      systemctl start httpd
    fi

    echo "<html><h1>Green Environment</h1></html>" > /var/www/html/index.html
  EOF
  )
}

# Auto Scaling Groups — attach to corresponding target groups
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

  # Тег Name
  tag {
    key                 = "Name"
    value               = local.blue_asg_name
    propagate_at_launch = true
  }

  # Общие теги
  dynamic "tag" {
    for_each = local.common_tags
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
