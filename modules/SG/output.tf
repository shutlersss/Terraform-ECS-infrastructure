output "sg_id" {
  value = aws_security_group.project.id
}

output "sg_alb_id" {
  value = aws_security_group.project_sg_alb.id
}
