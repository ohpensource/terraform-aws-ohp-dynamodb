resource "aws_backup_plan" "dynamodb_backup_plan" {
  name = "dynamodb_backup_plan"

  rule {
    rule_name         = "tf_backup_rule"
    target_vault_name = aws_backup_vault.backup_vault.name
    schedule          = "cron(0 12 * * ? *)"
  }
}

resource "aws_backup_vault" "backup_vault" {
  name        = "dynamodb_backup_vault"
  kms_key_arn = aws_kms_key.backup_vault_keys.arn
}

resource "aws_kms_key" "backup_vault_keys" {
  description             = "KMS keys used to encrypt backup vault"
  deletion_window_in_days = 10
  enable_key_rotation     = true
}

resource "aws_backup_selection" "dynamodb_backup_selection" {
  iam_role_arn = aws_iam_role.dynamodb_backup_role.arn
  name         = "tf_dynamodb_backup_selection"
  plan_id      = aws_backup_plan.dynamodb_backup_plan.id

  resources = [
    aws_dynamodb_table.default[0].arn
  ]
}

resource "aws_iam_role" "dynamodb_backup_role" {
  name               = "dynamodb_backup_role"
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
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
  role       = aws_iam_role.dynamodb_backup_role.name
}
