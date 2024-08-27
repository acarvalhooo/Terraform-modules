# Configuring provider
terraform {
  required_version = ">= 1.5"

  required_providers {
    aws = {
      source  = "aws"
      version = ">= 5.49.0"
    }
  }
}