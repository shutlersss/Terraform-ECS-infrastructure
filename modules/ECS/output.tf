output "cluster-name" {
  value = aws_ecs_cluster.aws-ecs-cluster.name
}

output "service-name" {
  value = aws_ecs_service.aws-ecs-service.name
}