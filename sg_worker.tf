resource "aws_security_group" "worker" {
  name        = "boundary-worker"
  description = "Boundary worker rules"
  vpc_id      = var.vpc_id

  tags = {
    "resinstack:cluster" = var.cluster_tag
  }
}

resource "aws_security_group_rule" "permit_control_to_controllers" {
  description       = "Permit worker-controller control traffic"
  security_group_id = aws_security_group.worker.id

  type      = "egress"
  from_port = 9201
  to_port   = 9201
  protocol  = "tcp"

  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "permit_worker_to_targets" {
  for_each = var.target_sgs

  description       = "Permit workers to targets ${each.key}"
  security_group_id = aws_security_group.worker.id

  type      = "egress"
  from_port = each.value.port
  to_port   = each.value.port
  protocol  = "tcp"

  source_security_group_id = each.value.group
}

resource "aws_security_group_rule" "accept_proxy_from_sources" {
  for_each = var.client_sgs

  description       = "Accept proxy traffic from ${each.key}"
  security_group_id = aws_security_group.worker.id

  type      = "ingress"
  from_port = 9202
  to_port   = 9202
  protocol  = "tcp"

  cidr_blocks = each.value
}
