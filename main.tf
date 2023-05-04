terraform {
  required_version = ">= 0.14"
}

provider "aws" {
  region = "us-east-1"
}

# VPC; Subnets
module "network" {
  source   = "./modules/network"
  region   = var.region
  vpc_cidr = var.vpc_cidr
}
