# ---------------------------------------------------------------------------------------------------------------------
# MODULE PARAMETERS
# These variables are expected to be passed in by the operator
# ---------------------------------------------------------------------------------------------------------------------
variable "domain_name" {
  description = "The domain name to create the certificate for"
  type        = string
  default     = null
}

variable "domain_zone_id" {
  description = "the route53 generated zone"
  type        = string
  default     = "route53-public"
}
