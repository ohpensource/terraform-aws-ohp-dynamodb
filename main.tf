resource "aws_kms_key" "dynamo_kms" {
  count = var.enable_encryption ? 1 : 0

  description             = "Dynamo DB KMS ${var.name}"
  deletion_window_in_days = 10
  enable_key_rotation     = true
}

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
    kms_key_arn = aws_kms_key.dynamo_kms[0].arn
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
