module "worker" {
  source  = "resinstack/resinstack/aws//modules/machine-pool"
  version = "0.2.2"

  ami = var.worker_cfg.ami

  key_name = var.ssh_key_name

  machine_size      = var.worker_cfg.size
  machine_count_min = var.worker_cfg.min
  machine_count_max = var.worker_cfg.max

  pool_name = "${var.cluster_tag}-boundary-worker"

  block_devices = {
    "/dev/xvda" = 8
    "/dev/xvdb" = 50
  }

  instance_profile = aws_iam_instance_profile.worker.name
  security_groups = [
    var.common_sg,
    aws_security_group.worker.id,
  ]
  associate_public_address = true

  vpc_subnets = var.public_subnets

  lb_target_groups = [
    aws_lb_target_group.worker_proxy.arn,
  ]

  user_data = var.worker_cfg.userdata

  cluster_tag = var.cluster_tag
}
