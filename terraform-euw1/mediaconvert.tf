###############################################################
# mediaconvert.tf
# Fixyachips VOD Transcoding Queue
# MediaConvert Queue — ON_DEMAND
# Importing: FixyachipsVODQueue-Fixyachips-App-V1
###############################################################

resource "aws_media_convert_queue" "main" {
  name        = "FixyachipsVODQueue-Fixyachips-App-V1"
  description = "On-Demand MediaConvert queue for VOD HLS transcoding"
  pricing_plan = "ON_DEMAND"
  status      = "ACTIVE"

  lifecycle {
    ignore_changes = [
      pricing_plan
    ]
  }

  tags = {
    Project     = "Fixyachips"
    Environment = "prod"
    ManagedBy   = "Terraform"
  }
}
