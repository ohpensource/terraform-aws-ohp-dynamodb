## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_dynamodb_table.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_hash_key"></a> [hash\_key](#input\_hash\_key) | DynamoDB table Hash Key | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(any)` | n/a | yes |
| <a name="input_attributes"></a> [attributes](#input\_attributes) | DynamoDB attributes in the form of a list of mapped values | <pre>list(object({<br>    name = string<br>    type = string<br>  }))</pre> | `[]` | no |
| <a name="input_billing_mode"></a> [billing\_mode](#input\_billing\_mode) | DynamoDB Billing mode. Can be PROVISIONED or PAY\_PER\_REQUEST | `string` | `"PROVISIONED"` | no |
| <a name="input_enable_encryption"></a> [enable\_encryption](#input\_enable\_encryption) | Enable DynamoDB server-side encryption | `bool` | `false` | no |
| <a name="input_enable_point_in_time_recovery"></a> [enable\_point\_in\_time\_recovery](#input\_enable\_point\_in\_time\_recovery) | Enable DynamoDB point in time recovery | `bool` | `true` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Enable DynamoDb Creation | `bool` | `true` | no |
| <a name="input_global_secondary_index"></a> [global\_secondary\_index](#input\_global\_secondary\_index) | Additional global secondary indexes in the form of a list of mapped values | <pre>list(object({<br>    hash_key           = string<br>    name               = string<br>    non_key_attributes = list(string)<br>    projection_type    = string<br>    range_key          = string<br>    read_capacity      = number<br>    write_capacity     = number<br>  }))</pre> | `[]` | no |
| <a name="input_hash_key_type"></a> [hash\_key\_type](#input\_hash\_key\_type) | Hash Key type, which must be a scalar type: `S`, `N`, or `B` for (S)tring, (N)umber or (B)inary data | `string` | `"S"` | no |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | The ARN of the CMK that should be used for the AWS KMS encryption. This attribute should only be specified if the key is different from the default DynamoDB CMK, alias/aws/dynamodb. | `string` | `null` | no |
| <a name="input_local_secondary_index"></a> [local\_secondary\_index](#input\_local\_secondary\_index) | Additional local secondary indexes in the form of a list of mapped values | <pre>list(object({<br>    name               = string<br>    non_key_attributes = list(string)<br>    projection_type    = string<br>    range_key          = string<br>  }))</pre> | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | DynamoDB Billing mode. Can be PROVISIONED or PAY\_PER\_REQUEST | `string` | `""` | no |
| <a name="input_range_key"></a> [range\_key](#input\_range\_key) | DynamoDB table Range Key | `string` | `""` | no |
| <a name="input_range_key_type"></a> [range\_key\_type](#input\_range\_key\_type) | Range Key type, which must be a scalar type: `S`, `N`, or `B` for (S)tring, (N)umber or (B)inary data | `string` | `"S"` | no |
| <a name="input_replicas"></a> [replicas](#input\_replicas) | List of regions to create replica | `list(string)` | `[]` | no |
| <a name="input_stream_enabled"></a> [stream\_enabled](#input\_stream\_enabled) | Enable DynamoDB streams | `bool` | `false` | no |
| <a name="input_stream_view_type"></a> [stream\_view\_type](#input\_stream\_view\_type) | When an item in the table is modified, what information is written to the stream | `string` | `""` | no |
| <a name="input_ttl_attribute"></a> [ttl\_attribute](#input\_ttl\_attribute) | DynamoDB table TTL attribute | `string` | `""` | no |
| <a name="input_ttl_enabled"></a> [ttl\_enabled](#input\_ttl\_enabled) | DynamoDB table TTL attribute enable/disable | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_table_arn"></a> [table\_arn](#output\_table\_arn) | DynamoDB table ARN |
| <a name="output_table_id"></a> [table\_id](#output\_table\_id) | DynamoDB table ID |
| <a name="output_table_name"></a> [table\_name](#output\_table\_name) | DynamoDB table name |
| <a name="output_table_stream_arn"></a> [table\_stream\_arn](#output\_table\_stream\_arn) | DynamoDB table stream ARN |
| <a name="output_table_stream_label"></a> [table\_stream\_label](#output\_table\_stream\_label) | DynamoDB table stream label |


## Examples

Simple

module "dynamodb" {
  source           = "git::https://bitbucket.org/ohpen-dev/terraform-aws-ohp-dynamodb.git" 
  name             = "table_name"
  hash_key         = "HashKey"
  range_key        = "RangeKey"
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

Advanced

module "dynamodb" {
  source           = "git::https://bitbucket.org/ohpen-dev/terraform-aws-ohp-dynamodb.git" 
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
    # {
    #   name = "CreatedDateString"
    #   type = "S"
    # },
    # {
    #   name = "GsiHashKey"
    #   type = "S"
    # }
  ]

  # global_secondary_index = [
  #   {
  #     name               = "CreatedDateString-GsiHashKey-index"
  #     hash_key           = "CreatedDateString"
  #     range_key          = "GsiHashKey"
  #     projection_type    = "INCLUDE"                                  #ALL
  #     write_capacity     = 5                                          #null
  #     read_capacity      = 5                                          #null
  #     non_key_attributes = ["BatchIdentifier", "ContainerIdentifier"] #null
  #   }
  # ]

  # local_secondary_index = [
  #   {
  #     name               = "TimestampSortIndex"
  #     range_key          = "Timestamp"
  #     projection_type    = "INCLUDE"
  #     non_key_attributes = ["BatchIdentifier", "ContainerIdentifier"]
  #   },
  # ]

  # replicas = ["eu-west-2"]
}