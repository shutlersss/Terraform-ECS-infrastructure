resource "aws_security_group" "project" {
  name        = "${var.project} SERVER SG"
  description = "Allow all local traffic for ECS"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Environment                                     = "${var.env}"
    Project                                         = "${var.project}"
    Name                                            = "${var.project} SERVER SG"
  }
}

#=========== security group for ALB =============#

resource "aws_security_group" "project_sg_alb" {
  name        = "${var.project} ALB SG"
  description = "Allow trafic from Internet to ports 80, 443 for ALB"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = ["80", "443"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Environment = "${var.env}"
    Project     = "${var.project}"
    Name        = "${var.project} ALB SG"
  }
}
