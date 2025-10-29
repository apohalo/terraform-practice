output "iam_group_name" {
  description = "The name of the IAM group created."
  value       = aws_iam_group.project_group.name
}

output "iam_role_name" {
  description = "The name of the IAM role created."
  value       = aws_iam_role.ec2_role.name
}

output "iam_instance_profile_name" {
  description = "The name of the IAM instance profile created."
  value       = aws_iam_instance_profile.ec2_instance_profile.name
}

output "iam_policy_arn" {
  description = "The ARN of the custom IAM policy."
  value       = aws_iam_policy.s3_write_policy.arn
}
