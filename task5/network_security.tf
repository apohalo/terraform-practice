provider "aws" {
  region = var.region
}

locals {
  ssh_sg_name          = "${var.project_tag}-ssh-sg"
  public_http_sg_name  = "${var.project_tag}-public-http-sg"
  private_http_sg_name = "${var.project_tag}-private-http-sg"
}

# --- Data sources for existing EC2 instances ---
data "aws_instance" "public_instance" {
  instance_id = var.public_instance_id
}

data "aws_instance" "private_instance" {
  instance_id = var.private_instance_id
}

# ============================================================
# 1) SSH Security Group
# ============================================================

resource "aws_security_group" "ssh_sg" {
  name        = local.ssh_sg_name
  description = "Allow SSH and ICMP from allowed IP ranges"
  vpc_id      = var.vpc_id

  tags = {
    Project = var.project_tag
    Name    = local.ssh_sg_name
  }
}

# Allow SSH (port 22) from allowed ranges
resource "aws_security_group_rule" "ssh_ingress_ssh" {
  description       = "Allow SSH from allowed ranges"
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = var.allowed_ip_range
  security_group_id = aws_security_group.ssh_sg.id
}

# Allow ICMP from allowed ranges
resource "aws_security_group_rule" "ssh_ingress_icmp" {
  description       = "Allow ICMP from allowed ranges"
  type              = "ingress"
  from_port         = -1
  to_port           = -1
  protocol          = "icmp"
  cidr_blocks       = var.allowed_ip_range
  security_group_id = aws_security_group.ssh_sg.id
}

# ============================================================
# 2) Public HTTP Security Group
# ============================================================

resource "aws_security_group" "public_http_sg" {
  name        = local.public_http_sg_name
  description = "Allow HTTP (80) and ICMP from allowed IP ranges"
  vpc_id      = var.vpc_id

  tags = {
    Project = var.project_tag
    Name    = local.public_http_sg_name
  }
}

# Allow HTTP (port 80) from allowed IPs
resource "aws_security_group_rule" "public_http_ingress_http" {
  description       = "Allow HTTP from allowed ranges"
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = var.allowed_ip_range
  security_group_id = aws_security_group.public_http_sg.id
}

# Allow ICMP from allowed IPs
resource "aws_security_group_rule" "public_http_ingress_icmp" {
  description       = "Allow ICMP from allowed ranges"
  type              = "ingress"
  from_port         = -1
  to_port           = -1
  protocol          = "icmp"
  cidr_blocks       = var.allowed_ip_range
  security_group_id = aws_security_group.public_http_sg.id
}

# ============================================================
# 3) Private HTTP Security Group (only from Public HTTP SG)
# ============================================================

resource "aws_security_group" "private_http_sg" {
  name        = local.private_http_sg_name
  description = "Allow HTTP (8080) and ICMP from the public-http security group only"
  vpc_id      = var.vpc_id

  tags = {
    Project = var.project_tag
    Name    = local.private_http_sg_name
  }
}

# Allow HTTP 8080 from the Public HTTP SG
resource "aws_security_group_rule" "private_http_from_public_http" {
  description              = "Allow HTTP 8080 from public-http SG"
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = aws_security_group.private_http_sg.id
  source_security_group_id = aws_security_group.public_http_sg.id
}

# Allow ICMP from Public HTTP SG
resource "aws_security_group_rule" "private_icmp_from_public_http" {
  description              = "Allow ICMP from public-http SG"
  type                     = "ingress"
  from_port                = -1
  to_port                  = -1
  protocol                 = "icmp"
  security_group_id        = aws_security_group.private_http_sg.id
  source_security_group_id = aws_security_group.public_http_sg.id
}

# ============================================================
# Attach Security Groups to Instance Network Interfaces
# ============================================================

# Use data sources to extract ENI IDs (primary interface)
locals {
  public_eni_id  = try(data.aws_instance.public_instance.network_interface_id, null)
  private_eni_id = try(data.aws_instance.private_instance.network_interface_id, null)
}

# Attach SSH and Public HTTP SGs to Public Instance
resource "aws_network_interface_sg_attachment" "attach_ssh_to_public" {
  network_interface_id = local.public_eni_id
  security_group_id    = aws_security_group.ssh_sg.id
}

resource "aws_network_interface_sg_attachment" "attach_public_http_to_public" {
  network_interface_id = local.public_eni_id
  security_group_id    = aws_security_group.public_http_sg.id
}

# Attach SSH and Private HTTP SGs to Private Instance
resource "aws_network_interface_sg_attachment" "attach_ssh_to_private" {
  network_interface_id = local.private_eni_id
  security_group_id    = aws_security_group.ssh_sg.id
}

resource "aws_network_interface_sg_attachment" "attach_private_http_to_private" {
  network_interface_id = local.private_eni_id
  security_group_id    = aws_security_group.private_http_sg.id
}
