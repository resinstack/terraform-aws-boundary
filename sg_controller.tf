resource "aws_security_group" "controller" {
  name        = "boundary-controller"
  description = "Boundary Controller rules"
  vpc_id      = var.vpc_id

  tags = {
    "resinstack:cluster" = var.cluster_tag
  }
}

resource "aws_security_group_rule" "accept_traffic_from_sources" {
  for_each = var.source_sgs

  description       = "Accept API traffic from ${each.key}"
  security_group_id = aws_security_group.controller.id

  type      = "ingress"
  from_port = 9200
  to_port   = 9200
  protocol  = "tcp"

  source_security_group_id = each.value
}

resource "aws_security_group_rule" "accept_control_from_workers" {
  description       = "Accept worker-controller traffic from workers"
  security_group_id = aws_security_group.controller.id

  type      = "ingress"
  from_port = 9201
  to_port   = 9201
  protocol  = "tcp"

  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "permit_postgres_to_db" {
  description       = "Permit controller traffic to db"
  security_group_id = aws_security_group.controller.id

  type      = "egress"
  from_port = 5432
  to_port   = 5432
  protocol  = "tcp"

  source_security_group_id = var.database_sg
}
