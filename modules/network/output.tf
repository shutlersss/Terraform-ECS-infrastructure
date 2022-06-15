output "vpc_id" {
  value = aws_vpc.project.id
}

output "public_subnet_ids" {
  value = aws_subnet.public_subnets[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private_subnets[*].id
}

output "data_az" {
  value = local.az_list
}

output "private_subnet_id" {
  value = local.private_subnet_id
}
