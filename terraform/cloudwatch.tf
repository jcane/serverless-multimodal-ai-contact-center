##############################################################
# cloudwatch.tf
# Fixyachips VOD Platform — CloudWatch Alarms
#
# Alarms:
#   1. api_5xx_errors
#   2. checkout_dlq
#   3. checkout_worker_errors
#   4. signup_dlq_backlog
#   5. signup_worker_errors
#   6. stripe_webhook_errors
#   7. stripe_webhook_throttles
#   8. stripe_webhook_dlq
#
# All alarms notify SNS alerts topic
# CF stack: Fixyachips-App-V1 — DO NOT DESTROY
##############################################################

locals {
  alerts_arn = "arn:aws:sns:us-east-1:${var.account_id}:FixyachipsAlerts-Fixyachips-App-V1"
}

##############################################################
# 1. API Gateway 5xx Errors
##############################################################

resource "aws_cloudwatch_metric_alarm" "api_5xx_errors" {
  alarm_name          = "Fixyachips-API-5xxErrors-Fixyachips-App-V1"
  alarm_description   = "API Gateway returning 5xx server errors"
  actions_enabled     = true

  alarm_actions = [local.alerts_arn]
  ok_actions    = [local.alerts_arn]

  metric_name = "5XXError"
  namespace   = "AWS/ApiGateway"
  statistic   = "Sum"

  dimensions = {
    ApiName = "FixyachipsAPI-Fixyachips-App-V1"
    Stage   = "prod"
  }

  period              = 300
  evaluation_periods  = 2
  datapoints_to_alarm = 2
  threshold           = 5
  comparison_operator = "GreaterThanOrEqualToThreshold"
  treat_missing_data  = "notBreaching"
}

##############################################################
# 2. Checkout DLQ Backlog
##############################################################

resource "aws_cloudwatch_metric_alarm" "checkout_dlq" {
  alarm_name        = "Fixyachips-CheckoutDLQ-Fixyachips-App-V1"
  alarm_description = "CRITICAL Failed Stripe checkout session creations accumulating"
  actions_enabled   = true

  alarm_actions = [local.alerts_arn]
  ok_actions    = [local.alerts_arn]

  metric_name = "ApproximateNumberOfMessagesVisible"
  namespace   = "AWS/SQS"
  statistic   = "Sum"

  dimensions = {
    QueueName = "FixyachipsCheckoutDLQ-Fixyachips-App-V1"
  }

  period             = 60
  evaluation_periods = 1
  threshold          = 1
  comparison_operator = "GreaterThanOrEqualToThreshold"
  treat_missing_data  = "notBreaching"
}

##############################################################
# 3. Checkout Worker Errors
##############################################################

resource "aws_cloudwatch_metric_alarm" "checkout_worker_errors" {
  alarm_name          = "Fixyachips-CheckoutWorker-Errors-Fixyachips-App-V1"
  alarm_description   = "CRITICAL CheckoutWorker errors indicate failed Stripe session creation"
  actions_enabled     = true

  alarm_actions = [local.alerts_arn]
  ok_actions    = [local.alerts_arn]

  metric_name = "Errors"
  namespace   = "AWS/Lambda"
  statistic   = "Sum"

  dimensions = {
    FunctionName = "FixyachipsCheckoutWorker-Fixyachips-App-V1"
  }

  period              = 300
  evaluation_periods  = 1
  datapoints_to_alarm = 1
  threshold           = 1
  comparison_operator = "GreaterThanOrEqualToThreshold"
  treat_missing_data  = "notBreaching"
}

##############################################################
# 4. Signup DLQ Backlog
##############################################################

resource "aws_cloudwatch_metric_alarm" "signup_dlq_backlog" {
  alarm_name        = "Fixyachips-SignupDLQ-Backlog-Fixyachips-App-V1"
  alarm_description = "Dead letter queue accumulating failed signup messages"
  actions_enabled   = true

  alarm_actions = [local.alerts_arn]
  ok_actions    = [local.alerts_arn]

  metric_name = "ApproximateNumberOfMessagesVisible"
  namespace   = "AWS/SQS"
  statistic   = "Sum"

  dimensions = {
    QueueName = "FixyachipsSignupDLQ-Fixyachips-App-V1"
  }

  period             = 60
  evaluation_periods = 1
  threshold          = 1
  comparison_operator = "GreaterThanOrEqualToThreshold"
  treat_missing_data  = "notBreaching"
}

##############################################################
# 5. Signup Worker Errors
##############################################################

resource "aws_cloudwatch_metric_alarm" "signup_worker_errors" {
  alarm_name          = "Fixyachips-SignupWorker-Errors-Fixyachips-App-V1"
  alarm_description   = "Signup Lambda errors exceed threshold"
  actions_enabled     = true

  alarm_actions = [local.alerts_arn]
  ok_actions    = [local.alerts_arn]

  metric_name = "Errors"
  namespace   = "AWS/Lambda"
  statistic   = "Sum"

  dimensions = {
    FunctionName = "FixyachipsSignupWorker-Fixyachips-App-V1"
  }

  period              = 300
  evaluation_periods  = 2
  datapoints_to_alarm = 2
  threshold           = 3
  comparison_operator = "GreaterThanOrEqualToThreshold"
  treat_missing_data  = "notBreaching"
}

##############################################################
# 6. Stripe Webhook Errors
##############################################################

resource "aws_cloudwatch_metric_alarm" "stripe_webhook_errors" {
  alarm_name          = "Fixyachips-StripeWebhook-Errors-Fixyachips-App-V1"
  alarm_description   = "CRITICAL Stripe webhook errors may indicate payment processing failures"
  actions_enabled     = true

  alarm_actions = [local.alerts_arn]
  ok_actions    = [local.alerts_arn]

  metric_name = "Errors"
  namespace   = "AWS/Lambda"
  statistic   = "Sum"

  dimensions = {
    FunctionName = "FixyachipsStripeWebhook-Fixyachips-App-V1"
  }

  period              = 300
  evaluation_periods  = 1
  datapoints_to_alarm = 1
  threshold           = 1
  comparison_operator = "GreaterThanOrEqualToThreshold"
  treat_missing_data  = "notBreaching"
}

##############################################################
# 7. Stripe Webhook Throttles
##############################################################

resource "aws_cloudwatch_metric_alarm" "stripe_webhook_throttles" {
  alarm_name        = "Fixyachips-StripeWebhook-Throttles-Fixyachips-App-V1"
  alarm_description = "Stripe webhook Lambda being throttled"
  actions_enabled   = true

  alarm_actions = [local.alerts_arn]
  ok_actions    = [local.alerts_arn]

  metric_name = "Throttles"
  namespace   = "AWS/Lambda"
  statistic   = "Sum"

  dimensions = {
    FunctionName = "FixyachipsStripeWebhook-Fixyachips-App-V1"
  }

  period             = 60
  evaluation_periods = 1
  threshold          = 1
  comparison_operator = "GreaterThanOrEqualToThreshold"
  treat_missing_data  = "notBreaching"
}

##############################################################
# 8. Stripe Webhook DLQ
##############################################################

resource "aws_cloudwatch_metric_alarm" "stripe_webhook_dlq" {
  alarm_name        = "Fixyachips-StripeWebhookDLQ-Fixyachips-App-V1"
  alarm_description = "CRITICAL Failed Stripe webhooks accumulating"
  actions_enabled   = true

  alarm_actions = [local.alerts_arn]
  ok_actions    = [local.alerts_arn]

  metric_name = "ApproximateNumberOfMessagesVisible"
  namespace   = "AWS/SQS"
  statistic   = "Sum"

  dimensions = {
    QueueName = "FixyachipsStripeWebhookDLQ-Fixyachips-App-V1"
  }

  period             = 60
  evaluation_periods = 1
  threshold          = 1
  comparison_operator = "GreaterThanOrEqualToThreshold"
  treat_missing_data  = "notBreaching"
}
