resource "aws_alb" "application_load_balancer" {
  name               = "${var.project}-${var.env}-alb"
  internal           = "${var.internal}"
  load_balancer_type = "${var.load_balancer_type}"
  subnets            = "${var.public_subnet_ids}"
  security_groups    = ["${var.sg_alb_id}"]

  tags = {
    Name        = "${var.project}-alb"
    Environment = var.env
  }
}

resource "aws_lb_target_group" "target_group" {
  name        = "${var.project}-${var.env}-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    healthy_threshold   = "3"
    interval            = "300"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = "/"
    unhealthy_threshold = "2"
  }

  tags = {
    Name        = "${var.project}-lb-tg"
    Environment = var.env
  }
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_alb.application_load_balancer.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.id
  }
}