provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source       = "./modules/vpc"
  project_name = var.project_name
}

module "alb" {
  source       = "./modules/alb"
  vpc_id       = module.vpc.vpc_id
  subnet_ids   = module.vpc.public_subnet_ids
  project_name = var.project_name
}

module "ec2" {
  source       = "./modules/ec2"
  vpc_id       = module.vpc.vpc_id
  subnet_id    = module.vpc.public_subnet_ids[0]
  ami_id       = var.ami_id
  key_name     = var.key_name
  alb_sg_id    = module.alb.alb_sg_id
  project_name = var.project_name
}

module "rds" {
  source       = "./modules/rds"
  vpc_id       = module.vpc.vpc_id
  subnet_ids   = module.vpc.private_subnet_ids
  ec2_sg_id    = module.ec2.ec2_sg_id
  db_username  = var.db_username
  db_password  = var.db_password
  project_name = var.project_name
}

module "cloudfront_acm" {
  source       = "./modules/cloudfront_acm"
  domain_name  = var.domain_name
  alb_dns      = module.alb.alb_dns_name
  project_name = var.project_name
}

module "monitoring_iam" {
  source          = "./modules/monitoring_iam"
  ec2_instance_id = module.ec2.instance_id
  project_name    = var.project_name
}
