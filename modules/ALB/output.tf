output "tg-arn" {
  value = aws_lb_target_group.target_group.arn
}

output "lb-listner" {
  value = aws_lb_listener.listener
}

output "lb-output" {
  value = aws_alb.application_load_balancer.dns_name
}