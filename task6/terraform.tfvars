region      = "us-east-1"
project_tag = "cmtr-7d8d3336"

vpc_cidr = "10.10.0.0/16"

public_subnet_cidrs = [
  "10.10.1.0/24",
  "10.10.3.0/24",
  "10.10.5.0/24"
]

public_subnet_azs = [
  "us-east-1a",
  "us-east-1b",
  "us-east-1c"
]

az_suffixes = ["a", "b", "c"]
