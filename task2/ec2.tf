resource "aws_instance" "cmtr-7d8d3336-ec2" {
  ami           = "ami-07860a2d7eb515d9a" # Amazon Linux 2 (us-east-1)
  instance_type = "t2.micro"

  key_name               = aws_key_pair.cmtr-7d8d3336-keypair.key_name
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]

  tags = {
    Name    = "cmtr-7d8d3336-ec2"
    Project = "epam-tf-lab"
    ID      = "cmtr-7d8d3336"
  }
}
