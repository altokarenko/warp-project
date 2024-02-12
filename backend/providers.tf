terraform {
  required_version = ">=1.1.0"

}

provider "aws" {
  default_tags {
    tags = {
      Terraform = "True"

    }
  }
  region = var.aws_region #<< Set specify region
}