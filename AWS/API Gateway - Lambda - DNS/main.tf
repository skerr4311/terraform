terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.17.0"
    }
  }

  backend "s3" {
    region = "ap-southeast-2"
    key    = "terraform/infrastructure.tfstate"
  }
}

provider "aws" {
  region = var.AWS_REGION
  profile                 = "me"
}