###############################################################
# waf.tf
# Fixyachips WAF Shield - prod
# WAFv2 WebACL — CLOUDFRONT scope
# Importing: de0fe5fb-4dbe-40af-8793-a5e9d4a9f71a
###############################################################

resource "aws_wafv2_web_acl" "main" {
  name        = "WebBodyguard-CUKBiodvYfdj"
  description = "Fixyachips WAF Shield - prod"
  scope       = "CLOUDFRONT"

  default_action {
    allow {}
  }

  ##############################################################
  # Rule 0 — Rate Limit per IP
  ##############################################################
  rule {
    name     = "CDNRateLimitPerIP"
    priority = 0

    statement {
      rate_based_statement {
        limit                 = 2000
        evaluation_window_sec = 300
        aggregate_key_type    = "IP"
      }
    }

    action {
      block {}
    }

    visibility_config {
      sampled_requests_enabled   = true
      cloudwatch_metrics_enabled = true
      metric_name                = "CDNRateLimit"
    }
  }

  ##############################################################
  # Rule 1 — AWS Managed Common Rule Set
  ##############################################################
  rule {
    name     = "AWSManagedRulesCommonRuleSet"
    priority = 1

    statement {
      managed_rule_group_statement {
        vendor_name = "AWS"
        name        = "AWSManagedRulesCommonRuleSet"

        rule_action_override {
          name = "SizeRestrictions_BODY"
          action_to_use {
            allow {}
          }
        }
      }
    }

    override_action {
      none {}
    }

    visibility_config {
      sampled_requests_enabled   = true
      cloudwatch_metrics_enabled = true
      metric_name                = "CommonRules"
    }
  }

  ##############################################################
  # Rule 2 — AWS Managed Bot Control Rule Set
  ##############################################################
  rule {
    name     = "AWSManagedRulesBotControlRuleSet"
    priority = 2

    statement {
      managed_rule_group_statement {
        vendor_name = "AWS"
        name        = "AWSManagedRulesBotControlRuleSet"

        managed_rule_group_configs {
          aws_managed_rules_bot_control_rule_set {
            inspection_level = "COMMON"
          }
        }
      }
    }

    override_action {
      none {}
    }

    visibility_config {
      sampled_requests_enabled   = true
      cloudwatch_metrics_enabled = true
      metric_name                = "BotControl"
    }
  }

  ##############################################################
  # Rule 3 — AWS Managed Known Bad Inputs Rule Set
  ##############################################################
  rule {
    name     = "AWSManagedRulesKnownBadInputsRuleSet"
    priority = 3

    statement {
      managed_rule_group_statement {
        vendor_name = "AWS"
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
      }
    }

    override_action {
      none {}
    }

    visibility_config {
      sampled_requests_enabled   = true
      cloudwatch_metrics_enabled = true
      metric_name                = "KnownBadInputs"
    }
  }

  ##############################################################
  # Rule 4 — AWS Managed SQLi Rule Set
  ##############################################################
  rule {
    name     = "AWSManagedRulesSQLiRuleSet"
    priority = 4

    statement {
      managed_rule_group_statement {
        vendor_name = "AWS"
        name        = "AWSManagedRulesSQLiRuleSet"
      }
    }

    override_action {
      none {}
    }

    visibility_config {
      sampled_requests_enabled   = true
      cloudwatch_metrics_enabled = true
      metric_name                = "SQLiProtection"
    }
  }

  ##############################################################
  # WebACL Visibility Config
  ##############################################################
  visibility_config {
    sampled_requests_enabled   = true
    cloudwatch_metrics_enabled = true
    metric_name                = "FixyachipsWAF-prod"
  }

  lifecycle {
    ignore_changes = [
      rule
    ]
  }

  tags = {
    Project     = "Fixyachips"
    Environment = "prod"
    ManagedBy   = "Terraform"
  }
}
