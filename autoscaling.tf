resource "aws_appautoscaling_target" "dynamodb-test-table_read_target" {
  count = var.billing_mode == local.PAY_PER_REQUEST ? 0 : 1

  max_capacity       = var.autoscaling_read_max_capacity
  min_capacity       = var.autoscaling_read_min_capacity
  resource_id        = "table/${var.name}"
  scalable_dimension = "dynamodb:table:ReadCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_policy" "dynamodb-test-table_read_policy" {
  count = var.billing_mode == local.PAY_PER_REQUEST ? 0 : 1

  name               = "dynamodb-read-capacity-utilization-${aws_appautoscaling_target.dynamodb-test-table_read_target[0].resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.dynamodb-test-table_read_target[0].resource_id
  scalable_dimension = aws_appautoscaling_target.dynamodb-test-table_read_target[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.dynamodb-test-table_read_target[0].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBReadCapacityUtilization"
    }
    target_value = var.autoscaling_target_value
  }
}

resource "aws_appautoscaling_target" "dynamodb-test-table_write_target" {
  count = var.billing_mode == local.PAY_PER_REQUEST ? 0 : 1

  max_capacity       = var.autoscaling_write_max_capacity
  min_capacity       = var.autoscaling_write_min_capacity
  resource_id        = "table/${var.name}"
  scalable_dimension = "dynamodb:table:WriteCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_policy" "dynamodb-test-table_write_policy" {
  count = var.billing_mode == local.PAY_PER_REQUEST ? 0 : 1

  name               = "dynamodb-write-capacity-utilization-${aws_appautoscaling_target.dynamodb-test-table_write_target[0].resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.dynamodb-test-table_write_target[0].resource_id
  scalable_dimension = aws_appautoscaling_target.dynamodb-test-table_write_target[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.dynamodb-test-table_write_target[0].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBWriteCapacityUtilization"
    }
    target_value = var.autoscaling_target_value
  }
}
