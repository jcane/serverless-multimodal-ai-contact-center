data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_partition" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
  region     = data.aws_region.current.name
  partition  = data.aws_partition.current.partition

  platform_bucket = "fixyachips-platform-${local.account_id}-prod"
  logs_bucket     = "fixyachips-logs-${local.account_id}-prod-v2"
  state_bucket    = "fixyachips-terraform-state-${local.account_id}"

  common_tags = {
    Project     = "Fixyachips-VOD"
    Environment = var.environment
    ManagedBy   = "Terraform"
    Owner       = "Joshua-Cane"
  }
}
