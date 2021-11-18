module "dynamodb" {
  source    = "github.com/ohpensource/terraform-aws-ohp-dynamodb"
  name      = "table_name"
  hash_key  = "HashKey"
  range_key = "RangeKey"
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
    }
  ]
}

