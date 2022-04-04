module "controller" {
  source  = "resinstack/resinstack/aws//modules/machine-pool"
  version = "0.2.2"

  ami = var.controller_cfg.ami

  key_name = var.ssh_key_name

  machine_size      = var.controller_cfg.size
  machine_count_min = var.controller_cfg.min
  machine_count_max = var.controller_cfg.max

  pool_name = "${var.cluster_tag}-boundary-control"

  block_devices = {
    "/dev/xvda" = 8
    "/dev/xvdb" = 50
  }

  instance_profile = aws_iam_instance_profile.controller.name
  security_groups = [
    var.common_sg,
    aws_security_group.controller.id,
  ]
  associate_public_address = true

  vpc_subnets = var.public_subnets

  lb_target_groups = [
    aws_lb_target_group.controller_internal.arn,
    aws_lb_target_group.controller_external.arn,
  ]

  user_data = var.controller_cfg.userdata

  cluster_tag = var.cluster_tag

  instance_tags = {
    "boundary:hostset" = "${var.cluster_tag}-boundary-controller"
  }
}
