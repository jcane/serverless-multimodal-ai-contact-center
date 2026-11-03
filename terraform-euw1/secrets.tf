##############################################################
# secrets.tf
# Fixyachips VOD Platform — Secrets Manager
#
# Secrets:
#   1. platform  — fixyachips (manually created)
#   2. stripe    — Fixyachips/StripeCredentials/prod
#
# CF stack: Fixyachips-App-V1 — DO NOT DESTROY
# WARNING: These blocks manage metadata only
#          Actual secret values are never stored in TF state
##############################################################

##############################################################
# 1. Platform Secret
# Manually created outside CloudFormation
# No KMS — no tags — no description
##############################################################

resource "aws_secretsmanager_secret" "platform" {
  name = "fixyachips"

  tags = {
    Name        = "fixyachips"
    Environment = "prod"
    Project     = "fixyachips"
    ManagedBy   = "terraform"
  }

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

##############################################################
# 2. Stripe Credentials Secret
# CF managed
# KMS encrypted with our CMK
##############################################################

resource "aws_secretsmanager_secret" "stripe" {
  name        = "Fixyachips/StripeCredentials/prod/Fixyachips-App-V1"
  description = "Stripe API keys and Webhook signing secrets"

  kms_key_id = "arn:aws:kms:us-east-1:${var.account_id}:key/7120f964-80ba-492a-9829-16f900354a0f"

  tags = {
    Name               = "Fixyachips/StripeCredentials/prod/Fixyachips-App-V1"
    Environment        = "prod"
    Project            = "Fixyachips"
    DataClassification = "Highly-Confidential"
    RotationRequired   = "true"
    ManagedBy          = "terraform"
  }

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}
