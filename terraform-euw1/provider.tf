provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "Fixyachips-VOD"
      Environment = var.environment
      ManagedBy   = "Terraform"
      Owner       = "Joshua-Cane"
      Version     = "4.5.1"
    }
  }
}
