# ---------------------------------------------------------------------------------------------------------------------
# MODULE PARAMETERS
# These variables are expected to be passed in by the operator
# ---------------------------------------------------------------------------------------------------------------------
variable "primary_domain_name" {
  description = "The primary domain name (e.g. foo.com) for which to create a Route 53 Public Hosted Zone."
  type        = string
}

# ---------------------------------------------------------------------------------------------------------------------
# DEFINE CONSTANTS
# Generally, these values won't need to be changed.
# ---------------------------------------------------------------------------------------------------------------------

variable "primary_domain_name_comment" {
  description = "A comment or description of the domain name in var.primary_domain_name."
  type        = string
  default     = "Hosted zone managed by Terraform"
}
