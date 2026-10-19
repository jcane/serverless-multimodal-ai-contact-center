# ============================================
# S3.TF
# Fixyachips VOD & Monetization Platform
# Platform bucket + Logs bucket
# ============================================

# ─────────────────────────────────────────────
# PLATFORM BUCKET
# Stores all VOD content + platform assets
# ─────────────────────────────────────────────

resource "aws_s3_bucket" "platform" {
  bucket = "fixyachips-platform-980049663300-prod"

  tags = {
    Project            = "Fixyachips"
    Environment        = "prod"
    CostCenter         = "ContentStorage-prod"
    DataClassification = "Confidential"
  }
}

resource "aws_s3_bucket_versioning" "platform" {
  bucket = aws_s3_bucket.platform.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "platform" {
  bucket = aws_s3_bucket.platform.id

  rule {
    bucket_key_enabled = true

    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "platform" {
  bucket = aws_s3_bucket.platform.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}


# ─────────────────────────────────────────────
# LOGS BUCKET
# Stores CloudFront + S3 access logs
# ─────────────────────────────────────────────

resource "aws_s3_bucket" "logs" {
  bucket = "fixyachips-logs-980049663300-prod-v2"

  tags = {
    Project     = "Fixyachips"
    Environment = "prod"
    CostCenter  = "Logging-prod"
  }
}

resource "aws_s3_bucket_versioning" "logs" {
  bucket = aws_s3_bucket.logs.id

  versioning_configuration {
    status = "Suspended"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "logs" {
  bucket = aws_s3_bucket.logs.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "logs" {
  bucket = aws_s3_bucket.logs.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}


# ============================================
# OUTPUTS
# ============================================

output "platform_bucket_name" {
  description = "Platform S3 bucket name"
  value       = aws_s3_bucket.platform.id
}

output "platform_bucket_arn" {
  description = "Platform S3 bucket ARN"
  value       = aws_s3_bucket.platform.arn
}

output "logs_bucket_name" {
  description = "Logs S3 bucket name"
  value       = aws_s3_bucket.logs.id
}

output "logs_bucket_arn" {
  description = "Logs S3 bucket ARN"
  value       = aws_s3_bucket.logs.arn
}
