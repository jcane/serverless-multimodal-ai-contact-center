##############################################################
# sqs.tf
# Fixyachips VOD Platform — SQS Dead Letter Queues
#
# Queues:
#   1. checkout_dlq      — FixyachipsCheckoutDLQ
#   2. signup_dlq        — FixyachipsSignupDLQ
#   3. stripe_webhook_dlq — FixyachipsStripeWebhookDLQ
#
# All queues: SSE-SQS managed encryption
# All queues: 14 day retention
# CF stack: Fixyachips-App-V1 — DO NOT DESTROY
##############################################################

##############################################################
# 1. Checkout DLQ
##############################################################

resource "aws_sqs_queue" "checkout_dlq" {
  name                       = "FixyachipsCheckoutDLQ-Fixyachips-App-V1"
  visibility_timeout_seconds = 30
  message_retention_seconds  = 1209600
  max_message_size           = 262144
  delay_seconds              = 0
  receive_wait_time_seconds  = 0

  sqs_managed_sse_enabled = true

  tags = {
    Name        = "FixyachipsCheckoutDLQ-Fixyachips-App-V1"
    Environment = "prod"
    Project     = "fixyachips"
    ManagedBy   = "terraform"
  }
}

##############################################################
# 2. Signup DLQ
##############################################################

resource "aws_sqs_queue" "signup_dlq" {
  name                       = "FixyachipsSignupDLQ-Fixyachips-App-V1"
  visibility_timeout_seconds = 30
  message_retention_seconds  = 1209600
  max_message_size           = 262144
  delay_seconds              = 0
  receive_wait_time_seconds  = 0

  sqs_managed_sse_enabled = true

  tags = {
    Name        = "FixyachipsSignupDLQ-Fixyachips-App-V1"
    Environment = "prod"
    Project     = "fixyachips"
    ManagedBy   = "terraform"
  }
}

##############################################################
# 3. Stripe Webhook DLQ
##############################################################

resource "aws_sqs_queue" "stripe_webhook_dlq" {
  name                       = "FixyachipsStripeWebhookDLQ-Fixyachips-App-V1"
  visibility_timeout_seconds = 30
  message_retention_seconds  = 1209600
  max_message_size           = 262144
  delay_seconds              = 0
  receive_wait_time_seconds  = 0

  sqs_managed_sse_enabled = true

  tags = {
    Name        = "FixyachipsStripeWebhookDLQ-Fixyachips-App-V1"
    Environment = "prod"
    Project     = "fixyachips"
    ManagedBy   = "terraform"
  }
}
