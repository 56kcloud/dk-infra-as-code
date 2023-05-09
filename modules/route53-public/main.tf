# ---------------------------------------------------------------------------------------------------------------------
# CREATE A ROUTE 53 PUBLIC HOSTED ZONE FOR THE PRIMARY DOMAIN NAME
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_route53_zone" "primary_domain" {
  name    = var.primary_domain_name
  comment = var.primary_domain_name_comment
  force_destroy = "false"
}
