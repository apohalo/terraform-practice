resource "aws_security_group" "ssh_sg" {
  name        = "cmtr-7d8d3336-ssh-sg"
  vpc_id      = var.vpc_id
  description = "Allow SSH access"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ip_range
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "public_http_sg" {
  name        = "cmtr-7d8d3336-public-http-sg"
  vpc_id      = var.vpc_id
  description = "Allow HTTP access from public"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.allowed_ip_range
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "private_http_sg" {
  name        = "cmtr-7d8d3336-private-http-sg"
  vpc_id      = var.vpc_id
  description = "Allow HTTP from public SG"

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.public_http_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
