resource "aws_backup_plan" "dynamodb_backup_plan" {
  count = var.enable_point_in_time_recovery ? 1 : 0

  name = var.name
  rule {
    rule_name         = "tf_backup_rule"
    target_vault_name = aws_backup_vault.backup_vault[0].name
    schedule          = "cron(0 12 * * ? *)"
  }
}

resource "aws_backup_vault" "backup_vault" {
  count = var.enable_point_in_time_recovery ? 1 : 0

  name        = var.name
  kms_key_arn = aws_kms_key.backup_vault_keys[0].arn
}

resource "aws_kms_key" "backup_vault_keys" {
  count = var.enable_point_in_time_recovery ? 1 : 0

  description             = "KMS keys used to encrypt backup vault"
  deletion_window_in_days = 10
  enable_key_rotation     = true
}

resource "aws_backup_selection" "dynamodb_backup_selection" {
  count = var.enable_point_in_time_recovery ? 1 : 0

  name         = var.name
  iam_role_arn = aws_iam_role.dynamodb_backup_role[0].arn
  plan_id      = aws_backup_plan.dynamodb_backup_plan[0].id

  resources = [
    aws_dynamodb_table.default[0].arn
  ]
}

resource "aws_iam_role" "dynamodb_backup_role" {
  count = var.enable_point_in_time_recovery ? 1 : 0

  name               = "${var.name}-backup"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": ["sts:AssumeRole"],
      "Effect": "allow",
      "Principal": {
        "Service": ["backup.amazonaws.com"]
      }
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "dynamodb_backup_role_attachement" {
  count = var.enable_point_in_time_recovery ? 1 : 0

  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
  role       = aws_iam_role.dynamodb_backup_role[0].name
}
