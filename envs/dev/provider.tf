#Here We declare Provider Block with Version Constraints
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
  required_version = ">= 1.5.0"
}

#provider block for AWS
provider "aws" {
  region = var.region
}
