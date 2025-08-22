terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.9.0"
    }
  }

  backend "s3" {
    bucket = "my-tf-s3.backend"
    key    = "Dev/terraform.tfstate"
    region = "ap-south-1"
  }

}


provider "aws" {
  region = "ap-south-1"
}
