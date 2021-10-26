data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "controller" {
  name                 = "resinstack-boundary-controller-${var.cluster_tag}"
  assume_role_policy   = data.aws_iam_policy_document.ec2_assume_role.json
  max_session_duration = 3600 * 12

  tags = {
    "resinstack:cluster" = var.cluster_tag
  }
}

resource "aws_iam_role_policy_attachment" "controller_kms" {
  for_each = local.key_purposes

  role       = aws_iam_role.controller.name
  policy_arn = aws_iam_policy.kms_policy[each.value].arn
}

resource "aws_iam_role_policy_attachment" "controller_keys" {
  role       = aws_iam_role.controller.name
  policy_arn = aws_iam_policy.controller_keys.arn
}

resource "aws_iam_instance_profile" "controller" {
  name = "resinstack-boundary-controller-${var.cluster_tag}"
  role = aws_iam_role.controller.name
}

resource "aws_iam_role" "worker" {
  name                 = "resinstack-boundary-worker-${var.cluster_tag}"
  assume_role_policy   = data.aws_iam_policy_document.ec2_assume_role.json
  max_session_duration = 3600 * 12

  tags = {
    "resinstack:cluster" = var.cluster_tag
  }
}

resource "aws_iam_role_policy_attachment" "worker_kms" {
  role       = aws_iam_role.worker.name
  policy_arn = aws_iam_policy.kms_policy["worker-auth"].arn
}

resource "aws_iam_instance_profile" "worker" {
  name = "resinstack-boundary-worker-${var.cluster_tag}"
  role = aws_iam_role.worker.name
}
