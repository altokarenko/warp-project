provider "aws" {
  default_tags {
    tags = {
      Terrafrom = "True"
    }
  }
  region = var.aws_region
}
terraform {
  required_version = ">=1.1.0"
  backend "s3" {
    bucket         = "opara-terraform-backend"
    key            = "dev/terraform.tfstate"
    region         = "us-west-2"
    encrypt        = true
    dynamodb_table = "opara-terraform-backend"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.5.0"
    }
  }
}
