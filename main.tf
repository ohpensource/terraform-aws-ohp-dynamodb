resource "aws_dynamodb_table" "default" {
  count            = var.enabled ? 1 : 0
  name             = var.name
  billing_mode     = var.billing_mode
  hash_key         = var.hash_key
  range_key        = var.range_key
  stream_enabled   = var.stream_enabled
  stream_view_type = var.stream_enabled ? var.stream_view_type : ""
  write_capacity   = var.write_capacity
  read_capacity    = var.read_capacity

  server_side_encryption {
    enabled     = var.enable_encryption
    kms_key_arn = aws_kms_key.dynamo_kms.arn
  }

  point_in_time_recovery {
    enabled = var.enable_point_in_time_recovery
  }

  dynamic "attribute" {
    for_each = var.attributes

    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }

  dynamic "global_secondary_index" {
    for_each = var.global_secondary_index
    content {
      hash_key           = global_secondary_index.value.hash_key
      name               = global_secondary_index.value.name
      non_key_attributes = lookup(global_secondary_index.value, "non_key_attributes", null)
      projection_type    = global_secondary_index.value.projection_type
      range_key          = lookup(global_secondary_index.value, "range_key", null)
      read_capacity      = lookup(global_secondary_index.value, "read_capacity", null)
      write_capacity     = lookup(global_secondary_index.value, "write_capacity", null)
    }
  }

  dynamic "local_secondary_index" {
    for_each = var.local_secondary_index
    content {
      name               = local_secondary_index.value.name
      non_key_attributes = lookup(local_secondary_index.value, "non_key_attributes", null)
      projection_type    = local_secondary_index.value.projection_type
      range_key          = local_secondary_index.value.range_key
    }
  }

  dynamic "replica" {
    for_each = var.replicas
    content {
      region_name = replica.value
    }
  }

  ttl {
    attribute_name = var.ttl_attribute
    enabled        = var.ttl_attribute != "" && var.ttl_attribute != null ? true : false
  }

  tags = var.tags
}

resource "aws_kms_key" "dynamo_kms" {
  description             = "Dynamo DB KMS ${var.name}"
  deletion_window_in_days = 10
}

resource "aws_appautoscaling_target" "dynamodb-test-table_read_target" {
  max_capacity       = var.autoscaling_read_max_capacity
  min_capacity       = var.autoscaling_read_min_capacity
  resource_id        = "table/${var.name}"
  scalable_dimension = "dynamodb:table:ReadCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_policy" "dynamodb-test-table_read_policy" {
  name               = "dynamodb-read-capacity-utilization-${aws_appautoscaling_target.dynamodb-test-table_read_target.resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.dynamodb-test-table_read_target.resource_id
  scalable_dimension = aws_appautoscaling_target.dynamodb-test-table_read_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.dynamodb-test-table_read_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBReadCapacityUtilization"
    }
    target_value = var.autoscaling_target_value
  }
}

resource "aws_appautoscaling_target" "dynamodb-test-table_write_target" {
  max_capacity       = var.autoscaling_write_max_capacity
  min_capacity       = var.autoscaling_write_min_capacity
  resource_id        = "table/${var.name}"
  scalable_dimension = "dynamodb:table:WriteCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_policy" "dynamodb-test-table_write_policy" {
  name               = "dynamodb-write-capacity-utilization-${aws_appautoscaling_target.dynamodb-test-table_write_target.resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.dynamodb-test-table_write_target.resource_id
  scalable_dimension = aws_appautoscaling_target.dynamodb-test-table_write_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.dynamodb-test-table_write_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBWriteCapacityUtilization"
    }
    target_value = var.autoscaling_target_value
  }
}

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
