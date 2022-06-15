output "lb-output" {
  description = "alb dns name."
  value = "http://${module.ALB.lb-output}"
}