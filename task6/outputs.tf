output "vpc_id" {
  description = "The unique identifier of the VPC"
  value       = aws_vpc.main_vpc.id
}

output "vpc_cidr" {
  description = "The CIDR block associated with the VPC"
  value       = aws_vpc.main_vpc.cidr_block
}

output "public_subnet_ids" {
  description = "A set of IDs for all public subnets"
  value       = [for s in aws_subnet.public_subnets : s.id]
}

output "public_subnet_cidr_block" {
  description = "A set of CIDR blocks for all public subnets"
  value       = [for s in aws_subnet.public_subnets : s.cidr_block]
}

output "public_subnet_availability_zone" {
  description = "A set of availability zones for all public subnets"
  value       = [for s in aws_subnet.public_subnets : s.availability_zone]
}

output "internet_gateway_id" {
  description = "The unique identifier of the Internet Gateway"
  value       = aws_internet_gateway.igw.id
}

output "routing_table_id" {
  description = "The unique identifier of the routing table"
  value       = aws_route_table.public_rt.id
}
