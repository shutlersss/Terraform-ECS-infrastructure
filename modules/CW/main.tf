resource "aws_cloudwatch_log_group" "log-group" {
  name = "${var.project}-${var.env}-logs"

  tags = {
    Application = var.project
    Environment = var.env
  }
}