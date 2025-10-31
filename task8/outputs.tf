output "alb_dns_name" {
  description = "DNS name of the created Application Load Balancer"
  value       = aws_lb.this.dns_name
}

output "asg_name" {
  description = "Auto Scaling Group name"
  value       = aws_autoscaling_group.this.name
}

output "launch_template_id" {
  description = "Launch Template ID"
  value       = aws_launch_template.this.id
}
