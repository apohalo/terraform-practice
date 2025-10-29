resource "aws_instance" "web_server" {
  ami           = "ami-07860a2d7eb515d9a" # Example Amazon Linux 2 AMI for us-east-1
  instance_type = "t2.micro"

  subnet_id              = data.terraform_remote_state.base_infra.outputs.public_subnet_id
  vpc_security_group_ids = [data.terraform_remote_state.base_infra.outputs.security_group_id]

  tags = {
    Name      = "${var.project_id}-web"
    Terraform = "true"
    Project   = var.project_id
  }
}
