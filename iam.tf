locals {
  iam_group_name       = "${var.project_tag}-iam-group"
  iam_policy_name      = "${var.project_tag}-iam-policy"
  iam_role_name        = "${var.project_tag}-iam-role"
  iam_instance_profile = "${var.project_tag}-iam-instance-profile"
}

# IAM Group (tags not supported)
resource "aws_iam_group" "project_group" {
  name = local.iam_group_name
}

# IAM Policy
resource "aws_iam_policy" "s3_write_policy" {
  name        = local.iam_policy_name
  description = "Custom policy granting write access to the specified S3 bucket"

  policy = templatefile("${path.module}/policy.json", {
    bucket_name = var.bucket_name
  })

  tags = {
    Project = var.project_tag
  }
}

# IAM Role
resource "aws_iam_role" "ec2_role" {
  name = local.iam_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Project = var.project_tag
  }
}

# Attach policy to the role
resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.s3_write_policy.arn
}

# Instance Profile
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = local.iam_instance_profile
  role = aws_iam_role.ec2_role.name

  tags = {
    Project = var.project_tag
  }
}
