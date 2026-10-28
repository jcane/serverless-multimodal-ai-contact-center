# ============================================================
# EventBridge Rule - VOD Pipeline Trigger
# Routes S3 video uploads to Step Functions VOD pipeline
# ============================================================

resource "aws_cloudwatch_event_rule" "vod_pipeline_trigger" {
  name           = "RouteS3UploadToStepFunctions"
  description    = "Routes video uploads from the source S3 bucket to trigger the VOD Step Functions pipeline."
  event_bus_name = "default"
  state          = "ENABLED"

  event_pattern = jsonencode({
    source        = ["aws.s3"]
    "detail-type" = ["Object Created"]
    detail = {
      bucket = {
        name = ["videoondemandfixyachips-source71e471f1-wlr7kazkufmk"]
      }
      object = {
        key = [
          { prefix = "Instructional/" },
          { prefix = "Marketing/" }
        ]
      }
    }
  })
}

resource "aws_cloudwatch_event_target" "vod_pipeline_target" {
  rule           = aws_cloudwatch_event_rule.vod_pipeline_trigger.name
  event_bus_name = "default"
  target_id      = "e47b9358-dc13-4979-bcb7-e9c22616fc08"
  arn            = "arn:aws:states:us-east-1:980049663300:stateMachine:Fixyachips-VOD-Localization-Multi-Language-Pipeline"
  role_arn       = "arn:aws:iam::980049663300:role/service-role/Amazon_EventBridge_Invoke_StepFunctions_1443270380"

  input_transformer {
    input_paths = {
      bucket = "$.detail.bucket.name"
      key    = "$.detail.object.key"
    }
    input_template = <<-TEMPLATE
      {"jobName": "<key>","videoSourcePath": "s3://<bucket>/<key>","destinationTutorialPath": "s3://videoondemandfixyachips-destination920a3c57-ykrxy0jwcztr/output/"}
    TEMPLATE
  }
}
