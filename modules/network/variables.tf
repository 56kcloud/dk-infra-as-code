
variable "region" {}
variable "vpc_cidr" {}
variable "public_network_index" {
  default = 40
}
variable "ecs_network_index" {
  default = 50
}
variable "db_network_index" {
  default = 60
}

