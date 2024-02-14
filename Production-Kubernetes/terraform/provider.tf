terraform {
  backend "s3" {
    bucket = "production-kubernetes-fadyio"
    key    = "eks-production.tfstate"
    region = "us-east-1"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.36.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}