variable "name" {
  type        = string
  description = "DynamoDB name"
}

variable "enabled" {
  type        = bool
  default     = true
  description = "Enable DynamoDb Creation"
}

variable "billing_mode" {
  type        = string
  default     = "PROVISIONED"
  description = "DynamoDB Billing mode. Can be PROVISIONED or PAY_PER_REQUEST"
}

variable "stream_enabled" {
  type        = bool
  default     = false
  description = "Enable DynamoDB streams"
}

variable "stream_view_type" {
  type        = string
  default     = ""
  description = "When an item in the table is modified, what information is written to the stream"
}

variable "enable_encryption" {
  type        = bool
  default     = true
  description = "Enable DynamoDB server-side encryption"
}

variable "kms_key_arn" {
  type        = string
  default     = null
  description = "The ARN of the CMK that should be used for the AWS KMS encryption. This attribute should only be specified if the key is different from the default DynamoDB CMK, alias/aws/dynamodb."
}

variable "enable_point_in_time_recovery" {
  type        = bool
  default     = true
  description = "Enable DynamoDB point in time recovery"
}

variable "hash_key" {
  type        = string
  description = "DynamoDB table Hash Key"
}

variable "hash_key_type" {
  type        = string
  default     = "S"
  description = "Hash Key type, which must be a scalar type: `S`, `N`, or `B` for (S)tring, (N)umber or (B)inary data"
}

variable "range_key" {
  type        = string
  description = "DynamoDB table Range Key"
}

variable "range_key_type" {
  type        = string
  default     = "S"
  description = "Range Key type, which must be a scalar type: `S`, `N`, or `B` for (S)tring, (N)umber or (B)inary data"
}

variable "ttl_enabled" {
  type        = bool
  default     = false
  description = "DynamoDB table TTL attribute enable/disable"
}

variable "ttl_attribute" {
  type        = string
  default     = ""
  description = "DynamoDB table TTL attribute"
}

variable "attributes" {
  type = list(object({
    name = string
    type = string
  }))
  default     = []
  description = "DynamoDB attributes in the form of a list of mapped values"
}

variable "global_secondary_index" {
  type = list(object({
    hash_key           = string
    name               = string
    non_key_attributes = list(string)
    projection_type    = string
    range_key          = string
    read_capacity      = number
    write_capacity     = number
  }))
  default = [
    # {
    #   hash_key           = ""
    #   name               = ""
    #   non_key_attributes = null
    #   projection_type    = ""
    #   range_key          = ""
    #   read_capacity      = null
    #   write_capacity     = null 
    # }
  ]
  description = "Additional global secondary indexes in the form of a list of mapped values"
}

variable "local_secondary_index" {
  type = list(object({
    name               = string
    non_key_attributes = list(string)
    projection_type    = string
    range_key          = string
  }))
  default     = []
  description = "Additional local secondary indexes in the form of a list of mapped values"
}

variable "replicas" {
  type        = list(string)
  default     = []
  description = "List of regions to create replica"
}

variable "write_capacity" {
  type        = number
  default     = 10
  description = "Write capacity"
}
variable "read_capacity" {
  type        = number
  default     = 10
  description = "Read capacity"
}

variable "autoscaling_target_value" {
  type        = number
  default     = 70
  description = "Autoscaling target value"
}

variable "autoscaling_read_min_capacity" {
  type        = number
  default     = 5
  description = "Autoscaling read minimum capacity"
}

variable "autoscaling_read_max_capacity" {
  type        = number
  default     = 1000
  description = "Autoscaling read maximum capacity"
}

variable "autoscaling_write_min_capacity" {
  type        = number
  default     = 5
  description = "Autoscaling write minimum capacity"
}

variable "autoscaling_write_max_capacity" {
  type        = number
  default     = 1000
  description = "Autoscaling write maximum capacity"
}

variable "tags" {
  type        = map(any)
  default     = {}
  description = "Values will combine with your provider default_tags configuration"
}
#     Iac          = "terraform"
#     IacRepo      = var.iac_repo
#     Team         = var.devops_team
#     Stage        = local.environment
#     Client       = var.client
#     Service      = local.service_name
#     ServiceGroup = local.service_group_name
#     AutoCi       = var.autoci_suffix != "" ? "true" : "false"
#     Datadog      = var.datadog_tag[local.environment]
#     Version      = var.version_tag == "" ? "0.0.0" : var.version_tag
#   }
