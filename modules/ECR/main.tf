resource "aws_ecr_repository" "Containers" {
  name = "${var.project}-${var.env}-ecr"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
      Name        = "${var.project}-ecr"
      Environment = var.env
  }
}