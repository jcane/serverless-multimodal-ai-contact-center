# dynamodb.tf
# Fixyachips VOD Platform — DynamoDB Tables
#
# Tables:
#   1. students_prod  — FixyachipsStudents-prod-Fixyachips-App-V1
#   2. students_dev   — FixyachipsStudents-Fixyachips-App-V1
#   3. heartbeats     — FixYaChips-VOD-Heartbeats
#
# All tables: PAY_PER_REQUEST billing
# students_prod + students_dev: KMS encrypted + PITR enabled
# heartbeats: no KMS + PITR disabled
#
# CF stack: Fixyachips-App-V1 — DO NOT DESTROY
##############################################################

##############################################################
# 1. Students Prod Table
##############################################################

resource "aws_dynamodb_table" "students_prod" {
  name         = "FixyachipsStudents-prod-Fixyachips-App-V1"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "StudentID"

  deletion_protection_enabled = true

  attribute {
    name = "StudentID"
    type = "S"
  }

  attribute {
    name = "Email"
    type = "S"
  }

  attribute {
    name = "Status"
    type = "S"
  }

  global_secondary_index {
    name            = "Email-Index"
    hash_key        = "Email"
    projection_type = "KEYS_ONLY"
  }

  global_secondary_index {
    name            = "Status-Index"
    hash_key        = "Status"
    projection_type = "ALL"
  }

  point_in_time_recovery {
    enabled = true
  }

  server_side_encryption {
    enabled     = true
    kms_key_arn = "arn:aws:kms:us-east-1:${var.account_id}:key/0fac4b6c-d569-41c8-83c7-f30da42b5701"
  }

  tags = {
    Name        = "FixyachipsStudents-prod-Fixyachips-App-V1"
    Environment = "prod"
    Project     = "fixyachips"
    ManagedBy   = "terraform"
  }
}

##############################################################
# 2. Students Dev Table
##############################################################

resource "aws_dynamodb_table" "students_dev" {
  name         = "FixyachipsStudents-Fixyachips-App-V1"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "StudentID"

  deletion_protection_enabled = false

  attribute {
    name = "StudentID"
    type = "S"
  }

  attribute {
    name = "Email"
    type = "S"
  }

  global_secondary_index {
    name            = "EmailIndex"
    hash_key        = "Email"
    projection_type = "ALL"
  }

  point_in_time_recovery {
    enabled = true
  }

  server_side_encryption {
    enabled     = true
    kms_key_arn = "arn:aws:kms:us-east-1:${var.account_id}:key/0279d82a-7266-4f3c-ad74-861ebe8764df"
  }

  tags = {
    Name        = "FixyachipsStudents-Fixyachips-App-V1"
    Environment = "dev"
    Project     = "fixyachips"
    ManagedBy   = "terraform"
  }
}

##############################################################
# 3. Heartbeats Table
# Manually created outside CF stack
# No KMS — no PITR — composite key PK + SK
##############################################################

resource "aws_dynamodb_table" "heartbeats" {
  name         = "FixYaChips-VOD-Heartbeats"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "PK"
  range_key    = "SK"

  deletion_protection_enabled = false

  attribute {
    name = "PK"
    type = "S"
  }

  attribute {
    name = "SK"
    type = "S"
  }

  point_in_time_recovery {
    enabled = false
  }

  tags = {
    Name        = "FixYaChips-VOD-Heartbeats"
    Environment = "prod"
    Project     = "fixyachips"
    ManagedBy   = "terraform"
  }
}