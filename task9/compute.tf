resource "aws_instance" "this" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t3.micro"
  subnet_id              = data.aws_subnet.public.id
  vpc_security_group_ids = [data.aws_security_group.this.id]

  user_data = <<-EOF
              #!/bin/bash
              dnf update -y
              dnf install -y httpd
              systemctl enable httpd
              systemctl start httpd
              echo "<h1>Hello from ${var.project_id} instance</h1>" > /var/www/html/index.html
              EOF

  tags = {
    Name        = "${var.project_id}-instance"
    Project     = var.project_id
    Environment = "lab"
  }
}
