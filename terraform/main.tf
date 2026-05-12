data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  subnet_count = max(length(var.public_subnet_cidrs), length(var.private_subnet_cidrs))
  azs          = length(var.availability_zones) > 0 ? var.availability_zones : slice(data.aws_availability_zones.available.names, 0, local.subnet_count)
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source               = "./modules/vpc"
  project_name         = var.project_name
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = local.azs
  tags                 = local.common_tags
}

module "security_group" {
  source       = "./modules/security_group"
  project_name = var.project_name
  environment  = var.environment
  vpc_id       = module.vpc.vpc_id
  my_ip_cidr   = var.my_ip_cidr
  tags         = local.common_tags
}

module "ec2" {
  source                = "./modules/ec2"
  project_name          = var.project_name
  environment           = var.environment
  public_subnet_id      = module.vpc.public_subnet_ids[0]
  private_subnet_id     = module.vpc.private_subnet_ids[0]
  bastion_sg_id         = module.security_group.public_sg_id
  private_node_sg_id    = module.security_group.private_sg_id
  bastion_instance_type = var.bastion_instance_type
  private_instance_type = var.private_instance_type
  key_name              = var.key_name
  tags                  = local.common_tags
}
