


# ============================================================
# s3.tf
# VOD Project — All Managed Buckets
# Audit completed October 20 2026
# ============================================================

# ------------------------------------------------------------
# LIVE WEBSITE
# ------------------------------------------------------------
resource "aws_s3_bucket" "platform" {
  bucket = "fixyachips-platform-${var.account_id}"

  tags = {
    Project     = "fixyachips-vod"
    Environment = "prod"
    Purpose     = "live-website"
  }
}

# ------------------------------------------------------------
# LAMBDA LAYERS
# ------------------------------------------------------------
resource "aws_s3_bucket" "platform_prod" {
  bucket = "fixyachips-platform-${var.account_id}-prod"

  tags = {
    Project     = "fixyachips-vod"
    Environment = "prod"
    Purpose     = "lambda-layers"
  }
}

# ------------------------------------------------------------
# LOGS
# ------------------------------------------------------------
resource "aws_s3_bucket" "logs" {
  bucket = "fixyachips-logs-${var.account_id}-prod-v2"

  tags = {
    Project     = "fixyachips-vod"
    Environment = "prod"
    Purpose     = "logs"
  }
}

# ------------------------------------------------------------
# RAW FOOTAGE ARCHIVE
# ------------------------------------------------------------
resource "aws_s3_bucket" "vault" {
  bucket = "fixyachips-v2-master-vault"

  tags = {
    Project     = "fixyachips-vod"
    Environment = "prod"
    Purpose     = "raw-footage-archive"
  }
}

# ------------------------------------------------------------
# VOD SOURCE INPUT
# ------------------------------------------------------------
resource "aws_s3_bucket" "vod_source" {
  bucket = "videoondemandfixyachips-source71e471f1-wlr7kazkufmk"

  tags = {
    Project     = "fixyachips-vod"
    Environment = "prod"
    Purpose     = "vod-source-input"
  }
}

# ------------------------------------------------------------
# VOD HLS OUTPUT
# ------------------------------------------------------------
resource "aws_s3_bucket" "vod_destination" {
  bucket = "videoondemandfixyachips-destination920a3c57-ykrxy0jwcztr"

  tags = {
    Project     = "fixyachips-vod"
    Environment = "prod"
    Purpose     = "vod-hls-output"
  }
}

# ------------------------------------------------------------
# VOD PIPELINE LOGS
# ------------------------------------------------------------
resource "aws_s3_bucket" "vod_logs" {
  bucket = "videoondemandfixyachips-logs6819bb44-xb8dlny4ktd9"

  tags = {
    Project     = "fixyachips-vod"
    Environment = "prod"
    Purpose     = "vod-pipeline-logs"
  }
}

# ------------------------------------------------------------
# MEDIACONVERT JOB DEFINITIONS
# ------------------------------------------------------------
resource "aws_s3_bucket" "vod_jobs" {
  bucket = "videoondemandfixyachips-manuals"

  tags = {
    Project     = "fixyachips-vod"
    Environment = "prod"
    Purpose     = "mediaconvert-job-definitions"
  }
}

# ------------------------------------------------------------
# TERRAFORM STATE
# NOTE: Managed separately — do not destroy
# ------------------------------------------------------------
resource "aws_s3_bucket" "terraform_state" {
  bucket = "fixyachips-terraform-state-${var.account_id}"

  tags = {
    Project     = "fixyachips-vod"
    Environment = "prod"
    Purpose     = "terraform-state"
  }
}
# ------------------------------------------------------------
# PLATFORM BUCKET — Sub-Resources
# ------------------------------------------------------------
resource "aws_s3_bucket_versioning" "platform" {
  bucket = aws_s3_bucket.platform.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "platform" {
  bucket = aws_s3_bucket.platform.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = true
  }
}

resource "aws_s3_bucket_public_access_block" "platform" {
  bucket = aws_s3_bucket.platform.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# ------------------------------------------------------------
# LOGS BUCKET — Sub-Resources
# ------------------------------------------------------------
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
    bucket_key_enabled = false
  }
}

resource "aws_s3_bucket_public_access_block" "logs" {
  bucket = aws_s3_bucket.logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
