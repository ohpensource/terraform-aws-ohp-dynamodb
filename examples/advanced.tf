module "dynamodb" {
  source           = "github.com/ohpensource/terraform-aws-ohp-dynamodb"
  name             = "table_name"
  billing_mode     = "PAY_PER_REQUEST"
  hash_key         = "HashKey"
  range_key        = "RangeKey"
  ttl_enabled      = false
  ttl_attribute    = "TimeToLive"
  kms_key_arn      = "arn:aws:kms:eu-west-1:061234567:key/123456-1234-123a-a1a2-1a2345678"
  stream_enabled   = false
  stream_view_type = "NEW_AND_OLD_IMAGES"

  tags = {
    Name        = "table_name"
    Environment = "dev"
  }

  attributes = [
    {
      name = "HashKey"
      type = "S"
    },
    {
      name = "RangeKey"
      type = "S"
    },
    {
      name = "CreatedDate"
      type = "S"
    },
    {
      name = "ExtraHashKey"
      type = "S"
    }
  ]

  global_secondary_index = [
    {
      name               = "CreatedDate-ExtraHashKey-index"
      hash_key           = "CreatedDate"
      range_key          = "ExtraHashKey"
      projection_type    = "INCLUDE"               #ALL
      write_capacity     = 5                       #null
      read_capacity      = 5                       #null
      non_key_attributes = ["HashKey", "RangeKey"] #null
    }
  ]

  local_secondary_index = [
    {
      name               = "TimestampSortIndex"
      range_key          = "Timestamp"
      projection_type    = "INCLUDE"
      non_key_attributes = ["BatchIdentifier", "ContainerIdentifier"]
    },
  ]

  replicas = ["eu-west-2"]
}
