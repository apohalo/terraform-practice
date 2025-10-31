provider "aws" {
  region = var.region
}

locals {
  common_tags = {
    Terraform = "true"
    Project   = var.project_tag
  }

  # Launch template name and other resource names required by the lab
  lt_name  = "cmtr-7d8d3336-template"
  asg_name = "cmtr-7d8d3336-asg"
  alb_name = "cmtr-7d8d3336-loadbalancer"
}

# --- Launch Template ---
resource "aws_launch_template" "this" {
  name          = local.lt_name
  image_id      = var.ami_id
  instance_type = "t3.micro"
  iam_instance_profile {
    name = var.instance_profile_name
  }
  key_name = var.ssh_key_name

  network_interfaces {
    # network interfaces will be created on instance launch; we set delete_on_termination
    delete_on_termination = true
    security_groups       = [var.ec2_sg_id, var.http_sg_id]
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "optional"
  }

  user_data = base64encode(<<-EOF
  #!/usr/bin/env bash
  set -euo pipefail

  TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600" -s)
  if [ -z "$${TOKEN}" ]; then
    INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
    PRIVATE_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
  else
    INSTANCE_ID=$(curl -s -H "X-aws-ec2-metadata-token: $${TOKEN}" http://169.254.169.254/latest/meta-data/instance-id)
    PRIVATE_IP=$(curl -s -H "X-aws-ec2-metadata-token: $${TOKEN}" http://169.254.169.254/latest/meta-data/local-ipv4)
  fi

  mkdir -p /var/www/html
  cat >/var/www/html/index.html <<HTML
  <!doctype html>
  <html>
    <head><title>Instance info</title></head>
    <body>
      <pre>This message was generated on instance $${INSTANCE_ID} with the following IP: $${PRIVATE_IP}</pre>
    </body>
  </html>
  HTML
EOF
  )

  tag_specifications {
    resource_type = "instance"
    tags          = local.common_tags
  }

  tags = local.common_tags
}

# --- Target group for ALB ---
resource "aws_lb_target_group" "this" {
  name     = "${var.project_tag}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check {
    path                = "/"
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
  }

  tags = local.common_tags
}

# --- Application Load Balancer ---
resource "aws_lb" "this" {
  name               = local.alb_name
  internal           = false
  load_balancer_type = "application"
  subnets            = var.public_subnet_ids
  security_groups    = [var.lb_sg_id]

  tags = local.common_tags
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

# --- Auto Scaling Group using Launch Template ---
resource "aws_autoscaling_group" "this" {
  name                = local.asg_name
  desired_capacity    = 2
  max_size            = 2
  min_size            = 1
  vpc_zone_identifier = var.private_subnet_ids
  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.this.arn]

  tag {
    key                 = "Name"
    value               = local.asg_name
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

  lifecycle {
    ignore_changes = [
      load_balancers,
      target_group_arns,
    ]
  }
}


# --- Attachment resource (optional) to link ALB to ASG using classic ELB names OR target groups ---
# Not strictly necessary since we set target_group_arns on ASG; keep for lab compatibility if needed.
resource "aws_autoscaling_attachment" "asg_to_tg" {
  autoscaling_group_name = aws_autoscaling_group.this.name
  lb_target_group_arn    = aws_lb_target_group.this.arn
}


# --- Output whether we have ALB DNS name and ASG name ---
