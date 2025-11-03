output "load_balancer_dns_name" {
  description = "DNS name of the application load balancer"
  value       = module.application.lb_dns_name
}
