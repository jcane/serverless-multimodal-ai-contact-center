variable "aws_region" {
  description = "Primary AWS deployment region"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "prod"

  validation {
    condition     = contains(["prod", "dev", "staging"], var.environment)
    error_message = "Environment must be prod, dev, or staging."
  }
}

variable "project_name" {
  description = "Project identifier used in resource naming"
  type        = string
  default     = "fixyachips"
}
