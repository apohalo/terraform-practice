provider "aws" {
  region = var.region
}

resource "aws_s3_bucket" "cmtr_bucket" {
  bucket = var.bucket_name

  tags = {
    Project = var.project_tag
  }
}
