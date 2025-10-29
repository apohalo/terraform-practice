prefix   = "cmtr-7d8d3336"
region   = "us-east-1"
vpc_cidr = "10.10.0.0/16"


public_subnets = [
  {
    az     = "us-east-1a"
    cidr   = "10.10.1.0/24"
    suffix = "01-subnet-public-a"
  },
  {
    az     = "us-east-1b"
    cidr   = "10.10.3.0/24"
    suffix = "01-subnet-public-b"
  },
  {
    az     = "us-east-1c"
    cidr   = "10.10.5.0/24"
    suffix = "01-subnet-public-c"
  }
]