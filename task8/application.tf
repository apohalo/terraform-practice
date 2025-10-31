provider "aws" {
  region = var.region
}

locals {
  common_tags = {
    Terraform = "true"
    Project   = var.project_tag
  }

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
    delete_on_termination = true
    security_groups       = [var.ec2_sg_id, var.http_sg_id]
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "optional"
  }

  # --- User Data: установка веб-сервера и создание index.html ---
  user_data = base64encode(<<-EOF
    #!/bin/bash
    set -euxo pipefail

    # Установка веб-сервера
    if command -v yum >/dev/null 2>&1; then
      yum update -y
      yum install -y httpd
      systemctl enable httpd
      systemctl start httpd
      WEB_ROOT="/var/www/html"
    elif command -v apt-get >/dev/null 2>&1; then
      apt-get update -y
      apt-get install -y apache2
      systemctl enable apache2
      systemctl start apache2
      WEB_ROOT="/var/www/html"
    else
      echo "No supported package manager found!" >&2
      exit 1
    fi

    # Получаем Instance ID и Private IP
    TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" \
      -H "X-aws-ec2-metadata-token-ttl-seconds: 21600" -s || true)

    if [ -z "$TOKEN" ]; then
      INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
      PRIVATE_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
    else
      INSTANCE_ID=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" \
        http://169.254.169.254/latest/meta-data/instance-id)
      PRIVATE_IP=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" \
        http://169.254.169.254/latest/meta-data/local-ipv4)
    fi

    # Создаём простую HTML-страницу
    cat > ${WEB_ROOT}/index.html <<HTML
    <!doctype html>
    <html>
      <head><title>Instance Info</title></head>
      <body style="font-family: monospace; background-color: #f0f0f0; padding: 20px;">
        <h2>Instance Info</h2>
        <p><b>Instance ID:</b> ${INSTANCE_ID}</p>
        <p><b>Private IP:</b> ${PRIVATE_IP}</p>
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

# --- Target Group for ALB ---
resource "aws_lb_target_group" "this" {
  name     = "${var.project_tag}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    port                = "80"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 2
    matcher             = "200"
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

# --- Listener for ALB ---
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

# --- Auto Scaling Group ---
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

# --- Optional: Attachment (для совместимости с lab) ---
resource "aws_autoscaling_attachment" "asg_to_tg" {
  autoscaling_group_name = aws_autoscaling_group.this.name
  lb_target_group_arn    = aws_lb_target_group.this.arn
}


