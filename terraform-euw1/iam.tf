###############################################################
# iam.tf
# Fixyachips IAM Roles — 3 roles
# Lambda + MediaConvert + ApiGateway
# NOTE: Bedrock AgentCore role lives in bedrock_iam.tf
###############################################################

###############################################################
# Role 1 — Lambda Master Execution Role
###############################################################
resource "aws_iam_role" "master_role" {
  name        = "Fixyachips-App-V1-FixyachipsMasterRole-93imi2rTiV4B"
  description = "Lambda execution role - least privilege for all workers"
  path        = "/"

  max_session_duration = 3600

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  lifecycle {
    ignore_changes = [
      assume_role_policy,
      inline_policy,
      managed_policy_arns
    ]
  }

  tags = {
    Project     = "Fixyachips"
    Environment = "prod"
    ManagedBy   = "Terraform"
  }
}

###############################################################
# Role 2 — MediaConvert Role
###############################################################
resource "aws_iam_role" "mediaconvert_role" {
  name        = "Fixyachips-App-V1-MediaConvertRole-E0dMye487z6W"
  description = "Least-privilege IAM role for MediaConvert VOD transcoding"
  path        = "/"

  max_session_duration = 3600

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "mediaconvert.amazonaws.com"
        }
        Action = "sts:AssumeRole"
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = var.account_id
          }
        }
      }
    ]
  })

  lifecycle {
    ignore_changes = [
      assume_role_policy,
      inline_policy,
      managed_policy_arns
    ]
  }

  tags = {
    Project     = "Fixyachips"
    Environment = "prod"
    ManagedBy   = "Terraform"
  }
}

###############################################################
# Role 3 — API Gateway CloudWatch Role
###############################################################
resource "aws_iam_role" "api_gateway_cloudwatch_role" {
  name        = "Fixyachips-App-V1-ApiGatewayCloudWatchRole-4PhqDl9yhylW"
  description = "API Gateway role for CloudWatch execution logs"
  path        = "/"

  max_session_duration = 3600

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "apigateway.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  lifecycle {
    ignore_changes = [
      assume_role_policy,
      inline_policy,
      managed_policy_arns
    ]
  }

  tags = {
    Project     = "Fixyachips"
    Environment = "prod"
    ManagedBy   = "Terraform"
  }
}
