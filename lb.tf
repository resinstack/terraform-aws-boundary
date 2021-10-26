resource "aws_lb" "boundary" {
  name               = "resinstack-boundary"
  load_balancer_type = "network"
  subnets            = var.public_subnets
}

resource "aws_lb_target_group" "controller_internal" {
  name     = "boundary-controller-internal"
  port     = 9201
  protocol = "TCP"
  vpc_id   = var.vpc_id

  deregistration_delay = 30
}

resource "aws_lb_target_group" "controller_external" {
  name     = "boundary-controller-external"
  port     = 9200
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  deregistration_delay = 30
}

resource "aws_lb_target_group" "worker_proxy" {
  name     = "boundary-worker-proxy"
  port     = 9202
  protocol = "TCP"
  vpc_id   = var.vpc_id

  deregistration_delay = 30
}

resource "aws_lb_listener" "controller_internal" {
  load_balancer_arn = aws_lb.boundary.arn
  port              = 9201
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.controller_internal.arn
  }
}

resource "aws_lb_listener" "worker_proxy" {
  load_balancer_arn = aws_lb.boundary.arn
  port              = 9202
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.worker_proxy.arn
  }
}
