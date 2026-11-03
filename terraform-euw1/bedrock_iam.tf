###############################################################################
# bedrock_iam.tf — Fixyachips AgentCore IAM Role + Execution Policy
# Imports:
#   aws_iam_role.bedrock_agent_core
#   aws_iam_policy.bedrock_agent_core_execution
#   aws_iam_role_policy_attachment.bedrock_agent_core
###############################################################################

###############################################################################
# IAM Role — AgentCore Harness Service Role
###############################################################################

resource "aws_iam_role" "bedrock_agent_core" {
  name        = "AmazonBedrockAgentCoreHarnessDefaultServiceRole-bwvpa"
  path        = "/service-role/"
  description = "Fixyachips AgentCore harness default service role"

  max_session_duration = 3600

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "bedrock-agentcore.amazonaws.com"
        }
        Action = "sts:AssumeRole"
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = var.account_id
          }
          ArnLike = {
            "aws:SourceArn" = "arn:aws:bedrock-agentcore:${var.aws_region}:${var.account_id}:*"
          }
        }
      }
    ]
  })

  lifecycle {
    ignore_changes = [
      assume_role_policy,
      tags
    ]
  }

  tags = {
    Project     = "Fixyachips"
    Environment = "prod"
    ManagedBy   = "terraform"
    Component   = "bedrock-agentcore"
  }
}

###############################################################################
# IAM Policy — AgentCore Harness Execution Policy
# NOTE: description omitted — IAM policy description is immutable
#       adding description forces destroy + recreate
###############################################################################

resource "aws_iam_policy" "bedrock_agent_core_execution" {
  name = "AmazonBedrockAgentCoreHarnessExecutionPolicy_a739u"
  path = "/service-role/"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "BedrockModelInvocation"
        Effect = "Allow"
        Action = [
          "bedrock:InvokeModel",
          "bedrock:InvokeModelWithResponseStream"
        ]
        Resource = [
          "arn:aws:bedrock:*::foundation-model/*",
          "arn:aws:bedrock:${var.aws_region}:${var.account_id}:*"
        ]
      },
      {
        Sid    = "EcrPublicTokenAccess"
        Effect = "Allow"
        Action = [
          "ecr-public:GetAuthorizationToken"
        ]
        Resource = "*"
      },
      {
        Sid    = "StsForEcrPublicPull"
        Effect = "Allow"
        Action = [
          "sts:GetServiceBearerToken"
        ]
        Resource = "*"
      },
      {
        Sid    = "XRayTracingAccess"
        Effect = "Allow"
        Action = [
          "xray:PutTraceSegments",
          "xray:PutTelemetryRecords",
          "xray:GetSamplingRules",
          "xray:GetSamplingTargets"
        ]
        Resource = "*"
      },
      {
        Sid    = "CloudWatchLogsGroup"
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:DescribeLogStreams"
        ]
        Resource = "arn:aws:logs:${var.aws_region}:${var.account_id}:log-group:/aws/bedrock-agentcore/runtimes/*"
      },
      {
        Sid    = "CloudWatchLogsDescribeGroups"
        Effect = "Allow"
        Action = [
          "logs:DescribeLogGroups"
        ]
        Resource = "arn:aws:logs:${var.aws_region}:${var.account_id}:log-group:*"
      },
      {
        Sid    = "CloudWatchLogsStream"
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:${var.aws_region}:${var.account_id}:log-group:/aws/bedrock-agentcore/runtimes/*:log-stream:*"
      },
      {
        Sid      = "CloudWatchMetricsPublish"
        Effect   = "Allow"
        Action   = "cloudwatch:PutMetricData"
        Resource = "*"
        Condition = {
          StringEquals = {
            "cloudwatch:namespace" = "bedrock-agentcore"
          }
        }
      },
      {
        Sid    = "AgentCoreWorkloadIdentity"
        Effect = "Allow"
        Action = [
          "bedrock-agentcore:GetWorkloadAccessToken",
          "bedrock-agentcore:GetWorkloadAccessTokenForJWT"
        ]
        Resource = [
          "arn:aws:bedrock-agentcore:${var.aws_region}:${var.account_id}:workload-identity-directory/default",
          "arn:aws:bedrock-agentcore:${var.aws_region}:${var.account_id}:workload-identity-directory/default/workload-identity/harness_harness_da9u6-*"
        ]
      },
      {
        Sid    = "AgentCoreBrowserDefault"
        Effect = "Allow"
        Action = [
          "bedrock-agentcore:StartBrowserSession",
          "bedrock-agentcore:StopBrowserSession",
          "bedrock-agentcore:GetBrowserSession",
          "bedrock-agentcore:ListBrowserSessions",
          "bedrock-agentcore:UpdateBrowserStream",
          "bedrock-agentcore:ConnectBrowserAutomationStream",
          "bedrock-agentcore:ConnectBrowserLiveViewStream"
        ]
        Resource = "arn:aws:bedrock-agentcore:${var.aws_region}:aws:browser/*"
      },
      {
        Sid    = "AgentCoreCodeInterpreterDefault"
        Effect = "Allow"
        Action = [
          "bedrock-agentcore:StartCodeInterpreterSession",
          "bedrock-agentcore:StopCodeInterpreterSession",
          "bedrock-agentcore:GetCodeInterpreterSession",
          "bedrock-agentcore:ListCodeInterpreterSessions",
          "bedrock-agentcore:InvokeCodeInterpreter"
        ]
        Resource = "arn:aws:bedrock-agentcore:${var.aws_region}:aws:code-interpreter/*"
      }
    ]
  })

  lifecycle {
    ignore_changes = [
      policy,
      description
    ]
  }

  tags = {
    Project     = "Fixyachips"
    Environment = "prod"
    ManagedBy   = "terraform"
    Component   = "bedrock-agentcore"
  }
}

###############################################################################
# Policy Attachment — bind execution policy to role
###############################################################################

resource "aws_iam_role_policy_attachment" "bedrock_agent_core" {
  role       = aws_iam_role.bedrock_agent_core.name
  policy_arn = aws_iam_policy.bedrock_agent_core_execution.arn
}
