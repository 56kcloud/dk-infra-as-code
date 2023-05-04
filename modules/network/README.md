# Network terraform module
## Usage
```terraform
module "network" {
  source               = "./modules/network"
  region               = "aws chosen region"
  vpc_cidr             = "vpc CIDR"
}
```
