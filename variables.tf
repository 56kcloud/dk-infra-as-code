variable "region" {
  default = "us-east-1"
}
variable "vpc_cidr" {
  default = "172.16.0.0/16"
}
variable "az_count" {
  default = 2
}
variable "application" {
  default = "amb"
}

variable "rds_instance_class" {
  default = "db.t3.medium"
}
variable "instance_type" {
  default = "t3a.medium"
}

variable "services" {
  type = map(any)
  default = {
    "dbengin" = {
      trg_port          = 80
      srv_port          = 5040
      listener_port     = 5040
      alb               = "int"
      protocol          = "HTTP"
      cpu               = 512
      memory            = 1024
      desired_num_tasks = 2
    },
    "kabasrv" = {
      trg_port          = 80
      srv_port          = 9393
      listener_port     = 9393
      alb               = "int"
      protocol          = "HTTP"
      cpu               = 512
      memory            = 1024
      desired_num_tasks = 2
    },
    "webapi" = {
      trg_port          = 80
      srv_port          = 26264
      listener_port     = 80
      alb               = "pub"
      protocol          = "HTTP"
      cpu               = 512
      memory            = 1024
      desired_num_tasks = 2
    },
    "simat-old" = {
      trg_port          = 80
      srv_port          = 80
      listener_port     = 8080
      alb               = "pub"
      protocol          = "HTTP"
      cpu               = 512
      memory            = 1024
      desired_num_tasks = 2
    },
    "dboperation" = {
      trg_port          = 80
      srv_port          = 5040
      listener_port     = 6060
      alb               = "int"
      protocol          = "HTTP"
      cpu               = 512
      memory            = 1024
      desired_num_tasks = 2
    },
    "reportapi" = {
      name              = "reportapi",
      trg_port          = 80
      srv_port          = 58629
      listener_port     = 58629
      alb               = "pub"
      protocol          = "HTTP"
      cpu               = 512
      memory            = 1024
      desired_num_tasks = 2
    },
    "keydelivery" = {
      trg_port          = 80
      srv_port          = 8001
      listener_port     = 8001
      alb               = "int"
      protocol          = "HTTP"
      cpu               = 512
      memory            = 1024
      desired_num_tasks = 2
    }
  }
}
