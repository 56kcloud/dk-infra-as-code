provider "aws" {}

terraform {
  required_version = ">= 0.14"
  backend "s3" {
    bucket         = "dk-terraform-backend-store"
    encrypt        = true
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock-dynamo"
  }
}

resource "aws_dynamodb_table" "dynamodb-terraform-state-lock" {
  name           = "terraform-state-lock-dynamo"
  hash_key       = "LockID"
  read_capacity  = 20
  write_capacity = 20
  attribute {
    name = "LockID"
    type = "S"
  }
  tags = {
    Name = "DynamoDB Terraform State Lock Table"
  }
}

module "vpc" {
  source             = "./modules/vpc"
  cidr               = var.cidr
  private_subnets    = var.private_subnets
  public_subnets     = var.public_subnets
  availability_zones = var.availability_zones
}

module "security_groups" {
  source         = "./modules/security-groups"
  name           = var.name
  vpc_id         = module.vpc.id
  environment    = var.environment
  container_port = var.container_port
}

module "primary_domain" {
  source                      = "./modules/route53-public"
  primary_domain_name         = var.domain_name
  primary_domain_name_comment = var.comment_domain_name

}

module "generate_certificate" {
  source         = "./modules/acm"
  domain_name    = var.domain_name_cert
  domain_zone_id = module.primary_domain.primary_domain_hosted_zone_id
}

module "alb" {
  source              = "./modules/alb"
  name                = var.name
  vpc_id              = module.vpc.id
  subnets             = module.vpc.public_subnets
  environment         = var.environment
  alb_security_groups = [module.security_groups.alb]
  alb_tls_cert_arn    = var.arn_certificate
  health_check_path   = var.health_check_path
  domain_name         = var.domain_name
  subdomain_name      = "app.${var.domain_name}"
  zone_id             = module.primary_domain.primary_domain_hosted_zone_id
}

module "ecr" {
  source      = "./modules/ecr"
  name        = var.name
  environment = var.environment
}
module "secrets" {
  source              = "./modules/secrets"
  name                = var.name
  environment         = var.environment
  application-secrets = var.application-secrets
}

module "ecs" {
  source                      = "./modules/ecs"
  name                        = var.name
  environment                 = var.environment
  region                      = var.aws-region
  subnets                     = module.vpc.private_subnets
  aws_alb_target_group_arn    = module.alb.aws_alb_target_group_arn
  ecs_service_security_groups = [module.security_groups.ecs_tasks]
  container_port              = var.container_port
  container_cpu               = var.container_cpu
  container_memory            = var.container_memory
  service_desired_count       = var.service_desired_count
  container_environment = [
    { name = "LOG_LEVEL",
    value = "DEBUG" },
    { name = "PORT",
    value = var.container_port }
  ]
  container_secrets      = module.secrets.secrets_map
  container_image        = module.ecr.aws_ecr_repository_url
  container_secrets_arns = module.secrets.application_secrets_arn
}

module "database" {
  source = "./modules/db"
}
