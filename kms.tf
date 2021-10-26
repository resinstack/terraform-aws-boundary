locals {
  key_purposes = toset(["root", "worker-auth", "recovery"])
}

resource "aws_kms_key" "key" {
  for_each = local.key_purposes

  description         = "resinstack:boundary:${each.value}:${var.cluster_tag}"
  enable_key_rotation = var.enable_key_rotation

  tags = {
    "resinstack:cluster" = var.cluster_tag
  }
}

data "aws_iam_policy_document" "kms_policy" {
  for_each = local.key_purposes

  statement {
    sid       = "BoundaryKMS${replace(each.value, "-", "")}"
    effect    = "Allow"
    resources = [aws_kms_key.key[each.value].arn]

    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:DescribeKey",
    ]
  }
}

resource "aws_iam_policy" "kms_policy" {
  for_each = local.key_purposes

  name        = "ResinStackBoundaryKMS-${each.value}-${var.cluster_tag}"
  description = "Allow access to boundary KMS purpose=${each.value}"

  policy = data.aws_iam_policy_document.kms_policy[each.value].json
}
