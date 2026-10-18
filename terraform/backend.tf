terraform {
  backend "s3" {
    bucket       = "fixyachips-terraform-state-980049663300"
    key          = "prod/fixyachips-vod/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
    encrypt      = true
  }
}
