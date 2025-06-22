locals {
  default_tags = {
    MaintainedBy = "Cloud Softway"
    CreatedBy    = "Terraform"
    Environment  = var.environment
    Project      = var.project
  }
}

terraform {
  # backend "s3" {
  # }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.30.0"
    }
  }

  required_version = ">= 1.6"
}