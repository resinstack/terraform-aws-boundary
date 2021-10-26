resource "aws_secretsmanager_secret" "postgres_url" {
  name = "resinstack-boundary-postgresql-${var.cluster_tag}"

  tags = {
    "resinstack:cluster" = var.cluster_tag
  }
}

data "aws_iam_policy_document" "controller_keys" {
  statement {
    actions = ["secretsmanager:GetSecretValue"]
    effect  = "Allow"
    resources = [
      aws_secretsmanager_secret.postgres_url.arn,
    ]
  }
}

resource "aws_iam_policy" "controller_keys" {
  name        = "ResinStackBoundaryKeyAccess-${var.cluster_tag}"
  description = "Allow access to static controller secrets"

  policy = data.aws_iam_policy_document.controller_keys.json
}
