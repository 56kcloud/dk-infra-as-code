output "arn" {
  value = aws_acm_certificate.certificate.arn
}

output "id" {
  value = aws_acm_certificate.certificate.id
}

output "domain_name" {
  value = aws_acm_certificate.certificate.domain_name
}
