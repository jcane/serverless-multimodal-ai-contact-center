###############################################################################
# outputs.tf — Fixyachips VOD Platform
# NOTE: kms outputs live in kms.tf
#       s3 outputs live in s3.tf
###############################################################################

# ─── CloudFront ──────────────────────────────────────────────────────────────

output "cloudfront_distribution_id" {
  description = "Fixyachips CloudFront distribution ID"
  value       = aws_cloudfront_distribution.main.id
}

output "cloudfront_domain_name" {
  description = "Fixyachips CloudFront domain name"
  value       = aws_cloudfront_distribution.main.domain_name
}

# ─── API Gateway ─────────────────────────────────────────────────────────────

output "api_gateway_id" {
  description = "Fixyachips API Gateway REST API ID"
  value       = aws_api_gateway_rest_api.main.id
}

output "api_gateway_execution_arn" {
  description = "Fixyachips API Gateway execution ARN"
  value       = aws_api_gateway_rest_api.main.execution_arn
}

# ─── DynamoDB ────────────────────────────────────────────────────────────────

output "dynamodb_students_prod_name" {
  description = "Fixyachips Students prod table name"
  value       = aws_dynamodb_table.students_prod.name
}

output "dynamodb_students_dev_name" {
  description = "Fixyachips Students dev table name"
  value       = aws_dynamodb_table.students_dev.name
}

output "dynamodb_heartbeats_name" {
  description = "Fixyachips Heartbeats table name"
  value       = aws_dynamodb_table.heartbeats.name
}

# ─── Cognito ─────────────────────────────────────────────────────────────────

output "cognito_user_pool_id" {
  description = "Fixyachips Cognito user pool ID"
  value       = aws_cognito_user_pool.main.id
}

output "cognito_user_pool_arn" {
  description = "Fixyachips Cognito user pool ARN"
  value       = aws_cognito_user_pool.main.arn
}

# ─── SNS ─────────────────────────────────────────────────────────────────────

output "sns_alerts_arn" {
  description = "Fixyachips SNS alerts topic ARN"
  value       = aws_sns_topic.alerts.arn
}

# ─── Bedrock AgentCore ───────────────────────────────────────────────────────

output "bedrock_agent_core_role_arn" {
  description = "Fixyachips AgentCore harness IAM role ARN"
  value       = aws_iam_role.bedrock_agent_core.arn
}

output "bedrock_agent_core_policy_arn" {
  description = "Fixyachips AgentCore harness execution policy ARN"
  value       = aws_iam_policy.bedrock_agent_core_execution.arn
}
