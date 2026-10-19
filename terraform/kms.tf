# ============================================
# KMS.TF
# Fixyachips VOD & Monetization Platform
# Customer Managed Keys for encryption
# ============================================

resource "aws_kms_key" "secrets" {
  description             = "CMK for Fixyachips Secrets Manager - prod"
  key_usage               = "ENCRYPT_DECRYPT"
  enable_key_rotation     = true
  deletion_window_in_days = 30
  multi_region            = false

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowRootAccountFullAccess"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${var.account_id}:root"
        }
        Action   = "kms:*"
        Resource = "*"
      }
    ]
  })

  tags = {
    Name        = "fixyachips-secrets-cmk-prod"
    Project     = "Fixyachips"
    Environment = "prod"
    ManagedBy   = "Terraform"
    Owner       = "Joshua-Cane"
  }
}

resource "aws_kms_alias" "secrets" {
  name          = "alias/fixyachips-secrets-prod"
  target_key_id = aws_kms_key.secrets.key_id
}

# ============================================
# OUTPUTS
# ============================================

output "kms_key_id" {
  description = "KMS key ID for Secrets Manager"
  value       = aws_kms_key.secrets.key_id
}

output "kms_key_arn" {
  description = "KMS key ARN for Secrets Manager"
  value       = aws_kms_key.secrets.arn
}

output "kms_alias_arn" {
  description = "KMS alias ARN"
  value       = aws_kms_alias.secrets.arn
}
