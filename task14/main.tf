module "network" {
  source = "./modules/network"

  vpc_cidr     = "10.10.0.0/16"
  subnet_cidrs = ["10.10.1.0/24", "10.10.3.0/24", "10.10.5.0/24"]
  azs          = ["us-east-1a", "us-east-1b", "us-east-1c"]
  vpc_name     = "cmtr-7d8d3336-vpc"
}

module "network_security" {
  source = "./modules/network_security"

  vpc_id           = module.network.vpc_id
  allowed_ip_range = var.allowed_ip_range
}

module "application" {
  source             = "./modules/application"
  project_name       = var.project_name
  vpc_id             = module.network.vpc_id
  subnet_ids         = module.network.public_subnet_ids
  ssh_sg_id          = module.network_security.ssh_sg_id
  public_http_sg_id  = module.network_security.public_http_sg_id
  private_http_sg_id = module.network_security.private_http_sg_id
}
