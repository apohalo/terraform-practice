provider "aws" {
  region = var.region
}

resource "aws_key_pair" "cmtr-7d8d3336-keypair" {
  key_name   = "cmtr-7d8d3336-keypair"
  public_key = var.ssh_key

  tags = {
    Project = "epam-tf-lab"
    ID      = "cmtr-7d8d3336"
  }
}
