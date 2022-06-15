output "tg-arn" {
  value = aws_lb_target_group.target_group.arn
}

output "lb-listner" {
  value = aws_lb_listener.listener
}