provider "aws" {
  region = var.region
}


# Note: per task requirements we do NOT configure a remote backend here
# Terraform will use the default local backend (terraform.tfstate) unless
# you explicitly configure a backend outside this repo.


locals {
  vpc_name = "${var.prefix}-01-vpc"
  igw_name = "${var.prefix}-01-igw"
  rt_name  = "${var.prefix}-01-rt"
}