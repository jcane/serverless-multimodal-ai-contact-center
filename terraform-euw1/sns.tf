##############################################################
# sns.tf
# Fixyachips VOD Platform — SNS Topics
#
# Topics:
#   1. alerts — FixyachipsAlerts-Fixyachips-App-V1
#
# CF stack: Fixyachips-App-V1 — DO NOT DESTROY
##############################################################

resource "aws_sns_topic" "alerts" {
  name = "FixyachipsAlerts-Fixyachips-App-V1"

  tags = {
    Name        = "FixyachipsAlerts-Fixyachips-App-V1"
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
