terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.2.0"
   backend "s3" {
    bucket = "clients-tf-states"
    key    = "ruamafreitas.com/terraform.tfstate"
    region = "eu-west-2"
    encrypt        = true
  }
}

# Main provider in London
provider "aws" {
  region = var.region
  alias  = "main"
}

# Provider for ACM Certificate (must be in us-east-1)
provider "aws" {
  alias  = "acm"
  region = "us-east-1"
}
