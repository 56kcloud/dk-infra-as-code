output "region" {
  value = var.region
}

output "vpc-id" {
  value = aws_vpc.vpc.id
}

output "public-subnet-ids" {
  value = [
    for subnet in aws_subnet.snet-public : subnet.id
  ]
}
