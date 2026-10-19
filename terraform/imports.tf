# ============================================
# IMPORTS.TF
# Fixyachips VOD & Monetization Platform
# Bring all existing AWS resources under
# Terraform control without destroying anything
#
# Account: 980049663300
# Region:  us-east-1
# Stack:   Fixyachips-App-V1
#
# SAFE — these blocks do not modify or
# destroy any live resources.
# They only register existing resources
# into Terraform state.
# ============================================


# ─────────────────────────────────────────────
# S3 BUCKETS
# ─────────────────────────────────────────────

import {
  to = aws_s3_bucket.platform
  id = "fixyachips-platform-980049663300-prod"
}

import {
  to = aws_s3_bucket.logs
  id = "fixyachips-logs-980049663300-prod-v2"
}
import {
  to = aws_s3_bucket_versioning.platform
  id = "fixyachips-platform-980049663300-prod"
}

import {
  to = aws_s3_bucket_server_side_encryption_configuration.platform
  id = "fixyachips-platform-980049663300-prod"
}

import {
  to = aws_s3_bucket_public_access_block.platform
  id = "fixyachips-platform-980049663300-prod"
}

import {
  to = aws_s3_bucket_versioning.logs
  id = "fixyachips-logs-980049663300-prod-v2"
}

import {
  to = aws_s3_bucket_server_side_encryption_configuration.logs
  id = "fixyachips-logs-980049663300-prod-v2"
}

import {
  to = aws_s3_bucket_public_access_block.logs
  id = "fixyachips-logs-980049663300-prod-v2"
}


# ─────────────────────────────────────────────
# KMS
# ─────────────────────────────────────────────

import {
  to = aws_kms_key.secrets
  id = "7120f964-80ba-492a-9829-16f900354a0f"
}

import {
  to = aws_kms_alias.secrets
  id = "alias/fixyachips-secrets-prod"
}


# ─────────────────────────────────────────────
# CLOUDFRONT
# ─────────────────────────────────────────────

import {
  to = aws_cloudfront_distribution.main
  id = "E1BVP04I7B9G57"
}


# ─────────────────────────────────────────────
# WAFv2
# ─────────────────────────────────────────────

import {
  to = aws_wafv2_web_acl.main
  id = "de0fe5fb-4dbe-40af-8793-a5e9d4a9f71a/WebBodyguard-CUKBiodvYfdj/CLOUDFRONT"
}


# ─────────────────────────────────────────────
# DYNAMODB TABLES
# ─────────────────────────────────────────────

import {
  to = aws_dynamodb_table.students_prod
  id = "FixyachipsStudents-prod-Fixyachips-App-V1"
}

import {
  to = aws_dynamodb_table.students_dev
  id = "FixyachipsStudents-Fixyachips-App-V1"
}

# Manual resource — created outside CloudFormation
import {
  to = aws_dynamodb_table.heartbeats
  id = "FixYaChips-VOD-Heartbeats"
}


# ─────────────────────────────────────────────
# LAMBDA FUNCTIONS
# ─────────────────────────────────────────────

import {
  to = aws_lambda_function.signup_worker
  id = "FixyachipsSignupWorker-Fixyachips-App-V1"
}

import {
  to = aws_lambda_function.stripe_webhook
  id = "FixyachipsStripeWebhook-Fixyachips-App-V1"
}

import {
  to = aws_lambda_function.checkout_worker
  id = "FixyachipsCheckoutWorker-Fixyachips-App-V1"
}

import {
  to = aws_lambda_function.mediaconvert_trigger
  id = "FixyachipsMediaConvertTrigger-Fixyachips-App-V1"
}

# Manual resources — created outside CloudFormation
import {
  to = aws_lambda_function.video_factory_trigger
  id = "Fixyachips-Video-Factory-Trigger"
}

import {
  to = aws_lambda_function.post_confirmation_trigger
  id = "Fixyachips-PostConfirmation-Trigger"
}


# ─────────────────────────────────────────────
# API GATEWAY
# ─────────────────────────────────────────────

import {
  to = aws_api_gateway_rest_api.main
  id = "4mbwbdlril"
}


# ─────────────────────────────────────────────
# SECRETS MANAGER
# ─────────────────────────────────────────────

import {
  to = aws_secretsmanager_secret.platform
  id = "fixyachips"
}

import {
  to = aws_secretsmanager_secret.stripe
  id = "Fixyachips/StripeCredentials/prod/Fixyachips-App-V1"
}


# ─────────────────────────────────────────────
# SQS DEAD LETTER QUEUES
# ─────────────────────────────────────────────

import {
  to = aws_sqs_queue.checkout_dlq
  id = "https://sqs.us-east-1.amazonaws.com/980049663300/FixyachipsCheckoutDLQ-Fixyachips-App-V1"
}

import {
  to = aws_sqs_queue.signup_dlq
  id = "https://sqs.us-east-1.amazonaws.com/980049663300/FixyachipsSignupDLQ-Fixyachips-App-V1"
}

import {
  to = aws_sqs_queue.stripe_webhook_dlq
  id = "https://sqs.us-east-1.amazonaws.com/980049663300/FixyachipsStripeWebhookDLQ-Fixyachips-App-V1"
}


# ─────────────────────────────────────────────
# SNS
# ─────────────────────────────────────────────

import {
  to = aws_sns_topic.alerts
  id = "arn:aws:sns:us-east-1:980049663300:FixyachipsAlerts-Fixyachips-App-V1"
}


# ─────────────────────────────────────────────
# CLOUDWATCH ALARMS
# ─────────────────────────────────────────────

import {
  to = aws_cloudwatch_metric_alarm.api_5xx_errors
  id = "Fixyachips-API-5xxErrors-Fixyachips-App-V1"
}

import {
  to = aws_cloudwatch_metric_alarm.checkout_dlq
  id = "Fixyachips-CheckoutDLQ-Fixyachips-App-V1"
}

import {
  to = aws_cloudwatch_metric_alarm.checkout_worker_errors
  id = "Fixyachips-CheckoutWorker-Errors-Fixyachips-App-V1"
}

import {
  to = aws_cloudwatch_metric_alarm.signup_dlq_backlog
  id = "Fixyachips-SignupDLQ-Backlog-Fixyachips-App-V1"
}

import {
  to = aws_cloudwatch_metric_alarm.signup_worker_errors
  id = "Fixyachips-SignupWorker-Errors-Fixyachips-App-V1"
}

import {
  to = aws_cloudwatch_metric_alarm.stripe_webhook_errors
  id = "Fixyachips-StripeWebhook-Errors-Fixyachips-App-V1"
}

import {
  to = aws_cloudwatch_metric_alarm.stripe_webhook_throttles
  id = "Fixyachips-StripeWebhook-Throttles-Fixyachips-App-V1"
}

import {
  to = aws_cloudwatch_metric_alarm.stripe_webhook_dlq
  id = "Fixyachips-StripeWebhookDLQ-Fixyachips-App-V1"
}


# ─────────────────────────────────────────────
# COGNITO
# Manual resource — created outside CloudFormation
# ─────────────────────────────────────────────

import {
  to = aws_cognito_user_pool.main
  id = "us-east-1_KZdOYrS4l"
}


# ─────────────────────────────────────────────
# IAM ROLES
# ─────────────────────────────────────────────

import {
  to = aws_iam_role.master_role
  id = "Fixyachips-App-V1-FixyachipsMasterRole-93imi2rTiV4B"
}

import {
  to = aws_iam_role.mediaconvert_role
  id = "Fixyachips-App-V1-MediaConvertRole-E0dMye487z6W"
}

import {
  to = aws_iam_role.api_gateway_cloudwatch_role
  id = "Fixyachips-App-V1-ApiGatewayCloudWatchRole-4PhqDl9yhylW"
}


# ─────────────────────────────────────────────
# BEDROCK
# Manual resources — created outside CloudFormation
# Week 5 target — placeholder blocks ready
# ─────────────────────────────────────────────

import {
  to = aws_iam_role.bedrock_agent_core
  id = "AmazonBedrockAgentCoreHarnessDefaultServiceRole-bwvpa"
}