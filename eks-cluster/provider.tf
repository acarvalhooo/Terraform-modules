# Configuring provider
terraform {
  required_providers {
    aws = {
      source  = "aws"
      version = ">= 5.49.0"
    }
  }
}