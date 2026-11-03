##############################################################
# api_gateway.tf
# Fixyachips VOD Platform — API Gateway REST API
#
# Resources:
#   - aws_api_gateway_rest_api.main
#
# API: FixyachipsAPI-Fixyachips-App-V1
# ID:  4mbwbdlril
#
# CF stack: Fixyachips-App-V1 — DO NOT DESTROY
##############################################################

resource "aws_api_gateway_rest_api" "main" {
  name        = "FixyachipsAPI-Fixyachips-App-V1"
  description = "REST API for waitlists and Stripe webhooks"

  api_key_source = "HEADER"

  endpoint_configuration {
    types = ["REGIONAL"]
  }

  disable_execute_api_endpoint = false

  tags = {
    Name        = "FixyachipsAPI-Fixyachips-App-V1"
    Environment = "prod"
    Project     = "fixyachips"
    ManagedBy   = "terraform"
  }

  lifecycle {
    ignore_changes = [
      policy,
    ]
  }
}
