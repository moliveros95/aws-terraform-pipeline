terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.37.0"
    }
  }
  backend "s3" {
    bucket = "260324-test-tfstate"
    key    = "aws-terraform-pipeline/terraform.tfstate"
    region = var.aws_region
  }
}

provider "aws" {
  region = var.aws_region
}