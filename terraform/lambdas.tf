##############################################################
# lambdas.tf
# Fixyachips VOD Platform — Lambda Functions
#
# Functions:
#   1. signup_worker          — CF managed
#   2. checkout_worker        — CF managed
#   3. stripe_webhook         — CF managed
#   4. mediaconvert_trigger   — CF managed
#   5. video_factory_trigger  — manually created
#   6. post_confirmation      — manually created
#
# NOTE: All functions currently use master role
#       Per-function IAM roles — Week 3 iam.tf
#
# Runtime: python3.12 (except post_confirmation nodejs22.x)
# CF stack: Fixyachips-App-V1 — DO NOT DESTROY
##############################################################

##############################################################
# 1. Signup Worker
##############################################################

resource "aws_lambda_function" "signup_worker" {
  function_name                  = "FixyachipsSignupWorker-Fixyachips-App-V1"
  role                           = "arn:aws:iam::${var.account_id}:role/Fixyachips-App-V1-FixyachipsMasterRole-93imi2rTiV4B"
  runtime                        = "python3.12"
  handler                        = "index.lambda_handler"
  timeout                        = 29
  memory_size                    = 256
  reserved_concurrent_executions = 100

  filename = "${path.module}/../src/signup_worker/index.zip"

  dead_letter_config {
    target_arn = "arn:aws:sqs:us-east-1:${var.account_id}:FixyachipsSignupDLQ-Fixyachips-App-V1"
  }

  environment {
    variables = {
      TABLE_NAME     = "FixyachipsStudents-prod-Fixyachips-App-V1"
      ENVIRONMENT    = "prod"
      ADMIN_EMAIL    = "info@fixyachips.com"
      LOG_LEVEL      = "WARNING"
      ALLOWED_ORIGIN = "https://fixyachips.com"
    }
  }

  tags = {
    Name        = "FixyachipsSignupWorker-Fixyachips-App-V1"
    Environment = "prod"
    Project     = "fixyachips"
    ManagedBy   = "terraform"
  }

  lifecycle {
    ignore_changes = [
      filename,
      source_code_hash,
    ]
  }
}

##############################################################
# 2. Checkout Worker
##############################################################

resource "aws_lambda_function" "checkout_worker" {
  function_name                  = "FixyachipsCheckoutWorker-Fixyachips-App-V1"
  role                           = "arn:aws:iam::${var.account_id}:role/Fixyachips-App-V1-FixyachipsMasterRole-93imi2rTiV4B"
  runtime                        = "python3.12"
  handler                        = "index.lambda_handler"
  timeout                        = 29
  memory_size                    = 256
  reserved_concurrent_executions = 50

  filename = "${path.module}/../src/checkout_worker/index.zip"

  layers = [
    "arn:aws:lambda:us-east-1:${var.account_id}:layer:stripe-python-layer-Fixyachips-App-V1:1"
  ]

  dead_letter_config {
    target_arn = "arn:aws:sqs:us-east-1:${var.account_id}:FixyachipsCheckoutDLQ-Fixyachips-App-V1"
  }

  environment {
    variables = {
      CANCEL_URL     = "https://fixyachips.com/pricing"
      ENVIRONMENT    = "prod"
      SECRET_ARN     = "arn:aws:secretsmanager:us-east-1:${var.account_id}:secret:Fixyachips/StripeCredentials/prod/Fixyachips-App-V1-pc8krK"
      SUCCESS_URL    = "https://fixyachips.com/success?session_id={CHECKOUT_SESSION_ID}"
      PRICE_ID       = "price_REPLACE_WITH_REAL_PRICE_ID_prod"
      ALLOWED_ORIGIN = "https://fixyachips.com"
    }
  }

  tags = {
    Name        = "FixyachipsCheckoutWorker-Fixyachips-App-V1"
    Environment = "prod"
    Project     = "fixyachips"
    ManagedBy   = "terraform"
  }

  lifecycle {
    ignore_changes = [
      filename,
      source_code_hash,
    ]
  }
}

##############################################################
# 3. Stripe Webhook
##############################################################

resource "aws_lambda_function" "stripe_webhook" {
  function_name                  = "FixyachipsStripeWebhook-Fixyachips-App-V1"
  role                           = "arn:aws:iam::${var.account_id}:role/Fixyachips-App-V1-FixyachipsMasterRole-93imi2rTiV4B"
  runtime                        = "python3.12"
  handler                        = "index.lambda_handler"
  timeout                        = 29
  memory_size                    = 256
  reserved_concurrent_executions = 50

  filename = "${path.module}/../src/stripe_webhook/index.zip"

  dead_letter_config {
    target_arn = "arn:aws:sqs:us-east-1:${var.account_id}:FixyachipsStripeWebhookDLQ-Fixyachips-App-V1"
  }

  environment {
    variables = {
      TABLE_NAME  = "FixyachipsStudents-prod-Fixyachips-App-V1"
      ENVIRONMENT = "prod"
      SECRET_ARN  = "arn:aws:secretsmanager:us-east-1:${var.account_id}:secret:Fixyachips/StripeCredentials/prod/Fixyachips-App-V1-pc8krK"
    }
  }

  tags = {
    Name        = "FixyachipsStripeWebhook-Fixyachips-App-V1"
    Environment = "prod"
    Project     = "fixyachips"
    ManagedBy   = "terraform"
  }

  lifecycle {
    ignore_changes = [
      filename,
      source_code_hash,
    ]
  }
}

##############################################################
# 4. MediaConvert Trigger
##############################################################

resource "aws_lambda_function" "mediaconvert_trigger" {
  function_name                  = "FixyachipsMediaConvertTrigger-Fixyachips-App-V1"
  role                           = "arn:aws:iam::${var.account_id}:role/Fixyachips-App-V1-FixyachipsMasterRole-93imi2rTiV4B"
  runtime                        = "python3.12"
  handler                        = "index.lambda_handler"
  timeout                        = 60
  memory_size                    = 256
  reserved_concurrent_executions = 20

  filename = "${path.module}/../src/mediaconvert_trigger/index.zip"

  environment {
    variables = {
      QUEUE_ARN         = "arn:aws:mediaconvert:us-east-1:${var.account_id}:queues/FixyachipsVODQueue-Fixyachips-App-V1"
      OUTPUT_BUCKET     = "fixyachips-platform-${var.account_id}-prod"
      MEDIACONVERT_ROLE = "arn:aws:iam::${var.account_id}:role/Fixyachips-App-V1-MediaConvertRole-E0dMye487z6W"
    }
  }

  tags = {
    Name        = "FixyachipsMediaConvertTrigger-Fixyachips-App-V1"
    Environment = "prod"
    Project     = "fixyachips"
    ManagedBy   = "terraform"
  }

  lifecycle {
    ignore_changes = [
      filename,
      source_code_hash,
    ]
  }
}

##############################################################
# 5. Video Factory Trigger
# Manually created outside CloudFormation
# No environment variables
##############################################################

resource "aws_lambda_function" "video_factory_trigger" {
  function_name = "Fixyachips-Video-Factory-Trigger"
  role          = "arn:aws:iam::${var.account_id}:role/Fixyachips-App-V1-FixyachipsMasterRole-93imi2rTiV4B"
  runtime       = "python3.12"
  handler       = "lambda_function.lambda_handler"
  timeout       = 3
  memory_size   = 128

  filename = "${path.module}/../src/video_factory_trigger/lambda_function.zip"

  tags = {
    Name        = "Fixyachips-Video-Factory-Trigger"
    Environment = "prod"
    Project     = "fixyachips"
    ManagedBy   = "terraform"
  }

  lifecycle {
    ignore_changes = [
      filename,
      source_code_hash,
    ]
  }
}

##############################################################
# 6. Post Confirmation Trigger
# Manually created outside CloudFormation
# nodejs22.x runtime — no environment variables
##############################################################

resource "aws_lambda_function" "post_confirmation_trigger" {
  function_name = "Fixyachips-PostConfirmation-Trigger"
  role          = "arn:aws:iam::${var.account_id}:role/Fixyachips-App-V1-FixyachipsMasterRole-93imi2rTiV4B"
  runtime       = "nodejs22.x"
  handler       = "index.handler"
  timeout       = 3
  memory_size   = 128

  filename = "${path.module}/../src/post_confirmation_trigger/index.zip"

  tags = {
    Name        = "Fixyachips-PostConfirmation-Trigger"
    Environment = "prod"
    Project     = "fixyachips"
    ManagedBy   = "terraform"
  }

  lifecycle {
    ignore_changes = [
      filename,
      source_code_hash,
    ]
  }
}
