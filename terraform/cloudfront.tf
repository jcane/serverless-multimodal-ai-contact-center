###############################################################
# cloudfront.tf
# Fixyachips Global Platform - prod
# CloudFront Distribution — OAC SigV4
# Importing: E1BVP04I7B9G57
###############################################################

resource "aws_cloudfront_distribution" "main" {
  comment             = "Fixyachips Global Platform - prod"
  default_root_object = "index.html"
  enabled             = true
  is_ipv6_enabled     = true
  http_version        = "http2and3"
  price_class         = "PriceClass_All"
  wait_for_deployment = false

  aliases = [
    "fixyachips.com",
    "www.fixyachips.com"
  ]

  web_acl_id = "arn:aws:wafv2:us-east-1:${var.account_id}:global/webacl/WebBodyguard-CUKBiodvYfdj/de0fe5fb-4dbe-40af-8793-a5e9d4a9f71a"

  ##############################################################
  # Origin — S3 with OAC SigV4
  ##############################################################
  origin {
    origin_id   = "S3Origin"
    domain_name = "fixyachips-platform-${var.account_id}.s3.us-east-1.amazonaws.com"

    origin_access_control_id = "E3DOZW0DC0H1VW"

    origin_shield {
      enabled              = true
      origin_shield_region = "us-east-1"
    }

    s3_origin_config {
      origin_access_identity = ""
    }

    connection_attempts = 3
    connection_timeout  = 10
  }

  ##############################################################
  # Default Cache Behavior
  ##############################################################
  default_cache_behavior {
    target_origin_id       = "S3Origin"
    viewer_protocol_policy = "redirect-to-https"
    compress               = true

    allowed_methods = ["HEAD", "GET", "OPTIONS"]
    cached_methods  = ["HEAD", "GET"]

    cache_policy_id          = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    origin_request_policy_id = "88a5eaf4-2fd4-4709-b370-b4c650ea3fcf"

    function_association {
      event_type   = "viewer-request"
      function_arn = "arn:aws:cloudfront::${var.account_id}:function/FixRouter-Fixyachips-App-V1"
    }
  }

  ##############################################################
  # Ordered Cache Behavior — videos/*
  ##############################################################
  ordered_cache_behavior {
    path_pattern           = "videos/*"
    target_origin_id       = "S3Origin"
    viewer_protocol_policy = "https-only"
    compress               = true

    allowed_methods = ["HEAD", "GET", "OPTIONS"]
    cached_methods  = ["HEAD", "GET"]

    cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6"
  }

  ##############################################################
  # Custom Error Responses
  ##############################################################
  custom_error_response {
    error_code            = 400
    response_page_path    = "/error/400.html"
    response_code         = 400
    error_caching_min_ttl = 10
  }

  custom_error_response {
    error_code            = 403
    response_page_path    = "/error/403.html"
    response_code         = 403
    error_caching_min_ttl = 30
  }

  custom_error_response {
    error_code            = 404
    response_page_path    = "/error/404.html"
    response_code         = 404
    error_caching_min_ttl = 30
  }

  custom_error_response {
    error_code            = 500
    response_page_path    = "/error/500.html"
    response_code         = 500
    error_caching_min_ttl = 0
  }

  custom_error_response {
    error_code            = 502
    response_page_path    = "/error/500.html"
    response_code         = 502
    error_caching_min_ttl = 0
  }

  custom_error_response {
    error_code            = 503
    response_page_path    = "/error/500.html"
    response_code         = 503
    error_caching_min_ttl = 0
  }

  ##############################################################
  # Logging
  ##############################################################
  logging_config {
    include_cookies = false
    bucket          = "fixyachips-logs-${var.account_id}-prod-v2.s3.amazonaws.com"
    prefix          = "cloudfront/"
  }

  ##############################################################
  # Viewer Certificate — ACM
  ##############################################################
  viewer_certificate {
    acm_certificate_arn      = "arn:aws:acm:us-east-1:${var.account_id}:certificate/f18b7918-a24d-4a36-bfe4-34a114d4ccaf"
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  ##############################################################
  # Geo Restriction — None
  ##############################################################
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  lifecycle {
    ignore_changes = [
      default_cache_behavior,
      ordered_cache_behavior,
      origin
    ]
  }

  tags = {
    Project     = "Fixyachips"
    Environment = "prod"
    ManagedBy   = "Terraform"
  }
}