###############################################################
# stepfunctions.tf
# Fixyachips VOD Localization Pipeline
# State Machine: Fixyachips-VOD-Localization-Multi-Language-Pipeline
###############################################################

resource "aws_sfn_state_machine" "vod_pipeline" {
  name     = "Fixyachips-VOD-Localization-Multi-Language-Pipeline"
  role_arn = "arn:aws:iam::980049663300:role/service-role/StepFunctions-Fixyachips-VOD-Localization-Multi-L-role-vngelb10u"
  type     = "STANDARD"

  definition = file("${path.module}/stepfunctions/vod-localization-pipeline.json")

  logging_configuration {
    level                  = "OFF"
    include_execution_data = false
  }

  tracing_configuration {
    enabled = false
  }

  encryption_configuration {
    type = "AWS_OWNED_KEY"
  }

  tags = {
    Project     = "Fixyachips"
    Environment = "prod"
    ManagedBy   = "Terraform"
  }
}
