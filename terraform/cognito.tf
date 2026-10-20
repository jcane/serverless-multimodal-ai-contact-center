###############################################################
# cognito.tf
# Fixyachips Global Users
# Cognito User Pool — us-east-1_KZdOYrS4l
# Importing: us-east-1_KZdOYrS4l
###############################################################

resource "aws_cognito_user_pool" "main" {
  name                = "Fixyachips_Global_Users-Fixyachips-AI-Global-2026-03-10-v2"
  deletion_protection = "INACTIVE"

  ##############################################################
  # Username — email as username
  ##############################################################
  username_attributes      = ["email"]
  auto_verified_attributes = ["email"]

  ##############################################################
  # Password Policy
  ##############################################################
  password_policy {
    minimum_length                   = 8
    require_uppercase                = true
    require_lowercase                = true
    require_numbers                  = true
    require_symbols                  = true
    temporary_password_validity_days = 7
  }

  ##############################################################
  # MFA — OFF
  ##############################################################
  mfa_configuration = "OFF"

  ##############################################################
  # Email Configuration
  ##############################################################
  email_configuration {
    email_sending_account = "COGNITO_DEFAULT"
  }

  ##############################################################
  # Verification Message
  ##############################################################
  verification_message_template {
    default_email_option = "CONFIRM_WITH_CODE"
  }

  ##############################################################
  # User Attribute Update Settings
  ##############################################################
  user_attribute_update_settings {
    attributes_require_verification_before_update = []
  }

  ##############################################################
  # Admin Create User Config
  ##############################################################
  admin_create_user_config {
    allow_admin_create_user_only = false
  }

  ##############################################################
  # Account Recovery
  ##############################################################
  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
    recovery_mechanism {
      name     = "verified_phone_number"
      priority = 2
    }
  }

  ##############################################################
  # Schema — Required Attributes
  ##############################################################
  schema {
    name                     = "email"
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    required                 = true

    string_attribute_constraints {
      min_length = "0"
      max_length = "2048"
    }
  }

  ##############################################################
  # Schema — Custom Attributes
  ##############################################################
  schema {
    name                     = "veteran_status"
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    required                 = false

    string_attribute_constraints {}
  }

  schema {
    name                     = "industry_segment"
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    required                 = false

    string_attribute_constraints {}
  }

  ##############################################################
  # User Pool Tier
  ##############################################################
  user_pool_tier = "ESSENTIALS"

  lifecycle {
    ignore_changes = [
      schema,
      lambda_config
    ]
  }

  tags = {
    Project     = "Fixyachips"
    Environment = "prod"
    ManagedBy   = "Terraform"
  }
}
