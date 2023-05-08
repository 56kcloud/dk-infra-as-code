# Network terraform module
## Usage
```terraform
module "network" {
  source             = "./modules/vpc"
  name               = "chosen name"
  cidr               = "CIDR VPC"
  private_subnets    = "list of adresses of private subnets"
  public_subnets     = "list of adresses of public subnets"
  availability_zones = "availability zones"
  environment        = "environment"
}
```
