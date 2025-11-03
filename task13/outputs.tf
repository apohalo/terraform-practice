output "alb_dns_name" {
  description = "ALB DNS name to access the application."
  value       = aws_lb.alb.dns_name
}


output "blue_target_group_arn" {
  description = "ARN of the Blue Target Group."
  value       = aws_lb_target_group.blue_tg.arn
}


output "green_target_group_arn" {
  description = "ARN of the Green Target Group."
  value       = aws_lb_target_group.green_tg.arn
}


output "blue_asg_name" {
  description = "Blue ASG name."
  value       = aws_autoscaling_group.blue_asg.name
}


output "green_asg_name" {
  description = "Green ASG name."
  value       = aws_autoscaling_group.green_asg.name
}