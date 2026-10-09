# Fuel Tracker — DynamoDB table + IAM for the Flutter app.
# Drop-in resource file: requires an existing AWS provider configuration
# (v6.x) and aws_iam_policy_document data source support.

variable "fuel_tracker_region" {
  description = "Region for the table (app default is us-east-1)"
  type        = string
  default     = "us-east-1"
}

variable "fuel_tracker_table_name" {
  description = "DynamoDB table name (app default is FuelTrackerEntries)"
  type        = string
  default     = "FuelTrackerEntries"
}

variable "fuel_tracker_iam_user_name" {
  description = "IAM user the app authenticates as"
  type        = string
  default     = "fuel-tracker-app"
}

# On-demand billing requires at least one GSI on an empty table;
# querying by device is also the natural access pattern for this app.
resource "aws_dynamodb_table" "fuel_tracker_entries" {
  name         = var.fuel_tracker_table_name
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "id"
    type = "S"
  }

  attribute {
    name = "deviceId"
    type = "S"
  }

  hash_key = "id"

  global_secondary_index {
    name            = "by_device_id"
    projection_type = "ALL"

    key_schema {
      attribute_name = "deviceId"
      key_type       = "HASH"
    }
  }

  server_side_encryption {
    # enabled without a kms_key_arn uses the AWS-managed default key
    enabled = true
  }
}

# Exactly the actions the app's signed-request client issues:
# PutItem for new/updated entries, BatchWriteItem (DeleteRequests) for
# deletions, GetItem/Query for reads, DescribeTable for the connection test.
data "aws_iam_policy_document" "fuel_tracker_dynamodb" {
  statement {
    effect = "Allow"
    actions = [
      "dynamodb:PutItem",
      "dynamodb:BatchWriteItem",
      "dynamodb:GetItem",
      "dynamodb:Query",
      "dynamodb:DescribeTable",
    ]
    resources = [aws_dynamodb_table.fuel_tracker_entries.arn]
  }
}

resource "aws_iam_policy" "fuel_tracker_dynamodb" {
  name        = "fuel-tracker-dynamodb"
  description = "Access to the FuelTracker DynamoDB table for the app"
  policy      = data.aws_iam_policy_document.fuel_tracker_dynamodb.json
}

resource "aws_iam_user" "fuel_tracker_app" {
  name = var.fuel_tracker_iam_user_name
}

resource "aws_iam_user_policy_attachment" "fuel_tracker_app" {
  user       = aws_iam_user.fuel_tracker_app.name
  policy_arn = aws_iam_policy.fuel_tracker_dynamodb.arn
}

resource "aws_iam_access_key" "fuel_tracker_app" {
  user = aws_iam_user.fuel_tracker_app.name
}

output "fuel_tracker_table_name" {
  value = aws_dynamodb_table.fuel_tracker_entries.name
}

output "fuel_tracker_table_arn" {
  value = aws_dynamodb_table.fuel_tracker_entries.arn
}

output "fuel_tracker_iam_user" {
  value = aws_iam_user.fuel_tracker_app.name
}

output "fuel_tracker_access_key_id" {
  value = aws_iam_access_key.fuel_tracker_app.id
}

output "fuel_tracker_access_key_secret" {
  value     = aws_iam_access_key.fuel_tracker_app.secret
  sensitive = true
}
