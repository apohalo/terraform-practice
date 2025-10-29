output "vpc_id" {
  description = "ID of the created VPC"
  value       = aws_vpc.this.id
}


output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = values(aws_subnet.public)[*].id
}


output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.igw.id
}