provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "cmtr_bucket" {
  bucket = "cmtr-7d8d3336-bucket-1761723666"

  tags = {
    Project = "cmtr-7d8d3336"
  }
}
